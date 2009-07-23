Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:38343 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZGWKNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:13:34 -0400
Received: by fxm18 with SMTP id 18so715131fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:13:32 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/7] mac80211: refactor the scan code
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Thu, 23 Jul 2009 12:13:41 +0200
Message-ID: <20090723101340.5147.17700.stgit@localhost.localdomain>
In-Reply-To: <20090723100732.5147.73989.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the processing of each scan state into its own functions for better
readability. This patch does not introduce functional changes.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 net/mac80211/scan.c |  136 +++++++++++++++++++++++++++++----------------------
 1 files changed, 78 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7482065..71500f1 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -474,13 +474,87 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	return rc;
 }
 
+static int ieee80211_scan_state_set_channel(struct ieee80211_local *local,
+					    unsigned long *next_delay)
+{
+	int skip;
+	struct ieee80211_channel *chan;
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
+	/* if no more bands/channels left, complete scan */
+	if (local->scan_channel_idx >= local->scan_req->n_channels) {
+		ieee80211_scan_completed(&local->hw, false);
+		return 1;
+	}
+	skip = 0;
+	chan = local->scan_req->channels[local->scan_channel_idx];
+
+	if (chan->flags & IEEE80211_CHAN_DISABLED ||
+	    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+	     chan->flags & IEEE80211_CHAN_NO_IBSS))
+		skip = 1;
+
+	if (!skip) {
+		local->scan_channel = chan;
+		if (ieee80211_hw_config(local,
+					IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
+	}
+
+	/* advance state machine to next channel/band */
+	local->scan_channel_idx++;
+
+	if (skip)
+		return 0;
+
+	/*
+	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
+	 * (which unfortunately doesn't say _why_ step a) is done,
+	 * but it waits for the probe delay or until a frame is
+	 * received - and the received frame would update the NAV).
+	 * For now, we do not support waiting until a frame is
+	 * received.
+	 *
+	 * In any case, it is not necessary for a passive scan.
+	 */
+	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+	    !local->scan_req->n_ssids) {
+		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		return 0;
+	}
+
+	*next_delay = IEEE80211_PROBE_DELAY;
+	local->scan_state = SCAN_SEND_PROBE;
+
+	return 0;
+}
+
+static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
+					    unsigned long *next_delay)
+{
+	int i;
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
+	for (i = 0; i < local->scan_req->n_ssids; i++)
+		ieee80211_send_probe_req(
+			sdata, NULL,
+			local->scan_req->ssids[i].ssid,
+			local->scan_req->ssids[i].ssid_len,
+			local->scan_req->ie, local->scan_req->ie_len);
+
+	/*
+	 * After sending probe requests, wait for probe responses
+	 * on the channel.
+	 */
+	*next_delay = IEEE80211_CHANNEL_TIME;
+	local->scan_state = SCAN_SET_CHANNEL;
+}
+
 void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_channel *chan;
-	int skip, i;
 	unsigned long next_delay = 0;
 
 	mutex_lock(&local->scan_mtx);
@@ -515,65 +589,11 @@ void ieee80211_scan_work(struct work_struct *work)
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
-		/* if no more bands/channels left, complete scan */
-		if (local->scan_channel_idx >= local->scan_req->n_channels) {
-			ieee80211_scan_completed(&local->hw, false);
+		if (ieee80211_scan_state_set_channel(local, &next_delay))
 			return;
-		}
-		skip = 0;
-		chan = local->scan_req->channels[local->scan_channel_idx];
-
-		if (chan->flags & IEEE80211_CHAN_DISABLED ||
-		    (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-		     chan->flags & IEEE80211_CHAN_NO_IBSS))
-			skip = 1;
-
-		if (!skip) {
-			local->scan_channel = chan;
-			if (ieee80211_hw_config(local,
-						IEEE80211_CONF_CHANGE_CHANNEL))
-				skip = 1;
-		}
-
-		/* advance state machine to next channel/band */
-		local->scan_channel_idx++;
-
-		if (skip)
-			break;
-
-		/*
-		 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
-		 * (which unfortunately doesn't say _why_ step a) is done,
-		 * but it waits for the probe delay or until a frame is
-		 * received - and the received frame would update the NAV).
-		 * For now, we do not support waiting until a frame is
-		 * received.
-		 *
-		 * In any case, it is not necessary for a passive scan.
-		 */
-		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
-		    !local->scan_req->n_ssids) {
-			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-			break;
-		}
-
-		next_delay = IEEE80211_PROBE_DELAY;
-		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
-		for (i = 0; i < local->scan_req->n_ssids; i++)
-			ieee80211_send_probe_req(
-				sdata, NULL,
-				local->scan_req->ssids[i].ssid,
-				local->scan_req->ssids[i].ssid_len,
-				local->scan_req->ie, local->scan_req->ie_len);
-
-		/*
-		 * After sending probe requests, wait for probe responses
-		 * on the channel.
-		 */
-		next_delay = IEEE80211_CHANNEL_TIME;
-		local->scan_state = SCAN_SET_CHANNEL;
+		ieee80211_scan_state_send_probe(local, &next_delay);
 		break;
 	}
 

