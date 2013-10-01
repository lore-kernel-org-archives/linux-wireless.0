Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56594 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab3JATTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 15:19:46 -0400
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
Subject: [PATCH v6 2/4] Bluetooth: btmrvl: get rid of struct btmrvl_cmd
Date: Tue, 1 Oct 2013 12:19:13 -0700
Message-ID: <1380655155-10007-3-git-send-email-bzhao@marvell.com> (sfid-20131001_211951_832280_B9C947A5)
In-Reply-To: <1380655155-10007-1-git-send-email-bzhao@marvell.com>
References: <1380655155-10007-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Replace this proprietary structure with the standard one
(struct hci_command_hdr).

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v6: remove proprietary struct btmrvl_cmd

 drivers/bluetooth/btmrvl_drv.h  |  6 ------
 drivers/bluetooth/btmrvl_main.c | 12 ++++++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index 27068d1..42f7028 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -116,12 +116,6 @@ struct btmrvl_private {
 #define PS_SLEEP			0x01
 #define PS_AWAKE			0x00
 
-struct btmrvl_cmd {
-	__le16 ocf_ogf;
-	u8 length;
-	u8 data[4];
-} __packed;
-
 struct btmrvl_event {
 	u8 ec;		/* event counter */
 	u8 length;
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index d9d4229..a4da7c8 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -170,20 +170,20 @@ static int btmrvl_send_sync_cmd(struct btmrvl_private *priv, u16 cmd_no,
 				const void *param, u8 len)
 {
 	struct sk_buff *skb;
-	struct btmrvl_cmd *cmd;
+	struct hci_command_hdr *hdr;
 
-	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
+	skb = bt_skb_alloc(HCI_COMMAND_HDR_SIZE + len, GFP_ATOMIC);
 	if (skb == NULL) {
 		BT_ERR("No free skb");
 		return -ENOMEM;
 	}
 
-	cmd = (struct btmrvl_cmd *) skb_put(skb, sizeof(*cmd));
-	cmd->ocf_ogf = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
-	cmd->length = len;
+	hdr = (struct hci_command_hdr *)skb_put(skb, HCI_COMMAND_HDR_SIZE);
+	hdr->opcode = cpu_to_le16(hci_opcode_pack(OGF, cmd_no));
+	hdr->plen = len;
 
 	if (len)
-		memcpy(cmd->data, param, len);
+		memcpy(skb_put(skb, len), param, len);
 
 	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
 
-- 
1.8.0

