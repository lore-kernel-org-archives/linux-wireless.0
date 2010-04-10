Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f193.google.com ([209.85.222.193]:40429 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0DJPFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 11:05:47 -0400
Received: by mail-pz0-f193.google.com with SMTP id 31so817455pzk.33
        for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 08:05:47 -0700 (PDT)
From: tom.leiming@gmail.com
To: Sujith.Manoharan@atheros.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 3/3] ath9k-htc: pass cacheline aligned buffer to usb hcd in register out path
Date: Sat, 10 Apr 2010 23:05:23 +0800
Message-Id: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ming Lei <tom.leiming@gmail.com>

This patch copies skb->data of register out command to kmalloced buffer,
which is cacheline aligned(dma safe) and passed into usb hcd. Since the
data in register out command is not very much, we can ignore the
performance loss caused by the copy.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   35 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index be4dfbd..b9d42ff 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -29,6 +29,30 @@ MODULE_DEVICE_TABLE(usb, ath9k_hif_usb_ids);
 
 static int __hif_usb_tx(struct hif_device_usb *hif_dev);
 
+static inline struct cmd_buf *alloc_cmd(int len)
+{
+	struct cmd_buf *cmd;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return NULL;
+
+	cmd->usb_buf = kmalloc(len, GFP_KERNEL);
+	if (!cmd->usb_buf) {
+		kfree(cmd);
+		return NULL;
+	}
+
+	return cmd;
+}
+
+static inline void free_cmd(struct cmd_buf *cmd)
+{
+	kfree(cmd->usb_buf);
+	kfree(cmd);
+}
+
+
 static void hif_usb_regout_cb(struct urb *urb)
 {
 	struct cmd_buf *cmd = (struct cmd_buf *)urb->context;
@@ -48,13 +72,13 @@ static void hif_usb_regout_cb(struct urb *urb)
 	if (cmd) {
 		ath9k_htc_txcompletion_cb(cmd->hif_dev->htc_handle,
 					  cmd->skb, 1);
-		kfree(cmd);
+		free_cmd(cmd);
 	}
 
 	return;
 free:
 	dev_kfree_skb_any(cmd->skb);
-	kfree(cmd);
+	free_cmd(cmd);
 }
 
 static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
@@ -68,7 +92,7 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 	if (urb == NULL)
 		return -ENOMEM;
 
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	cmd = alloc_cmd(skb->len);
 	if (cmd == NULL) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -76,17 +100,18 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 
 	cmd->skb = skb;
 	cmd->hif_dev = hif_dev;
+	memcpy(cmd->usb_buf, skb->data, skb->len);
 
 	usb_fill_int_urb(urb, hif_dev->udev,
 			 usb_sndintpipe(hif_dev->udev, USB_REG_OUT_PIPE),
-			 skb->data, skb->len,
+			 cmd->usb_buf, skb->len,
 			 hif_usb_regout_cb, cmd, 1);
 
 	usb_anchor_urb(urb, &hif_dev->regout_submitted);
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret) {
 		usb_unanchor_urb(urb);
-		kfree(cmd);
+		free_cmd(cmd);
 	}
 	usb_free_urb(urb);
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 7d49a8a..ebc8c41 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -76,6 +76,7 @@ struct hif_usb_tx {
 struct cmd_buf {
 	struct sk_buff *skb;
 	struct hif_device_usb *hif_dev;
+	unsigned char *usb_buf;
 };
 
 #define HIF_USB_START BIT(0)
-- 
1.6.2.5

