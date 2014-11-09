Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36880 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKIQu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:29 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so7060968wgg.22
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/16] mac80211: move skb info band assignment out
Date: Sun,  9 Nov 2014 18:50:09 +0200
Message-Id: <1415551822-20121-3-git-send-email-arik@wizery.com> (sfid-20141109_175039_525829_443AEA95)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of passing the band as a parameter to ieee80211_xmit()
and ieee80211_tx(), move it outside of the two functions while
making sure info->band is set up before calling them.

This removes the parameter and simplifies the follow commit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c         |  3 ++-
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/sta_info.c    |  3 ++-
 net/mac80211/tx.c          | 23 +++++++++++------------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0618594..3d1611a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3511,6 +3511,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 		       IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+	info->band = band;
 
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 	skb->priority = 7;
@@ -3518,7 +3519,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		nullfunc->qos_ctrl = cpu_to_le16(7);
 
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb, band);
+	ieee80211_xmit(sdata, skb);
 	local_bh_enable();
 	rcu_read_unlock();
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bc6f12f..00cda1e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1761,8 +1761,7 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		    enum ieee80211_band band);
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index adc2537..9737251 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1249,7 +1249,8 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	ieee80211_xmit(sdata, skb, chanctx_conf->def.chan->band);
+	info->band = chanctx_conf->def.chan->band;
+	ieee80211_xmit(sdata, skb);
 	rcu_read_unlock();
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 66af35f..c4a5494 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1426,8 +1426,7 @@ EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb, bool txpending,
-			 enum ieee80211_band band)
+			 struct sk_buff *skb, bool txpending)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
@@ -1452,8 +1451,6 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 		return true;
 	}
 
-	info->band = band;
-
 	/* set up hw_queue value early */
 	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
 	    !(local->hw.flags & IEEE80211_HW_QUEUE_CONTROL))
@@ -1501,8 +1498,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-		    enum ieee80211_band band)
+void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1537,7 +1533,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-	ieee80211_tx(sdata, skb, false, band);
+	ieee80211_tx(sdata, skb, false);
 }
 
 static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
@@ -1757,7 +1753,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 				     sdata->vif.type))
 		goto fail_rcu;
 
-	ieee80211_xmit(sdata, skb, chandef->chan->band);
+	info->band = chandef->chan->band;
+	ieee80211_xmit(sdata, skb);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
@@ -2220,8 +2217,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	info->flags = info_flags;
 	info->ack_frame_id = info_id;
+	info->band = band;
 
-	ieee80211_xmit(sdata, skb, band);
+	ieee80211_xmit(sdata, skb);
 	rcu_read_unlock();
 
 	return;
@@ -2277,8 +2275,8 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 			dev_kfree_skb(skb);
 			return true;
 		}
-		result = ieee80211_tx(sdata, skb, true,
-				      chanctx_conf->def.chan->band);
+		info->band = chanctx_conf->def.chan->band;
+		result = ieee80211_tx(sdata, skb, true);
 	} else {
 		struct sk_buff_head skbs;
 
@@ -3059,6 +3057,7 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	 * requirements are that we do not come into tx with bhs on.
 	 */
 	local_bh_disable();
-	ieee80211_xmit(sdata, skb, band);
+	IEEE80211_SKB_CB(skb)->band = band;
+	ieee80211_xmit(sdata, skb);
 	local_bh_enable();
 }
-- 
1.9.1

