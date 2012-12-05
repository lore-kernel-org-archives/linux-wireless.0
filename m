Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2434 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab2LEO0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/11] brcmfmac: error messages should not be suppressed
Date: Wed, 5 Dec 2012 15:25:58 +0100
Message-ID: <1354717564-7183-6-git-send-email-arend@broadcom.com> (sfid-20121205_152652_622324_453630F0)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The call to brcmf_dbg(ERROR, ...) only resulted in a log message
when compiled with -DDEBUG. Error messages are valuable for resolving
issues so this patch replaces it with brcmf_err(...) so they always
end up in the log.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   15 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   44 +++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   14 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   40 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   22 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   46 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  189 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   12 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |   14 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   76 ++++----
 11 files changed, 237 insertions(+), 249 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 334ddab..be35a2f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -67,9 +67,8 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 	u8 data;
 	unsigned long flags;
 
-	brcmf_dbg(TRACE, "Entering\n");
+	brcmf_dbg(TRACE, "Entering: irq %d\n", sdiodev->irq);
 
-	brcmf_dbg(ERROR, "requesting irq %d\n", sdiodev->irq);
 	ret = request_irq(sdiodev->irq, brcmf_sdio_irqhandler,
 			  sdiodev->irq_flags, "brcmf_oob_intr",
 			  &sdiodev->func[1]->dev);
@@ -184,7 +183,7 @@ brcmf_sdcard_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 		} while (err != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
 		if (err) {
-			brcmf_dbg(ERROR, "failed at addr:0x%0x\n",
+			brcmf_err("failed at addr:0x%0x\n",
 				  SBSDIO_FUNC1_SBADDRLOW + i);
 			break;
 		}
@@ -246,7 +245,7 @@ brcmf_sdio_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
 	if (ret != 0)
-		brcmf_dbg(ERROR, "failed with %d\n", ret);
+		brcmf_err("failed with %d\n", ret);
 
 	return ret;
 }
@@ -340,7 +339,7 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
 	if (!mypkt) {
-		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
 		return -EIO;
 	}
@@ -409,7 +408,7 @@ brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
 	if (!mypkt) {
-		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
 		return -EIO;
 	}
@@ -472,7 +471,7 @@ int brcmf_sdcard_rwdata(struct brcmf_sdio_dev *sdiodev, uint rw, u32 addr,
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
 	if (!mypkt) {
-		brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed: len %d\n",
+		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
 		return -EIO;
 	}
@@ -519,7 +518,7 @@ int brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdbrcm_probe(regs, sdiodev);
 	if (!sdiodev->bus) {
-		brcmf_dbg(ERROR, "device attach failed\n");
+		brcmf_err("device attach failed\n");
 		ret = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index a800502..d33e559 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -107,15 +107,13 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 				/* Enable Function 2 */
 				err_ret = sdio_enable_func(sdfunc);
 				if (err_ret)
-					brcmf_dbg(ERROR,
-						  "enable F2 failed:%d\n",
+					brcmf_err("enable F2 failed:%d\n",
 						  err_ret);
 			} else {
 				/* Disable Function 2 */
 				err_ret = sdio_disable_func(sdfunc);
 				if (err_ret)
-					brcmf_dbg(ERROR,
-						  "Disable F2 failed:%d\n",
+					brcmf_err("Disable F2 failed:%d\n",
 						  err_ret);
 			}
 		}
@@ -129,7 +127,7 @@ static inline int brcmf_sdioh_f0_write_byte(struct brcmf_sdio_dev *sdiodev,
 		sdio_writeb(sdfunc, *byte, regaddr, &err_ret);
 		kfree(sdfunc);
 	} else if (regaddr < 0xF0) {
-		brcmf_dbg(ERROR, "F0 Wr:0x%02x: write disallowed\n", regaddr);
+		brcmf_err("F0 Wr:0x%02x: write disallowed\n", regaddr);
 		err_ret = -EPERM;
 	} else {
 		sdio_f0_writeb(sdfunc, *byte, regaddr, &err_ret);
@@ -166,7 +164,7 @@ int brcmf_sdioh_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw, uint func,
 	}
 
 	if (err_ret)
-		brcmf_dbg(ERROR, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
+		brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
 			  rw ? "write" : "read", func, regaddr, *byte, err_ret);
 
 	return err_ret;
@@ -179,7 +177,7 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 	int err_ret = -EIO;
 
 	if (func == 0) {
-		brcmf_dbg(ERROR, "Only CMD52 allowed to F0\n");
+		brcmf_err("Only CMD52 allowed to F0\n");
 		return -EINVAL;
 	}
 
@@ -198,7 +196,7 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
 				    addr, &err_ret);
 		else
-			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
+			brcmf_err("Invalid nbytes: %d\n", nbytes);
 	} else {		/* CMD52 Read */
 		if (nbytes == 4)
 			*word = sdio_readl(sdiodev->func[func], addr, &err_ret);
@@ -206,11 +204,11 @@ int brcmf_sdioh_request_word(struct brcmf_sdio_dev *sdiodev,
 			*word = sdio_readw(sdiodev->func[func], addr,
 					   &err_ret) & 0xFFFF;
 		else
-			brcmf_dbg(ERROR, "Invalid nbytes: %d\n", nbytes);
+			brcmf_err("Invalid nbytes: %d\n", nbytes);
 	}
 
 	if (err_ret)
-		brcmf_dbg(ERROR, "Failed to %s word, Err: 0x%08x\n",
+		brcmf_err("Failed to %s word, Err: 0x%08x\n",
 			  rw ? "write" : "read", err_ret);
 
 	return err_ret;
@@ -270,7 +268,7 @@ brcmf_sdioh_request_chain(struct brcmf_sdio_dev *sdiodev, uint fix_inc,
 		err_ret = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
 						   addr, pkt, pkt_len);
 		if (err_ret) {
-			brcmf_dbg(ERROR, "%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+			brcmf_err("%s FAILED %p[%d], addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
 				  write ? "TX" : "RX", pkt, SGCount, addr,
 				  pkt_len, err_ret);
 		} else {
@@ -315,7 +313,7 @@ int brcmf_sdioh_request_buffer(struct brcmf_sdio_dev *sdiodev,
 	status = brcmf_sdioh_request_data(sdiodev, write, fifo, func,
 					   addr, pkt, pkt_len);
 	if (status) {
-		brcmf_dbg(ERROR, "%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
+		brcmf_err("%s FAILED %p, addr=0x%05x, pkt_len=%d, ERR=0x%08x\n",
 			  write ? "TX" : "RX", pkt, addr, pkt_len, status);
 	} else {
 		brcmf_dbg(TRACE, "%s xfr'd %p, addr=0x%05x, len=%d\n",
@@ -336,7 +334,7 @@ static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr)
 	for (i = 0; i < 3; i++) {
 		regdata = brcmf_sdio_regrl(sdiodev, regaddr, &ret);
 		if (ret != 0)
-			brcmf_dbg(ERROR, "Can't read!\n");
+			brcmf_err("Can't read!\n");
 
 		*ptr++ = (u8) regdata;
 		regaddr++;
@@ -374,7 +372,7 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 	/* Enable Function 1 */
 	err_ret = sdio_enable_func(sdiodev->func[1]);
 	if (err_ret)
-		brcmf_dbg(ERROR, "Failed to enable F1 Err: 0x%08x\n", err_ret);
+		brcmf_err("Failed to enable F1 Err: 0x%08x\n", err_ret);
 
 	return false;
 }
@@ -394,13 +392,13 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 
 	err_ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
 	if (err_ret) {
-		brcmf_dbg(ERROR, "Failed to set F1 blocksize\n");
+		brcmf_err("Failed to set F1 blocksize\n");
 		goto out;
 	}
 
 	err_ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
 	if (err_ret) {
-		brcmf_dbg(ERROR, "Failed to set F2 blocksize\n");
+		brcmf_err("Failed to set F2 blocksize\n");
 		goto out;
 	}
 
@@ -434,7 +432,7 @@ static int brcmf_sdio_getintrcfg(struct brcmf_sdio_dev *sdiodev)
 	struct brcmf_sdio_oobirq *oobirq_entry;
 
 	if (list_empty(&oobirq_lh)) {
-		brcmf_dbg(ERROR, "no valid oob irq resource\n");
+		brcmf_err("no valid oob irq resource\n");
 		return -ENXIO;
 	}
 
@@ -508,7 +506,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
 	err = brcmf_sdio_probe(sdiodev);
 	if (err) {
-		brcmf_dbg(ERROR, "F2 error, probe failed %d...\n", err);
+		brcmf_err("F2 error, probe failed %d...\n", err);
 		goto fail;
 	}
 	brcmf_dbg(TRACE, "F2 init completed...\n");
@@ -564,13 +562,13 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 	sdio_flags = sdio_get_host_pm_caps(sdiodev->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-		brcmf_dbg(ERROR, "Host can't keep power while suspended\n");
+		brcmf_err("Host can't keep power while suspended\n");
 		return -EINVAL;
 	}
 
 	ret = sdio_set_host_pm_flags(sdiodev->func[1], MMC_PM_KEEP_POWER);
 	if (ret) {
-		brcmf_dbg(ERROR, "Failed to set pm_flags\n");
+		brcmf_err("Failed to set pm_flags\n");
 		return ret;
 	}
 
@@ -635,7 +633,7 @@ static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 	ret = sdio_register_driver(&brcmf_sdmmc_driver);
 
 	if (ret)
-		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
+		brcmf_err("sdio_register_driver failed: %d\n", ret);
 
 	return ret;
 }
@@ -665,7 +663,7 @@ void brcmf_sdio_init(void)
 	ret = platform_driver_register(&brcmf_sdio_pd);
 
 	if (ret)
-		brcmf_dbg(ERROR, "platform_driver_register failed: %d\n", ret);
+		brcmf_err("platform_driver_register failed: %d\n", ret);
 }
 #else
 void brcmf_sdio_exit(void)
@@ -684,6 +682,6 @@ void brcmf_sdio_init(void)
 	ret = sdio_register_driver(&brcmf_sdmmc_driver);
 
 	if (ret)
-		brcmf_dbg(ERROR, "sdio_register_driver failed: %d\n", ret);
+		brcmf_err("sdio_register_driver failed: %d\n", ret);
 }
 #endif		/* CONFIG_BRCMFMAC_SDIO_OOB */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index b123d25..8392355 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -176,7 +176,7 @@ brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
-		brcmf_dbg(ERROR, "brcmf_proto_cdc_msg failed w/status %d\n",
+		brcmf_err("brcmf_proto_cdc_msg failed w/status %d\n",
 			  ret);
 		goto done;
 	}
@@ -193,7 +193,7 @@ retry:
 	if ((id < prot->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != prot->reqid) {
-		brcmf_dbg(ERROR, "%s: unexpected request id %d (expected %d)\n",
+		brcmf_err("%s: unexpected request id %d (expected %d)\n",
 			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
@@ -255,7 +255,7 @@ int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
 
 	if (id != prot->reqid) {
-		brcmf_dbg(ERROR, "%s: unexpected request id %d (expected %d)\n",
+		brcmf_err("%s: unexpected request id %d (expected %d)\n",
 			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
 		ret = -EINVAL;
 		goto done;
@@ -317,7 +317,7 @@ int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 	/* Pop BDC header used to convey priority for buses that don't */
 
 	if (pktbuf->len < BDC_HEADER_LEN) {
-		brcmf_dbg(ERROR, "rx data too short (%d < %d)\n",
+		brcmf_err("rx data too short (%d < %d)\n",
 			  pktbuf->len, BDC_HEADER_LEN);
 		return -EBADE;
 	}
@@ -326,13 +326,13 @@ int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 
 	*ifidx = BDC_GET_IF_IDX(h);
 	if (*ifidx >= BRCMF_MAX_IFS) {
-		brcmf_dbg(ERROR, "rx data ifnum out of range (%d)\n", *ifidx);
+		brcmf_err("rx data ifnum out of range (%d)\n", *ifidx);
 		return -EBADE;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
-		brcmf_dbg(ERROR, "%s: non-BDC packet received, flags 0x%x\n",
+		brcmf_err("%s: non-BDC packet received, flags 0x%x\n",
 			  brcmf_ifname(drvr, *ifidx), h->flags);
 		return -EBADE;
 	}
@@ -361,7 +361,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		brcmf_dbg(ERROR, "struct brcmf_proto is not correctly defined\n");
+		brcmf_err("struct brcmf_proto is not correctly defined\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index eee7175..f8b52e5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -80,7 +80,7 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
 			brcmu_pktq_pdeq_tail(q, eprec);
 		if (p == NULL)
-			brcmf_dbg(ERROR, "brcmu_pktq_penq() failed, oldest %d\n",
+			brcmf_err("brcmu_pktq_penq() failed, oldest %d\n",
 				  discard_oldest);
 
 		brcmu_pkt_buf_free_skb(p);
@@ -89,7 +89,7 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 	/* Enqueue */
 	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL)
-		brcmf_dbg(ERROR, "brcmu_pktq_penq() failed\n");
+		brcmf_err("brcmu_pktq_penq() failed\n");
 
 	return p != NULL;
 }
@@ -99,12 +99,12 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
 	int i;
 	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		brcmf_dbg(ERROR, "Mask invalid format. Needs to start with 0x\n");
+		brcmf_err("Mask invalid format. Needs to start with 0x\n");
 		return -EINVAL;
 	}
 	src = src + 2;		/* Skip past 0x */
 	if (strlen(src) % 2 != 0) {
-		brcmf_dbg(ERROR, "Mask invalid format. Length must be even.\n");
+		brcmf_err("Mask invalid format. Length must be even.\n");
 		return -EINVAL;
 	}
 	for (i = 0; *src != '\0'; i++) {
@@ -139,7 +139,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_if *ifp, char *arg, int enable,
 	argv = strsep(&arg_save, " ");
 
 	if (argv == NULL) {
-		brcmf_dbg(ERROR, "No args provided\n");
+		brcmf_err("No args provided\n");
 		goto fail;
 	}
 
@@ -154,12 +154,12 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_if *ifp, char *arg, int enable,
 	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_enable", &enable_parm,
 				       sizeof(enable_parm));
 	if (err)
-		brcmf_dbg(ERROR, "Set pkt_filter_enable error (%d)\n", err);
+		brcmf_err("Set pkt_filter_enable error (%d)\n", err);
 
 	/* Control the master mode */
 	err = brcmf_fil_iovar_int_set(ifp, "pkt_filter_mode", master_mode);
 	if (err)
-		brcmf_dbg(ERROR, "Set pkt_filter_mode error (%d)\n", err);
+		brcmf_err("Set pkt_filter_mode error (%d)\n", err);
 
 fail:
 	kfree(arg_org);
@@ -191,14 +191,14 @@ static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
 	while (argv[i]) {
 		i++;
 		if (i >= 8) {
-			brcmf_dbg(ERROR, "Too many parameters\n");
+			brcmf_err("Too many parameters\n");
 			goto fail;
 		}
 		argv[i] = strsep(&arg_save, " ");
 	}
 
 	if (i != 6) {
-		brcmf_dbg(ERROR, "Not enough args provided %d\n", i);
+		brcmf_err("Not enough args provided %d\n", i);
 		goto fail;
 	}
 
@@ -233,7 +233,7 @@ static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
 		(char *)&pkt_filter->u.pattern.mask_and_pattern[mask_size]);
 
 	if (mask_size != pattern_size) {
-		brcmf_dbg(ERROR, "Mask and pattern not the same size\n");
+		brcmf_err("Mask and pattern not the same size\n");
 		goto fail;
 	}
 
@@ -245,7 +245,7 @@ static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
 	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_add", pkt_filter,
 				       buf_len);
 	if (err)
-		brcmf_dbg(ERROR, "Set pkt_filter_add error (%d)\n", err);
+		brcmf_err("Set pkt_filter_add error (%d)\n", err);
 
 fail:
 	kfree(arg_org);
@@ -266,7 +266,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
-		brcmf_dbg(ERROR, "Retreiving cur_etheraddr failed, %d\n",
+		brcmf_err("Retreiving cur_etheraddr failed, %d\n",
 			  err);
 		goto done;
 	}
@@ -277,14 +277,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strcpy(buf, "ver");
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
-		brcmf_dbg(ERROR, "Retreiving version information failed, %d\n",
+		brcmf_err("Retreiving version information failed, %d\n",
 			  err);
 		goto done;
 	}
 	ptr = (char *)buf;
 	strsep(&ptr, "\n");
 	/* Print fw version info */
-	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
+	brcmf_err("Firmware version = %s\n", buf);
 
 	/*
 	 * Setup timeout if Beacons are lost and roam is off to report
@@ -293,7 +293,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout",
 				      BRCMF_DEFAULT_BCN_TIMEOUT);
 	if (err) {
-		brcmf_dbg(ERROR, "bcn_timeout error (%d)\n", err);
+		brcmf_err("bcn_timeout error (%d)\n", err);
 		goto done;
 	}
 
@@ -302,7 +302,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	 */
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
 	if (err) {
-		brcmf_dbg(ERROR, "roam_off error (%d)\n", err);
+		brcmf_err("roam_off error (%d)\n", err);
 		goto done;
 	}
 
@@ -310,14 +310,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_dbg(ERROR, "Get event_msgs error (%d)\n", err);
+		brcmf_err("Get event_msgs error (%d)\n", err);
 		goto done;
 	}
 	setbit(eventmask, BRCMF_E_IF);
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_dbg(ERROR, "Set event_msgs error (%d)\n", err);
+		brcmf_err("Set event_msgs error (%d)\n", err);
 		goto done;
 	}
 
@@ -325,7 +325,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_DEFAULT_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_dbg(ERROR, "BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+		brcmf_err("BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
@@ -334,7 +334,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_DEFAULT_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_dbg(ERROR, "BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+		brcmf_err("BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index a0e18a1..eb1d8d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -18,7 +18,6 @@
 #define _BRCMF_DBG_H_
 
 /* message levels */
-#define BRCMF_ERROR_VAL	0x0001
 #define BRCMF_TRACE_VAL	0x0002
 #define BRCMF_INFO_VAL	0x0004
 #define BRCMF_DATA_VAL	0x0008
@@ -33,22 +32,15 @@
 #define BRCMF_FIL_VAL	0x1000
 #define BRCMF_USB_VAL	0x2000
 
+/* error messages are always logged */
+#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
+
 #if defined(DEBUG)
 
-#define brcmf_dbg(level, fmt, ...)					\
-do {									\
-	if (BRCMF_ERROR_VAL == BRCMF_##level##_VAL) {			\
-		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
-			if (net_ratelimit())				\
-				pr_debug("%s: " fmt,			\
-					 __func__, ##__VA_ARGS__);	\
-		}							\
-	} else {							\
-		if (brcmf_msg_level & BRCMF_##level##_VAL) {		\
-			pr_debug("%s: " fmt,				\
-				 __func__, ##__VA_ARGS__);		\
-		}							\
-	}								\
+#define brcmf_dbg(level, fmt, ...)				\
+do {								\
+	if (brcmf_msg_level & BRCMF_##level##_VAL)		\
+		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
 } while (0)
 
 #define BRCMF_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 421b49c..74a616b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -39,19 +39,19 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
 
 /* Error bits */
-int brcmf_msg_level = BRCMF_ERROR_VAL;
+int brcmf_msg_level;
 module_param(brcmf_msg_level, int, 0);
 
 
 char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		brcmf_dbg(ERROR, "ifidx %d out of range\n", ifidx);
+		brcmf_err("ifidx %d out of range\n", ifidx);
 		return "<if_bad>";
 	}
 
 	if (drvr->iflist[ifidx] == NULL) {
-		brcmf_dbg(ERROR, "null i/f %d\n", ifidx);
+		brcmf_err("null i/f %d\n", ifidx);
 		return "<if_null>";
 	}
 
@@ -102,7 +102,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	err = brcmf_fil_iovar_data_set(ifp, "mcast_list", buf, buflen);
 	if (err < 0) {
-		brcmf_dbg(ERROR, "Setting mcast_list failed, %d\n", err);
+		brcmf_err("Setting mcast_list failed, %d\n", err);
 		cmd_value = cnt ? true : cmd_value;
 	}
 
@@ -115,13 +115,13 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	 */
 	err = brcmf_fil_iovar_int_set(ifp, "allmulti", cmd_value);
 	if (err < 0)
-		brcmf_dbg(ERROR, "Setting allmulti failed, %d\n", err);
+		brcmf_err("Setting allmulti failed, %d\n", err);
 
 	/*Finally, pick up the PROMISC flag */
 	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
 	if (err < 0)
-		brcmf_dbg(ERROR, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
+		brcmf_err("Setting BRCMF_C_SET_PROMISC failed, %d\n",
 			  err);
 }
 
@@ -137,7 +137,7 @@ _brcmf_set_mac_address(struct work_struct *work)
 	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ifp->mac_addr,
 				       ETH_ALEN);
 	if (err < 0) {
-		brcmf_dbg(ERROR, "Setting cur_etheraddr failed, %d\n", err);
+		brcmf_err("Setting cur_etheraddr failed, %d\n", err);
 	} else {
 		brcmf_dbg(TRACE, "MAC address updated to %pM\n",
 			  ifp->mac_addr);
@@ -173,7 +173,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Reject if down */
 	if (!drvr->bus_if->drvr_up ||
 	    (drvr->bus_if->state != BRCMF_BUS_DATA)) {
-		brcmf_dbg(ERROR, "xmit rejected drvup=%d state=%d\n",
+		brcmf_err("xmit rejected drvup=%d state=%d\n",
 			  drvr->bus_if->drvr_up,
 			  drvr->bus_if->state);
 		netif_stop_queue(ndev);
@@ -181,7 +181,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	if (!drvr->iflist[ifp->idx]) {
-		brcmf_dbg(ERROR, "bad ifidx %d\n", ifp->idx);
+		brcmf_err("bad ifidx %d\n", ifp->idx);
 		netif_stop_queue(ndev);
 		return -ENODEV;
 	}
@@ -197,7 +197,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			brcmf_dbg(ERROR, "%s: skb_realloc_headroom failed\n",
+			brcmf_err("%s: skb_realloc_headroom failed\n",
 				  brcmf_ifname(drvr, ifp->idx));
 			ret = -ENOMEM;
 			goto done;
@@ -377,13 +377,13 @@ static int brcmf_toe_set(struct brcmf_if *ifp, u32 toe_ol)
 
 	err = brcmf_fil_iovar_int_set(ifp, "toe_ol", toe_ol);
 	if (err < 0) {
-		brcmf_dbg(ERROR, "Setting toe_ol failed, %d\n", err);
+		brcmf_err("Setting toe_ol failed, %d\n", err);
 		return err;
 	}
 
 	err = brcmf_fil_iovar_int_set(ifp, "toe", (toe_ol != 0));
 	if (err < 0)
-		brcmf_dbg(ERROR, "Setting toe failed, %d\n", err);
+		brcmf_err("Setting toe failed, %d\n", err);
 
 	return err;
 
@@ -440,7 +440,7 @@ static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 
 		/* otherwise, require dongle to be up */
 		else if (!drvr->bus_if->drvr_up) {
-			brcmf_dbg(ERROR, "dongle is not up\n");
+			brcmf_err("dongle is not up\n");
 			return -ENODEV;
 		}
 		/* finally, report dongle driver type */
@@ -559,7 +559,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_DATA) {
-		brcmf_dbg(ERROR, "failed bus is not ready\n");
+		brcmf_err("failed bus is not ready\n");
 		return -EAGAIN;
 	}
 
@@ -583,7 +583,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	netif_start_queue(ndev);
 	drvr->bus_if->drvr_up = true;
 	if (brcmf_cfg80211_up(ndev)) {
-		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
+		brcmf_err("failed to bring up cfg80211\n");
 		return -1;
 	}
 
@@ -634,7 +634,7 @@ int brcmf_net_attach(struct brcmf_if *ifp)
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
 	if (register_netdev(ndev) != 0) {
-		brcmf_dbg(ERROR, "couldn't register the net device\n");
+		brcmf_err("couldn't register the net device\n");
 		goto fail;
 	}
 
@@ -662,7 +662,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	 * in case we missed the BRCMF_E_IF_DEL event.
 	 */
 	if (ifp) {
-		brcmf_dbg(ERROR, "ERROR: netdev:%s already exists\n",
+		brcmf_err("ERROR: netdev:%s already exists\n",
 			  ifp->ndev->name);
 		if (ifidx) {
 			netif_stop_queue(ifp->ndev);
@@ -670,7 +670,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 			free_netdev(ifp->ndev);
 			drvr->iflist[ifidx] = NULL;
 		} else {
-			brcmf_dbg(ERROR, "ignore IF event\n");
+			brcmf_err("ignore IF event\n");
 			return ERR_PTR(-EINVAL);
 		}
 	}
@@ -678,7 +678,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx, s32 bssidx,
 	/* Allocate netdev, including space for private structure */
 	ndev = alloc_netdev(sizeof(struct brcmf_if), name, ether_setup);
 	if (!ndev) {
-		brcmf_dbg(ERROR, "OOM - alloc_netdev\n");
+		brcmf_err("OOM - alloc_netdev\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -710,7 +710,7 @@ void brcmf_del_if(struct brcmf_pub *drvr, int ifidx)
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp) {
-		brcmf_dbg(ERROR, "Null interface\n");
+		brcmf_err("Null interface\n");
 		return;
 	}
 	if (ifp->ndev) {
@@ -760,7 +760,7 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
-		brcmf_dbg(ERROR, "brcmf_prot_attach failed\n");
+		brcmf_err("brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
@@ -791,7 +791,7 @@ int brcmf_bus_start(struct device *dev)
 	/* Bring up the bus */
 	ret = brcmf_bus_init(bus_if);
 	if (ret != 0) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
+		brcmf_err("brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
 	}
 
@@ -821,7 +821,7 @@ int brcmf_bus_start(struct device *dev)
 	ret = brcmf_net_attach(ifp);
 fail:
 	if (ret < 0) {
-		brcmf_dbg(ERROR, "failed: %d\n", ret);
+		brcmf_err("failed: %d\n", ret);
 		if (drvr->config)
 			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(drvr->iflist[0]->ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f2293bb..cf857f1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -689,7 +689,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		brcmf_sdio_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				 clkreq, &err);
 		if (err) {
-			brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
+			brcmf_err("HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -697,7 +697,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkctl = brcmf_sdio_regrb(bus->sdiodev,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			brcmf_dbg(ERROR, "HT Avail read error: %d\n", err);
+			brcmf_err("HT Avail read error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -707,7 +707,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			devctl = brcmf_sdio_regrb(bus->sdiodev,
 						  SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				brcmf_dbg(ERROR, "Devctl error setting CA: %d\n",
+				brcmf_err("Devctl error setting CA: %d\n",
 					  err);
 				return -EBADE;
 			}
@@ -741,11 +741,11 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 				usleep_range(5000, 10000);
 		}
 		if (err) {
-			brcmf_dbg(ERROR, "HT Avail request error: %d\n", err);
+			brcmf_err("HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			brcmf_dbg(ERROR, "HT Avail timeout (%d): clkctl 0x%02x\n",
+			brcmf_err("HT Avail timeout (%d): clkctl 0x%02x\n",
 				  PMU_MAX_TRANSITION_DLY, clkctl);
 			return -EBADE;
 		}
@@ -757,7 +757,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 #if defined(DEBUG)
 		if (!bus->alp_only) {
 			if (SBSDIO_ALPONLY(clkctl))
-				brcmf_dbg(ERROR, "HT Clock should be on\n");
+				brcmf_err("HT Clock should be on\n");
 		}
 #endif				/* defined (DEBUG) */
 
@@ -779,7 +779,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 				 clkreq, &err);
 		brcmf_dbg(INFO, "CLKCTL: turned OFF\n");
 		if (err) {
-			brcmf_dbg(ERROR, "Failed access turning clock off: %d\n",
+			brcmf_err("Failed access turning clock off: %d\n",
 				  err);
 			return -EBADE;
 		}
@@ -836,7 +836,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 		else if (bus->clkstate == CLK_AVAIL)
 			brcmf_sdbrcm_htclk(bus, false, false);
 		else
-			brcmf_dbg(ERROR, "request for %d -> %d\n",
+			brcmf_err("request for %d -> %d\n",
 				  bus->clkstate, target);
 		brcmf_sdbrcm_wd_timer(bus, BRCMF_WD_POLL_MS);
 		break;
@@ -880,7 +880,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 		brcmf_dbg(INFO, "Dongle reports NAK handled, expect rtx of %d\n",
 			  bus->rx_seq);
 		if (!bus->rxskip)
-			brcmf_dbg(ERROR, "unexpected NAKHANDLED!\n");
+			brcmf_err("unexpected NAKHANDLED!\n");
 
 		bus->rxskip = false;
 		intstatus |= I_HMB_FRAME_IND;
@@ -894,7 +894,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 		    (hmb_data & HMB_DATA_VERSION_MASK) >>
 		    HMB_DATA_VERSION_SHIFT;
 		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			brcmf_dbg(ERROR, "Version mismatch, dongle reports %d, "
+			brcmf_err("Version mismatch, dongle reports %d, "
 				  "expecting %d\n",
 				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
 		else
@@ -927,7 +927,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
-		brcmf_dbg(ERROR, "Unknown mailbox data content: 0x%02x\n",
+		brcmf_err("Unknown mailbox data content: 0x%02x\n",
 			  hmb_data);
 
 	return intstatus;
@@ -940,7 +940,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	u8 hi, lo;
 	int err;
 
-	brcmf_dbg(ERROR, "%sterminate frame%s\n",
+	brcmf_err("%sterminate frame%s\n",
 		  abort ? "abort command, " : "",
 		  rtx ? ", send NAK" : "");
 
@@ -963,14 +963,14 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			brcmf_dbg(ERROR, "count growing: last 0x%04x now 0x%04x\n",
+			brcmf_err("count growing: last 0x%04x now 0x%04x\n",
 				  lastrbc, (hi << 8) + lo);
 		}
 		lastrbc = (hi << 8) + lo;
 	}
 
 	if (!retries)
-		brcmf_dbg(ERROR, "count never zeroed: last 0x%04x\n", lastrbc);
+		brcmf_err("count never zeroed: last 0x%04x\n", lastrbc);
 	else
 		brcmf_dbg(INFO, "flush took %d iterations\n", 0xffff - retries);
 
@@ -1057,22 +1057,22 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		return -ENODATA;
 	}
 	if ((u16)(~(len ^ checksum))) {
-		brcmf_dbg(ERROR, "HW header checksum error\n");
+		brcmf_err("HW header checksum error\n");
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		return -EIO;
 	}
 	if (len < SDPCM_HDRLEN) {
-		brcmf_dbg(ERROR, "HW header length error\n");
+		brcmf_err("HW header length error\n");
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER &&
 	    (roundup(len, bus->blocksize) != rd->len)) {
-		brcmf_dbg(ERROR, "HW superframe header length error\n");
+		brcmf_err("HW superframe header length error\n");
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && len > rd->len) {
-		brcmf_dbg(ERROR, "HW subframe header length error\n");
+		brcmf_err("HW subframe header length error\n");
 		return -EPROTO;
 	}
 	rd->len = len;
@@ -1089,7 +1089,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	 */
 	if (type == BRCMF_SDIO_FT_SUPER &&
 	    SDPCM_GLOMDESC(&header[SDPCM_FRAMETAG_LEN])) {
-		brcmf_dbg(ERROR, "Glom descriptor found in superframe head\n");
+		brcmf_err("Glom descriptor found in superframe head\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
@@ -1097,7 +1097,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	rd->channel = SDPCM_PACKET_CHANNEL(&header[SDPCM_FRAMETAG_LEN]);
 	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL &&
 	    type != BRCMF_SDIO_FT_SUPER) {
-		brcmf_dbg(ERROR, "HW header length too long\n");
+		brcmf_err("HW header length too long\n");
 		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
@@ -1105,26 +1105,26 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER && rd->channel != SDPCM_GLOM_CHANNEL) {
-		brcmf_dbg(ERROR, "Wrong channel for superframe\n");
+		brcmf_err("Wrong channel for superframe\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && rd->channel != SDPCM_DATA_CHANNEL &&
 	    rd->channel != SDPCM_EVENT_CHANNEL) {
-		brcmf_dbg(ERROR, "Wrong channel for subframe\n");
+		brcmf_err("Wrong channel for subframe\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
 	rd->dat_offset = SDPCM_DOFFSET_VALUE(&header[SDPCM_FRAMETAG_LEN]);
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
-		brcmf_dbg(ERROR, "seq %d: bad data offset\n", rx_seq);
+		brcmf_err("seq %d: bad data offset\n", rx_seq);
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
 		rd->len = 0;
 		return -ENXIO;
 	}
 	if (rd->seq_num != rx_seq) {
-		brcmf_dbg(ERROR, "seq %d: sequence number error, expect %d\n",
+		brcmf_err("seq %d: sequence number error, expect %d\n",
 			  rx_seq, rd->seq_num);
 		bus->sdcnt.rx_badseq++;
 		rd->seq_num = rx_seq;
@@ -1136,7 +1136,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
 		/* only warm for NON glom packet */
 		if (rd->channel != SDPCM_GLOM_CHANNEL)
-			brcmf_dbg(ERROR, "seq %d: next length error\n", rx_seq);
+			brcmf_err("seq %d: next length error\n", rx_seq);
 		rd->len_nxtfrm = 0;
 	}
 	fc = SDPCM_FCMASK_VALUE(&header[SDPCM_FRAMETAG_LEN]);
@@ -1150,7 +1150,7 @@ static int brcmf_sdio_hdparser(struct brcmf_sdio *bus, u8 *header,
 	}
 	tx_seq_max = SDPCM_WINDOW_VALUE(&header[SDPCM_FRAMETAG_LEN]);
 	if ((u8)(tx_seq_max - bus->tx_seq) > 0x40) {
-		brcmf_dbg(ERROR, "seq %d: max tx seq number error\n", rx_seq);
+		brcmf_err("seq %d: max tx seq number error\n", rx_seq);
 		tx_seq_max = bus->tx_seq + 2;
 	}
 	bus->tx_max = tx_seq_max;
@@ -1186,7 +1186,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			brcmf_dbg(ERROR, "bad glomd len(%d), ignore descriptor\n",
+			brcmf_err("bad glomd len(%d), ignore descriptor\n",
 				  dlen);
 			dlen = 0;
 		}
@@ -1198,13 +1198,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			dptr += sizeof(u16);
 			if ((sublen < SDPCM_HDRLEN) ||
 			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				brcmf_dbg(ERROR, "descriptor len %d bad: %d\n",
+				brcmf_err("descriptor len %d bad: %d\n",
 					  num, sublen);
 				pnext = NULL;
 				break;
 			}
 			if (sublen % BRCMF_SDALIGN) {
-				brcmf_dbg(ERROR, "sublen %d not multiple of %d\n",
+				brcmf_err("sublen %d not multiple of %d\n",
 					  sublen, BRCMF_SDALIGN);
 				usechain = false;
 			}
@@ -1221,7 +1221,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
 			if (pnext == NULL) {
-				brcmf_dbg(ERROR, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
+				brcmf_err("bcm_pkt_buf_get_skb failed, num %d len %d\n",
 					  num, sublen);
 				break;
 			}
@@ -1284,13 +1284,13 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					bus->dataptr, dlen);
 			sublen = (u16) brcmf_sdbrcm_glom_from_buf(bus, dlen);
 			if (sublen != dlen) {
-				brcmf_dbg(ERROR, "FAILED TO COPY, dlen %d sublen %d\n",
+				brcmf_err("FAILED TO COPY, dlen %d sublen %d\n",
 					  dlen, sublen);
 				errcode = -1;
 			}
 			pnext = NULL;
 		} else {
-			brcmf_dbg(ERROR, "COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
+			brcmf_err("COULDN'T ALLOC %d-BYTE GLOM, FORCE FAILURE\n",
 				  dlen);
 			errcode = -1;
 		}
@@ -1299,7 +1299,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
-			brcmf_dbg(ERROR, "glom read of %d bytes failed: %d\n",
+			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
 
@@ -1390,7 +1390,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				continue;
 			} else if (brcmf_proto_hdrpull(bus->sdiodev->dev,
 						       &ifidx, pfirst) != 0) {
-				brcmf_dbg(ERROR, "rx protocol error\n");
+				brcmf_err("rx protocol error\n");
 				bus->sdiodev->bus_if->dstats.rx_errors++;
 				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
@@ -1456,7 +1456,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if (bus->rxblen)
 		buf = vzalloc(bus->rxblen);
 	if (!buf) {
-		brcmf_dbg(ERROR, "no memory for control frame\n");
+		brcmf_err("no memory for control frame\n");
 		goto done;
 	}
 	rbuf = bus->rxbuf;
@@ -1486,7 +1486,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte control read exceeds %d-byte buffer\n",
+		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
 		bus->sdiodev->bus_if->dstats.rx_errors++;
 		brcmf_sdbrcm_rxfail(bus, false, false);
@@ -1494,7 +1494,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	}
 
 	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
-		brcmf_dbg(ERROR, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+		brcmf_err("%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->sdiodev->bus_if->dstats.rx_errors++;
 		bus->sdcnt.rx_toolong++;
@@ -1511,7 +1511,7 @@ brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
-		brcmf_dbg(ERROR, "read %d control bytes failed: %d\n",
+		brcmf_err("read %d control bytes failed: %d\n",
 			  rdlen, sdret);
 		bus->sdcnt.rxc_errors++;
 		brcmf_sdbrcm_rxfail(bus, true, true);
@@ -1527,7 +1527,7 @@ gotpkt:
 	/* Point to valid data and indicate its length */
 	spin_lock_bh(&bus->rxctl_lock);
 	if (bus->rxctl) {
-		brcmf_dbg(ERROR, "last control frame is being processed.\n");
+		brcmf_err("last control frame is being processed.\n");
 		spin_unlock_bh(&bus->rxctl_lock);
 		vfree(buf);
 		goto done;
@@ -1599,7 +1599,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 						      BRCMF_FIRSTREAD);
 			bus->sdcnt.f2rxhdrs++;
 			if (sdret < 0) {
-				brcmf_dbg(ERROR, "RXHEADER FAILED: %d\n",
+				brcmf_err("RXHEADER FAILED: %d\n",
 					  sdret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdbrcm_rxfail(bus, true, true);
@@ -1643,7 +1643,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					    BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			brcmf_dbg(ERROR, "brcmu_pkt_buf_get_skb failed\n");
+			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
 			bus->sdiodev->bus_if->dstats.rx_dropped++;
 			brcmf_sdbrcm_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
@@ -1659,7 +1659,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		sdio_release_host(bus->sdiodev->func[1]);
 
 		if (sdret < 0) {
-			brcmf_dbg(ERROR, "read %d bytes from channel %d failed: %d\n",
+			brcmf_err("read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, sdret);
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
@@ -1685,7 +1685,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			}
 			bus->sdcnt.rx_readahead_cnt++;
 			if (rd->len != roundup(rd_new.len, 16)) {
-				brcmf_dbg(ERROR, "frame length mismatch:read %d, should be %d\n",
+				brcmf_err("frame length mismatch:read %d, should be %d\n",
 					  rd->len,
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
@@ -1706,7 +1706,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					   "RxHdr:\n");
 
 			if (rd_new.channel == SDPCM_CONTROL_CHANNEL) {
-				brcmf_dbg(ERROR, "readahead on control packet %d?\n",
+				brcmf_err("readahead on control packet %d?\n",
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
@@ -1733,7 +1733,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
-				brcmf_dbg(ERROR, "%s: glom superframe w/o "
+				brcmf_err("%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
 				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdbrcm_rxfail(bus, false, false);
@@ -1762,7 +1762,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			continue;
 		} else if (brcmf_proto_hdrpull(bus->sdiodev->dev, &ifidx,
 			   pkt) != 0) {
-			brcmf_dbg(ERROR, "rx protocol error\n");
+			brcmf_err("rx protocol error\n");
 			brcmu_pkt_buf_free_skb(pkt);
 			bus->sdiodev->bus_if->dstats.rx_errors++;
 			continue;
@@ -1818,7 +1818,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 			bus->sdiodev->bus_if->tx_realloc++;
 			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
-				brcmf_dbg(ERROR, "couldn't allocate new %d-byte packet\n",
+				brcmf_err("couldn't allocate new %d-byte packet\n",
 					  pkt->len + BRCMF_SDALIGN);
 				ret = -ENOMEM;
 				goto done;
@@ -2024,7 +2024,7 @@ static void brcmf_sdbrcm_bus_stop(struct device *dev)
 				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err)
-		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+		brcmf_err("Failed to force clock for F2: err %d\n", err);
 
 	/* Turn off the bus (F2), free any pending packets */
 	brcmf_dbg(INTR, "disable SDIO interrupts\n");
@@ -2150,7 +2150,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		devctl = brcmf_sdio_regrb(bus->sdiodev,
 					  SBSDIO_DEVICE_CTL, &err);
 		if (err) {
-			brcmf_dbg(ERROR, "error reading DEVCTL: %d\n", err);
+			brcmf_err("error reading DEVCTL: %d\n", err);
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 #endif				/* DEBUG */
@@ -2159,7 +2159,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 		clkctl = brcmf_sdio_regrb(bus->sdiodev,
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			brcmf_dbg(ERROR, "error reading CSR: %d\n",
+			brcmf_err("error reading CSR: %d\n",
 				  err);
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
@@ -2171,7 +2171,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			devctl = brcmf_sdio_regrb(bus->sdiodev,
 						  SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				brcmf_dbg(ERROR, "error reading DEVCTL: %d\n",
+				brcmf_err("error reading DEVCTL: %d\n",
 					  err);
 				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
@@ -2179,7 +2179,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 			brcmf_sdio_regwb(bus->sdiodev, SBSDIO_DEVICE_CTL,
 					 devctl, &err);
 			if (err) {
-				brcmf_dbg(ERROR, "error writing DEVCTL: %d\n",
+				brcmf_err("error writing DEVCTL: %d\n",
 					  err);
 				bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 			}
@@ -2226,17 +2226,17 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
-		brcmf_dbg(ERROR, "Dongle reports WR_OOSYNC\n");
+		brcmf_err("Dongle reports WR_OOSYNC\n");
 		intstatus &= ~I_WR_OOSYNC;
 	}
 
 	if (intstatus & I_RD_OOSYNC) {
-		brcmf_dbg(ERROR, "Dongle reports RD_OOSYNC\n");
+		brcmf_err("Dongle reports RD_OOSYNC\n");
 		intstatus &= ~I_RD_OOSYNC;
 	}
 
 	if (intstatus & I_SBINT) {
-		brcmf_dbg(ERROR, "Dongle reports SBINT\n");
+		brcmf_err("Dongle reports SBINT\n");
 		intstatus &= ~I_SBINT;
 	}
 
@@ -2319,7 +2319,7 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	}
 
 	if ((bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) || (err != 0)) {
-		brcmf_dbg(ERROR, "failed backplane access over SDIO, halting operation\n");
+		brcmf_err("failed backplane access over SDIO, halting operation\n");
 		bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		atomic_set(&bus->intstatus, 0);
 	} else if (atomic_read(&bus->intstatus) ||
@@ -2370,7 +2370,7 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 		skb_pull(pkt, SDPCM_HDRLEN);
 		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
 		brcmu_pkt_buf_free_skb(pkt);
-		brcmf_dbg(ERROR, "out of bus->txq !!!\n");
+		brcmf_err("out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
 		ret = 0;
@@ -2420,7 +2420,7 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 	/* Set the backplane window to include the start address */
 	bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev, address);
 	if (bcmerror) {
-		brcmf_dbg(ERROR, "window change failed\n");
+		brcmf_err("window change failed\n");
 		goto xfer_done;
 	}
 
@@ -2432,7 +2432,7 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 		bcmerror = brcmf_sdcard_rwdata(bus->sdiodev, write,
 					       sdaddr, data, dsize);
 		if (bcmerror) {
-			brcmf_dbg(ERROR, "membytes transfer failed\n");
+			brcmf_err("membytes transfer failed\n");
 			break;
 		}
 
@@ -2444,7 +2444,7 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 			bcmerror = brcmf_sdcard_set_sbaddr_window(bus->sdiodev,
 								  address);
 			if (bcmerror) {
-				brcmf_dbg(ERROR, "window change failed\n");
+				brcmf_err("window change failed\n");
 				break;
 			}
 			sdaddr = 0;
@@ -2455,7 +2455,7 @@ brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdcard_set_sbaddr_window(bus->sdiodev, bus->sdiodev->sbwad))
-		brcmf_dbg(ERROR, "FAILED to set window back to 0x%x\n",
+		brcmf_err("FAILED to set window back to 0x%x\n",
 			  bus->sdiodev->sbwad);
 
 	sdio_release_host(bus->sdiodev->func[1]);
@@ -2739,7 +2739,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 * NVRAM length at the end of memory should have been overwritten.
 	 */
 	if (!brcmf_sdio_valid_shared_address(addr)) {
-			brcmf_dbg(ERROR, "invalid sdpcm_shared address 0x%08X\n",
+			brcmf_err("invalid sdpcm_shared address 0x%08X\n",
 				  addr);
 			return -EINVAL;
 	}
@@ -2762,8 +2762,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) != SDPCM_SHARED_VERSION) {
-		brcmf_dbg(ERROR,
-			  "sdpcm_shared version mismatch: dhd %d dongle %d\n",
+		brcmf_err("sdpcm_shared version mismatch: dhd %d dongle %d\n",
 			  SDPCM_SHARED_VERSION,
 			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EPROTO;
@@ -2938,10 +2937,10 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_sdio *bus)
 	if ((sh.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
 		brcmf_dbg(INFO, "firmware not built with -assert\n");
 	else if (sh.flags & SDPCM_SHARED_ASSERT)
-		brcmf_dbg(ERROR, "assertion in dongle\n");
+		brcmf_err("assertion in dongle\n");
 
 	if (sh.flags & SDPCM_SHARED_TRAP)
-		brcmf_dbg(ERROR, "firmware trap in dongle\n");
+		brcmf_err("firmware trap in dongle\n");
 
 	return 0;
 }
@@ -3047,7 +3046,7 @@ brcmf_sdbrcm_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
 			  rxlen, msglen);
 	} else if (timeleft == 0) {
-		brcmf_dbg(ERROR, "resumed on timeout\n");
+		brcmf_err("resumed on timeout\n");
 		brcmf_sdbrcm_checkdied(bus);
 	} else if (pending) {
 		brcmf_dbg(CTL, "cancelled\n");
@@ -3098,14 +3097,14 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 		bcmerror = brcmf_sdbrcm_membytes(bus, false, varaddr,
 						 nvram_ularray, bus->varsz);
 		if (bcmerror) {
-			brcmf_dbg(ERROR, "error %d on reading %d nvram bytes at 0x%08x\n",
+			brcmf_err("error %d on reading %d nvram bytes at 0x%08x\n",
 				  bcmerror, bus->varsz, varaddr);
 		}
 		/* Compare the org NVRAM with the one read from RAM */
 		if (memcmp(bus->vars, nvram_ularray, bus->varsz))
-			brcmf_dbg(ERROR, "Downloaded NVRAM image is corrupted\n");
+			brcmf_err("Downloaded NVRAM image is corrupted\n");
 		else
-			brcmf_dbg(ERROR, "Download/Upload/Compare of NVRAM ok\n");
+			brcmf_err("Download/Upload/Compare of NVRAM ok\n");
 
 		kfree(nvram_ularray);
 #endif				/* DEBUG */
@@ -3163,14 +3162,14 @@ static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 		}
 	} else {
 		if (!ci->iscoreup(bus->sdiodev, ci, BCMA_CORE_INTERNAL_MEM)) {
-			brcmf_dbg(ERROR, "SOCRAM core is down after reset?\n");
+			brcmf_err("SOCRAM core is down after reset?\n");
 			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		bcmerror = brcmf_sdbrcm_write_vars(bus);
 		if (bcmerror) {
-			brcmf_dbg(ERROR, "no vars written to RAM\n");
+			brcmf_err("no vars written to RAM\n");
 			bcmerror = 0;
 		}
 
@@ -3210,7 +3209,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 	ret = request_firmware(&bus->firmware, BRCMF_SDIO_FW_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
-		brcmf_dbg(ERROR, "Fail to request firmware %d\n", ret);
+		brcmf_err("Fail to request firmware %d\n", ret);
 		return ret;
 	}
 	bus->fw_ptr = 0;
@@ -3229,7 +3228,7 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
 		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
 		if (ret) {
-			brcmf_dbg(ERROR, "error %d on writing %d membytes at 0x%08x\n",
+			brcmf_err("error %d on writing %d membytes at 0x%08x\n",
 				  ret, MEMBLOCK, offset);
 			goto err;
 		}
@@ -3329,7 +3328,7 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 	ret = request_firmware(&bus->firmware, BRCMF_SDIO_NV_NAME,
 			       &bus->sdiodev->func[2]->dev);
 	if (ret) {
-		brcmf_dbg(ERROR, "Fail to request nvram %d\n", ret);
+		brcmf_err("Fail to request nvram %d\n", ret);
 		return ret;
 	}
 
@@ -3346,23 +3345,23 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 
 	/* Keep arm in reset */
 	if (brcmf_sdbrcm_download_state(bus, true)) {
-		brcmf_dbg(ERROR, "error placing ARM core in reset\n");
+		brcmf_err("error placing ARM core in reset\n");
 		goto err;
 	}
 
 	/* External image takes precedence if specified */
 	if (brcmf_sdbrcm_download_code_file(bus)) {
-		brcmf_dbg(ERROR, "dongle image file download failed\n");
+		brcmf_err("dongle image file download failed\n");
 		goto err;
 	}
 
 	/* External nvram takes precedence if specified */
 	if (brcmf_sdbrcm_download_nvram(bus))
-		brcmf_dbg(ERROR, "dongle nvram file download failed\n");
+		brcmf_err("dongle nvram file download failed\n");
 
 	/* Take arm out of reset */
 	if (brcmf_sdbrcm_download_state(bus, false)) {
-		brcmf_dbg(ERROR, "error getting out of ARM core reset\n");
+		brcmf_err("error getting out of ARM core reset\n");
 		goto err;
 	}
 
@@ -3430,7 +3429,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 				 (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		brcmf_dbg(ERROR, "Failed to force clock for F2: err %d\n", err);
+		brcmf_err("Failed to force clock for F2: err %d\n", err);
 		goto exit;
 	}
 
@@ -3476,7 +3475,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 	if (ret == 0) {
 		ret = brcmf_sdio_intr_register(bus->sdiodev);
 		if (ret != 0)
-			brcmf_dbg(ERROR, "intr register failed:%d\n", ret);
+			brcmf_err("intr register failed:%d\n", ret);
 	}
 
 	/* If we didn't come up, turn off backplane clock */
@@ -3496,12 +3495,12 @@ void brcmf_sdbrcm_isr(void *arg)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!bus) {
-		brcmf_dbg(ERROR, "bus is null pointer, exiting\n");
+		brcmf_err("bus is null pointer, exiting\n");
 		return;
 	}
 
 	if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN) {
-		brcmf_dbg(ERROR, "bus is down. we have nothing to do\n");
+		brcmf_err("bus is down. we have nothing to do\n");
 		return;
 	}
 	/* Count the interrupt call */
@@ -3510,13 +3509,13 @@ void brcmf_sdbrcm_isr(void *arg)
 		atomic_set(&bus->ipend, 1);
 	else
 		if (brcmf_sdio_intr_rstatus(bus)) {
-			brcmf_dbg(ERROR, "failed backplane access\n");
+			brcmf_err("failed backplane access\n");
 			bus->sdiodev->bus_if->state = BRCMF_BUS_DOWN;
 		}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
-		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
+		brcmf_err("isr w/o interrupt configured!\n");
 
 	brcmf_sdbrcm_adddpctsk(bus);
 	queue_work(bus->brcmf_wq, &bus->datawork);
@@ -3718,18 +3717,18 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 					  SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		brcmf_dbg(ERROR, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
+		brcmf_err("ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
 			  err, BRCMF_INIT_CLKCTL1, clkctl);
 		goto fail;
 	}
 
 	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci, regsva)) {
-		brcmf_dbg(ERROR, "brcmf_sdio_chip_attach failed!\n");
+		brcmf_err("brcmf_sdio_chip_attach failed!\n");
 		goto fail;
 	}
 
 	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
-		brcmf_dbg(ERROR, "unsupported chip: 0x%04x\n", bus->ci->chip);
+		brcmf_err("unsupported chip: 0x%04x\n", bus->ci->chip);
 		goto fail;
 	}
 
@@ -3739,7 +3738,7 @@ brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 	/* Get info on the SOCRAM cores... */
 	bus->ramsize = bus->ci->ramsize;
 	if (!(bus->ramsize)) {
-		brcmf_dbg(ERROR, "failed to find SOCRAM memory!\n");
+		brcmf_err("failed to find SOCRAM memory!\n");
 		goto fail;
 	}
 
@@ -3921,13 +3920,13 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	INIT_WORK(&bus->datawork, brcmf_sdio_dataworker);
 	bus->brcmf_wq = create_singlethread_workqueue("brcmf_wq");
 	if (bus->brcmf_wq == NULL) {
-		brcmf_dbg(ERROR, "insufficient memory to create txworkqueue\n");
+		brcmf_err("insufficient memory to create txworkqueue\n");
 		goto fail;
 	}
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdbrcm_probe_attach(bus, regsva))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_attach failed\n");
+		brcmf_err("brcmf_sdbrcm_probe_attach failed\n");
 		goto fail;
 	}
 
@@ -3960,18 +3959,18 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
-		brcmf_dbg(ERROR, "brcmf_attach failed\n");
+		brcmf_err("brcmf_attach failed\n");
 		goto fail;
 	}
 
 	/* Allocate buffers */
 	if (!(brcmf_sdbrcm_probe_malloc(bus))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_malloc failed\n");
+		brcmf_err("brcmf_sdbrcm_probe_malloc failed\n");
 		goto fail;
 	}
 
 	if (!(brcmf_sdbrcm_probe_init(bus))) {
-		brcmf_dbg(ERROR, "brcmf_sdbrcm_probe_init failed\n");
+		brcmf_err("brcmf_sdbrcm_probe_init failed\n");
 		goto fail;
 	}
 
@@ -4001,7 +4000,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	/* if firmware path present try to download and bring up bus */
 	ret = brcmf_bus_start(bus->sdiodev->dev);
 	if (ret != 0) {
-		brcmf_dbg(ERROR, "dongle is not responding\n");
+		brcmf_err("dongle is not responding\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index c26493f..ba0b225 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -157,9 +157,9 @@ static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
 		if (ifp->ndev && fweh->evt_handler[code])
 			err = fweh->evt_handler[code](ifp, emsg, data);
 		else
-			brcmf_dbg(ERROR, "unhandled event %d ignored\n", code);
+			brcmf_err("unhandled event %d ignored\n", code);
 	} else {
-		brcmf_dbg(ERROR, "no interface object\n");
+		brcmf_err("no interface object\n");
 	}
 	return err;
 }
@@ -184,7 +184,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		  ifevent->bssidx, ifevent->flags);
 
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
-		brcmf_dbg(ERROR, "invalid interface index: %u\n",
+		brcmf_err("invalid interface index: %u\n",
 			  ifevent->ifidx);
 		return;
 	}
@@ -286,7 +286,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
 						    event->data);
 		if (err) {
-			brcmf_dbg(ERROR, "event handler failed (%d)\n",
+			brcmf_err("event handler failed (%d)\n",
 				  event->code);
 			err = 0;
 		}
@@ -343,7 +343,7 @@ int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
 			brcmf_fweh_handler_t handler)
 {
 	if (drvr->fweh.evt_handler[code]) {
-		brcmf_dbg(ERROR, "event code %d already registered\n", code);
+		brcmf_err("event code %d already registered\n", code);
 		return -ENOSPC;
 	}
 	drvr->fweh.evt_handler[code] = handler;
@@ -391,7 +391,7 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs",
 				       eventmask, BRCMF_EVENTING_MASK_LEN);
 	if (err)
-		brcmf_dbg(ERROR, "Set event_msgs error (%d)\n", err);
+		brcmf_err("Set event_msgs error (%d)\n", err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 51a1450..d8d8b65 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -38,7 +38,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	s32 err;
 
 	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
-		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
+		brcmf_err("bus is down. we have nothing to do.\n");
 		return -EIO;
 	}
 
@@ -53,7 +53,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	if (err >= 0)
 		err = 0;
 	else
-		brcmf_dbg(ERROR, "Failed err=%d\n", err);
+		brcmf_err("Failed err=%d\n", err);
 
 	return err;
 }
@@ -161,7 +161,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_dbg(ERROR, "Creating iovar failed\n");
+		brcmf_err("Creating iovar failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -187,7 +187,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_dbg(ERROR, "Creating iovar failed\n");
+		brcmf_err("Creating iovar failed\n");
 	}
 
 	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
@@ -237,7 +237,7 @@ brcmf_create_bsscfg(s32 bssidx, char *name, char *data, u32 datalen, char *buf,
 	iolen = prefixlen + namelen + sizeof(bssidx_le) + datalen;
 
 	if (buflen < iolen) {
-		brcmf_dbg(ERROR, "buffer is too short\n");
+		brcmf_err("buffer is too short\n");
 		return 0;
 	}
 
@@ -284,7 +284,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_dbg(ERROR, "Creating bsscfg failed\n");
+		brcmf_err("Creating bsscfg failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -310,7 +310,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_dbg(ERROR, "Creating bsscfg failed\n");
+		brcmf_err("Creating bsscfg failed\n");
 	}
 	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 9434440..b1bb46c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -186,7 +186,7 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 					   CORE_SB(base, sbtmstatehigh),
 					   NULL);
 		if (regdata & SSB_TMSHIGH_BUSY)
-			brcmf_dbg(ERROR, "core state still busy\n");
+			brcmf_err("core state still busy\n");
 
 		regdata = brcmf_sdio_regrl(sdiodev, CORE_SB(base, sbidlow),
 					   NULL);
@@ -438,7 +438,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->ramsize = 0x80000;
 		break;
 	default:
-		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
+		brcmf_err("chipid 0x%x is not supported\n", ci->chip);
 		return -ENODEV;
 	}
 
@@ -456,7 +456,7 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->resetcore = brcmf_sdio_ai_resetcore;
 		break;
 	default:
-		brcmf_dbg(ERROR, "socitype %u not supported\n", ci->socitype);
+		brcmf_err("socitype %u not supported\n", ci->socitype);
 		return -ENODEV;
 	}
 
@@ -473,7 +473,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
 	brcmf_sdio_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
-		brcmf_dbg(ERROR, "error writing for HT off\n");
+		brcmf_err("error writing for HT off\n");
 		return err;
 	}
 
@@ -483,7 +483,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 				  SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
-		brcmf_dbg(ERROR, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
 			  clkset, clkval);
 		return -EACCES;
 	}
@@ -493,7 +493,7 @@ brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
 	if (!SBSDIO_ALPAV(clkval)) {
-		brcmf_dbg(ERROR, "timeout on ALPAV wait, clkval 0x%02x\n",
+		brcmf_err("timeout on ALPAV wait, clkval 0x%02x\n",
 			  clkval);
 		return -EBUSY;
 	}
@@ -618,7 +618,7 @@ brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		str_shift = 11;
 		break;
 	default:
-		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
 			  brcmf_sdio_chip_name(ci->chip, chn, 8),
 			  ci->chiprev, ci->pmurev);
 		break;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 5eb7bf8..914c56f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -216,7 +216,7 @@ brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0)
-		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
+		brcmf_err("usb_submit_urb failed %d\n", ret);
 
 	return ret;
 }
@@ -250,7 +250,7 @@ brcmf_usb_recv_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0)
-		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
+		brcmf_err("usb_submit_urb failed %d\n", ret);
 
 	return ret;
 }
@@ -271,14 +271,14 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	devinfo->ctl_completed = false;
 	err = brcmf_usb_send_ctl(devinfo, buf, len);
 	if (err) {
-		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
+		brcmf_err("fail %d bytes: %d\n", err, len);
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
-		brcmf_dbg(ERROR, "Txctl wait timed out\n");
+		brcmf_err("Txctl wait timed out\n");
 		err = -EIO;
 	}
 	return err;
@@ -300,7 +300,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	devinfo->ctl_completed = false;
 	err = brcmf_usb_recv_ctl(devinfo, buf, len);
 	if (err) {
-		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
+		brcmf_err("fail %d bytes: %d\n", err, len);
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
@@ -308,7 +308,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	err = devinfo->ctl_urb_status;
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
-		brcmf_dbg(ERROR, "rxctl wait timed out\n");
+		brcmf_err("rxctl wait timed out\n");
 		err = -EIO;
 	}
 	if (!err)
@@ -356,7 +356,7 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
 
 	reqs = kzalloc(sizeof(struct brcmf_usbreq) * qsize, GFP_ATOMIC);
 	if (reqs == NULL) {
-		brcmf_dbg(ERROR, "fail to allocate memory!\n");
+		brcmf_err("fail to allocate memory!\n");
 		return NULL;
 	}
 	req = reqs;
@@ -372,7 +372,7 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
 	}
 	return reqs;
 fail:
-	brcmf_dbg(ERROR, "fail!\n");
+	brcmf_err("fail!\n");
 	while (!list_empty(q)) {
 		req = list_entry(q->next, struct brcmf_usbreq, list);
 		if (req && req->urb)
@@ -389,7 +389,7 @@ static void brcmf_usb_free_q(struct list_head *q, bool pending)
 	int i = 0;
 	list_for_each_entry_safe(req, next, q, list) {
 		if (!req->urb) {
-			brcmf_dbg(ERROR, "bad req\n");
+			brcmf_err("bad req\n");
 			break;
 		}
 		i++;
@@ -462,7 +462,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
 		skb_put(skb, urb->actual_length);
 		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
-			brcmf_dbg(ERROR, "rx protocol error\n");
+			brcmf_err("rx protocol error\n");
 			brcmu_pkt_buf_free_skb(skb);
 			devinfo->bus_pub.bus->dstats.rx_errors++;
 		} else
@@ -513,7 +513,7 @@ static void brcmf_usb_rx_fill_all(struct brcmf_usbdev_info *devinfo)
 	struct brcmf_usbreq *req;
 
 	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP) {
-		brcmf_dbg(ERROR, "bus is not up=%d\n", devinfo->bus_pub.state);
+		brcmf_err("bus is not up=%d\n", devinfo->bus_pub.state);
 		return;
 	}
 	while ((req = brcmf_usb_deq(devinfo, &devinfo->rx_freeq, NULL)) != NULL)
@@ -569,14 +569,14 @@ brcmf_usb_intr_complete(struct urb *urb)
 	}
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_DOWN) {
-		brcmf_dbg(ERROR, "intr cb when DBUS down, ignoring\n");
+		brcmf_err("intr cb when DBUS down, ignoring\n");
 		return;
 	}
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
 		err = usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
 		if (err)
-			brcmf_dbg(ERROR, "usb_submit_urb, err=%d\n", err);
+			brcmf_err("usb_submit_urb, err=%d\n", err);
 	}
 }
 
@@ -594,7 +594,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 					&devinfo->tx_freecount);
 	if (!req) {
 		brcmu_pkt_buf_free_skb(skb);
-		brcmf_dbg(ERROR, "no req to send\n");
+		brcmf_err("no req to send\n");
 		return -ENOMEM;
 	}
 
@@ -606,7 +606,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	brcmf_usb_enq(devinfo, &devinfo->tx_postq, req, NULL);
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
-		brcmf_dbg(ERROR, "brcmf_usb_tx usb_submit_urb FAILED\n");
+		brcmf_err("brcmf_usb_tx usb_submit_urb FAILED\n");
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
@@ -648,7 +648,7 @@ static int brcmf_usb_up(struct device *dev)
 
 		ret = usb_submit_urb(devinfo->intr_urb, GFP_ATOMIC);
 		if (ret) {
-			brcmf_dbg(ERROR, "USB_SUBMIT_URB failed with status %d\n",
+			brcmf_err("USB_SUBMIT_URB failed with status %d\n",
 				  ret);
 			return -EINVAL;
 		}
@@ -745,7 +745,7 @@ static bool brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0) {
-		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
+		brcmf_err("usb_submit_urb failed %d\n", ret);
 		kfree(tmpbuf);
 		return false;
 	}
@@ -815,7 +815,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id, sizeof(id));
 		return 0;
 	} else {
-		brcmf_dbg(ERROR, "Cannot talk to Dongle. Firmware is not UP, %d ms\n",
+		brcmf_err("Cannot talk to Dongle. Firmware is not UP, %d ms\n",
 			  BRCMF_USB_RESET_GETVER_SPINWAIT * loop_cnt);
 		return -EINVAL;
 	}
@@ -840,7 +840,7 @@ brcmf_usb_dl_send_bulk(struct brcmf_usbdev_info *devinfo, void *buffer, int len)
 	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->bulk_urb, GFP_ATOMIC);
 	if (ret) {
-		brcmf_dbg(ERROR, "usb_submit_urb failed %d\n", ret);
+		brcmf_err("usb_submit_urb failed %d\n", ret);
 		return ret;
 	}
 	ret = brcmf_usb_ioctl_resp_wait(devinfo);
@@ -873,7 +873,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 	/* 2) Check we are in the Waiting state */
 	if (rdlstate != DL_WAITING) {
-		brcmf_dbg(ERROR, "Failed to DL_START\n");
+		brcmf_err("Failed to DL_START\n");
 		err = -EINVAL;
 		goto fail;
 	}
@@ -902,7 +902,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 			memcpy(bulkchunk, dlpos, sendlen);
 			if (brcmf_usb_dl_send_bulk(devinfo, bulkchunk,
 						   sendlen)) {
-				brcmf_dbg(ERROR, "send_bulk failed\n");
+				brcmf_err("send_bulk failed\n");
 				err = -EINVAL;
 				goto fail;
 			}
@@ -912,7 +912,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 		}
 		if (!brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state,
 				      sizeof(struct rdl_state_le))) {
-			brcmf_dbg(ERROR, "DL_GETSTATE Failed xxxx\n");
+			brcmf_err("DL_GETSTATE Failed xxxx\n");
 			err = -EINVAL;
 			goto fail;
 		}
@@ -922,7 +922,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 		/* restart if an error is reported */
 		if (rdlstate == DL_BAD_HDR || rdlstate == DL_BAD_CRC) {
-			brcmf_dbg(ERROR, "Bad Hdr or Bad CRC state %d\n",
+			brcmf_err("Bad Hdr or Bad CRC state %d\n",
 				  rdlstate);
 			err = -EINVAL;
 			goto fail;
@@ -981,7 +981,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 			return -ENODEV;
 		/* The Dongle may go for re-enumeration. */
 	} else {
-		brcmf_dbg(ERROR, "Dongle not runnable\n");
+		brcmf_err("Dongle not runnable\n");
 		return -EINVAL;
 	}
 	brcmf_dbg(USB, "Exit\n");
@@ -1019,13 +1019,13 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 	chiprev = devinfo->bus_pub.chiprev;
 
 	if (!brcmf_usb_chip_support(devid, chiprev)) {
-		brcmf_dbg(ERROR, "unsupported chip %d rev %d\n",
+		brcmf_err("unsupported chip %d rev %d\n",
 			  devid, chiprev);
 		return -EINVAL;
 	}
 
 	if (!devinfo->image) {
-		brcmf_dbg(ERROR, "No firmware!\n");
+		brcmf_err("No firmware!\n");
 		return -ENOENT;
 	}
 
@@ -1124,11 +1124,11 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 	/* fw image not yet loaded. Load it now and add to list */
 	err = request_firmware(&fw, fwname, devinfo->dev);
 	if (!fw) {
-		brcmf_dbg(ERROR, "fail to request firmware %s\n", fwname);
+		brcmf_err("fail to request firmware %s\n", fwname);
 		return err;
 	}
 	if (check_file(fw->data) < 0) {
-		brcmf_dbg(ERROR, "invalid firmware %s\n", fwname);
+		brcmf_err("invalid firmware %s\n", fwname);
 		return -EINVAL;
 	}
 
@@ -1196,17 +1196,17 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 
 	devinfo->intr_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->intr_urb) {
-		brcmf_dbg(ERROR, "usb_alloc_urb (intr) failed\n");
+		brcmf_err("usb_alloc_urb (intr) failed\n");
 		goto error;
 	}
 	devinfo->ctl_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->ctl_urb) {
-		brcmf_dbg(ERROR, "usb_alloc_urb (ctl) failed\n");
+		brcmf_err("usb_alloc_urb (ctl) failed\n");
 		goto error;
 	}
 	devinfo->bulk_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->bulk_urb) {
-		brcmf_dbg(ERROR, "usb_alloc_urb (bulk) failed\n");
+		brcmf_err("usb_alloc_urb (bulk) failed\n");
 		goto error;
 	}
 
@@ -1223,7 +1223,7 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	return &devinfo->bus_pub;
 
 error:
-	brcmf_dbg(ERROR, "failed!\n");
+	brcmf_err("failed!\n");
 	brcmf_usb_detach(devinfo);
 	return NULL;
 }
@@ -1263,13 +1263,13 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(0, dev);
 	if (ret) {
-		brcmf_dbg(ERROR, "brcmf_attach failed\n");
+		brcmf_err("brcmf_attach failed\n");
 		goto fail;
 	}
 
 	ret = brcmf_bus_start(dev);
 	if (ret) {
-		brcmf_dbg(ERROR, "dongle is not responding\n");
+		brcmf_err("dongle is not responding\n");
 		brcmf_detach(dev);
 		goto fail;
 	}
@@ -1344,7 +1344,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (IFDESC(usb, CONTROL_IF).bInterfaceClass != USB_CLASS_VENDOR_SPEC ||
 	    IFDESC(usb, CONTROL_IF).bInterfaceSubClass != 2 ||
 	    IFDESC(usb, CONTROL_IF).bInterfaceProtocol != 0xff) {
-		brcmf_dbg(ERROR, "invalid control interface: class %d, subclass %d, proto %d\n",
+		brcmf_err("invalid control interface: class %d, subclass %d, proto %d\n",
 			  IFDESC(usb, CONTROL_IF).bInterfaceClass,
 			  IFDESC(usb, CONTROL_IF).bInterfaceSubClass,
 			  IFDESC(usb, CONTROL_IF).bInterfaceProtocol);
@@ -1356,7 +1356,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	endpoint = &IFEPDESC(usb, CONTROL_IF, 0);
 	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
 		!= USB_ENDPOINT_XFER_INT) {
-		brcmf_dbg(ERROR, "invalid control endpoint %d\n",
+		brcmf_err("invalid control endpoint %d\n",
 			  endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
 		ret = -1;
 		goto fail;
@@ -1375,7 +1375,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		endpoint = &IFEPDESC(usb, BULK_IF, ep);
 		if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
 		    USB_ENDPOINT_XFER_BULK) {
-			brcmf_dbg(ERROR, "invalid data endpoint %d\n", ep);
+			brcmf_err("invalid data endpoint %d\n", ep);
 			ret = -1;
 			goto fail;
 		}
@@ -1418,7 +1418,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	return 0;
 
 fail:
-	brcmf_dbg(ERROR, "failed with errno %d\n", ret);
+	brcmf_err("failed with errno %d\n", ret);
 	kfree(devinfo);
 	usb_set_intfdata(intf, NULL);
 	return ret;
-- 
1.7.9.5


