Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58695 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1IULF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 07:05:59 -0400
Received: by fxe4 with SMTP id 4so1496002fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 04:05:58 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: add ieee80211_vif param to tsf functions
Date: Wed, 21 Sep 2011 14:06:11 +0300
Message-Id: <1316603171-26288-1-git-send-email-eliad@wizery.com> (sfid-20110921_130605_467429_AD224FBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TSF can be kept per vif.
Add ieee80211_vif param to set/get/reset_tsf, and move
the debugfs entries to the per-vif directory.

Update all the drivers that implement these callbacks.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/adm8211.c                   |    3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c    |    6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c    |    9 +++-
 drivers/net/wireless/ath/ath9k/main.c            |    8 ++-
 drivers/net/wireless/ath/carl9170/main.c         |    3 +-
 drivers/net/wireless/b43/main.c                  |    5 +-
 drivers/net/wireless/iwlegacy/iwl-core.c         |    3 +-
 drivers/net/wireless/iwlegacy/iwl-core.h         |    3 +-
 drivers/net/wireless/rt2x00/rt2400pci.c          |    5 +-
 drivers/net/wireless/rt2x00/rt2500pci.c          |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.h          |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c            |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c            |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c       |    5 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c       |    2 +-
 drivers/net/wireless/rtlwifi/core.c              |    8 ++-
 drivers/net/wireless/wl12xx/main.c               |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c           |    2 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   12 +++--
 drivers/staging/winbond/wbusb.c                  |    2 +-
 include/net/mac80211.h                           |    7 ++-
 net/mac80211/debugfs.c                           |   52 ----------------------
 net/mac80211/debugfs_netdev.c                    |   48 +++++++++++++++++++-
 net/mac80211/driver-ops.h                        |   22 +++++----
 net/mac80211/driver-trace.h                      |   26 +++++++----
 net/mac80211/ibss.c                              |    4 +-
 27 files changed, 137 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 43ebc44..3b752d9 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1249,7 +1249,8 @@ static int adm8211_hw_reset(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static u64 adm8211_get_tsft(struct ieee80211_hw *dev)
+static u64 adm8211_get_tsft(struct ieee80211_hw *dev,
+			    struct ieee80211_vif *vif)
 {
 	struct adm8211_priv *priv = dev->priv;
 	u32 tsftl;
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 0560234..bba4f6f 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -602,7 +602,7 @@ ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 
 static u64
-ath5k_get_tsf(struct ieee80211_hw *hw)
+ath5k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath5k_hw *ah = hw->priv;
 
@@ -611,7 +611,7 @@ ath5k_get_tsf(struct ieee80211_hw *hw)
 
 
 static void
-ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+ath5k_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u64 tsf)
 {
 	struct ath5k_hw *ah = hw->priv;
 
@@ -620,7 +620,7 @@ ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 
 
 static void
-ath5k_reset_tsf(struct ieee80211_hw *hw)
+ath5k_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath5k_hw *ah = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b9de151..b33dcc2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1564,7 +1564,8 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
-static u64 ath9k_htc_get_tsf(struct ieee80211_hw *hw)
+static u64 ath9k_htc_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	u64 tsf;
@@ -1578,7 +1579,8 @@ static u64 ath9k_htc_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void ath9k_htc_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void ath9k_htc_set_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u64 tsf)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
@@ -1589,7 +1591,8 @@ static void ath9k_htc_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 	mutex_unlock(&priv->mutex);
 }
 
-static void ath9k_htc_reset_tsf(struct ieee80211_hw *hw)
+static void ath9k_htc_reset_tsf(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dacac57..d50b2cf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2162,7 +2162,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	ath9k_ps_restore(sc);
 }
 
-static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
+static u64 ath9k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = hw->priv;
 	u64 tsf;
@@ -2176,7 +2176,9 @@ static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void ath9k_set_tsf(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
+			  u64 tsf)
 {
 	struct ath_softc *sc = hw->priv;
 
@@ -2187,7 +2189,7 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 	mutex_unlock(&sc->mutex);
 }
 
-static void ath9k_reset_tsf(struct ieee80211_hw *hw)
+static void ath9k_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = hw->priv;
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index af351ec..8b780d6 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1078,7 +1078,8 @@ out:
 	mutex_unlock(&ar->mutex);
 }
 
-static u64 carl9170_op_get_tsf(struct ieee80211_hw *hw)
+static u64 carl9170_op_get_tsf(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif)
 {
 	struct ar9170 *ar = hw->priv;
 	struct carl9170_tsf_rsp tsf;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6bca727..3563af6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3596,7 +3596,7 @@ static int b43_op_get_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
+static u64 b43_op_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -3615,7 +3615,8 @@ static u64 b43_op_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void b43_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void b43_op_set_tsf(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif, u64 tsf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 35cd253..c492191 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2220,7 +2220,8 @@ out:
 }
 EXPORT_SYMBOL(iwl_legacy_mac_config);
 
-void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw)
+void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 84da793..b2df01c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -620,7 +620,8 @@ static inline const struct ieee80211_supported_band *iwl_get_hw_mode(
 
 /* mac80211 handlers */
 int iwl_legacy_mac_config(struct ieee80211_hw *hw, u32 changed);
-void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw);
+void iwl_legacy_mac_reset_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif);
 void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index daa32fc..7e9272b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1239,7 +1239,7 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 	 * call, we must decrease the higher 32bits with 1 to get
 	 * to correct value.
 	 */
-	tsf = rt2x00dev->ops->hw->get_tsf(rt2x00dev->hw);
+	tsf = rt2x00dev->ops->hw->get_tsf(rt2x00dev->hw, NULL);
 	rx_low = rt2x00_get_field32(word4, RXD_W4_RX_END_TIME);
 	rx_high = upper_32_bits(tsf);
 
@@ -1673,7 +1673,8 @@ static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
-static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw)
+static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b46c3b8..dcc0e1f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1966,7 +1966,8 @@ static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw)
+static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ef67f67..dada07f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4389,7 +4389,7 @@ int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 }
 EXPORT_SYMBOL_GPL(rt2800_conf_tx);
 
-u64 rt2800_get_tsf(struct ieee80211_hw *hw)
+u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 69deb31..1052be8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -196,7 +196,7 @@ void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
 int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 		   const struct ieee80211_tx_queue_params *params);
-u64 rt2800_get_tsf(struct ieee80211_hw *hw);
+u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 058ef4b..6b6a8e2 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2940,7 +2940,7 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	return 0;
 }
 
-static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
+static u64 rt61pci_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0baeb89..6f51e39 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2279,7 +2279,7 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	return 0;
 }
 
-static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
+static u64 rt73usb_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	u64 tsf;
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 66b29dc..0082015 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -669,7 +669,8 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 		rtl8180_free_tx_ring(dev, i);
 }
 
-static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
+static u64 rtl8180_get_tsf(struct ieee80211_hw *dev,
+			   struct ieee80211_vif *vif)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
@@ -701,7 +702,7 @@ static void rtl8180_beacon_work(struct work_struct *work)
 	 * TODO: make hardware update beacon timestamp
 	 */
 	mgmt = (struct ieee80211_mgmt *)skb->data;
-	mgmt->u.beacon.timestamp = cpu_to_le64(rtl8180_get_tsf(dev));
+	mgmt->u.beacon.timestamp = cpu_to_le64(rtl8180_get_tsf(dev, vif));
 
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 1e0be14..f5afa15 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1277,7 +1277,7 @@ static int rtl8187_conf_tx(struct ieee80211_hw *dev, u16 queue,
 	return 0;
 }
 
-static u64 rtl8187_get_tsf(struct ieee80211_hw *dev)
+static u64 rtl8187_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 04c4e9e..21e40f6 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -775,7 +775,7 @@ out:
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
-static u64 rtl_op_get_tsf(struct ieee80211_hw *hw)
+static u64 rtl_op_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u64 tsf;
@@ -784,7 +784,8 @@ static u64 rtl_op_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void rtl_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void rtl_op_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   u64 tsf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -794,7 +795,8 @@ static void rtl_op_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CORRECT_TSF, (u8 *) (&bibss));
 }
 
-static void rtl_op_reset_tsf(struct ieee80211_hw *hw)
+static void rtl_op_reset_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8 tmp = 0;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 680f558..9adfc5b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3702,7 +3702,8 @@ out:
 	return ret;
 }
 
-static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw)
+static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 
 	struct wl1271 *wl = hw->priv;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index cabfae1..0a70149 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1332,7 +1332,7 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 }
 
-static u64 zd_op_get_tsf(struct ieee80211_hw *hw)
+static u64 zd_op_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	return zd_chip_get_tsf(&mac->chip);
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index d6de44e..315dd91 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -133,7 +133,8 @@ static int brcms_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 			  bool set);
 static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw);
 static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw);
-static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf);
+static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u64 tsf);
 static int brcms_ops_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats);
 static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
@@ -142,7 +143,8 @@ static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta);
 static int brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *params);
-static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw);
+static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
 static int brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 static int brcms_ops_sta_remove(struct ieee80211_hw *hw,
@@ -516,7 +518,8 @@ static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw)
 	return;
 }
 
-static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void brcms_ops_set_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, u64 tsf)
 {
 	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return;
@@ -565,7 +568,8 @@ brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return 0;
 }
 
-static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw)
+static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return 0;
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3724e1e..a2e8bd4 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -277,7 +277,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
-static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
+static u64 wbsoft_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
 {
 	printk("wbsoft_get_tsf called\n");
 	return 0;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5e5029b..1ef42c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1989,9 +1989,10 @@ struct ieee80211_ops {
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
-	u64 (*get_tsf)(struct ieee80211_hw *hw);
-	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
-	void (*reset_tsf)(struct ieee80211_hw *hw);
+	u64 (*get_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
+	void (*set_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			u64 tsf);
+	void (*reset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index c914116..883996b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -78,57 +78,6 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
-static ssize_t tsf_read(struct file *file, char __user *user_buf,
-			     size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	u64 tsf;
-
-	tsf = drv_get_tsf(local);
-
-	return mac80211_format_buffer(user_buf, count, ppos, "0x%016llx\n",
-				      (unsigned long long) tsf);
-}
-
-static ssize_t tsf_write(struct file *file,
-                         const char __user *user_buf,
-                         size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	unsigned long long tsf;
-	char buf[100];
-	size_t len;
-
-	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
-	buf[len] = '\0';
-
-	if (strncmp(buf, "reset", 5) == 0) {
-		if (local->ops->reset_tsf) {
-			drv_reset_tsf(local);
-			wiphy_info(local->hw.wiphy, "debugfs reset TSF\n");
-		}
-	} else {
-		tsf = simple_strtoul(buf, NULL, 0);
-		if (local->ops->set_tsf) {
-			drv_set_tsf(local, tsf);
-			wiphy_info(local->hw.wiphy,
-				   "debugfs set TSF to %#018llx\n", tsf);
-
-		}
-	}
-
-	return count;
-}
-
-static const struct file_operations tsf_ops = {
-	.read = tsf_read,
-	.write = tsf_write,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
-
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -447,7 +396,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(frequency);
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
-	DEBUGFS_ADD(tsf);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
 	DEBUGFS_ADD(noack);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6e8eab7..d344892 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -21,6 +21,7 @@
 #include "rate.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
+#include "driver-ops.h"
 
 static ssize_t ieee80211_if_read(
 	struct ieee80211_sub_if_data *sdata,
@@ -331,6 +332,46 @@ static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 }
 __IEEE80211_IF_FILE(num_buffered_multicast, NULL);
 
+/* IBSS attributes */
+static ssize_t ieee80211_if_fmt_tsf(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+	u64 tsf;
+
+	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
+
+	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
+}
+
+static ssize_t ieee80211_if_parse_tsf(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+	unsigned long long tsf;
+	int ret;
+
+	if (strncmp(buf, "reset", 5) == 0) {
+		if (local->ops->reset_tsf) {
+			drv_reset_tsf(local, sdata);
+			wiphy_info(local->hw.wiphy, "debugfs reset TSF\n");
+		}
+	} else {
+		ret = kstrtoull(buf, 10, &tsf);
+		if (ret < 0)
+			return -EINVAL;
+		if (local->ops->set_tsf) {
+			drv_set_tsf(local, sdata, tsf);
+			wiphy_info(local->hw.wiphy,
+				   "debugfs set TSF to %#018llx\n", tsf);
+		}
+	}
+
+	return buflen;
+}
+__IEEE80211_IF_FILE_W(tsf);
+
+
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
@@ -419,6 +460,11 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
+static void add_ibss_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD_MODE(tsf, 0600);
+}
+
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
@@ -512,7 +558,7 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 		add_sta_files(sdata);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		/* XXX */
+		add_ibss_files(sdata);
 		break;
 	case NL80211_IFTYPE_AP:
 		add_ap_files(sdata);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9001ff3..5e5d973 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -427,36 +427,40 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
-static inline u64 drv_get_tsf(struct ieee80211_local *local)
+static inline u64 drv_get_tsf(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata)
 {
 	u64 ret = -1ULL;
 
 	might_sleep();
 
-	trace_drv_get_tsf(local);
+	trace_drv_get_tsf(local, sdata);
 	if (local->ops->get_tsf)
-		ret = local->ops->get_tsf(&local->hw);
+		ret = local->ops->get_tsf(&local->hw, &sdata->vif);
 	trace_drv_return_u64(local, ret);
 	return ret;
 }
 
-static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
+static inline void drv_set_tsf(struct ieee80211_local *local,
+			       struct ieee80211_sub_if_data *sdata,
+			       u64 tsf)
 {
 	might_sleep();
 
-	trace_drv_set_tsf(local, tsf);
+	trace_drv_set_tsf(local, sdata, tsf);
 	if (local->ops->set_tsf)
-		local->ops->set_tsf(&local->hw, tsf);
+		local->ops->set_tsf(&local->hw, &sdata->vif, tsf);
 	trace_drv_return_void(local);
 }
 
-static inline void drv_reset_tsf(struct ieee80211_local *local)
+static inline void drv_reset_tsf(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata)
 {
 	might_sleep();
 
-	trace_drv_reset_tsf(local);
+	trace_drv_reset_tsf(local, sdata);
 	if (local->ops->reset_tsf)
-		local->ops->reset_tsf(&local->hw);
+		local->ops->reset_tsf(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index f47b00d..07d94ff 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -726,35 +726,41 @@ TRACE_EVENT(drv_conf_tx,
 	)
 );
 
-DEFINE_EVENT(local_only_evt, drv_get_tsf,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+DEFINE_EVENT(local_sdata_evt, drv_get_tsf,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_set_tsf,
-	TP_PROTO(struct ieee80211_local *local, u64 tsf),
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u64 tsf),
 
-	TP_ARGS(local, tsf),
+	TP_ARGS(local, sdata, tsf),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(u64, tsf)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->tsf = tsf;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " tsf:%llu",
-		LOCAL_PR_ARG, (unsigned long long)__entry->tsf
+		LOCAL_PR_FMT  VIF_PR_FMT  " tsf:%llu",
+		LOCAL_PR_ARG, VIF_PR_ARG, (unsigned long long)__entry->tsf
 	)
 );
 
-DEFINE_EVENT(local_only_evt, drv_reset_tsf,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+DEFINE_EVENT(local_sdata_evt, drv_reset_tsf,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56c24ca..b0b7b1f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -81,7 +81,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	lockdep_assert_held(&ifibss->mtx);
 
 	/* Reset own TSF to allow time synchronization work. */
-	drv_reset_tsf(local);
+	drv_reset_tsf(local, sdata);
 
 	skb = ifibss->skb;
 	rcu_assign_pointer(ifibss->presp, NULL);
@@ -382,7 +382,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		 * second best option: get current TSF
 		 * (will return -1 if not supported)
 		 */
-		rx_timestamp = drv_get_tsf(local);
+		rx_timestamp = drv_get_tsf(local, sdata);
 	}
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-- 
1.7.6.401.g6a319

