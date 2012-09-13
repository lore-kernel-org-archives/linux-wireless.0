Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2040 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab2IMTM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: raise SDIO host lock to higher level
Date: Thu, 13 Sep 2012 21:12:02 +0200
Message-ID: <1347563526-12513-7-git-send-email-arend@broadcom.com> (sfid-20120913_211242_119259_B567F0D4)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use SDIO host lock to protect the entire communication process
of register access or data read/write rather than function calls
to MMC/SDIO stack only. This can help to avoid unintentional
memory access and unexpected interruption.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   37 +++++++++++++++++---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   25 -------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    4 +++
 3 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 8e7e692..0c1d08a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -249,7 +249,9 @@ u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(INFO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -264,7 +266,9 @@ u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
+	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(INFO, "data:0x%08x\n", data);
 
 	if (ret)
@@ -279,7 +283,9 @@ void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x, data:0x%02x\n", addr, data);
+	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+	sdio_release_host(sdiodev->func[1]);
 
 	if (ret)
 		*ret = retval;
@@ -291,7 +297,9 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(INFO, "addr:0x%08x, data:0x%08x\n", addr, data);
+	sdio_claim_host(sdiodev->func[1]);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
+	sdio_release_host(sdiodev->func[1]);
 
 	if (ret)
 		*ret = retval;
@@ -356,15 +364,20 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
+	sdio_claim_host(sdiodev->func[1]);
+
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
 	if (err)
-		return err;
+		goto done;
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
 	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_READ,
 					 fn, addr, pkt);
 
+done:
+	sdio_release_host(sdiodev->func[1]);
+
 	return err;
 }
 
@@ -378,15 +391,20 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pktq->qlen);
 
+	sdio_claim_host(sdiodev->func[1]);
+
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	err = brcmf_sdcard_recv_prepare(sdiodev, fn, flags, width, &addr);
 	if (err)
-		return err;
+		goto done;
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
 	err = brcmf_sdioh_request_chain(sdiodev, incr_fix, SDIOH_READ, fn, addr,
 					pktq);
 
+done:
+	sdio_release_host(sdiodev->func[1]);
+
 	return err;
 }
 
@@ -428,10 +446,12 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (flags & SDIO_REQ_ASYNC)
 		return -ENOTSUPP;
 
+	sdio_claim_host(sdiodev->func[1]);
+
 	if (bar0 != sdiodev->sbwad) {
 		err = brcmf_sdcard_set_sbaddr_window(sdiodev, bar0);
 		if (err)
-			return err;
+			goto done;
 
 		sdiodev->sbwad = bar0;
 	}
@@ -443,8 +463,13 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	if (width == 4)
 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
-	return brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
-					  addr, pkt);
+	err = brcmf_sdioh_request_buffer(sdiodev, incr_fix, SDIOH_WRITE, fn,
+					 addr, pkt);
+
+done:
+	sdio_release_host(sdiodev->func[1]);
+
+	return err;
 }
 
 int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
@@ -485,8 +510,10 @@ int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
+	sdio_claim_host(sdiodev->func[1]);
 	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
 				 SDIO_CCCR_ABORT, &t_func);
+	sdio_release_host(sdiodev->func[1]);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 372f74e..c3247d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -103,7 +103,6 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 	if (regaddr == SDIO_CCCR_IOEx) {
 		sdfunc = sdiodev->func[2];
 		if (sdfunc) {
-			sdio_claim_host(sdfunc);
 			if (*byte & SDIO_FUNC_ENABLE_2) {
 				/* Enable Function 2 */
 				err_ret = sdio_enable_func(sdfunc);
@@ -119,7 +118,6 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 						  "Disable F2 failed:%d\n",
 						  err_ret);
 			}
-			sdio_release_host(sdfunc);
 		}
 	} else if ((regaddr == SDIO_CCCR_ABORT) ||
 		   (regaddr == SDIO_CCCR_IENx)) {
@@ -128,17 +126,13 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 		if (!sdfunc)
 			return -ENOMEM;
 		sdfunc->num = 0;
-		sdio_claim_host(sdfunc);
 		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
-		sdio_release_host(sdfunc);
 		kfree(sdfunc);
 	} else if (regaddr < 0xF0) {
 		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
 		err_ret = -EPERM;
 	} else {
-		sdio_claim_host(sdfunc);
 		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
-		sdio_release_host(sdfunc);
 	}
 
 	return err_ret;
@@ -159,7 +153,6 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 		/* handle F0 separately */
 		err_ret = brcmf_sdioh_f0_write_byte(sdiodev, regaddr, byte);
 	} else {
-		sdio_claim_host(sdiodev->func[func]);
 		if (rw) /* CMD52 Write */
 			sdio_writeb(sdiodev->func[func], *byte, regaddr,
 				    &err_ret);
@@ -170,7 +163,6 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 			*byte = sdio_readb(sdiodev->func[func], regaddr,
 					   &err_ret);
 		}
-		sdio_release_host(sdiodev->func[func]);
 	}
 
 	if (err_ret)
@@ -197,8 +189,6 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
-	/* Claim host controller */
-	sdio_claim_host(sdiodev->func[func]);
 
 	if (rw) {		/* CMD52 Write */
 		if (nbytes == 4)
@@ -219,9 +209,6 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
 	}
 
-	/* Release host controller */
-	sdio_release_host(sdiodev->func[func]);
-
 	if (err_ret)
 		brcmf_dbg(ERROR, "Failed to %s word, Err: 0x%08x\n",
 			  rw ? "write" : "read", err_ret);
@@ -275,9 +262,6 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
-	/* Claim host controller */
-	sdio_claim_host(sdiodev->func[func]);
-
 	skb_queue_walk(pktq, pkt) {
 		uint pkt_len = pkt->len;
 		pkt_len += 3;
@@ -300,9 +284,6 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 		SGCount++;
 	}
 
-	/* Release host controller */
-	sdio_release_host(sdiodev->func[func]);
-
 	brcmf_dbg(TRACE, "Exit\n");
 	return err_ret;
 }
@@ -328,9 +309,6 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 	if (brcmf_pm_resume_error(sdiodev))
 		return -EIO;
 
-	/* Claim host controller */
-	sdio_claim_host(sdiodev->func[func]);
-
 	pkt_len += 3;
 	pkt_len &= (uint)~3;
 
@@ -344,9 +322,6 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 			  write ? "TX" : "RX", pkt, addr, pkt_len);
 	}
 
-	/* Release host controller */
-	sdio_release_host(sdiodev->func[func]);
-
 	return status;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 90a3849..619f3cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2564,6 +2564,8 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 	else
 		dsize = size;
 
+	sdio_claim_host(bus->sdiodev->func[1]);
+
 	/* Set the backplane window to include the start address */
 	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
 	if (bcmerror) {
@@ -2605,6 +2607,8 @@ xfer_done:
 		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
 			  bus->sdiodev->sbwad);
 
+	sdio_release_host(bus->sdiodev->func[1]);
+
 	return bcmerror;
 }
 
-- 
1.7.9.5


