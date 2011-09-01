Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1175 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1IAJRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/30] staging: brcm80211: remove duplicate set sb
 window address function
Date: Thu, 1 Sep 2011 11:17:04 +0200
Message-ID: <1314868640-9425-15-git-send-email-rvossen@broadcom.com> (sfid-20110901_111804_874543_EA850627)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

In fullmac, brcmf_sdbrcm_set_siaddr_window and brcmf_sdcard_set_sbaddr_window
have identical fucntionality. Remove the one in dhd_sdio.c

Reported-by: Rafal Milecki <zajec5@gmail.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c    |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |   27 ++++-------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h |    3 ++
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 8448b8b..3672776 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -275,7 +275,7 @@ int brcmf_sdcard_cis_read(struct brcmf_sdio_dev *sdiodev, uint func, u8 * cis,
 	return status;
 }
 
-static int
+int
 brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index c1647eb..72e5629 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -948,24 +948,6 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size)
 		bus->ramsize = brcmf_dongle_memsize;
 }
 
-static int brcmf_sdbrcm_set_siaddr_window(struct brcmf_bus *bus, u32 address)
-{
-	int err = 0;
-	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-			       SBSDIO_FUNC1_SBADDRLOW,
-			       (address >> 8) & SBSDIO_SBADDRLOW_MASK, &err);
-	if (!err)
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				 SBSDIO_FUNC1_SBADDRMID,
-				 (address >> 16) & SBSDIO_SBADDRMID_MASK, &err);
-	if (!err)
-		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				       SBSDIO_FUNC1_SBADDRHIGH,
-				       (address >> 24) & SBSDIO_SBADDRHIGH_MASK,
-				       &err);
-	return err;
-}
-
 /* Turn backplane clock on or off */
 static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 {
@@ -1958,7 +1940,7 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		dsize = size;
 
 	/* Set the backplane window to include the start address */
-	bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
+	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
 	if (bcmerror) {
 		brcmf_dbg(ERROR, "window change failed\n");
 		goto xfer_done;
@@ -1981,7 +1963,8 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 		if (size) {
 			data += dsize;
 			address += dsize;
-			bcmerror = brcmf_sdbrcm_set_siaddr_window(bus, address);
+			bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
+								  address);
 			if (bcmerror) {
 				brcmf_dbg(ERROR, "window change failed\n");
 				break;
@@ -1993,7 +1976,7 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdbrcm_set_siaddr_window(bus,
+	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
 					   brcmf_sdcard_cur_sbwad(
 							bus->sdiodev)))
 		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
@@ -4838,7 +4821,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 	bus->alp_only = true;
 
 	/* Return the window to backplane enumeration space for core access */
-	if (brcmf_sdbrcm_set_siaddr_window(bus, SI_ENUM_BASE))
+	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, SI_ENUM_BASE))
 		brcmf_dbg(ERROR, "FAILED to return to SI_ENUM_BASE\n");
 
 #ifdef BCMDBG
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 03ae16a..9c55c4a 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -234,6 +234,9 @@ extern int brcmf_sdio_remove(struct brcmf_sdio_dev *sdiodev);
 /* Function to return current window addr */
 extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_dev *sdiodev);
 
+extern int brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev,
+					  u32 address);
+
 /* attach, return handler on success, NULL if failed.
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
-- 
1.7.4.1


