Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbZEKJZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 05:25:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 4/5] mac80211: add a struct for info upon device stop
Date: Mon, 11 May 2009 05:25:03 -0400
Message-Id: <1242033904-25694-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows us to stuff information to give to the driver
for stoping the device. This will come more in handy later
when we add WoW support.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/adm8211.c              |    3 +-
 drivers/net/wireless/at76c50x-usb.c         |    3 +-
 drivers/net/wireless/ath/ar9170/main.c      |    3 +-
 drivers/net/wireless/ath/ath5k/base.c       |    6 +++-
 drivers/net/wireless/ath/ath9k/main.c       |    3 +-
 drivers/net/wireless/b43/main.c             |    3 +-
 drivers/net/wireless/b43legacy/main.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +-
 drivers/net/wireless/libertas_tf/main.c     |    3 +-
 drivers/net/wireless/mac80211_hwsim.c       |    3 +-
 drivers/net/wireless/mwl8k.c                |    3 +-
 drivers/net/wireless/p54/p54common.c        |    3 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    3 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    3 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    3 +-
 drivers/net/wireless/wl12xx/main.c          |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    3 +-
 include/net/mac80211.h                      |   39 +++++++++++++++++++++++---
 net/mac80211/driver-ops.h                   |    5 ++-
 net/mac80211/iface.c                        |   18 +++++++++---
 net/mac80211/pm.c                           |    4 ++-
 23 files changed, 93 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 316df03..2efe158 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1546,7 +1546,8 @@ fail:
 	return retval;
 }
 
-static void adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev,
+			 struct ieee80211_device_stop_info *stop_info)
 {
 	struct adm8211_priv *priv = dev->priv;
 
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index e3caeef..54d71c6 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1766,7 +1766,8 @@ error:
 	return 0;
 }
 
-static void at76_mac80211_stop(struct ieee80211_hw *hw)
+static void at76_mac80211_stop(struct ieee80211_hw *hw,
+			       struct ieee80211_device_stop_info *stop_info)
 {
 	struct at76_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 4ef1d2f..f87546d 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1003,7 +1003,8 @@ out:
 	return err;
 }
 
-static void ar9170_op_stop(struct ieee80211_hw *hw)
+static void ar9170_op_stop(struct ieee80211_hw *hw,
+			   struct ieee80211_device_stop_info *stop_info)
 {
 	struct ar9170 *ar = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6789c5d..ef2563c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -221,7 +221,8 @@ static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 static int ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel);
 static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
-static void ath5k_stop(struct ieee80211_hw *hw);
+static void ath5k_stop(struct ieee80211_hw *hw,
+		       struct ieee80211_device_stop_info *stop_info);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf);
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
@@ -2696,7 +2697,8 @@ static int ath5k_start(struct ieee80211_hw *hw)
 	return ath5k_init(hw->priv);
 }
 
-static void ath5k_stop(struct ieee80211_hw *hw)
+static void ath5k_stop(struct ieee80211_hw *hw,
+		       struct ieee80211_device_stop_info *stop_info)
 {
 	ath5k_stop_hw(hw->priv);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4fe0f8a..23a3a4c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2118,7 +2118,8 @@ exit:
 	return 0;
 }
 
-static void ath9k_stop(struct ieee80211_hw *hw)
+static void ath9k_stop(struct ieee80211_hw *hw,
+		       struct ieee80211_device_stop_info *stop_info)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2615aaf..ffe0bf0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4348,7 +4348,8 @@ static int b43_op_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-static void b43_op_stop(struct ieee80211_hw *hw)
+static void b43_op_stop(struct ieee80211_hw *hw,
+			struct ieee80211_device_stop_info *stop_info)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 07c7898..3ac73c5 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3514,7 +3514,8 @@ out_mutex_unlock:
 	return err;
 }
 
-static void b43legacy_op_stop(struct ieee80211_hw *hw)
+static void b43legacy_op_stop(struct ieee80211_hw *hw,
+			      struct ieee80211_device_stop_info *stop_info)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6cdee0b..4355812 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2001,7 +2001,8 @@ out:
 	return 0;
 }
 
-static void iwl_mac_stop(struct ieee80211_hw *hw)
+static void iwl_mac_stop(struct ieee80211_hw *hw,
+			 struct ieee80211_device_stop_info *stop_info)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index f6c1489..ad002e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3411,7 +3411,8 @@ out_release_irq:
 	return ret;
 }
 
-static void iwl3945_mac_stop(struct ieee80211_hw *hw)
+static void iwl3945_mac_stop(struct ieee80211_hw *hw,
+			     struct ieee80211_device_stop_info *stop_info)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 10a99e2..d3db5ca 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -291,7 +291,8 @@ err_prog_firmware:
 	return ret;
 }
 
-static void lbtf_op_stop(struct ieee80211_hw *hw)
+static void lbtf_op_stop(struct ieee80211_hw *hw,
+			 struct ieee80211_device_stop_info *stop_info)
 {
 	struct lbtf_private *priv = hw->priv;
 	unsigned long flags;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b1213b6..2c191fa 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -477,7 +477,8 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 }
 
 
-static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
+static void mac80211_hwsim_stop(struct ieee80211_hw *hw,
+				struct ieee80211_device_stop_info *stop_info)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = 0;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 46b288d..303b952 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2916,7 +2916,8 @@ static int mwl8k_stop_wt(struct work_struct *wt)
 	return rc;
 }
 
-static void mwl8k_stop(struct ieee80211_hw *hw)
+static void mwl8k_stop(struct ieee80211_hw *hw,
+		       struct ieee80211_device_stop_info *stop_info)
 {
 	int rc;
 	struct mwl8k_stop_worker *worker;
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 48d81d9..67d4483 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -2087,7 +2087,8 @@ out:
 	return err;
 }
 
-static void p54_stop(struct ieee80211_hw *dev)
+static void p54_stop(struct ieee80211_hw *dev,
+		     struct ieee80211_device_stop_info *stop_info)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 419b1b9..db7d61f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -958,7 +958,8 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
-void rt2x00mac_stop(struct ieee80211_hw *hw);
+void rt2x00mac_stop(struct ieee80211_hw *hw,
+		    struct ieee80211_device_stop_info *stop_info);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c4c06b4..e9f4c3a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -178,7 +178,8 @@ int rt2x00mac_start(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_start);
 
-void rt2x00mac_stop(struct ieee80211_hw *hw)
+void rt2x00mac_stop(struct ieee80211_hw *hw,
+		    struct ieee80211_device_stop_info *stop_info)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 7e65d7c..d84a597 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -627,7 +627,8 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	return ret;
 }
 
-static void rtl8180_stop(struct ieee80211_hw *dev)
+static void rtl8180_stop(struct ieee80211_hw *dev,
+			 struct ieee80211_device_stop_info *stop_info)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u8 reg;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 158827e..62a462c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -991,7 +991,8 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static void rtl8187_stop(struct ieee80211_hw *dev)
+static void rtl8187_stop(struct ieee80211_hw *dev,
+			 struct ieee80211_device_stop_info *stop_info)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..971794b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -363,7 +363,8 @@ out:
 	return ret;
 }
 
-static void wl12xx_op_stop(struct ieee80211_hw *hw)
+static void wl12xx_op_stop(struct ieee80211_hw *hw,
+			   struct ieee80211_device_stop_info *stop_info)
 {
 	struct wl12xx *wl = hw->priv;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6bdb170..db3d894 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -256,7 +256,8 @@ out:
 	return r;
 }
 
-static void zd_op_stop(struct ieee80211_hw *hw)
+static void zd_op_stop(struct ieee80211_hw *hw,
+		       struct ieee80211_device_stop_info *stop_info)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 38dc1cd..d7460a4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1291,6 +1291,31 @@ enum ieee80211_ampdu_mlme_action {
 };
 
 /**
+ * enum ieee80211_device_stop_reason - device stop reasons
+ *
+ * These are reasons why mac80211 would call the driver's stop()
+ * callback. Devices should probably not care other than when
+ * we call to stop during suspend, in these cases the device may
+ * want to leave the radio on for WoW events for example.
+ * @IEEE80211_DEV_STOP_INVALID_MAC: invalid mac address was detected for device
+ * @IEEE80211_DEV_STOP_NO_OPEN_DEV: we were not able to open any
+	netdevice for the current wireless device during user initialization.
+ * @IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST: user requested the device to be
+ *	closed.
+ * @IEEE80211_DEV_STOP_SUSPEND: we are going to suspend
+ */
+enum ieee80211_device_stop_reasons {
+	IEEE80211_DEV_STOP_INVALID_MAC,
+	IEEE80211_DEV_STOP_NO_OPEN_DEV,
+	IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST,
+	IEEE80211_DEV_STOP_SUSPEND,
+};
+
+struct ieee80211_device_stop_info {
+	enum ieee80211_device_stop_reasons reason;
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -1318,10 +1343,13 @@ enum ieee80211_ampdu_mlme_action {
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
+ *	an interface. To assist drivers we provide stop detail
+ *	information through &struct ieee80211_device_stop_info. This
+ *	will help later for WoW support.
  *	Must be implemented.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
@@ -1443,7 +1471,8 @@ enum ieee80211_ampdu_mlme_action {
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
-	void (*stop)(struct ieee80211_hw *hw);
+	void (*stop)(struct ieee80211_hw *hw,
+		     struct ieee80211_device_stop_info *stop_info);
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
 	void (*remove_interface)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3912b53..3864353 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -14,9 +14,10 @@ static inline int drv_start(struct ieee80211_local *local)
 	return local->ops->start(&local->hw);
 }
 
-static inline void drv_stop(struct ieee80211_local *local)
+static inline void drv_stop(struct ieee80211_local *local,
+			    struct ieee80211_device_stop_info *stop_info)
 {
-	local->ops->stop(&local->hw);
+	local->ops->stop(&local->hw, stop_info);
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f8eefad..54d9b91 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -81,6 +81,7 @@ static int ieee80211_open(struct net_device *dev)
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_if_init_conf conf;
+	struct ieee80211_device_stop_info stop_info;
 	u32 changed = 0;
 	int res;
 	u32 hw_reconf_flags = 0;
@@ -198,8 +199,10 @@ static int ieee80211_open(struct net_device *dev)
 	 * Validate the MAC address for this device.
 	 */
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-		if (!local->open_count)
-			drv_stop(local);
+		if (!local->open_count) {
+			stop_info.reason = IEEE80211_DEV_STOP_INVALID_MAC;
+			drv_stop(local, &stop_info);
+		}
 		return -EADDRNOTAVAIL;
 	}
 
@@ -331,8 +334,10 @@ static int ieee80211_open(struct net_device *dev)
  err_del_interface:
 	drv_remove_interface(local, &conf);
  err_stop:
-	if (!local->open_count)
-		drv_stop(local);
+	if (!local->open_count) {
+		stop_info.reason = IEEE80211_DEV_STOP_NO_OPEN_DEV;
+		drv_stop(local, &stop_info);
+	}
  err_del_bss:
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -555,10 +560,13 @@ static int ieee80211_stop(struct net_device *dev)
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
+		struct ieee80211_device_stop_info stop_info;
+
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
 
-		drv_stop(local);
+		stop_info.reason = IEEE80211_DEV_STOP_DEV_CLOSE_REQUEST;
+		drv_stop(local, &stop_info);
 
 		ieee80211_led_radio(local, 0);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 9d3d89a..24aa109 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -67,8 +67,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	/* stop hardware */
 	if (local->open_count) {
+		struct ieee80211_device_stop_info stop_info;
 		ieee80211_led_radio(local, false);
-		drv_stop(local);
+		stop_info.reason = IEEE80211_DEV_STOP_SUSPEND;
+		drv_stop(local, &stop_info);
 	}
 	return 0;
 }
-- 
1.6.0.6

