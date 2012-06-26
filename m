Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4074 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2FZT1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: use firmware data buffer directly for
 nvram
Date: Tue, 26 Jun 2012 21:26:37 +0200
Message-ID: <1340738800-14087-5-git-send-email-arend@broadcom.com> (sfid-20120626_212734_955610_AE307478)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The nvram file could be parsed directly in the data buffer in the
firmware structure passed by request_firmware function. This patch
gets rid of the redundant memcpy.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   97 ++++++--------------
 1 file changed, 30 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 581e7d9..a50796c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3336,39 +3336,6 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static int brcmf_sdbrcm_downloadvars(struct brcmf_sdio *bus, void *arg, int len)
-{
-	int bcmerror = 0;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* Basic sanity checks */
-	if (bus->sdiodev->bus_if->drvr_up) {
-		bcmerror = -EISCONN;
-		goto err;
-	}
-	if (!len) {
-		bcmerror = -EOVERFLOW;
-		goto err;
-	}
-
-	/* Free the old ones and replace with passed variables */
-	kfree(bus->vars);
-
-	bus->vars = kmalloc(len, GFP_ATOMIC);
-	bus->varsz = bus->vars ? len : 0;
-	if (bus->vars == NULL) {
-		bcmerror = -ENOMEM;
-		goto err;
-	}
-
-	/* Copy the passed variables, which should include the
-		 terminating double-null */
-	memcpy(bus->vars, arg, bus->varsz);
-err:
-	return bcmerror;
-}
-
 static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 {
 	int bcmerror = 0;
@@ -3573,13 +3540,21 @@ err:
  * by two NULs.
 */
 
-static uint brcmf_process_nvram_vars(char *varbuf, uint len)
+static int brcmf_process_nvram_vars(struct brcmf_sdio *bus)
 {
+	char *varbuf;
 	char *dp;
 	bool findNewline;
 	int column;
-	uint buf_len, n;
+	int ret = 0;
+	uint buf_len, n, len;
+
+	len = bus->firmware->size;
+	varbuf = vmalloc(len);
+	if (!varbuf)
+		return -ENOMEM;
 
+	memcpy(varbuf, bus->firmware->data, len);
 	dp = varbuf;
 
 	findNewline = false;
@@ -3608,56 +3583,44 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len)
 		column++;
 	}
 	buf_len = dp - varbuf;
-
 	while (dp < varbuf + n)
 		*dp++ = 0;
 
-	return buf_len;
+	kfree(bus->vars);
+
+	bus->varsz = buf_len + 1;
+	bus->vars = kmalloc(bus->varsz, GFP_KERNEL);
+	if (bus->vars == NULL) {
+		bus->varsz = 0;
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* copy the processed variables and add null termination */
+	memcpy(bus->vars, varbuf, buf_len);
+	bus->vars[buf_len] = 0;
+err:
+	vfree(varbuf);
+	return ret;
 }
 
 static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 {
-	uint len;
-	char *memblock = NULL;
-	char *bufp;
 	int ret;
 
+	if (bus->sdiodev->bus_if->drvr_up)
+		return -EISCONN;
+
 	ret = request_firmware(&bus->firmware, BRCMF_SDIO_NV_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
 		return ret;
 	}
-	bus->fw_ptr = 0;
-
-	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
-	if (memblock == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	len = brcmf_sdbrcm_get_image(memblock, MEMBLOCK, bus);
-
-	if (len > 0 && len < MEMBLOCK) {
-		bufp = (char *)memblock;
-		bufp[len] = 0;
-		len = brcmf_process_nvram_vars(bufp, len);
-		bufp += len;
-		*bufp++ = 0;
-		if (len)
-			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
-		if (ret)
-			brcmf_dbg(ERROR, "error downloading vars: %d\n", ret);
-	} else {
-		brcmf_dbg(ERROR, "error reading nvram file: %d\n", len);
-		ret = -EIO;
-	}
 
-err:
-	kfree(memblock);
+	ret = brcmf_process_nvram_vars(bus);
 
 	release_firmware(bus->firmware);
-	bus->fw_ptr = 0;
 
 	return ret;
 }
-- 
1.7.9.5


