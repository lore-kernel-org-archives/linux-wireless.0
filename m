Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45650 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbdJ0LdG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 07:33:06 -0400
Received: by mail-pg0-f65.google.com with SMTP id b192so5093756pga.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 04:33:05 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 2/3] rsi: sdio: Add WOWLAN support for S4 hibernate state
Date: Fri, 27 Oct 2017 16:55:56 +0530
Message-Id: <1509103557-6215-3-git-send-email-amitkarwar@gmail.com> (sfid-20171027_133312_347519_206A0967)
In-Reply-To: <1509103557-6215-1-git-send-email-amitkarwar@gmail.com>
References: <1509103557-6215-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

We are disabling of interrupts from firmware in freeze handler.
Also setting power management capability KEEP_MMC_POWER to make
device wakeup for WoWLAN trigger.
At restore, we observed a device reset on some platforms. Hence
reloading of firmware and device initialization is performed.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |   2 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |   9 +++
 drivers/net/wireless/rsi/rsi_91x_main.c     |   1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 111 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_main.h         |   4 +
 drivers/net/wireless/rsi/rsi_sdio.h         |   1 +
 7 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 87e023d..d0d2201 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -276,6 +276,8 @@ void rsi_core_qos_processor(struct rsi_common *common)
 			rsi_dbg(DATA_TX_ZONE, "%s: No More Pkt\n", __func__);
 			break;
 		}
+		if (common->hibernate_resume)
+			break;
 
 		mutex_lock(&common->tx_lock);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index c3bd3ca..95eb5e6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include "rsi_debugfs.h"
 #include "rsi_mgmt.h"
+#include "rsi_sdio.h"
 #include "rsi_common.h"
 #include "rsi_ps.h"
 
@@ -325,6 +326,11 @@ static int rsi_mac80211_start(struct ieee80211_hw *hw)
 
 	rsi_dbg(ERR_ZONE, "===> Interface UP <===\n");
 	mutex_lock(&common->mutex);
+	if (common->hibernate_resume) {
+		common->reinit_hw = true;
+		adapter->host_intf_ops->reinit_device(adapter);
+		wait_for_completion(&adapter->priv->wlan_init_completion);
+	}
 	common->iface_down = false;
 	wiphy_rfkill_start_polling(hw->wiphy);
 	rsi_send_rx_filter_frame(common, 0);
@@ -1846,6 +1852,9 @@ static int rsi_mac80211_resume(struct ieee80211_hw *hw)
 
 	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
 
+	if (common->hibernate_resume)
+		return 0;
+
 	mutex_lock(&common->mutex);
 	rsi_send_wowlan_request(common, 0, 0);
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 2a1fbb7..0cb8e68 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -263,6 +263,7 @@ struct rsi_hw *rsi_91x_init(void)
 	rsi_default_ps_params(adapter);
 	spin_lock_init(&adapter->ps_lock);
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
+	init_completion(&common->wlan_init_completion);
 	common->init_done = true;
 	return adapter;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 1446ee3..d38a09f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1761,7 +1761,11 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 			common->bb_rf_prog_count--;
 			if (!common->bb_rf_prog_count) {
 				common->fsm_state = FSM_MAC_INIT_DONE;
-				return rsi_mac80211_attach(common);
+				if (common->reinit_hw) {
+					complete(&common->wlan_init_completion);
+				} else {
+					return rsi_mac80211_attach(common);
+				}
 			}
 		} else {
 			rsi_dbg(INFO_ZONE,
@@ -1839,6 +1843,7 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 	case TA_CONFIRM_TYPE:
 		return rsi_handle_ta_confirm_type(common, msg);
 	case CARD_READY_IND:
+		common->hibernate_resume = false;
 		rsi_dbg(FSM_ZONE, "%s: Card ready indication received\n",
 			__func__);
 		return rsi_handle_card_ready(common, msg);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index fa6af7b..3f683d8 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -880,6 +880,7 @@ static struct rsi_host_intf_ops sdio_host_intf_ops = {
 	.master_reg_read	= rsi_sdio_master_reg_read,
 	.master_reg_write	= rsi_sdio_master_reg_write,
 	.load_data_master_write	= rsi_sdio_load_data_master_write,
+	.reinit_device          = rsi_sdio_reinit_device,
 };
 
 /**
@@ -936,6 +937,8 @@ static int rsi_probe(struct sdio_func *pfunction,
 		return -EIO;
 	}
 
+	adapter->priv->hibernate_resume = false;
+	adapter->priv->reinit_hw = false;
 	return 0;
 fail:
 	rsi_91x_deinit(adapter);
@@ -1198,9 +1201,117 @@ static int rsi_resume(struct device *dev)
 	return 0;
 }
 
+static int rsi_freeze(struct device *dev)
+{
+	int ret;
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common;
+	struct rsi_91x_sdiodev *sdev;
+
+	rsi_dbg(INFO_ZONE, "SDIO Bus freeze ===>\n");
+
+	if (!adapter) {
+		rsi_dbg(ERR_ZONE, "Device is not ready\n");
+		return -ENODEV;
+	}
+	common = adapter->priv;
+	sdev = (struct rsi_91x_sdiodev *)adapter->rsi_dev;
+
+#ifdef CONFIG_RSI_WOW
+	if ((common->wow_flags & RSI_WOW_ENABLED) &&
+	    (common->wow_flags & RSI_WOW_NO_CONNECTION))
+		rsi_dbg(ERR_ZONE,
+			"##### Device can not wake up through WLAN\n");
+#endif
+	ret = rsi_sdio_disable_interrupts(pfunction);
+
+	if (sdev->write_fail)
+		rsi_dbg(INFO_ZONE, "###### Device is not ready #######\n");
+
+	ret = rsi_set_sdio_pm_caps(adapter);
+	if (ret)
+		rsi_dbg(INFO_ZONE, "Setting power management caps failed\n");
+
+	rsi_dbg(INFO_ZONE, "***** RSI module freezed *****\n");
+
+	return 0;
+}
+
+static int rsi_thaw(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(ERR_ZONE, "SDIO Bus thaw =====>\n");
+
+	common->hibernate_resume = true;
+	common->fsm_state = FSM_CARD_NOT_READY;
+	common->iface_down = true;
+
+	rsi_sdio_enable_interrupts(pfunction);
+
+	rsi_dbg(INFO_ZONE, "***** RSI module thaw done *****\n");
+
+	return 0;
+}
+
+int rsi_sdio_reinit_device(struct rsi_hw *adapter)
+{
+	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
+	struct sdio_func *pfunction = sdev->pfunction;
+	int ii;
+
+	for (ii = 0; ii < NUM_SOFT_QUEUES; ii++)
+		skb_queue_purge(&adapter->priv->tx_queue[ii]);
+
+	/* Initialize device again */
+	sdio_claim_host(pfunction);
+
+	sdio_release_irq(pfunction);
+	rsi_reset_card(pfunction);
+
+	sdio_enable_func(pfunction);
+	rsi_setupcard(adapter);
+	rsi_init_sdio_slave_regs(adapter);
+	sdio_claim_irq(pfunction, rsi_handle_interrupt);
+	rsi_hal_device_init(adapter);
+
+	sdio_release_host(pfunction);
+
+	return 0;
+}
+
+static int rsi_restore(struct device *dev)
+{
+	struct sdio_func *pfunction = dev_to_sdio_func(dev);
+	struct rsi_hw *adapter = sdio_get_drvdata(pfunction);
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(INFO_ZONE, "SDIO Bus restore ======>\n");
+	common->hibernate_resume = true;
+	common->fsm_state = FSM_FW_NOT_LOADED;
+	common->iface_down = true;
+
+	adapter->sc_nvifs = 0;
+	ieee80211_restart_hw(adapter->hw);
+
+#ifdef CONFIG_RSI_WOW
+	common->wow_flags = 0;
+#endif
+	common->iface_down = false;
+
+	rsi_dbg(INFO_ZONE, "RSI module restored\n");
+
+	return 0;
+}
 static const struct dev_pm_ops rsi_pm_ops = {
 	.suspend = rsi_suspend,
 	.resume = rsi_resume,
+	.freeze = rsi_freeze,
+	.thaw = rsi_thaw,
+	.restore = rsi_restore,
 };
 #endif
 
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 44a199f..8cab630 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -214,6 +214,7 @@ struct rsi_common {
 
 	struct rsi_thread tx_thread;
 	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 2];
+	struct completion wlan_init_completion;
 	/* Mutex declaration */
 	struct mutex mutex;
 	/* Mutex used for tx thread */
@@ -272,6 +273,8 @@ struct rsi_common {
 	u8 obm_ant_sel_val;
 	int tx_power;
 	u8 ant_in_use;
+	bool hibernate_resume;
+	bool reinit_hw;
 	u8 wow_flags;
 	u16 beacon_interval;
 	u8 dtim_cnt;
@@ -362,5 +365,6 @@ struct rsi_host_intf_ops {
 	int (*load_data_master_write)(struct rsi_hw *adapter, u32 addr,
 				      u32 instructions_size, u16 block_size,
 				      u8 *fw);
+	int (*reinit_device)(struct rsi_hw *adapter);
 };
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 49c549b..8fbf90e 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -131,4 +131,5 @@ int rsi_sdio_master_access_msword(struct rsi_hw *adapter, u16 ms_word);
 void rsi_sdio_ack_intr(struct rsi_hw *adapter, u8 int_bit);
 int rsi_sdio_determine_event_timeout(struct rsi_hw *adapter);
 int rsi_sdio_check_buffer_status(struct rsi_hw *adapter, u8 q_num);
+int rsi_sdio_reinit_device(struct rsi_hw *adapter);
 #endif
-- 
2.7.4
