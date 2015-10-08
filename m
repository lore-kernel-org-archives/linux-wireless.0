Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32982 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbbJHSlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:41:18 -0400
Received: by pacex6 with SMTP id ex6so62128561pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2015 11:41:17 -0700 (PDT)
From: Eric Caruso <ejcaruso@google.com>
To: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com
Cc: linux-wireless@vger.kernel.org, leizh@broadcom.com,
	Eric Caruso <ejcaruso@google.com>
Subject: [PATCH] brcm80211: Add support for brcm4371
Date: Thu,  8 Oct 2015 11:40:46 -0700
Message-Id: <1444329646-11495-1-git-send-email-ejcaruso@google.com> (sfid-20151008_204121_690438_FF4637E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a new Broadcom chip and we should be able to recognize it.

Signed-off-by: Eric Caruso <ejcaruso@google.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 9 +++++++++
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 288f831..2195ee2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -651,6 +651,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43570_CHIP_ID:
 	case BRCM_CC_4358_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
+	case BRCM_CC_4371_CHIP_ID:
 		return 0x180000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 3a98c43..b2e13cc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -53,6 +53,8 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_43570_NVRAM_NAME		"brcm/brcmfmac43570-pcie.txt"
 #define BRCMF_PCIE_4358_FW_NAME			"brcm/brcmfmac4358-pcie.bin"
 #define BRCMF_PCIE_4358_NVRAM_NAME		"brcm/brcmfmac4358-pcie.txt"
+#define BRCMF_PCIE_4371_FW_NAME			"brcm/brcmfmac4371-pcie.bin"
+#define BRCMF_PCIE_4371_NVRAM_NAME		"brcm/brcmfmac4371-pcie.txt"
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
 
@@ -198,6 +200,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4371_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4371_NVRAM_NAME);
 
 
 struct brcmf_pcie_console {
@@ -1422,6 +1426,10 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_4358_FW_NAME;
 		nvram_name = BRCMF_PCIE_4358_NVRAM_NAME;
 		break;
+	case BRCM_CC_4371_CHIP_ID:
+		fw_name = BRCMF_PCIE_4371_FW_NAME;
+		nvram_name = BRCMF_PCIE_4371_NVRAM_NAME;
+		break;
 	default:
 		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
 		return -ENODEV;
@@ -1937,6 +1945,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_RAW_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 7a6daa3..611b6a3 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -47,6 +47,7 @@
 #define BRCM_CC_43570_CHIP_ID		43570
 #define BRCM_CC_4358_CHIP_ID		0x4358
 #define BRCM_CC_43602_CHIP_ID		43602
+#define BRCM_CC_4371_CHIP_ID		0x4371
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
@@ -65,6 +66,7 @@
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
 #define BRCM_PCIE_43602_RAW_DEVICE_ID	43602
+#define BRCM_PCIE_4371_DEVICE_ID	0x440d
 
 /* brcmsmac IDs */
 #define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
-- 
2.6.0.rc2.230.g3dd15c0

