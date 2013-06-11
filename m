Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47297
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab3FKNtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 09:49:47 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 2/3] cw1200:  Eliminate the ETF debug/engineering code.
Date: Tue, 11 Jun 2013 09:49:39 -0400
Message-Id: <1370958580-6463-2-git-send-email-pizza@shaftnet.org> (sfid-20130611_154953_362499_59BFF96B)
In-Reply-To: <1370958580-6463-1-git-send-email-pizza@shaftnet.org>
References: <1370958580-6463-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is only really useful for people who are bringing up new hardware
designs and have access to the proprietary vendor tools that interface
with this mode.

It'll live out of tree until it's rewritten to use a less kludgy interface.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/Kconfig  |  10 --
 drivers/net/wireless/cw1200/cw1200.h |   9 --
 drivers/net/wireless/cw1200/debug.c  | 236 -----------------------------------
 drivers/net/wireless/cw1200/fwio.c   |   5 -
 drivers/net/wireless/cw1200/main.c   |  30 +----
 drivers/net/wireless/cw1200/wsm.c    |  56 +--------
 drivers/net/wireless/cw1200/wsm.h    |   5 -
 7 files changed, 2 insertions(+), 349 deletions(-)

diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
index fc1b472..0880742 100644
--- a/drivers/net/wireless/cw1200/Kconfig
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -27,14 +27,4 @@ config CW1200_WLAN_SPI
 	  need to add appropriate platform data glue in your board setup
 	  file.
 
-menu "Driver debug features"
-	depends on CW1200 && DEBUG_FS
-
-config CW1200_ETF
-	bool "Enable CW1200 Engineering Test Framework hooks"
-	help
-	  If you don't know what this is, just say N.
-
-endmenu
-
 endif
diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
index 95320f2..91ff7f1 100644
--- a/drivers/net/wireless/cw1200/cw1200.h
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -35,11 +35,6 @@ struct task_struct;
 struct cw1200_debug_priv;
 struct firmware;
 
-#ifdef CONFIG_CW1200_ETF
-extern int etf_mode;
-extern char *etf_firmware;
-#endif
-
 #define CW1200_MAX_CTRL_FRAME_LEN	(0x1000)
 
 #define CW1200_MAX_STA_IN_AP_MODE	(5)
@@ -287,10 +282,6 @@ struct cw1200_common {
 	struct work_struct	linkid_reset_work;
 	u8			action_frame_sa[ETH_ALEN];
 	u8			action_linkid;
-
-#ifdef CONFIG_CW1200_ETF
-	struct sk_buff_head etf_q;
-#endif
 };
 
 struct cw1200_sta_priv {
diff --git a/drivers/net/wireless/cw1200/debug.c b/drivers/net/wireless/cw1200/debug.c
index ac9c219..e323b4d 100644
--- a/drivers/net/wireless/cw1200/debug.c
+++ b/drivers/net/wireless/cw1200/debug.c
@@ -357,144 +357,6 @@ static const struct file_operations fops_counters = {
 	.owner = THIS_MODULE,
 };
 
-#ifdef CONFIG_CW1200_ETF
-static int cw1200_etf_out_show(struct seq_file *seq, void *v)
-{
-	struct cw1200_common *priv = seq->private;
-	struct sk_buff *skb;
-	u32 len = 0;
-
-	skb = skb_dequeue(&priv->etf_q);
-
-	if (skb)
-		len = skb->len;
-
-	seq_write(seq, &len, sizeof(len));
-
-	if (skb) {
-		seq_write(seq, skb->data, len);
-		kfree_skb(skb);
-	}
-
-	return 0;
-}
-
-static int cw1200_etf_out_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, &cw1200_etf_out_show,
-			   inode->i_private);
-}
-
-static const struct file_operations fops_etf_out = {
-	.open = cw1200_etf_out_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-struct etf_req_msg;
-static int etf_request(struct cw1200_common *priv,
-		       struct etf_req_msg *msg, u32 len);
-
-#define MAX_RX_SIZE 2600
-
-struct etf_in_state {
-	struct cw1200_common *priv;
-	u16 total_len;
-	u16 written;
-	u8 buf[MAX_RX_SIZE];
-};
-
-static int cw1200_etf_in_open(struct inode *inode, struct file *file)
-{
-	struct etf_in_state *etf = kmalloc(sizeof(struct etf_in_state),
-					   GFP_KERNEL);
-
-	if (!etf)
-		return -ENOMEM;
-
-	etf->written = 0;
-	etf->total_len = 0;
-	etf->priv = inode->i_private;
-
-	file->private_data = etf;
-
-	return 0;
-}
-
-static int cw1200_etf_in_release(struct inode *inode, struct file *file)
-{
-	kfree(file->private_data);
-	return 0;
-}
-
-static ssize_t cw1200_etf_in_write(struct file *file,
-	const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	struct etf_in_state *etf = file->private_data;
-
-	ssize_t written = 0;
-
-	if (!etf->total_len) {
-		if (count < sizeof(etf->total_len)) {
-			pr_err("count < sizeof(total_len)\n");
-			return -EINVAL;
-		}
-
-		if (copy_from_user(&etf->total_len, user_buf,
-				   sizeof(etf->total_len))) {
-			pr_err("copy_from_user (len) failed\n");
-			return -EFAULT;
-		}
-
-		if (etf->total_len > MAX_RX_SIZE) {
-			pr_err("requested length > MAX_RX_SIZE\n");
-			return -EINVAL;
-		}
-
-		written += sizeof(etf->total_len);
-		count -= sizeof(etf->total_len);
-	}
-
-	if (!count)
-		goto done;
-
-	if (count > (etf->total_len - written)) {
-		pr_err("Tried to write > MAX_RX_SIZE\n");
-		return -EINVAL;
-	}
-
-	if (copy_from_user(etf->buf + etf->written, user_buf + written,
-			   count)) {
-		pr_err("copy_from_user (payload %zu) failed\n", count);
-		return -EFAULT;
-	}
-
-	written += count;
-	etf->written += count;
-
-	if (etf->written >= etf->total_len) {
-		if (etf_request(etf->priv, (struct etf_req_msg *)etf->buf,
-				etf->total_len)) {
-			pr_err("etf_request failed\n");
-			return -EIO;
-		}
-	}
-
-done:
-	return written;
-}
-
-static const struct file_operations fops_etf_in = {
-	.open = cw1200_etf_in_open,
-	.release = cw1200_etf_in_release,
-	.write = cw1200_etf_in_write,
-	.llseek = default_llseek,
-	.owner = THIS_MODULE,
-};
-#endif /* CONFIG_CW1200_ETF */
-
 static ssize_t cw1200_wsm_dumps(struct file *file,
 	const char __user *user_buf, size_t count, loff_t *ppos)
 {
@@ -542,19 +404,6 @@ int cw1200_debug_init(struct cw1200_common *priv)
 				 priv, &fops_counters))
 		goto err;
 
-#ifdef CONFIG_CW1200_ETF
-	if (etf_mode) {
-		skb_queue_head_init(&priv->etf_q);
-
-		if (!debugfs_create_file("etf_out", S_IRUSR, d->debugfs_phy,
-					 priv, &fops_etf_out))
-			goto err;
-		if (!debugfs_create_file("etf_in", S_IWUSR, d->debugfs_phy,
-					 priv, &fops_etf_in))
-			goto err;
-	}
-#endif /* CONFIG_CW1200_ETF */
-
 	if (!debugfs_create_file("wsm_dumps", S_IWUSR, d->debugfs_phy,
 				 priv, &fops_wsm_dumps))
 		goto err;
@@ -577,88 +426,3 @@ void cw1200_debug_release(struct cw1200_common *priv)
 		kfree(d);
 	}
 }
-
-#ifdef CONFIG_CW1200_ETF
-struct cw1200_sdd {
-	u8 id;
-	u8 len;
-	u8 data[];
-};
-
-struct etf_req_msg {
-	u32 id;
-	u32 len;
-	u8 data[];
-};
-
-static int parse_sdd_file(struct cw1200_common *priv, u8 *data, u32 length)
-{
-	struct cw1200_sdd *ie;
-
-	while (length > 0) {
-		ie = (struct cw1200_sdd *)data;
-		if (ie->id == SDD_REFERENCE_FREQUENCY_ELT_ID) {
-			priv->hw_refclk = cpu_to_le16(*((u16 *)ie->data));
-			pr_info("Using Reference clock frequency %d KHz\n",
-				priv->hw_refclk);
-			break;
-		}
-
-		length -= ie->len + sizeof(*ie);
-		data += ie->len + sizeof(*ie);
-	}
-	return 0;
-}
-
-char *etf_firmware;
-
-#define ST90TDS_START_ADAPTER           0x09 /* Loads firmware too */
-#define ST90TDS_STOP_ADAPTER            0x0A
-#define ST90TDS_CONFIG_ADAPTER          0x0E /* Send configuration params */
-#define ST90TDS_SBUS_READ               0x13
-#define ST90TDS_SBUS_WRITE              0x14
-#define ST90TDS_GET_DEVICE_OPTION       0x19
-#define ST90TDS_SET_DEVICE_OPTION       0x1A
-#define ST90TDS_SEND_SDD                0x1D /* SDD File used to find DPLL */
-
-#include "fwio.h"
-
-static int etf_request(struct cw1200_common *priv,
-		       struct etf_req_msg *msg,
-		       u32 len)
-{
-	int rval = -1;
-	switch (msg->id) {
-	case ST90TDS_START_ADAPTER:
-		etf_firmware = "cw1200_etf.bin";
-		pr_info("ETF_START (len %d, '%s')\n", len, etf_firmware);
-		rval = cw1200_load_firmware(priv);
-		break;
-	case ST90TDS_STOP_ADAPTER:
-		pr_info("ETF_STOP (unhandled)\n");
-		break;
-	case ST90TDS_SEND_SDD:
-		pr_info("ETF_SDD\n");
-		rval = parse_sdd_file(priv, msg->data, msg->len);
-		break;
-	case ST90TDS_CONFIG_ADAPTER:
-		pr_info("ETF_CONFIG_ADAP (unhandled)\n");
-		break;
-	case ST90TDS_SBUS_READ:
-		pr_info("ETF_SBUS_READ (unhandled)\n");
-		break;
-	case ST90TDS_SBUS_WRITE:
-		pr_info("ETF_SBUS_WRITE (unhandled)\n");
-		break;
-	case ST90TDS_SET_DEVICE_OPTION:
-		pr_info("ETF_SET_DEV_OPT (unhandled)\n");
-		break;
-	default:
-		pr_info("ETF_PASSTHRU (0x%08x)\n", msg->id);
-		rval = wsm_raw_cmd(priv, (u8 *)msg, len);
-		break;
-	}
-
-	return rval;
-}
-#endif /* CONFIG_CW1200_ETF */
diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index 427c9f2..acdff0f 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -139,11 +139,6 @@ static int cw1200_load_firmware_cw1200(struct cw1200_common *priv)
 	val32 &= ~ST90TDS_CONFIG_CPU_CLK_DIS_BIT;
 	REG_WRITE(ST90TDS_CONFIG_REG_ID, val32);
 
-#ifdef CONFIG_CW1200_ETF
-	if (etf_mode)
-		fw_path = etf_firmware;
-#endif
-
 	/* Load a firmware file */
 	ret = request_firmware(&firmware, fw_path, priv->pdev);
 	if (ret) {
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 2ea1bad..9f9adb4 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -61,12 +61,6 @@ int cw1200_power_mode = wsm_power_mode_quiescent;
 module_param(cw1200_power_mode, int, 0644);
 MODULE_PARM_DESC(cw1200_power_mode, "WSM power mode.  0 == active, 1 == doze, 2 == quiescent (default)");
 
-#ifdef CONFIG_CW1200_ETF
-int etf_mode;
-module_param(etf_mode, int, 0644);
-MODULE_PARM_DESC(etf_mode, "Enable EngineeringTestingFramework operation");
-#endif
-
 #define RATETAB_ENT(_rate, _rateid, _flags)		\
 	{						\
 		.bitrate	= (_rate),		\
@@ -418,11 +412,6 @@ static int cw1200_register_common(struct ieee80211_hw *dev)
 	struct cw1200_common *priv = dev->priv;
 	int err;
 
-#ifdef CONFIG_CW1200_ETF
-	if (etf_mode)
-		goto done;
-#endif
-
 #ifdef CONFIG_PM
 	err = cw1200_pm_init(&priv->pm_state, priv);
 	if (err) {
@@ -442,9 +431,6 @@ static int cw1200_register_common(struct ieee80211_hw *dev)
 		return err;
 	}
 
-#ifdef CONFIG_CW1200_ETF
-done:
-#endif
 	cw1200_debug_init(priv);
 
 	pr_info("Registered as '%s'\n", wiphy_name(dev->wiphy));
@@ -461,13 +447,7 @@ static void cw1200_unregister_common(struct ieee80211_hw *dev)
 	struct cw1200_common *priv = dev->priv;
 	int i;
 
-#ifdef CONFIG_CW1200_ETF
-	if (!etf_mode) {
-#endif
-		ieee80211_unregister_hw(dev);
-#ifdef CONFIG_CW1200_ETF
-	}
-#endif
+	ieee80211_unregister_hw(dev);
 
 	del_timer_sync(&priv->mcast_timeout);
 	cw1200_unregister_bh(priv);
@@ -568,11 +548,6 @@ int cw1200_core_probe(const struct hwbus_ops *hwbus_ops,
 	if (err)
 		goto err1;
 
-#ifdef CONFIG_CW1200_ETF
-	if (etf_mode)
-		goto skip_fw;
-#endif
-
 	err = cw1200_load_firmware(priv);
 	if (err)
 		goto err2;
@@ -594,9 +569,6 @@ int cw1200_core_probe(const struct hwbus_ops *hwbus_ops,
 	/* Enable multi-TX confirmation */
 	wsm_use_multi_tx_conf(priv, true);
 
-#ifdef CONFIG_CW1200_ETF
-skip_fw:
-#endif
 	err = cw1200_register_common(dev);
 	if (err)
 		goto err2;
diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index e99f34e..d185f29 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -1111,10 +1111,7 @@ static int wsm_cmd_send(struct cw1200_common *priv,
 	 * pad the message by a few bytes to ensure
 	 * that it's completely received.
 	 */
-#ifdef CONFIG_CW1200_ETF
-	if (!etf_mode)
-#endif
-		buf_len += 4;
+	buf_len += 4;
 
 	/* Fill HI message header */
 	/* BH will add sequence number */
@@ -1165,29 +1162,6 @@ done:
 	return ret;
 }
 
-#ifdef CONFIG_CW1200_ETF
-int wsm_raw_cmd(struct cw1200_common *priv, u8 *data, size_t len)
-{
-	struct wsm_buf *buf = &priv->wsm_cmd_buf;
-	int ret;
-
-	u16 *cmd = (u16 *)(data + 2);
-
-	wsm_cmd_lock(priv);
-
-	WSM_PUT(buf, data + 4, len - 4);  /* Skip over header (u16+u16) */
-
-	ret = wsm_cmd_send(priv, buf, NULL, __le16_to_cpu(*cmd), WSM_CMD_TIMEOUT);
-
-	wsm_cmd_unlock(priv);
-	return ret;
-
-nomem:
-	wsm_cmd_unlock(priv);
-	return -ENOMEM;
-}
-#endif /* CONFIG_CW1200_ETF */
-
 /* ******************************************************************** */
 /* WSM TX port control							*/
 
@@ -1343,34 +1317,6 @@ int wsm_handle_rx(struct cw1200_common *priv, u16 id,
 	pr_debug("[WSM] <<< 0x%.4X (%td)\n", id,
 		 wsm_buf.end - wsm_buf.begin);
 
-#ifdef CONFIG_CW1200_ETF
-	if (etf_mode) {
-		struct sk_buff *skb = alloc_skb(wsm_buf.end - wsm_buf.begin, GFP_KERNEL);
-
-		/* Strip out Sequence num before passing up */
-		wsm->id = __le16_to_cpu(wsm->id);
-		wsm->id &= 0x0FFF;
-		wsm->id = __cpu_to_le16(wsm->id);
-
-		memcpy(skb_put(skb, wsm_buf.end - wsm_buf.begin),
-		       wsm_buf.begin,
-		       wsm_buf.end - wsm_buf.begin);
-		skb_queue_tail(&priv->etf_q, skb);
-
-		/* Special case for startup */
-		if (id == WSM_STARTUP_IND_ID) {
-			wsm_startup_indication(priv, &wsm_buf);
-		} else if (id & 0x0400) {
-			spin_lock(&priv->wsm_cmd.lock);
-			priv->wsm_cmd.done = 1;
-			spin_unlock(&priv->wsm_cmd.lock);
-			wake_up(&priv->wsm_cmd_wq);
-		}
-
-		goto out;
-	}
-#endif
-
 	if (id == WSM_TX_CONFIRM_IND_ID) {
 		ret = wsm_tx_confirm(priv, &wsm_buf, link_id);
 	} else if (id == WSM_MULTI_TX_CONFIRM_ID) {
diff --git a/drivers/net/wireless/cw1200/wsm.h b/drivers/net/wireless/cw1200/wsm.h
index 8d902d6..4689dff 100644
--- a/drivers/net/wireless/cw1200/wsm.h
+++ b/drivers/net/wireless/cw1200/wsm.h
@@ -1871,9 +1871,4 @@ static inline u8 wsm_queue_id_to_wsm(u8 queue_id)
 	return queue_mapping[queue_id];
 }
 
-
-#ifdef CONFIG_CW1200_ETF
-int wsm_raw_cmd(struct cw1200_common *priv, u8 *data, size_t len);
-#endif
-
 #endif /* CW1200_HWIO_H_INCLUDED */
-- 
1.8.2.1

