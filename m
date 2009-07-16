Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:61369 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbZGPJIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:08:00 -0400
Received: by bwz28 with SMTP id 28so1917832bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:07:57 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT 3/5] mac80211: introduce a new scan state "decision"
Date: Thu, 16 Jul 2009 11:08:05 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200907161104.41975.helmut.schaa@gmail.com>
In-Reply-To: <200907161104.41975.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907161108.05473.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new scan state "decision" which is entered after
every completed scan operation and decides about the next steps.
At first the decision is in any case to scan the next channel.
This shouldn't introduce any functional changes.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6a01771..4166418 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -678,7 +678,7 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
+	enum { SCAN_DECISION, SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 60a4e00..ef9d86d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -376,7 +376,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	local->scan_state = SCAN_SET_CHANNEL;
+	local->scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
 	spin_lock_bh(&local->filter_lock);
@@ -474,17 +474,25 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	return rc;
 }
 
-static int ieee80211_scan_state_set_channel(struct ieee80211_local *local, unsigned long *next_delay)
+static int ieee80211_scan_state_decision(struct ieee80211_local *local, unsigned long *next_delay)
 {
-	int skip;
-	struct ieee80211_channel *chan;
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-
 	/* if no more bands/channels left, complete scan */
 	if (local->scan_channel_idx >= local->scan_req->n_channels) {
 		ieee80211_scan_completed(&local->hw, false);
 		return 1;
 	}
+
+	*next_delay = 0;
+	local->scan_state = SCAN_SET_CHANNEL;
+	return 0;
+}
+
+static void ieee80211_scan_state_set_channel(struct ieee80211_local *local, unsigned long *next_delay)
+{
+	int skip;
+	struct ieee80211_channel *chan;
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+
 	skip = 0;
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
@@ -504,7 +512,7 @@ static int ieee80211_scan_state_set_channel(struct ieee80211_local *local, unsig
 	local->scan_channel_idx++;
 
 	if (skip)
-		return 0;
+		return;
 
 	/*
 	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
@@ -519,13 +527,13 @@ static int ieee80211_scan_state_set_channel(struct ieee80211_local *local, unsig
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		return 0;
+		local->scan_state = SCAN_DECISION;
+		return;
 	}
 
+	/* active scan, send probes */
 	*next_delay = IEEE80211_PROBE_DELAY;
 	local->scan_state = SCAN_SEND_PROBE;
-
-	return 0;
 }
 
 static void ieee80211_scan_state_send_probe(struct ieee80211_local *local, unsigned long *next_delay)
@@ -545,7 +553,7 @@ void ieee80211_scan_state_send_probe(struct ieee80211_local *local, unsigned lon
 	 * on the channel.
 	 */
 	*next_delay = IEEE80211_CHANNEL_TIME;
-	local->scan_state = SCAN_SET_CHANNEL;
+	local->scan_state = SCAN_DECISION;
 }
 
 void ieee80211_scan_work(struct work_struct *work)
@@ -591,9 +599,12 @@ void ieee80211_scan_work(struct work_struct *work)
 	 */
 	do {
 		switch (local->scan_state) {
+	 	case SCAN_DECISION:
+	 		if (ieee80211_scan_state_decision(local, &next_delay))
+ 				return;
+ 			break;
 		case SCAN_SET_CHANNEL:
-			if (ieee80211_scan_state_set_channel(local, &next_delay))
-				return;
+			ieee80211_scan_state_set_channel(local, &next_delay);
 			break;
 		case SCAN_SEND_PROBE:
 			ieee80211_scan_state_send_probe(local, &next_delay);
