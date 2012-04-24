Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:34161 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753525Ab2DXXSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:18:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <padovan@profusion.mobi>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH RESEND 1/2] Bluetooth: btmrvl: configure default host sleep parameters
Date: Tue, 24 Apr 2012 16:18:21 -0700
Message-Id: <1335309502-10793-1-git-send-email-bzhao@marvell.com> (sfid-20120425_011835_937646_EB1D1877)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently debugfs commands "hscfgcmd" and "gpiogap" are provided
for host sleep configuration. But if user doesn't configure host
sleep parameters using these commands, host sleep activation is
failed during suspend (support for suspend and resume handlers is
added in next patch).

Default host sleep configuration is done during driver initialisation
in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/bluetooth/btmrvl_drv.h  |    1 +
 drivers/bluetooth/btmrvl_main.c |   53 ++++++++++++++++++++++----------------
 drivers/bluetooth/btmrvl_sdio.c |    3 ++
 3 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index 90bda50..2c79e76 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -139,6 +139,7 @@ void btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb);
 int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb);
 
 int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd);
+int btmrvl_send_hscfg_cmd(struct btmrvl_private *priv);
 int btmrvl_enable_ps(struct btmrvl_private *priv);
 int btmrvl_prepare_command(struct btmrvl_private *priv);
 
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index d1209ad..a880537 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -200,6 +200,36 @@ int btmrvl_send_module_cfg_cmd(struct btmrvl_private *priv, int subcmd)
 }
 EXPORT_SYMBOL_GPL(btmrvl_send_module_cfg_cmd);
 
+int btmrvl_send_hscfg_cmd(struct btmrvl_private *priv)
+{
+	struct sk_buff *skb;
+	struct btmrvl_cmd *cmd;
+
+	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
+	if (!skb) {
+		BT_ERR("No free skb");
+		return -ENOMEM;
+	}
+
+	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
+	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF,
+						   BT_CMD_HOST_SLEEP_CONFIG));
+	cmd->length = 2;
+	cmd->data[0] = (priv->btmrvl_dev.gpio_gap & 0xff00) >> 8;
+	cmd->data[1] = (u8) (priv->btmrvl_dev.gpio_gap & 0x00ff);
+
+	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
+
+	skb->dev = (void *) priv->btmrvl_dev.hcidev;
+	skb_queue_head(&priv->adapter->tx_queue, skb);
+
+	BT_DBG("Queue HSCFG Command, gpio=0x%x, gap=0x%x", cmd->data[0],
+	       cmd->data[1]);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(btmrvl_send_hscfg_cmd);
+
 int btmrvl_enable_ps(struct btmrvl_private *priv)
 {
 	struct sk_buff *skb;
@@ -271,32 +301,11 @@ static int btmrvl_enable_hs(struct btmrvl_private *priv)
 
 int btmrvl_prepare_command(struct btmrvl_private *priv)
 {
-	struct sk_buff *skb = NULL;
-	struct btmrvl_cmd *cmd;
 	int ret = 0;
 
 	if (priv->btmrvl_dev.hscfgcmd) {
 		priv->btmrvl_dev.hscfgcmd = 0;
-
-		skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
-		if (skb == NULL) {
-			BT_ERR("No free skb");
-			return -ENOMEM;
-		}
-
-		cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-		cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_HOST_SLEEP_CONFIG));
-		cmd->length = 2;
-		cmd->data[0] = (priv->btmrvl_dev.gpio_gap & 0xff00) >> 8;
-		cmd->data[1] = (u8) (priv->btmrvl_dev.gpio_gap & 0x00ff);
-
-		bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
-
-		skb->dev = (void *) priv->btmrvl_dev.hcidev;
-		skb_queue_head(&priv->adapter->tx_queue, skb);
-
-		BT_DBG("Queue HSCFG Command, gpio=0x%x, gap=0x%x",
-						cmd->data[0], cmd->data[1]);
+		btmrvl_send_hscfg_cmd(priv);
 	}
 
 	if (priv->btmrvl_dev.pscmd) {
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 27b74b0..f93a7a2 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -1013,6 +1013,9 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 	priv->btmrvl_dev.psmode = 1;
 	btmrvl_enable_ps(priv);
 
+	priv->btmrvl_dev.gpio_gap = 0xffff;
+	btmrvl_send_hscfg_cmd(priv);
+
 	return 0;
 
 disable_host_int:
-- 
1.7.4.1

