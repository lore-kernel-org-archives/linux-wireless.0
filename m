Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61479 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab1ALNCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:02:17 -0500
Received: by pzk35 with SMTP id 35so87197pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 05:02:17 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19757.42544.304328.698003@gargle.gargle.HOWL>
Date: Wed, 12 Jan 2011 18:31:36 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: track receivers aggregation reorder buffer size
In-Reply-To: <20110112121417.852157387@sipsolutions.net>
References: <20110112121322.702618109@sipsolutions.net>
	<20110112121417.852157387@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The aggregation code currently doesn't implement the
> buffer size negotiation. It will always request a max
> buffer size (which is fine, if a little pointless, as
> the mac80211 code doesn't know and might just use 0
> instead), but if the peer requests a smaller size it
> isn't possible to honour this request.
> 
> In order to fix this, look at the buffer size in the
> addBA response frame, keep track of it and pass it to
> the driver in the ampdu_action callback when called
> with the IEEE80211_AMPDU_TX_OPERATIONAL action. That
> way the driver can limit the number of subframes in
> aggregates appropriately.
> 
> Note that this doesn't fix any drivers apart from the
> addition of the new argument -- they all need to be
> updated separately to use this variable!

At least for ath9k_htc, the fix is pretty simple, something like the patch below.
I tested this with a peer advertising a non-default subframe count
(using max_tx_aggregation_subframes) and it seems to work. Now all that is needed
is to fix the FW to actually _use_ this value. :)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1ce506f..94a4b14 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -210,6 +210,7 @@ struct ath9k_htc_vif {
 
 #define ATH9K_HTC_MAX_STA 8
 #define ATH9K_HTC_MAX_TID 8
+#define ATH9K_HTC_MAX_SUBFRAME 20
 
 enum tid_aggr_state {
 	AGGR_STOP = 0,
@@ -433,7 +434,7 @@ void ath9k_htc_txep(void *priv, struct sk_buff *skb, enum htc_endpoint_id ep_id,
 void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 			enum htc_endpoint_id ep_id, bool txok);
 
-int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv);
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv, u8 buf_size);
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
 void ath9k_ani_work(struct work_struct *work);;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f4d576b..3a3f982 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -304,7 +304,7 @@ static int ath9k_htc_add_monitor_interface(struct ath9k_htc_priv *priv)
 	/*
 	 * Set chainmask etc. on the target.
 	 */
-	ret = ath9k_htc_update_cap_target(priv);
+	ret = ath9k_htc_update_cap_target(priv, ATH9K_HTC_MAX_SUBFRAME);
 	if (ret)
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Failed to update capability in target\n");
@@ -430,7 +430,7 @@ static int ath9k_htc_remove_station(struct ath9k_htc_priv *priv,
 	return 0;
 }
 
-int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
+int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv, u8 buf_size)
 {
 	struct ath9k_htc_cap_target tcap;
 	int ret;
@@ -442,7 +442,7 @@ int ath9k_htc_update_cap_target(struct ath9k_htc_priv *priv)
 	tcap.flags = 0x240c40;
 	tcap.flags_ext = 0x80601000;
 	tcap.ampdu_limit = 0xffff0000;
-	tcap.ampdu_subframes = 20;
+	tcap.ampdu_subframes = min((u8)ATH9K_HTC_MAX_SUBFRAME, buf_size);
 	tcap.tx_chainmask_legacy = priv->ah->caps.tx_chainmask;
 	tcap.protmode = 1;
 	tcap.tx_chainmask = priv->ah->caps.tx_chainmask;
@@ -1130,7 +1130,7 @@ static int ath9k_htc_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = ath9k_htc_update_cap_target(priv);
+	ret = ath9k_htc_update_cap_target(priv, ATH9K_HTC_MAX_SUBFRAME);
 	if (ret)
 		ath_dbg(common, ATH_DBG_CONFIG,
 			"Failed to update capability in target\n");
@@ -1548,7 +1548,7 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  enum ieee80211_ampdu_mlme_action action,
 				  struct ieee80211_sta *sta,
-				  u16 tid, u16 *ssn)
+				  u16 tid, u16 *ssn, u8 buf_size)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath9k_htc_sta *ista;
@@ -1570,6 +1570,12 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
+		if (buf_size < ATH9K_HTC_MAX_SUBFRAME) {
+			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_CONFIG,
+				"Choosing subframe count %d for station %pM\n",
+				buf_size, sta->addr);
+			ath9k_htc_update_cap_target(priv, buf_size);
+		}
 		spin_lock_bh(&priv->tx_lock);
 		ista->tid_state[tid] = AGGR_OPERATIONAL;
 		spin_unlock_bh(&priv->tx_lock);
