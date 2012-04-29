Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44988 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 13/19] brcmsmac: remove pcicore_find_pci_capability()
Date: Sun, 29 Apr 2012 02:50:37 +0200
Message-Id: <1335660643-26368-14-git-send-email-hauke@hauke-m.de> (sfid-20120429_025153_786650_382E2F63)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is now unreferenced

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c |   64 ----------------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h |    2 -
 2 files changed, 66 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 5de506d..2d615cb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -240,70 +240,6 @@ void pcicore_deinit(struct pcicore_info *pch)
 	kfree(pch);
 }
 
-/* return cap_offset if requested capability exists in the PCI config space */
-/* Note that it's caller's responsibility to make sure it's a pci bus */
-u8
-pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
-			    unsigned char *buf, u32 *buflen)
-{
-	u8 cap_id;
-	u8 cap_ptr = 0;
-	u32 bufsize;
-	u8 byte_val;
-
-	/* check for Header type 0 */
-	pci_read_config_byte(dev, PCI_HEADER_TYPE, &byte_val);
-	if ((byte_val & 0x7f) != PCI_HEADER_TYPE_NORMAL)
-		goto end;
-
-	/* check if the capability pointer field exists */
-	pci_read_config_byte(dev, PCI_STATUS, &byte_val);
-	if (!(byte_val & PCI_STATUS_CAP_LIST))
-		goto end;
-
-	pci_read_config_byte(dev, PCI_CAPABILITY_LIST, &cap_ptr);
-	/* check if the capability pointer is 0x00 */
-	if (cap_ptr == 0x00)
-		goto end;
-
-	/* loop thru the capability list
-	 * and see if the pcie capability exists
-	 */
-
-	pci_read_config_byte(dev, cap_ptr, &cap_id);
-
-	while (cap_id != req_cap_id) {
-		pci_read_config_byte(dev, cap_ptr + 1, &cap_ptr);
-		if (cap_ptr == 0x00)
-			break;
-		pci_read_config_byte(dev, cap_ptr, &cap_id);
-	}
-	if (cap_id != req_cap_id)
-		goto end;
-
-	/* found the caller requested capability */
-	if (buf != NULL && buflen != NULL) {
-		u8 cap_data;
-
-		bufsize = *buflen;
-		if (!bufsize)
-			goto end;
-		*buflen = 0;
-		/* copy the capability data excluding cap ID and next ptr */
-		cap_data = cap_ptr + 2;
-		if ((bufsize + cap_data) > PCI_SZPCR)
-			bufsize = PCI_SZPCR - cap_data;
-		*buflen = bufsize;
-		while (bufsize--) {
-			pci_read_config_byte(dev, cap_data, buf);
-			cap_data++;
-			buf++;
-		}
-	}
-end:
-	return cap_ptr;
-}
-
 /* ***** Register Access API */
 static uint
 pcie_readreg(struct bcma_device *core, uint addrtype, uint offset)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 460a33e..1e15ba9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -66,8 +66,6 @@ extern struct pcicore_info *pcicore_init(struct si_pub *sih,
 extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_up(struct pcicore_info *pch, int state);
 extern void pcicore_down(struct pcicore_info *pch, int state);
-extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
-				      unsigned char *buf, u32 *buflen);
 extern void pcicore_fixcfg(struct pcicore_info *pch);
 
 #endif /* _BRCM_NICPCI_H_ */
-- 
1.7.9.5

