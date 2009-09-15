Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42661 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZIOXWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:22:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
Date: Tue, 15 Sep 2009 16:45:59 -0700
Message-Id: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Add timer based auto deep sleep feature in libertas driver which can be
configured through debugfs interface. This is tested on SD8688, SD8686 cards
with firmware versions 10.38.1.p25, 9.70.4.p0 respectively on 32-bit and 64-bit
platforms. Tests have been done for USB/CS cards to make sure that the patch
won't break USB/CS code. We didn't test the if_spi driver.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/README    |   28 +++++-
 drivers/net/wireless/libertas/cmd.c     |   72 +++++++++++++-
 drivers/net/wireless/libertas/cmdresp.c |   12 +++
 drivers/net/wireless/libertas/debugfs.c |  160 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/decl.h    |    4 +
 drivers/net/wireless/libertas/dev.h     |   18 ++++
 drivers/net/wireless/libertas/host.h    |    1 +
 drivers/net/wireless/libertas/if_cs.c   |    3 +
 drivers/net/wireless/libertas/if_sdio.c |   56 +++++++++++
 drivers/net/wireless/libertas/if_sdio.h |    3 +-
 drivers/net/wireless/libertas/if_spi.c  |    3 +
 drivers/net/wireless/libertas/if_usb.c  |    3 +
 drivers/net/wireless/libertas/main.c    |  111 +++++++++++++++++++---
 drivers/net/wireless/libertas/scan.c    |   11 ++
 drivers/net/wireless/libertas/wext.c    |  138 ++++++++++++++++++++++++++
 15 files changed, 604 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index ab6a2d5..059ce8c 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -1,5 +1,5 @@
 ================================================================================
-			README for USB8388
+			README for Libertas
 
  (c) Copyright © 2003-2006, Marvell International Ltd.
  All Rights Reserved
@@ -226,4 +226,30 @@ setuserscan
     All entries in the scan table (not just the new scan data when keep=1)
     will be displayed upon completion by use of the getscantable ioctl.
 
+deepsleep
+
+	This command is used to configure the station in deep sleep mode/auto
+	deep sleep mode. Command expects two parameters:
+	'state'	'idle time period'
+
+	The timer is implemented to monitor the activities (command, event,
+        data, etc.). When an activity is detected station will exit from deep
+        sleep mode automatically and restart the timer. At timer expiry (no
+        activity for defined time period) the deepsleep mode is entered
+        automatically.
+
+	Note: this command is for SDIO interface only.
+
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
+
+	Usage:
+	To read the current status of deep sleep do:
+		cat deepsleep
+	To enable deep sleep mode do:
+		echo '1 0' > deepsleep
+	To enable auto deep sleep mode with idle time period 5 seconds do:
+		echo '1 5000' > deepsleep
+	To disable deep sleep/auto deep sleep mode do:
+		echo '0 0' > deepsleep
+
 ==============================================================================
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6850981..3a3e894 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -17,7 +17,6 @@
 
 static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv);
 
-
 /**
  *  @brief Simple callback that copies response back into command
  *
@@ -319,6 +318,60 @@ int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 	return 0;
 }
 
+static int lbs_wait_for_ds_awake(struct lbs_private *priv)
+{
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (priv->is_deep_sleep) {
+		if (!wait_event_interruptible_timeout(priv->ds_awake_q,
+					!priv->is_deep_sleep, (10 * HZ))) {
+			lbs_pr_err("ds_awake_q: timer expired\n");
+			ret = -1;
+		}
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep)
+{
+	int ret =  0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (deep_sleep) {
+		if (priv->is_deep_sleep != 1) {
+			lbs_deb_cmd("deep sleep: sleep\n");
+			BUG_ON(!priv->enter_deep_sleep);
+			ret = priv->enter_deep_sleep(priv);
+			if (!ret) {
+				netif_stop_queue(priv->dev);
+				netif_carrier_off(priv->dev);
+			}
+		} else {
+			lbs_pr_err("deep sleep: already enabled\n");
+		}
+	} else {
+		if (priv->is_deep_sleep) {
+			lbs_deb_cmd("deep sleep: wakeup\n");
+			BUG_ON(!priv->exit_deep_sleep);
+			ret = priv->exit_deep_sleep(priv);
+			if (!ret) {
+				ret = lbs_wait_for_ds_awake(priv);
+				if (ret)
+					lbs_pr_err("deep sleep: wakeup"
+							"failed\n");
+			}
+		}
+	}
+
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
 int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
 			   struct assoc_request *assoc)
 {
@@ -1242,8 +1295,17 @@ static void lbs_submit_command(struct lbs_private *priv,
 		timeo = HZ/4;
 	}
 
-	/* Setup the timer after transmit command */
-	mod_timer(&priv->command_timer, jiffies + timeo);
+	if (command == CMD_802_11_DEEP_SLEEP) {
+		if (priv->is_auto_deep_sleep_enabled) {
+			priv->wakeup_dev_required = 1;
+			priv->dnld_sent = 0;
+		}
+		priv->is_deep_sleep = 1;
+		lbs_complete_command(priv, cmdnode, 0);
+	} else {
+		/* Setup the timer after transmit command */
+		mod_timer(&priv->command_timer, jiffies + timeo);
+	}
 
 	lbs_deb_leave(LBS_DEB_HOST);
 }
@@ -1505,6 +1567,10 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 	case CMD_802_11_BEACON_CTRL:
 		ret = lbs_cmd_bcn_ctrl(priv, cmdptr, cmd_action);
 		break;
+	case CMD_802_11_DEEP_SLEEP:
+		cmdptr->command = cpu_to_le16(CMD_802_11_DEEP_SLEEP);
+		cmdptr->size = cpu_to_le16(S_DS_GEN);
+		break;
 	default:
 		lbs_pr_err("PREP_CMD: unknown command 0x%04x\n", cmd_no);
 		ret = -1;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index c42d3fa..47d2b19 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -504,9 +504,21 @@ int lbs_process_event(struct lbs_private *priv, u32 event)
 
 	case MACREG_INT_CODE_HOST_AWAKE:
 		lbs_deb_cmd("EVENT: host awake\n");
+		if (priv->reset_deep_sleep_wakeup)
+			priv->reset_deep_sleep_wakeup(priv);
+		priv->is_deep_sleep = 0;
 		lbs_send_confirmwake(priv);
 		break;
 
+	case MACREG_INT_CODE_DEEP_SLEEP_AWAKE:
+		if (priv->reset_deep_sleep_wakeup)
+			priv->reset_deep_sleep_wakeup(priv);
+		lbs_deb_cmd("EVENT: ds awake\n");
+		priv->is_deep_sleep = 0;
+		priv->wakeup_dev_required = 0;
+		wake_up_interruptible(&priv->ds_awake_q);
+		break;
+
 	case MACREG_INT_CODE_PS_AWAKE:
 		lbs_deb_cmd("EVENT: ps awake\n");
 		/* handle unexpected PS AWAKE event */
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 893a55c..624a438 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -117,6 +117,11 @@ static ssize_t lbs_sleepparams_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, user_buf, buf_size)) {
 		ret = -EFAULT;
@@ -157,6 +162,11 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	ret = lbs_cmd_802_11_sleep_params(priv, CMD_ACT_GET, &sp);
 	if (ret)
 		goto out_unlock;
@@ -173,6 +183,118 @@ out_unlock:
 	return ret;
 }
 
+static ssize_t lbs_deepsleep_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	struct lbs_private *priv = file->private_data;
+	ssize_t pos = 0;
+	int ret;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (!priv->enter_deep_sleep) {
+		lbs_pr_err("deep sleep feature is not implemented "
+				"for this interface driver\n");
+		ret = -EINVAL;
+		goto out_ds;
+	}
+
+	if (priv->is_auto_deep_sleep_enabled)
+		pos += snprintf(buf, len, "%d %d\n",
+				priv->is_auto_deep_sleep_enabled,
+				priv->auto_deep_sleep_timeout);
+	else if (priv->is_deep_sleep)
+		pos += snprintf(buf, len, "%d %d\n",
+				priv->is_deep_sleep,
+				priv->auto_deep_sleep_timeout);
+	else
+		pos += snprintf(buf, len, "%d %d\n",
+				priv->is_deep_sleep,
+				priv->auto_deep_sleep_timeout);
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+
+out_ds:
+	free_page(addr);
+	return ret;
+}
+
+static ssize_t lbs_deepsleep_write(struct file *file,
+				    const char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	struct lbs_private *priv = file->private_data;
+	ssize_t res, buf_size;
+	int is_deep_sleep, auto_deep_sleep_timeout;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (!priv->enter_deep_sleep) {
+		lbs_pr_err("deep sleep feature is not implemented "
+				"for this interface driver\n");
+		res = -EINVAL;
+		goto out_ds;
+	}
+
+	if (priv->connect_status == LBS_CONNECTED) {
+		lbs_pr_err("can't use deep sleep cmd in connected "
+				"state\n");
+		res = -EINVAL;
+		goto out_ds;
+	}
+
+	buf_size = min(count, len - 1);
+	if (copy_from_user(buf, userbuf, buf_size)) {
+		res = -EFAULT;
+		goto out_ds;
+	}
+
+	res = sscanf(buf, "%d %d", &is_deep_sleep, &auto_deep_sleep_timeout);
+	if ((res != 2) || (!is_deep_sleep && auto_deep_sleep_timeout) ||
+					!((is_deep_sleep == 1) ||
+					(is_deep_sleep == 0))) {
+		lbs_pr_err("unknown option\n");
+		res = -EINVAL;
+		goto out_ds;
+	}
+
+	if (auto_deep_sleep_timeout) {
+		if (!priv->is_auto_deep_sleep_enabled) {
+			priv->is_activity_detected = 0;
+			priv->auto_deep_sleep_timeout = auto_deep_sleep_timeout;
+			lbs_enter_auto_deep_sleep(priv);
+		} else {
+			priv->auto_deep_sleep_timeout = auto_deep_sleep_timeout;
+			lbs_deb_debugfs("auto deep sleep: already enabled\n");
+		}
+	} else {
+		if (priv->is_auto_deep_sleep_enabled) {
+			lbs_exit_auto_deep_sleep(priv);
+			/* Try to exit deep sleep if auto deep sleep disabled */
+			res = lbs_set_deep_sleep(priv, 0);
+			if (res)
+				goto out_ds;
+		}
+		if ((is_deep_sleep == 0) || (is_deep_sleep == 1)) {
+			res = lbs_set_deep_sleep(priv, is_deep_sleep);
+			if (res)
+				goto out_ds;
+		}
+	}
+
+	res = count;
+
+out_ds:
+	free_page(addr);
+	return res;
+}
+
 /*
  * When calling CMD_802_11_SUBSCRIBE_EVENT with CMD_ACT_GET, me might
  * get a bunch of vendor-specific TLVs (a.k.a. IEs) back from the
@@ -223,6 +345,9 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	u8 freq;
 	int events = 0;
 
+	if (!lbs_is_cmd_allowed(priv))
+		return -EBUSY;
+
 	buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -275,6 +400,9 @@ static ssize_t lbs_threshold_write(uint16_t tlv_type, uint16_t event_mask,
 	char *buf;
 	int ret;
 
+	if (!lbs_is_cmd_allowed(priv))
+		return -EBUSY;
+
 	buf = (char *)get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
@@ -444,6 +572,11 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		free_page(addr);
+		return -EBUSY;
+	}
+
 	offval.offset = priv->mac_offset;
 	offval.value = 0;
 
@@ -496,6 +629,11 @@ static ssize_t lbs_wrmac_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		res = -EBUSY;
+		goto out_unlock;
+	}
+
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
@@ -532,6 +670,11 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		free_page(addr);
+		return -EBUSY;
+	}
+
 	offval.offset = priv->bbp_offset;
 	offval.value = 0;
 
@@ -585,6 +728,11 @@ static ssize_t lbs_wrbbp_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		res = -EBUSY;
+		goto out_unlock;
+	}
+
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
@@ -621,6 +769,11 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		free_page(addr);
+		return -EBUSY;
+	}
+
 	offval.offset = priv->rf_offset;
 	offval.value = 0;
 
@@ -674,6 +827,11 @@ static ssize_t lbs_wrrf_write(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		res = -EBUSY;
+		goto out_unlock;
+	}
+
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
@@ -717,6 +875,8 @@ static const struct lbs_debugfs_files debugfs_files[] = {
 					write_file_dummy), },
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
+	{ "deepsleep", 0644, FOPS(lbs_deepsleep_read,
+				lbs_deepsleep_write), },
 };
 
 static const struct lbs_debugfs_files debugfs_events_files[] = {
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 0b84bdc..34b475f 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -33,6 +33,10 @@ int lbs_execute_next_command(struct lbs_private *priv);
 int lbs_process_event(struct lbs_private *priv, u32 event);
 void lbs_queue_event(struct lbs_private *priv, u32 event);
 void lbs_notify_command_response(struct lbs_private *priv, u8 resp_idx);
+int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
+int lbs_is_cmd_allowed(struct lbs_private *priv);
+int lbs_enter_auto_deep_sleep(struct lbs_private *priv);
+int lbs_exit_auto_deep_sleep(struct lbs_private *priv);
 
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 578c697..e2b4ef2 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -129,6 +129,20 @@ struct lbs_private {
 	u32 bbp_offset;
 	u32 rf_offset;
 
+	/** Deep sleep flag */
+	int is_deep_sleep;
+	/** Auto deep sleep enabled flag */
+	int is_auto_deep_sleep_enabled;
+	/** Device wakeup required flag */
+	int wakeup_dev_required;
+	/** Auto deep sleep flag*/
+	int is_activity_detected;
+	/** Auto deep sleep timeout (in miliseconds) */
+	int auto_deep_sleep_timeout;
+
+	/** Deep sleep wait queue */
+	wait_queue_head_t       ds_awake_q;
+
 	/* Download sent:
 	   bit0 1/0=data_sent/data_tx_done,
 	   bit1 1/0=cmd_sent/cmd_tx_done,
@@ -154,6 +168,9 @@ struct lbs_private {
 	/** Hardware access */
 	int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *payload, u16 nb);
 	void (*reset_card) (struct lbs_private *priv);
+	int (*enter_deep_sleep) (struct lbs_private *priv);
+	int (*exit_deep_sleep) (struct lbs_private *priv);
+	int (*reset_deep_sleep_wakeup) (struct lbs_private *priv);
 
 	/* Wake On LAN */
 	uint32_t wol_criteria;
@@ -204,6 +221,7 @@ struct lbs_private {
 
 	/** Timers */
 	struct timer_list command_timer;
+	struct timer_list auto_deepsleep_timer;
 	int nr_retries;
 	int cmd_timed_out;
 
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index fe8f0cb..c055daa 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -57,6 +57,7 @@
 #define CMD_802_11_ENABLE_RSN			0x002f
 #define CMD_802_11_SET_AFC			0x003c
 #define CMD_802_11_GET_AFC			0x003d
+#define CMD_802_11_DEEP_SLEEP                  0x003e
 #define CMD_802_11_AD_HOC_STOP			0x0040
 #define CMD_802_11_HOST_SLEEP_CFG		0x0043
 #define CMD_802_11_WAKEUP_CONFIRM		0x0044
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 6238176..465742f 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -946,6 +946,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	card->priv = priv;
 	priv->card = card;
 	priv->hw_host_to_card = if_cs_host_to_card;
+	priv->enter_deep_sleep = NULL;
+	priv->exit_deep_sleep = NULL;
+	priv->reset_deep_sleep_wakeup = NULL;
 	priv->fw_ready = 1;
 
 	/* Now actually get the IRQ */
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 485a8d4..9716728 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -831,6 +831,58 @@ out:
 	return ret;
 }
 
+static int if_sdio_enter_deep_sleep(struct lbs_private *priv)
+{
+	int ret = -1;
+	struct cmd_header cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	lbs_deb_sdio("send DEEP_SLEEP command\n");
+	ret = __lbs_cmd(priv, CMD_802_11_DEEP_SLEEP, &cmd, sizeof(cmd),
+			lbs_cmd_copyback, (unsigned long) &cmd);
+	if (ret)
+		lbs_pr_err("DEEP_SLEEP cmd failed\n");
+
+	mdelay(200);
+	return ret;
+}
+
+static int if_sdio_exit_deep_sleep(struct lbs_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret = -1;
+
+	lbs_deb_enter(LBS_DEB_SDIO);
+	sdio_claim_host(card->func);
+
+	sdio_writeb(card->func, HOST_POWER_UP, CONFIGURATION_REG, &ret);
+	if (ret)
+		lbs_pr_err("sdio_writeb failed!\n");
+
+	sdio_release_host(card->func);
+	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
+	return ret;
+}
+
+static int if_sdio_reset_deep_sleep_wakeup(struct lbs_private *priv)
+{
+	struct if_sdio_card *card = priv->card;
+	int ret = -1;
+
+	lbs_deb_enter(LBS_DEB_SDIO);
+	sdio_claim_host(card->func);
+
+	sdio_writeb(card->func, 0, CONFIGURATION_REG, &ret);
+	if (ret)
+		lbs_pr_err("sdio_writeb failed!\n");
+
+	sdio_release_host(card->func);
+	lbs_deb_leave_args(LBS_DEB_SDIO, "ret %d", ret);
+	return ret;
+
+}
+
 /*******************************************************************/
 /* SDIO callbacks                                                  */
 /*******************************************************************/
@@ -859,6 +911,7 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	 * Ignore the define name, this really means the card has
 	 * successfully received the command.
 	 */
+	card->priv->is_activity_detected = 1;
 	if (cause & IF_SDIO_H_INT_DNLD)
 		lbs_host_to_card_done(card->priv);
 
@@ -998,6 +1051,9 @@ static int if_sdio_probe(struct sdio_func *func,
 
 	priv->card = card;
 	priv->hw_host_to_card = if_sdio_host_to_card;
+	priv->enter_deep_sleep = if_sdio_enter_deep_sleep;
+	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
+	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
 
 	priv->fw_ready = 1;
 
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index 60c9b2f..12179c1 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -51,5 +51,6 @@
 #define IF_SDIO_EVENT           0x80fc
 
 #define IF_SDIO_BLOCK_SIZE	256
-
+#define CONFIGURATION_REG               0x03
+#define HOST_POWER_UP                   (0x1U << 1)
 #endif
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 446e327..e2fa657 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -1117,6 +1117,9 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 	card->priv = priv;
 	priv->card = card;
 	priv->hw_host_to_card = if_spi_host_to_card;
+	priv->enter_deep_sleep = NULL;
+	priv->exit_deep_sleep = NULL;
+	priv->reset_deep_sleep_wakeup = NULL;
 	priv->fw_ready = 1;
 
 	/* Initialize interrupt handling stuff. */
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 92bc8c5..a8262de 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -300,6 +300,9 @@ static int if_usb_probe(struct usb_interface *intf,
 	cardp->priv->fw_ready = 1;
 
 	priv->hw_host_to_card = if_usb_host_to_card;
+	priv->enter_deep_sleep = NULL;
+	priv->exit_deep_sleep = NULL;
+	priv->reset_deep_sleep_wakeup = NULL;
 #ifdef CONFIG_OLPC
 	if (machine_is_olpc())
 		priv->reset_card = if_usb_reset_olpc_card;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 8df1cfd..3b14fcc 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -574,8 +574,10 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* Wake main thread if commands are pending */
-	if (!priv->cur_cmd || priv->tx_pending_len > 0)
-		wake_up_interruptible(&priv->waitq);
+	if (!priv->cur_cmd || priv->tx_pending_len > 0) {
+		if (!priv->wakeup_dev_required)
+			wake_up_interruptible(&priv->waitq);
+	}
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -770,7 +772,8 @@ static int lbs_thread(void *data)
 			shouldsleep = 0;	/* We have a command response */
 		else if (priv->cur_cmd)
 			shouldsleep = 1;	/* Can't send a command; one already running */
-		else if (!list_empty(&priv->cmdpendingq))
+		else if (!list_empty(&priv->cmdpendingq) &&
+					!(priv->wakeup_dev_required))
 			shouldsleep = 0;	/* We have a command to send */
 		else if (__kfifo_len(priv->event_fifo))
 			shouldsleep = 0;	/* We have an event to process */
@@ -822,6 +825,26 @@ static int lbs_thread(void *data)
 		}
 		spin_unlock_irq(&priv->driver_lock);
 
+		/* Process hardware events, e.g. card removed, link lost */
+		spin_lock_irq(&priv->driver_lock);
+		while (__kfifo_len(priv->event_fifo)) {
+			u32 event;
+			__kfifo_get(priv->event_fifo, (unsigned char *) &event,
+				sizeof(event));
+			spin_unlock_irq(&priv->driver_lock);
+			lbs_process_event(priv, event);
+			spin_lock_irq(&priv->driver_lock);
+		}
+		spin_unlock_irq(&priv->driver_lock);
+
+		if (priv->wakeup_dev_required) {
+			lbs_deb_thread("Waking up device...\n");
+			/* Wake up device */
+			if (priv->exit_deep_sleep(priv))
+				lbs_deb_thread("Wakeup device failed\n");
+			continue;
+		}
+
 		/* command timeout stuff */
 		if (priv->cmd_timed_out && priv->cur_cmd) {
 			struct cmd_ctrl_node *cmdnode = priv->cur_cmd;
@@ -849,18 +872,7 @@ static int lbs_thread(void *data)
 		}
 		priv->cmd_timed_out = 0;
 
-		/* Process hardware events, e.g. card removed, link lost */
-		spin_lock_irq(&priv->driver_lock);
-		while (__kfifo_len(priv->event_fifo)) {
-			u32 event;
 
-			__kfifo_get(priv->event_fifo, (unsigned char *) &event,
-				sizeof(event));
-			spin_unlock_irq(&priv->driver_lock);
-			lbs_process_event(priv, event);
-			spin_lock_irq(&priv->driver_lock);
-		}
-		spin_unlock_irq(&priv->driver_lock);
 
 		if (!priv->fw_ready)
 			continue;
@@ -894,6 +906,9 @@ static int lbs_thread(void *data)
 		    (priv->psstate == PS_STATE_PRE_SLEEP))
 			continue;
 
+		if (priv->is_deep_sleep)
+			continue;
+
 		/* Execute the next command */
 		if (!priv->dnld_sent && !priv->cur_cmd)
 			lbs_execute_next_command(priv);
@@ -928,6 +943,7 @@ static int lbs_thread(void *data)
 	}
 
 	del_timer(&priv->command_timer);
+	del_timer(&priv->auto_deepsleep_timer);
 	wake_up_all(&priv->cmd_pending);
 
 	lbs_deb_leave(LBS_DEB_THREAD);
@@ -1050,6 +1066,60 @@ out:
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
+/**
+ *  This function put the device back to deep sleep mode when timer expires
+ *  and no activity (command, event, data etc.) is detected.
+ */
+static void auto_deepsleep_timer_fn(unsigned long data)
+{
+	struct lbs_private *priv = (struct lbs_private *)data;
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (priv->is_activity_detected) {
+		priv->is_activity_detected = 0;
+	} else {
+		if (priv->is_auto_deep_sleep_enabled &&
+				(!priv->wakeup_dev_required) &&
+				(priv->connect_status != LBS_CONNECTED)) {
+			lbs_deb_main("Entering auto deep sleep mode...\n");
+			ret = lbs_prepare_and_send_command(priv,
+					CMD_802_11_DEEP_SLEEP, 0,
+					0, 0, NULL);
+		}
+	}
+	mod_timer(&priv->auto_deepsleep_timer , jiffies +
+				(priv->auto_deep_sleep_timeout * HZ)/1000);
+	lbs_deb_leave(LBS_DEB_CMD);
+}
+
+int lbs_enter_auto_deep_sleep(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_SDIO);
+
+	priv->is_auto_deep_sleep_enabled = 1;
+	if (priv->is_deep_sleep)
+		priv->wakeup_dev_required = 1;
+	mod_timer(&priv->auto_deepsleep_timer ,
+			jiffies + (priv->auto_deep_sleep_timeout * HZ)/1000);
+
+	lbs_deb_leave(LBS_DEB_SDIO);
+	return 0;
+}
+
+int lbs_exit_auto_deep_sleep(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_SDIO);
+
+	priv->is_auto_deep_sleep_enabled = 0;
+	priv->auto_deep_sleep_timeout = 0;
+	del_timer(&priv->auto_deepsleep_timer);
+
+	lbs_deb_leave(LBS_DEB_SDIO);
+	return 0;
+}
+
 static void lbs_sync_channel_worker(struct work_struct *work)
 {
 	struct lbs_private *priv = container_of(work, struct lbs_private,
@@ -1099,11 +1169,17 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
+	priv->is_deep_sleep = 0;
+	priv->is_auto_deep_sleep_enabled = 0;
+	priv->wakeup_dev_required = 0;
+	init_waitqueue_head(&priv->ds_awake_q);
 
 	mutex_init(&priv->lock);
 
 	setup_timer(&priv->command_timer, command_timer_fn,
 		(unsigned long)priv);
+	setup_timer(&priv->auto_deepsleep_timer, auto_deepsleep_timer_fn,
+			(unsigned long)priv);
 
 	INIT_LIST_HEAD(&priv->cmdfreeq);
 	INIT_LIST_HEAD(&priv->cmdpendingq);
@@ -1142,6 +1218,7 @@ static void lbs_free_adapter(struct lbs_private *priv)
 	if (priv->event_fifo)
 		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
+	del_timer(&priv->auto_deepsleep_timer);
 	kfree(priv->networks);
 	priv->networks = NULL;
 
@@ -1272,6 +1349,11 @@ void lbs_remove_card(struct lbs_private *priv)
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
+	if (priv->is_deep_sleep) {
+		priv->is_deep_sleep = 0;
+		wake_up_interruptible(&priv->ds_awake_q);
+	}
+
 	/* Stop the thread servicing the interrupts */
 	priv->surpriseremoved = 1;
 	kthread_stop(priv->main_thread);
@@ -1392,6 +1474,7 @@ void lbs_stop_card(struct lbs_private *priv)
 
 	/* Delete the timeout of the currently processing command */
 	del_timer_sync(&priv->command_timer);
+	del_timer_sync(&priv->auto_deepsleep_timer);
 
 	/* Flush pending command nodes */
 	spin_lock_irqsave(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 6c95af3..e468e15 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -950,6 +950,11 @@ int lbs_set_scan(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (!priv->radio_on) {
 		ret = -EINVAL;
 		goto out;
@@ -1017,6 +1022,12 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		err = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", err);
+		return err;
+	}
+
 	/* iwlist should wait until the current scan is finished */
 	if (priv->scan_channel)
 		return -EAGAIN;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index be837a0..ef2b986 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -45,6 +45,31 @@ static inline void lbs_cancel_association_work(struct lbs_private *priv)
 	priv->pending_assoc_req = NULL;
 }
 
+/**
+ *  @brief This function checks if the command is allowed.
+ *
+ *  @param priv         A pointer to lbs_private structure
+ *  @return             allowed or not allowed.
+ */
+
+int lbs_is_cmd_allowed(struct lbs_private *priv)
+{
+	int         ret = 1;
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	if (!priv->is_auto_deep_sleep_enabled) {
+		if (priv->is_deep_sleep) {
+			lbs_deb_wext("IOCTLS called when station"
+					"is in deep sleep\n");
+			ret = 0;
+		}
+	}
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+	return ret;
+}
+
 
 /**
  *  @brief Find the channel frequency power info with specific channel
@@ -168,6 +193,11 @@ static int lbs_get_freq(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		lbs_deb_leave(LBS_DEB_WEXT);
+		return -EBUSY;
+	}
+
 	cfp = lbs_find_cfp_by_band_and_channel(priv, 0,
 					   priv->curbssparams.channel);
 
@@ -278,6 +308,12 @@ static int lbs_set_rts(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	if (vwrq->disabled)
 		val = MRVDRV_RTS_MAX_VALUE;
 
@@ -299,6 +335,11 @@ static int lbs_get_rts(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_RTS_THRESHOLD, &val);
 	if (ret)
 		goto out;
@@ -321,6 +362,12 @@ static int lbs_set_frag(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	if (vwrq->disabled)
 		val = MRVDRV_FRAG_MAX_VALUE;
 
@@ -342,6 +389,11 @@ static int lbs_get_frag(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = lbs_get_snmp_mib(priv, SNMP_MIB_OID_FRAG_THRESHOLD, &val);
 	if (ret)
 		goto out;
@@ -391,6 +443,11 @@ static int lbs_get_txpow(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (!priv->radio_on) {
 		lbs_deb_wext("tx power off\n");
 		vwrq->value = 0;
@@ -424,6 +481,11 @@ static int lbs_set_retry(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
         if ((vwrq->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
                 return -EOPNOTSUPP;
 
@@ -472,6 +534,11 @@ static int lbs_get_retry(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	vwrq->disabled = 0;
 
 	if (vwrq->flags & IW_RETRY_LONG) {
@@ -712,6 +779,11 @@ static int lbs_set_power(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		lbs_deb_leave(LBS_DEB_WEXT);
+		return -EBUSY;
+	}
+
 	if (!(priv->fwcapinfo & FW_CAPINFO_PS)) {
 		if (vwrq->disabled)
 			return 0;
@@ -792,6 +864,9 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv))
+		return NULL;
+
 	priv->wstats.status = priv->mode;
 
 	/* If we're not associated, all quality values are meaningless */
@@ -892,6 +967,12 @@ static int lbs_set_freq(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1000,6 +1081,12 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 	u8 rates[MAX_RATES + 1];
 
 	lbs_deb_enter(LBS_DEB_WEXT);
+
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	lbs_deb_wext("vwrq->value %d\n", vwrq->value);
 	lbs_deb_wext("vwrq->fixed %d\n", vwrq->fixed);
 
@@ -1058,6 +1145,11 @@ static int lbs_get_rate(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		lbs_deb_leave(LBS_DEB_WEXT);
+		return -EBUSY;
+	}
+
 	if (priv->connect_status == LBS_CONNECTED) {
 		vwrq->value = priv->cur_rate * 500000;
 
@@ -1084,6 +1176,11 @@ static int lbs_set_mode(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (   (*uwrq != IW_MODE_ADHOC)
 	    && (*uwrq != IW_MODE_INFRA)
 	    && (*uwrq != IW_MODE_AUTO)) {
@@ -1325,6 +1422,12 @@ static int lbs_set_encode(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1508,6 +1611,12 @@ static int lbs_set_encodeext(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1720,6 +1829,12 @@ static int lbs_set_auth(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	mutex_lock(&priv->lock);
 	assoc_req = lbs_get_association_request(priv);
 	if (!assoc_req) {
@@ -1822,6 +1937,12 @@ static int lbs_get_auth(struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	switch (dwrq->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_KEY_MGMT:
 		dwrq->value = priv->secinfo.key_mgmt;
@@ -1864,6 +1985,11 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (vwrq->disabled) {
 		lbs_set_radio(priv, RADIO_PREAMBLE_AUTO, 0);
 		goto out;
@@ -1983,6 +2109,12 @@ static int lbs_set_essid(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	if (!priv->radio_on) {
 		ret = -EINVAL;
 		goto out;
@@ -2110,6 +2242,12 @@ static int lbs_set_wap(struct net_device *dev, struct iw_request_info *info,
 
 	lbs_deb_enter(LBS_DEB_WEXT);
 
+	if (!lbs_is_cmd_allowed(priv)) {
+		ret = -EBUSY;
+		lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
+		return ret;
+	}
+
 	if (!priv->radio_on)
 		return -EINVAL;
 
-- 
1.5.4.3

