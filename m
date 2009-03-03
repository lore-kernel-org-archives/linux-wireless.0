Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35442 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863AbZCCRZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:10 -0500
Message-Id: <20090303172503.038370112@atheros.com> (sfid-20090303_182514_180011_D928F37A)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:31 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 06/15] ath9k: Virtual wiphy pause/unpause functionality
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow virtual wiphys to be paused/unpaused to allow off-channel
operations. Pause will stop all TX queues for the wiphy and move the
STA into power save mode if in managed mode. Unpause wakes up the TX
queues and notifies the AP that the STA woke up if in managed mode.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |   10 ++
 drivers/net/wireless/ath9k/beacon.c  |    3 
 drivers/net/wireless/ath9k/main.c    |    1 
 drivers/net/wireless/ath9k/rc.h      |    7 +
 drivers/net/wireless/ath9k/virtual.c |  161 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/xmit.c    |   11 +-
 6 files changed, 191 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:09.000000000 +0200
@@ -292,6 +292,7 @@ struct ath_atx_ac {
 struct ath_tx_control {
 	struct ath_txq *txq;
 	int if_id;
+	enum ath9k_internal_frame_type frame_type;
 };
 
 struct ath_xmit_status {
@@ -392,6 +393,7 @@ struct ath_vif {
 	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
 	struct ath_tx_control av_btxctl;
+	u8 bssid[ETH_ALEN]; /* current BSSID from config_interface */
 };
 
 /*******************/
@@ -619,6 +621,11 @@ struct ath_softc {
 struct ath_wiphy {
 	struct ath_softc *sc; /* shared for all virtual wiphys */
 	struct ieee80211_hw *hw;
+	enum ath_wiphy_state {
+		ATH_WIPHY_ACTIVE,
+		ATH_WIPHY_PAUSING,
+		ATH_WIPHY_PAUSED,
+	} state;
 };
 
 int ath_reset(struct ath_softc *sc, bool retry_tx);
@@ -683,5 +690,8 @@ static inline void ath9k_ps_restore(stru
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
 int ath9k_wiphy_add(struct ath_softc *sc);
 int ath9k_wiphy_del(struct ath_wiphy *aphy);
+void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb);
+int ath9k_wiphy_pause(struct ath_wiphy *aphy);
+int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:09.000000000 +0200
@@ -2371,6 +2371,7 @@ static int ath9k_config_interface(struct
 		case NL80211_IFTYPE_ADHOC:
 			/* Set BSSID */
 			memcpy(sc->curbssid, conf->bssid, ETH_ALEN);
+			memcpy(avp->bssid, conf->bssid, ETH_ALEN);
 			sc->curaid = 0;
 			ath9k_hw_write_associd(sc);
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2009-03-03 18:31:09.000000000 +0200
@@ -1514,6 +1514,7 @@ static int ath_tx_setup_buffer(struct ie
 		return -ENOMEM;
 	tx_info->rate_driver_data[0] = tx_info_priv;
 	tx_info_priv->aphy = aphy;
+	tx_info_priv->frame_type = txctl->frame_type;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
 
@@ -1722,11 +1723,14 @@ static void ath_tx_complete(struct ath_s
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 	int hdrlen, padsize;
+	int frame_type = ATH9K_NOT_INTERNAL;
 
 	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
-	if (tx_info_priv)
+	if (tx_info_priv) {
 		hw = tx_info_priv->aphy->hw;
+		frame_type = tx_info_priv->frame_type;
+	}
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
@@ -1757,7 +1761,10 @@ static void ath_tx_complete(struct ath_s
 		skb_pull(skb, padsize);
 	}
 
-	ieee80211_tx_status(hw, skb);
+	if (frame_type == ATH9K_NOT_INTERNAL)
+		ieee80211_tx_status(hw, skb);
+	else
+		ath9k_tx_status(hw, skb);
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
--- wireless-testing.orig/drivers/net/wireless/ath9k/rc.h	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/rc.h	2009-03-03 18:31:09.000000000 +0200
@@ -194,12 +194,19 @@ struct ath_rate_priv {
 	struct ath_rate_softc *asc;
 };
 
+enum ath9k_internal_frame_type {
+	ATH9K_NOT_INTERNAL,
+	ATH9K_INT_PAUSE,
+	ATH9K_INT_UNPAUSE
+};
+
 struct ath_tx_info_priv {
 	struct ath_wiphy *aphy;
 	struct ath_tx_status tx;
 	int n_frames;
 	int n_bad_frames;
 	bool update_rc;
+	enum ath9k_internal_frame_type frame_type;
 };
 
 #define ATH_TX_INFO_PRIV(tx_info) \
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:09.000000000 +0200
@@ -175,3 +175,164 @@ int ath9k_wiphy_del(struct ath_wiphy *ap
 	spin_unlock_bh(&sc->wiphy_lock);
 	return -ENOENT;
 }
+
+static int ath9k_send_nullfunc(struct ath_wiphy *aphy,
+			       struct ieee80211_vif *vif, const u8 *bssid,
+			       int ps)
+{
+	struct ath_softc *sc = aphy->sc;
+	struct ath_tx_control txctl;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+	struct ieee80211_tx_info *info;
+
+	skb = dev_alloc_skb(24);
+	if (skb == NULL)
+		return -ENOMEM;
+	hdr = (struct ieee80211_hdr *) skb_put(skb, 24);
+	memset(hdr, 0, 24);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
+			 IEEE80211_FCTL_TODS);
+	if (ps)
+		fc |= cpu_to_le16(IEEE80211_FCTL_PM);
+	hdr->frame_control = fc;
+	memcpy(hdr->addr1, bssid, ETH_ALEN);
+	memcpy(hdr->addr2, aphy->hw->wiphy->perm_addr, ETH_ALEN);
+	memcpy(hdr->addr3, bssid, ETH_ALEN);
+
+	info = IEEE80211_SKB_CB(skb);
+	memset(info, 0, sizeof(*info));
+	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->control.vif = vif;
+	info->control.rates[0].idx = 0;
+	info->control.rates[0].count = 4;
+	info->control.rates[1].idx = -1;
+
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
+	txctl.txq = &sc->tx.txq[sc->tx.hwq_map[ATH9K_WME_AC_VO]];
+	txctl.frame_type = ps ? ATH9K_INT_PAUSE : ATH9K_INT_UNPAUSE;
+
+	if (ath_tx_start(aphy->hw, skb, &txctl) != 0)
+		goto exit;
+
+	return 0;
+exit:
+	dev_kfree_skb_any(skb);
+	return -1;
+}
+
+/*
+ * ath9k version of ieee80211_tx_status() for TX frames that are generated
+ * internally in the driver.
+ */
+void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+
+	if (tx_info_priv && tx_info_priv->frame_type == ATH9K_INT_PAUSE &&
+	    aphy->state == ATH_WIPHY_PAUSING) {
+		if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
+			printk(KERN_DEBUG "ath9k: %s: no ACK for pause "
+			       "frame\n", wiphy_name(hw->wiphy));
+			/*
+			 * The AP did not reply; ignore this to allow us to
+			 * continue.
+			 */
+		}
+		aphy->state = ATH_WIPHY_PAUSED;
+	}
+
+	kfree(tx_info_priv);
+	tx_info->rate_driver_data[0] = NULL;
+
+	dev_kfree_skb(skb);
+}
+
+static void ath9k_pause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = data;
+	struct ath_vif *avp = (void *) vif->drv_priv;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (!vif->bss_conf.assoc) {
+			aphy->state = ATH_WIPHY_PAUSED;
+			break;
+		}
+		/* TODO: could avoid this if already in PS mode */
+		ath9k_send_nullfunc(aphy, vif, avp->bssid, 1);
+		break;
+	case NL80211_IFTYPE_AP:
+		/* Beacon transmission is paused by aphy->state change */
+		aphy->state = ATH_WIPHY_PAUSED;
+		break;
+	default:
+		break;
+	}
+}
+
+/* caller must hold wiphy_lock */
+static int __ath9k_wiphy_pause(struct ath_wiphy *aphy)
+{
+	ieee80211_stop_queues(aphy->hw);
+	aphy->state = ATH_WIPHY_PAUSING;
+	/*
+	 * TODO: handle PAUSING->PAUSED for the case where there are multiple
+	 * active vifs (now we do it on the first vif getting ready; should be
+	 * on the last)
+	 */
+	ieee80211_iterate_active_interfaces_atomic(aphy->hw, ath9k_pause_iter,
+						   aphy);
+	return 0;
+}
+
+int ath9k_wiphy_pause(struct ath_wiphy *aphy)
+{
+	int ret;
+	spin_lock_bh(&aphy->sc->wiphy_lock);
+	ret = __ath9k_wiphy_pause(aphy);
+	spin_unlock_bh(&aphy->sc->wiphy_lock);
+	return ret;
+}
+
+static void ath9k_unpause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_wiphy *aphy = data;
+	struct ath_vif *avp = (void *) vif->drv_priv;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (!vif->bss_conf.assoc)
+			break;
+		ath9k_send_nullfunc(aphy, vif, avp->bssid, 0);
+		break;
+	case NL80211_IFTYPE_AP:
+		/* Beacon transmission is re-enabled by aphy->state change */
+		break;
+	default:
+		break;
+	}
+}
+
+/* caller must hold wiphy_lock */
+static int __ath9k_wiphy_unpause(struct ath_wiphy *aphy)
+{
+	ieee80211_iterate_active_interfaces_atomic(aphy->hw,
+						   ath9k_unpause_iter, aphy);
+	aphy->state = ATH_WIPHY_ACTIVE;
+	ieee80211_wake_queues(aphy->hw);
+	return 0;
+}
+
+int ath9k_wiphy_unpause(struct ath_wiphy *aphy)
+{
+	int ret;
+	spin_lock_bh(&aphy->sc->wiphy_lock);
+	ret = __ath9k_wiphy_unpause(aphy);
+	spin_unlock_bh(&aphy->sc->wiphy_lock);
+	return ret;
+}
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:30:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2009-03-03 18:31:09.000000000 +0200
@@ -125,6 +125,9 @@ static struct ath_buf *ath_beacon_genera
 	struct ieee80211_tx_info *info;
 	int cabq_depth;
 
+	if (aphy->state != ATH_WIPHY_ACTIVE)
+		return NULL;
+
 	avp = (void *)vif->drv_priv;
 	cabq = sc->beacon.cabq;
 

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
