Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38822 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbETHe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 03:34:28 -0400
Received: by wichy4 with SMTP id hy4so49436547wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 00:34:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: simplify check stripping v2 NVRAM
Date: Wed, 20 May 2015 09:34:21 +0200
Message-Id: <1432107261-7350-1-git-send-email-zajec5@gmail.com> (sfid-20150520_093432_011277_ADD3D9EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comparing NVRAM entry with a full filtering string is simpler than
comparing it with a short prefix and then checking random chars at magic
offsets. The cost of snprintf relatively low, we execute it just once.
Tested on BCM43602 with NVRAM hacked to use V2 format.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 8ff31ff..181a0e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -25,7 +25,7 @@
 
 #define BRCMF_FW_MAX_NVRAM_SIZE			64000
 #define BRCMF_FW_NVRAM_DEVPATH_LEN		19	/* devpath0=pcie/1/4/ */
-#define BRCMF_FW_NVRAM_PCIEDEV_LEN		9	/* pcie/1/4/ */
+#define BRCMF_FW_NVRAM_PCIEDEV_LEN		10	/* pcie/1/4/ + \0 */
 
 char brcmf_firmware_path[BRCMF_FW_PATH_LEN];
 module_param_string(firmware_path, brcmf_firmware_path,
@@ -297,6 +297,8 @@ fail:
 static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 				    u16 bus_nr)
 {
+	char prefix[BRCMF_FW_NVRAM_PCIEDEV_LEN];
+	size_t len;
 	u32 i, j;
 	u8 *nvram;
 
@@ -308,14 +310,13 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
 	 * Valid entries are of type pcie/X/Y/ where X = domain_nr and
 	 * Y = bus_nr.
 	 */
+	snprintf(prefix, sizeof(prefix), "pcie/%d/%d/", domain_nr, bus_nr);
+	len = strlen(prefix);
 	i = 0;
 	j = 0;
-	while (i < nvp->nvram_len - BRCMF_FW_NVRAM_PCIEDEV_LEN) {
-		if ((strncmp(&nvp->nvram[i], "pcie/", 5) == 0) &&
-		    (nvp->nvram[i + 6] == '/') && (nvp->nvram[i + 8] == '/') &&
-		    ((nvp->nvram[i + 5] - '0') == domain_nr) &&
-		    ((nvp->nvram[i + 7] - '0') == bus_nr)) {
-			i += BRCMF_FW_NVRAM_PCIEDEV_LEN;
+	while (i < nvp->nvram_len - len) {
+		if (strncmp(&nvp->nvram[i], prefix, len) == 0) {
+			i += len;
 			while (nvp->nvram[i] != 0) {
 				nvram[j] = nvp->nvram[i];
 				i++;
-- 
1.8.4.5

