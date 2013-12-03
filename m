Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab3LCTPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 14:15:33 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 6/6] mac80211: Enable initiating radiation on indoor channels
Date: Tue,  3 Dec 2013 21:16:06 +0200
Message-Id: <1386098166-24196-7-git-send-email-ilan.peer@intel.com> (sfid-20131203_201543_454379_27BE3A6E)
In-Reply-To: <1386098166-24196-1-git-send-email-ilan.peer@intel.com>
References: <1386098166-24196-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow active scanning and frame injection on channels marked with
IEEE80211_CHAN_NO_IR iff the channel is also marked with
IEEE80211_CHAN_INDOOR_ONLY and the wireless core thinks that it
operates in an indoor environment.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/scan.c |    8 +++-----
 net/mac80211/tx.c   |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4d73c46..fd4f58a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -525,8 +525,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		/* We need to ensure power level is at max for scanning. */
 		ieee80211_hw_config(local, 0);
 
-		if ((req->channels[0]->flags &
-		     IEEE80211_CHAN_NO_IR) ||
+		if (!regulatory_ir_allowed(req->channels[0]) ||
 		    !local->scan_req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
@@ -572,7 +571,7 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR)
+	if (!regulatory_ir_allowed(chan))
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
@@ -696,8 +695,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_NO_IR ||
-	    !local->scan_req->n_ssids) {
+	if (!regulatory_ir_allowed(chan) || !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
 		return;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6d59e21..596caa8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1727,7 +1727,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)))
+	if (!regulatory_ir_allowed(chan) || chan->flags & IEEE80211_CHAN_RADAR)
 		goto fail_rcu;
 
 	ieee80211_xmit(sdata, skb, chan->band);
-- 
1.7.10.4

