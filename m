Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbZEMJVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:21:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2 2/5] mac80211: inform devices when we are suspending on the stop callback
Date: Wed, 13 May 2009 05:20:58 -0400
Message-Id: <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We inform the drivers so they can take appropriate actions during
suspend for WoW support.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/adm8211.c              |    2 +-
 drivers/net/wireless/at76c50x-usb.c         |    2 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |    4 ++--
 drivers/net/wireless/ath/ath9k/main.c       |    2 +-
 drivers/net/wireless/b43/main.c             |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/libertas_tf/main.c     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |    2 +-
 drivers/net/wireless/mwl8k.c                |    2 +-
 drivers/net/wireless/p54/p54common.c        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c          |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    2 +-
 include/net/mac80211.h                      |   12 +++++++-----
 net/mac80211/driver-ops.h                   |    2 +-
 21 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 316df03..bfcf9ce 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1546,7 +1546,7 @@ fail:
 	return retval;
 }
 
-static void adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev, bool suspend)
 {
 	struct adm8211_priv *priv = dev->priv;
 
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e3caeef..e9ae9f7 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1766,7 +1766,7 @@ error:
 	return 0;
 }
 
-static void at76_mac80211_stop(struct ieee80211_hw *hw)
+static void at76_mac80211_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct at76_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 4ef1d2f..f85c981 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1003,7 +1003,7 @@ out:
 	return err;
 }
 
-static void ar9170_op_stop(struct ieee80211_hw *hw)
+static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct ar9170 *ar = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index dbfe9f4..6a917ab 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -221,7 +221,7 @@ static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
 static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
-static void ath5k_stop(struct ieee80211_hw *hw);
+static void ath5k_stop(struct ieee80211_hw *hw, bool suspend);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf);
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
@@ -2700,7 +2700,7 @@ static int ath5k_start(struct ieee80211_hw *hw)
 	return ath5k_init(hw->priv);
 }
 
-static void ath5k_stop(struct ieee80211_hw *hw)
+static void ath5k_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	ath5k_stop_hw(hw->priv);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7a1a8d3..fa1acf1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2118,7 +2118,7 @@ exit:
 	return 0;
 }
 
-static void ath9k_stop(struct ieee80211_hw *hw)
+static void ath9k_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2615aaf..177db73 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4348,7 +4348,7 @@ static int b43_op_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-static void b43_op_stop(struct ieee80211_hw *hw)
+static void b43_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 07c7898..7bac6be 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3514,7 +3514,7 @@ out_mutex_unlock:
 	return err;
 }
 
-static void b43legacy_op_stop(struct ieee80211_hw *hw)
+static void b43legacy_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 596977d..e48c345 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1985,7 +1985,7 @@ out:
 	return 0;
 }
 
-static void iwl_mac_stop(struct ieee80211_hw *hw)
+static void iwl_mac_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c32ec80..01b428d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3397,7 +3397,7 @@ out_release_irq:
 	return ret;
 }
 
-static void iwl3945_mac_stop(struct ieee80211_hw *hw)
+static void iwl3945_mac_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 10a99e2..07b2620 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -291,7 +291,7 @@ err_prog_firmware:
 	return ret;
 }
 
-static void lbtf_op_stop(struct ieee80211_hw *hw)
+static void lbtf_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct lbtf_private *priv = hw->priv;
 	unsigned long flags;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 61a4ad7..388068b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -477,7 +477,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 }
 
 
-static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
+static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = 0;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a263d5c..97f1c99 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2916,7 +2916,7 @@ static int mwl8k_stop_wt(struct work_struct *wt)
 	return rc;
 }
 
-static void mwl8k_stop(struct ieee80211_hw *hw)
+static void mwl8k_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	int rc;
 	struct mwl8k_stop_worker *worker;
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 48d81d9..d6660af 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2087,7 +2087,7 @@ out:
 	return err;
 }
 
-static void p54_stop(struct ieee80211_hw *dev)
+static void p54_stop(struct ieee80211_hw *dev, bool suspend)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 419b1b9..568a3c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -958,7 +958,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
-void rt2x00mac_stop(struct ieee80211_hw *hw);
+void rt2x00mac_stop(struct ieee80211_hw *hw, bool suspend);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c4c06b4..0540075 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -178,7 +178,7 @@ int rt2x00mac_start(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_start);
 
-void rt2x00mac_stop(struct ieee80211_hw *hw)
+void rt2x00mac_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 7e65d7c..d72debc 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -627,7 +627,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	return ret;
 }
 
-static void rtl8180_stop(struct ieee80211_hw *dev)
+static void rtl8180_stop(struct ieee80211_hw *dev, bool suspend)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u8 reg;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 6499ccc..878bb6a 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -991,7 +991,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static void rtl8187_stop(struct ieee80211_hw *dev)
+static void rtl8187_stop(struct ieee80211_hw *dev, bool suspend)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..dc3e804 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -363,7 +363,7 @@ out:
 	return ret;
 }
 
-static void wl12xx_op_stop(struct ieee80211_hw *hw)
+static void wl12xx_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct wl12xx *wl = hw->priv;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6bdb170..e553a64 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -256,7 +256,7 @@ out:
 	return r;
 }
 
-static void zd_op_stop(struct ieee80211_hw *hw)
+static void zd_op_stop(struct ieee80211_hw *hw, bool suspend)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d10ed17..9145cbf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1296,10 +1296,12 @@ enum ieee80211_ampdu_mlme_action {
  *	Must be implemented.
  *
  * @stop: Called after last netdevice attached to the hardware
- *	is disabled. This should turn off the hardware (at least
- *	it must turn off frame reception.)
- *	May be called right after add_interface if that rejects
- *	an interface.
+ *	is disabled or during suspend. This should turn off the
+ *	hardware (at least it must turn off frame reception) unless
+ *	the device wants to enable Wake-on-Wireless-LAN.
+ *	This may be called right after add_interface if that rejects
+ *	an interface. To assist drivers with WoW we inform the driver
+ *	whether or not the stop call is for suspend.
  *	Must be implemented.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
@@ -1421,7 +1423,7 @@ enum ieee80211_ampdu_mlme_action {
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
-	void (*stop)(struct ieee80211_hw *hw);
+	void (*stop)(struct ieee80211_hw *hw, bool suspend);
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
 	void (*remove_interface)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3912b53..ba6eca1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -16,7 +16,7 @@ static inline int drv_start(struct ieee80211_local *local)
 
 static inline void drv_stop(struct ieee80211_local *local)
 {
-	local->ops->stop(&local->hw);
+	local->ops->stop(&local->hw, local->suspended);
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
-- 
1.6.0.6

