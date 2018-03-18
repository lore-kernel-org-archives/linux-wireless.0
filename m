Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skyhawk.myhost.co.nz ([120.138.17.237]:58578 "EHLO
        skyhawk.myhost.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754230AbeCRX6G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 19:58:06 -0400
From: Ben Caradoc-Davies <ben@transient.nz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Ben Caradoc-Davies <ben@transient.nz>
Subject: [PATCH] mac80211: add ieee80211_hw flag for QoS NDP support
Date: Mon, 19 Mar 2018 12:57:44 +1300
Message-Id: <20180318235744.3527-1-ben@transient.nz> (sfid-20180319_005810_500268_5A2703C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing") adds an
argument qos_ok to ieee80211_nullfunc_get to support QoS NDP. Despite
the claim in the commit log "Change all the drivers to *not* allow
QoS NDP for now, even though it looks like most of them should be OK
with that", this commit enables QoS NDP in response to beacons (see
change to mlme.c:ieee80211_send_nullfunc), causing ath9k_htc to lose
IP connectivity. See:
https://patchwork.kernel.org/patch/10241109/
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060

This patch replaces the argument qos_ok of ieee80211_nullfunc_get
with an ieee80211_hw flag that drivers can use to declare support for
QoS NDP, allowing consistent behaviour between mlme.c and drivers.

Signed-off-by: Ben Caradoc-Davies <ben@transient.nz>
---
 drivers/net/wireless/ath/ath9k/channel.c |  2 +-
 drivers/net/wireless/st/cw1200/sta.c     |  4 ++--
 drivers/net/wireless/ti/wl1251/main.c    |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c     |  5 ++---
 include/net/mac80211.h                   | 12 +++++-------
 net/mac80211/debugfs.c                   |  1 +
 net/mac80211/mlme.c                      |  2 +-
 net/mac80211/tx.c                        |  5 ++---
 8 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1b05b5d7a038..dfb26f03c1a2 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1113,7 +1113,7 @@ ath_chanctx_send_vif_ps_frame(struct ath_softc *sc, struct ath_vif *avp,
 		if (!avp->assoc)
 			return false;
 
-		skb = ieee80211_nullfunc_get(sc->hw, vif, false);
+		skb = ieee80211_nullfunc_get(sc->hw, vif);
 		if (!skb)
 			return false;
 
diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9a0562..03687a80d6e9 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -198,7 +198,7 @@ void __cw1200_cqm_bssloss_sm(struct cw1200_common *priv,
 
 		priv->bss_loss_state++;
 
-		skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
+		skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
 		WARN_ON(!skb);
 		if (skb)
 			cw1200_tx(priv->hw, NULL, skb);
@@ -2265,7 +2265,7 @@ static int cw1200_upload_null(struct cw1200_common *priv)
 		.rate = 0xFF,
 	};
 
-	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif, false);
+	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
 	if (!frame.skb)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 037defd10b91..99a6889a6540 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -566,7 +566,7 @@ static int wl1251_build_null_data(struct wl1251 *wl)
 		size = sizeof(struct wl12xx_null_data_template);
 		ptr = NULL;
 	} else {
-		skb = ieee80211_nullfunc_get(wl->hw, wl->vif, false);
+		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
 		if (!skb)
 			goto out;
 		size = skb->len;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 761cf8573a80..2bfc12fdc929 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1069,8 +1069,7 @@ int wl12xx_cmd_build_null_data(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		ptr = NULL;
 	} else {
 		skb = ieee80211_nullfunc_get(wl->hw,
-					     wl12xx_wlvif_to_vif(wlvif),
-					     false);
+					     wl12xx_wlvif_to_vif(wlvif));
 		if (!skb)
 			goto out;
 		size = skb->len;
@@ -1097,7 +1096,7 @@ int wl12xx_cmd_build_klv_null_data(struct wl1271 *wl,
 	struct sk_buff *skb = NULL;
 	int ret = -ENOMEM;
 
-	skb = ieee80211_nullfunc_get(wl->hw, vif, false);
+	skb = ieee80211_nullfunc_get(wl->hw, vif);
 	if (!skb)
 		goto out;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c96511fa9198..985f32c76ba9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2063,6 +2063,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA: Hardware supports buffer STA on
  *	TDLS links.
  *
+ * @IEEE80211_HW_SUPPORTS_QOS_NDP: The driver (or firmware) supports QoS NDP
+ *	for AP probing.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2106,6 +2109,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
 	IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
+	IEEE80211_HW_SUPPORTS_QOS_NDP,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -4478,24 +4482,18 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
  * ieee80211_nullfunc_get - retrieve a nullfunc template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
- * @qos_ok: QoS NDP is acceptable to the caller, this should be set
- *	if at all possible
  *
  * Creates a Nullfunc template which can, for example, uploaded to
  * hardware. The template must be updated after association so that correct
  * BSSID and address is used.
  *
- * If @qos_ndp is set and the association is to an AP with QoS/WMM, the
- * returned packet will be QoS NDP.
- *
  * Note: Caller (or hardware) is responsible for setting the
  * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
  *
  * Return: The nullfunc template. %NULL on error.
  */
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       bool qos_ok);
+				       struct ieee80211_vif *vif);
 
 /**
  * ieee80211_probereq_get - retrieve a Probe Request template
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 1f466d12a6bc..8718d7e9ad9d 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -212,6 +212,7 @@ static const char *hw_flag_names[] = {
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
 	FLAG(SUPPORTS_TDLS_BUFFER_STA),
+	FLAG(SUPPORTS_QOS_NDP),
 #undef FLAG
 };
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..cc55ff8ae979 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -896,7 +896,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif, true);
+	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
 		return;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 69722504e3e1..885285dd247b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4448,8 +4448,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(ieee80211_pspoll_get);
 
 struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       bool qos_ok)
+				       struct ieee80211_vif *vif)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_sub_if_data *sdata;
@@ -4465,7 +4464,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	ifmgd = &sdata->u.mgd;
 	local = sdata->local;
 
-	if (qos_ok) {
+	if (ieee80211_hw_check(hw, SUPPORTS_QOS_NDP)) {
 		struct sta_info *sta;
 
 		rcu_read_lock();
-- 
Ben Caradoc-Davies <ben@transient.nz>
Director
Transient Software Limited <https://transient.nz/>
New Zealand
