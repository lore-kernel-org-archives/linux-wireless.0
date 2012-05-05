Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1403 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab2EEB1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 21:27:50 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] brcmfmac: remove function brcmf_sdcard_regfail
Date: Fri, 4 May 2012 18:27:37 -0700
Message-ID: <1336181258-7305-11-git-send-email-frankyl@broadcom.com> (sfid-20120505_032830_636723_2098A1FB)
In-Reply-To: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
References: <1336181258-7305-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new interface brcmf_sdio_regr/w provides result of access
attempts. It is no longer necessary to use dedicated variable
and function to provide enquiry for failure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    8 +---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   46 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    4 --
 3 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index cd5f7d7..aec1bd6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -237,8 +237,7 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 						       func_num, addr, data, 4);
 	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
-	sdiodev->regfail = (ret != 0);
-	if (sdiodev->regfail)
+	if (ret != 0)
 		brcmf_dbg(ERROR, "failed with %d\n", ret);
 
 	return ret;
@@ -298,11 +297,6 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		*ret = retval;
 }
 
-bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev)
-{
-	return sdiodev->regfail;
-}
-
 static int brcmf_sdcard_recv_prepare(struct brcmf_sdio_dev *sdiodev, uint fn,
 				     uint flags, uint width, u32 *addr)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 5338f57..1dbf2be 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1026,9 +1026,9 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	/* Wait until the packet has been flushed (device/FIFO stable) */
 	for (lastrbc = retries = 0xffff; retries > 0; retries--) {
 		hi = brcmf_sdio_regrb(bus->sdiodev,
-				      SBSDIO_FUNC1_RFRAMEBCHI, NULL);
+				      SBSDIO_FUNC1_RFRAMEBCHI, &err);
 		lo = brcmf_sdio_regrb(bus->sdiodev,
-				      SBSDIO_FUNC1_RFRAMEBCLO, NULL);
+				      SBSDIO_FUNC1_RFRAMEBCLO, &err);
 		bus->f1regdata += 2;
 
 		if ((hi == 0) && (lo == 0))
@@ -1060,7 +1060,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	bus->nextlen = 0;
 
 	/* If we can't reach the device, signal failure */
-	if (err || brcmf_sdcard_regfail(bus->sdiodev))
+	if (err)
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 }
 
@@ -2221,10 +2221,11 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
 			/* Check device status, signal pending interrupt */
-			r_sdreg32(bus, &intstatus,
-				  offsetof(struct sdpcmd_regs, intstatus));
+			ret = r_sdreg32(bus, &intstatus,
+					offsetof(struct sdpcmd_regs,
+						 intstatus));
 			bus->f2txdata++;
-			if (brcmf_sdcard_regfail(bus->sdiodev))
+			if (ret != 0)
 				break;
 			if (intstatus & bus->hostintmask)
 				bus->ipend = true;
@@ -2347,6 +2348,7 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	uint framecnt = 0;	/* Temporary counter of tx/rx frames */
 	bool rxdone = true;	/* Flag for no more read data */
 	bool resched = false;	/* Flag indicating resched wanted */
+	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2357,7 +2359,6 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 	/* If waiting for HTAVAIL, check status */
 	if (bus->clkstate == CLK_PENDING) {
-		int err;
 		u8 clkctl, devctl = 0;
 
 #ifdef DEBUG
@@ -2414,16 +2415,17 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	/* Pending interrupt indicates new device status */
 	if (bus->ipend) {
 		bus->ipend = false;
-		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus));
+		err = r_sdreg32(bus, &newstatus,
+				offsetof(struct sdpcmd_regs, intstatus));
 		bus->f1regdata++;
-		if (brcmf_sdcard_regfail(bus->sdiodev))
+		if (err != 0)
 			newstatus = 0;
 		newstatus &= bus->hostintmask;
 		bus->fcstate = !!(newstatus & I_HMB_FC_STATE);
 		if (newstatus) {
-			w_sdreg32(bus, newstatus,
-				  offsetof(struct sdpcmd_regs, intstatus));
+			err = w_sdreg32(bus, newstatus,
+					offsetof(struct sdpcmd_regs,
+						 intstatus));
 			bus->f1regdata++;
 		}
 	}
@@ -2438,11 +2440,11 @@ static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	 */
 	if (intstatus & I_HMB_FC_CHANGE) {
 		intstatus &= ~I_HMB_FC_CHANGE;
-		w_sdreg32(bus, I_HMB_FC_CHANGE,
-			  offsetof(struct sdpcmd_regs, intstatus));
+		err = w_sdreg32(bus, I_HMB_FC_CHANGE,
+				offsetof(struct sdpcmd_regs, intstatus));
 
-		r_sdreg32(bus, &newstatus,
-			  offsetof(struct sdpcmd_regs, intstatus));
+		err = r_sdreg32(bus, &newstatus,
+				offsetof(struct sdpcmd_regs, intstatus));
 		bus->f1regdata += 2;
 		bus->fcstate =
 		    !!(newstatus & (I_HMB_FC_STATE | I_HMB_FC_CHANGE));
@@ -2513,17 +2515,17 @@ clkwait:
 			brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
 
 			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-					 SFC_WF_TERM, NULL);
+					 SFC_WF_TERM, &err);
 			bus->f1regdata++;
 
 			for (i = 0; i < 3; i++) {
 				u8 hi, lo;
 				hi = brcmf_sdio_regrb(bus->sdiodev,
 						      SBSDIO_FUNC1_WFRAMEBCHI,
-						      NULL);
+						      &err);
 				lo = brcmf_sdio_regrb(bus->sdiodev,
 						      SBSDIO_FUNC1_WFRAMEBCLO,
-						      NULL);
+						      &err);
 				bus->f1regdata += 2;
 				if ((hi == 0) && (lo == 0))
 					break;
@@ -2550,10 +2552,8 @@ clkwait:
 		 else await next interrupt */
 	/* On failed register access, all bets are off:
 		 no resched or interrupts */
-	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) ||
-	    brcmf_sdcard_regfail(bus->sdiodev)) {
-		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation %d\n",
-			  brcmf_sdcard_regfail(bus->sdiodev));
+	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) || (err != 0)) {
+		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation\n");
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		bus->intstatus = 0;
 	} else if (bus->clkstate == CLK_PENDING) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index a147535..6d2e665 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -146,7 +146,6 @@ struct brcmf_sdio_dev {
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
 	u32 sbwad;			/* Save backplane window address */
-	bool regfail;			/* status of last reg_r/w call */
 	void *bus;
 	atomic_t suspend;		/* suspend flag */
 	wait_queue_head_t request_byte_wait;
@@ -176,9 +175,6 @@ extern void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 extern void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			     u32 data, int *ret);
 
-/* Indicate if last reg read/write failed */
-extern bool brcmf_sdcard_regfail(struct brcmf_sdio_dev *sdiodev);
-
 /* Buffer transfer to/from device (client) core via cmd53.
  *   fn:       function number
  *   addr:     backplane address (i.e. >= regsva from attach)
-- 
1.7.9.5


