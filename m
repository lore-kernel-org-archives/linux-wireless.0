Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:39516
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab3CKONx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 10:13:53 -0400
Message-ID: <513DE4BB.9010104@posedge.com> (sfid-20130311_151356_798750_BCB6C046)
Date: Mon, 11 Mar 2013 19:35:47 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Enable sw scan with chan context
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

Enable software scan with channel context in use.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---

  net/mac80211/scan.c |   17 +++++++++++------
  1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 43a45cf..58076ec 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -309,10 +309,6 @@ EXPORT_SYMBOL(ieee80211_scan_completed);

  static int ieee80211_start_sw_scan(struct ieee80211_local *local)
  {
-	/* Software scan is not supported in multi-channel cases */
-	if (local->use_chanctx)
-		return -EOPNOTSUPP;
-
  	/*
  	 * Hardware/driver doesn't support hw_scan, so use software
  	 * scanning instead. First send a nullfunc frame with power save
@@ -387,9 +383,18 @@ static void ieee80211_scan_state_send_probe(struct 
ieee80211_local *local,
  {
  	int i;
  	struct ieee80211_sub_if_data *sdata;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	enum ieee80211_band band;
+	struct ieee80211_channel *scan_chan;
  	u32 tx_flags;

+	if (!local->use_chanctx) {
+		band = local->hw.conf.channel->band;
+		scan_chan = local->hw.conf.channel;
+	} else {
+		band = local->scan_channel->band;
+		scan_chan = local->scan_channel;
+	}
+
  	tx_flags = IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
  	if (local->scan_req->no_cck)
  		tx_flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
@@ -404,7 +409,7 @@ static void ieee80211_scan_state_send_probe(struct 
ieee80211_local *local,
  			local->scan_req->ssids[i].ssid_len,
  			local->scan_req->ie, local->scan_req->ie_len,
  			local->scan_req->rates[band], false,
-			tx_flags, local->hw.conf.channel, true);
+			tx_flags, scan_chan, true);

  	/*
  	 * After sending probe requests, wait for probe responses

