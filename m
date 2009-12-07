Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbZLGLEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 06:04:07 -0500
Subject: [PATCH] mac80211: remove struct ieee80211_if_init_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 10:22:54 +0100
Message-ID: <1260177774.13866.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All its members (vif, mac_addr, type) are now available
in the vif struct directly, so we can pass that instead
of the conf struct. I generated this patch (except the
mac80211 and header file changes) with this semantic
patch:

@@
identifier conf, fn, hw;
type tp;
@@
tp fn(struct ieee80211_hw *hw,
-struct ieee80211_if_init_conf *conf)
+struct ieee80211_vif *vif)
{
<...
(
-conf->type
+vif->type
|
-conf->mac_addr
+vif->addr
|
-conf->vif
+vif
)
...>
}

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c             |   12 +++---
 drivers/net/wireless/at76c50x-usb.c        |    6 +--
 drivers/net/wireless/ath/ar9170/main.c     |    8 ++--
 drivers/net/wireless/ath/ath5k/base.c      |   18 ++++-----
 drivers/net/wireless/ath/ath9k/main.c      |   28 +++++++-------
 drivers/net/wireless/b43/main.c            |   26 ++++++-------
 drivers/net/wireless/b43legacy/main.c      |   24 ++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c    |   20 +++++-----
 drivers/net/wireless/iwlwifi/iwl-core.h    |    4 +-
 drivers/net/wireless/libertas_tf/main.c    |   10 ++---
 drivers/net/wireless/mac80211_hwsim.c      |   18 ++++-----
 drivers/net/wireless/mwl8k.c               |   14 +++----
 drivers/net/wireless/p54/main.c            |   12 +++---
 drivers/net/wireless/rt2x00/rt2x00.h       |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   26 ++++++-------
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   14 +++----
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   12 +++---
 drivers/net/wireless/wl12xx/wl1251_main.c  |   14 +++----
 drivers/net/wireless/wl12xx/wl1271_main.c  |   10 ++---
 drivers/net/wireless/zd1211rw/zd_mac.c     |   10 ++---
 include/net/mac80211.h                     |   57 +++++++----------------------
 net/mac80211/driver-ops.h                  |   12 +++---
 net/mac80211/iface.c                       |   14 +------
 net/mac80211/pm.c                          |    6 ---
 net/mac80211/util.c                        |    9 +---
 25 files changed, 172 insertions(+), 216 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/adm8211.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/adm8211.c	2009-12-07 10:12:18.000000000 +0100
@@ -1400,15 +1400,15 @@ static void adm8211_configure_filter(str
 }
 
 static int adm8211_add_interface(struct ieee80211_hw *dev,
-				 struct ieee80211_if_init_conf *conf)
+				 struct ieee80211_vif *vif)
 {
 	struct adm8211_priv *priv = dev->priv;
 	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		priv->mode = conf->type;
+		priv->mode = vif->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1416,8 +1416,8 @@ static int adm8211_add_interface(struct 
 
 	ADM8211_IDLE();
 
-	ADM8211_CSR_WRITE(PAR0, le32_to_cpu(*(__le32 *)conf->mac_addr));
-	ADM8211_CSR_WRITE(PAR1, le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+	ADM8211_CSR_WRITE(PAR0, le32_to_cpu(*(__le32 *)vif->addr));
+	ADM8211_CSR_WRITE(PAR1, le16_to_cpu(*(__le16 *)(vif->addr + 4)));
 
 	adm8211_update_mode(dev);
 
@@ -1427,7 +1427,7 @@ static int adm8211_add_interface(struct 
 }
 
 static void adm8211_remove_interface(struct ieee80211_hw *dev,
-				     struct ieee80211_if_init_conf *conf)
+				     struct ieee80211_vif *vif)
 {
 	struct adm8211_priv *priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_MONITOR;
--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2009-12-07 10:12:18.000000000 +0100
@@ -1789,7 +1789,7 @@ static void at76_mac80211_stop(struct ie
 }
 
 static int at76_add_interface(struct ieee80211_hw *hw,
-			      struct ieee80211_if_init_conf *conf)
+			      struct ieee80211_vif *vif)
 {
 	struct at76_priv *priv = hw->priv;
 	int ret = 0;
@@ -1798,7 +1798,7 @@ static int at76_add_interface(struct iee
 
 	mutex_lock(&priv->mtx);
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		priv->iw_mode = IW_MODE_INFRA;
 		break;
@@ -1814,7 +1814,7 @@ exit:
 }
 
 static void at76_remove_interface(struct ieee80211_hw *hw,
-				  struct ieee80211_if_init_conf *conf)
+				  struct ieee80211_vif *vif)
 {
 	at76_dbg(DBG_MAC80211, "%s()", __func__);
 }
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -1950,7 +1950,7 @@ err_free:
 }
 
 static int ar9170_op_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+				   struct ieee80211_vif *vif)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ath_common *common = &ar->common;
@@ -1963,8 +1963,8 @@ static int ar9170_op_add_interface(struc
 		goto unlock;
 	}
 
-	ar->vif = conf->vif;
-	memcpy(common->macaddr, conf->mac_addr, ETH_ALEN);
+	ar->vif = vif;
+	memcpy(common->macaddr, vif->addr, ETH_ALEN);
 
 	if (modparam_nohwcrypt || (ar->vif->type != NL80211_IFTYPE_STATION)) {
 		ar->rx_software_decryption = true;
@@ -1984,7 +1984,7 @@ unlock:
 }
 
 static void ar9170_op_remove_interface(struct ieee80211_hw *hw,
-				       struct ieee80211_if_init_conf *conf)
+				       struct ieee80211_vif *vif)
 {
 	struct ar9170 *ar = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-12-07 10:12:18.000000000 +0100
@@ -225,9 +225,9 @@ static int ath5k_reset_wake(struct ath5k
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
-		struct ieee80211_if_init_conf *conf);
+		struct ieee80211_vif *vif);
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
-		struct ieee80211_if_init_conf *conf);
+		struct ieee80211_vif *vif);
 static int ath5k_config(struct ieee80211_hw *hw, u32 changed);
 static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
 				   int mc_count, struct dev_addr_list *mc_list);
@@ -2774,7 +2774,7 @@ static void ath5k_stop(struct ieee80211_
 }
 
 static int ath5k_add_interface(struct ieee80211_hw *hw,
-		struct ieee80211_if_init_conf *conf)
+		struct ieee80211_vif *vif)
 {
 	struct ath5k_softc *sc = hw->priv;
 	int ret;
@@ -2785,22 +2785,22 @@ static int ath5k_add_interface(struct ie
 		goto end;
 	}
 
-	sc->vif = conf->vif;
+	sc->vif = vif;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
-		sc->opmode = conf->type;
+		sc->opmode = vif->type;
 		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto end;
 	}
 
-	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
+	ath5k_hw_set_lladdr(sc->ah, vif->addr);
 	ath5k_mode_setup(sc);
 
 	ret = 0;
@@ -2811,13 +2811,13 @@ end:
 
 static void
 ath5k_remove_interface(struct ieee80211_hw *hw,
-			struct ieee80211_if_init_conf *conf)
+			struct ieee80211_vif *vif)
 {
 	struct ath5k_softc *sc = hw->priv;
 	u8 mac[ETH_ALEN] = {};
 
 	mutex_lock(&sc->lock);
-	if (sc->vif != conf->vif)
+	if (sc->vif != vif)
 		goto end;
 
 	ath5k_hw_set_lladdr(sc->ah, mac);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -2532,12 +2532,12 @@ static void ath9k_stop(struct ieee80211_
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
-			       struct ieee80211_if_init_conf *conf)
+			       struct ieee80211_vif *vif)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (void *)conf->vif->drv_priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	enum nl80211_iftype ic_opmode = NL80211_IFTYPE_UNSPECIFIED;
 	int ret = 0;
 
@@ -2549,7 +2549,7 @@ static int ath9k_add_interface(struct ie
 		goto out;
 	}
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
 		break;
@@ -2560,11 +2560,11 @@ static int ath9k_add_interface(struct ie
 			ret = -ENOBUFS;
 			goto out;
 		}
-		ic_opmode = conf->type;
+		ic_opmode = vif->type;
 		break;
 	default:
 		ath_print(common, ATH_DBG_FATAL,
-			"Interface type %d not yet supported\n", conf->type);
+			"Interface type %d not yet supported\n", vif->type);
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -2596,18 +2596,18 @@ static int ath9k_add_interface(struct ie
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
-	if ((conf->type == NL80211_IFTYPE_STATION) ||
-	    (conf->type == NL80211_IFTYPE_ADHOC) ||
-	    (conf->type == NL80211_IFTYPE_MESH_POINT)) {
+	if ((vif->type == NL80211_IFTYPE_STATION) ||
+	    (vif->type == NL80211_IFTYPE_ADHOC) ||
+	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		sc->imask |= ATH9K_INT_MIB;
 		sc->imask |= ATH9K_INT_TSFOOR;
 	}
 
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (conf->type == NL80211_IFTYPE_AP    ||
-	    conf->type == NL80211_IFTYPE_ADHOC ||
-	    conf->type == NL80211_IFTYPE_MONITOR)
+	if (vif->type == NL80211_IFTYPE_AP    ||
+	    vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_MONITOR)
 		ath_start_ani(common);
 
 out:
@@ -2616,12 +2616,12 @@ out:
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+				   struct ieee80211_vif *vif)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp = (void *)conf->vif->drv_priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	int i;
 
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
@@ -2642,7 +2642,7 @@ static void ath9k_remove_interface(struc
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {
-		if (sc->beacon.bslot[i] == conf->vif) {
+		if (sc->beacon.bslot[i] == vif) {
 			printk(KERN_DEBUG "%s: vif had allocated beacon "
 			       "slot\n", __func__);
 			sc->beacon.bslot[i] = NULL;
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -4385,7 +4385,7 @@ err_busdown:
 }
 
 static int b43_op_add_interface(struct ieee80211_hw *hw,
-				struct ieee80211_if_init_conf *conf)
+				struct ieee80211_vif *vif)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -4393,24 +4393,24 @@ static int b43_op_add_interface(struct i
 
 	/* TODO: allow WDS/AP devices to coexist */
 
-	if (conf->type != NL80211_IFTYPE_AP &&
-	    conf->type != NL80211_IFTYPE_MESH_POINT &&
-	    conf->type != NL80211_IFTYPE_STATION &&
-	    conf->type != NL80211_IFTYPE_WDS &&
-	    conf->type != NL80211_IFTYPE_ADHOC)
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_MESH_POINT &&
+	    vif->type != NL80211_IFTYPE_STATION &&
+	    vif->type != NL80211_IFTYPE_WDS &&
+	    vif->type != NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
 	if (wl->operating)
 		goto out_mutex_unlock;
 
-	b43dbg(wl, "Adding Interface type %d\n", conf->type);
+	b43dbg(wl, "Adding Interface type %d\n", vif->type);
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->vif = conf->vif;
-	wl->if_type = conf->type;
-	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+	wl->vif = vif;
+	wl->if_type = vif->type;
+	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
 	b43_adjust_opmode(dev);
 	b43_set_pretbtt(dev);
@@ -4425,17 +4425,17 @@ static int b43_op_add_interface(struct i
 }
 
 static void b43_op_remove_interface(struct ieee80211_hw *hw,
-				    struct ieee80211_if_init_conf *conf)
+				    struct ieee80211_vif *vif)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
-	b43dbg(wl, "Removing Interface type %d\n", conf->type);
+	b43dbg(wl, "Removing Interface type %d\n", vif->type);
 
 	mutex_lock(&wl->mutex);
 
 	B43_WARN_ON(!wl->operating);
-	B43_WARN_ON(wl->vif != conf->vif);
+	B43_WARN_ON(wl->vif != vif);
 	wl->vif = NULL;
 
 	wl->operating = 0;
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -3361,7 +3361,7 @@ err_kfree_lo_control:
 }
 
 static int b43legacy_op_add_interface(struct ieee80211_hw *hw,
-				      struct ieee80211_if_init_conf *conf)
+				      struct ieee80211_vif *vif)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev;
@@ -3370,23 +3370,23 @@ static int b43legacy_op_add_interface(st
 
 	/* TODO: allow WDS/AP devices to coexist */
 
-	if (conf->type != NL80211_IFTYPE_AP &&
-	    conf->type != NL80211_IFTYPE_STATION &&
-	    conf->type != NL80211_IFTYPE_WDS &&
-	    conf->type != NL80211_IFTYPE_ADHOC)
+	if (vif->type != NL80211_IFTYPE_AP &&
+	    vif->type != NL80211_IFTYPE_STATION &&
+	    vif->type != NL80211_IFTYPE_WDS &&
+	    vif->type != NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
 	if (wl->operating)
 		goto out_mutex_unlock;
 
-	b43legacydbg(wl, "Adding Interface type %d\n", conf->type);
+	b43legacydbg(wl, "Adding Interface type %d\n", vif->type);
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->vif = conf->vif;
-	wl->if_type = conf->type;
-	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+	wl->vif = vif;
+	wl->if_type = vif->type;
+	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43legacy_adjust_opmode(dev);
@@ -3403,18 +3403,18 @@ static int b43legacy_op_add_interface(st
 }
 
 static void b43legacy_op_remove_interface(struct ieee80211_hw *hw,
-					  struct ieee80211_if_init_conf *conf)
+					  struct ieee80211_vif *vif)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	unsigned long flags;
 
-	b43legacydbg(wl, "Removing Interface type %d\n", conf->type);
+	b43legacydbg(wl, "Removing Interface type %d\n", vif->type);
 
 	mutex_lock(&wl->mutex);
 
 	B43legacy_WARN_ON(!wl->operating);
-	B43legacy_WARN_ON(wl->vif != conf->vif);
+	B43legacy_WARN_ON(wl->vif != vif);
 	wl->vif = NULL;
 
 	wl->operating = 0;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-12-07 10:12:18.000000000 +0100
@@ -2582,12 +2582,12 @@ int iwl_set_mode(struct iwl_priv *priv, 
 EXPORT_SYMBOL(iwl_set_mode);
 
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
+				 struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
 
-	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", conf->type);
+	IWL_DEBUG_MAC80211(priv, "enter: type %d\n", vif->type);
 
 	if (priv->vif) {
 		IWL_DEBUG_MAC80211(priv, "leave - vif != NULL\n");
@@ -2595,19 +2595,19 @@ int iwl_mac_add_interface(struct ieee802
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->vif = conf->vif;
-	priv->iw_mode = conf->type;
+	priv->vif = vif;
+	priv->iw_mode = vif->type;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	mutex_lock(&priv->mutex);
 
-	if (conf->mac_addr) {
-		IWL_DEBUG_MAC80211(priv, "Set %pM\n", conf->mac_addr);
-		memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
+	if (vif->addr) {
+		IWL_DEBUG_MAC80211(priv, "Set %pM\n", vif->addr);
+		memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
 	}
 
-	if (iwl_set_mode(priv, conf->type) == -EAGAIN)
+	if (iwl_set_mode(priv, vif->type) == -EAGAIN)
 		/* we are not ready, will run again when ready */
 		set_bit(STATUS_MODE_PENDING, &priv->status);
 
@@ -2619,7 +2619,7 @@ int iwl_mac_add_interface(struct ieee802
 EXPORT_SYMBOL(iwl_mac_add_interface);
 
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-				     struct ieee80211_if_init_conf *conf)
+				     struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -2632,7 +2632,7 @@ void iwl_mac_remove_interface(struct iee
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
 	}
-	if (priv->vif == conf->vif) {
+	if (priv->vif == vif) {
 		priv->vif = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
 	}
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -318,14 +318,14 @@ static void lbtf_op_stop(struct ieee8021
 }
 
 static int lbtf_op_add_interface(struct ieee80211_hw *hw,
-			struct ieee80211_if_init_conf *conf)
+			struct ieee80211_vif *vif)
 {
 	struct lbtf_private *priv = hw->priv;
 	if (priv->vif != NULL)
 		return -EOPNOTSUPP;
 
-	priv->vif = conf->vif;
-	switch (conf->type) {
+	priv->vif = vif;
+	switch (vif->type) {
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		lbtf_set_mode(priv, LBTF_AP_MODE);
@@ -337,12 +337,12 @@ static int lbtf_op_add_interface(struct 
 		priv->vif = NULL;
 		return -EOPNOTSUPP;
 	}
-	lbtf_set_mac_address(priv, (u8 *) conf->mac_addr);
+	lbtf_set_mac_address(priv, (u8 *) vif->addr);
 	return 0;
 }
 
 static void lbtf_op_remove_interface(struct ieee80211_hw *hw,
-			struct ieee80211_if_init_conf *conf)
+			struct ieee80211_vif *vif)
 {
 	struct lbtf_private *priv = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-12-07 10:12:18.000000000 +0100
@@ -553,24 +553,24 @@ static void mac80211_hwsim_stop(struct i
 
 
 static int mac80211_hwsim_add_interface(struct ieee80211_hw *hw,
-					struct ieee80211_if_init_conf *conf)
+					struct ieee80211_vif *vif)
 {
 	printk(KERN_DEBUG "%s:%s (type=%d mac_addr=%pM)\n",
-	       wiphy_name(hw->wiphy), __func__, conf->type,
-	       conf->mac_addr);
-	hwsim_set_magic(conf->vif);
+	       wiphy_name(hw->wiphy), __func__, vif->type,
+	       vif->addr);
+	hwsim_set_magic(vif);
 	return 0;
 }
 
 
 static void mac80211_hwsim_remove_interface(
-	struct ieee80211_hw *hw, struct ieee80211_if_init_conf *conf)
+	struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	printk(KERN_DEBUG "%s:%s (type=%d mac_addr=%pM)\n",
-	       wiphy_name(hw->wiphy), __func__, conf->type,
-	       conf->mac_addr);
-	hwsim_check_magic(conf->vif);
-	hwsim_clear_magic(conf->vif);
+	       wiphy_name(hw->wiphy), __func__, vif->type,
+	       vif->addr);
+	hwsim_check_magic(vif);
+	hwsim_clear_magic(vif);
 }
 
 
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2009-12-07 10:12:10.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2009-12-07 10:12:18.000000000 +0100
@@ -2891,7 +2891,7 @@ static void mwl8k_stop(struct ieee80211_
 }
 
 static int mwl8k_add_interface(struct ieee80211_hw *hw,
-				struct ieee80211_if_init_conf *conf)
+				struct ieee80211_vif *vif)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif;
@@ -2905,7 +2905,7 @@ static int mwl8k_add_interface(struct ie
 	/*
 	 * We only support managed interfaces for now.
 	 */
-	if (conf->type != NL80211_IFTYPE_STATION)
+	if (vif->type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
 	/*
@@ -2921,12 +2921,12 @@ static int mwl8k_add_interface(struct ie
 	}
 
 	/* Clean out driver private area */
-	mwl8k_vif = MWL8K_VIF(conf->vif);
+	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 
 	/* Set and save the mac address */
-	mwl8k_set_mac_addr(hw, conf->mac_addr);
-	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, ETH_ALEN);
+	mwl8k_set_mac_addr(hw, vif->addr);
+	memcpy(mwl8k_vif->mac_addr, vif->addr, ETH_ALEN);
 
 	/* Back pointer to parent config block */
 	mwl8k_vif->priv = priv;
@@ -2939,14 +2939,14 @@ static int mwl8k_add_interface(struct ie
 	/* Set Initial sequence number to zero */
 	mwl8k_vif->seqno = 0;
 
-	priv->vif = conf->vif;
+	priv->vif = vif;
 	priv->current_channel = NULL;
 
 	return 0;
 }
 
 static void mwl8k_remove_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+				   struct ieee80211_vif *vif)
 {
 	struct mwl8k_priv *priv = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/p54/main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/p54/main.c	2009-12-07 10:12:18.000000000 +0100
@@ -216,7 +216,7 @@ static void p54_stop(struct ieee80211_hw
 }
 
 static int p54_add_interface(struct ieee80211_hw *dev,
-			     struct ieee80211_if_init_conf *conf)
+			     struct ieee80211_vif *vif)
 {
 	struct p54_common *priv = dev->priv;
 
@@ -226,28 +226,28 @@ static int p54_add_interface(struct ieee
 		return -EOPNOTSUPP;
 	}
 
-	priv->vif = conf->vif;
+	priv->vif = vif;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
-		priv->mode = conf->type;
+		priv->mode = vif->type;
 		break;
 	default:
 		mutex_unlock(&priv->conf_mutex);
 		return -EOPNOTSUPP;
 	}
 
-	memcpy(priv->mac_addr, conf->mac_addr, ETH_ALEN);
+	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
 	p54_setup_mac(priv);
 	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
 static void p54_remove_interface(struct ieee80211_hw *dev,
-				 struct ieee80211_if_init_conf *conf)
+				 struct ieee80211_vif *vif)
 {
 	struct p54_common *priv = dev->priv;
 
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-12-07 10:12:18.000000000 +0100
@@ -187,10 +187,10 @@ void rt2x00mac_stop(struct ieee80211_hw 
 EXPORT_SYMBOL_GPL(rt2x00mac_stop);
 
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
-			    struct ieee80211_if_init_conf *conf)
+			    struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(conf->vif);
+	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, QID_BEACON);
 	struct queue_entry *entry = NULL;
 	unsigned int i;
@@ -203,7 +203,7 @@ int rt2x00mac_add_interface(struct ieee8
 	    !test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
 		return -ENODEV;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
 		/*
 		 * We don't support mixed combinations of
@@ -263,7 +263,7 @@ int rt2x00mac_add_interface(struct ieee8
 	 * increase interface count and start initialization.
 	 */
 
-	if (conf->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP)
 		rt2x00dev->intf_ap_count++;
 	else
 		rt2x00dev->intf_sta_count++;
@@ -273,16 +273,16 @@ int rt2x00mac_add_interface(struct ieee8
 	mutex_init(&intf->beacon_skb_mutex);
 	intf->beacon = entry;
 
-	if (conf->type == NL80211_IFTYPE_AP)
-		memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
-	memcpy(&intf->mac, conf->mac_addr, ETH_ALEN);
+	if (vif->type == NL80211_IFTYPE_AP)
+		memcpy(&intf->bssid, vif->addr, ETH_ALEN);
+	memcpy(&intf->mac, vif->addr, ETH_ALEN);
 
 	/*
 	 * The MAC adddress must be configured after the device
 	 * has been initialized. Otherwise the device can reset
 	 * the MAC registers.
 	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, conf->type, intf->mac, NULL);
+	rt2x00lib_config_intf(rt2x00dev, intf, vif->type, intf->mac, NULL);
 
 	/*
 	 * Some filters depend on the current working mode. We can force
@@ -296,10 +296,10 @@ int rt2x00mac_add_interface(struct ieee8
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
 
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
-				struct ieee80211_if_init_conf *conf)
+				struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(conf->vif);
+	struct rt2x00_intf *intf = vif_to_intf(vif);
 
 	/*
 	 * Don't allow interfaces to be remove while
@@ -307,11 +307,11 @@ void rt2x00mac_remove_interface(struct i
 	 * no interface is present.
 	 */
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
-	    (conf->type == NL80211_IFTYPE_AP && !rt2x00dev->intf_ap_count) ||
-	    (conf->type != NL80211_IFTYPE_AP && !rt2x00dev->intf_sta_count))
+	    (vif->type == NL80211_IFTYPE_AP && !rt2x00dev->intf_ap_count) ||
+	    (vif->type != NL80211_IFTYPE_AP && !rt2x00dev->intf_sta_count))
 		return;
 
-	if (conf->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP)
 		rt2x00dev->intf_ap_count--;
 	else
 		rt2x00dev->intf_sta_count--;
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c	2009-12-07 10:12:18.000000000 +0100
@@ -657,35 +657,35 @@ static void rtl8180_stop(struct ieee8021
 }
 
 static int rtl8180_add_interface(struct ieee80211_hw *dev,
-				 struct ieee80211_if_init_conf *conf)
+				 struct ieee80211_vif *vif)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
 	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		return -EOPNOTSUPP;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		priv->mode = conf->type;
+		priv->mode = vif->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	priv->vif = conf->vif;
+	priv->vif = vif;
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->MAC[0],
-			  le32_to_cpu(*(__le32 *)conf->mac_addr));
+			  le32_to_cpu(*(__le32 *)vif->addr));
 	rtl818x_iowrite16(priv, (__le16 __iomem *)&priv->map->MAC[4],
-			  le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+			  le16_to_cpu(*(__le16 *)(vif->addr + 4)));
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	return 0;
 }
 
 static void rtl8180_remove_interface(struct ieee80211_hw *dev,
-				     struct ieee80211_if_init_conf *conf)
+				     struct ieee80211_vif *vif)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	priv->mode = NL80211_IFTYPE_MONITOR;
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c	2009-12-07 10:12:18.000000000 +0100
@@ -1018,7 +1018,7 @@ static void rtl8187_stop(struct ieee8021
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
-				 struct ieee80211_if_init_conf *conf)
+				 struct ieee80211_vif *vif)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
@@ -1028,21 +1028,21 @@ static int rtl8187_add_interface(struct 
 	if (priv->mode != NL80211_IFTYPE_MONITOR)
 		goto exit;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
-		priv->mode = conf->type;
+		priv->mode = vif->type;
 		break;
 	default:
 		goto exit;
 	}
 
 	ret = 0;
-	priv->vif = conf->vif;
+	priv->vif = vif;
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->MAC[i],
-				 ((u8 *)conf->mac_addr)[i]);
+				 ((u8 *)vif->addr)[i]);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 exit:
@@ -1051,7 +1051,7 @@ exit:
 }
 
 static void rtl8187_remove_interface(struct ieee80211_hw *dev,
-				     struct ieee80211_if_init_conf *conf)
+				     struct ieee80211_vif *vif)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	mutex_lock(&priv->conf_mutex);
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2009-12-07 10:12:18.000000000 +0100
@@ -510,13 +510,13 @@ static void wl1251_op_stop(struct ieee80
 }
 
 static int wl1251_op_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+				   struct ieee80211_vif *vif)
 {
 	struct wl1251 *wl = hw->priv;
 	int ret = 0;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
-		     conf->type, conf->mac_addr);
+		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
 	if (wl->vif) {
@@ -524,9 +524,9 @@ static int wl1251_op_add_interface(struc
 		goto out;
 	}
 
-	wl->vif = conf->vif;
+	wl->vif = vif;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
 		break;
@@ -538,8 +538,8 @@ static int wl1251_op_add_interface(struc
 		goto out;
 	}
 
-	if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
-		memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+	if (memcmp(wl->mac_addr, vif->addr, ETH_ALEN)) {
+		memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 		SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
 		ret = wl1251_acx_station_id(wl);
 		if (ret < 0)
@@ -552,7 +552,7 @@ out:
 }
 
 static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_if_init_conf *conf)
+					 struct ieee80211_vif *vif)
 {
 	struct wl1251 *wl = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2009-12-07 10:12:18.000000000 +0100
@@ -996,13 +996,13 @@ static void wl1271_op_stop(struct ieee80
 }
 
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+				   struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
-		     conf->type, conf->mac_addr);
+		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
 	if (wl->vif) {
@@ -1010,9 +1010,9 @@ static int wl1271_op_add_interface(struc
 		goto out;
 	}
 
-	wl->vif = conf->vif;
+	wl->vif = vif;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
 		break;
@@ -1032,7 +1032,7 @@ out:
 }
 
 static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_if_init_conf *conf)
+					 struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-12-07 10:12:18.000000000 +0100
@@ -869,7 +869,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 }
 
 static int zd_op_add_interface(struct ieee80211_hw *hw,
-				struct ieee80211_if_init_conf *conf)
+				struct ieee80211_vif *vif)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 
@@ -877,22 +877,22 @@ static int zd_op_add_interface(struct ie
 	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
 		return -EOPNOTSUPP;
 
-	switch (conf->type) {
+	switch (vif->type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		mac->type = conf->type;
+		mac->type = vif->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	return zd_write_mac_addr(&mac->chip, conf->mac_addr);
+	return zd_write_mac_addr(&mac->chip, vif->addr);
 }
 
 static void zd_op_remove_interface(struct ieee80211_hw *hw,
-				    struct ieee80211_if_init_conf *conf)
+				    struct ieee80211_vif *vif)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = NL80211_IFTYPE_UNSPECIFIED;
--- wireless-testing.orig/include/net/mac80211.h	2009-12-07 10:11:44.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-12-07 10:21:46.000000000 +0100
@@ -700,33 +700,6 @@ static inline bool ieee80211_vif_is_mesh
 }
 
 /**
- * struct ieee80211_if_init_conf - initial configuration of an interface
- *
- * @vif: pointer to a driver-use per-interface structure. The pointer
- *	itself is also used for various functions including
- *	ieee80211_beacon_get() and ieee80211_get_buffered_bc().
- * @type: one of &enum nl80211_iftype constants. Determines the type of
- *	added/removed interface.
- * @mac_addr: pointer to MAC address of the interface. This pointer is valid
- *	until the interface is removed (i.e. it cannot be used after
- *	remove_interface() callback was called for this interface).
- *
- * This structure is used in add_interface() and remove_interface()
- * callbacks of &struct ieee80211_hw.
- *
- * When you allow multiple interfaces to be added to your PHY, take care
- * that the hardware can actually handle multiple MAC addresses. However,
- * also take care that when there's no interface left with mac_addr != %NULL
- * you remove the MAC address from the device to avoid acknowledging packets
- * in pure monitor mode.
- */
-struct ieee80211_if_init_conf {
-	enum nl80211_iftype type;
-	struct ieee80211_vif *vif;
-	void *mac_addr;
-};
-
-/**
  * enum ieee80211_key_alg - key algorithm
  * @ALG_WEP: WEP40 or WEP104
  * @ALG_TKIP: TKIP
@@ -1553,9 +1526,9 @@ struct ieee80211_ops {
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 	int (*add_interface)(struct ieee80211_hw *hw,
-			     struct ieee80211_if_init_conf *conf);
+			     struct ieee80211_vif *vif);
 	void (*remove_interface)(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf);
+				 struct ieee80211_vif *vif);
 	int (*config)(struct ieee80211_hw *hw, u32 changed);
 	void (*bss_info_changed)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
@@ -1837,7 +1810,7 @@ void ieee80211_tx_status_irqsafe(struct 
 /**
  * ieee80211_beacon_get_tim - beacon generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @tim_offset: pointer to variable that will receive the TIM IE offset.
  *	Set to 0 if invalid (in non-AP modes).
  * @tim_length: pointer to variable that will receive the TIM IE length,
@@ -1865,7 +1838,7 @@ struct sk_buff *ieee80211_beacon_get_tim
 /**
  * ieee80211_beacon_get - beacon generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * See ieee80211_beacon_get_tim().
  */
@@ -1878,7 +1851,7 @@ static inline struct sk_buff *ieee80211_
 /**
  * ieee80211_rts_get - RTS frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @frame: pointer to the frame that is going to be protected by the RTS.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_info of the frame.
@@ -1897,7 +1870,7 @@ void ieee80211_rts_get(struct ieee80211_
 /**
  * ieee80211_rts_duration - Get the duration field for an RTS frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame that is going to be protected by the RTS.
  * @frame_txctl: &struct ieee80211_tx_info of the frame.
  *
@@ -1912,7 +1885,7 @@ __le16 ieee80211_rts_duration(struct iee
 /**
  * ieee80211_ctstoself_get - CTS-to-self frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @frame: pointer to the frame that is going to be protected by the CTS-to-self.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_info of the frame.
@@ -1932,7 +1905,7 @@ void ieee80211_ctstoself_get(struct ieee
 /**
  * ieee80211_ctstoself_duration - Get the duration field for a CTS-to-self frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame that is going to be protected by the CTS-to-self.
  * @frame_txctl: &struct ieee80211_tx_info of the frame.
  *
@@ -1948,7 +1921,7 @@ __le16 ieee80211_ctstoself_duration(stru
 /**
  * ieee80211_generic_frame_duration - Calculate the duration field for a frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  * @frame_len: the length of the frame.
  * @rate: the rate at which the frame is going to be transmitted.
  *
@@ -1963,7 +1936,7 @@ __le16 ieee80211_generic_frame_duration(
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
  * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * Function for accessing buffered broadcast and multicast frames. If
  * hardware/firmware does not implement buffering of broadcast/multicast
@@ -2131,7 +2104,7 @@ int ieee80211_start_tx_ba_session(struct
 
 /**
  * ieee80211_start_tx_ba_cb - low level driver ready to aggregate.
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
@@ -2142,7 +2115,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 
 /**
  * ieee80211_start_tx_ba_cb_irqsafe - low level driver ready to aggregate.
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the TID to BA on.
  *
@@ -2170,7 +2143,7 @@ int ieee80211_stop_tx_ba_session(struct 
 
 /**
  * ieee80211_stop_tx_ba_cb - low level driver ready to stop aggregate.
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
@@ -2181,7 +2154,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 
 /**
  * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback
  * @ra: receiver address of the BA session recipient.
  * @tid: the desired TID to BA on.
  *
@@ -2260,7 +2233,7 @@ void ieee80211_sta_block_awake(struct ie
 /**
  * ieee80211_beacon_loss - inform hardware does not receive beacons
  *
- * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
  * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-12-07 10:12:32.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-12-07 10:12:59.000000000 +0100
@@ -36,18 +36,18 @@ static inline void drv_stop(struct ieee8
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
-				    struct ieee80211_if_init_conf *conf)
+				    struct ieee80211_vif *vif)
 {
-	int ret = local->ops->add_interface(&local->hw, conf);
-	trace_drv_add_interface(local, vif_to_sdata(conf->vif), ret);
+	int ret = local->ops->add_interface(&local->hw, vif);
+	trace_drv_add_interface(local, vif_to_sdata(vif), ret);
 	return ret;
 }
 
 static inline void drv_remove_interface(struct ieee80211_local *local,
-					struct ieee80211_if_init_conf *conf)
+					struct ieee80211_vif *vif)
 {
-	local->ops->remove_interface(&local->hw, conf);
-	trace_drv_remove_interface(local, vif_to_sdata(conf->vif));
+	local->ops->remove_interface(&local->hw, vif);
+	trace_drv_remove_interface(local, vif_to_sdata(vif));
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
--- wireless-testing.orig/net/mac80211/iface.c	2009-12-07 10:13:21.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-12-07 10:14:27.000000000 +0100
@@ -96,7 +96,6 @@ static int ieee80211_open(struct net_dev
 	struct ieee80211_sub_if_data *nsdata;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	struct ieee80211_if_init_conf conf;
 	u32 changed = 0;
 	int res;
 	u32 hw_reconf_flags = 0;
@@ -248,10 +247,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_configure_filter(local);
 		break;
 	default:
-		conf.vif = &sdata->vif;
-		conf.type = sdata->vif.type;
-		conf.mac_addr = sdata->vif.addr;
-		res = drv_add_interface(local, &conf);
+		res = drv_add_interface(local, &sdata->vif);
 		if (res)
 			goto err_stop;
 
@@ -334,7 +330,7 @@ static int ieee80211_open(struct net_dev
 
 	return 0;
  err_del_interface:
-	drv_remove_interface(local, &conf);
+	drv_remove_interface(local, &sdata->vif);
  err_stop:
 	if (!local->open_count)
 		drv_stop(local);
@@ -349,7 +345,6 @@ static int ieee80211_stop(struct net_dev
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
@@ -533,12 +528,9 @@ static int ieee80211_stop(struct net_dev
 				BSS_CHANGED_BEACON_ENABLED);
 		}
 
-		conf.vif = &sdata->vif;
-		conf.type = sdata->vif.type;
-		conf.mac_addr = sdata->vif.addr;
 		/* disable all keys for as long as this netdev is down */
 		ieee80211_disable_keys(sdata);
-		drv_remove_interface(local, &conf);
+		drv_remove_interface(local, &sdata->vif);
 	}
 
 	sdata->bss = NULL;
--- wireless-testing.orig/net/mac80211/pm.c	2009-12-07 10:13:22.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-12-07 10:14:41.000000000 +0100
@@ -10,7 +10,6 @@ int __ieee80211_suspend(struct ieee80211
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	unsigned long flags;
 
@@ -100,10 +99,7 @@ int __ieee80211_suspend(struct ieee80211
 		ieee80211_bss_info_change_notify(sdata,
 			BSS_CHANGED_BEACON_ENABLED);
 
-		conf.vif = &sdata->vif;
-		conf.type = sdata->vif.type;
-		conf.mac_addr = sdata->vif.addr;
-		drv_remove_interface(local, &conf);
+		drv_remove_interface(local, &sdata->vif);
 	}
 
 	/* stop hardware - this must stop RX */
--- wireless-testing.orig/net/mac80211/util.c	2009-12-07 10:13:22.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-12-07 10:15:01.000000000 +0100
@@ -1075,7 +1075,6 @@ int ieee80211_reconfig(struct ieee80211_
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	unsigned long flags;
 	int res;
@@ -1094,12 +1093,8 @@ int ieee80211_reconfig(struct ieee80211_
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-		    ieee80211_sdata_running(sdata)) {
-			conf.vif = &sdata->vif;
-			conf.type = sdata->vif.type;
-			conf.mac_addr = sdata->vif.addr;
-			res = drv_add_interface(local, &conf);
-		}
+		    ieee80211_sdata_running(sdata))
+			res = drv_add_interface(local, &sdata->vif);
 	}
 
 	/* add STAs back */
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-12-07 10:15:19.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-12-07 10:15:37.000000000 +0100
@@ -328,9 +328,9 @@ int iwl_mac_beacon_update(struct ieee802
 int iwl_commit_rxon(struct iwl_priv *priv);
 int iwl_set_mode(struct iwl_priv *priv, int mode);
 int iwl_mac_add_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf);
+			  struct ieee80211_vif *vif);
 void iwl_mac_remove_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf);
+			      struct ieee80211_vif *vif);
 int iwl_mac_config(struct ieee80211_hw *hw, u32 changed);
 void iwl_config_ap(struct iwl_priv *priv);
 int iwl_mac_get_tx_stats(struct ieee80211_hw *hw,
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00.h	2009-12-07 10:16:20.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00.h	2009-12-07 10:16:31.000000000 +0100
@@ -1013,9 +1013,9 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 int rt2x00mac_start(struct ieee80211_hw *hw);
 void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
-			    struct ieee80211_if_init_conf *conf);
+			    struct ieee80211_vif *vif);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
-				struct ieee80211_if_init_conf *conf);
+				struct ieee80211_vif *vif);
 int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed);
 void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 				unsigned int changed_flags,


