Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13958 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbbJHSdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:24 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/11] brcmfmac: rename firmware_path to alternative_fw_path
Date: Thu, 8 Oct 2015 20:33:13 +0200
Message-ID: <1444329201-3696-4-git-send-email-arend@broadcom.com> (sfid-20151008_203337_729350_D35F6375)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

In brcmfmac the module parameter "firmware_path" is used as an
alternative relative path under the search path used by firmware_class
or ueventhelper. Rename the parameter to alternative_fw_path to avoid
confusion.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 971920f..4248f3c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -29,7 +29,7 @@
 #define BRCMF_FW_NVRAM_PCIEDEV_LEN		10	/* pcie/1/4/ + \0 */
 
 char brcmf_firmware_path[BRCMF_FW_PATH_LEN];
-module_param_string(firmware_path, brcmf_firmware_path,
+module_param_string(alternative_fw_path, brcmf_firmware_path,
 		    BRCMF_FW_PATH_LEN, 0440);
 
 enum nvram_parser_state {
-- 
1.9.1

