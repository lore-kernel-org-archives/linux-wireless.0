Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1JBIPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 04:15:36 -0400
Received: by bkbzt4 with SMTP id zt4so3855346bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Oct 2011 01:15:34 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: pass vif param to conf_tx() callback
Date: Sun,  2 Oct 2011 10:15:52 +0200
Message-Id: <1317543352-29019-1-git-send-email-eliad@wizery.com> (sfid-20111002_101552_130579_7FDA5164)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx params should be configured per interface.
add ieee80211_vif param to the conf_tx callback,
and change all the drivers that use this callback.

The following spatch was used:
@rule1@
struct ieee80211_ops ops;
identifier conf_tx_op;
@@
	ops.conf_tx = conf_tx_op;

@rule2@
identifier rule1.conf_tx_op;
identifier hw, queue, params;
@@
	conf_tx_op (
-		struct ieee80211_hw *hw,
+		struct ieee80211_hw *hw, struct ieee80211_vif *vif,
		u16 queue,
		const struct ieee80211_tx_queue_params *params) {...}

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: fixed some drivers i missed, rebased

 drivers/net/wireless/ath/ath5k/mac80211-ops.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c    |    3 ++-
 drivers/net/wireless/ath/ath9k/main.c            |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c         |    3 ++-
 drivers/net/wireless/b43/main.c                  |    3 ++-
 drivers/net/wireless/b43legacy/main.c            |    3 ++-
 drivers/net/wireless/iwlegacy/iwl-core.c         |    3 ++-
 drivers/net/wireless/iwlegacy/iwl-core.h         |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.c          |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-core.h          |    3 ++-
 drivers/net/wireless/mac80211_hwsim.c            |    3 ++-
 drivers/net/wireless/mwl8k.c                     |    5 +++--
 drivers/net/wireless/p54/main.c                  |    3 ++-
 drivers/net/wireless/rt2x00/rt2400pci.c          |    5 +++--
 drivers/net/wireless/rt2x00/rt2800lib.c          |    5 +++--
 drivers/net/wireless/rt2x00/rt2800lib.h          |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00.h             |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c          |    3 ++-
 drivers/net/wireless/rt2x00/rt61pci.c            |    5 +++--
 drivers/net/wireless/rt2x00/rt73usb.c            |    5 +++--
 drivers/net/wireless/rtl818x/rtl8187/dev.c       |    3 ++-
 drivers/net/wireless/rtlwifi/core.c              |    3 ++-
 drivers/net/wireless/wl1251/main.c               |    3 ++-
 drivers/net/wireless/wl12xx/main.c               |    3 ++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    7 ++++---
 include/net/mac80211.h                           |    3 ++-
 net/mac80211/driver-ops.h                        |    3 ++-
 27 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index bba4f6f..6ed4c07 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -563,7 +563,7 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 
 
 static int
-ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
+ath5k_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	      const struct ieee80211_tx_queue_params *params)
 {
 	struct ath5k_hw *ah = hw->priv;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 17dbbd9..0b9a0e8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1352,7 +1352,8 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0ebf732..9883186 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1842,7 +1842,8 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
-static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int ath9k_conf_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct ath_softc *sc = hw->priv;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 8b780d6..beca710 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1305,7 +1305,8 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int carl9170_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif, u16 queue,
 			       const struct ieee80211_tx_queue_params *param)
 {
 	struct ar9170 *ar = hw->priv;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 43400fb..7cf4125 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3559,7 +3559,8 @@ static void b43_qos_init(struct b43_wldev *dev)
 	b43dbg(dev->wl, "QoS enabled\n");
 }
 
-static int b43_op_conf_tx(struct ieee80211_hw *hw, u16 _queue,
+static int b43_op_conf_tx(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif, u16 _queue,
 			  const struct ieee80211_tx_queue_params *params)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 468d183..a3b72cd 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2466,7 +2466,8 @@ out:
 	}
 }
 
-static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif, u16 queue,
 				const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 8928d47..2bd5659 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1250,7 +1250,8 @@ void iwl_legacy_clear_isr_stats(struct iwl_priv *priv)
 	memset(&priv->isr_stats, 0, sizeof(priv->isr_stats));
 }
 
-int iwl_legacy_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+int iwl_legacy_mac_conf_tx(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index b2df01c..d1271fe 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -286,7 +286,8 @@ struct iwl_cfg {
  ***************************/
 
 struct ieee80211_hw *iwl_legacy_alloc_all(struct iwl_cfg *cfg);
-int iwl_legacy_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+int iwl_legacy_mac_conf_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_legacy_mac_tx_last_beacon(struct ieee80211_hw *hw);
 void iwl_legacy_set_rxon_hwcrypto(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index fc400bb..0725603 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1123,8 +1123,9 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			   const struct ieee80211_tx_queue_params *params)
+int iwl_mac_conf_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif, u16 queue,
+		    const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_rxon_context *ctx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e55ffad..db50b65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -236,7 +236,8 @@ struct iwl_cfg {
  *   L i b                 *
  ***************************/
 
-int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+int iwl_mac_conf_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif, u16 queue,
 		    const struct ieee80211_tx_queue_params *params);
 int iwl_mac_tx_last_beacon(struct ieee80211_hw *hw);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 34b79fc..68455a2 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -970,7 +970,8 @@ static int mac80211_hwsim_set_tim(struct ieee80211_hw *hw,
 }
 
 static int mac80211_hwsim_conf_tx(
-	struct ieee80211_hw *hw, u16 queue,
+	struct ieee80211_hw *hw,
+	struct ieee80211_vif *vif, u16 queue,
 	const struct ieee80211_tx_queue_params *params)
 {
 	wiphy_debug(hw->wiphy,
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ea1395a..995695c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4915,7 +4915,8 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int mwl8k_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int mwl8k_conf_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -5462,7 +5463,7 @@ static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image)
 		goto fail;
 
 	for (i = 0; i < MWL8K_TX_WMM_QUEUES; i++) {
-		rc = mwl8k_conf_tx(hw, i, &priv->wmm_params[i]);
+		rc = mwl8k_conf_tx(hw, NULL, i, &priv->wmm_params[i]);
 		if (rc)
 			goto fail;
 	}
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 726a934..ad9ae04 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -404,7 +404,8 @@ static void p54_configure_filter(struct ieee80211_hw *dev,
 		p54_set_groupfilter(priv);
 }
 
-static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
+static int p54_conf_tx(struct ieee80211_hw *dev,
+		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 7e9272b..3a6b402 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1648,7 +1648,8 @@ static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int rt2400pci_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1661,7 +1662,7 @@ static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	if (queue != 0)
 		return -EINVAL;
 
-	if (rt2x00mac_conf_tx(hw, queue, params))
+	if (rt2x00mac_conf_tx(hw, vif, queue, params))
 		return -EINVAL;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9688dd0..3f183a1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4398,7 +4398,8 @@ int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 }
 EXPORT_SYMBOL_GPL(rt2800_set_rts_threshold);
 
-int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+int rt2800_conf_tx(struct ieee80211_hw *hw,
+		   struct ieee80211_vif *vif, u16 queue_idx,
 		   const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -4414,7 +4415,7 @@ int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	 * we are free to update the registers based on the value
 	 * in the queue parameter.
 	 */
-	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	retval = rt2x00mac_conf_tx(hw, vif, queue_idx, params);
 	if (retval)
 		return retval;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 6de128e..8c3c281 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -197,7 +197,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev);
 void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
 			 u16 *iv16);
 int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
-int rt2800_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+int rt2800_conf_tx(struct ieee80211_hw *hw,
+		   struct ieee80211_vif *vif, u16 queue_idx,
 		   const struct ieee80211_tx_queue_params *params);
 u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index cbf8eb3..2ec5c00 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1299,7 +1299,8 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_bss_conf *bss_conf,
 				u32 changes);
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_vif *vif, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
 void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index cef1c87..bf0acff 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -713,7 +713,8 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_vif *vif, u16 queue_idx,
 		      const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6b6a8e2..bf55b4a 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2883,7 +2883,8 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+static int rt61pci_conf_tx(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif, u16 queue_idx,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -2899,7 +2900,7 @@ static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	 * we are free to update the registers based on the value
 	 * in the queue parameter.
 	 */
-	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	retval = rt2x00mac_conf_tx(hw, vif, queue_idx, params);
 	if (retval)
 		return retval;
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6f51e39..cfb19db 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2222,7 +2222,8 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+static int rt73usb_conf_tx(struct ieee80211_hw *hw,
+			   struct ieee80211_vif *vif, u16 queue_idx,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -2238,7 +2239,7 @@ static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	 * we are free to update the registers based on the value
 	 * in the queue parameter.
 	 */
-	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	retval = rt2x00mac_conf_tx(hw, vif, queue_idx, params);
 	if (retval)
 		return retval;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index f5afa15..24873b5 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1241,7 +1241,8 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
 
-static int rtl8187_conf_tx(struct ieee80211_hw *dev, u16 queue,
+static int rtl8187_conf_tx(struct ieee80211_hw *dev,
+			   struct ieee80211_vif *vif, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct rtl8187_priv *priv = dev->priv;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 21e40f6..3f0f056 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -504,7 +504,8 @@ static int _rtl_get_hal_qnum(u16 queue)
  *for mac80211 VO=0, VI=1, BE=2, BK=3
  *for rtl819x  BE=0, BK=1, VI=2, VO=3
  */
-static int rtl_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int rtl_op_conf_tx(struct ieee80211_hw *hw,
+		   struct ieee80211_vif *vif, u16 queue,
 		   const struct ieee80211_tx_queue_params *param)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index a14a48c..ba3268e 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -1158,7 +1158,8 @@ static struct ieee80211_channel wl1251_channels[] = {
 	{ .hw_value = 13, .center_freq = 2472},
 };
 
-static int wl1251_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int wl1251_op_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	enum wl1251_acx_ps_scheme ps_scheme;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7d409b0..e2d6edd2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3744,7 +3744,8 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct wl1271 *wl = hw->priv;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 315dd91..6d71cba 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -141,8 +141,9 @@ static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum sta_notify_cmd cmd,
 			      struct ieee80211_sta *sta);
-static int brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			  const struct ieee80211_tx_queue_params *params);
+static int brcms_ops_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
+			     const struct ieee80211_tx_queue_params *params);
 static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 static int brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
@@ -556,7 +557,7 @@ brcms_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static int
-brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
+brcms_ops_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
 {
 	struct brcms_info *wl = hw->priv;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bc79930..9880c43 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2148,7 +2148,8 @@ struct ieee80211_ops {
 			  struct ieee80211_sta *sta);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
-	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
+	int (*conf_tx)(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	u64 (*get_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*set_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 68721d37..5f165d7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -423,7 +423,8 @@ static inline int drv_conf_tx(struct ieee80211_local *local,
 
 	trace_drv_conf_tx(local, sdata, queue, params);
 	if (local->ops->conf_tx)
-		ret = local->ops->conf_tx(&local->hw, queue, params);
+		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
+					  queue, params);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
-- 
1.7.6.401.g6a319

