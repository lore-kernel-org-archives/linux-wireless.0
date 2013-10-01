Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60178 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989Ab3JATUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 15:20:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v6 1/4] Bluetooth: btmrvl: add btmrvl_send_sync_cmd() function
Date: Tue, 1 Oct 2013 12:19:12 -0700
Message-ID: <1380655155-10007-2-git-send-email-bzhao@marvell.com> (sfid-20131001_212007_884896_ACBD54E4)
In-Reply-To: <1380655155-10007-1-git-send-email-bzhao@marvell.com>
References: <1380655155-10007-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Command preparation code is used multiple times. This patch
separate out this common code and create btmrvl_send_sync_cmd()
function.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v6: separate out common code

 drivers/bluetooth/btmrvl_main.c | 129 +++++++++++++---------------------------
 1 file changed, 41 insertions(+), 88 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 9a9f518..d9d4229 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -57,8 +57,7 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
 		ocf = hci_opcode_ocf(opcode);
 		ogf = hci_opcode_ogf(opcode);
 
-		if (ocf == BT_CMD_MODULE_CFG_REQ &&
-					priv->btmrvl_dev.sendcmdflag) {
+		if (priv->btmrvl_dev.sendcmdflag) {
 			priv->btmrvl_dev.sendcmdflag = false;
 			priv->adapter->cmd_complete = true;
 			wake_up_interruptible(&priv->adapter->cmd_wait_q);
@@ -116,7 +115,6 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 			adapter->hs_state = HS_ACTIVATED;
 			if (adapter->psmode)
 				adapter->ps_state = PS_SLEEP;
-			wake_up_interruptible(&adapter->cmd_wait_q);
 			BT_DBG("HS ACTIVATED!");
 		} else {
 			BT_DBG("HS Enable failed");
@@ -168,11 +166,11 @@ exit:
 }
 EXPORT_SYMBOL_GPL(btmrvl_process_event);
 
-int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd)
+static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
+				const void *param, u8 len)
 {
 	struct sk_buff *skb;
 	struct btmrvl_cmd *cmd;
-	int ret = 0;
 
 	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
 	if (skb == NULL) {
@@ -181,9 +179,11 @@ int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd)
 	}
 
 	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_MODULE_CFG_REQ));
-	cmd->length = 1;
-	cmd->data[0] = subcmd;
+	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
+	cmd->length = len;
+
+	if (len)
+		memcpy(cmd->data, param, len);
 
 	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
 
@@ -194,19 +194,23 @@ int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd)
 
 	priv->adapter->cmd_complete = false;
 
-	BT_DBG("Queue module cfg Command");
-
 	wake_up_interruptible(&priv->main_thread.wait_q);
 
 	if (!wait_event_interruptible_timeout(priv->adapter->cmd_wait_q,
 				priv->adapter->cmd_complete,
-				msecs_to_jiffies(WAIT_UNTIL_CMD_RESP))) {
-		ret = -ETIMEDOUT;
-		BT_ERR("module_cfg_cmd(%x): timeout: %d",
-					subcmd, priv->btmrvl_dev.sendcmdflag);
-	}
+				msecs_to_jiffies(WAIT_UNTIL_CMD_RESP)))
+		return -ETIMEDOUT;
 
-	BT_DBG("module cfg Command done");
+	return 0;
+}
+
+int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd)
+{
+	int ret;
+
+	ret = btmrvl_send_sync_cmd(priv, BT_CMD_MODULE_CFG_REQ, &subcmd, 1);
+	if (ret)
+		BT_ERR("module_cfg_cmd(%x) failed\n", subcmd);
 
 	return ret;
 }
@@ -214,61 +218,36 @@ EXPORT_SYMBOL_GPL(btmrvl_send_module_cfg_cmd);
 
 int btmrvl_send_hscfg_cmd(struct btmrvl_private *priv)
 {
-	struct sk_buff *skb;
-	struct btmrvl_cmd *cmd;
-
-	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
-	if (!skb) {
-		BT_ERR("No free skb");
-		return -ENOMEM;
-	}
-
-	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF,
-						   BT_CMD_HOST_SLEEP_CONFIG));
-	cmd->length = 2;
-	cmd->data[0] = (priv->btmrvl_dev.gpio_gap & 0xff00) >> 8;
-	cmd->data[1] = (u8) (priv->btmrvl_dev.gpio_gap & 0x00ff);
+	int ret;
+	u8 param[2];
 
-	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
+	param[0] = (priv->btmrvl_dev.gpio_gap & 0xff00) >> 8;
+	param[1] = (u8) (priv->btmrvl_dev.gpio_gap & 0x00ff);
 
-	skb->dev = (void *) priv->btmrvl_dev.hcidev;
-	skb_queue_head(&priv->adapter->tx_queue, skb);
+	BT_DBG("Sending HSCFG Command, gpio=0x%x, gap=0x%x",
+	       param[0], param[1]);
 
-	BT_DBG("Queue HSCFG Command, gpio=0x%x, gap=0x%x", cmd->data[0],
-	       cmd->data[1]);
+	ret = btmrvl_send_sync_cmd(priv, BT_CMD_HOST_SLEEP_CONFIG, param, 2);
+	if (ret)
+		BT_ERR("HSCFG command failed\n");
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(btmrvl_send_hscfg_cmd);
 
 int btmrvl_enable_ps(struct btmrvl_private *priv)
 {
-	struct sk_buff *skb;
-	struct btmrvl_cmd *cmd;
-
-	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
-	if (skb == NULL) {
-		BT_ERR("No free skb");
-		return -ENOMEM;
-	}
-
-	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF,
-					BT_CMD_AUTO_SLEEP_MODE));
-	cmd->length = 1;
+	int ret;
+	u8 param;
 
 	if (priv->btmrvl_dev.psmode)
-		cmd->data[0] = BT_PS_ENABLE;
+		param = BT_PS_ENABLE;
 	else
-		cmd->data[0] = BT_PS_DISABLE;
-
-	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
-
-	skb->dev = (void *) priv->btmrvl_dev.hcidev;
-	skb_queue_head(&priv->adapter->tx_queue, skb);
+		param = BT_PS_DISABLE;
 
-	BT_DBG("Queue PSMODE Command:%d", cmd->data[0]);
+	ret = btmrvl_send_sync_cmd(priv, BT_CMD_AUTO_SLEEP_MODE, &param, 1);
+	if (ret)
+		BT_ERR("PSMODE command failed\n");
 
 	return 0;
 }
@@ -276,37 +255,11 @@ EXPORT_SYMBOL_GPL(btmrvl_enable_ps);
 
 int btmrvl_enable_hs(struct btmrvl_private *priv)
 {
-	struct sk_buff *skb;
-	struct btmrvl_cmd *cmd;
-	int ret = 0;
-
-	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
-	if (skb == NULL) {
-		BT_ERR("No free skb");
-		return -ENOMEM;
-	}
-
-	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_HOST_SLEEP_ENABLE));
-	cmd->length = 0;
-
-	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
-
-	skb->dev = (void *) priv->btmrvl_dev.hcidev;
-	skb_queue_head(&priv->adapter->tx_queue, skb);
-
-	BT_DBG("Queue hs enable Command");
-
-	wake_up_interruptible(&priv->main_thread.wait_q);
+	int ret;
 
-	if (!wait_event_interruptible_timeout(priv->adapter->cmd_wait_q,
-			priv->adapter->hs_state,
-			msecs_to_jiffies(WAIT_UNTIL_HS_STATE_CHANGED))) {
-		ret = -ETIMEDOUT;
-		BT_ERR("timeout: %d, %d,%d", priv->adapter->hs_state,
-						priv->adapter->ps_state,
-						priv->adapter->wakeup_tries);
-	}
+	ret = btmrvl_send_sync_cmd(priv, BT_CMD_HOST_SLEEP_ENABLE, NULL, 0);
+	if (ret)
+		BT_ERR("Host sleep enable command failed\n");
 
 	return ret;
 }
-- 
1.8.0

