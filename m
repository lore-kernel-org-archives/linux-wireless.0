Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0LRJ3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 04:29:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 01:29:15 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/2] ath9k_htc: Fix unnecessary warnings on card removal
Date: Sat, 18 Dec 2010 14:59:07 +0530
Message-ID: <1292664547-5474-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid register read/write operations when
the card is unplaugged. Otherwise results in
unnecessary warnings.

usb 1-1: USB disconnect, address 10
ath: Failed to wakeup in 500us
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/hw.c:1616
ath9k_hw_setpower+0x61f/0x630 [ath9k_hw]()
Pid: 1830, comm: khubd Tainted: G        W   2.6.37-rc5-wl #33
Call Trace:
[<ffffffff8105018a>] warn_slowpath_common+0x7a/0xb0
[<ffffffffa0621c90>] ? ath9k_regwrite+0x0/0x190 [ath9k_htc]
[<ffffffff810501d5>] warn_slowpath_null+0x15/0x20
[<ffffffffa05d06ef>] ath9k_hw_setpower+0x61f/0x630 [ath9k_hw]
[<ffffffffa061f25c>] ath9k_htc_ps_wakeup+0x5c/0x60 [ath9k_htc]
[<ffffffffa062082e>] ath9k_htc_remove_interface+0x4e/0xe0 [ath9k_htc]
[<ffffffff81345329>] ? mutex_unlock+0x9/0x10
[<ffffffffa055bbe7>] ? ieee80211_free_keys+0x87/0xa0 [mac80211]
[<ffffffffa054e845>] ieee80211_do_stop+0x4f5/0x540 [mac80211]
[<ffffffff8134678f>] ? _raw_spin_unlock_bh+0x1f/0x30
[<ffffffff812b6983>] ? dev_deactivate+0x1c3/0x1e0
[<ffffffffa054e8a5>] ieee80211_stop+0x15/0x20 [mac80211]
[<ffffffff8129d226>] __dev_close+0x56/0x90
[<ffffffff8129d27a>] dev_close+0x1a/0x50

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 ++----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   24 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/wmi.c          |    2 +-
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fdf9d5f..d90838a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -339,7 +339,6 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_ASSOCIATED		   BIT(7)
 #define OP_ENABLE_BEACON	   BIT(8)
 #define OP_LED_DEINIT		   BIT(9)
-#define OP_UNPLUGGED		   BIT(10)
 #define OP_BT_PRIORITY_DETECTED	   BIT(11)
 #define OP_BT_SCAN		   BIT(12)
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 0f6be35..8a73dc2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -632,6 +632,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	ah->hw_version.subsysid = 0; /* FIXME */
 	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
+	ah->ah_flags &= ~AH_UNPLUGGED;
 	priv->ah = ah;
 
 	common = ath9k_hw_common(ah);
@@ -851,9 +852,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
-	/* The device may have been unplugged earlier. */
-	priv->op_flags &= ~OP_UNPLUGGED;
-
 	ret = ath9k_init_device(priv, devid, product, drv_info);
 	if (ret)
 		goto err_init;
@@ -873,7 +871,7 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 
 		/* Check if the device has been yanked out. */
 		if (hotunplug)
-			htc_handle->drv_priv->op_flags |= OP_UNPLUGGED;
+			htc_handle->drv_priv->ah->ah_flags |= AH_UNPLUGGED;
 
 		ath9k_deinit_device(htc_handle->drv_priv);
 		ath9k_deinit_wmi(htc_handle->drv_priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index dd17909..f6e64c9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1110,6 +1110,11 @@ static int ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ath9k_htc_priv *priv = hw->priv;
 	int padpos, padsize, ret;
 
+	if (priv->ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_ANY,
+			"Device no present, can not xmit\n");
+		goto fail_tx;
+	}
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	/* Add the padding after the header if this is not already done */
@@ -1231,6 +1236,12 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
 	ath9k_led_stop_brightness(priv);
 
+	if (ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -1348,6 +1359,11 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
 	mutex_lock(&priv->mutex);
+	if (priv->ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(common, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
 	ath9k_htc_ps_wakeup(priv);
 
 	memset(&hvif, 0, sizeof(struct ath9k_htc_target_vif));
@@ -1471,11 +1487,17 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	u32 rfilt;
 
 	mutex_lock(&priv->mutex);
-	ath9k_htc_ps_wakeup(priv);
 
 	changed_flags &= SUPPORTED_FILTERS;
 	*total_flags &= SUPPORTED_FILTERS;
 
+	if (priv->ah->ah_flags & AH_UNPLUGGED) {
+		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_ANY,
+			"Device not present\n");
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+	ath9k_htc_ps_wakeup(priv);
 	priv->rxfilter = *total_flags;
 	rfilt = ath9k_htc_calcrxfilter(priv);
 	ath9k_hw_setrxfilter(priv->ah, rfilt);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 8f42ea7..8f42d42 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -250,7 +250,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	int time_left, ret = 0;
 	unsigned long flags;
 
-	if (wmi->drv_priv->op_flags & OP_UNPLUGGED)
+	if (wmi->drv_priv->ah->ah_flags & AH_UNPLUGGED)
 		return 0;
 
 	skb = alloc_skb(headroom + cmd_len, GFP_ATOMIC);
-- 
1.7.3.3

