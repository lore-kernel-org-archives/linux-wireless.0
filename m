Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52120 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdKUNqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 08:46:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use QoS NDP for AP probing
Date: Tue, 21 Nov 2017 14:46:08 +0100
Message-Id: <20171121134608.13043-1-johannes@sipsolutions.net> (sfid-20171121_144712_740109_96DF0F65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When connected to a QoS/WMM AP, mac80211 should use a QoS NDP
for probing it, instead of a regular non-QoS one, fix this.

Change all the drivers to *not* allow QoS NDP for now, even
though it looks like most of them should be OK with that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/st/cw1200/sta.c     |  4 ++--
 drivers/net/wireless/ti/wl1251/main.c    |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c     |  5 +++--
 include/net/mac80211.h                   |  8 +++++++-
 net/mac80211/mlme.c                      |  2 +-
 net/mac80211/tx.c                        | 29 +++++++++++++++++++++++++++--
 7 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index f0439f2d566b..173891b11b2d 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1112,7 +1112,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 		if (!avp->assoc)
 			return false;
 
-		skb = ieee80211_nullfunc_get(sc->hw, vif);
+		skb = ieee80211_nullfunc_get(sc->hw, vif, false);
 		if (!skb)
 			return false;
 
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index a52224836a2b..666b88cb2cfe 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -198,7 +198,7 @@ void __cw1200_cqm_bssloss_sm(struct cw1200_common *priv,
 
 		priv->bss_loss_state++;
 
-		skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
+		skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
 		WARN_ON(!skb);
 		if (skb)
 			cw1200_tx(priv->hw, NULL, skb);
@@ -2266,7 +2266,7 @@ static int cw1200_upload_null(struct cw1200_common *priv)
 		.rate = 0xFF,
 	};
 
-	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
+	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
 	if (!frame.skb)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 9915d83a4a30..6d02c660b4ab 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -566,7 +566,7 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 		size = sizeof(struct wl12xx_null_data_template);
 		ptr = NULL;
 	} else {
-		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
+		skb = ieee80211_nullfunc_get(wl->hw, wl->vif, false);
 		if (!skb)
 			goto out;
 		size = skb->len;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 2bfc12fdc929..761cf8573a80 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1069,7 +1069,8 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ptr = NULL;
 	} else {
 		skb = ieee80211_nullfunc_get(wl->hw,
-					     wl12xx_wlvif_to_vif(wlvif));
+					     wl12xx_wlvif_to_vif(wlvif),
+					     false);
 		if (!skb)
 			goto out;
 		size = skb->len;
@@ -1096,7 +1097,7 @@ int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 	struct sk_buff *skb = NULL;
 	int ret = -ENOMEM;
 
-	skb = ieee80211_nullfunc_get(wl->hw, vif);
+	skb = ieee80211_nullfunc_get(wl->hw, vif, false);
 	if (!skb)
 		goto out;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ed73f79fe6ad..2ee4af25256d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4474,18 +4474,24 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
  * ieee80211_nullfunc_get - retrieve a nullfunc template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @qos_ok: QoS NDP is acceptable to the caller, this should be set
+ *	if at all possible
  *
  * Creates a Nullfunc template which can, for example, uploaded to
  * hardware. The template must be updated after association so that correct
  * BSSID and address is used.
  *
+ * If @qos_ndp is set and the association is to an AP with QoS/WMM, the
+ * returned packet will be QoS NDP.
+ *
  * Note: Caller (or hardware) is responsible for setting the
  * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
  *
  * Return: The nullfunc template. %NULL on error.
  */
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif);
+				       struct ieee80211_vif *vif,
+				       bool qos_ok);
 
 /**
  * ieee80211_probereq_get - retrieve a Probe Request template
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4c80e7896fa2..fa0f96c74898 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -896,7 +896,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
+	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif, true);
 	if (!skb)
 		return;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7b8154474b9e..3160954fc406 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4438,13 +4438,15 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(ieee80211_pspoll_get);
 
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif)
+				       struct ieee80211_vif *vif,
+				       bool qos_ok)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
 	struct ieee80211_local *local;
 	struct sk_buff *skb;
+	bool qos = false;
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
 		return NULL;
@@ -4453,7 +4455,17 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	ifmgd = &sdata->u.mgd;
 	local = sdata->local;
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*nullfunc));
+	if (qos_ok) {
+		struct sta_info *sta;
+
+		rcu_read_lock();
+		sta = sta_info_get(sdata, ifmgd->bssid);
+		qos = sta && sta->sta.wme;
+		rcu_read_unlock();
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(*nullfunc) + 2);
 	if (!skb)
 		return NULL;
 
@@ -4463,6 +4475,19 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	nullfunc->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 					      IEEE80211_STYPE_NULLFUNC |
 					      IEEE80211_FCTL_TODS);
+	if (qos) {
+		__le16 qos = cpu_to_le16(7);
+
+		BUILD_BUG_ON((IEEE80211_STYPE_QOS_NULLFUNC |
+			      IEEE80211_STYPE_NULLFUNC) !=
+			     IEEE80211_STYPE_QOS_NULLFUNC);
+		nullfunc->frame_control |=
+			cpu_to_le16(IEEE80211_STYPE_QOS_NULLFUNC);
+		skb->priority = 7;
+		skb_set_queue_mapping(skb, IEEE80211_AC_VO);
+		skb_put_data(skb, &qos, sizeof(qos));
+	}
+
 	memcpy(nullfunc->addr1, ifmgd->bssid, ETH_ALEN);
 	memcpy(nullfunc->addr2, vif->addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, ifmgd->bssid, ETH_ALEN);
-- 
2.14.2
