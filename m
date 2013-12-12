Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45864 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3LLK7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:16 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/18] brcmfmac: use sdio functions to enable/disable F2
Date: Thu, 12 Dec 2013 11:58:53 +0100
Message-ID: <1386845946-9859-6-git-send-email-arend@broadcom.com> (sfid-20131212_122500_730423_D6F6BFC2)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of catching CCCR_IOEx register in F0 write access to
determine whether F2 state needs to change do it with direct
call to sdio_[enable/disable]_func().

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   29 +++++------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   33 ++++----------------
 2 files changed, 14 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 1975054..5919b45 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -53,6 +53,9 @@
 
 #define SDIO_FUNC1_BLOCKSIZE		64
 #define SDIO_FUNC2_BLOCKSIZE		512
+/* Maximum milliseconds to wait for F2 to come up */
+#define SDIO_WAIT_F2RDY	3000
+
 
 static irqreturn_t brcmf_sdio_oob_irqhandler(int irq, void *dev_id)
 {
@@ -205,27 +208,8 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 	 * Handle F2 enable/disable and Abort command
 	 * as a special case.
 	 */
-	if (regaddr == SDIO_CCCR_IOEx) {
-		sdfunc = sdiodev->func[2];
-		if (sdfunc) {
-			if (*byte & SDIO_FUNC_ENABLE_2) {
-				/* Enable Function 2 */
-				err_ret = sdio_enable_func(sdfunc);
-				if (err_ret)
-					brcmf_err("enable F2 failed:%d\n",
-						  err_ret);
-			} else {
-				/* Disable Function 2 */
-				err_ret = sdio_disable_func(sdfunc);
-				if (err_ret)
-					brcmf_err("Disable F2 failed:%d\n",
-						  err_ret);
-			}
-		} else {
-			err_ret = -ENOENT;
-		}
-	} else if ((regaddr == SDIO_CCCR_ABORT) ||
-		   (regaddr == SDIO_CCCR_IENx)) {
+	if ((regaddr == SDIO_CCCR_ABORT) ||
+	    (regaddr == SDIO_CCCR_IENx)) {
 		sdfunc = kmemdup(sdiodev->func[0], sizeof(struct sdio_func),
 				 GFP_KERNEL);
 		if (!sdfunc)
@@ -945,6 +929,9 @@ static int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 		goto out;
 	}
 
+	/* increase F2 timeout */
+	sdiodev->func[2]->enable_timeout = SDIO_WAIT_F2RDY;
+
 	/* Enable Function 1 */
 	err_ret = sdio_enable_func(sdiodev->func[1]);
 	if (err_ret) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 0f95f3e..c3f3d8d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -260,9 +260,6 @@ struct rte_console {
 #define MAX_HDR_READ	(1 << 6)
 #define MAX_RX_DATASZ	2048
 
-/* Maximum milliseconds to wait for F2 to come up */
-#define BRCMF_WAIT_F2RDY	3000
-
 /* Bump up limit on waiting for HT to account for first startup;
  * if the image is doing a CRC calculation before programming the PMU
  * for HT availability, it could take a couple hundred ms more, so
@@ -2265,8 +2262,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 
 	/* Turn off the bus (F2), free any pending packets */
 	brcmf_dbg(INTR, "disable SDIO interrupts\n");
-	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, SDIO_FUNC_ENABLE_1,
-			 NULL);
+	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
 
 	/* Clear any pending interrupts now that F2 is disabled */
 	w_sdreg32(bus, local_hostintmask,
@@ -3570,8 +3566,6 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
-	unsigned long timeout;
-	u8 ready, enable;
 	int err, ret = 0;
 	u8 saveclk;
 
@@ -3612,26 +3606,13 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	/* Enable function 2 (frame transfers) */
 	w_sdreg32(bus, SDPCM_PROT_VERSION << SMB_DATA_VERSION_SHIFT,
 		  offsetof(struct sdpcmd_regs, tosbmailboxdata));
-	enable = (SDIO_FUNC_ENABLE_1 | SDIO_FUNC_ENABLE_2);
-
-	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, enable, NULL);
+	err = sdio_enable_func(bus->sdiodev->func[SDIO_FUNC_2]);
 
-	timeout = jiffies + msecs_to_jiffies(BRCMF_WAIT_F2RDY);
-	ready = 0;
-	while (enable != ready) {
-		ready = brcmf_sdio_regrb(bus->sdiodev,
-					 SDIO_CCCR_IORx, NULL);
-		if (time_after(jiffies, timeout))
-			break;
-		else if (time_after(jiffies, timeout - BRCMF_WAIT_F2RDY + 50))
-			/* prevent busy waiting if it takes too long */
-			msleep_interruptible(20);
-	}
 
-	brcmf_dbg(INFO, "enable 0x%02x, ready 0x%02x\n", enable, ready);
+	brcmf_dbg(INFO, "enable F2: err=%d\n", err);
 
 	/* If F2 successfully enabled, set core and enable interrupts */
-	if (ready == enable) {
+	if (!err) {
 		/* Set up the interrupt mask and enable interrupts */
 		bus->hostintmask = HOSTINTMASK;
 		w_sdreg32(bus, bus->hostintmask,
@@ -3640,8 +3621,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_WATERMARK, 8, &err);
 	} else {
 		/* Disable F2 again */
-		enable = SDIO_FUNC_ENABLE_1;
-		brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx, enable, NULL);
+		sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
 		ret = -ENODEV;
 	}
 
@@ -3942,8 +3922,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 	sdio_claim_host(bus->sdiodev->func[1]);
 
 	/* Disable F2 to clear any intermediate frame state on the dongle */
-	brcmf_sdio_regwb(bus->sdiodev, SDIO_CCCR_IOEx,
-			 SDIO_FUNC_ENABLE_1, NULL);
+	sdio_disable_func(bus->sdiodev->func[SDIO_FUNC_2]);
 
 	bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 	bus->rxflow = false;
-- 
1.7.10.4

