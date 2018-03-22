Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52638 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751825AbeCVU2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:37 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 11/12] brcmfmac: get rid of brcmf_fw_get_full_name()
Date: Thu, 22 Mar 2018 21:28:30 +0100
Message-Id: <1521750511-12345-12-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212904_616365_1A3708DD)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function was pretty minimal and now it is called only from one
place so just get rid of it.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c    | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c14a02a..9277f4c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -628,13 +628,6 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	return 0;
 }
 
-static void brcmf_fw_get_full_name(char fw_name[BRCMF_FW_NAME_LEN],
-				   const char *fw_base, const char *extension)
-{
-	strlcat(fw_name, fw_base, BRCMF_FW_NAME_LEN);
-	strlcat(fw_name, extension, BRCMF_FW_NAME_LEN);
-}
-
 struct brcmf_fw_request *
 brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 		       struct brcmf_firmware_mapping mapping_table[],
@@ -685,9 +678,10 @@ struct brcmf_fw_request *
 					BRCMF_FW_NAME_LEN);
 			}
 		}
-		brcmf_fw_get_full_name(fwnames[j].path,
-				       mapping_table[i].fw_base,
-				       fwnames[j].extension);
+		strlcat(fwnames[j].path, mapping_table[i].fw_base,
+			BRCMF_FW_NAME_LEN);
+		strlcat(fwnames[j].path, fwnames[j].extension,
+			BRCMF_FW_NAME_LEN);
 		fwreq->items[j].path = fwnames[j].path;
 	}
 
-- 
1.9.1
