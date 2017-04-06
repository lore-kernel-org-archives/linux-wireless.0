Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51826 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932616AbdDFQst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 12:48:49 -0400
Date: Thu, 6 Apr 2017 17:48:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] nfc: fix get_unaligned_...() misuses
Message-ID: <20170406164847.GU29622@ZenIV.linux.org.uk> (sfid-20170406_184944_118750_AE3DDD47)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* use unaligned.h, not unaligned/access_ok.h
* if a local variable of type uint16_t is unaligned, your compiler is FUBAR
* the whole point of get_unaligned_... is to avoid memcpy + ..._to_cpu().
  Using it *after* memcpy() (into aligned object, no less) is pointless.
  
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index f8dcdf4b24f6..d3b04da0f16f 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
@@ -281,12 +281,11 @@ static int process_state_fw_dnld(struct nfcmrvl_private *priv,
 			return -EINVAL;
 		}
 		skb_pull(skb, 1);
-		memcpy(&len, skb->data, 2);
+		len = get_unaligned_le16(skb->data);
 		skb_pull(skb, 2);
+		comp_len = get_unaligned_le16(skb->data);
 		memcpy(&comp_len, skb->data, 2);
 		skb_pull(skb, 2);
-		len = get_unaligned_le16(&len);
-		comp_len = get_unaligned_le16(&comp_len);
 		if (((~len) & 0xFFFF) != comp_len) {
 			nfc_err(priv->dev, "bad len complement: %x %x %x",
 				len, comp_len, (~len & 0xFFFF));
diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index 5291797324ba..f27b03e3b5ae 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -24,7 +24,7 @@
 #include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
-#include <linux/unaligned/access_ok.h>
+#include <linux/unaligned.h>
 
 #include "nxp-nci.h"
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 36099e557730..9da35d2898fc 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -36,7 +36,6 @@
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/platform_data/nxp-nci.h>
-#include <linux/unaligned/access_ok.h>
 
 #include <net/nfc/nfc.h>
 
@@ -127,7 +126,7 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
 		goto fw_read_exit;
 	}
 
-	frame_len = (get_unaligned_be16(&header) & NXP_NCI_FW_FRAME_LEN_MASK) +
+	frame_len = (be16_to_cpu(header) & NXP_NCI_FW_FRAME_LEN_MASK) +
 		    NXP_NCI_FW_CRC_LEN;
 
 	*skb = alloc_skb(NXP_NCI_FW_HDR_LEN + frame_len, GFP_KERNEL);
