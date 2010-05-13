Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:37653 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0EMFIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 01:08:00 -0400
From: Kiran Divekar <dkiran@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Wed, 12 May 2010 22:07:55 -0700
Subject: [PATCH v2] Libertas: Added callback functions to support SDIO
 suspend/resume.
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C04D61E8CF1@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In suspend() host sleep is activated using already configured
host sleep parameters through wol command, and in resume() host
sleep is cancelled. Earlier priv->fw_ready flag used to reset and
set in suspend and resume handler respectively. Since after suspend
only host goes into sleep state and firmware is always ready, those
changes in flag state are removed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>

Please ignore earlier v1 patch, which was incomplete.
---
 drivers/net/wireless/libertas/cmd.c     |   37 ++++++++++++--
 drivers/net/wireless/libertas/cmdresp.c |   30 ++---------
 drivers/net/wireless/libertas/decl.h    |    2 +-
 drivers/net/wireless/libertas/dev.h     |    6 ++
 drivers/net/wireless/libertas/ethtool.c |   15 +++---
 drivers/net/wireless/libertas/if_sdio.c |   58 ++++++++++++++++++++++
 drivers/net/wireless/libertas/if_usb.c  |    6 ++
 drivers/net/wireless/libertas/main.c    |   79 ++++++++++++++++++++++---------
 8 files changed, 172 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index cdb9b96..0fa6b0e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -70,6 +70,8 @@ static u8 is_command_allowed_in_ps(u16 cmd)
 	switch (cmd) {
 	case CMD_802_11_RSSI:
 		return 1;
+	case CMD_802_11_HOST_SLEEP_CFG:
+		return 1;
 	default:
 		break;
 	}
@@ -185,6 +187,23 @@ out:
 	return ret;
 }
 
+static int lbs_ret_host_sleep_cfg(struct lbs_private *priv, unsigned long dummy,
+			struct cmd_header *resp)
+{
+	lbs_deb_enter(LBS_DEB_CMD);
+	if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
+		priv->is_host_sleep_configured = 0;
+		if (priv->psstate == PS_STATE_FULL_POWER) {
+			priv->is_host_sleep_activated = 0;
+			wake_up_interruptible(&priv->host_sleep_q);
+		}
+	} else {
+		priv->is_host_sleep_configured = 1;
+	}
+	lbs_deb_leave(LBS_DEB_CMD);
+	return 0;
+}
+
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
 		struct wol_config *p_wol_config)
 {
@@ -202,12 +221,11 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
 	else
 		cmd_config.wol_conf.action = CMD_ACT_ACTION_NONE;
 
-	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, &cmd_config);
+	ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_CFG, &cmd_config.hdr,
+			le16_to_cpu(cmd_config.hdr.size),
+			lbs_ret_host_sleep_cfg, 0);
 	if (!ret) {
-		if (criteria) {
-			lbs_deb_cmd("Set WOL criteria to %x\n", criteria);
-			priv->wol_criteria = criteria;
-		} else
+		if (p_wol_config)
 			memcpy((uint8_t *) p_wol_config,
 					(uint8_t *)&cmd_config.wol_conf,
 					sizeof(struct wol_config));
@@ -712,6 +730,10 @@ static void lbs_queue_cmd(struct lbs_private *priv,
 		}
 	}
 
+	if (le16_to_cpu(cmdnode->cmdbuf->command) ==
+			CMD_802_11_WAKEUP_CONFIRM)
+		addtail = 0;
+
 	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	if (addtail)
@@ -1353,6 +1375,11 @@ static void lbs_send_confirmsleep(struct lbs_private *priv)
 	/* We don't get a response on the sleep-confirmation */
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
+	if (priv->is_host_sleep_configured) {
+		priv->is_host_sleep_activated = 1;
+		wake_up_interruptible(&priv->host_sleep_q);
+	}
+
 	/* If nothing to do, go back to sleep (?) */
 	if (!kfifo_len(&priv->event_fifo) && !priv->resp_len[priv->resp_idx])
 		priv->psstate = PS_STATE_SLEEP;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 88f7131..d6c3063 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -17,6 +17,7 @@
 #include "dev.h"
 #include "assoc.h"
 #include "wext.h"
+#include "cmd.h"
 
 /**
  *  @brief This function handles disconnect event. it
@@ -341,32 +342,10 @@ done:
 	return ret;
 }
 
-static int lbs_send_confirmwake(struct lbs_private *priv)
-{
-	struct cmd_header cmd;
-	int ret = 0;
-
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	cmd.command = cpu_to_le16(CMD_802_11_WAKEUP_CONFIRM);
-	cmd.size = cpu_to_le16(sizeof(cmd));
-	cmd.seqnum = cpu_to_le16(++priv->seqnum);
-	cmd.result = 0;
-
-	lbs_deb_hex(LBS_DEB_HOST, "wake confirm", (u8 *) &cmd,
-		sizeof(cmd));
-
-	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
-	if (ret)
-		lbs_pr_alert("SEND_WAKEC_CMD: Host to Card failed for Confirm Wake\n");
-
-	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
-	return ret;
-}
-
 int lbs_process_event(struct lbs_private *priv, u32 event)
 {
 	int ret = 0;
+	struct cmd_header cmd;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
@@ -410,7 +389,10 @@ int lbs_process_event(struct lbs_private *priv, u32 event)
 		if (priv->reset_deep_sleep_wakeup)
 			priv->reset_deep_sleep_wakeup(priv);
 		priv->is_deep_sleep = 0;
-		lbs_send_confirmwake(priv);
+		lbs_cmd_async(priv, CMD_802_11_WAKEUP_CONFIRM, &cmd,
+				sizeof(cmd));
+		priv->is_host_sleep_activated = 0;
+		wake_up_interruptible(&priv->host_sleep_q);
 		break;
 
 	case MACREG_INT_CODE_DEEP_SLEEP_AWAKE:
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 709ffca..61db8bc 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -38,7 +38,7 @@ int lbs_set_mac_address(struct net_device *dev, void *addr);
 void lbs_set_multicast_list(struct net_device *dev);
 
 int lbs_suspend(struct lbs_private *priv);
-void lbs_resume(struct lbs_private *priv);
+int lbs_resume(struct lbs_private *priv);
 
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index a54880e..71c5ad4 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -75,6 +75,7 @@ struct lbs_private {
 
 	/* Deep sleep */
 	int is_deep_sleep;
+	int deep_sleep_required;
 	int is_auto_deep_sleep_enabled;
 	int wakeup_dev_required;
 	int is_activity_detected;
@@ -82,6 +83,11 @@ struct lbs_private {
 	wait_queue_head_t ds_awake_q;
 	struct timer_list auto_deepsleep_timer;
 
+	/* Host sleep*/
+	int is_host_sleep_configured;
+	int is_host_sleep_activated;
+	wait_queue_head_t host_sleep_q;
+
 	/* Hardware access */
 	void *card;
 	u8 fw_ready;
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 3804a58..6a36c99 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -91,23 +91,22 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
 			       struct ethtool_wolinfo *wol)
 {
 	struct lbs_private *priv = dev->ml_priv;
-	uint32_t criteria = 0;
 
 	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
 		return -EOPNOTSUPP;
 
+	priv->wol_criteria = 0;
 	if (wol->wolopts & WAKE_UCAST)
-		criteria |= EHS_WAKE_ON_UNICAST_DATA;
+		priv->wol_criteria |= EHS_WAKE_ON_UNICAST_DATA;
 	if (wol->wolopts & WAKE_MCAST)
-		criteria |= EHS_WAKE_ON_MULTICAST_DATA;
+		priv->wol_criteria |= EHS_WAKE_ON_MULTICAST_DATA;
 	if (wol->wolopts & WAKE_BCAST)
-		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
+		priv->wol_criteria |= EHS_WAKE_ON_BROADCAST_DATA;
 	if (wol->wolopts & WAKE_PHY)
-		criteria |= EHS_WAKE_ON_MAC_EVENT;
+		priv->wol_criteria |= EHS_WAKE_ON_MAC_EVENT;
 	if (wol->wolopts == 0)
-		criteria |= EHS_REMOVE_WAKEUP;
-
-	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
+		priv->wol_criteria |= EHS_REMOVE_WAKEUP;
+	return 0;
 }
 
 const struct ethtool_ops lbs_ethtool_ops = {
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 64dd345..6b1048b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1182,11 +1182,69 @@ static void if_sdio_remove(struct sdio_func *func)
 	lbs_deb_leave(LBS_DEB_SDIO);
 }
 
+static int if_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	int ret;
+	struct if_sdio_card *card = sdio_get_drvdata(func);
+
+	mmc_pm_flag_t flags = sdio_get_host_pm_caps(func);
+
+	lbs_pr_info("%s: suspend: PM flags = 0x%x\n",
+						sdio_func_id(func), flags);
+
+	/* If we aren't being asked to wake on anything, we should bail out
+	 * and let the SD stack power down the card.
+	 */
+	if (card->priv->wol_criteria == 0xffffffff) {
+		lbs_pr_info("Suspend without wake params -- "
+						"powering down card.");
+		return -ENOSYS;
+	}
+
+	if (!(flags & MMC_PM_KEEP_POWER)) {
+		lbs_pr_err("%s: cannot remain alive while host is suspended\n",
+			sdio_func_id(func));
+		return -ENOSYS;
+	}
+
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (ret)
+		return ret;
+
+	ret = lbs_suspend(card->priv);
+	if (ret)
+		return ret;
+
+	return sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+}
+
+static int if_sdio_resume(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct if_sdio_card *card = sdio_get_drvdata(func);
+	int ret;
+
+	lbs_pr_info("%s: resume: we're back\n", sdio_func_id(func));
+
+	ret = lbs_resume(card->priv);
+
+	return ret;
+}
+
+static struct dev_pm_ops if_sdio_pm_ops = {
+	.suspend	= if_sdio_suspend,
+	.resume		= if_sdio_resume,
+};
+
 static struct sdio_driver if_sdio_driver = {
 	.name		= "libertas_sdio",
 	.id_table	= if_sdio_ids,
 	.probe		= if_sdio_probe,
 	.remove		= if_sdio_remove,
+	.drv = {
+		.pm = &if_sdio_pm_ops,
+	},
 };
 
 /*******************************************************************/
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index fcea574..e7a483c 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1047,6 +1047,12 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	if (priv->psstate != PS_STATE_FULL_POWER)
 		return -1;
 
+	if (priv->wol_criteria == 0xffffffff) {
+		lbs_pr_info("Suspend attempt without "
+						"configuring wake params!\n");
+		return -ENOSYS;
+	}
+
 	ret = lbs_suspend(priv);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d35ebca..dcbff80 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -625,16 +625,13 @@ static int lbs_thread(void *data)
 	return 0;
 }
 
-static int lbs_suspend_callback(struct lbs_private *priv, unsigned long dummy,
-				struct cmd_header *cmd)
+static int lbs_ret_host_sleep_activate(struct lbs_private *priv,
+		unsigned long dummy,
+		struct cmd_header *cmd)
 {
 	lbs_deb_enter(LBS_DEB_FW);
-
-	netif_device_detach(priv->dev);
-	if (priv->mesh_dev)
-		netif_device_detach(priv->mesh_dev);
-
-	priv->fw_ready = 0;
+	priv->is_host_sleep_activated = 1;
+	wake_up_interruptible(&priv->host_sleep_q);
 	lbs_deb_leave(LBS_DEB_FW);
 	return 0;
 }
@@ -646,39 +643,67 @@ int lbs_suspend(struct lbs_private *priv)
 
 	lbs_deb_enter(LBS_DEB_FW);
 
-	if (priv->wol_criteria == 0xffffffff) {
-		lbs_pr_info("Suspend attempt without configuring wake params!\n");
-		return -EINVAL;
+	if (priv->is_deep_sleep) {
+		ret = lbs_set_deep_sleep(priv, 0);
+		if (ret) {
+			lbs_pr_err("deep sleep cancellation failed: %d\n", ret);
+			return ret;
+		}
+		priv->deep_sleep_required = 1;
 	}
 
 	memset(&cmd, 0, sizeof(cmd));
+	ret = lbs_host_sleep_cfg(priv, priv->wol_criteria,
+						(struct wol_config *)NULL);
+	if (ret) {
+		lbs_pr_info("Host sleep configuration failed: %d\n", ret);
+		return ret;
+	}
+	if (priv->psstate == PS_STATE_FULL_POWER) {
+		ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
+				sizeof(cmd), lbs_ret_host_sleep_activate, 0);
+		if (ret)
+			lbs_pr_info("HOST_SLEEP_ACTIVATE failed: %d\n", ret);
+	}
 
-	ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
-			sizeof(cmd), lbs_suspend_callback, 0);
-	if (ret)
-		lbs_pr_info("HOST_SLEEP_ACTIVATE failed: %d\n", ret);
+	if (!wait_event_interruptible_timeout(priv->host_sleep_q,
+				priv->is_host_sleep_activated, (10 * HZ))) {
+		lbs_pr_err("host_sleep_q: timer expired\n");
+		ret = -1;
+	}
+	netif_device_detach(priv->dev);
+	if (priv->mesh_dev)
+		netif_device_detach(priv->mesh_dev);
 
 	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lbs_suspend);
 
-void lbs_resume(struct lbs_private *priv)
+int lbs_resume(struct lbs_private *priv)
 {
+	int ret;
+
 	lbs_deb_enter(LBS_DEB_FW);
 
-	priv->fw_ready = 1;
+	priv->wol_criteria |= EHS_REMOVE_WAKEUP;
 
-	/* Firmware doesn't seem to give us RX packets any more
-	   until we send it some command. Might as well update */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-				     0, 0, NULL);
+	ret = lbs_host_sleep_cfg(priv, priv->wol_criteria,
+					(struct wol_config *)NULL);
 
 	netif_device_attach(priv->dev);
 	if (priv->mesh_dev)
 		netif_device_attach(priv->mesh_dev);
 
-	lbs_deb_leave(LBS_DEB_FW);
+	if (priv->deep_sleep_required) {
+		priv->deep_sleep_required = 0;
+		ret = lbs_set_deep_sleep(priv, 1);
+		if (ret)
+			lbs_pr_err("deep sleep activation failed: %d\n", ret);
+	}
+
+	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(lbs_resume);
 
@@ -834,10 +859,13 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;
 	priv->is_auto_deep_sleep_enabled = 0;
+	priv->deep_sleep_required = 0;
 	priv->wakeup_dev_required = 0;
 	init_waitqueue_head(&priv->ds_awake_q);
 	priv->authtype_auto = 1;
-
+	priv->is_host_sleep_configured = 0;
+	priv->is_host_sleep_activated = 0;
+	init_waitqueue_head(&priv->host_sleep_q);
 	mutex_init(&priv->lock);
 
 	setup_timer(&priv->command_timer, lbs_cmd_timeout_handler,
@@ -976,6 +1004,7 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 
 	priv->wol_criteria = 0xffffffff;
 	priv->wol_gpio = 0xff;
+	priv->wol_gap = 20;
 
 	goto done;
 
@@ -1031,6 +1060,10 @@ void lbs_remove_card(struct lbs_private *priv)
 		wake_up_interruptible(&priv->ds_awake_q);
 	}
 
+	priv->is_host_sleep_configured = 0;
+	priv->is_host_sleep_activated = 0;
+	wake_up_interruptible(&priv->host_sleep_q);
+
 	/* Stop the thread servicing the interrupts */
 	priv->surpriseremoved = 1;
 	kthread_stop(priv->main_thread);
-- 
1.5.3.4

