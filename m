Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37606 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbETJBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 05:01:18 -0400
Received: by wibt6 with SMTP id t6so52003076wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 02:01:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: simplify check finding NVRAM v1 device path
Date: Wed, 20 May 2015 11:01:08 +0200
Message-Id: <1432112468-24092-1-git-send-email-zajec5@gmail.com> (sfid-20150520_110125_572433_AC5EF5A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a simple use of snprintf and small buffer we can compare NVRAM
entry value with a full string. This way we avoid checking random chars
at magic offsets.
Tested on BCM43602 with NVRAM hacked to use v1 format.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 181a0e8..0d02e31 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -222,6 +222,10 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
 static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 				    u16 bus_nr)
 {
+	/* Device path with a leading '=' key-value separator */
+	char pcie_path[] = "=pcie/?/?";
+	size_t pcie_len;
+
 	u32 i, j;
 	bool found;
 	u8 *nvram;
@@ -238,6 +242,9 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 	/* First search for the devpathX and see if it is the configuration
 	 * for domain_nr/bus_nr. Search complete nvp
 	 */
+	snprintf(pcie_path, sizeof(pcie_path), "=pcie/%d/%d", domain_nr,
+		 bus_nr);
+	pcie_len = strlen(pcie_path);
 	found = false;
 	i = 0;
 	while (i < nvp->nvram_len - BRCMF_FW_NVRAM_DEVPATH_LEN) {
@@ -245,13 +252,10 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 		 * Y = domain_nr, Z = bus_nr, X = virtual ID
 		 */
 		if ((strncmp(&nvp->nvram[i], "devpath", 7) == 0) &&
-		    (strncmp(&nvp->nvram[i + 8], "=pcie/", 6) == 0)) {
-			if (((nvp->nvram[i + 14] - '0') == domain_nr) &&
-			    ((nvp->nvram[i + 16] - '0') == bus_nr)) {
-				id = nvp->nvram[i + 7] - '0';
-				found = true;
-				break;
-			}
+		    (strncmp(&nvp->nvram[i + 8], pcie_path, pcie_len) == 0)) {
+			id = nvp->nvram[i + 7] - '0';
+			found = true;
+			break;
 		}
 		while (nvp->nvram[i] != 0)
 			i++;
-- 
1.8.4.5

