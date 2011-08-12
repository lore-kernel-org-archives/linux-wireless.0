Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1918 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab1HLNfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/14] staging: brcm80211: remove iovar IOV_BLOCKSIZE in
 brcmfmac
Date: Fri, 12 Aug 2011 15:34:49 +0200
Message-ID: <1313156101-16817-3-git-send-email-arend@broadcom.com> (sfid-20110812_153522_287747_9F1AD863)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Iovar IOV_BLOCKSIZE code is not actually setting the sdio
function's block size. Use cur_blksize provided by mmc core where
necessary.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   52 ---------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   31 +------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    1 -
 3 files changed, 1 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1256847..a2fba4f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -169,14 +169,12 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0)
 	}
 
 	sd->num_funcs = 2;
-	sd->client_block_size[0] = 64;
 
 	gInstance->sd = sd;
 
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[1]);
 
-	sd->client_block_size[1] = 64;
 	err_ret = sdio_set_block_size(gInstance->func[1], 64);
 	if (err_ret)
 		BRCMF_ERROR(("%s: Failed to set F1 blocksize\n", __func__));
@@ -188,7 +186,6 @@ struct sdioh_info *brcmf_sdioh_attach(void *bar0)
 		/* Claim host controller F2 */
 		sdio_claim_host(gInstance->func[2]);
 
-		sd->client_block_size[2] = sd_f2_blocksize;
 		err_ret =
 		    sdio_set_block_size(gInstance->func[2], sd_f2_blocksize);
 		if (err_ret)
@@ -273,7 +270,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 /* IOVar table */
 enum {
 	IOV_MSGLEVEL = 1,
-	IOV_BLOCKSIZE,
 	IOV_NUMINTS,
 	IOV_DEVREG,
 	IOV_HCIREGS,
@@ -281,8 +277,6 @@ enum {
 };
 
 const struct brcmu_iovar sdioh_iovars[] = {
-	{"sd_blocksize", IOV_BLOCKSIZE, 0, IOVT_UINT32, 0},/* ((fn << 16) |
-								 size) */
 	{"sd_numints", IOV_NUMINTS, 0, IOVT_UINT32, 0},
 	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
@@ -346,52 +340,6 @@ brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 
 	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
 	switch (actionid) {
-	case IOV_GVAL(IOV_BLOCKSIZE):
-		if ((u32) int_val > si->num_funcs) {
-			bcmerror = -EINVAL;
-			break;
-		}
-		int_val = (s32) si->client_block_size[int_val];
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_SVAL(IOV_BLOCKSIZE):
-		{
-			uint func = ((u32) int_val >> 16);
-			uint blksize = (u16) int_val;
-			uint maxsize;
-
-			if (func > si->num_funcs) {
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			switch (func) {
-			case 0:
-				maxsize = 32;
-				break;
-			case 1:
-				maxsize = 64;
-				break;
-			case 2:
-				maxsize = 512;
-				break;
-			default:
-				maxsize = 0;
-			}
-			if (blksize > maxsize) {
-				bcmerror = -EINVAL;
-				break;
-			}
-			if (!blksize)
-				blksize = maxsize;
-
-			/* Now set it */
-			si->client_block_size[func] = blksize;
-
-			break;
-		}
-
 	case IOV_GVAL(IOV_RXCHAIN):
 		int_val = false;
 		memcpy(arg, &int_val, val_size);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 74c9d4e..6e1fe5c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3168,24 +3168,6 @@ brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 		bcmerror = brcmf_sdcard_iovar_op(bus->sdiodev, name, params,
 						 plen, arg, len, set);
 
-		/* Similar check for blocksize change */
-		if (set && strcmp(name, "sd_blocksize") == 0) {
-			s32 fnum = 2;
-			if (brcmf_sdcard_iovar_op
-			    (bus->sdiodev, "sd_blocksize", &fnum, sizeof(s32),
-			     &bus->blocksize, sizeof(s32),
-			     false) != 0) {
-				bus->blocksize = 0;
-				BRCMF_ERROR(("%s: fail on %s get\n", __func__,
-					     "sd_blocksize"));
-			} else {
-				BRCMF_INFO(("%s: noted sd_blocksize update,"
-					    " value now %d\n", __func__,
-					    bus->blocksize));
-			}
-		}
-		bus->roundup = min(max_roundup, bus->blocksize);
-
 		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
 		    !bus->dpc_sched) {
 			bus->activity = false;
@@ -5679,8 +5661,6 @@ fail:
 
 static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 {
-	s32 fnum;
-
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
 #ifdef SDTEST
@@ -5705,16 +5685,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
 	/* Query the F2 block size, set roundup accordingly */
-	fnum = 2;
-	if (brcmf_sdcard_iovar_op(bus->sdiodev, "sd_blocksize", &fnum,
-				  sizeof(s32), &bus->blocksize,
-				  sizeof(s32), false) != 0) {
-		bus->blocksize = 0;
-		BRCMF_ERROR(("%s: fail on %s get\n", __func__, "sd_blocksize"));
-	} else {
-		BRCMF_INFO(("%s: Initial value for %s is %d\n",
-			    __func__, "sd_blocksize", bus->blocksize));
-	}
+	bus->blocksize = bus->sdiodev->func2->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
 
 	/* Query if bus module supports packet chaining,
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index c5a68c0..c61a186 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -129,7 +129,6 @@ struct sdioh_info {
 	int intrcount;		/* Client interrupts */
 	bool sd_blockmode;	/* sd_blockmode == false => 64 Byte Cmd 53s. */
 	/*  Must be on for sd_multiblock to be effective */
-	int client_block_size[SDIOD_MAX_IOFUNCS];	/* Blocksize */
 	u8 num_funcs;	/* Supported funcs on client */
 	u32 com_cis_ptr;
 	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
-- 
1.7.4.1


