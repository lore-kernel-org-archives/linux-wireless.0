Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35836 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbbE1MTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:19:43 -0400
Received: by labko7 with SMTP id ko7so26522576lab.2
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:19:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: support NVRAMs containing pci devpaths (instead of pcie)
Date: Thu, 28 May 2015 14:19:21 +0200
Message-Id: <1432815561-6639-1-git-send-email-zajec5@gmail.com> (sfid-20150528_142000_608951_FD402223)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently Broadcom added support for NVRAMs with entries for multiple
PCIe devices. One of the supported formats is based on prefixes defined
like: devpath0=pcie/1/4/ and entries like 0:foo=bar 0:baz=qux etc.

Unfortunately there are also a bit older devices using different way of
defining prefixes, e.g. SmartRG SR400ac (2 x BCM43602) with entries:
devpath0=pci/1/1/
devpath1=pci/2/1
Broadcom stated this old format will never be used/supported by brcmfmac
but given the simplicity of this patch I'll insist on supporting it.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index b72df87..743f16b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -232,6 +232,8 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 				    u16 bus_nr)
 {
 	/* Device path with a leading '=' key-value separator */
+	char pci_path[] = "=pci/?/?";
+	size_t pci_len;
 	char pcie_path[] = "=pcie/?/?";
 	size_t pcie_len;
 
@@ -251,6 +253,9 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 	/* First search for the devpathX and see if it is the configuration
 	 * for domain_nr/bus_nr. Search complete nvp
 	 */
+	snprintf(pci_path, sizeof(pci_path), "=pci/%d/%d", domain_nr,
+		 bus_nr);
+	pci_len = strlen(pci_path);
 	snprintf(pcie_path, sizeof(pcie_path), "=pcie/%d/%d", domain_nr,
 		 bus_nr);
 	pcie_len = strlen(pcie_path);
@@ -260,8 +265,9 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
 		/* Format: devpathX=pcie/Y/Z/
 		 * Y = domain_nr, Z = bus_nr, X = virtual ID
 		 */
-		if ((strncmp(&nvp->nvram[i], "devpath", 7) == 0) &&
-		    (strncmp(&nvp->nvram[i + 8], pcie_path, pcie_len) == 0)) {
+		if (strncmp(&nvp->nvram[i], "devpath", 7) == 0 &&
+		    (!strncmp(&nvp->nvram[i + 8], pci_path, pci_len) ||
+		     !strncmp(&nvp->nvram[i + 8], pcie_path, pcie_len))) {
 			id = nvp->nvram[i + 7] - '0';
 			found = true;
 			break;
-- 
1.8.4.5

