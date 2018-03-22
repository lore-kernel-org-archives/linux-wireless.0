Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52612 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751839AbeCVU2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:37 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 10/12] brcmfmac: get rid of brcmf_fw_map_chip_to_name()
Date: Thu, 22 Mar 2018 21:28:29 +0100
Message-Id: <1521750511-12345-11-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212907_058342_C01A3FF4)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is no longer used so removing it.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 53 ----------------------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  4 --
 2 files changed, 57 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index f495d22..c14a02a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -635,59 +635,6 @@ static void brcmf_fw_get_full_name(char fw_name[BRCMF_FW_NAME_LEN],
 	strlcat(fw_name, extension, BRCMF_FW_NAME_LEN);
 }
 
-int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
-			      struct brcmf_firmware_mapping mapping_table[],
-			      u32 table_size, char fw_name[BRCMF_FW_NAME_LEN],
-			      char nvram_name[BRCMF_FW_NAME_LEN])
-{
-	char chipname[12];
-	u32 i;
-	char end;
-
-	for (i = 0; i < table_size; i++) {
-		if (mapping_table[i].chipid == chip &&
-		    mapping_table[i].revmask & BIT(chiprev))
-			break;
-	}
-
-	if (i == table_size) {
-		brcmf_err("Unknown chipid %d [%d]\n", chip, chiprev);
-		return -ENODEV;
-	}
-
-	brcmf_chip_name(chip, chiprev, chipname, sizeof(chipname));
-
-	/* check if firmware path is provided by module parameter */
-	if (brcmf_mp_global.firmware_path[0] != '\0') {
-		if (fw_name)
-			strlcpy(fw_name, brcmf_mp_global.firmware_path,
-				BRCMF_FW_NAME_LEN);
-		if (nvram_name)
-			strlcpy(nvram_name, brcmf_mp_global.firmware_path,
-				BRCMF_FW_NAME_LEN);
-
-		end = brcmf_mp_global.firmware_path[
-				strlen(brcmf_mp_global.firmware_path) - 1];
-		if (end != '/') {
-			if (fw_name)
-				strlcat(fw_name, "/", BRCMF_FW_NAME_LEN);
-			if (nvram_name)
-				strlcat(nvram_name, "/", BRCMF_FW_NAME_LEN);
-		}
-	}
-
-	brcmf_info("using %s for chip %s\n",
-		   mapping_table[i].fw_base, chipname);
-	if (fw_name)
-		brcmf_fw_get_full_name(fw_name,
-				       mapping_table[i].fw_base, ".bin");
-	if (nvram_name)
-		brcmf_fw_get_full_name(nvram_name,
-				       mapping_table[i].fw_base, ".txt");
-
-	return 0;
-}
-
 struct brcmf_fw_request *
 brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 		       struct brcmf_firmware_mapping mapping_table[],
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 1416fbb..79a2109 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -46,10 +46,6 @@ struct brcmf_firmware_mapping {
 #define BRCMF_FW_ENTRY(chipid, mask, name) \
 	{ chipid, mask, BRCM_ ## name ## _FIRMWARE_BASENAME }
 
-int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
-			      struct brcmf_firmware_mapping mapping_table[],
-			      u32 table_size, char fw_name[BRCMF_FW_NAME_LEN],
-			      char nvram_name[BRCMF_FW_NAME_LEN]);
 void brcmf_fw_nvram_free(void *nvram);
 
 enum brcmf_fw_type {
-- 
1.9.1
