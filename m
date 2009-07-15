Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbZGOAWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] mac80211: add WoW support
Date: Tue, 14 Jul 2009 20:21:59 -0400
Message-Id: <1247617320-20163-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we're associated and have not already gone into PS mode
we ensure send a nullfunc frame before going to suspend. Upon
resume we ensure we restore PS mode if it was enabled and inform
the driver accordingly, also notify the AP we're awake.

WoW requires the radio to be left on during suspend, to do this
we inform drivers of the requested wow triggers on the mac80211
stop callback.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/adm8211.c              |    2 +-
 drivers/net/wireless/at76c50x-usb.c         |    3 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |    4 +-
 drivers/net/wireless/ath/ath9k/main.c       |    2 +-
 drivers/net/wireless/b43/main.c             |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/libertas_tf/main.c     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |    2 +-
 drivers/net/wireless/mwl8k.c                |    2 +-
 drivers/net/wireless/p54/main.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1251_main.c   |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    2 +-
 include/net/mac80211.h                      |   17 +++++++++-----
 net/mac80211/cfg.c                          |    5 ++-
 net/mac80211/debugfs.c                      |    2 +-
 net/mac80211/driver-ops.h                   |    6 ++--
 net/mac80211/driver-trace.h                 |    6 +++-
 net/mac80211/ieee80211_i.h                  |   12 ++++++++-
 net/mac80211/iface.c                        |    6 ++--
 net/mac80211/pm.c                           |   31 +++++++++++++++++++++++++-
 net/mac80211/util.c                         |   14 ++++++++++++
 28 files changed, 99 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5695911..776a715 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1547,7 +1547,7 @@ fail:
 	return retval;
 }
 
-static void adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev, struct cfg80211_wow *wow)
 {
 	struct adm8211_priv *priv = dev->priv;
 
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 13303fa..8357fef 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1767,7 +1767,8 @@ error:
 	return 0;
 }
 
-static void at76_mac80211_stop(struct ieee80211_hw *hw)
+static void at76_mac80211_stop(struct ieee80211_hw *hw,
+			       struct cfg80211_wow *wow)
 {
 	struct at76_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 51753ed..2c2f002 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1132,7 +1132,7 @@ out:
 	return err;
 }
 
-static void ar9170_op_stop(struct ieee80211_hw *hw)
+static void ar9170_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct ar9170 *ar = hw->priv;
 	unsigned int i;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 20ba6fa..0bd53e8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -223,7 +223,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
 static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
-static void ath5k_stop(struct ieee80211_hw *hw);
+static void ath5k_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf);
 static void ath5k_remove_interface(struct ieee80211_hw *hw,
@@ -2735,7 +2735,7 @@ static int ath5k_start(struct ieee80211_hw *hw)
 	return ath5k_init(hw->priv);
 }
 
-static void ath5k_stop(struct ieee80211_hw *hw)
+static void ath5k_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	ath5k_stop_hw(hw->priv);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 907434a..f40f2cf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2087,7 +2087,7 @@ exit:
 	return 0;
 }
 
-static void ath9k_stop(struct ieee80211_hw *hw)
+static void ath9k_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e71c8d9..f0ca9d0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4368,7 +4368,7 @@ static int b43_op_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-static void b43_op_stop(struct ieee80211_hw *hw)
+static void b43_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c4973c1..9235578 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3469,7 +3469,7 @@ out_mutex_unlock:
 	return err;
 }
 
-static void b43legacy_op_stop(struct ieee80211_hw *hw)
+static void b43legacy_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 13279b1..fd2c146 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2137,7 +2137,7 @@ out:
 	return 0;
 }
 
-static void iwl_mac_stop(struct ieee80211_hw *hw)
+static void iwl_mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a05a039..83cc25c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3126,7 +3126,7 @@ out_release_irq:
 	return ret;
 }
 
-static void iwl3945_mac_stop(struct ieee80211_hw *hw)
+static void iwl3945_mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct iwl_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 4872345..8557ca4 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -291,7 +291,7 @@ err_prog_firmware:
 	return ret;
 }
 
-static void lbtf_op_stop(struct ieee80211_hw *hw)
+static void lbtf_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct lbtf_private *priv = hw->priv;
 	unsigned long flags;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2e2af65..516a31c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -488,7 +488,7 @@ static int mac80211_hwsim_start(struct ieee80211_hw *hw)
 }
 
 
-static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
+static void mac80211_hwsim_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = 0;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b9eded8..1261f8d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2917,7 +2917,7 @@ static int mwl8k_stop_wt(struct work_struct *wt)
 	return rc;
 }
 
-static void mwl8k_stop(struct ieee80211_hw *hw)
+static void mwl8k_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	int rc;
 	struct mwl8k_stop_worker *worker;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index c9a0545..43b5940 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -190,7 +190,7 @@ out:
 	return err;
 }
 
-static void p54_stop(struct ieee80211_hw *dev)
+static void p54_stop(struct ieee80211_hw *dev, struct cfg80211_wow *wow)
 {
 	struct p54_common *priv = dev->priv;
 	int i;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 71f37cb..e2701fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -953,7 +953,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
  */
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
-void rt2x00mac_stop(struct ieee80211_hw *hw);
+void rt2x00mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 			    struct ieee80211_if_init_conf *conf);
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b7e0ddd..4522c96 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -179,7 +179,7 @@ int rt2x00mac_start(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_start);
 
-void rt2x00mac_stop(struct ieee80211_hw *hw)
+void rt2x00mac_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 09f46ab..807605c 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -628,7 +628,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	return ret;
 }
 
-static void rtl8180_stop(struct ieee80211_hw *dev)
+static void rtl8180_stop(struct ieee80211_hw *dev, struct cfg80211_wow *wow)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	u8 reg;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index c9b9dbe..fd1e8f8 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -989,7 +989,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static void rtl8187_stop(struct ieee80211_hw *dev)
+static void rtl8187_stop(struct ieee80211_hw *dev, struct cfg80211_wow *wow)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index cf5e054..a87a25a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -376,7 +376,7 @@ out:
 	return ret;
 }
 
-static void wl1251_op_stop(struct ieee80211_hw *hw)
+static void wl1251_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct wl1251 *wl = hw->priv;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 9600b72..70dcf01 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -256,7 +256,7 @@ out:
 	return r;
 }
 
-static void zd_op_stop(struct ieee80211_hw *hw)
+static void zd_op_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7dd67a1..004e6b3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -545,6 +545,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_CHANNEL: the channel/channel_type changed
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
+ * @IEEE80211_CONF_CHANGE_WOW: Wake-on-Wireless LAN triggers have changed
  */
 enum ieee80211_conf_changed {
 	_IEEE80211_CONF_CHANGE_RADIO_ENABLED	= BIT(0),
@@ -555,6 +556,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_WOW		= BIT(9),
 };
 
 static inline __deprecated enum ieee80211_conf_changed
@@ -1294,11 +1296,14 @@ enum ieee80211_ampdu_mlme_action {
  *	Must be implemented.
  *
  * @stop: Called after last netdevice attached to the hardware
- *	is disabled. This should turn off the hardware (at least
- *	it must turn off frame reception.)
- *	May be called right after add_interface if that rejects
- *	an interface.
- *	Must be implemented.
+ *	is disabled or during suspend. This should turn off the
+ *	hardware (at least it must turn off frame reception) unless
+ *	the device wants to enable Wake-on-Wireless-LAN. In order to
+ *	process WoW triggers the radio must be left on and the driver
+ *	must enable the triggers in hardware. This callback may be
+ *	called right after add_interface if that rejects an interface.
+ *	Must be implemented. WoW triggers which should be enabled prior
+ *	suspend are passed in the callback.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
  *	enabled. Because it is not called for monitor mode devices, @start
@@ -1425,7 +1430,7 @@ enum ieee80211_ampdu_mlme_action {
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
-	void (*stop)(struct ieee80211_hw *hw);
+	void (*stop)(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
 	void (*remove_interface)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 52928ad..afa6476 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1138,15 +1138,16 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 }
 
 #ifdef CONFIG_PM
-static int ieee80211_suspend(struct wiphy *wiphy)
+static int ieee80211_suspend(struct wiphy *wiphy, struct cfg80211_wow *wow)
 {
-	return __ieee80211_suspend(wiphy_priv(wiphy));
+	return __ieee80211_suspend(wiphy_priv(wiphy), wow);
 }
 
 static int ieee80211_resume(struct wiphy *wiphy)
 {
 	return __ieee80211_resume(wiphy_priv(wiphy));
 }
+
 #else
 #define ieee80211_suspend NULL
 #define ieee80211_resume NULL
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 96991b6..8985c40 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -115,7 +115,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 	struct ieee80211_local *local = file->private_data;
 
 	rtnl_lock();
-	__ieee80211_suspend(&local->hw);
+	__ieee80211_suspend(&local->hw, NULL);
 	__ieee80211_resume(&local->hw);
 	rtnl_unlock();
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 4100c36..f12488f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -17,10 +17,10 @@ static inline int drv_start(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline void drv_stop(struct ieee80211_local *local)
+static inline void drv_stop(struct ieee80211_local *local, struct cfg80211_wow *wow)
 {
-	local->ops->stop(&local->hw);
-	trace_drv_stop(local);
+	local->ops->stop(&local->hw, wow);
+	trace_drv_stop(local, wow);
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 48c93d1..f83f913 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -51,16 +51,18 @@ TRACE_EVENT(drv_start,
 );
 
 TRACE_EVENT(drv_stop,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct ieee80211_local *local, struct cfg80211_wow *wow),
 
-	TP_ARGS(local),
+	TP_ARGS(local, wow),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		__field(u32, triggers_enabled)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		__entry->triggers_enabled = wow->triggers_enabled;
 	),
 
 	TP_printk(
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6a01771..2ebf56d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -612,6 +612,14 @@ struct ieee80211_local {
 	 */
 	bool quiescing;
 
+	/*
+	 * This will be true if we had enabled PS before going to suspend.
+	 * We use this to help resume restore the PS state to what it was.
+	 * Note that this only makes sense if we're associated and are a
+	 * station.
+	 */
+	bool ps_before_suspend;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
@@ -1035,14 +1043,14 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 int ieee80211_reconfig(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
-int __ieee80211_suspend(struct ieee80211_hw *hw);
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw)
+static inline int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	return 0;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cadb0f6..b5e1c76 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -195,7 +195,7 @@ static int ieee80211_open(struct net_device *dev)
 	 */
 	if (!is_valid_ether_addr(dev->dev_addr)) {
 		if (!local->open_count)
-			drv_stop(local);
+			drv_stop(local, NULL);
 		return -EADDRNOTAVAIL;
 	}
 
@@ -321,7 +321,7 @@ static int ieee80211_open(struct net_device *dev)
 	drv_remove_interface(local, &conf);
  err_stop:
 	if (!local->open_count)
-		drv_stop(local);
+		drv_stop(local, NULL);
  err_del_bss:
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
@@ -532,7 +532,7 @@ static int ieee80211_stop(struct net_device *dev)
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
-		drv_stop(local);
+		drv_stop(local, NULL);
 
 		ieee80211_led_radio(local, false);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 7a549f9..d1918ad 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,7 +6,7 @@
 #include "driver-ops.h"
 #include "led.h"
 
-int __ieee80211_suspend(struct ieee80211_hw *hw)
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -16,6 +16,33 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 
 	ieee80211_scan_cancel(local);
 
+	local->ps_before_suspend = !!(local->hw.conf.flags & IEEE80211_CONF_PS);
+
+	if (wow->triggers_enabled) {
+		if (!local->ps_before_suspend) {
+			local->hw.conf.flags |= IEEE80211_CONF_PS;
+			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		}
+
+		del_timer_sync(&local->dynamic_ps_timer);
+		cancel_work_sync(&local->dynamic_ps_enable_work);
+
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			struct ieee80211_if_managed *ifmgd;
+
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+
+			ifmgd = &sdata->u.mgd;
+			if (!ifmgd->associated)
+				continue;
+
+			if (!local->ps_before_suspend)
+				ieee80211_send_nullfunc(local, sdata, 1);
+		}
+
+	}
+
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
@@ -61,7 +88,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	/* stop hardware - this must stop RX */
 	if (local->open_count) {
 		ieee80211_led_radio(local, false);
-		drv_stop(local);
+		drv_stop(local, wow);
 	}
 
 	/* remove STAs */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fc5584..c6985ce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -970,6 +970,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 */
 	local->suspended = false;
 
+	if (from_suspend && local->ps_before_suspend)
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+
 	/* restart hardware */
 	if (local->open_count) {
 		res = drv_start(local);
@@ -1072,6 +1075,17 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		return 0;
 
 #ifdef CONFIG_PM
+	if (!local->ps_before_suspend) {
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			struct ieee80211_if_managed *ifmgd;
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+			ifmgd = &sdata->u.mgd;
+			if (ifmgd->associated)
+				ieee80211_send_nullfunc(local, sdata, 0);
+		}
+	}
+
 	local->suspended = false;
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-- 
1.6.0.6

