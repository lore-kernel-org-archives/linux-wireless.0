Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34200 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1IYRHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 13:07:04 -0400
Received: by eya28 with SMTP id 28so3096778eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 10:07:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
Date: Sun, 25 Sep 2011 20:06:55 +0300
Message-Id: <1316970415-23239-3-git-send-email-eliad@wizery.com> (sfid-20110925_190724_392119_D7C5583F)
In-Reply-To: <1316970415-23239-1-git-send-email-eliad@wizery.com>
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx params should be configured per interface.
Add ieee80211_vif param to the conf_tx callback,
and update all the drivers that use this callback.

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
 drivers/net/wireless/ath/ath5k/mac80211-ops.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c    |    3 ++-
 drivers/net/wireless/ath/ath9k/main.c            |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c         |    3 ++-
 drivers/net/wireless/b43/main.c                  |    3 ++-
 drivers/net/wireless/b43legacy/main.c            |    3 ++-
 drivers/net/wireless/mac80211_hwsim.c            |    3 ++-
 drivers/net/wireless/mwl8k.c                     |    3 ++-
 drivers/net/wireless/p54/main.c                  |    3 ++-
 drivers/net/wireless/rt2x00/rt2400pci.c          |    3 ++-
 drivers/net/wireless/rt2x00/rt61pci.c            |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c            |    3 ++-
 drivers/net/wireless/rtl818x/rtl8187/dev.c       |    3 ++-
 drivers/net/wireless/rtlwifi/core.c              |    3 ++-
 drivers/net/wireless/wl1251/main.c               |    3 ++-
 drivers/net/wireless/wl12xx/main.c               |    3 ++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    7 ++++---
 include/net/mac80211.h                           |    3 ++-
 net/mac80211/driver-ops.h                        |    3 ++-
 19 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 0560234..0fbfc72 100644
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
index 495fdf6..d56a154 100644
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
index ee39702..0601579 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1843,7 +1843,8 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
-static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int ath9k_conf_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct ath_softc *sc = hw->priv;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index af351ec..e390a8e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1304,7 +1304,8 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int carl9170_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif, u16 queue,
 			       const struct ieee80211_tx_queue_params *param)
 {
 	struct ar9170 *ar = hw->priv;
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 56fa3a3..29b86d4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3552,7 +3552,8 @@ static void b43_qos_init(struct b43_wldev *dev)
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
index ea1395a..2428895 100644
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
index daa32fc..1946060 100644
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
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 058ef4b..5438bb4 100644
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
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0baeb89..1a6b68b 100644
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
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 1e0be14..c106742 100644
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
index 04c4e9e..05c27c9 100644
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
index a51dd0e..60e2869 100644
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
index d6de44e..d03f0cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -140,8 +140,9 @@ static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum sta_notify_cmd cmd,
 			      struct ieee80211_sta *sta);
-static int brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
-			  const struct ieee80211_tx_queue_params *params);
+static int brcms_ops_conf_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif, u16 queue,
+			     const struct ieee80211_tx_queue_params *params);
 static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw);
 static int brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
@@ -553,7 +554,7 @@ brcms_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static int
-brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
+brcms_ops_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
 {
 	struct brcms_info *wl = hw->priv;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c0f63fd..b8ecba7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1998,7 +1998,8 @@ struct ieee80211_ops {
 			  struct ieee80211_sta *sta);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
-	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
+	int (*conf_tx)(struct ieee80211_hw *hw,
+		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5315a5d..d998b24 100644
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

