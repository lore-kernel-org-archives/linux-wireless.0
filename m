Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4026 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2FZT1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:27:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: reduce allocations needed during nvram
 data download
Date: Tue, 26 Jun 2012 21:26:38 +0200
Message-ID: <1340738800-14087-6-git-send-email-arend@broadcom.com> (sfid-20120626_212721_484251_39A0AC29)
In-Reply-To: <1340738800-14087-1-git-send-email-arend@broadcom.com>
References: <1340738800-14087-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The nvram data is preprocessed before being sent to the device
and just before sending an additional allocation was done that
assured word alignment of the data. This has moved to the
preprocessing step to reduce allocations and subsequent copying
of the nvram data.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   48 +++++++-------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a50796c..2ee19c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3339,9 +3339,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 {
 	int bcmerror = 0;
-	u32 varsize;
 	u32 varaddr;
-	u8 *vbuffer;
 	u32 varsizew;
 	__le32 varsizew_le;
 #ifdef DEBUG
@@ -3350,56 +3348,44 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 
 	/* Even if there are no vars are to be written, we still
 		 need to set the ramsize. */
-	varsize = bus->varsz ? roundup(bus->varsz, 4) : 0;
-	varaddr = (bus->ramsize - 4) - varsize;
+	varaddr = (bus->ramsize - 4) - bus->varsz;
 
 	if (bus->vars) {
-		vbuffer = kzalloc(varsize, GFP_ATOMIC);
-		if (!vbuffer)
-			return -ENOMEM;
-
-		memcpy(vbuffer, bus->vars, bus->varsz);
-
 		/* Write the vars list */
-		bcmerror =
-		    brcmf_sdbrcm_membytes(bus, true, varaddr, vbuffer, varsize);
+		bcmerror = brcmf_sdbrcm_membytes(bus, true, varaddr,
+						 bus->vars, bus->varsz);
 #ifdef DEBUG
 		/* Verify NVRAM bytes */
-		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n", varsize);
-		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
-		if (!nvram_ularray) {
-			kfree(vbuffer);
+		brcmf_dbg(INFO, "Compare NVRAM dl & ul; varsize=%d\n",
+			  bus->varsz);
+		nvram_ularray = kmalloc(bus->varsz, GFP_ATOMIC);
+		if (!nvram_ularray)
 			return -ENOMEM;
-		}
 
 		/* Upload image to verify downloaded contents. */
-		memset(nvram_ularray, 0xaa, varsize);
+		memset(nvram_ularray, 0xaa, bus->varsz);
 
 		/* Read the vars list to temp buffer for comparison */
-		bcmerror =
-		    brcmf_sdbrcm_membytes(bus, false, varaddr, nvram_ularray,
-				     varsize);
+		bcmerror = brcmf_sdbrcm_membytes(bus, false, varaddr,
+						 nvram_ularray, bus->varsz);
 		if (bcmerror) {
 			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
-				  bcmerror, varsize, varaddr);
+				  bcmerror, bus->varsz, varaddr);
 		}
 		/* Compare the org NVRAM with the one read from RAM */
-		if (memcmp(vbuffer, nvram_ularray, varsize))
+		if (memcmp(bus->vars, nvram_ularray, bus->varsz))
 			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
 		else
 			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
 
 		kfree(nvram_ularray);
 #endif				/* DEBUG */
-
-		kfree(vbuffer);
 	}
 
 	/* adjust to the user specified RAM */
 	brcmf_dbg(INFO, "Physical memory size: %d\n", bus->ramsize);
 	brcmf_dbg(INFO, "Vars are at %d, orig varsize is %d\n",
-		  varaddr, varsize);
-	varsize = ((bus->ramsize - 4) - varaddr);
+		  varaddr, bus->varsz);
 
 	/*
 	 * Determine the length token:
@@ -3410,13 +3396,13 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 		varsizew = 0;
 		varsizew_le = cpu_to_le32(0);
 	} else {
-		varsizew = varsize / 4;
+		varsizew = bus->varsz / 4;
 		varsizew = (~varsizew << 16) | (varsizew & 0x0000FFFF);
 		varsizew_le = cpu_to_le32(varsizew);
 	}
 
 	brcmf_dbg(INFO, "New varsize is %d, length token=0x%08x\n",
-		  varsize, varsizew);
+		  bus->varsz, varsizew);
 
 	/* Write the length token to the last word */
 	bcmerror = brcmf_sdbrcm_membytes(bus, true, (bus->ramsize - 4),
@@ -3587,8 +3573,8 @@ static int brcmf_process_nvram_vars(struct brcmf_sdio *bus)
 		*dp++ = 0;
 
 	kfree(bus->vars);
-
-	bus->varsz = buf_len + 1;
+	/* roundup needed for download to device */
+	bus->varsz = roundup(buf_len + 1, 4);
 	bus->vars = kmalloc(bus->varsz, GFP_KERNEL);
 	if (bus->vars == NULL) {
 		bus->varsz = 0;
-- 
1.7.9.5


