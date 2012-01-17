Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34249 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2AQMJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 07:09:19 -0500
Received: by mail-yw0-f46.google.com with SMTP id o21so33558yho.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 04:09:19 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 1/3] NFC: Add endian annotations to nfcwilink driver
Date: Tue, 17 Jan 2012 14:11:31 +0200
Message-Id: <1326802293-11539-2-git-send-email-ilane@ti.com> (sfid-20120117_130922_876892_2B892874)
In-Reply-To: <1326802293-11539-1-git-send-email-ilane@ti.com>
References: <1326802293-11539-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add endian annotations to TI nfcwilink driver.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 drivers/nfc/nfcwilink.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index 06c3642..ee60d08 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -28,6 +28,7 @@
  */
 #include <linux/platform_device.h>
 #include <linux/module.h>
+#include <linux/types.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
@@ -42,9 +43,9 @@
 #define NFCWILINK_REGISTER_TIMEOUT	8000	/* 8 sec */
 
 struct nfcwilink_hdr {
-	u8 chnl;
-	u8 opcode;
-	u16 len;
+	__u8 chnl;
+	__u8 opcode;
+	__le16 len;
 } __packed;
 
 struct nfcwilink {
@@ -212,7 +213,7 @@ static int nfcwilink_send(struct sk_buff *skb)
 		return -EBUSY;
 
 	/* add the ST hdr to the start of the buffer */
-	hdr.len = skb->len;
+	hdr.len = cpu_to_le16(skb->len);
 	memcpy(skb_push(skb, NFCWILINK_HDR_LEN), &hdr, NFCWILINK_HDR_LEN);
 
 	/* Insert skb to shared transport layer's transmit queue.
@@ -239,7 +240,7 @@ static int nfcwilink_probe(struct platform_device *pdev)
 {
 	static struct nfcwilink *drv;
 	int rc;
-	u32 protocols;
+	__u32 protocols;
 
 	nfc_dev_dbg(&pdev->dev, "probe entry");
 
-- 
1.7.0.4

