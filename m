Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38396 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382Ab3JCVUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 17:20:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Anderson Lizardo <anderson.lizardo@openbossa.org>,
	<linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] Bluetooth: btmrvl: operate on 16-bit opcodes instead of ogf/ocf
Date: Thu, 3 Oct 2013 14:19:43 -0700
Message-ID: <1380835183-14115-1-git-send-email-bzhao@marvell.com> (sfid-20131003_232008_640642_043598C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace ogf/ocf and its packing with 16-bit opcodes.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Use hci_opcode_ogf() to make code more readable. (Anderson Lizardo)

 drivers/bluetooth/btmrvl_drv.h  | 19 +++++++++++--------
 drivers/bluetooth/btmrvl_main.c | 21 +++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index f9d1833..e3b49c6 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -90,12 +90,12 @@ struct btmrvl_private {
 
 #define MRVL_VENDOR_PKT			0xFE
 
-/* Bluetooth commands  */
-#define BT_CMD_AUTO_SLEEP_MODE		0x23
-#define BT_CMD_HOST_SLEEP_CONFIG	0x59
-#define BT_CMD_HOST_SLEEP_ENABLE	0x5A
-#define BT_CMD_MODULE_CFG_REQ		0x5B
-#define BT_CMD_LOAD_CONFIG_DATA		0x61
+/* Vendor specific Bluetooth commands */
+#define BT_CMD_AUTO_SLEEP_MODE		0xFC23
+#define BT_CMD_HOST_SLEEP_CONFIG	0xFC59
+#define BT_CMD_HOST_SLEEP_ENABLE	0xFC5A
+#define BT_CMD_MODULE_CFG_REQ		0xFC5B
+#define BT_CMD_LOAD_CONFIG_DATA		0xFC61
 
 /* Sub-commands: Module Bringup/Shutdown Request/Response */
 #define MODULE_BRINGUP_REQ		0xF1
@@ -104,6 +104,11 @@ struct btmrvl_private {
 
 #define MODULE_SHUTDOWN_REQ		0xF2
 
+/* Vendor specific Bluetooth events */
+#define BT_EVENT_AUTO_SLEEP_MODE	0x23
+#define BT_EVENT_HOST_SLEEP_CONFIG	0x59
+#define BT_EVENT_HOST_SLEEP_ENABLE	0x5A
+#define BT_EVENT_MODULE_CFG_REQ		0x5B
 #define BT_EVENT_POWER_STATE		0x20
 
 /* Bluetooth Power States */
@@ -111,8 +116,6 @@ struct btmrvl_private {
 #define BT_PS_DISABLE			0x03
 #define BT_PS_SLEEP			0x01
 
-#define OGF				0x3F
-
 /* Host Sleep states */
 #define HS_ACTIVATED			0x01
 #define HS_DEACTIVATED			0x00
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 6e7bd4e..ffec74e 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -50,12 +50,10 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
 
 	if (hdr->evt == HCI_EV_CMD_COMPLETE) {
 		struct hci_ev_cmd_complete *ec;
-		u16 opcode, ocf, ogf;
+		u16 opcode;
 
 		ec = (void *) (skb->data + HCI_EVENT_HDR_SIZE);
 		opcode = __le16_to_cpu(ec->opcode);
-		ocf = hci_opcode_ocf(opcode);
-		ogf = hci_opcode_ogf(opcode);
 
 		if (priv->btmrvl_dev.sendcmdflag) {
 			priv->btmrvl_dev.sendcmdflag = false;
@@ -63,9 +61,8 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
 			wake_up_interruptible(&priv->adapter->cmd_wait_q);
 		}
 
-		if (ogf == OGF) {
-			BT_DBG("vendor event skipped: ogf 0x%4.4x ocf 0x%4.4x",
-			       ogf, ocf);
+		if (hci_opcode_ogf(opcode) == 0x3F) {
+			BT_DBG("vendor event skipped: opcode=%#4.4x", opcode);
 			kfree_skb(skb);
 			return false;
 		}
@@ -89,7 +86,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 	}
 
 	switch (event->data[0]) {
-	case BT_CMD_AUTO_SLEEP_MODE:
+	case BT_EVENT_AUTO_SLEEP_MODE:
 		if (!event->data[2]) {
 			if (event->data[1] == BT_PS_ENABLE)
 				adapter->psmode = 1;
@@ -102,7 +99,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		}
 		break;
 
-	case BT_CMD_HOST_SLEEP_CONFIG:
+	case BT_EVENT_HOST_SLEEP_CONFIG:
 		if (!event->data[3])
 			BT_DBG("gpio=%x, gap=%x", event->data[1],
 							event->data[2]);
@@ -110,7 +107,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 			BT_DBG("HSCFG command failed");
 		break;
 
-	case BT_CMD_HOST_SLEEP_ENABLE:
+	case BT_EVENT_HOST_SLEEP_ENABLE:
 		if (!event->data[1]) {
 			adapter->hs_state = HS_ACTIVATED;
 			if (adapter->psmode)
@@ -121,7 +118,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 		}
 		break;
 
-	case BT_CMD_MODULE_CFG_REQ:
+	case BT_EVENT_MODULE_CFG_REQ:
 		if (priv->btmrvl_dev.sendcmdflag &&
 				event->data[1] == MODULE_BRINGUP_REQ) {
 			BT_DBG("EVENT:%s",
@@ -166,7 +163,7 @@ exit:
 }
 EXPORT_SYMBOL_GPL(btmrvl_process_event);
 
-static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
+static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 opcode,
 				const void *param, u8 len)
 {
 	struct sk_buff *skb;
@@ -179,7 +176,7 @@ static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
 	}
 
 	hdr = (struct hci_command_hdr *)skb_put(skb, HCI_COMMAND_HDR_SIZE);
-	hdr->opcode = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
+	hdr->opcode = cpu_to_le16(opcode);
 	hdr->plen = len;
 
 	if (len)
-- 
1.8.0

