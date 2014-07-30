Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56709 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbaG3LUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 1/8] brcmfmac: Do not use strcpy and strcat
Date: Wed, 30 Jul 2014 13:20:00 +0200
Message-ID: <1406719207-5126-2-git-send-email-arend@broadcom.com> (sfid-20140730_132035_182759_D9DDA328)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

Commit "c1b2053 brcmfmac: Make firmware path a module parameter"
introduced use of strcpy and strcat. The strcpy and strcat require
using null terminated strings and can cause out-of-bounds memory
access and subsequent corruption. This patch replaces these by
strncpy and strncat respectively to assure array boundaries are
not crossed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 25 ++++++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 67d91d5..f55f625 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -670,6 +670,8 @@ static int brcmf_sdio_get_fwnames(struct brcmf_chip *ci,
 				  struct brcmf_sdio_dev *sdiodev)
 {
 	int i;
+	uint fw_len, nv_len;
+	char end;
 
 	for (i = 0; i < ARRAY_SIZE(brcmf_fwname_data); i++) {
 		if (brcmf_fwname_data[i].chipid == ci->chip &&
@@ -682,16 +684,25 @@ static int brcmf_sdio_get_fwnames(struct brcmf_chip *ci,
 		return -ENODEV;
 	}
 
+	fw_len = sizeof(sdiodev->fw_name) - 1;
+	nv_len = sizeof(sdiodev->nvram_name) - 1;
 	/* check if firmware path is provided by module parameter */
 	if (brcmf_firmware_path[0] != '\0') {
-		if (brcmf_firmware_path[strlen(brcmf_firmware_path) - 1] != '/')
-			strcat(brcmf_firmware_path, "/");
-
-		strcpy(sdiodev->fw_name, brcmf_firmware_path);
-		strcpy(sdiodev->nvram_name, brcmf_firmware_path);
+		strncpy(sdiodev->fw_name, brcmf_firmware_path, fw_len);
+		strncpy(sdiodev->nvram_name, brcmf_firmware_path, nv_len);
+		fw_len -= strlen(sdiodev->fw_name);
+		nv_len -= strlen(sdiodev->nvram_name);
+
+		end = brcmf_firmware_path[strlen(brcmf_firmware_path) - 1];
+		if (end != '/') {
+			strncat(sdiodev->fw_name, "/", fw_len);
+			strncat(sdiodev->nvram_name, "/", nv_len);
+			fw_len--;
+			nv_len--;
+		}
 	}
-	strcat(sdiodev->fw_name, brcmf_fwname_data[i].bin);
-	strcat(sdiodev->nvram_name, brcmf_fwname_data[i].nv);
+	strncat(sdiodev->fw_name, brcmf_fwname_data[i].bin, fw_len);
+	strncat(sdiodev->nvram_name, brcmf_fwname_data[i].nv, nv_len);
 
 	return 0;
 }
-- 
1.9.1

