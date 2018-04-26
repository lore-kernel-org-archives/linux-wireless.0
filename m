Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:44256 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754865AbeDZKRN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:17:13 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: constify firmware mapping tables
Date: Thu, 26 Apr 2018 12:16:49 +0200
Message-Id: <1524737811-1965-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180426_121724_729732_0B14A30A)
In-Reply-To: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1524737811-1965-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information in the firmware mapping does not need to be modified
so it can be static const.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 9277f4c..6e47f14 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -630,7 +630,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 
 struct brcmf_fw_request *
 brcmf_fw_alloc_request(u32 chip, u32 chiprev,
-		       struct brcmf_firmware_mapping mapping_table[],
+		       const struct brcmf_firmware_mapping mapping_table[],
 		       u32 table_size, struct brcmf_fw_name *fwnames,
 		       u32 n_fwnames)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 79a2109..2893e56 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -80,7 +80,7 @@ struct brcmf_fw_name {
 
 struct brcmf_fw_request *
 brcmf_fw_alloc_request(u32 chip, u32 chiprev,
-		       struct brcmf_firmware_mapping mapping_table[],
+		       const struct brcmf_firmware_mapping mapping_table[],
 		       u32 table_size, struct brcmf_fw_name *fwnames,
 		       u32 n_fwnames);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 6e25ff9..9708647 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -59,7 +59,7 @@ enum brcmf_pcie_state {
 BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 
-static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
+static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
 	BRCMF_FW_ENTRY(BRCM_CC_43465_CHIP_ID, 0xFFFFFFF0, 4366C),
 	BRCMF_FW_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 1037df7..412a05b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -619,7 +619,7 @@ struct sdiod_drive_str {
 BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
 BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
 
-static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
+static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
 	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x0000001F, 43241B0),
 	BRCMF_FW_ENTRY(BRCM_CC_43241_CHIP_ID, 0x00000020, 43241B4),
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index a0873ad..a4308c6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -52,7 +52,7 @@
 BRCMF_FW_DEF(43569, "brcmfmac43569");
 BRCMF_FW_DEF(4373, "brcmfmac4373");
 
-static struct brcmf_firmware_mapping brcmf_usb_fwnames[] = {
+static const struct brcmf_firmware_mapping brcmf_usb_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),
 	BRCMF_FW_ENTRY(BRCM_CC_43235_CHIP_ID, 0x00000008, 43236B),
 	BRCMF_FW_ENTRY(BRCM_CC_43236_CHIP_ID, 0x00000008, 43236B),
-- 
1.9.1
