Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41642 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbbIXOXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:23:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: remove software PS-Poll implementation
Date: Thu, 24 Sep 2015 16:23:07 +0200
Message-Id: <1443104587-26139-1-git-send-email-johannes@sipsolutions.net> (sfid-20150924_162314_417202_B5D87F4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's not all that much value in having a software PS-Poll
implementation, particularly since it's very old and can't
deal with multiple virtual interfaces.

The code still supports a very basic software implementation
of powersave using null-data packets.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  4 ++++
 net/mac80211/ieee80211_i.h |  3 ---
 net/mac80211/mlme.c        | 41 +++++------------------------------------
 net/mac80211/offchannel.c  |  2 --
 net/mac80211/rx.c          | 35 -----------------------------------
 5 files changed, 9 insertions(+), 76 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1b91fcd0aa11..0a790287db16 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2447,6 +2447,10 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
 		return -EOPNOTSUPP;
 
+	/* we no longer support PS-Poll in software, use 10ms timeout */
+	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) && timeout == 0)
+		timeout = 10;
+
 	if (enabled == sdata->u.mgd.powersave &&
 	    timeout == local->dynamic_ps_forced_timeout)
 		return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f9605f13def9..489d279082c5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1295,7 +1295,6 @@ struct ieee80211_local {
 				* multicast packets for power saving stations
 				*/
 
-	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
 	 * PS can only be enabled when we have exactly one managed
@@ -1489,8 +1488,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req);
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req);
-void ieee80211_send_pspoll(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 int ieee80211_max_network_latency(struct notifier_block *nb,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 88047bf6c0e0..13b624fab1e0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -917,23 +917,6 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_pspoll(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_pspoll *pspoll;
-	struct sk_buff *skb;
-
-	skb = ieee80211_pspoll_get(&local->hw, &sdata->vif);
-	if (!skb)
-		return;
-
-	pspoll = (struct ieee80211_pspoll *) skb->data;
-	pspoll->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
-
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
-}
-
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     bool powersave)
@@ -3439,26 +3422,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
 	    ieee80211_check_tim(elems.tim, elems.tim_len, ifmgd->aid)) {
-		if (local->hw.conf.dynamic_ps_timeout > 0) {
-			if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-				ieee80211_hw_config(local,
-						    IEEE80211_CONF_CHANGE_PS);
-			}
-			ieee80211_send_nullfunc(local, sdata, false);
-		} else if (!local->pspolling && sdata->u.mgd.powersave) {
-			local->pspolling = true;
-
-			/*
-			 * Here is assumed that the driver will be
-			 * able to send ps-poll frame and receive a
-			 * response even though power save mode is
-			 * enabled, but some drivers might require
-			 * to disable power save here. This needs
-			 * to be investigated.
-			 */
-			ieee80211_send_pspoll(local, sdata);
+		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+			ieee80211_hw_config(local,
+					    IEEE80211_CONF_CHANGE_PS);
 		}
+		ieee80211_send_nullfunc(local, sdata, false);
 	}
 
 	if (sdata->vif.p2p) {
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 04401037140e..1b2bf93f6a7b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -31,8 +31,6 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	local->offchannel_ps_enabled = false;
 
-	/* FIXME: what to do when local->pspolling is true? */
-
 	del_timer_sync(&local->dynamic_ps_timer);
 	del_timer_sync(&ifmgd->bcn_mon_timer);
 	del_timer_sync(&ifmgd->conn_mon_timer);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5bc0b88d9eb1..3d117f4bbb8c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1183,40 +1183,6 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
-
-static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
-{
-	struct ieee80211_local *local;
-	struct ieee80211_hdr *hdr;
-	struct sk_buff *skb;
-
-	local = rx->local;
-	skb = rx->skb;
-	hdr = (struct ieee80211_hdr *) skb->data;
-
-	if (!local->pspolling)
-		return RX_CONTINUE;
-
-	if (!ieee80211_has_fromds(hdr->frame_control))
-		/* this is not from AP */
-		return RX_CONTINUE;
-
-	if (!ieee80211_is_data(hdr->frame_control))
-		return RX_CONTINUE;
-
-	if (!ieee80211_has_moredata(hdr->frame_control)) {
-		/* AP has no more frames buffered for us */
-		local->pspolling = false;
-		return RX_CONTINUE;
-	}
-
-	/* more data bit is set, let's request a new frame from the AP */
-	ieee80211_send_pspoll(local, rx->sdata);
-
-	return RX_CONTINUE;
-}
-
 static void sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -3170,7 +3136,6 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 		 */
 		rx->skb = skb;
 
-		CALL_RXH(ieee80211_rx_h_check_more_data)
 		CALL_RXH(ieee80211_rx_h_uapsd_and_pspoll)
 		CALL_RXH(ieee80211_rx_h_sta_process)
 		CALL_RXH(ieee80211_rx_h_decrypt)
-- 
2.5.1

