Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42584 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3JURXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:07 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so4330125wid.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:06 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 10/14] mac80211: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:34 +0200
Message-Id: <1382376158-25586-11-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193807_170367_6AF40030)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/mac80211/scan.c | 10 +++++-----
 net/mac80211/tx.c   |  3 +--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5ad66a8..c22cbb5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -526,7 +526,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		ieee80211_hw_config(local, 0);
 
 		if ((req->channels[0]->flags &
-		     IEEE80211_CHAN_PASSIVE_SCAN) ||
+		     IEEE80211_CHAN_NO_IR) ||
 		    !local->scan_req->n_ssids) {
 			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		} else {
@@ -572,7 +572,7 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	 * TODO: channel switching also consumes quite some time,
 	 * add that delay as well to get a better estimation
 	 */
-	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+	if (chan->flags & IEEE80211_CHAN_NO_IR)
 		return IEEE80211_PASSIVE_CHANNEL_TIME;
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
@@ -696,7 +696,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	 *
 	 * In any case, it is not necessary for a passive scan.
 	 */
-	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+	if (chan->flags & IEEE80211_CHAN_NO_IR ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->next_scan_state = SCAN_DECISION;
@@ -881,7 +881,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				struct ieee80211_channel *tmp_ch =
 				    &local->hw.wiphy->bands[band]->channels[i];
 
-				if (tmp_ch->flags & (IEEE80211_CHAN_NO_IBSS |
+				if (tmp_ch->flags & (IEEE80211_CHAN_NO_IR |
 						     IEEE80211_CHAN_DISABLED))
 					continue;
 
@@ -895,7 +895,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->int_scan_req->n_channels = n_ch;
 	} else {
-		if (WARN_ON_ONCE(chan->flags & (IEEE80211_CHAN_NO_IBSS |
+		if (WARN_ON_ONCE(chan->flags & (IEEE80211_CHAN_NO_IR |
 						IEEE80211_CHAN_DISABLED)))
 			goto unlock;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9993fcb..ff1ebbf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1695,8 +1695,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-			    IEEE80211_CHAN_PASSIVE_SCAN)))
+	if ((chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)))
 		goto fail_rcu;
 
 	ieee80211_xmit(sdata, skb, chan->band);
-- 
1.8.4.rc3

