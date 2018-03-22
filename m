Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52610 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751890AbeCVU2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:37 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 03/12] brcmfmac: use brcmf_chip_name() for consistency
Date: Thu, 22 Mar 2018 21:28:22 +0100
Message-Id: <1521750511-12345-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212842_295057_892AF372)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When logging the chip id/revision information make use of
brcmf_chip_name() so it is always the same.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c     | 5 ++---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 7 +++++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index bf45369..3b829fe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -926,9 +926,8 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 	brcmf_chip_name(ci->pub.chip, ci->pub.chiprev,
 			ci->pub.name, sizeof(ci->pub.name));
-	brcmf_dbg(INFO, "found %s chip: BCM%s, rev=%d\n",
-		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name,
-		  ci->pub.chiprev);
+	brcmf_dbg(INFO, "found %s chip: %s\n",
+		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name);
 
 	if (socitype == SOCI_SB) {
 		if (ci->pub.chip != BRCM_CC_4329_CHIP_ID) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 091b529..e2199f5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -25,6 +25,7 @@
 #include "firmware.h"
 #include "core.h"
 #include "common.h"
+#include "chip.h"
 
 #define BRCMF_FW_MAX_NVRAM_SIZE			64000
 #define BRCMF_FW_NVRAM_DEVPATH_LEN		19	/* devpath0=pcie/1/4/ */
@@ -567,6 +568,7 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 			      u32 table_size, char fw_name[BRCMF_FW_NAME_LEN],
 			      char nvram_name[BRCMF_FW_NAME_LEN])
 {
+	char chipname[12];
 	u32 i;
 	char end;
 
@@ -581,6 +583,8 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 		return -ENODEV;
 	}
 
+	brcmf_chip_name(chip, chiprev, chipname, sizeof(chipname));
+
 	/* check if firmware path is provided by module parameter */
 	if (brcmf_mp_global.firmware_path[0] != '\0') {
 		strlcpy(fw_name, brcmf_mp_global.firmware_path,
@@ -601,8 +605,7 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 	if ((nvram_name) && (mapping_table[i].nvram))
 		strlcat(nvram_name, mapping_table[i].nvram, BRCMF_FW_NAME_LEN);
 
-	brcmf_info("using %s for chip %#08x(%d) rev %#08x\n",
-		   fw_name, chip, chip, chiprev);
+	brcmf_info("using %s for chip %s\n", fw_name, chipname);
 
 	return 0;
 }
-- 
1.9.1
