Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34470 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbbJNRtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 13:49:47 -0400
Received: by payp3 with SMTP id p3so12480534pay.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 10:49:46 -0700 (PDT)
From: Eric Caruso <ejcaruso@google.com>
To: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, leizh@broadcom.com,
	Eric Caruso <ejcaruso@google.com>
Subject: [PATCH v2] brcm80211: Add support for brcm4371
Date: Wed, 14 Oct 2015 10:49:09 -0700
Message-Id: <1444844949-8765-1-git-send-email-ejcaruso@google.com> (sfid-20151014_194954_402666_17C46A31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a new Broadcom chip and we should be able to recognize it.

Signed-off-by: Eric Caruso <ejcaruso@google.com>
---
v2: rebased.

 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 8 ++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index ffc3ace..f04833d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -682,6 +682,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43570_CHIP_ID:
 	case BRCM_CC_4358_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
+	case BRCM_CC_4371_CHIP_ID:
 		return 0x180000;
 	case BRCM_CC_4365_CHIP_ID:
 	case BRCM_CC_4366_CHIP_ID:
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 30baf35..c9caada 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -59,6 +59,8 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_4365_NVRAM_NAME		"brcm/brcmfmac4365b-pcie.txt"
 #define BRCMF_PCIE_4366_FW_NAME			"brcm/brcmfmac4366b-pcie.bin"
 #define BRCMF_PCIE_4366_NVRAM_NAME		"brcm/brcmfmac4366b-pcie.txt"
+#define BRCMF_PCIE_4371_FW_NAME			"brcm/brcmfmac4371-pcie.bin"
+#define BRCMF_PCIE_4371_NVRAM_NAME		"brcm/brcmfmac4371-pcie.txt"
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
 
@@ -212,6 +214,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_4365_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4365_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4366_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4366_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4371_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4371_NVRAM_NAME);
 
 
 struct brcmf_pcie_console {
@@ -1456,6 +1460,9 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_4366_FW_NAME;
 		nvram_name = BRCMF_PCIE_4366_NVRAM_NAME;
 		break;
+	case BRCM_CC_4371_CHIP_ID:
+		fw_name = BRCMF_PCIE_4371_FW_NAME;
+		nvram_name = BRCMF_PCIE_4371_NVRAM_NAME;
 	default:
 		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
 		return -ENODEV;
@@ -1995,6 +2002,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index d823734..aa06ea2 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -50,6 +50,7 @@
 #define BRCM_CC_43602_CHIP_ID		43602
 #define BRCM_CC_4365_CHIP_ID		0x4365
 #define BRCM_CC_4366_CHIP_ID		0x4366
+#define BRCM_CC_4371_CHIP_ID		0x4371
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
@@ -75,6 +76,7 @@
 #define BRCM_PCIE_4366_DEVICE_ID	0x43c3
 #define BRCM_PCIE_4366_2G_DEVICE_ID	0x43c4
 #define BRCM_PCIE_4366_5G_DEVICE_ID	0x43c5
+#define BRCM_PCIE_4371_DEVICE_ID	0x440d
 
 
 /* brcmsmac IDs */
-- 
2.6.0.rc2.230.g3dd15c0

