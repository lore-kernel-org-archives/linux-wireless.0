Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35695 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbcAPPjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2016 10:39:16 -0500
Received: by mail-wm0-f48.google.com with SMTP id r129so4592967wmr.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jan 2016 07:39:15 -0800 (PST)
From: Arend van Spriel <aspriel@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <aspriel@gmail.com>
Subject: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc compilers
Date: Sat, 16 Jan 2016 16:39:13 +0100
Message-Id: <1452958753-12307-1-git-send-email-aspriel@gmail.com> (sfid-20160116_163949_058318_E20C3657)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With gcc < 4.3 __UNIQUE_ID does not create unique ids with the macro
BRCMF_FW_NVRAM_DEF. Fix this by removing the MODULE_FIRMWARE instance
for the nvram file. This file is not in linux-firmware repo so it may
not be needed anyway. Otherwise consider this as a temporary fix.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arend van Spriel <aspriel@gmail.com>
---
Hi Kalle,

Here a quick fix for the __UNIQUE_ID issue. Looking at the other
issue right now, which seems a bit more complicated.

Regards,
Arend
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index ef06f57..d3c9f0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -47,8 +47,7 @@ static const char BRCM_ ## fw_nvram_name ## _FIRMWARE_NAME[] = \
 	BRCMF_FW_DEFAULT_PATH fw; \
 static const char BRCM_ ## fw_nvram_name ## _NVRAM_NAME[] = \
 	BRCMF_FW_DEFAULT_PATH nvram; \
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw); \
-MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH nvram)
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH fw);
 
 #define BRCMF_FW_DEF(fw_name, fw) \
 static const char BRCM_ ## fw_name ## _FIRMWARE_NAME[] = \
-- 
1.9.1

