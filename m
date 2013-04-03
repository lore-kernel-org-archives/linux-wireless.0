Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4063 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760341Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/25] brcmfmac: add dedicated log level for low-level
 sdio debugging
Date: Wed, 3 Apr 2013 12:40:44 +0200
Message-ID: <1364985650-11719-20-git-send-email-arend@broadcom.com> (sfid-20130403_124309_735921_1DBD2AA8)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The low-level sdio code has a large number of trace and info messages
that are mostly useful looking into bus specific issues. For tracing
higher-level driver functions it is better to have a dedicated level
for low-level sdio debugging.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Change-Id: Ia424ff18d9033b97aeffc248358e50c51805e815
Reviewed-on: http://lb-bun-88.bun.broadcom.com:8080/74
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   30 +++++-----
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   60 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   34 +++++------
 4 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 11fd1c7..f3149de 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -65,7 +65,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 	u8 data;
 	unsigned long flags;
 
-	brcmf_dbg(TRACE, "Entering: irq %d\n", sdiodev->irq);
+	brcmf_dbg(SDIO, "Entering: irq %d\n", sdiodev->irq);
 
 	ret = request_irq(sdiodev->irq, brcmf_sdio_irqhandler,
 			  sdiodev->irq_flags, "brcmf_oob_intr",
@@ -102,7 +102,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
-	brcmf_dbg(TRACE, "Entering\n");
+	brcmf_dbg(SDIO, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, 0, NULL);
@@ -136,7 +136,7 @@ static void brcmf_sdio_dummy_irqhandler(struct sdio_func *func)
 
 int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
-	brcmf_dbg(TRACE, "Entering\n");
+	brcmf_dbg(SDIO, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_claim_irq(sdiodev->func[1], brcmf_sdio_irqhandler);
@@ -148,7 +148,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 int brcmf_sdio_intr_unregister(struct brcmf_sdio_dev *sdiodev)
 {
-	brcmf_dbg(TRACE, "Entering\n");
+	brcmf_dbg(SDIO, "Entering\n");
 
 	sdio_claim_host(sdiodev->func[1]);
 	sdio_release_irq(sdiodev->func[2]);
@@ -253,9 +253,9 @@ u8 brcmf_sdio_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u8 data;
 	int retval;
 
-	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
-	brcmf_dbg(INFO, "data:0x%02x\n", data);
+	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -268,9 +268,9 @@ u32 brcmf_sdio_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data;
 	int retval;
 
-	brcmf_dbg(INFO, "addr:0x%08x\n", addr);
+	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, false);
-	brcmf_dbg(INFO, "data:0x%08x\n", data);
+	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 	if (ret)
 		*ret = retval;
@@ -283,7 +283,7 @@ void brcmf_sdio_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(INFO, "addr:0x%08x, data:0x%02x\n", addr, data);
+	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
 
 	if (ret)
@@ -295,7 +295,7 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(INFO, "addr:0x%08x, data:0x%08x\n", addr, data);
+	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
 	retval = brcmf_sdio_regrw_helper(sdiodev, addr, &data, true);
 
 	if (ret)
@@ -358,7 +358,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint width;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
@@ -381,7 +381,7 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint width;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pktq->qlen);
 
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
@@ -428,7 +428,7 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	uint bar0 = addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
 
-	brcmf_dbg(INFO, "fun = %d, addr = 0x%x, size = %d\n",
+	brcmf_dbg(SDIO, "fun = %d, addr = 0x%x, size = %d\n",
 		  fn, addr, pkt->len);
 
 	/* Async not implemented yet */
@@ -492,13 +492,13 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 int brcmf_sdcard_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 {
 	char t_func = (char)fn;
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
 	brcmf_sdioh_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
 				 SDIO_CCCR_ABORT, &t_func);
 
-	brcmf_dbg(TRACE, "Exit\n");
+	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d92d373..7165489 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -139,7 +139,7 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 {
 	int err_ret;
 
-	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
+	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
 
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
 	if (brcmf_pm_resume_error(sdiodev))
@@ -179,7 +179,7 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 		return -EINVAL;
 	}
 
-	brcmf_dbg(INFO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		  rw, func, addr, nbytes);
 
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
@@ -252,7 +252,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 
 	struct sk_buff *pkt;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	brcmf_pm_resume_wait(sdiodev, &sdiodev->request_chain_wait);
 	if (brcmf_pm_resume_error(sdiodev))
@@ -270,7 +270,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 				  write ? "TX" : "RX", pkt, SGCount, addr,
 				  pkt_len, err_ret);
 		} else {
-			brcmf_dbg(TRACE, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
+			brcmf_dbg(SDIO, "%s xfr'd %p[%d], addr=0x%05x, len=%d\n",
 				  write ? "TX" : "RX", pkt, SGCount, addr,
 				  pkt_len);
 		}
@@ -280,7 +280,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 		SGCount++;
 	}
 
-	brcmf_dbg(TRACE, "Exit\n");
+	brcmf_dbg(SDIO, "Exit\n");
 	return err_ret;
 }
 
@@ -295,7 +295,7 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 	uint pkt_len;
 	bool fifo = (fix_inc == SDIOH_DATA_FIX);
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	if (pkt == NULL)
 		return -EINVAL;
@@ -314,7 +314,7 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 		brcmf_err("%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
 			  write ? "TX" : "RX", pkt, addr, pkt_len, status);
 	} else {
-		brcmf_dbg(TRACE, "%s xfr'd %p, addr=0x%05x, len=%d\n",
+		brcmf_dbg(SDIO, "%s xfr'd %p, addr=0x%05x, len=%d\n",
 			  write ? "TX" : "RX", pkt, addr, pkt_len);
 	}
 
@@ -350,12 +350,12 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	u32 fbraddr;
 	u8 func;
 
-	brcmf_dbg(TRACE, "\n");
+	brcmf_dbg(SDIO, "\n");
 
 	/* Get the Card's common CIS address */
 	sdiodev->func_cis_ptr[0] = brcmf_sdioh_get_cisaddr(sdiodev,
 							   SDIO_CCCR_CIS);
-	brcmf_dbg(INFO, "Card's Common CIS Ptr = 0x%x\n",
+	brcmf_dbg(SDIO, "Card's Common CIS Ptr = 0x%x\n",
 		  sdiodev->func_cis_ptr[0]);
 
 	/* Get the Card's function CIS (for each function) */
@@ -363,7 +363,7 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	     func <= sdiodev->num_funcs; func++, fbraddr += SDIOD_FBR_SIZE) {
 		sdiodev->func_cis_ptr[func] =
 		    brcmf_sdioh_get_cisaddr(sdiodev, SDIO_FBR_CIS + fbraddr);
-		brcmf_dbg(INFO, "Function %d CIS Ptr = 0x%x\n",
+		brcmf_dbg(SDIO, "Function %d CIS Ptr = 0x%x\n",
 			  func, sdiodev->func_cis_ptr[func]);
 	}
 
@@ -382,7 +382,7 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret = 0;
 
-	brcmf_dbg(TRACE, "\n");
+	brcmf_dbg(SDIO, "\n");
 
 	sdiodev->num_funcs = 2;
 
@@ -404,13 +404,13 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 
 out:
 	sdio_release_host(sdiodev->func[1]);
-	brcmf_dbg(TRACE, "Done\n");
+	brcmf_dbg(SDIO, "Done\n");
 	return err_ret;
 }
 
 void brcmf_sdioh_detach(struct brcmf_sdio_dev *sdiodev)
 {
-	brcmf_dbg(TRACE, "\n");
+	brcmf_dbg(SDIO, "\n");
 
 	/* Disable Function 2 */
 	sdio_claim_host(sdiodev->func[2]);
@@ -458,11 +458,11 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
 
-	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(TRACE, "Class=%x\n", func->class);
-	brcmf_dbg(TRACE, "sdio vendor ID: 0x%04x\n", func->vendor);
-	brcmf_dbg(TRACE, "sdio device ID: 0x%04x\n", func->device);
-	brcmf_dbg(TRACE, "Function#: %d\n", func->num);
+	brcmf_dbg(SDIO, "Enter\n");
+	brcmf_dbg(SDIO, "Class=%x\n", func->class);
+	brcmf_dbg(SDIO, "sdio vendor ID: 0x%04x\n", func->vendor);
+	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
+	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
 	/* Consume func num 1 but dont do anything with it. */
 	if (func->num == 1)
@@ -501,13 +501,13 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	if (err)
 		goto fail;
 
-	brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
+	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdio_probe...\n");
 	err = brcmf_sdio_probe(sdiodev);
 	if (err) {
 		brcmf_err("F2 error, probe failed %d...\n", err);
 		goto fail;
 	}
-	brcmf_dbg(TRACE, "F2 init completed...\n");
+	brcmf_dbg(SDIO, "F2 init completed...\n");
 	return 0;
 
 fail:
@@ -523,10 +523,10 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
 
-	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(TRACE, "sdio vendor ID: 0x%04x\n", func->vendor);
-	brcmf_dbg(TRACE, "sdio device ID: 0x%04x\n", func->device);
-	brcmf_dbg(TRACE, "Function: %d\n", func->num);
+	brcmf_dbg(SDIO, "Enter\n");
+	brcmf_dbg(SDIO, "sdio vendor ID: 0x%04x\n", func->vendor);
+	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
+	brcmf_dbg(SDIO, "Function: %d\n", func->num);
 
 	if (func->num != 1 && func->num != 2)
 		return;
@@ -543,7 +543,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 		kfree(sdiodev);
 	}
 
-	brcmf_dbg(TRACE, "Exit\n");
+	brcmf_dbg(SDIO, "Exit\n");
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -554,7 +554,7 @@ static int brcmf_sdio_suspend(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	int ret = 0;
 
-	brcmf_dbg(TRACE, "\n");
+	brcmf_dbg(SDIO, "\n");
 
 	atomic_set(&sdiodev->suspend, true);
 
@@ -645,7 +645,7 @@ static struct platform_driver brcmf_sdio_pd = {
 
 void brcmf_sdio_exit(void)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 
@@ -656,7 +656,7 @@ void brcmf_sdio_init(void)
 {
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	ret = platform_driver_register(&brcmf_sdio_pd);
 
@@ -666,7 +666,7 @@ void brcmf_sdio_init(void)
 #else
 void brcmf_sdio_exit(void)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	sdio_unregister_driver(&brcmf_sdmmc_driver);
 }
@@ -675,7 +675,7 @@ void brcmf_sdio_init(void)
 {
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	ret = sdio_register_driver(&brcmf_sdmmc_driver);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index ef93fe4..30c2e9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -34,6 +34,7 @@
 #define BRCMF_SCAN_VAL	0x00004000
 #define BRCMF_CONN_VAL	0x00008000
 #define BRCMF_CDC_VAL	0x00010000
+#define BRCMF_SDIO_VAL	0x00020000
 
 /* set default print format */
 #undef pr_fmt
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a5354e7..d2a9d78 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -675,7 +675,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 	u8 clkctl, clkreq, devctl;
 	unsigned long timeout;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	clkctl = 0;
 
@@ -713,7 +713,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
 			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					 devctl, &err);
-			brcmf_dbg(INFO, "CLKCTL: set PENDING\n");
+			brcmf_dbg(SDIO, "CLKCTL: set PENDING\n");
 			bus->clkstate = CLK_PENDING;
 
 			return 0;
@@ -750,7 +750,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 
 		/* Mark clock available */
 		bus->clkstate = CLK_AVAIL;
-		brcmf_dbg(INFO, "CLKCTL: turned ON\n");
+		brcmf_dbg(SDIO, "CLKCTL: turned ON\n");
 
 #if defined(DEBUG)
 		if (!bus->alp_only) {
@@ -775,7 +775,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		bus->clkstate = CLK_SDONLY;
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				 clkreq, &err);
-		brcmf_dbg(INFO, "CLKCTL: turned OFF\n");
+		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
 			brcmf_err("Failed access turning clock off: %d\n",
 				  err);
@@ -788,7 +788,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 /* Change idle/active SD state */
 static int brcmf_sdbrcm_sdclk(struct brcmf_sdio *bus, bool on)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	if (on)
 		bus->clkstate = CLK_SDONLY;
@@ -805,7 +805,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 	uint oldstate = bus->clkstate;
 #endif				/* DEBUG */
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
@@ -849,7 +849,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 		break;
 	}
 #ifdef DEBUG
-	brcmf_dbg(INFO, "%d -> %d\n", oldstate, bus->clkstate);
+	brcmf_dbg(SDIO, "%d -> %d\n", oldstate, bus->clkstate);
 #endif				/* DEBUG */
 
 	return 0;
@@ -862,7 +862,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 	u8 fcbits;
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Read mailbox data and ack that we did so */
 	ret = r_sdreg32(bus, &hmb_data,
@@ -875,7 +875,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 
 	/* Dongle recomposed rx frames, accept them again */
 	if (hmb_data & HMB_DATA_NAKHANDLED) {
-		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
+		brcmf_dbg(SDIO, "Dongle reports NAK handled, expect rtx of %d\n",
 			  bus->rx_seq);
 		if (!bus->rxskip)
 			brcmf_err("unexpected NAKHANDLED!\n");
@@ -896,7 +896,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 				  "expecting %d\n",
 				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
 		else
-			brcmf_dbg(INFO, "Dongle ready, protocol version %d\n",
+			brcmf_dbg(SDIO, "Dongle ready, protocol version %d\n",
 				  bus->sdpcm_ver);
 	}
 
@@ -970,7 +970,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	if (!retries)
 		brcmf_err("count never zeroed: last 0x%04x\n", lastrbc);
 	else
-		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
+		brcmf_dbg(SDIO, "flush took %d iterations\n", 0xffff - retries);
 
 	if (rtx) {
 		bus->sdcnt.rxrtx++;
@@ -1173,7 +1173,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	/* If packets, issue read(s) and send up packet chain */
 	/* Return sequence numbers consumed? */
 
-	brcmf_dbg(TRACE, "start: glomd %p glom %p\n",
+	brcmf_dbg(SDIO, "start: glomd %p glom %p\n",
 		  bus->glomd, skb_peek(&bus->glom));
 
 	/* If there's a descriptor, generate the packet chain */
@@ -2117,7 +2117,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 
-		brcmf_dbg(INFO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
+		brcmf_dbg(SDIO, "DPC: PENDING, devctl 0x%02x clkctl 0x%02x\n",
 			  devctl, clkctl);
 
 		if (SBSDIO_HTAV(clkctl)) {
@@ -2387,7 +2387,7 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 
 	/* Do the transfer(s) */
 	while (size) {
-		brcmf_dbg(INFO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
+		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
 			  write ? "write" : "read", dsize,
 			  sdaddr, address & SBSDIO_SBWINDOW_MASK);
 		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
@@ -2620,10 +2620,10 @@ brcmf_sdbrcm_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 						 msecs_to_jiffies(2000));
 
 		if (!bus->ctrl_frame_stat) {
-			brcmf_dbg(INFO, "ctrl_frame_stat == false\n");
+			brcmf_dbg(SDIO, "ctrl_frame_stat == false\n");
 			ret = 0;
 		} else {
-			brcmf_dbg(INFO, "ctrl_frame_stat == true\n");
+			brcmf_dbg(SDIO, "ctrl_frame_stat == true\n");
 			ret = -1;
 		}
 	}
@@ -2694,7 +2694,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 
 	addr = le32_to_cpu(addr_le);
 
-	brcmf_dbg(INFO, "sdpcm_shared address 0x%08X\n", addr);
+	brcmf_dbg(SDIO, "sdpcm_shared address 0x%08X\n", addr);
 
 	/*
 	 * Check if addr is valid.
-- 
1.7.10.4


