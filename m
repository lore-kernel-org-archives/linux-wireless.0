Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36557 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdBBVdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Feb 2017 16:33:52 -0500
Received: by mail-lf0-f68.google.com with SMTP id h65so39467lfi.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2017 13:33:50 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 8/9] brcmfmac: modify all brcmf_err calls adding struct brcmf_pub
Date: Thu,  2 Feb 2017 22:33:20 +0100
Message-Id: <20170202213321.11591-8-zajec5@gmail.com> (sfid-20170202_223417_725043_B09E4D0A)
In-Reply-To: <20170202213321.11591-1-zajec5@gmail.com>
References: <20170202213321.11591-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This finally allows getting extra info from struct brcmf_pub in the
brcmf_err and improving error messages. In places where pub struct is
not available or hard to obtain NULL is passed instead. Few of these
cases could be improved in the future by adding more arguments to
various functions.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Rebase on the latest tree
    Fix pub variable usage in brcmf_cfg80211_vndr_cmds_dcmd_handler
    Simplify sdio code thanks to [PATCH V2 5/7] brcmfmac: sdio: store private pointer to struct brcmf_pub
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  49 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   5 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 452 ++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  26 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  45 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   4 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   2 +-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |  12 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  43 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  58 +--
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  80 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  42 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |  20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 213 +++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  70 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/vendor.c  |  17 +-
 23 files changed, 692 insertions(+), 507 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 384b1873e7e3..e57e189f3a6a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -169,7 +169,7 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
 	if (ret < 0) {
-		brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
+		brcmf_err(drvr, "brcmf_proto_bcdc_msg failed w/status %d\n",
 			  ret);
 		goto done;
 	}
@@ -186,7 +186,7 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	if ((id < bcdc->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != bcdc->reqid) {
-		brcmf_err("%s: unexpected request id %d (expected %d)\n",
+		brcmf_err(drvr, "%s: unexpected request id %d (expected %d)\n",
 			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
 			  bcdc->reqid);
 		ret = -EINVAL;
@@ -234,7 +234,7 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	id = (flags & BCDC_DCMD_ID_MASK) >> BCDC_DCMD_ID_SHIFT;
 
 	if (id != bcdc->reqid) {
-		brcmf_err("%s: unexpected request id %d (expected %d)\n",
+		brcmf_err(drvr, "%s: unexpected request id %d (expected %d)\n",
 			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
 			  bcdc->reqid);
 		ret = -EINVAL;
@@ -299,7 +299,7 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	}
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
 	    BCDC_PROTO_VER) {
-		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
+		brcmf_err(drvr, "%s: non-BCDC packet received, flags 0x%x\n",
 			  brcmf_ifname(tmp_if), h->flags);
 		return -EBADE;
 	}
@@ -379,7 +379,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&bcdc->msg + 1) != (unsigned long)bcdc->buf) {
-		brcmf_err("struct brcmf_proto_bcdc is not correctly defined\n");
+		brcmf_err(drvr, "struct brcmf_proto_bcdc is not correctly defined\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 5bc2ba214735..7c592ce5f894 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -103,6 +103,7 @@ static void brcmf_sdiod_dummy_irqhandler(struct sdio_func *func)
 
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct brcmfmac_sdio_pd *pdata;
 	int ret = 0;
 	u8 data;
@@ -117,7 +118,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 				  pdata->oob_irq_flags, "brcmf_oob_intr",
 				  &sdiodev->func[1]->dev);
 		if (ret != 0) {
-			brcmf_err("request_irq failed %d\n", ret);
+			brcmf_err(pub, "request_irq failed %d\n", ret);
 			return ret;
 		}
 		sdiodev->oob_irq_requested = true;
@@ -128,7 +129,7 @@ int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 		ret = enable_irq_wake(pdata->oob_irq_nr);
 		if (ret != 0) {
-			brcmf_err("enable_irq_wake failed %d\n", ret);
+			brcmf_err(pub, "enable_irq_wake failed %d\n", ret);
 			return ret;
 		}
 		sdiodev->irq_wake = true;
@@ -253,6 +254,7 @@ static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
 static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 				    u32 addr, u8 regsz, void *data, bool write)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct sdio_func *func;
 	int ret = -EINVAL;
 
@@ -292,7 +294,7 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 			*(u32 *)data = sdio_readl(func, addr, &ret);
 		break;
 	default:
-		brcmf_err("invalid size: %d\n", regsz);
+		brcmf_err(pub, "invalid size: %d\n", regsz);
 		break;
 	}
 
@@ -306,6 +308,7 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data, bool write)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	u8 func;
 	s32 retry = 0;
 	int ret;
@@ -344,7 +347,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		 * in the logs.
 		 */
 		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to %s data F%d@0x%05x, err: %d\n",
+			brcmf_err(pub, "failed to %s data F%d@0x%05x, err: %d\n",
 				  write ? "write" : "read", func, addr, ret);
 		else
 			brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
@@ -356,6 +359,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 static int
 brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	int err = 0, i;
 	u8 addr[3];
 
@@ -371,7 +375,7 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 					       SBSDIO_FUNC1_SBADDRLOW + i,
 					       sizeof(u8), &addr[i], true);
 		if (err) {
-			brcmf_err("failed at addr: 0x%0x\n",
+			brcmf_err(pub, "failed at addr: 0x%0x\n",
 				  SBSDIO_FUNC1_SBADDRLOW + i);
 			break;
 		}
@@ -512,6 +516,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	unsigned int max_req_sz, orig_offset, dst_offset;
 	unsigned short max_seg_cnt, seg_sz;
 	unsigned char *pkt_data, *orig_data, *dst_data;
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct sk_buff *pkt_next = NULL, *local_pkt_next;
 	struct sk_buff_head local_list, *target_list;
 	struct mmc_request mmc_req;
@@ -604,7 +609,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		seg_sz -= sg_cnt;
 
 		if (req_sz % func_blk_sz != 0) {
-			brcmf_err("sg request length %u is not %u aligned\n",
+			brcmf_err(pub, "sg request length %u is not %u aligned\n",
 				  req_sz, func_blk_sz);
 			ret = -ENOTBLK;
 			goto exit;
@@ -626,7 +631,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
 			break;
 		} else if (ret != 0) {
-			brcmf_err("CMD53 sg block %s failed %d\n",
+			brcmf_err(pub, "CMD53 sg block %s failed %d\n",
 				  write ? "write" : "read", ret);
 			ret = -EIO;
 			break;
@@ -667,12 +672,13 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 
 int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct sk_buff *mypkt;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
 	if (!mypkt) {
-		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
+		brcmf_err(pub, "brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
 		return -EIO;
 	}
@@ -745,13 +751,14 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct sk_buff *mypkt;
 	u32 addr = sdiodev->sbwad;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
 	if (!mypkt) {
-		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
+		brcmf_err(pub, "brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
 		return -EIO;
 	}
@@ -800,6 +807,7 @@ int
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	int bcmerror = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
@@ -808,7 +816,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	dsize = min_t(uint, SBSDIO_SB_OFT_ADDR_LIMIT, size);
 	pkt = dev_alloc_skb(dsize);
 	if (!pkt) {
-		brcmf_err("dev_alloc_skb failed: len %d\n", dsize);
+		brcmf_err(pub, "dev_alloc_skb failed: len %d\n", dsize);
 		return -EIO;
 	}
 	pkt->priority = 0;
@@ -842,7 +850,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		bcmerror = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
 					      sdaddr, pkt);
 		if (bcmerror) {
-			brcmf_err("membytes transfer failed\n");
+			brcmf_err(pub, "membytes transfer failed\n");
 			break;
 		}
 		if (!write)
@@ -863,7 +871,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdiod_set_sbaddr_window(sdiodev, sdiodev->sbwad))
-		brcmf_err("FAILED to set window back to 0x%x\n",
+		brcmf_err(pub, "FAILED to set window back to 0x%x\n",
 			  sdiodev->sbwad);
 
 	sdio_release_host(sdiodev->func[1]);
@@ -886,6 +894,7 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 
 void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	struct sdio_func *func;
 	struct mmc_host *host;
 	uint max_blocks;
@@ -914,7 +923,7 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	brcmf_dbg(TRACE, "nents=%d\n", nents);
 	err = sg_alloc_table(&sdiodev->sgtable, nents, GFP_KERNEL);
 	if (err < 0) {
-		brcmf_err("allocation failed: disable scatter-gather");
+		brcmf_err(pub, "allocation failed: disable scatter-gather");
 		sdiodev->sg_support = false;
 	}
 
@@ -1047,13 +1056,13 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 
 	ret = sdio_set_block_size(sdiodev->func[1], SDIO_FUNC1_BLOCKSIZE);
 	if (ret) {
-		brcmf_err("Failed to set F1 blocksize\n");
+		brcmf_err(NULL, "Failed to set F1 blocksize\n");
 		sdio_release_host(sdiodev->func[1]);
 		goto out;
 	}
 	ret = sdio_set_block_size(sdiodev->func[2], SDIO_FUNC2_BLOCKSIZE);
 	if (ret) {
-		brcmf_err("Failed to set F2 blocksize\n");
+		brcmf_err(NULL, "Failed to set F2 blocksize\n");
 		sdio_release_host(sdiodev->func[1]);
 		goto out;
 	}
@@ -1065,7 +1074,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 	ret = sdio_enable_func(sdiodev->func[1]);
 	sdio_release_host(sdiodev->func[1]);
 	if (ret) {
-		brcmf_err("Failed to enable F1: err=%d\n", ret);
+		brcmf_err(NULL, "Failed to enable F1: err=%d\n", ret);
 		goto out;
 	}
 
@@ -1179,7 +1188,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "F2 found, calling brcmf_sdiod_probe...\n");
 	err = brcmf_sdiod_probe(sdiodev);
 	if (err) {
-		brcmf_err("F2 error, probe failed %d...\n", err);
+		brcmf_err(NULL, "F2 error, probe failed %d...\n", err);
 		goto fail;
 	}
 
@@ -1244,6 +1253,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	struct sdio_func *func;
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_pub *pub;
 	mmc_pm_flag_t sdio_flags;
 
 	func = container_of(dev, struct sdio_func, dev);
@@ -1254,6 +1264,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 
 	bus_if = dev_get_drvdata(dev);
 	sdiodev = bus_if->bus_priv.sdio;
+	pub = bus_if->drvr;
 
 	brcmf_sdiod_freezer_on(sdiodev);
 	brcmf_sdio_wd_timer(sdiodev->bus, 0);
@@ -1266,7 +1277,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 			sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
 	}
 	if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
-		brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
+		brcmf_err(pub, "Failed to set pm_flags %x\n", sdio_flags);
 	return 0;
 }
 
@@ -1309,7 +1320,7 @@ void brcmf_sdio_register(void)
 
 	ret = sdio_register_driver(&brcmf_sdmmc_driver);
 	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
+		brcmf_err(NULL, "sdio_register_driver failed: %d\n", ret);
 }
 
 void brcmf_sdio_exit(void)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
index 14a70d4b4e86..0944d7291d58 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -215,7 +215,7 @@ static bool brcmf_btcoex_is_sco_active(struct brcmf_if *ifp)
 		ioc_res = brcmf_btcoex_params_read(ifp, 27, &param27);
 
 		if (ioc_res < 0) {
-			brcmf_err("ioc read btc params error\n");
+			brcmf_err(ifp->drvr, "ioc read btc params error\n");
 			break;
 		}
 
@@ -345,7 +345,8 @@ static void brcmf_btcoex_handler(struct work_struct *work)
 		goto idle;
 
 	default:
-		brcmf_err("invalid state=%d !!!\n", btci->bt_state);
+		brcmf_err(btci->cfg->pub, "invalid state=%d !!!\n",
+			  btci->bt_state);
 		goto idle;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 0e28d0710af5..a665665fde96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -468,7 +468,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 					sizeof(key_le));
 
 	if (err)
-		brcmf_err("wsec_key error (%d)\n", err);
+		brcmf_err(ifp->drvr, "wsec_key error (%d)\n", err);
 	return err;
 }
 
@@ -549,6 +549,7 @@ static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
 
 static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_mbss_ssid_le mbss_ssid_le;
 	int bsscfgidx;
 	int err;
@@ -565,7 +566,7 @@ static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 	err = brcmf_fil_bsscfg_data_set(ifp, "bsscfg:ssid", &mbss_ssid_le,
 					sizeof(mbss_ssid_le));
 	if (err < 0)
-		brcmf_err("setting ssid failed %d\n", err);
+		brcmf_err(pub, "setting ssid failed %d\n", err);
 
 	return err;
 }
@@ -584,6 +585,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	int err;
 
@@ -609,7 +611,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(pub, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -617,7 +619,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	/* interface created in firmware */
 	ifp = vif->ifp;
 	if (!ifp) {
-		brcmf_err("no if pointer provided\n");
+		brcmf_err(pub, "no if pointer provided\n");
 		err = -ENOENT;
 		goto fail;
 	}
@@ -625,7 +627,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-		brcmf_err("Registering netdevice failed\n");
+		brcmf_err(pub, "Registering netdevice failed\n");
 		goto fail;
 	}
 
@@ -656,13 +658,15 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     u32 *flags,
 						     struct vif_params *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct wireless_dev *wdev;
 	int err;
 
 	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
-	err = brcmf_vif_add_validate(wiphy_to_cfg(wiphy), type);
+	err = brcmf_vif_add_validate(cfg, type);
 	if (err) {
-		brcmf_err("iface validation failed: err=%d\n", err);
+		brcmf_err(pub, "iface validation failed: err=%d\n", err);
 		return ERR_PTR(err);
 	}
 	switch (type) {
@@ -687,7 +691,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 
 	if (IS_ERR(wdev))
-		brcmf_err("add iface %s type %d failed: err=%d\n",
+		brcmf_err(pub, "add iface %s type %d failed: err=%d\n",
 			  name, type, (int)PTR_ERR(wdev));
 	else
 		brcmf_cfg80211_update_proto_addr_mode(wdev);
@@ -708,7 +712,7 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 	if (check_vif_up(ifp->vif)) {
 		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
-			brcmf_err("fail to set mpc\n");
+			brcmf_err(ifp->drvr, "fail to set mpc\n");
 			return;
 		}
 		brcmf_dbg(INFO, "MPC : %d\n", mpc);
@@ -719,6 +723,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort)
 {
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_scan_params_le params_le;
 	struct cfg80211_scan_request *scan_request;
 	s32 err = 0;
@@ -751,7 +756,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &params_le, sizeof(params_le));
 		if (err)
-			brcmf_err("Scan abort  failed\n");
+			brcmf_err(pub, "Scan abort  failed\n");
 	}
 
 	brcmf_scan_config_mpc(ifp, 1);
@@ -784,6 +789,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 				       struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct net_device *ndev = wdev->netdev;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	int ret;
@@ -793,7 +799,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 
 	err = brcmf_fil_bsscfg_data_set(ifp, "interface_remove", NULL, 0);
 	if (err) {
-		brcmf_err("interface_remove failed %d\n", err);
+		brcmf_err(pub, "interface_remove failed %d\n", err);
 		goto err_unarm;
 	}
 
@@ -801,7 +807,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 	ret = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	if (!ret) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(pub, "timeout occurred\n");
 		err = -EIO;
 		goto err_unarm;
 	}
@@ -862,6 +868,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	s32 infra = 0;
@@ -903,13 +910,13 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	err = brcmf_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
 	if (err) {
-		brcmf_err("iface validation failed: err=%d\n", err);
+		brcmf_err(pub, "iface validation failed: err=%d\n", err);
 		return err;
 	}
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		brcmf_err("type (%d) : currently we do not support this type\n",
+		brcmf_err(pub, "type (%d) : currently we do not support this type\n",
 			  type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
@@ -938,7 +945,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
-			brcmf_err("WLC_SET_INFRA error (%d)\n", err);
+			brcmf_err(pub, "WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
 			goto done;
 		}
@@ -1042,6 +1049,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 {
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
 			  offsetof(struct brcmf_escan_params_le, params_le);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_escan_params_le *params;
 	s32 err = 0;
 
@@ -1071,7 +1079,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		if (err == -EBUSY)
 			brcmf_dbg(INFO, "system busy : escan canceled\n");
 		else
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(pub, "error (%d)\n", err);
 	}
 
 	kfree(params);
@@ -1096,7 +1104,7 @@ brcmf_do_escan(struct brcmf_if *ifp, struct cfg80211_scan_request *request)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
 				    passive_scan);
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(ifp->drvr, "error (%d)\n", err);
 		return err;
 	}
 	brcmf_scan_config_mpc(ifp, 0);
@@ -1118,6 +1126,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 {
 	struct brcmf_if *ifp = vif->ifp;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct cfg80211_ssid *ssids;
 	u32 passive_scan;
 	bool escan_req;
@@ -1129,21 +1138,23 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 	brcmf_dbg(SCAN, "START ESCAN\n");
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
+		brcmf_err(pub, "Scanning already: status (%lu)\n",
+			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
-		brcmf_err("Scanning being aborted: status (%lu)\n",
+		brcmf_err(pub, "Scanning being aborted: status (%lu)\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		brcmf_err("Scanning suppressed: status (%lu)\n",
+		brcmf_err(pub, "Scanning suppressed: status (%lu)\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
-		brcmf_err("Connecting: status (%lu)\n", ifp->vif->sme_state);
+		brcmf_err(pub, "Connecting: status (%lu)\n",
+			  ifp->vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -1191,7 +1202,8 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
 					    passive_scan);
 		if (err) {
-			brcmf_err("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
+			brcmf_err(pub, "WLC_SET_PASSIVE_SCAN error (%d)\n",
+				  err);
 			goto scan_out;
 		}
 		brcmf_scan_config_mpc(ifp, 0);
@@ -1202,7 +1214,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 				brcmf_dbg(INFO, "BUSY: scan for \"%s\" canceled\n",
 					  ssid_le.SSID);
 			else
-				brcmf_err("WLC_SCAN error (%d)\n", err);
+				brcmf_err(pub, "WLC_SCAN error (%d)\n", err);
 
 			brcmf_scan_config_mpc(ifp, 1);
 			goto scan_out;
@@ -1235,7 +1247,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	err = brcmf_cfg80211_escan(wiphy, vif, request, NULL);
 
 	if (err)
-		brcmf_err("scan error (%d)\n", err);
+		brcmf_err(vif->ifp->drvr, "scan error (%d)\n", err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -1248,7 +1260,7 @@ static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "rtsthresh",
 				      rts_threshold);
 	if (err)
-		brcmf_err("Error (%d)\n", err);
+		brcmf_err(NULL, "Error (%d)\n", err);
 
 	return err;
 }
@@ -1260,7 +1272,7 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "fragthresh",
 				      frag_threshold);
 	if (err)
-		brcmf_err("Error (%d)\n", err);
+		brcmf_err(NULL, "Error (%d)\n", err);
 
 	return err;
 }
@@ -1272,7 +1284,7 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), cmd, retry);
 	if (err) {
-		brcmf_err("cmd (%d) , error (%d)\n", cmd, err);
+		brcmf_err(NULL, "cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
 	return err;
@@ -1349,6 +1361,7 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(vif->wdev.wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1358,7 +1371,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err) {
-			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
+			brcmf_err(pub, "WLC_DISASSOC failed (%d)\n", err);
 		}
 		if ((vif->wdev.iftype == NL80211_IFTYPE_STATION) ||
 		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT))
@@ -1376,6 +1389,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_join_params join_params;
@@ -1442,7 +1456,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_iovar_int_set(ifp, "wsec", wsec);
 	if (err) {
-		brcmf_err("wsec failed (%d)\n", err);
+		brcmf_err(pub, "wsec failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1454,7 +1468,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD, bcnprd);
 	if (err) {
-		brcmf_err("WLC_SET_BCNPRD failed (%d)\n", err);
+		brcmf_err(pub, "WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1499,7 +1513,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_CHANNEL,
 					    target_channel);
 		if (err) {
-			brcmf_err("WLC_SET_CHANNEL failed (%d)\n", err);
+			brcmf_err(pub, "WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
 		}
 	} else
@@ -1511,7 +1525,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
-		brcmf_err("WLC_SET_SSID failed (%d)\n", err);
+		brcmf_err(pub, "WLC_SET_SSID failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1548,6 +1562,8 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1561,7 +1577,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
-		brcmf_err("set wpa_auth failed (%d)\n", err);
+		brcmf_err(pub, "set wpa_auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1573,6 +1589,8 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1594,7 +1612,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 	if (err) {
-		brcmf_err("set auth failed (%d)\n", err);
+		brcmf_err(pub, "set auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1607,6 +1625,8 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1629,7 +1649,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			pval = AES_ENABLED;
 			break;
 		default:
-			brcmf_err("invalid cipher pairwise (%d)\n",
+			brcmf_err(pub, "invalid cipher pairwise (%d)\n",
 				  sme->crypto.ciphers_pairwise[0]);
 			return -EINVAL;
 		}
@@ -1650,7 +1670,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			gval = AES_ENABLED;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(pub, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1666,7 +1686,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 	wsec = pval | gval;
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", wsec);
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(pub, "error (%d)\n", err);
 		return err;
 	}
 
@@ -1681,6 +1701,7 @@ static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 val;
 	s32 err;
 	const struct brcmf_tlv *rsn_ie;
@@ -1696,7 +1717,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 
 	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wpa_auth", &val);
 	if (err) {
-		brcmf_err("could not get wpa_auth (%d)\n", err);
+		brcmf_err(pub, "could not get wpa_auth (%d)\n", err);
 		return err;
 	}
 	if (val & (WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED)) {
@@ -1708,7 +1729,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA_AUTH_PSK;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(pub, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1727,7 +1748,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA2_AUTH_PSK;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(pub, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1771,7 +1792,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	brcmf_dbg(CONN, "setting wpa_auth to %d\n", val);
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
-		brcmf_err("could not set wpa_auth (%d)\n", err);
+		brcmf_err(pub, "could not set wpa_auth (%d)\n", err);
 		return err;
 	}
 
@@ -1783,6 +1804,8 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1808,7 +1831,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	key.len = (u32) sme->key_len;
 	key.index = (u32) sme->key_idx;
 	if (key.len > sizeof(key.data)) {
-		brcmf_err("Too long key length (%u)\n", key.len);
+		brcmf_err(pub, "Too long key length (%u)\n", key.len);
 		return -EINVAL;
 	}
 	memcpy(key.data, sme->key, key.len);
@@ -1821,7 +1844,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		key.algo = CRYPTO_ALGO_WEP128;
 		break;
 	default:
-		brcmf_err("Invalid algorithm (%d)\n",
+		brcmf_err(pub, "Invalid algorithm (%d)\n",
 			  sme->crypto.ciphers_pairwise[0]);
 		return -EINVAL;
 	}
@@ -1838,7 +1861,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
 		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
 		if (err)
-			brcmf_err("set auth failed (%d)\n", err);
+			brcmf_err(pub, "set auth failed (%d)\n", err);
 	}
 	return err;
 }
@@ -1896,7 +1919,7 @@ static void brcmf_set_join_pref(struct brcmf_if *ifp,
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
 	if (err)
-		brcmf_err("Set join_pref error (%d)\n", err);
+		brcmf_err(ifp->drvr, "Set join_pref error (%d)\n", err);
 }
 
 static s32
@@ -1904,6 +1927,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
@@ -1922,7 +1946,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!sme->ssid) {
-		brcmf_err("Invalid ssid\n");
+		brcmf_err(pub, "Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1951,7 +1975,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		brcmf_err("Set Assoc REQ IE Failed\n");
+		brcmf_err(pub, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -1972,32 +1996,32 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_wpa_version failed (%d)\n", err);
+		brcmf_err(pub, "wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
 	sme->auth_type = brcmf_war_auth_type(ifp, sme->auth_type);
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_auth_type failed (%d)\n", err);
+		brcmf_err(pub, "wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_wsec_mode(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_set_cipher failed (%d)\n", err);
+		brcmf_err(pub, "wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_key_mgmt(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_key_mgmt failed (%d)\n", err);
+		brcmf_err(pub, "wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_sharedkey(ndev, sme);
 	if (err) {
-		brcmf_err("brcmf_set_sharedkey failed (%d)\n", err);
+		brcmf_err(pub, "brcmf_set_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
@@ -2084,7 +2108,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-		brcmf_err("BRCMF_C_SET_SSID failed (%d)\n", err);
+		brcmf_err(pub, "BRCMF_C_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
@@ -2099,6 +2123,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
@@ -2115,7 +2140,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_DISASSOC,
 				     &scbval, sizeof(scbval));
 	if (err)
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(pub, "error (%d)\n", err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -2126,6 +2151,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    enum nl80211_tx_power_setting type, s32 mbm)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -2142,7 +2168,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
 		if (mbm < 0) {
-			brcmf_err("TX_POWER_FIXED - dbm is negative\n");
+			brcmf_err(pub, "TX_POWER_FIXED - dbm is negative\n");
 			err = -EINVAL;
 			goto done;
 		}
@@ -2152,7 +2178,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 		qdbm |= WL_TXPWR_OVERRIDE;
 		break;
 	default:
-		brcmf_err("Unsupported type %d\n", type);
+		brcmf_err(pub, "Unsupported type %d\n", type);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2160,11 +2186,11 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	disable = WL_RADIO_SW_DISABLE << 16;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_RADIO, disable);
 	if (err)
-		brcmf_err("WLC_SET_RADIO error (%d)\n", err);
+		brcmf_err(pub, "WLC_SET_RADIO error (%d)\n", err);
 
 	err = brcmf_fil_iovar_int_set(ifp, "qtxpower", qdbm);
 	if (err)
-		brcmf_err("qtxpower error (%d)\n", err);
+		brcmf_err(pub, "qtxpower error (%d)\n", err);
 
 done:
 	brcmf_dbg(TRACE, "Exit %d (qdbm)\n", qdbm & ~WL_TXPWR_OVERRIDE);
@@ -2176,6 +2202,7 @@ brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    s32 *dbm)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 qdbm = 0;
@@ -2187,7 +2214,7 @@ brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	err = brcmf_fil_iovar_int_get(ifp, "qtxpower", &qdbm);
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(pub, "error (%d)\n", err);
 		goto done;
 	}
 	*dbm = (qdbm & ~WL_TXPWR_OVERRIDE) / 4;
@@ -2202,6 +2229,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 				  u8 key_idx, bool unicast, bool multicast)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
@@ -2213,7 +2241,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err(pub, "WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
 
@@ -2223,7 +2251,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp,
 					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(pub, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2273,6 +2301,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		       struct key_params *params)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_wsec_key *key;
 	s32 val;
 	s32 wsec;
@@ -2287,7 +2316,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
-		brcmf_err("invalid key index (%d)\n", key_idx);
+		brcmf_err(pub, "invalid key index (%d)\n", key_idx);
 		return -EINVAL;
 	}
 
@@ -2296,7 +2325,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 					      mac_addr);
 
 	if (params->key_len > sizeof(key->data)) {
-		brcmf_err("Too long key length (%u)\n", params->key_len);
+		brcmf_err(pub, "Too long key length (%u)\n", params->key_len);
 		return -EINVAL;
 	}
 
@@ -2350,7 +2379,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
-		brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
+		brcmf_err(pub, "Invalid cipher (0x%x)\n", params->cipher);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2361,13 +2390,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("get wsec error (%d)\n", err);
+		brcmf_err(pub, "get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		brcmf_err("set wsec error (%d)\n", err);
+		brcmf_err(pub, "set wsec error (%d)\n", err);
 		goto done;
 	}
 
@@ -2384,6 +2413,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 {
 	struct key_params params;
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
@@ -2398,7 +2428,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err(pub, "WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
@@ -2419,7 +2449,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 	} else  {
-		brcmf_err("Invalid algo (0x%x)\n", wsec);
+		brcmf_err(pub, "Invalid algo (0x%x)\n", wsec);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2449,6 +2479,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 static void
 brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err;
 	u8 key_idx;
 	struct brcmf_wsec_key *key;
@@ -2465,18 +2496,18 @@ brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 
 	err = send_key_to_dongle(ifp, key);
 	if (err) {
-		brcmf_err("Setting WEP key failed (%d)\n", err);
+		brcmf_err(pub, "Setting WEP key failed (%d)\n", err);
 		return;
 	}
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("get wsec error (%d)\n", err);
+		brcmf_err(pub, "get wsec error (%d)\n", err);
 		return;
 	}
 	wsec |= WEP_ENABLED;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err)
-		brcmf_err("set wsec error (%d)\n", err);
+		brcmf_err(pub, "set wsec error (%d)\n", err);
 }
 
 static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
@@ -2502,6 +2533,7 @@ static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
 
 static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	struct {
 		__le32 len;
 		struct brcmf_bss_info_le bss_le;
@@ -2517,7 +2549,7 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO, buf,
 				     WL_BSS_INFO_MAX);
 	if (err) {
-		brcmf_err("Failed to get bss info (%d)\n", err);
+		brcmf_err(pub, "Failed to get bss info (%d)\n", err);
 		goto out_kfree;
 	}
 	si->filled |= BIT(NL80211_STA_INFO_BSS_PARAM);
@@ -2539,6 +2571,7 @@ static s32
 brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 				struct station_info *sinfo)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_pktcnt_le pktcnt;
 	s32 err;
@@ -2548,7 +2581,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	/* Get the current tx rate */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 	if (err < 0) {
-		brcmf_err("BRCMF_C_GET_RATE error (%d)\n", err);
+		brcmf_err(pub, "BRCMF_C_GET_RATE error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
@@ -2558,7 +2591,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scbval,
 				     sizeof(scbval));
 	if (err) {
-		brcmf_err("BRCMF_C_GET_RSSI error (%d)\n", err);
+		brcmf_err(pub, "BRCMF_C_GET_RSSI error (%d)\n", err);
 		return err;
 	}
 	rssi = le32_to_cpu(scbval.val);
@@ -2568,7 +2601,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_GET_PKTCNTS, &pktcnt,
 				     sizeof(pktcnt));
 	if (err) {
-		brcmf_err("BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
+		brcmf_err(pub, "BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS) |
@@ -2588,6 +2621,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_scb_val_le scb_val;
 	s32 err = 0;
 	struct brcmf_sta_info_le sta_info_le;
@@ -2616,7 +2650,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
-			brcmf_err("GET STA INFO failed, %d\n", err);
+			brcmf_err(pub, "GET STA INFO failed, %d\n", err);
 			goto done;
 		}
 	}
@@ -2685,7 +2719,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
 						     &scb_val, sizeof(scb_val));
 			if (err) {
-				brcmf_err("Could not get rssi (%d)\n", err);
+				brcmf_err(pub, "Could not get rssi (%d)\n",
+					  err);
 				goto done;
 			} else {
 				rssi = le32_to_cpu(scb_val.val);
@@ -2705,6 +2740,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 			    int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
@@ -2716,7 +2752,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 					     &cfg->assoclist,
 					     sizeof(cfg->assoclist));
 		if (err) {
-			brcmf_err("BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
+			brcmf_err(pub, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
 				  err);
 			cfg->assoclist.count = 0;
 			return -EOPNOTSUPP;
@@ -2736,6 +2772,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	s32 pm;
 	s32 err = 0;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2765,9 +2802,9 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
-			brcmf_err("net_device is not ready yet\n");
+			brcmf_err(pub, "net_device is not ready yet\n");
 		else
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(pub, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2778,6 +2815,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *pub = cfg->pub;
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
@@ -2791,7 +2829,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	s32 notify_signal;
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
-		brcmf_err("Bss info is larger than buffer. Discarding\n");
+		brcmf_err(pub, "Bss info is larger than buffer. Discarding\n");
 		return 0;
 	}
 
@@ -2849,6 +2887,7 @@ next_bss_le(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
 
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info_le *bi = NULL;	/* must be initialized */
 	s32 err = 0;
@@ -2857,7 +2896,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	bss_list = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	if (bss_list->count != 0 &&
 	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
-		brcmf_err("Version %d != WL_BSS_INFO_VERSION\n",
+		brcmf_err(pub, "Version %d != WL_BSS_INFO_VERSION\n",
 			  bss_list->version);
 		return -EOPNOTSUPP;
 	}
@@ -2875,6 +2914,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 			     struct net_device *ndev, const u8 *bssid)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *pub = cfg->pub;
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
@@ -2902,7 +2942,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
 				     buf, WL_BSS_INFO_MAX);
 	if (err) {
-		brcmf_err("WLC_GET_BSS_INFO failed: %d\n", err);
+		brcmf_err(pub, "WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
 	}
 
@@ -2956,6 +2996,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_bss_info_le *bi;
 	const struct brcmf_tlv *tim;
 	u16 beacon_interval;
@@ -2972,7 +3013,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
-		brcmf_err("Could not get bss info %d\n", err);
+		brcmf_err(pub, "Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
@@ -2997,7 +3038,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 		u32 var;
 		err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
 		if (err) {
-			brcmf_err("wl dtim_assoc failed (%d)\n", err);
+			brcmf_err(pub, "wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
 		dtim_period = (u8)var;
@@ -3037,7 +3078,7 @@ static void brcmf_escan_timeout(unsigned long data)
 			(struct brcmf_cfg80211_info *)data;
 
 	if (cfg->internal_escan || cfg->scan_request) {
-		brcmf_err("timer expired\n");
+		brcmf_err(cfg->pub, "timer expired\n");
 		schedule_work(&cfg->escan_timeout_work);
 	}
 }
@@ -3086,6 +3127,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			     const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pub *pub = cfg->pub;
 	s32 status;
 	struct brcmf_escan_result_le *escan_result_le;
 	struct brcmf_bss_info_le *bss_info_le;
@@ -3098,7 +3140,8 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	status = e->status;
 
 	if (!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("scan not ready, bsscfgidx=%d\n", ifp->bsscfgidx);
+		brcmf_err(pub, "scan not ready, bsscfgidx=%d\n",
+			  ifp->bsscfgidx);
 		return -EPERM;
 	}
 
@@ -3106,11 +3149,11 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		brcmf_dbg(SCAN, "ESCAN Partial result\n");
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
-			brcmf_err("Invalid escan result (NULL pointer)\n");
+			brcmf_err(pub, "Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
-			brcmf_err("Invalid bss_count %d: ignoring\n",
+			brcmf_err(pub, "Invalid bss_count %d: ignoring\n",
 				  escan_result_le->bss_count);
 			goto exit;
 		}
@@ -3127,7 +3170,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		bi_length = le32_to_cpu(bss_info_le->length);
 		if (bi_length != (le32_to_cpu(escan_result_le->buflen) -
 					WL_ESCAN_RESULTS_FIXED_SIZE)) {
-			brcmf_err("Invalid bss_info length %d: ignoring\n",
+			brcmf_err(pub, "Invalid bss_info length %d: ignoring\n",
 				  bi_length);
 			goto exit;
 		}
@@ -3136,7 +3179,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 					BIT(NL80211_IFTYPE_ADHOC))) {
 			if (le16_to_cpu(bss_info_le->capability) &
 						WLAN_CAPABILITY_IBSS) {
-				brcmf_err("Ignoring IBSS result\n");
+				brcmf_err(pub, "Ignoring IBSS result\n");
 				goto exit;
 			}
 		}
@@ -3144,7 +3187,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
 		if (bi_length > BRCMF_ESCAN_BUF_SIZE - list->buflen) {
-			brcmf_err("Buffer is too small: ignoring\n");
+			brcmf_err(pub, "Buffer is too small: ignoring\n");
 			goto exit;
 		}
 
@@ -3290,6 +3333,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
 	struct cfg80211_scan_request *request = NULL;
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
@@ -3320,7 +3364,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
 	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
 	if (!result_count) {
-		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
+		brcmf_err(pub, "FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
 	request = brcmf_alloc_internal_escan_request(wiphy,
@@ -3335,7 +3379,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
 		if (!netinfo) {
-			brcmf_err("Invalid netinfo ptr. index: %d\n",
+			brcmf_err(pub, "Invalid netinfo ptr. index: %d\n",
 				  i);
 			err = -EINVAL;
 			goto out_err;
@@ -3369,12 +3413,13 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 
 	brcmf_dbg(SCAN, "Enter n_match_sets:%d n_ssids:%d\n",
 		  req->n_match_sets, req->n_ssids);
 
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		brcmf_err("Scanning suppressed: status (%lu)\n",
+		brcmf_err(pub, "Scanning suppressed: status (%lu)\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
@@ -3454,6 +3499,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 		      void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_pno_scanresults_le *pfn_result;
 	struct brcmf_pno_net_info_le *netinfo;
 
@@ -3472,7 +3518,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 	}
 
 	if (le32_to_cpu(pfn_result->count) < 1) {
-		brcmf_err("Invalid result count, expected 1 (%d)\n",
+		brcmf_err(pub, "Invalid result count, expected 1 (%d)\n",
 			  le32_to_cpu(pfn_result->count));
 		return -EINVAL;
 	}
@@ -3500,6 +3546,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_wowl_wakeind_le wake_ind_le;
 	struct cfg80211_wowlan_wakeup wakeup_data;
 	struct cfg80211_wowlan_wakeup *wakeup;
@@ -3510,7 +3557,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
 				       sizeof(wake_ind_le));
 	if (err) {
-		brcmf_err("Get wowl_wakeind failed, err = %d\n", err);
+		brcmf_err(pub, "Get wowl_wakeind failed, err = %d\n", err);
 		return;
 	}
 
@@ -3551,7 +3598,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 				cfg->wowl.nd_data_completed,
 				BRCMF_ND_INFO_TIMEOUT);
 			if (!timeout)
-				brcmf_err("No result for wowl net detect\n");
+				brcmf_err(pub, "No result for wowl net detect\n");
 			else
 				wakeup_data.net_detect = cfg->wowl.nd_info;
 		}
@@ -3738,6 +3785,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
 	s32 err;
@@ -3759,7 +3807,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			cfg->pmk_list.npmk = cpu_to_le32(npmk);
 		}
 	} else {
-		brcmf_err("Too many PMKSA entries cached %d\n", npmk);
+		brcmf_err(pub, "Too many PMKSA entries cached %d\n", npmk);
 		return -EINVAL;
 	}
 
@@ -3780,6 +3828,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
 	s32 err;
@@ -3805,7 +3854,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		memset(&pmk[i], 0, sizeof(*pmk));
 		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
 	} else {
-		brcmf_err("Cache entry not found\n");
+		brcmf_err(pub, "Cache entry not found\n");
 		return -EINVAL;
 	}
 
@@ -3837,24 +3886,25 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err;
 
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
 	if (err < 0) {
-		brcmf_err("auth error %d\n", err);
+		brcmf_err(pub, "auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", 0);
 	if (err < 0) {
-		brcmf_err("wsec error %d\n", err);
+		brcmf_err(pub, "wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", WPA_AUTH_NONE);
 	if (err < 0) {
-		brcmf_err("wpa_auth error %d\n", err);
+		brcmf_err(pub, "wpa_auth error %d\n", err);
 		return err;
 	}
 
@@ -3874,6 +3924,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		      const struct brcmf_vs_tlv *wpa_ie,
 		      bool is_rsn_ie)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	u32 auth = 0; /* d11 open authentication */
 	u16 count;
 	s32 err = 0;
@@ -3904,13 +3955,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {
 		err = -EINVAL;
-		brcmf_err("no multicast cipher suite\n");
+		brcmf_err(pub, "no multicast cipher suite\n");
 		goto exit;
 	}
 
 	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 		err = -EINVAL;
-		brcmf_err("ivalid OUI\n");
+		brcmf_err(pub, "ivalid OUI\n");
 		goto exit;
 	}
 	offset += TLV_OUI_LEN;
@@ -3932,7 +3983,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		break;
 	default:
 		err = -EINVAL;
-		brcmf_err("Invalid multi cast cipher info\n");
+		brcmf_err(pub, "Invalid multi cast cipher info\n");
 		goto exit;
 	}
 
@@ -3943,13 +3994,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for unicast suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		brcmf_err("no unicast cipher suite\n");
+		brcmf_err(pub, "no unicast cipher suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err(pub, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -3967,7 +4018,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			pval |= AES_ENABLED;
 			break;
 		default:
-			brcmf_err("Invalid unicast security info\n");
+			brcmf_err(pub, "Invalid unicast security info\n");
 		}
 		offset++;
 	}
@@ -3977,13 +4028,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for auth key management suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		brcmf_err("no auth key mgmt suite\n");
+		brcmf_err(pub, "no auth key mgmt suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err(pub, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -4011,7 +4062,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			wpa_auth |= WPA2_AUTH_1X_SHA256;
 			break;
 		default:
-			brcmf_err("Invalid key mgmt info\n");
+			brcmf_err(pub, "Invalid key mgmt info\n");
 		}
 		offset++;
 	}
@@ -4053,7 +4104,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		err = brcmf_fil_bsscfg_int_set(ifp, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
-			brcmf_err("wme_bss_disable error %d\n", err);
+			brcmf_err(pub, "wme_bss_disable error %d\n", err);
 			goto exit;
 		}
 
@@ -4067,7 +4118,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 							&data[offset],
 							WPA_IE_MIN_OUI_LEN);
 			if (err < 0) {
-				brcmf_err("bip error %d\n", err);
+				brcmf_err(pub, "bip error %d\n", err);
 				goto exit;
 			}
 		}
@@ -4078,13 +4129,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", auth);
 	if (err < 0) {
-		brcmf_err("auth error %d\n", err);
+		brcmf_err(pub, "auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err < 0) {
-		brcmf_err("wsec error %d\n", err);
+		brcmf_err(pub, "wsec error %d\n", err);
 		goto exit;
 	}
 	/* Configure MFP, this needs to go after wsec otherwise the wsec command
@@ -4093,14 +4144,14 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MFP)) {
 		err = brcmf_fil_bsscfg_int_set(ifp, "mfp", mfp);
 		if (err < 0) {
-			brcmf_err("mfp error %d\n", err);
+			brcmf_err(pub, "mfp error %d\n", err);
 			goto exit;
 		}
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_auth);
 	if (err < 0) {
-		brcmf_err("wpa_auth error %d\n", err);
+		brcmf_err(pub, "wpa_auth error %d\n", err);
 		goto exit;
 	}
 
@@ -4127,7 +4178,7 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		vndrie = (struct brcmf_vs_tlv *)ie;
 		/* len should be bigger than OUI length + one */
 		if (vndrie->len < (VS_IE_FIXED_HDR_LEN - TLV_HDR_LEN + 1)) {
-			brcmf_err("invalid vndr ie. length is too small %d\n",
+			brcmf_err(NULL, "invalid vndr ie. length is too small %d\n",
 				  vndrie->len);
 			goto next;
 		}
@@ -4187,6 +4238,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
 	struct brcmf_if *ifp;
+	struct brcmf_pub *pub;
 	struct vif_saved_ie *saved_ie;
 	s32 err = 0;
 	u8  *iovar_ie_buf;
@@ -4207,6 +4259,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	if (!vif)
 		return -ENODEV;
 	ifp = vif->ifp;
+	pub = ifp->drvr;
 	saved_ie = &vif->saved_ie;
 
 	brcmf_dbg(TRACE, "bsscfgidx %d, pktflag : 0x%02X\n", ifp->bsscfgidx,
@@ -4238,13 +4291,13 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		break;
 	default:
 		err = -EPERM;
-		brcmf_err("not suitable type\n");
+		brcmf_err(pub, "not suitable type\n");
 		goto exit;
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
 		err = -ENOMEM;
-		brcmf_err("extra IE size too big\n");
+		brcmf_err(pub, "extra IE size too big\n");
 		goto exit;
 	}
 
@@ -4305,7 +4358,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			/* verify remained buf size before copy data */
 			if (remained_buf_len < (vndrie_info->vndrie.len +
 							VNDR_IE_VSIE_OFFSET)) {
-				brcmf_err("no space in mgmt_ie_buf: len left %d",
+				brcmf_err(pub, "no space in mgmt_ie_buf: len left %d",
 					  remained_buf_len);
 				break;
 			}
@@ -4337,7 +4390,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
-			brcmf_err("vndr ie set error : %d\n", err);
+			brcmf_err(pub, "vndr ie set error : %d\n", err);
 	}
 
 exit:
@@ -4365,13 +4418,14 @@ static s32
 brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 			struct cfg80211_beacon_data *beacon)
 {
+	struct brcmf_pub *pub = vif->ifp->drvr;
 	s32 err;
 
 	/* Set Beacon IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_BEACON_FLAG,
 				    beacon->tail, beacon->tail_len);
 	if (err) {
-		brcmf_err("Set Beacon IE Failed\n");
+		brcmf_err(pub, "Set Beacon IE Failed\n");
 		return err;
 	}
 	brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
@@ -4381,7 +4435,7 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 				    beacon->proberesp_ies,
 				    beacon->proberesp_ies_len);
 	if (err)
-		brcmf_err("Set Probe Resp IE Failed\n");
+		brcmf_err(pub, "Set Probe Resp IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
 
@@ -4394,6 +4448,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 {
 	s32 ie_offset;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	const struct brcmf_tlv *ssid_ie;
 	const struct brcmf_tlv *country_ie;
@@ -4490,7 +4545,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
 						    is_11d);
 			if (err < 0) {
-				brcmf_err("Regulatory Set Error, %d\n", err);
+				brcmf_err(pub, "Regulatory Set Error, %d\n",
+					  err);
 				goto exit;
 			}
 		}
@@ -4498,7 +4554,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 						    settings->beacon_interval);
 			if (err < 0) {
-				brcmf_err("Beacon Interval Set Error, %d\n",
+				brcmf_err(pub, "Beacon Interval Set Error, %d\n",
 					  err);
 				goto exit;
 			}
@@ -4507,7 +4563,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
 						    settings->dtim_period);
 			if (err < 0) {
-				brcmf_err("DTIM Interval Set Error, %d\n", err);
+				brcmf_err(pub, "DTIM Interval Set Error, %d\n",
+					  err);
 				goto exit;
 			}
 		}
@@ -4517,7 +4574,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		     !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB))) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 			if (err < 0) {
-				brcmf_err("BRCMF_C_DOWN error %d\n", err);
+				brcmf_err(pub, "BRCMF_C_DOWN error %d\n", err);
 				goto exit;
 			}
 			brcmf_fil_iovar_int_set(ifp, "apsta", 0);
@@ -4525,7 +4582,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 		if (err < 0) {
-			brcmf_err("SET INFRA error %d\n", err);
+			brcmf_err(pub, "SET INFRA error %d\n", err);
 			goto exit;
 		}
 	} else if (WARN_ON(supports_11d && (is_11d != ifp->vif->is_11d))) {
@@ -4541,7 +4598,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 		if (err < 0) {
-			brcmf_err("setting AP mode failed %d\n", err);
+			brcmf_err(pub, "setting AP mode failed %d\n", err);
 			goto exit;
 		}
 		if (!mbss) {
@@ -4550,14 +4607,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			 */
 			err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 			if (err < 0) {
-				brcmf_err("Set Channel failed: chspec=%d, %d\n",
+				brcmf_err(pub, "Set Channel failed: chspec=%d, %d\n",
 					  chanspec, err);
 				goto exit;
 			}
 		}
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0) {
-			brcmf_err("BRCMF_C_UP error (%d)\n", err);
+			brcmf_err(pub, "BRCMF_C_UP error (%d)\n", err);
 			goto exit;
 		}
 		/* On DOWN the firmware removes the WEP keys, reconfigure
@@ -4572,14 +4629,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0) {
-			brcmf_err("SET SSID error (%d)\n", err);
+			brcmf_err(pub, "SET SSID error (%d)\n", err);
 			goto exit;
 		}
 
 		if (settings->hidden_ssid) {
 			err = brcmf_fil_iovar_int_set(ifp, "closednet", 1);
 			if (err) {
-				brcmf_err("closednet error (%d)\n", err);
+				brcmf_err(pub, "closednet error (%d)\n", err);
 				goto exit;
 			}
 		}
@@ -4588,14 +4645,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	} else if (dev_role == NL80211_IFTYPE_P2P_GO) {
 		err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 		if (err < 0) {
-			brcmf_err("Set Channel failed: chspec=%d, %d\n",
+			brcmf_err(pub, "Set Channel failed: chspec=%d, %d\n",
 				  chanspec, err);
 			goto exit;
 		}
 		err = brcmf_fil_bsscfg_data_set(ifp, "ssid", &ssid_le,
 						sizeof(ssid_le));
 		if (err < 0) {
-			brcmf_err("setting ssid failed %d\n", err);
+			brcmf_err(pub, "setting ssid failed %d\n", err);
 			goto exit;
 		}
 		bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
@@ -4603,7 +4660,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0) {
-			brcmf_err("bss_enable config failed %d\n", err);
+			brcmf_err(pub, "bss_enable config failed %d\n", err);
 			goto exit;
 		}
 
@@ -4627,6 +4684,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
 	struct brcmf_join_params join_params;
@@ -4651,16 +4709,16 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0)
-			brcmf_err("SET SSID error (%d)\n", err);
+			brcmf_err(pub, "SET SSID error (%d)\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 		if (err < 0)
-			brcmf_err("BRCMF_C_DOWN error %d\n", err);
+			brcmf_err(pub, "BRCMF_C_DOWN error %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0)
-			brcmf_err("setting AP mode failed %d\n", err);
+			brcmf_err(pub, "setting AP mode failed %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 0);
 		if (err < 0)
-			brcmf_err("setting INFRA mode failed %d\n", err);
+			brcmf_err(pub, "setting INFRA mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
@@ -4668,7 +4726,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Bring device back up so it can be used again */
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
-			brcmf_err("BRCMF_C_UP error %d\n", err);
+			brcmf_err(pub, "BRCMF_C_UP error %d\n", err);
 
 		brcmf_vif_clear_mgmt_ies(ifp->vif);
 	} else {
@@ -4677,7 +4735,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0)
-			brcmf_err("bss_enable config failed %d\n", err);
+			brcmf_err(pub, "bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ifp, 1);
 	brcmf_configure_arp_nd_offload(ifp, true);
@@ -4706,6 +4764,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 			   struct station_del_parameters *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -4725,7 +4784,8 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
-		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
+		brcmf_err(pub, "SCB_DEAUTHENTICATE_FOR_REASON failed %d\n",
+			  err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -4736,6 +4796,7 @@ brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 			      const u8 *mac, struct station_parameters *params)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err;
 
 	brcmf_dbg(TRACE, "Enter, MAC %pM, mask 0x%04x set 0x%04x\n", mac,
@@ -4755,7 +4816,7 @@ brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SCB_DEAUTHORIZE,
 					     (void *)mac, ETH_ALEN);
 	if (err < 0)
-		brcmf_err("Setting SCB (de-)authorize failed, %d\n", err);
+		brcmf_err(pub, "Setting SCB (de-)authorize failed, %d\n", err);
 
 	return err;
 }
@@ -4784,6 +4845,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		       struct cfg80211_mgmt_tx_params *params, u64 *cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct ieee80211_channel *chan = params->chan;
 	const u8 *buf = params->buf;
 	size_t len = params->len;
@@ -4805,7 +4867,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
-		brcmf_err("Driver only allows MGMT packet type\n");
+		brcmf_err(pub, "Driver only allows MGMT packet type\n");
 		return -EPERM;
 	}
 
@@ -4837,7 +4899,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
 		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
 		if (af_params == NULL) {
-			brcmf_err("unable to allocate frame\n");
+			brcmf_err(pub, "unable to allocate frame\n");
 			err = -ENOMEM;
 			goto exit;
 		}
@@ -4888,6 +4950,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					u64 cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	int err = 0;
 
@@ -4895,7 +4958,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 	vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (vif == NULL) {
-		brcmf_err("No p2p device available for probe response\n");
+		brcmf_err(pub, "No p2p device available for probe response\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -4909,6 +4972,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 				      struct cfg80211_chan_def *chandef)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct net_device *ndev = wdev->netdev;
 	struct brcmf_if *ifp;
 	struct brcmu_chan ch;
@@ -4923,7 +4987,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
 	if (err) {
-		brcmf_err("chanspec failed (%d)\n", err);
+		brcmf_err(pub, "chanspec failed (%d)\n", err);
 		return err;
 	}
 
@@ -5035,7 +5099,7 @@ static int brcmf_convert_nl80211_tdls_oper(enum nl80211_tdls_operation oper)
 		ret = BRCMF_TDLS_MANUAL_EP_DELETE;
 		break;
 	default:
-		brcmf_err("unsupported operation: %d\n", oper);
+		brcmf_err(NULL, "unsupported operation: %d\n", oper);
 		ret = -EOPNOTSUPP;
 	}
 	return ret;
@@ -5062,7 +5126,8 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	ret = brcmf_fil_iovar_data_set(ifp, "tdls_endpoint",
 				       &info, sizeof(info));
 	if (ret < 0)
-		brcmf_err("tdls_endpoint iovar failed: ret=%d\n", ret);
+		brcmf_err(ifp->drvr, "tdls_endpoint iovar failed: ret=%d\n",
+			  ret);
 
 	return ret;
 }
@@ -5083,7 +5148,7 @@ brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		brcmf_err("Set Assoc REQ IE Failed\n");
+		brcmf_err(ifp->drvr, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -5096,6 +5161,7 @@ brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
 			      struct cfg80211_gtk_rekey_data *gtk)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_gtk_keyinfo_le gtk_le;
 	int ret;
 
@@ -5109,7 +5175,7 @@ brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
 	ret = brcmf_fil_iovar_data_set(ifp, "gtk_key_info", &gtk_le,
 				       sizeof(gtk_le));
 	if (ret < 0)
-		brcmf_err("gtk_key_info iovar failed: ret=%d\n", ret);
+		brcmf_err(pub, "gtk_key_info iovar failed: ret=%d\n", ret);
 
 	return ret;
 }
@@ -5276,6 +5342,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 {
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
+	struct brcmf_pub *pub = cfg->pub;
 	u32 req_len;
 	u32 resp_len;
 	s32 err = 0;
@@ -5285,7 +5352,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "assoc_info",
 				       cfg->extra_buf, WL_ASSOC_INFO_MAX);
 	if (err) {
-		brcmf_err("could not get assoc info (%d)\n", err);
+		brcmf_err(pub, "could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info =
@@ -5297,7 +5364,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			brcmf_err("could not get assoc req (%d)\n", err);
+			brcmf_err(pub, "could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
@@ -5313,7 +5380,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			brcmf_err("could not get assoc resp (%d)\n", err);
+			brcmf_err(pub, "could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
@@ -5432,6 +5499,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_pub *pub = cfg->pub;
 	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
@@ -5450,7 +5518,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
 		memset(&sinfo, 0, sizeof(sinfo));
 		if (!data) {
-			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
+			brcmf_err(pub, "No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
 		}
 		sinfo.assoc_req_ies = data;
@@ -5731,6 +5799,7 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 
 static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err;
 	u32 bcn_timeout;
 	__le32 roamtrigger[2];
@@ -5743,7 +5812,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON;
 	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 	if (err) {
-		brcmf_err("bcn_timeout error (%d)\n", err);
+		brcmf_err(pub, "bcn_timeout error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5755,7 +5824,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off",
 				      ifp->drvr->settings->roamoff);
 	if (err) {
-		brcmf_err("roam_off error (%d)\n", err);
+		brcmf_err(pub, "roam_off error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5764,7 +5833,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
-		brcmf_err("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
+		brcmf_err(pub, "WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5773,7 +5842,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
-		brcmf_err("WLC_SET_ROAM_DELTA error (%d)\n", err);
+		brcmf_err(pub, "WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5784,25 +5853,26 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 static s32
 brcmf_dongle_scantime(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	s32 err = 0;
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_err("Scan assoc time error (%d)\n", err);
+		brcmf_err(pub, "Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_err("Scan unassoc time error (%d)\n", err);
+		brcmf_err(pub, "Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 				    BRCMF_SCAN_PASSIVE_TIME);
 	if (err) {
-		brcmf_err("Scan passive time error (%d)\n", err);
+		brcmf_err(pub, "Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -5835,6 +5905,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 				    u32 bw_cap[])
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_pub *pub = ifp->drvr;
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *channel;
 	struct wiphy *wiphy;
@@ -5856,7 +5927,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 				       BRCMF_DCMD_MEDLEN);
 	if (err) {
-		brcmf_err("get chanspecs error (%d)\n", err);
+		brcmf_err(pub, "get chanspecs error (%d)\n", err);
 		goto fail_pbuf;
 	}
 
@@ -5880,7 +5951,8 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
 			band = wiphy->bands[NL80211_BAND_5GHZ];
 		} else {
-			brcmf_err("Invalid channel Spec. 0x%x.\n", ch.chspec);
+			brcmf_err(pub, "Invalid channel Spec. 0x%x.\n",
+				  ch.chspec);
 			continue;
 		}
 		if (!band)
@@ -5903,7 +5975,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			/* It seems firmware supports some channel we never
 			 * considered. Something new in IEEE standard?
 			 */
-			brcmf_err("Ignoring unexpected firmware channel %d\n",
+			brcmf_err(pub, "Ignoring unexpected firmware channel %d\n",
 				  ch.control_ch_num);
 			continue;
 		}
@@ -5947,6 +6019,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_pub *pub = cfg->pub;
 	struct ieee80211_supported_band *band;
 	struct brcmf_fil_bwcap_le band_bwcap;
 	struct brcmf_chanspec_list *list;
@@ -5992,7 +6065,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 		err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 					       BRCMF_DCMD_MEDLEN);
 		if (err) {
-			brcmf_err("get chanspecs error (%d)\n", err);
+			brcmf_err(pub, "get chanspecs error (%d)\n", err);
 			kfree(pbuf);
 			return err;
 		}
@@ -6023,6 +6096,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 
 static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	u32 band, mimo_bwcap;
 	int err;
 
@@ -6058,7 +6132,7 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
 		break;
 	default:
-		brcmf_err("invalid mimo_bw_cap value\n");
+		brcmf_err(pub, "invalid mimo_bw_cap value\n");
 	}
 }
 
@@ -6134,6 +6208,7 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	u32 nmode = 0;
 	u32 vhtmode = 0;
@@ -6150,7 +6225,7 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
 	if (err) {
-		brcmf_err("nmode error (%d)\n", err);
+		brcmf_err(pub, "nmode error (%d)\n", err);
 	} else {
 		brcmf_get_bwcap(ifp, bw_cap);
 	}
@@ -6160,7 +6235,7 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
-		brcmf_err("rxchain error (%d)\n", err);
+		brcmf_err(pub, "rxchain error (%d)\n", err);
 		nchain = 1;
 	} else {
 		for (nchain = 0; rxchain; nchain++)
@@ -6170,7 +6245,7 @@ static int brcmf_setup_wiphybands(struct wiphy *wiphy)
 
 	err = brcmf_construct_chaninfo(cfg, bw_cap);
 	if (err) {
-		brcmf_err("brcmf_construct_chaninfo failed (%d)\n", err);
+		brcmf_err(pub, "brcmf_construct_chaninfo failed (%d)\n", err);
 		return err;
 	}
 
@@ -6381,7 +6456,7 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wowl = kmemdup(&brcmf_wowlan_support, sizeof(brcmf_wowlan_support),
 		       GFP_KERNEL);
 	if (!wowl) {
-		brcmf_err("only support basic wowlan features\n");
+		brcmf_err(cfg->pub, "only support basic wowlan features\n");
 		wiphy->wowlan = &brcmf_wowlan_support;
 		return;
 	}
@@ -6468,7 +6543,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BANDLIST, &bandlist,
 				     sizeof(bandlist));
 	if (err) {
-		brcmf_err("could not obtain band info: err=%d\n", err);
+		brcmf_err(drvr, "could not obtain band info: err=%d\n", err);
 		return err;
 	}
 	/* first entry in bandlist is number of bands */
@@ -6725,6 +6800,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 					struct regulatory_request *req)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_fil_country_le ccreq;
 	s32 err;
@@ -6733,7 +6809,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	/* ignore non-ISO3166 country codes */
 	for (i = 0; i < sizeof(req->alpha2); i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			brcmf_err("not a ISO3166 code (0x%02x 0x%02x)\n",
+			brcmf_err(pub, "not a ISO3166 code (0x%02x 0x%02x)\n",
 				  req->alpha2[0], req->alpha2[1]);
 			return;
 		}
@@ -6743,7 +6819,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_get(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		brcmf_err("Country code iovar returned err = %d\n", err);
+		brcmf_err(pub, "Country code iovar returned err = %d\n", err);
 		return;
 	}
 
@@ -6753,7 +6829,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		brcmf_err("Firmware rejected country setting\n");
+		brcmf_err(pub, "Firmware rejected country setting\n");
 		return;
 	}
 	brcmf_setup_wiphybands(wiphy);
@@ -6801,7 +6877,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	u16 *cap = NULL;
 
 	if (!ndev) {
-		brcmf_err("ndev is invalid\n");
+		brcmf_err(drvr, "ndev is invalid\n");
 		return NULL;
 	}
 
@@ -6816,7 +6892,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 #endif
 	wiphy = wiphy_new(ops, sizeof(struct brcmf_cfg80211_info));
 	if (!wiphy) {
-		brcmf_err("Could not allocate wiphy device\n");
+		brcmf_err(drvr, "Could not allocate wiphy device\n");
 		return NULL;
 	}
 	memcpy(wiphy->perm_addr, drvr->mac, ETH_ALEN);
@@ -6840,7 +6916,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = wl_init_priv(cfg);
 	if (err) {
-		brcmf_err("Failed to init iwm_priv (%d)\n", err);
+		brcmf_err(drvr, "Failed to init iwm_priv (%d)\n", err);
 		brcmf_free_vif(vif);
 		goto wiphy_out;
 	}
@@ -6849,7 +6925,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* determine d11 io type before wiphy setup */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
 	if (err) {
-		brcmf_err("Failed to get D11 version (%d)\n", err);
+		brcmf_err(drvr, "Failed to get D11 version (%d)\n", err);
 		goto priv_out;
 	}
 	cfg->d11inf.io_type = (u8)io_type;
@@ -6874,13 +6950,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	}
 	err = wiphy_register(wiphy);
 	if (err < 0) {
-		brcmf_err("Could not register wiphy device (%d)\n", err);
+		brcmf_err(drvr, "Could not register wiphy device (%d)\n", err);
 		goto priv_out;
 	}
 
 	err = brcmf_setup_wiphybands(wiphy);
 	if (err) {
-		brcmf_err("Setting wiphy bands failed (%d)\n", err);
+		brcmf_err(drvr, "Setting wiphy bands failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
@@ -6903,18 +6979,18 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	drvr->config = cfg;
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		brcmf_err("FWEH activation failed (%d)\n", err);
+		brcmf_err(drvr, "FWEH activation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
 	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
-		brcmf_err("P2P initialisation failed (%d)\n", err);
+		brcmf_err(drvr, "P2P initialisation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_btcoex_attach(cfg);
 	if (err) {
-		brcmf_err("BT-coex initialisation failed (%d)\n", err);
+		brcmf_err(drvr, "BT-coex initialisation failed (%d)\n", err);
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
 	}
@@ -6933,7 +7009,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* (re-) activate FWEH event handling */
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		brcmf_err("FWEH activation failed (%d)\n", err);
+		brcmf_err(drvr, "FWEH activation failed (%d)\n", err);
 		goto detach;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 05f22ff81d60..8ae44c3fcd85 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -313,7 +313,7 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core_priv *core,
 
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
 		if (val & SSB_TMSHIGH_BUSY)
-			brcmf_err("core state still busy\n");
+			brcmf_err(NULL, "core state still busy\n");
 
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
 		if (val & SSB_IDLOW_INITIATOR) {
@@ -526,12 +526,12 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 	}
 
 	if (!cpu_found) {
-		brcmf_err("CPU core not detected\n");
+		brcmf_err(NULL, "CPU core not detected\n");
 		return -ENXIO;
 	}
 	/* check RAM core presence for ARM CM3 core */
 	if (need_socram && !has_socram) {
-		brcmf_err("RAM core not provided with ARM CM3 core\n");
+		brcmf_err(NULL, "RAM core not provided with ARM CM3 core\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -691,7 +691,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_4366_CHIP_ID:
 		return 0x200000;
 	default:
-		brcmf_err("unknown chip: %s\n", ci->pub.name);
+		brcmf_err(NULL, "unknown chip: %s\n", ci->pub.name);
 		break;
 	}
 	return 0;
@@ -708,7 +708,7 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 		ci->pub.ramsize = brcmf_chip_tcm_ramsize(mem_core);
 		ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
 		if (!ci->pub.rambase) {
-			brcmf_err("RAM base not provided with ARM CR4 core\n");
+			brcmf_err(NULL, "RAM base not provided with ARM CR4 core\n");
 			return -EINVAL;
 		}
 	} else {
@@ -719,14 +719,14 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 			ci->pub.ramsize = brcmf_chip_sysmem_ramsize(mem_core);
 			ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
 			if (!ci->pub.rambase) {
-				brcmf_err("RAM base not provided with ARM CA7 core\n");
+				brcmf_err(NULL, "RAM base not provided with ARM CA7 core\n");
 				return -EINVAL;
 			}
 		} else {
 			mem = brcmf_chip_get_core(&ci->pub,
 						  BCMA_CORE_INTERNAL_MEM);
 			if (!mem) {
-				brcmf_err("No memory cores found\n");
+				brcmf_err(NULL, "No memory cores found\n");
 				return -ENOMEM;
 			}
 			mem_core = container_of(mem, struct brcmf_core_priv,
@@ -740,12 +740,12 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 		  ci->pub.srsize, ci->pub.srsize);
 
 	if (!ci->pub.ramsize) {
-		brcmf_err("RAM size is undetermined\n");
+		brcmf_err(NULL, "RAM size is undetermined\n");
 		return -ENOMEM;
 	}
 
 	if (ci->pub.ramsize > BRCMF_CHIP_MAX_MEMSIZE) {
-		brcmf_err("RAM size is incorrect\n");
+		brcmf_err(NULL, "RAM size is incorrect\n");
 		return -ENOMEM;
 	}
 
@@ -929,7 +929,7 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 	if (socitype == SOCI_SB) {
 		if (ci->pub.chip != BRCM_CC_4329_CHIP_ID) {
-			brcmf_err("SB chip is not supported\n");
+			brcmf_err(NULL, "SB chip is not supported\n");
 			return -ENODEV;
 		}
 		ci->iscoreup = brcmf_chip_sb_iscoreup;
@@ -958,7 +958,7 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 		brcmf_chip_dmp_erom_scan(ci);
 	} else {
-		brcmf_err("chip backplane type %u is not supported\n",
+		brcmf_err(NULL, "chip backplane type %u is not supported\n",
 			  socitype);
 		return -ENODEV;
 	}
@@ -1007,7 +1007,7 @@ static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
 				     ARMCR4_BCMA_IOCTL_CPUHALT);
 		break;
 	default:
-		brcmf_err("unknown id: %u\n", id);
+		brcmf_err(NULL, "unknown id: %u\n", id);
 		break;
 	}
 }
@@ -1206,7 +1206,7 @@ static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
 
 	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
 	if (!brcmf_chip_iscoreup(core)) {
-		brcmf_err("SOCRAM core is down after reset?\n");
+		brcmf_err(NULL, "SOCRAM core is down after reset?\n");
 		return false;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index f8ce597c4781..c0ac7979c9ea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -86,6 +86,7 @@ struct brcmf_mp_global_t brcmf_mp_global;
 void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 {
 	struct brcmf_join_pref_params join_pref_params[2];
+	struct brcmf_pub *pub = ifp->drvr;
 	int err;
 
 	/* Setup join_pref to select target by RSSI (boost on 5GHz) */
@@ -101,13 +102,14 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
 	if (err)
-		brcmf_err("Set join_pref error (%d)\n", err);
+		brcmf_err(pub, "Set join_pref error (%d)\n", err);
 }
 
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_rev_info_le revinfo;
 	struct brcmf_rev_info *ri;
 	char *ptr;
@@ -117,7 +119,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
-		brcmf_err("Retreiving cur_etheraddr failed, %d\n", err);
+		brcmf_err(pub, "Retreiving cur_etheraddr failed, %d\n", err);
 		goto done;
 	}
 	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
@@ -126,7 +128,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 				     &revinfo, sizeof(revinfo));
 	ri = &ifp->drvr->revinfo;
 	if (err < 0) {
-		brcmf_err("retrieving revision info failed, %d\n", err);
+		brcmf_err(pub, "retrieving revision info failed, %d\n", err);
 	} else {
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
 		ri->deviceid = le32_to_cpu(revinfo.deviceid);
@@ -153,7 +155,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strcpy(buf, "ver");
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
-		brcmf_err("Retreiving version information failed, %d\n",
+		brcmf_err(pub, "Retreiving version information failed, %d\n",
 			  err);
 		goto done;
 	}
@@ -161,7 +163,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strsep(&ptr, "\n");
 
 	/* Print fw version info */
-	brcmf_err("Firmware version = %s\n", buf);
+	brcmf_err(pub, "Firmware version = %s\n", buf);
 
 	/* locate firmware version number for ethtool */
 	ptr = strrchr(buf, ' ') + 1;
@@ -170,7 +172,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	/* set mpc */
 	err = brcmf_fil_iovar_int_set(ifp, "mpc", 1);
 	if (err) {
-		brcmf_err("failed setting mpc\n");
+		brcmf_err(pub, "failed setting mpc\n");
 		goto done;
 	}
 
@@ -180,14 +182,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Get event_msgs error (%d)\n", err);
+		brcmf_err(pub, "Get event_msgs error (%d)\n", err);
 		goto done;
 	}
 	setbit(eventmask, BRCMF_E_IF);
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Set event_msgs error (%d)\n", err);
+		brcmf_err(pub, "Set event_msgs error (%d)\n", err);
 		goto done;
 	}
 
@@ -195,7 +197,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_DEFAULT_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+		brcmf_err(pub, "BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
@@ -204,7 +206,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_DEFAULT_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+		brcmf_err(pub, "BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
 			  err);
 		goto done;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b73a55b00fa7..44f225b4a47d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -59,7 +59,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 	s32 bsscfgidx;
 
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("ifidx %d out of range\n", ifidx);
+		brcmf_err(drvr, "ifidx %d out of range\n", ifidx);
 		return NULL;
 	}
 
@@ -74,6 +74,7 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
+	struct brcmf_pub *pub;
 	struct net_device *ndev;
 	struct netdev_hw_addr *ha;
 	u32 cmd_value, cnt;
@@ -83,6 +84,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	s32 err;
 
 	ifp = container_of(work, struct brcmf_if, multicast_work);
+	pub = ifp->drvr;
 
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -113,7 +115,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	err = brcmf_fil_iovar_data_set(ifp, "mcast_list", buf, buflen);
 	if (err < 0) {
-		brcmf_err("Setting mcast_list failed, %d\n", err);
+		brcmf_err(pub, "Setting mcast_list failed, %d\n", err);
 		cmd_value = cnt ? true : cmd_value;
 	}
 
@@ -126,13 +128,13 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	 */
 	err = brcmf_fil_iovar_int_set(ifp, "allmulti", cmd_value);
 	if (err < 0)
-		brcmf_err("Setting allmulti failed, %d\n", err);
+		brcmf_err(pub, "Setting allmulti failed, %d\n", err);
 
 	/*Finally, pick up the PROMISC flag */
 	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
 	if (err < 0)
-		brcmf_err("Setting BRCMF_C_SET_PROMISC failed, %d\n",
+		brcmf_err(pub, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
 			  err);
 }
 
@@ -156,7 +158,7 @@ static void _brcmf_update_ndtable(struct work_struct *work)
 					       &ifp->ipv6_addr_tbl[i],
 					       sizeof(struct in6_addr));
 		if (ret)
-			brcmf_err("add nd ip err %d\n", ret);
+			brcmf_err(ifp->drvr, "add nd ip err %d\n", ret);
 	}
 }
 #else
@@ -176,7 +178,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", sa->sa_data,
 				       ETH_ALEN);
 	if (err < 0) {
-		brcmf_err("Setting cur_etheraddr failed, %d\n", err);
+		brcmf_err(ifp->drvr, "Setting cur_etheraddr failed, %d\n", err);
 	} else {
 		brcmf_dbg(TRACE, "updated to %pM\n", sa->sa_data);
 		memcpy(ifp->mac_addr, sa->sa_data, ETH_ALEN);
@@ -204,7 +206,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("xmit rejected state=%d\n", drvr->bus_if->state);
+		brcmf_err(drvr, "xmit rejected state=%d\n",
+			  drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
 		ret = -ENODEV;
@@ -222,7 +225,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
-			brcmf_err("%s: skb_realloc_headroom failed\n",
+			brcmf_err(drvr, "%s: skb_realloc_headroom failed\n",
 				  brcmf_ifname(ifp));
 			ret = -ENOMEM;
 			goto done;
@@ -466,7 +469,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("failed bus is not ready\n");
+		brcmf_err(drvr, "failed bus is not ready\n");
 		return -EAGAIN;
 	}
 
@@ -480,7 +483,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		ndev->features &= ~NETIF_F_IP_CSUM;
 
 	if (brcmf_cfg80211_up(ndev)) {
-		brcmf_err("failed to bring up cfg80211\n");
+		brcmf_err(drvr, "failed to bring up cfg80211\n");
 		return -EIO;
 	}
 
@@ -525,7 +528,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	else
 		err = register_netdev(ndev);
 	if (err != 0) {
-		brcmf_err("couldn't register the net device\n");
+		brcmf_err(drvr, "couldn't register the net device\n");
 		goto fail;
 	}
 
@@ -613,7 +616,7 @@ static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
 	if (register_netdev(ndev) != 0) {
-		brcmf_err("couldn't register the p2p net device\n");
+		brcmf_err(ifp->drvr, "couldn't register the p2p net device\n");
 		goto fail;
 	}
 
@@ -643,7 +646,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 	 */
 	if (ifp) {
 		if (ifidx) {
-			brcmf_err("ERROR: netdev:%s already exists\n",
+			brcmf_err(drvr, "ERROR: netdev:%s already exists\n",
 				  ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
 			brcmf_net_detach(ifp->ndev, false);
@@ -702,7 +705,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 	ifp = drvr->iflist[bsscfgidx];
 	drvr->iflist[bsscfgidx] = NULL;
 	if (!ifp) {
-		brcmf_err("Null interface, bsscfgidx=%d\n", bsscfgidx);
+		brcmf_err(drvr, "Null interface, bsscfgidx=%d\n", bsscfgidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", bsscfgidx,
@@ -787,7 +790,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 	ret = brcmf_fil_iovar_data_get(ifp, "arp_hostip", addr_table,
 				       sizeof(addr_table));
 	if (ret) {
-		brcmf_err("fail to get arp ip table err:%d\n", ret);
+		brcmf_err(drvr, "fail to get arp ip table err:%d\n", ret);
 		return NOTIFY_OK;
 	}
 
@@ -804,7 +807,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip",
 				&ifa->ifa_address, sizeof(ifa->ifa_address));
 			if (ret)
-				brcmf_err("add arp ip err %d\n", ret);
+				brcmf_err(drvr, "add arp ip err %d\n", ret);
 		}
 		break;
 	case NETDEV_DOWN:
@@ -816,7 +819,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear",
 						       NULL, 0);
 			if (ret) {
-				brcmf_err("fail to clear arp ip table err:%d\n",
+				brcmf_err(drvr, "fail to clear arp ip table err:%d\n",
 					  ret);
 				return NOTIFY_OK;
 			}
@@ -827,7 +830,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 							       &addr_table[i],
 							       sizeof(addr_table[i]));
 				if (ret)
-					brcmf_err("add arp ip err %d\n",
+					brcmf_err(drvr, "add arp ip err %d\n",
 						  ret);
 			}
 		}
@@ -923,7 +926,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
-		brcmf_err("brcmf_prot_attach failed\n");
+		brcmf_err(drvr, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
@@ -1045,7 +1048,7 @@ int brcmf_bus_started(struct device *dev)
 	return 0;
 
 fail:
-	brcmf_err("failed: %d\n", ret);
+	brcmf_err(drvr, "failed: %d\n", ret);
 	if (drvr->config) {
 		brcmf_cfg80211_detach(drvr->config);
 		drvr->config = NULL;
@@ -1152,7 +1155,7 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	if (!err)
-		brcmf_err("Timed out waiting for no pending 802.1x packets\n");
+		brcmf_err(ifp->drvr, "Timed out waiting for no pending 802.1x packets\n");
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index f4644cf371c7..89793a0364b8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -58,16 +58,17 @@ static int brcmf_debug_psm_watchdog_notify(struct brcmf_if *ifp,
 					   const struct brcmf_event_msg *evtmsg,
 					   void *data)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	int err;
 
 	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
 
-	brcmf_err("PSM's watchdog has fired!\n");
+	brcmf_err(pub, "PSM's watchdog has fired!\n");
 
 	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
 					 evtmsg->datalen);
 	if (err)
-		brcmf_err("Failed to get memory dump, %d\n", err);
+		brcmf_err(pub, "Failed to get memory dump, %d\n", err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 99acc095c834..46cebe46f8a5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -52,12 +52,12 @@ void __brcmf_err(struct brcmf_pub *pub, const char *func, const char *fmt, ...);
 /* Macro for error messages. When debugging / tracing the driver all error
  * messages are important to us.
  */
-#define brcmf_err(fmt, ...)						\
+#define brcmf_err(pub, fmt, ...)					\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
 		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
 		    net_ratelimit())					\
-			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
+			__brcmf_err(pub, __func__, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index c7c1e9906500..d1c0a215ef6e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -578,7 +578,7 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 	}
 
 	if (i == table_size) {
-		brcmf_err("Unknown chipid %d [%d]\n", chip, chiprev);
+		brcmf_err(NULL, "Unknown chipid %d [%d]\n", chip, chiprev);
 		return -ENODEV;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index d0b738da2458..a101850e7ce3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -343,7 +343,7 @@ void brcmf_flowring_open(struct brcmf_flowring *flow, u16 flowid)
 
 	ring = flow->rings[flowid];
 	if (!ring) {
-		brcmf_err("Ring NULL, for flowid %d\n", flowid);
+		brcmf_err(NULL, "Ring NULL, for flowid %d\n", flowid);
 		return;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index c79306b57532..6d27c1026393 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -107,6 +107,7 @@ static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
 					 struct brcmf_event_msg *emsg,
 					 void *data)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmf_fweh_info *fweh;
 	int err = -EINVAL;
 
@@ -117,9 +118,9 @@ static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
 		if (fweh->evt_handler[code])
 			err = fweh->evt_handler[code](ifp, emsg, data);
 		else
-			brcmf_err("unhandled event %d ignored\n", code);
+			brcmf_err(pub, "unhandled event %d ignored\n", code);
 	} else {
-		brcmf_err("no interface object\n");
+		brcmf_err(pub, "no interface object\n");
 	}
 	return err;
 }
@@ -158,7 +159,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		return;
 	}
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("invalid interface index: %u\n", ifevent->ifidx);
+		brcmf_err(drvr, "invalid interface index: %u\n",
+			  ifevent->ifidx);
 		return;
 	}
 
@@ -258,7 +260,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 				   min_t(u32, emsg.datalen, 64),
 				   "event payload, len=%d\n", emsg.datalen);
 		if (emsg.datalen > event->datalen) {
-			brcmf_err("event invalid length header=%d, msg=%d\n",
+			brcmf_err(drvr, "event invalid length header=%d, msg=%d\n",
 				  event->datalen, emsg.datalen);
 			goto event_free;
 		}
@@ -276,7 +278,7 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
 						    event->data);
 		if (err) {
-			brcmf_err("event handler failed (%d)\n",
+			brcmf_err(drvr, "event handler failed (%d)\n",
 				  event->code);
 			err = 0;
 		}
@@ -344,7 +346,7 @@ int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
 			brcmf_fweh_handler_t handler)
 {
 	if (drvr->fweh.evt_handler[code]) {
-		brcmf_err("event code %d already registered\n", code);
+		brcmf_err(drvr, "event code %d already registered\n", code);
 		return -ENOSPC;
 	}
 	drvr->fweh.evt_handler[code] = handler;
@@ -393,7 +395,7 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs",
 				       eventmask, BRCMF_EVENTING_MASK_LEN);
 	if (err)
-		brcmf_err("Set event_msgs error (%d)\n", err);
+		brcmf_err(ifp->drvr, "Set event_msgs error (%d)\n", err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index f6a2df94dba7..b2adf08aee1e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -110,7 +110,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	s32 err;
 
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("bus is down. we have nothing to do.\n");
+		brcmf_err(drvr, "bus is down. we have nothing to do.\n");
 		return -EIO;
 	}
 
@@ -236,7 +236,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating iovar failed\n");
+		brcmf_err(drvr, "Creating iovar failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -262,7 +262,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating iovar failed\n");
+		brcmf_err(drvr, "Creating iovar failed\n");
 	}
 
 	brcmf_dbg(FIL, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
@@ -312,7 +312,7 @@ brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
 	iolen = prefixlen + namelen + sizeof(bsscfgidx_le) + datalen;
 
 	if (buflen < iolen) {
-		brcmf_err("buffer is too short\n");
+		brcmf_err(NULL, "buffer is too short\n");
 		return 0;
 	}
 
@@ -360,7 +360,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating bsscfg failed\n");
+		brcmf_err(drvr, "Creating bsscfg failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -386,7 +386,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating bsscfg failed\n");
+		brcmf_err(drvr, "Creating bsscfg failed\n");
 	}
 	brcmf_dbg(FIL, "ifidx=%d, bsscfgidx=%d, name=%s, len=%d\n", ifp->ifidx,
 		  ifp->bsscfgidx, name, len);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 5f1a5929cb30..f235d412df46 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -620,7 +620,7 @@ static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 		if (i == BRCMF_FWS_HANGER_MAXITEMS)
 			i = 0;
 	}
-	brcmf_err("all slots occupied\n");
+	brcmf_err(NULL, "all slots occupied\n");
 	h->failed_slotfind++;
 	i = BRCMF_FWS_HANGER_MAXITEMS;
 done:
@@ -634,7 +634,7 @@ static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
 		return -ENOENT;
 
 	if (h->items[slot_id].state != BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
-		brcmf_err("slot is not free\n");
+		brcmf_err(NULL, "slot is not free\n");
 		h->failed_to_push++;
 		return -EINVAL;
 	}
@@ -653,7 +653,7 @@ static inline int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 		return -ENOENT;
 
 	if (h->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
-		brcmf_err("entry not in use\n");
+		brcmf_err(NULL, "entry not in use\n");
 		h->failed_to_pop++;
 		return -EINVAL;
 	}
@@ -674,7 +674,7 @@ static int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 		return -ENOENT;
 
 	if (h->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
-		brcmf_err("entry not in use\n");
+		brcmf_err(NULL, "entry not in use\n");
 		return -EINVAL;
 	}
 
@@ -1180,13 +1180,13 @@ brcmf_fws_macdesc_use_req_credit(struct brcmf_fws_mac_descriptor *entry,
 		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
 		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 1);
 		if (entry->state != BRCMF_FWS_STATE_CLOSE)
-			brcmf_err("requested credit set while mac not closed!\n");
+			brcmf_err(NULL, "requested credit set while mac not closed!\n");
 	} else if (entry->requested_packet > 0) {
 		entry->requested_packet--;
 		brcmf_skb_if_flags_set_field(skb, REQUESTED, 1);
 		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
 		if (entry->state != BRCMF_FWS_STATE_CLOSE)
-			brcmf_err("requested packet set while mac not closed!\n");
+			brcmf_err(NULL, "requested packet set while mac not closed!\n");
 	} else {
 		brcmf_skb_if_flags_set_field(skb, REQUESTED, 0);
 		brcmf_skb_if_flags_set_field(skb, REQ_CREDIT, 0);
@@ -1253,6 +1253,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 	int prec = 2 * fifo;
 	u32 *qfull_stat = &fws->stats.delayq_full_error;
 	struct brcmf_fws_mac_descriptor *entry;
+	struct brcmf_pub *pub = fws->drvr;
 	struct pktq *pq;
 	struct sk_buff_head *queue;
 	struct sk_buff *p_head;
@@ -1262,7 +1263,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 
 	entry = brcmf_skbcb(p)->mac;
 	if (entry == NULL) {
-		brcmf_err("no mac descriptor found for skb %p\n", p);
+		brcmf_err(pub, "no mac descriptor found for skb %p\n", p);
 		return -ENOENT;
 	}
 
@@ -1452,6 +1453,7 @@ static int
 brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		      u32 genbit, u16 seq)
 {
+	struct brcmf_pub *pub = fws->drvr;
 	u32 fifo;
 	int ret;
 	bool remove_from_hanger = true;
@@ -1475,12 +1477,12 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	else if (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED)
 		fws->stats.txs_host_tossed++;
 	else
-		brcmf_err("unexpected txstatus\n");
+		brcmf_err(pub, "unexpected txstatus\n");
 
 	ret = brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
 				      remove_from_hanger);
 	if (ret != 0) {
-		brcmf_err("no packet in hanger slot: hslot=%d\n", hslot);
+		brcmf_err(pub, "no packet in hanger slot: hslot=%d\n", hslot);
 		return ret;
 	}
 
@@ -1591,7 +1593,8 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 	u8 *credits = data;
 
 	if (e->datalen < BRCMF_FWS_FIFO_COUNT) {
-		brcmf_err("event payload too small (%d)\n", e->datalen);
+		brcmf_err(ifp->drvr, "event payload too small (%d)\n",
+			  e->datalen);
 		return -EINVAL;
 	}
 	if (fws->creditmap_received)
@@ -1653,6 +1656,7 @@ static void brcmf_rxreorder_get_skb_list(struct brcmf_ampdu_rx_reorder *rfi,
 
 void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	u8 *reorder_data;
 	u8 flow_id, max_idx, cur_idx, exp_idx, end_idx;
 	struct brcmf_ampdu_rx_reorder *rfi;
@@ -1667,7 +1671,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
-		brcmf_err("invalid flags...so ignore this packet\n");
+		brcmf_err(pub, "invalid flags...so ignore this packet\n");
 		brcmf_netif_rx(ifp, pkt);
 		return;
 	}
@@ -1704,7 +1708,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 			  flow_id, max_idx);
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
-			brcmf_err("failed to alloc buffer\n");
+			brcmf_err(pub, "failed to alloc buffer\n");
 			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
@@ -1969,6 +1973,7 @@ static u8 brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 				   struct sk_buff *skb, int fifo)
 {
+	struct brcmf_pub *pub = fws->drvr;
 	struct brcmf_fws_mac_descriptor *entry;
 	struct sk_buff *pktout;
 	int qidx, hslot;
@@ -1982,11 +1987,11 @@ static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 
 		pktout = brcmu_pktq_penq_head(&entry->psq, qidx, skb);
 		if (pktout == NULL) {
-			brcmf_err("%s queue %d full\n", entry->name, qidx);
+			brcmf_err(pub, "%s queue %d full\n", entry->name, qidx);
 			rc = -ENOSPC;
 		}
 	} else {
-		brcmf_err("%s entry removed\n", entry->name);
+		brcmf_err(pub, "%s entry removed\n", entry->name);
 		rc = -ENOENT;
 	}
 
@@ -2120,7 +2125,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 		brcmf_fws_schedule_deq(fws);
 	} else {
-		brcmf_err("drop skb: no hanger slot\n");
+		brcmf_err(drvr, "drop skb: no hanger slot\n");
 		brcmf_txfinalize(ifp, skb, false);
 		rc = -ENOMEM;
 	}
@@ -2339,7 +2344,7 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 
 	fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
 	if (fws->fws_wq == NULL) {
-		brcmf_err("workqueue creation failed\n");
+		brcmf_err(drvr, "workqueue creation failed\n");
 		rc = -EBADF;
 		goto fail;
 	}
@@ -2355,13 +2360,13 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
 				 brcmf_fws_notify_credit_map);
 	if (rc < 0) {
-		brcmf_err("register credit map handler failed\n");
+		brcmf_err(drvr, "register credit map handler failed\n");
 		goto fail;
 	}
 	rc = brcmf_fweh_register(drvr, BRCMF_E_BCMC_CREDIT_SUPPORT,
 				 brcmf_fws_notify_bcmc_credit_support);
 	if (rc < 0) {
-		brcmf_err("register bcmc credit handler failed\n");
+		brcmf_err(drvr, "register bcmc credit handler failed\n");
 		brcmf_fweh_unregister(drvr, BRCMF_E_FIFO_CREDIT_MAP);
 		goto fail;
 	}
@@ -2373,7 +2378,7 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	fws->fw_signals = true;
 	ifp = brcmf_get_ifp(drvr, 0);
 	if (brcmf_fil_iovar_int_set(ifp, "tlv", tlv)) {
-		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		brcmf_err(drvr, "failed to set bdcv2 tlv signaling\n");
 		fws->fcmode = BRCMF_FWS_FCMODE_NONE;
 		fws->fw_signals = false;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index d2c834c3b2fc..2227617555cd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -320,7 +320,7 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
 				   skb->len - data_offset, pktids->direction);
 
 	if (dma_mapping_error(dev, *physaddr)) {
-		brcmf_err("dma_map_single failed !!\n");
+		brcmf_err(NULL, "dma_map_single failed !!\n");
 		return -ENOMEM;
 	}
 
@@ -358,7 +358,7 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 	struct sk_buff *skb;
 
 	if (idx >= pktids->array_size) {
-		brcmf_err("Invalid packet id %d (max %d)\n", idx,
+		brcmf_err(NULL, "Invalid packet id %d (max %d)\n", idx,
 			  pktids->array_size);
 		return NULL;
 	}
@@ -371,7 +371,7 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 		pktid->allocated.counter = 0;
 		return skb;
 	} else {
-		brcmf_err("Invalid packet id %d (not in use)\n", idx);
+		brcmf_err(NULL, "Invalid packet id %d (not in use)\n", idx);
 	}
 
 	return NULL;
@@ -429,7 +429,7 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		brcmf_err(drvr, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		return -ENOMEM;
 	}
@@ -492,7 +492,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 
 	timeout = brcmf_msgbuf_ioctl_resp_wait(msgbuf);
 	if (!timeout) {
-		brcmf_err("Timeout on response for query command\n");
+		brcmf_err(drvr, "Timeout on response for query command\n");
 		return -EIO;
 	}
 
@@ -568,6 +568,7 @@ static u32
 brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_msgbuf_work_item *work)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_tx_flowring_create_req *create;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
@@ -583,7 +584,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				     &msgbuf->flowring_dma_handle[flowid],
 				     GFP_KERNEL);
 	if (!dma_buf) {
-		brcmf_err("dma_alloc_coherent failed\n");
+		brcmf_err(pub, "dma_alloc_coherent failed\n");
 		brcmf_flowring_delete(msgbuf->flow, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
 	}
@@ -596,7 +597,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		brcmf_err(pub, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
@@ -623,7 +624,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
 	if (err) {
-		brcmf_err("Failed to write commonring\n");
+		brcmf_err(pub, "Failed to write commonring\n");
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
 	}
@@ -682,6 +683,7 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	u32 count;
@@ -701,7 +703,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	while (brcmf_flowring_qlen(flow, flowid)) {
 		skb = brcmf_flowring_dequeue(flow, flowid);
 		if (skb == NULL) {
-			brcmf_err("No SKB, but qlen %d\n",
+			brcmf_err(pub, "No SKB, but qlen %d\n",
 				  brcmf_flowring_qlen(flow, flowid));
 			break;
 		}
@@ -710,7 +712,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 					     msgbuf->tx_pktids, skb, ETH_HLEN,
 					     &physaddr, &pktid)) {
 			brcmf_flowring_reinsert(flow, flowid, skb);
-			brcmf_err("No PKTID available !!\n");
+			brcmf_err(pub, "No PKTID available !!\n");
 			break;
 		}
 		ret_ptr = brcmf_commonring_reserve_for_write(commonring);
@@ -881,6 +883,7 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 
 static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	struct sk_buff *skb;
@@ -908,7 +911,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 		skb = brcmu_pkt_buf_get_skb(BRCMF_MSGBUF_MAX_PKT_SIZE);
 
 		if (skb == NULL) {
-			brcmf_err("Failed to alloc SKB\n");
+			brcmf_err(pub, "Failed to alloc SKB\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -918,7 +921,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 					     msgbuf->rx_pktids, skb, 0,
 					     &physaddr, &pktid)) {
 			dev_kfree_skb_any(skb);
-			brcmf_err("No PKTID available !!\n");
+			brcmf_err(pub, "No PKTID available !!\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -988,6 +991,7 @@ static u32
 brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 			     u32 count)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	struct sk_buff *skb;
@@ -1005,7 +1009,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 							      count,
 							      &alloced);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		brcmf_err(pub, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		return 0;
 	}
@@ -1017,7 +1021,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 		skb = brcmu_pkt_buf_get_skb(BRCMF_MSGBUF_MAX_PKT_SIZE);
 
 		if (skb == NULL) {
-			brcmf_err("Failed to alloc SKB\n");
+			brcmf_err(pub, "Failed to alloc SKB\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -1027,7 +1031,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 					     msgbuf->rx_pktids, skb, 0,
 					     &physaddr, &pktid)) {
 			dev_kfree_skb_any(skb);
-			brcmf_err("No PKTID available !!\n");
+			brcmf_err(pub, "No PKTID available !!\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -1079,6 +1083,7 @@ static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_rx_event *event;
 	u32 idx;
 	u16 buflen;
@@ -1105,7 +1110,7 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	ifp = brcmf_get_ifp(msgbuf->drvr, event->msg.ifidx);
 	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n",
+		brcmf_err(pub, "Received pkt for invalid ifidx %d\n",
 			  event->msg.ifidx);
 		goto exit;
 	}
@@ -1122,6 +1127,7 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 static void
 brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_rx_complete *rx_complete;
 	struct sk_buff *skb;
 	u16 data_offset;
@@ -1150,7 +1156,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
 	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n",
+		brcmf_err(pub, "Received pkt for invalid ifidx %d\n",
 			  rx_complete->msg.ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
@@ -1165,6 +1171,7 @@ static void
 brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_flowring_create_resp *flowring_create_resp;
 	u16 status;
 	u16 flowid;
@@ -1176,7 +1183,7 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	status =  le16_to_cpu(flowring_create_resp->compl_hdr.status);
 
 	if (status) {
-		brcmf_err("Flowring creation failed, code %d\n", status);
+		brcmf_err(pub, "Flowring creation failed, code %d\n", status);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return;
 	}
@@ -1193,6 +1200,7 @@ static void
 brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_flowring_delete_resp *flowring_delete_resp;
 	u16 status;
 	u16 flowid;
@@ -1204,7 +1212,7 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	status =  le16_to_cpu(flowring_delete_resp->compl_hdr.status);
 
 	if (status) {
-		brcmf_err("Flowring deletion failed, code %d\n", status);
+		brcmf_err(pub, "Flowring deletion failed, code %d\n", status);
 		brcmf_flowring_delete(msgbuf->flow, flowid);
 		return;
 	}
@@ -1217,6 +1225,7 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 
 static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_common_hdr *msg;
 
 	msg = (struct msgbuf_common_hdr *)buf;
@@ -1249,7 +1258,7 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 		brcmf_msgbuf_process_rx_complete(msgbuf, buf);
 		break;
 	default:
-		brcmf_err("Unsupported msgtype %d\n", msg->msgtype);
+		brcmf_err(pub, "Unsupported msgtype %d\n", msg->msgtype);
 		break;
 	}
 }
@@ -1322,6 +1331,7 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct brcmf_pub *pub = msgbuf->drvr;
 	struct msgbuf_tx_flowring_delete_req *delete;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
@@ -1332,7 +1342,7 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("FW unaware, flowring will be removed !!\n");
+		brcmf_err(pub, "FW unaware, flowring will be removed !!\n");
 		brcmf_commonring_unlock(commonring);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return;
@@ -1356,7 +1366,7 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
 	if (err) {
-		brcmf_err("Failed to submit RING_DELETE, flowring will be removed\n");
+		brcmf_err(pub, "Failed to submit RING_DELETE, flowring will be removed\n");
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 	}
 }
@@ -1426,7 +1436,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if_msgbuf = drvr->bus_if->msgbuf;
 
 	if (if_msgbuf->max_flowrings >= BRCMF_FLOWRING_HASHSIZE) {
-		brcmf_err("driver not configured for this many flowrings %d\n",
+		brcmf_err(drvr, "driver not configured for this many flowrings %d\n",
 			  if_msgbuf->max_flowrings);
 		if_msgbuf->max_flowrings = BRCMF_FLOWRING_HASHSIZE - 1;
 	}
@@ -1437,7 +1447,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 
 	msgbuf->txflow_wq = create_singlethread_workqueue("msgbuf_txflow");
 	if (msgbuf->txflow_wq == NULL) {
-		brcmf_err("workqueue creation failed\n");
+		brcmf_err(drvr, "workqueue creation failed\n");
 		goto fail;
 	}
 	INIT_WORK(&msgbuf->txflow_work, brcmf_msgbuf_txflow_worker);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index aee6e5937c41..9fa9da87e93a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -45,7 +45,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
-		brcmf_err("interrupt could not be mapped\n");
+		brcmf_err(NULL, "interrupt could not be mapped\n");
 		return;
 	}
 	irqf = irqd_get_trigger_type(irq_get_irq_data(irq));
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index de19c7c92bc6..206b13c02c2c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -450,7 +450,8 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 	ret = brcmf_fil_iovar_data_set(ifp, "p2p_da_override", p2p_mac,
 				       ETH_ALEN);
 	if (ret)
-		brcmf_err("failed to update device address ret %d\n", ret);
+		brcmf_err(ifp->drvr, "failed to update device address ret %d\n",
+			  ret);
 
 	return ret;
 }
@@ -572,13 +573,14 @@ static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
  */
 static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	s32 ret = 0;
 
 	brcmf_dbg(TRACE, "enter\n");
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (!vif) {
-		brcmf_err("P2P config device not available\n");
+		brcmf_err(pub, "P2P config device not available\n");
 		ret = -EPERM;
 		goto exit;
 	}
@@ -592,13 +594,13 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 	ret = brcmf_fil_iovar_int_set(vif->ifp, "p2p_disc", 1);
 	if (ret < 0) {
-		brcmf_err("set p2p_disc error\n");
+		brcmf_err(pub, "set p2p_disc error\n");
 		goto exit;
 	}
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	ret = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
 	if (ret < 0) {
-		brcmf_err("unable to set WL_P2P_DISC_ST_SCAN\n");
+		brcmf_err(pub, "unable to set WL_P2P_DISC_ST_SCAN\n");
 		goto exit;
 	}
 
@@ -610,7 +612,7 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 	 */
 	ret = brcmf_fil_bsscfg_int_set(vif->ifp, "wsec", AES_ENABLED);
 	if (ret < 0) {
-		brcmf_err("wsec error %d\n", ret);
+		brcmf_err(pub, "wsec error %d\n", ret);
 		goto exit;
 	}
 
@@ -632,6 +634,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 			   u16 chanspecs[], s32 search_state,
 			   enum p2p_bss_type bss_type)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	s32 ret = 0;
 	s32 memsize = offsetof(struct brcmf_p2p_scan_le,
 			       eparams.params_le.channel_list);
@@ -650,7 +653,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 
 	vif = p2p->bss_idx[bss_type].vif;
 	if (vif == NULL) {
-		brcmf_err("no vif for bss type %d\n", bss_type);
+		brcmf_err(pub, "no vif for bss type %d\n", bss_type);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -678,7 +681,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 		       BRCMF_P2P_WILDCARD_SSID_LEN);
 		break;
 	default:
-		brcmf_err(" invalid search state %d\n", search_state);
+		brcmf_err(pub, " invalid search state %d\n", search_state);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -765,6 +768,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			       struct cfg80211_scan_request *request)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_pub *pub = cfg->pub;
 	s32 err = 0;
 	s32 search_state = WL_P2P_DISC_ST_SCAN;
 	struct brcmf_cfg80211_vif *vif;
@@ -827,7 +831,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 	}
 exit:
 	if (err)
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(pub, "error (%d)\n", err);
 	return err;
 }
 
@@ -924,19 +928,20 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 static s32
 brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmu_chan ch;
 	s32 err = 0;
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (!vif) {
-		brcmf_err("Discovery is not set, so we have nothing to do\n");
+		brcmf_err(pub, "Discovery is not set, so we have nothing to do\n");
 		err = -EPERM;
 		goto exit;
 	}
 
 	if (test_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status)) {
-		brcmf_err("Previous LISTEN is not completed yet\n");
+		brcmf_err(pub, "Previous LISTEN is not completed yet\n");
 		/* WAR: prevent cookie mismatch in wpa_supplicant return OK */
 		goto exit;
 	}
@@ -1053,6 +1058,7 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
  */
 static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	s32 err;
 	u32 channel_cnt;
 	u16 *default_chan_list;
@@ -1068,7 +1074,7 @@ static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 	default_chan_list = kzalloc(channel_cnt * sizeof(*default_chan_list),
 				    GFP_KERNEL);
 	if (default_chan_list == NULL) {
-		brcmf_err("channel list allocation failed\n");
+		brcmf_err(pub, "channel list allocation failed\n");
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -1110,6 +1116,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 	struct brcmf_p2p_info *p2p = container_of(afx_hdl,
 						  struct brcmf_p2p_info,
 						  afx_hdl);
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	s32 err;
 
 	if (!afx_hdl->is_active)
@@ -1123,7 +1130,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
 	if (err) {
-		brcmf_err("ERROR occurred! value is (%d)\n", err);
+		brcmf_err(pub, "ERROR occurred! value is (%d)\n", err);
 		if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
 			     &p2p->status))
 			complete(&afx_hdl->act_frm_scan);
@@ -1349,6 +1356,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	struct brcmf_pub *pub = ifp->drvr;
 	struct wireless_dev *wdev;
 	u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
@@ -1417,7 +1425,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	mgmt_frame = kzalloc(offsetof(struct ieee80211_mgmt, u) +
 			     mgmt_frame_len, GFP_KERNEL);
 	if (!mgmt_frame) {
-		brcmf_err("No memory available for action frame\n");
+		brcmf_err(pub, "No memory available for action frame\n");
 		return -ENOMEM;
 	}
 	memcpy(mgmt_frame->da, ifp->mac_addr, ETH_ALEN);
@@ -1498,6 +1506,7 @@ int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
 static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 				     struct brcmf_fil_af_params_le *af_params)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 	s32 timeout = 0;
@@ -1512,7 +1521,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe", af_params,
 					sizeof(*af_params));
 	if (err) {
-		brcmf_err(" sending action frame has failed\n");
+		brcmf_err(pub, " sending action frame has failed\n");
 		goto exit;
 	}
 
@@ -1551,6 +1560,7 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 			       struct brcmf_config_af_params *config_af_params)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_p2p_pub_act_frame *act_frm;
 	s32 err = 0;
@@ -1629,7 +1639,7 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 		config_af_params->extra_listen = false;
 		break;
 	default:
-		brcmf_err("Unknown p2p pub act frame subtype: %d\n",
+		brcmf_err(pub, "Unknown p2p pub act frame subtype: %d\n",
 			  act_frm->subtype);
 		err = -EINVAL;
 	}
@@ -1648,6 +1658,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_fil_af_params_le *af_params)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_config_af_params config_af_params;
@@ -1687,7 +1698,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		if (brcmf_p2p_pub_af_tx(cfg, af_params, &config_af_params)) {
 			/* Just send unknown subtype frame with */
 			/* default parameters.                  */
-			brcmf_err("P2P Public action frame, unknown subtype.\n");
+			brcmf_err(pub, "P2P Public action frame, unknown subtype.\n");
 		}
 	} else if (brcmf_p2p_is_gas_action(action_frame->data,
 					   action_frame_len)) {
@@ -1709,7 +1720,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 			af_params->dwell_time =
 				cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
 		} else {
-			brcmf_err("Unknown action type: %d\n", action);
+			brcmf_err(pub, "Unknown action type: %d\n", action);
 			goto exit;
 		}
 	} else if (brcmf_p2p_is_p2p_action(action_frame->data,
@@ -1717,7 +1728,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		/* do not configure anything. it will be */
 		/* sent with a default configuration     */
 	} else {
-		brcmf_err("Unknown Frame: category 0x%x, action 0x%x\n",
+		brcmf_err(pub, "Unknown Frame: category 0x%x, action 0x%x\n",
 			  category, action);
 		return false;
 	}
@@ -1756,7 +1767,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 
 		if (brcmf_p2p_af_searching_channel(p2p) ==
 							P2P_INVALID_CHANNEL) {
-			brcmf_err("Couldn't find peer's channel.\n");
+			brcmf_err(pub, "Couldn't find peer's channel.\n");
 			goto exit;
 		}
 
@@ -1778,7 +1789,8 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		tx_retry++;
 	}
 	if (ack == false) {
-		brcmf_err("Failed to send Action Frame(retry %d)\n", tx_retry);
+		brcmf_err(pub, "Failed to send Action Frame(retry %d)\n",
+			  tx_retry);
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
 	}
 
@@ -1961,6 +1973,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		       enum brcmf_fil_p2p_if_types if_type)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_fil_p2p_if_le if_request;
 	s32 err;
@@ -1970,13 +1983,13 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 	if (!vif) {
-		brcmf_err("vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
+		brcmf_err(pub, "vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
 		return -EPERM;
 	}
 	brcmf_notify_escan_complete(cfg, vif->ifp, true, true);
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
 	if (!vif) {
-		brcmf_err("vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
+		brcmf_err(pub, "vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
 		return -EPERM;
 	}
 	brcmf_set_mpc(vif->ifp, 0);
@@ -1994,7 +2007,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_set(vif->ifp, "p2p_ifupd", &if_request,
 				       sizeof(if_request));
 	if (err) {
-		brcmf_err("p2p_ifupd FAILED, err=%d\n", err);
+		brcmf_err(pub, "p2p_ifupd FAILED, err=%d\n", err);
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		return err;
 	}
@@ -2002,7 +2015,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err)  {
-		brcmf_err("No BRCMF_E_IF_CHANGE event received\n");
+		brcmf_err(pub, "No BRCMF_E_IF_CHANGE event received\n");
 		return -EIO;
 	}
 
@@ -2065,6 +2078,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 						    struct wiphy *wiphy,
 						    u8 *addr)
 {
+	struct brcmf_pub *pub = p2p->cfg->pub;
 	struct brcmf_cfg80211_vif *p2p_vif;
 	struct brcmf_if *p2p_ifp;
 	struct brcmf_if *pri_ifp;
@@ -2076,7 +2090,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 
 	p2p_vif = brcmf_alloc_vif(p2p->cfg, NL80211_IFTYPE_P2P_DEVICE);
 	if (IS_ERR(p2p_vif)) {
-		brcmf_err("could not create discovery vif\n");
+		brcmf_err(pub, "could not create discovery vif\n");
 		return (struct wireless_dev *)p2p_vif;
 	}
 
@@ -2090,7 +2104,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* Initialize P2P Discovery in the firmware */
 	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 	if (err < 0) {
-		brcmf_err("set p2p_disc error\n");
+		brcmf_err(pub, "set p2p_disc error\n");
 		brcmf_fweh_p2pdev_setup(pri_ifp, false);
 		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 		goto fail;
@@ -2102,7 +2116,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 	brcmf_fweh_p2pdev_setup(pri_ifp, false);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(pub, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -2116,7 +2130,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* verify bsscfg index for P2P discovery */
 	err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bsscfgidx);
 	if (err < 0) {
-		brcmf_err("retrieving discover bsscfg index failed\n");
+		brcmf_err(pub, "retrieving discover bsscfg index failed\n");
 		goto fail;
 	}
 
@@ -2151,6 +2165,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	enum brcmf_fil_p2p_if_types iftype;
 	int err;
@@ -2191,7 +2206,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(pub, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -2199,7 +2214,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	/* interface created in firmware */
 	ifp = vif->ifp;
 	if (!ifp) {
-		brcmf_err("no if pointer provided\n");
+		brcmf_err(pub, "no if pointer provided\n");
 		err = -ENOENT;
 		goto fail;
 	}
@@ -2208,7 +2223,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	ifp->ndev->name_assign_type = name_assign_type;
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-		brcmf_err("Registering netdevice failed\n");
+		brcmf_err(pub, "Registering netdevice failed\n");
 		goto fail;
 	}
 
@@ -2360,6 +2375,7 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
  */
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 {
+	struct brcmf_pub *pub = cfg->pub;
 	struct brcmf_p2p_info *p2p;
 	struct brcmf_if *pri_ifp;
 	s32 err = 0;
@@ -2374,7 +2390,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 	if (p2pdev_forced) {
 		err_ptr = brcmf_p2p_create_p2pdev(p2p, NULL, NULL);
 		if (IS_ERR(err_ptr)) {
-			brcmf_err("P2P device creation failed.\n");
+			brcmf_err(pub, "P2P device creation failed.\n");
 			err = PTR_ERR(err_ptr);
 		}
 	} else {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 8a3c6e2e4b38..dd61fa0706eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -519,6 +519,7 @@ static void
 brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 {
 	const struct pci_dev *pdev = devinfo->pdev;
+	struct brcmf_pub *pub = devinfo->pub;
 	struct brcmf_core *core;
 	u32 bar0_win;
 
@@ -536,7 +537,7 @@ brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 			}
 		}
 	} else {
-		brcmf_err("Unsupported core selected %x\n", coreid);
+		brcmf_err(pub, "Unsupported core selected %x\n", coreid);
 	}
 }
 
@@ -839,7 +840,8 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 				 brcmf_pcie_isr_thread, IRQF_SHARED,
 				 "brcmf_pcie_intr", devinfo)) {
 		pci_disable_msi(pdev);
-		brcmf_err("Failed to request IRQ %d\n", pdev->irq);
+		brcmf_err(devinfo->pub, "Failed to request IRQ %d\n",
+			  pdev->irq);
 		return -EIO;
 	}
 	devinfo->irq_allocated = true;
@@ -869,7 +871,7 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 		count++;
 	}
 	if (devinfo->in_irq)
-		brcmf_err("Still in IRQ (processing) !!!\n");
+		brcmf_err(devinfo->pub, "Still in IRQ (processing) !!!\n");
 
 	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
 	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT, status);
@@ -1074,6 +1076,7 @@ static void brcmf_pcie_release_ringbuffers(struct brcmf_pciedev_info *devinfo)
 
 static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct brcmf_pcie_ringbuf *ring;
 	struct brcmf_pcie_ringbuf *rings;
 	u32 d2h_w_idx_ptr;
@@ -1226,7 +1229,7 @@ static int brcmf_pcie_init_ringbuffers(struct brcmf_pciedev_info *devinfo)
 	return 0;
 
 fail:
-	brcmf_err("Allocating ring buffers failed\n");
+	brcmf_err(pub, "Allocating ring buffers failed\n");
 	brcmf_pcie_release_ringbuffers(devinfo);
 	return -ENOMEM;
 }
@@ -1288,7 +1291,7 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
 	return 0;
 
 fail:
-	brcmf_err("Allocating scratch buffers failed\n");
+	brcmf_err(devinfo->pub, "Allocating scratch buffers failed\n");
 	brcmf_pcie_release_scratchbuffers(devinfo);
 	return -ENOMEM;
 }
@@ -1389,6 +1392,7 @@ static int
 brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 			       u32 sharedram_addr)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct brcmf_pcie_shared_info *shared;
 	u32 addr;
 
@@ -1400,7 +1404,8 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 	brcmf_dbg(PCIE, "PCIe protocol version %d\n", shared->version);
 	if ((shared->version > BRCMF_PCIE_MAX_SHARED_VERSION) ||
 	    (shared->version < BRCMF_PCIE_MIN_SHARED_VERSION)) {
-		brcmf_err("Unsupported PCIE version %d\n", shared->version);
+		brcmf_err(pub, "Unsupported PCIE version %d\n",
+			  shared->version);
 		return -EINVAL;
 	}
 
@@ -1442,6 +1447,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 					const struct firmware *fw, void *nvram,
 					u32 nvram_len)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	u32 sharedram_addr;
 	u32 sharedram_addr_written;
 	u32 loop_counter;
@@ -1496,7 +1502,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 		loop_counter--;
 	}
 	if (sharedram_addr == sharedram_addr_written) {
-		brcmf_err("FW failed to initialize\n");
+		brcmf_err(pub, "FW failed to initialize\n");
 		return -ENODEV;
 	}
 	brcmf_dbg(PCIE, "Shared RAM addr: 0x%08x\n", sharedram_addr);
@@ -1507,6 +1513,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 
 static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct pci_dev *pdev;
 	int err;
 	phys_addr_t  bar0_addr, bar1_addr;
@@ -1516,7 +1523,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		brcmf_err("pci_enable_device failed err=%d\n", err);
+		brcmf_err(pub, "pci_enable_device failed err=%d\n", err);
 		return err;
 	}
 
@@ -1529,7 +1536,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	/* read Bar-1 mapped memory range */
 	bar1_size = pci_resource_len(pdev, 2);
 	if ((bar1_size == 0) || (bar1_addr == 0)) {
-		brcmf_err("BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
+		brcmf_err(pub, "BAR1 Not enabled, device size=%ld, addr=%#016llx\n",
 			  bar1_size, (unsigned long long)bar1_addr);
 		return -EINVAL;
 	}
@@ -1538,7 +1545,7 @@ static int brcmf_pcie_get_resource(struct brcmf_pciedev_info *devinfo)
 	devinfo->tcm = ioremap_nocache(bar1_addr, bar1_size);
 
 	if (!devinfo->regs || !devinfo->tcm) {
-		brcmf_err("ioremap() failed (%p,%p)\n", devinfo->regs,
+		brcmf_err(pub, "ioremap() failed (%p,%p)\n", devinfo->regs,
 			  devinfo->tcm);
 		return -EINVAL;
 	}
@@ -1572,13 +1579,13 @@ static int brcmf_pcie_attach_bus(struct brcmf_pciedev_info *devinfo)
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(dev, devinfo->settings);
 	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
+		brcmf_err(NULL, "brcmf_attach failed\n");
 	} else {
 		devinfo->pub = bus->drvr;
 
 		ret = brcmf_bus_started(dev);
 		if (ret)
-			brcmf_err("dongle is not responding\n");
+			brcmf_err(devinfo->pub, "dongle is not responding\n");
 	}
 
 	return ret;
@@ -1807,7 +1814,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	kfree(bus->msgbuf);
 	kfree(bus);
 fail:
-	brcmf_err("failed %x:%x\n", pdev->vendor, pdev->device);
+	brcmf_err(NULL, "failed %x:%x\n", pdev->vendor, pdev->device);
 	brcmf_pcie_release_resource(devinfo);
 	if (devinfo->ci)
 		brcmf_chip_detach(devinfo->ci);
@@ -1881,7 +1888,7 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
-		brcmf_err("Timeout on response for entering D3 substate\n");
+		brcmf_err(devinfo->pub, "Timeout on response for entering D3 substate\n");
 		return -EIO;
 	}
 
@@ -1895,6 +1902,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 {
 	struct brcmf_pciedev_info *devinfo;
 	struct brcmf_bus *bus;
+	struct brcmf_pub *pub;
 	struct pci_dev *pdev;
 	int err;
 
@@ -1902,6 +1910,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 
 	bus = dev_get_drvdata(dev);
 	devinfo = bus->bus_priv.pcie->devinfo;
+	pub = devinfo->pub;
 	brcmf_dbg(PCIE, "Enter, dev=%p, bus=%p\n", dev, bus);
 
 	/* Check if device is still up and running, if so we are ready */
@@ -1925,7 +1934,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err("probe after resume failed, err=%d\n", err);
+		brcmf_err(pub, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
@@ -1993,7 +2002,8 @@ void brcmf_pcie_register(void)
 	brcmf_dbg(PCIE, "Enter\n");
 	err = pci_register_driver(&brcmf_pciedrvr);
 	if (err)
-		brcmf_err("PCIE driver registration failed, err=%d\n", err);
+		brcmf_err(NULL, "PCIE driver registration failed, err=%d\n",
+			  err);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 9a25e79a46cf..532cdcc0fbbd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -48,6 +48,7 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 			    u32 mscan, u32 bestn)
 {
 	struct brcmf_pno_param_le pfn_param;
+	struct brcmf_pub *pub = ifp->drvr;
 	u16 flags;
 	u32 pfnmem;
 	s32 err;
@@ -75,13 +76,13 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 		/* set bestn in firmware */
 		err = brcmf_fil_iovar_int_set(ifp, "pfnmem", pfnmem);
 		if (err < 0) {
-			brcmf_err("failed to set pfnmem\n");
+			brcmf_err(pub, "failed to set pfnmem\n");
 			goto exit;
 		}
 		/* get max mscan which the firmware supports */
 		err = brcmf_fil_iovar_int_get(ifp, "pfnmem", &pfnmem);
 		if (err < 0) {
-			brcmf_err("failed to get pfnmem\n");
+			brcmf_err(pub, "failed to get pfnmem\n");
 			goto exit;
 		}
 		mscan = min_t(u32, mscan, pfnmem);
@@ -95,7 +96,7 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
 				       sizeof(pfn_param));
 	if (err)
-		brcmf_err("pfn_set failed, err=%d\n", err);
+		brcmf_err(pub, "pfn_set failed, err=%d\n", err);
 
 exit:
 	return err;
@@ -105,6 +106,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, u8 *mac_addr,
 				u8 *mac_mask)
 {
 	struct brcmf_pno_macaddr_le pfn_mac;
+	struct brcmf_pub *pub = ifp->drvr;
 	int err, i;
 
 	pfn_mac.version = BRCMF_PFN_MACADDR_CFG_VER;
@@ -123,7 +125,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, u8 *mac_addr,
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
 				       sizeof(pfn_mac));
 	if (err)
-		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+		brcmf_err(pub, "pfn_macaddr failed, err=%d\n", err);
 
 	return err;
 }
@@ -165,6 +167,7 @@ static bool brcmf_is_ssid_active(struct cfg80211_ssid *ssid,
 
 int brcmf_pno_clean(struct brcmf_if *ifp)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	int ret;
 
 	/* Disable pfn */
@@ -174,7 +177,7 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 		ret = brcmf_fil_iovar_data_set(ifp, "pfnclear", NULL, 0);
 	}
 	if (ret < 0)
-		brcmf_err("failed code %d\n", ret);
+		brcmf_err(pub, "failed code %d\n", ret);
 
 	return ret;
 }
@@ -182,6 +185,7 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req)
 {
+	struct brcmf_pub *pub = ifp->drvr;
 	struct brcmu_d11inf *d11inf;
 	struct brcmf_pno_config_le pno_cfg;
 	struct cfg80211_ssid *ssid;
@@ -191,7 +195,7 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	/* clean up everything */
 	ret = brcmf_pno_clean(ifp);
 	if  (ret < 0) {
-		brcmf_err("failed error=%d\n", ret);
+		brcmf_err(pub, "failed error=%d\n", ret);
 		return ret;
 	}
 
@@ -223,7 +227,7 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	for (i = 0; i < req->n_match_sets; i++) {
 		ssid = &req->match_sets[i].ssid;
 		if (!ssid->ssid_len) {
-			brcmf_err("skip broadcast ssid\n");
+			brcmf_err(pub, "skip broadcast ssid\n");
 			continue;
 		}
 
@@ -236,7 +240,7 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	/* Enable the PNO */
 	ret = brcmf_fil_iovar_int_set(ifp, "pfn", 1);
 	if (ret < 0)
-		brcmf_err("PNO enable failed!! ret=%d\n", ret);
+		brcmf_err(pub, "PNO enable failed!! ret=%d\n", ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
index d26ff219ef66..a9a2ebb0a155 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
@@ -47,7 +47,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 		if (brcmf_proto_msgbuf_attach(drvr))
 			goto fail;
 	} else {
-		brcmf_err("Unsupported proto type %d\n",
+		brcmf_err(drvr, "Unsupported proto type %d\n",
 			  drvr->bus_if->proto_type);
 		goto fail;
 	}
@@ -55,7 +55,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL) ||
 	    (proto->configure_addr_mode == NULL) ||
 	    (proto->delete_peer == NULL) || (proto->add_tdls_peer == NULL)) {
-		brcmf_err("Not all proto handlers have been installed\n");
+		brcmf_err(drvr, "Not all proto handlers have been installed\n");
 		goto fail;
 	}
 	return 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 81a1e24852e0..a85f5cc2e1d7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -678,6 +678,7 @@ static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 static int
 brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u8 wr_val = 0, rd_val, cmp_val, bmask;
 	int err = 0;
 	int err_cnt = 0;
@@ -734,7 +735,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 			  rd_val, err);
 
 	if (try_cnt > MAX_KSO_ATTEMPTS)
-		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
+		brcmf_err(pub, "max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
 	return err;
 }
@@ -744,6 +745,7 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 /* Turn backplane clock on or off */
 static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int err;
 	u8 clkctl, clkreq, devctl;
 	unsigned long timeout;
@@ -765,7 +767,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 				  clkreq, &err);
 		if (err) {
-			brcmf_err("HT Avail request error: %d\n", err);
+			brcmf_err(pub, "HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -773,7 +775,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 		clkctl = brcmf_sdiod_regrb(bus->sdiodev,
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 		if (err) {
-			brcmf_err("HT Avail read error: %d\n", err);
+			brcmf_err(pub, "HT Avail read error: %d\n", err);
 			return -EBADE;
 		}
 
@@ -783,7 +785,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 			devctl = brcmf_sdiod_regrb(bus->sdiodev,
 						   SBSDIO_DEVICE_CTL, &err);
 			if (err) {
-				brcmf_err("Devctl error setting CA: %d\n",
+				brcmf_err(pub, "Devctl error setting CA: %d\n",
 					  err);
 				return -EBADE;
 			}
@@ -817,11 +819,11 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 				usleep_range(5000, 10000);
 		}
 		if (err) {
-			brcmf_err("HT Avail request error: %d\n", err);
+			brcmf_err(pub, "HT Avail request error: %d\n", err);
 			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			brcmf_err("HT Avail timeout (%d): clkctl 0x%02x\n",
+			brcmf_err(pub, "HT Avail timeout (%d): clkctl 0x%02x\n",
 				  PMU_MAX_TRANSITION_DLY, clkctl);
 			return -EBADE;
 		}
@@ -833,7 +835,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 #if defined(DEBUG)
 		if (!bus->alp_only) {
 			if (SBSDIO_ALPONLY(clkctl))
-				brcmf_err("HT Clock should be on\n");
+				brcmf_err(pub, "HT Clock should be on\n");
 		}
 #endif				/* defined (DEBUG) */
 
@@ -854,7 +856,7 @@ static int brcmf_sdio_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 				  clkreq, &err);
 		brcmf_dbg(SDIO, "CLKCTL: turned OFF\n");
 		if (err) {
-			brcmf_err("Failed access turning clock off: %d\n",
+			brcmf_err(pub, "Failed access turning clock off: %d\n",
 				  err);
 			return -EBADE;
 		}
@@ -878,6 +880,7 @@ static int brcmf_sdio_sdclk(struct brcmf_sdio *bus, bool on)
 /* Transition SD and backplane clock readiness */
 static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 {
+	struct brcmf_pub *pub = bus->pub;
 #ifdef DEBUG
 	uint oldstate = bus->clkstate;
 #endif				/* DEBUG */
@@ -904,7 +907,7 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 		else if (bus->clkstate == CLK_AVAIL)
 			brcmf_sdio_htclk(bus, false, false);
 		else
-			brcmf_err("request for %d -> %d\n",
+			brcmf_err(pub, "request for %d -> %d\n",
 				  bus->clkstate, target);
 		break;
 
@@ -926,6 +929,7 @@ static int brcmf_sdio_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 static int
 brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int err = 0;
 	u8 clkcsr;
 
@@ -955,7 +959,7 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 			err = brcmf_sdio_kso_control(bus, true);
 		}
 		if (err) {
-			brcmf_err("error while changing bus sleep state %d\n",
+			brcmf_err(pub, "error while changing bus sleep state %d\n",
 				  err);
 			goto done;
 		}
@@ -988,6 +992,7 @@ static inline bool brcmf_sdio_valid_shared_address(u32 addr)
 static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 				 struct sdpcm_shared *sh)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u32 addr = 0;
 	int rv;
 	u32 shaddr = 0;
@@ -1015,7 +1020,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	 */
 	addr = le32_to_cpu(addr_le);
 	if (!brcmf_sdio_valid_shared_address(addr)) {
-		brcmf_err("invalid sdpcm_shared address 0x%08X\n", addr);
+		brcmf_err(pub, "invalid sdpcm_shared address 0x%08X\n", addr);
 		rv = -EINVAL;
 		goto fail;
 	}
@@ -1040,7 +1045,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	sh->msgtrace_addr = le32_to_cpu(sh_le.msgtrace_addr);
 
 	if ((sh->flags & SDPCM_SHARED_VERSION_MASK) > SDPCM_SHARED_VERSION) {
-		brcmf_err("sdpcm shared version unsupported: dhd %d dongle %d\n",
+		brcmf_err(pub, "sdpcm shared version unsupported: dhd %d dongle %d\n",
 			  SDPCM_SHARED_VERSION,
 			  sh->flags & SDPCM_SHARED_VERSION_MASK);
 		return -EPROTO;
@@ -1048,7 +1053,7 @@ static int brcmf_sdio_readshared(struct brcmf_sdio *bus,
 	return 0;
 
 fail:
-	brcmf_err("unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
+	brcmf_err(pub, "unable to obtain sdpcm_shared info: rv=%d (addr=0x%x)\n",
 		  rv, addr);
 	sdio_release_host(bus->sdiodev->func[1]);
 	return rv;
@@ -1069,6 +1074,7 @@ static void brcmf_sdio_get_console_addr(struct brcmf_sdio *bus)
 
 static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u32 intstatus = 0;
 	u32 hmb_data;
 	u8 fcbits;
@@ -1090,7 +1096,7 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 		brcmf_dbg(SDIO, "Dongle reports NAK handled, expect rtx of %d\n",
 			  bus->rx_seq);
 		if (!bus->rxskip)
-			brcmf_err("unexpected NAKHANDLED!\n");
+			brcmf_err(pub, "unexpected NAKHANDLED!\n");
 
 		bus->rxskip = false;
 		intstatus |= I_HMB_FRAME_IND;
@@ -1104,7 +1110,7 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 		    (hmb_data & HMB_DATA_VERSION_MASK) >>
 		    HMB_DATA_VERSION_SHIFT;
 		if (bus->sdpcm_ver != SDPCM_PROT_VERSION)
-			brcmf_err("Version mismatch, dongle reports %d, "
+			brcmf_err(pub, "Version mismatch, dongle reports %d, "
 				  "expecting %d\n",
 				  bus->sdpcm_ver, SDPCM_PROT_VERSION);
 		else
@@ -1143,7 +1149,7 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
 			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
-		brcmf_err("Unknown mailbox data content: 0x%02x\n",
+		brcmf_err(pub, "Unknown mailbox data content: 0x%02x\n",
 			  hmb_data);
 
 	return intstatus;
@@ -1151,12 +1157,13 @@ static u32 brcmf_sdio_hostmail(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 {
+	struct brcmf_pub *pub = bus->pub;
 	uint retries = 0;
 	u16 lastrbc;
 	u8 hi, lo;
 	int err;
 
-	brcmf_err("%sterminate frame%s\n",
+	brcmf_err(pub, "%sterminate frame%s\n",
 		  abort ? "abort command, " : "",
 		  rtx ? ", send NAK" : "");
 
@@ -1179,14 +1186,14 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 			break;
 
 		if ((hi > (lastrbc >> 8)) && (lo > (lastrbc & 0x00ff))) {
-			brcmf_err("count growing: last 0x%04x now 0x%04x\n",
+			brcmf_err(pub, "count growing: last 0x%04x now 0x%04x\n",
 				  lastrbc, (hi << 8) + lo);
 		}
 		lastrbc = (hi << 8) + lo;
 	}
 
 	if (!retries)
-		brcmf_err("count never zeroed: last 0x%04x\n", lastrbc);
+		brcmf_err(pub, "count never zeroed: last 0x%04x\n", lastrbc);
 	else
 		brcmf_dbg(SDIO, "flush took %d iterations\n", 0xffff - retries);
 
@@ -1207,10 +1214,11 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
 {
 	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct brcmf_pub *pub = bus->pub;
 	u8 i, hi, lo;
 
 	/* On failure, abort the command and terminate the frame */
-	brcmf_err("sdio error, abort command and terminate frame\n");
+	brcmf_err(pub, "sdio error, abort command and terminate frame\n");
 	bus->sdcnt.tx_sderrs++;
 
 	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
@@ -1320,6 +1328,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 			      struct brcmf_sdio_hdrinfo *rd,
 			      enum brcmf_sdio_frmtype type)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u16 len, checksum;
 	u8 rx_seq, fc, tx_seq_max;
 	u32 swheader;
@@ -1335,22 +1344,22 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 		return -ENODATA;
 	}
 	if ((u16)(~(len ^ checksum))) {
-		brcmf_err("HW header checksum error\n");
+		brcmf_err(pub, "HW header checksum error\n");
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdio_rxfail(bus, false, false);
 		return -EIO;
 	}
 	if (len < SDPCM_HDRLEN) {
-		brcmf_err("HW header length error\n");
+		brcmf_err(pub, "HW header length error\n");
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER &&
 	    (roundup(len, bus->blocksize) != rd->len)) {
-		brcmf_err("HW superframe header length error\n");
+		brcmf_err(pub, "HW superframe header length error\n");
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && len > rd->len) {
-		brcmf_err("HW subframe header length error\n");
+		brcmf_err(pub, "HW subframe header length error\n");
 		return -EPROTO;
 	}
 	rd->len = len;
@@ -1359,7 +1368,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	header += SDPCM_HWHDR_LEN;
 	swheader = le32_to_cpu(*(__le32 *)header);
 	if (type == BRCMF_SDIO_FT_SUPER && SDPCM_GLOMDESC(header)) {
-		brcmf_err("Glom descriptor found in superframe head\n");
+		brcmf_err(pub, "Glom descriptor found in superframe head\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
@@ -1367,26 +1376,26 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	rd->channel = (swheader & SDPCM_CHANNEL_MASK) >> SDPCM_CHANNEL_SHIFT;
 	if (len > MAX_RX_DATASZ && rd->channel != SDPCM_CONTROL_CHANNEL &&
 	    type != BRCMF_SDIO_FT_SUPER) {
-		brcmf_err("HW header length too long\n");
+		brcmf_err(pub, "HW header length too long\n");
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdio_rxfail(bus, false, false);
 		rd->len = 0;
 		return -EPROTO;
 	}
 	if (type == BRCMF_SDIO_FT_SUPER && rd->channel != SDPCM_GLOM_CHANNEL) {
-		brcmf_err("Wrong channel for superframe\n");
+		brcmf_err(pub, "Wrong channel for superframe\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
 	if (type == BRCMF_SDIO_FT_SUB && rd->channel != SDPCM_DATA_CHANNEL &&
 	    rd->channel != SDPCM_EVENT_CHANNEL) {
-		brcmf_err("Wrong channel for subframe\n");
+		brcmf_err(pub, "Wrong channel for subframe\n");
 		rd->len = 0;
 		return -EINVAL;
 	}
 	rd->dat_offset = brcmf_sdio_getdatoffset(header);
 	if (rd->dat_offset < SDPCM_HDRLEN || rd->dat_offset > rd->len) {
-		brcmf_err("seq %d: bad data offset\n", rx_seq);
+		brcmf_err(pub, "seq %d: bad data offset\n", rx_seq);
 		bus->sdcnt.rx_badhdr++;
 		brcmf_sdio_rxfail(bus, false, false);
 		rd->len = 0;
@@ -1404,7 +1413,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	if (rd->len_nxtfrm << 4 > MAX_RX_DATASZ) {
 		/* only warm for NON glom packet */
 		if (rd->channel != SDPCM_GLOM_CHANNEL)
-			brcmf_err("seq %d: next length error\n", rx_seq);
+			brcmf_err(pub, "seq %d: next length error\n", rx_seq);
 		rd->len_nxtfrm = 0;
 	}
 	swheader = le32_to_cpu(*(__le32 *)(header + 4));
@@ -1419,7 +1428,7 @@ static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 	}
 	tx_seq_max = (swheader & SDPCM_WINDOW_MASK) >> SDPCM_WINDOW_SHIFT;
 	if ((u8)(tx_seq_max - bus->tx_seq) > 0x40) {
-		brcmf_err("seq %d: max tx seq number error\n", rx_seq);
+		brcmf_err(pub, "seq %d: max tx seq number error\n", rx_seq);
 		tx_seq_max = bus->tx_seq + 2;
 	}
 	bus->tx_max = tx_seq_max;
@@ -1462,6 +1471,7 @@ static void brcmf_sdio_hdpack(struct brcmf_sdio *bus, u8 *header,
 
 static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
 	u16 sublen;
@@ -1484,7 +1494,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		dlen = (u16) (bus->glomd->len);
 		dptr = bus->glomd->data;
 		if (!dlen || (dlen & 1)) {
-			brcmf_err("bad glomd len(%d), ignore descriptor\n",
+			brcmf_err(pub, "bad glomd len(%d), ignore descriptor\n",
 				  dlen);
 			dlen = 0;
 		}
@@ -1496,13 +1506,13 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			dptr += sizeof(u16);
 			if ((sublen < SDPCM_HDRLEN) ||
 			    ((num == 0) && (sublen < (2 * SDPCM_HDRLEN)))) {
-				brcmf_err("descriptor len %d bad: %d\n",
+				brcmf_err(pub, "descriptor len %d bad: %d\n",
 					  num, sublen);
 				pnext = NULL;
 				break;
 			}
 			if (sublen % bus->sgentry_align) {
-				brcmf_err("sublen %d not multiple of %d\n",
+				brcmf_err(pub, "sublen %d not multiple of %d\n",
 					  sublen, bus->sgentry_align);
 			}
 			totlen += sublen;
@@ -1518,7 +1528,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			/* Allocate/chain packet for next subframe */
 			pnext = brcmu_pkt_buf_get_skb(sublen + bus->sgentry_align);
 			if (pnext == NULL) {
-				brcmf_err("bcm_pkt_buf_get_skb failed, num %d len %d\n",
+				brcmf_err(pub, "bcm_pkt_buf_get_skb failed, num %d len %d\n",
 					  num, sublen);
 				break;
 			}
@@ -1577,7 +1587,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		/* On failure, kill the superframe */
 		if (errcode < 0) {
-			brcmf_err("glom read of %d bytes failed: %d\n",
+			brcmf_err(pub, "glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
 			sdio_claim_host(bus->sdiodev->func[1]);
@@ -1706,6 +1716,7 @@ static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 static void
 brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 {
+	struct brcmf_pub *pub = bus->pub;
 	uint rdlen, pad;
 	u8 *buf = NULL, *rbuf;
 	int sdret;
@@ -1740,14 +1751,14 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 
 	/* Drop if the read is too big or it exceeds our maximum */
 	if ((rdlen + BRCMF_FIRSTREAD) > bus->sdiodev->bus_if->maxctl) {
-		brcmf_err("%d-byte control read exceeds %d-byte buffer\n",
+		brcmf_err(pub, "%d-byte control read exceeds %d-byte buffer\n",
 			  rdlen, bus->sdiodev->bus_if->maxctl);
 		brcmf_sdio_rxfail(bus, false, false);
 		goto done;
 	}
 
 	if ((len - doff) > bus->sdiodev->bus_if->maxctl) {
-		brcmf_err("%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
+		brcmf_err(pub, "%d-byte ctl frame (%d-byte ctl data) exceeds %d-byte limit\n",
 			  len, len - doff, bus->sdiodev->bus_if->maxctl);
 		bus->sdcnt.rx_toolong++;
 		brcmf_sdio_rxfail(bus, false, false);
@@ -1760,7 +1771,7 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
-		brcmf_err("read %d control bytes failed: %d\n",
+		brcmf_err(pub, "read %d control bytes failed: %d\n",
 			  rdlen, sdret);
 		bus->sdcnt.rxc_errors++;
 		brcmf_sdio_rxfail(bus, true, true);
@@ -1776,7 +1787,7 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	/* Point to valid data and indicate its length */
 	spin_lock_bh(&bus->rxctl_lock);
 	if (bus->rxctl) {
-		brcmf_err("last control frame is being processed.\n");
+		brcmf_err(pub, "last control frame is being processed.\n");
 		spin_unlock_bh(&bus->rxctl_lock);
 		vfree(buf);
 		goto done;
@@ -1806,6 +1817,7 @@ static void brcmf_sdio_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 
 static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 {
+	struct brcmf_pub *pub = bus->pub;
 	struct sk_buff *pkt;		/* Packet for event or data frames */
 	u16 pad;		/* Number of pad bytes to read */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
@@ -1843,7 +1855,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 						   bus->rxhdr, BRCMF_FIRSTREAD);
 			bus->sdcnt.f2rxhdrs++;
 			if (ret < 0) {
-				brcmf_err("RXHEADER FAILED: %d\n",
+				brcmf_err(pub, "RXHEADER FAILED: %d\n",
 					  ret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdio_rxfail(bus, true, true);
@@ -1887,7 +1899,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					    bus->head_align);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
-			brcmf_err("brcmu_pkt_buf_get_skb failed\n");
+			brcmf_err(pub, "brcmu_pkt_buf_get_skb failed\n");
 			brcmf_sdio_rxfail(bus, false,
 					    RETRYCHAN(rd->channel));
 			sdio_release_host(bus->sdiodev->func[1]);
@@ -1901,7 +1913,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		sdio_release_host(bus->sdiodev->func[1]);
 
 		if (ret < 0) {
-			brcmf_err("read %d bytes from channel %d failed: %d\n",
+			brcmf_err(pub, "read %d bytes from channel %d failed: %d\n",
 				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
 			sdio_claim_host(bus->sdiodev->func[1]);
@@ -1926,7 +1938,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			}
 			bus->sdcnt.rx_readahead_cnt++;
 			if (rd->len != roundup(rd_new.len, 16)) {
-				brcmf_err("frame length mismatch:read %d, should be %d\n",
+				brcmf_err(pub, "frame length mismatch:read %d, should be %d\n",
 					  rd->len,
 					  roundup(rd_new.len, 16) >> 4);
 				rd->len = 0;
@@ -1947,7 +1959,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 					   "RxHdr:\n");
 
 			if (rd_new.channel == SDPCM_CONTROL_CHANNEL) {
-				brcmf_err("readahead on control packet %d?\n",
+				brcmf_err(pub, "readahead on control packet %d?\n",
 					  rd_new.seq_num);
 				/* Force retry w/normal header read */
 				rd->len = 0;
@@ -1974,7 +1986,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 				skb_pull(pkt, SDPCM_HDRLEN);
 				bus->glomd = pkt;
 			} else {
-				brcmf_err("%s: glom superframe w/o "
+				brcmf_err(pub, "%s: glom superframe w/o "
 					  "descriptor!\n", __func__);
 				sdio_claim_host(bus->sdiodev->func[1]);
 				brcmf_sdio_rxfail(bus, false, false);
@@ -2405,6 +2417,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_pub *pub = bus->pub;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2432,7 +2445,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 			brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 					  (saveclk | SBSDIO_FORCE_HT), &err);
 		if (err)
-			brcmf_err("Failed to force clock for F2: err %d\n",
+			brcmf_err(pub, "Failed to force clock for F2: err %d\n",
 				  err);
 
 		/* Turn off the bus (F2), free any pending packets */
@@ -2509,6 +2522,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 
 static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u32 newstatus = 0;
 	unsigned long intstatus;
 	uint txlimit = bus->txbound;	/* Tx frames to send before resched */
@@ -2585,17 +2599,17 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	/* Generally don't ask for these, can get CRC errors... */
 	if (intstatus & I_WR_OOSYNC) {
-		brcmf_err("Dongle reports WR_OOSYNC\n");
+		brcmf_err(pub, "Dongle reports WR_OOSYNC\n");
 		intstatus &= ~I_WR_OOSYNC;
 	}
 
 	if (intstatus & I_RD_OOSYNC) {
-		brcmf_err("Dongle reports RD_OOSYNC\n");
+		brcmf_err(pub, "Dongle reports RD_OOSYNC\n");
 		intstatus &= ~I_RD_OOSYNC;
 	}
 
 	if (intstatus & I_SBINT) {
-		brcmf_err("Dongle reports SBINT\n");
+		brcmf_err(pub, "Dongle reports SBINT\n");
 		intstatus &= ~I_SBINT;
 	}
 
@@ -2645,7 +2659,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	}
 
 	if ((bus->sdiodev->state != BRCMF_SDIOD_DATA) || (err != 0)) {
-		brcmf_err("failed backplane access over SDIO, halting operation\n");
+		brcmf_err(pub, "failed backplane access over SDIO, halting operation\n");
 		atomic_set(&bus->intstatus, 0);
 		if (bus->ctrl_frame_stat) {
 			sdio_claim_host(bus->sdiodev->func[1]);
@@ -2705,14 +2719,14 @@ static bool brcmf_sdio_prec_enq(struct pktq *q, struct sk_buff *pkt, int prec)
 		/* Evict packet according to discard policy */
 		p = brcmu_pktq_pdeq_tail(q, eprec);
 		if (p == NULL)
-			brcmf_err("brcmu_pktq_pdeq_tail() failed\n");
+			brcmf_err(NULL, "brcmu_pktq_pdeq_tail() failed\n");
 		brcmu_pkt_buf_free_skb(p);
 	}
 
 	/* Enqueue */
 	p = brcmu_pktq_penq(q, prec, pkt);
 	if (p == NULL)
-		brcmf_err("brcmu_pktq_penq() failed\n");
+		brcmf_err(NULL, "brcmu_pktq_penq() failed\n");
 
 	return p != NULL;
 }
@@ -2724,6 +2738,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_pub *pub = bus->pub;
 
 	brcmf_dbg(TRACE, "Enter: pkt: data %p len %d\n", pkt->data, pkt->len);
 	if (sdiodev->state != BRCMF_SDIOD_DATA)
@@ -2746,7 +2761,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	*(u16 *)(pkt->cb) = 0;
 	if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec)) {
 		skb_pull(pkt, bus->tx_hdrlen);
-		brcmf_err("out of bus->txq !!!\n");
+		brcmf_err(pub, "out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
 		ret = 0;
@@ -3022,6 +3037,7 @@ static int brcmf_sdio_assert_info(struct seq_file *seq, struct brcmf_sdio *bus,
 
 static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int error;
 	struct sdpcm_shared sh;
 
@@ -3033,10 +3049,10 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 	if ((sh.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
 		brcmf_dbg(INFO, "firmware not built with -assert\n");
 	else if (sh.flags & SDPCM_SHARED_ASSERT)
-		brcmf_err("assertion in dongle\n");
+		brcmf_err(pub, "assertion in dongle\n");
 
 	if (sh.flags & SDPCM_SHARED_TRAP)
-		brcmf_err("firmware trap in dongle\n");
+		brcmf_err(pub, "firmware trap in dongle\n");
 
 	return 0;
 }
@@ -3148,6 +3164,7 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_pub *pub = bus->pub;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (sdiodev->state != BRCMF_SDIOD_DATA)
@@ -3170,7 +3187,7 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 		brcmf_dbg(CTL, "resumed on rxctl frame, got %d expected %d\n",
 			  rxlen, msglen);
 	} else if (timeleft == 0) {
-		brcmf_err("resumed on timeout\n");
+		brcmf_err(pub, "resumed on timeout\n");
 		brcmf_sdio_checkdied(bus);
 	} else if (pending) {
 		brcmf_dbg(CTL, "cancelled\n");
@@ -3193,6 +3210,7 @@ static bool
 brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
 			u8 *ram_data, uint ram_sz)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	char *ram_cmp;
 	int err;
 	bool ret = true;
@@ -3215,12 +3233,12 @@ brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
 		      ram_sz - offset;
 		err = brcmf_sdiod_ramrw(sdiodev, false, address, ram_cmp, len);
 		if (err) {
-			brcmf_err("error %d on reading %d membytes at 0x%08x\n",
+			brcmf_err(pub, "error %d on reading %d membytes at 0x%08x\n",
 				  err, len, address);
 			ret = false;
 			break;
 		} else if (memcmp(ram_cmp, &ram_data[offset], len)) {
-			brcmf_err("Downloaded RAM image is corrupted, block offset is %d, len is %d\n",
+			brcmf_err(pub, "Downloaded RAM image is corrupted, block offset is %d, len is %d\n",
 				  offset, len);
 			ret = false;
 			break;
@@ -3245,6 +3263,7 @@ brcmf_sdio_verifymemory(struct brcmf_sdio_dev *sdiodev, u32 ram_addr,
 static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 					 const struct firmware *fw)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int err;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3252,7 +3271,7 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 	err = brcmf_sdiod_ramrw(bus->sdiodev, true, bus->ci->rambase,
 				(u8 *)fw->data, fw->size);
 	if (err)
-		brcmf_err("error %d on writing %d membytes at 0x%08x\n",
+		brcmf_err(pub, "error %d on writing %d membytes at 0x%08x\n",
 			  err, (int)fw->size, bus->ci->rambase);
 	else if (!brcmf_sdio_verifymemory(bus->sdiodev, bus->ci->rambase,
 					  (u8 *)fw->data, fw->size))
@@ -3264,6 +3283,7 @@ static int brcmf_sdio_download_code_file(struct brcmf_sdio *bus,
 static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 				     void *vars, u32 varsz)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int address;
 	int err;
 
@@ -3272,7 +3292,7 @@ static int brcmf_sdio_download_nvram(struct brcmf_sdio *bus,
 	address = bus->ci->ramsize - varsz + bus->ci->rambase;
 	err = brcmf_sdiod_ramrw(bus->sdiodev, true, address, vars, varsz);
 	if (err)
-		brcmf_err("error %d on writing %d nvram bytes at 0x%08x\n",
+		brcmf_err(pub, "error %d on writing %d nvram bytes at 0x%08x\n",
 			  err, varsz, address);
 	else if (!brcmf_sdio_verifymemory(bus->sdiodev, address, vars, varsz))
 		err = -EIO;
@@ -3284,6 +3304,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 					const struct firmware *fw,
 					void *nvram, u32 nvlen)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int bcmerror;
 	u32 rstvec;
 
@@ -3296,7 +3317,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	bcmerror = brcmf_sdio_download_code_file(bus, fw);
 	release_firmware(fw);
 	if (bcmerror) {
-		brcmf_err("dongle image file download failed\n");
+		brcmf_err(pub, "dongle image file download failed\n");
 		brcmf_fw_nvram_free(nvram);
 		goto err;
 	}
@@ -3304,13 +3325,13 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	bcmerror = brcmf_sdio_download_nvram(bus, nvram, nvlen);
 	brcmf_fw_nvram_free(nvram);
 	if (bcmerror) {
-		brcmf_err("dongle nvram file download failed\n");
+		brcmf_err(pub, "dongle nvram file download failed\n");
 		goto err;
 	}
 
 	/* Take arm out of reset */
 	if (!brcmf_chip_set_active(bus->ci, rstvec)) {
-		brcmf_err("error getting out of ARM core reset\n");
+		brcmf_err(pub, "error getting out of ARM core reset\n");
 		goto err;
 	}
 
@@ -3322,6 +3343,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 
 static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
 	int err = 0;
 	u8 val;
 
@@ -3329,14 +3351,14 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 
 	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, &err);
 	if (err) {
-		brcmf_err("error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
+		brcmf_err(pub, "error reading SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
 	val |= 1 << SBSDIO_FUNC1_WCTRL_HTWAIT_SHIFT;
 	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_WAKEUPCTRL, val, &err);
 	if (err) {
-		brcmf_err("error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
+		brcmf_err(pub, "error writing SBSDIO_FUNC1_WAKEUPCTRL\n");
 		return;
 	}
 
@@ -3346,14 +3368,14 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 			   SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT),
 			  &err);
 	if (err) {
-		brcmf_err("error writing SDIO_CCCR_BRCM_CARDCAP\n");
+		brcmf_err(pub, "error writing SDIO_CCCR_BRCM_CARDCAP\n");
 		return;
 	}
 
 	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_CHIPCLKCSR,
 			  SBSDIO_FORCE_HT, &err);
 	if (err) {
-		brcmf_err("error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
+		brcmf_err(pub, "error writing SBSDIO_FUNC1_CHIPCLKCSR\n");
 		return;
 	}
 
@@ -3365,6 +3387,7 @@ static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 /* enable KSO bit */
 static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
 	u8 val;
 	int err = 0;
 
@@ -3376,7 +3399,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 
 	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
 	if (err) {
-		brcmf_err("error reading SBSDIO_FUNC1_SLEEPCSR\n");
+		brcmf_err(pub, "error reading SBSDIO_FUNC1_SLEEPCSR\n");
 		return err;
 	}
 
@@ -3386,7 +3409,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 				  val, &err);
 		if (err) {
-			brcmf_err("error writing SBSDIO_FUNC1_SLEEPCSR\n");
+			brcmf_err(pub, "error writing SBSDIO_FUNC1_SLEEPCSR\n");
 			return err;
 		}
 	}
@@ -3461,6 +3484,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_pub *pub = bus->pub;
 	int err;
 	int address;
 	int offset;
@@ -3477,7 +3501,7 @@ static int brcmf_sdio_bus_get_memdump(struct device *dev, void *data,
 		      mem_size - offset;
 		err = brcmf_sdiod_ramrw(sdiodev, false, address, data, len);
 		if (err) {
-			brcmf_err("error %d on reading %d membytes at 0x%08x\n",
+			brcmf_err(pub, "error %d on reading %d membytes at 0x%08x\n",
 				  err, len, address);
 			goto done;
 		}
@@ -3501,10 +3525,12 @@ void brcmf_sdio_trigger_dpc(struct brcmf_sdio *bus)
 
 void brcmf_sdio_isr(struct brcmf_sdio *bus)
 {
+	struct brcmf_pub *pub = bus->pub;
+
 	brcmf_dbg(TRACE, "Enter\n");
 
 	if (!bus) {
-		brcmf_err("bus is null pointer, exiting\n");
+		brcmf_err(pub, "bus is null pointer, exiting\n");
 		return;
 	}
 
@@ -3514,12 +3540,12 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 		atomic_set(&bus->ipend, 1);
 	else
 		if (brcmf_sdio_intr_rstatus(bus)) {
-			brcmf_err("failed backplane access\n");
+			brcmf_err(pub, "failed backplane access\n");
 		}
 
 	/* Disable additional interrupts (is this needed now)? */
 	if (!bus->intr)
-		brcmf_err("isr w/o interrupt configured!\n");
+		brcmf_err(pub, "isr w/o interrupt configured!\n");
 
 	bus->dpc_triggered = true;
 	queue_work(bus->brcmf_wq, &bus->datawork);
@@ -3631,6 +3657,7 @@ static void
 brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			     struct brcmf_chip *ci, u32 drivestrength)
 {
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	const struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask;
 	u32 str_shift;
@@ -3661,7 +3688,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			str_mask = 0x00000007;
 			str_shift = 0;
 		} else
-			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
+			brcmf_err(pub, "Invalid SDIO Drive strength for chip %s, strength=%d\n",
 				  ci->name, drivestrength);
 		break;
 	case SDIOD_DRVSTR_KEY(BRCM_CC_43362_CHIP_ID, 13):
@@ -3700,6 +3727,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 static int brcmf_sdio_buscoreprep(void *ctx)
 {
 	struct brcmf_sdio_dev *sdiodev = ctx;
+	struct brcmf_pub *pub = sdiodev->bus_if->drvr;
 	int err = 0;
 	u8 clkval, clkset;
 
@@ -3707,7 +3735,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
 	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
 	if (err) {
-		brcmf_err("error writing for HT off\n");
+		brcmf_err(pub, "error writing for HT off\n");
 		return err;
 	}
 
@@ -3717,7 +3745,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
 
 	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
-		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+		brcmf_err(pub, "ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
 			  clkset, clkval);
 		return -EACCES;
 	}
@@ -3727,7 +3755,7 @@ static int brcmf_sdio_buscoreprep(void *ctx)
 			!SBSDIO_ALPAV(clkval)),
 			PMU_MAX_TRANSITION_DLY);
 	if (!SBSDIO_ALPAV(clkval)) {
-		brcmf_err("timeout on ALPAV wait, clkval 0x%02x\n",
+		brcmf_err(pub, "timeout on ALPAV wait, clkval 0x%02x\n",
 			  clkval);
 		return -EBUSY;
 	}
@@ -3795,14 +3823,14 @@ static const struct brcmf_buscore_ops brcmf_sdio_buscore_ops = {
 static bool
 brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
-	struct brcmf_sdio_dev *sdiodev;
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	struct brcmf_pub *pub = bus->pub;
 	u8 clkctl = 0;
 	int err = 0;
 	int reg_addr;
 	u32 reg_val;
 	u32 drivestrength;
 
-	sdiodev = bus->sdiodev;
 	sdio_claim_host(sdiodev->func[1]);
 
 	pr_debug("F1 signature read @0x18000000=0x%4x\n",
@@ -3820,14 +3848,14 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 					   SBSDIO_FUNC1_CHIPCLKCSR, &err);
 
 	if (err || ((clkctl & ~SBSDIO_AVBITS) != BRCMF_INIT_CLKCTL1)) {
-		brcmf_err("ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
+		brcmf_err(pub, "ChipClkCSR access: err %d wrote 0x%02x read 0x%02x\n",
 			  err, BRCMF_INIT_CLKCTL1, clkctl);
 		goto fail;
 	}
 
 	bus->ci = brcmf_chip_attach(sdiodev, &brcmf_sdio_buscore_ops);
 	if (IS_ERR(bus->ci)) {
-		brcmf_err("brcmf_chip_attach failed!\n");
+		brcmf_err(pub, "brcmf_chip_attach failed!\n");
 		bus->ci = NULL;
 		goto fail;
 	}
@@ -3836,7 +3864,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 						   bus->ci->chip,
 						   bus->ci->chiprev);
 	if (!sdiodev->settings) {
-		brcmf_err("Failed to get device parameters\n");
+		brcmf_err(pub, "Failed to get device parameters\n");
 		goto fail;
 	}
 	/* platform specific configuration:
@@ -3866,7 +3894,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 #endif
 
 	if (brcmf_sdio_kso_init(bus)) {
-		brcmf_err("error enabling KSO\n");
+		brcmf_err(pub, "error enabling KSO\n");
 		goto fail;
 	}
 
@@ -3984,6 +4012,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct brcmf_sdio *bus = sdiodev->bus;
+	struct brcmf_pub *pub = bus->pub;
 	int err = 0;
 	u8 saveclk;
 
@@ -4017,7 +4046,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 				  (saveclk | SBSDIO_FORCE_HT), &err);
 	}
 	if (err) {
-		brcmf_err("Failed to force clock for F2: err %d\n", err);
+		brcmf_err(pub, "Failed to force clock for F2: err %d\n", err);
 		goto release;
 	}
 
@@ -4057,7 +4086,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 
 		err = brcmf_sdiod_intr_register(sdiodev);
 		if (err != 0)
-			brcmf_err("intr register failed:%d\n", err);
+			brcmf_err(pub, "intr register failed:%d\n", err);
 	}
 
 	/* If we didn't come up, turn off backplane clock */
@@ -4068,7 +4097,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev,
 
 	err = brcmf_bus_started(dev);
 	if (err != 0) {
-		brcmf_err("dongle is not responding\n");
+		brcmf_err(pub, "dongle is not responding\n");
 		goto fail;
 	}
 	return;
@@ -4105,7 +4134,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	wq = alloc_ordered_workqueue("brcmf_wq/%s", WQ_MEM_RECLAIM,
 				     dev_name(&sdiodev->func[1]->dev));
 	if (!wq) {
-		brcmf_err("insufficient memory to create txworkqueue\n");
+		pr_err("insufficient memory to create txworkqueue\n");
 		goto fail;
 	}
 	brcmf_sdiod_freezer_count(sdiodev);
@@ -4114,7 +4143,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 
 	/* attempt to attach to the dongle */
 	if (!(brcmf_sdio_probe_attach(bus))) {
-		brcmf_err("brcmf_sdio_probe_attach failed\n");
+		pr_err("brcmf_sdio_probe_attach failed\n");
 		goto fail;
 	}
 
@@ -4153,7 +4182,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	/* Attach to the common layer, reserve hdr space */
 	ret = brcmf_attach(bus->sdiodev->dev, bus->sdiodev->settings);
 	if (ret != 0) {
-		brcmf_err("brcmf_attach failed\n");
+		pr_err("brcmf_attach failed\n");
 		goto fail;
 	}
 	bus->pub = sdiodev->bus_if->drvr;
@@ -4175,7 +4204,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 			    ALIGNMENT) + bus->head_align;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
-			brcmf_err("rxbuf allocation failed\n");
+			brcmf_err(bus->pub, "rxbuf allocation failed\n");
 			goto fail;
 		}
 	}
@@ -4214,7 +4243,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 				     sdiodev->fw_name, sdiodev->nvram_name,
 				     brcmf_sdio_firmware_callback);
 	if (ret != 0) {
-		brcmf_err("async firmware request failed: %d\n", ret);
+		brcmf_err(bus->pub, "async firmware request failed: %d\n", ret);
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 523949c44861..03e606ceed15 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -253,6 +253,7 @@ brcmf_usb_ctlwrite_complete(struct urb *urb)
 static int
 brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	int ret;
 	u16 size;
 
@@ -277,7 +278,7 @@ brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0)
-		brcmf_err("usb_submit_urb failed %d\n", ret);
+		brcmf_err(pub, "usb_submit_urb failed %d\n", ret);
 
 	return ret;
 }
@@ -285,6 +286,7 @@ brcmf_usb_send_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 static int
 brcmf_usb_recv_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	int ret;
 	u16 size;
 
@@ -311,7 +313,7 @@ brcmf_usb_recv_ctl(struct brcmf_usbdev_info *devinfo, u8 *buf, int len)
 
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0)
-		brcmf_err("usb_submit_urb failed %d\n", ret);
+		brcmf_err(pub, "usb_submit_urb failed %d\n", ret);
 
 	return ret;
 }
@@ -321,6 +323,7 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	int err = 0;
 	int timeout = 0;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
+	struct brcmf_pub *pub = devinfo->pub;
 
 	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
@@ -332,14 +335,14 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	devinfo->ctl_completed = false;
 	err = brcmf_usb_send_ctl(devinfo, buf, len);
 	if (err) {
-		brcmf_err("fail %d bytes: %d\n", err, len);
+		brcmf_err(pub, "fail %d bytes: %d\n", err, len);
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
 	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
-		brcmf_err("Txctl wait timed out\n");
+		brcmf_err(pub, "Txctl wait timed out\n");
 		err = -EIO;
 	}
 	return err;
@@ -350,6 +353,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	int err = 0;
 	int timeout = 0;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
+	struct brcmf_pub *pub = devinfo->pub;
 
 	brcmf_dbg(USB, "Enter\n");
 	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
@@ -361,7 +365,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	devinfo->ctl_completed = false;
 	err = brcmf_usb_recv_ctl(devinfo, buf, len);
 	if (err) {
-		brcmf_err("fail %d bytes: %d\n", err, len);
+		brcmf_err(pub, "fail %d bytes: %d\n", err, len);
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
@@ -369,7 +373,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	err = devinfo->ctl_urb_status;
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
-		brcmf_err("rxctl wait timed out\n");
+		brcmf_err(pub, "rxctl wait timed out\n");
 		err = -EIO;
 	}
 	if (!err)
@@ -432,7 +436,7 @@ brcmf_usbdev_qinit(struct list_head *q, int qsize)
 	}
 	return reqs;
 fail:
-	brcmf_err("fail!\n");
+	brcmf_err(NULL, "fail!\n");
 	while (!list_empty(q)) {
 		req = list_entry(q->next, struct brcmf_usbreq, list);
 		if (req)
@@ -449,7 +453,7 @@ static void brcmf_usb_free_q(struct list_head *q, bool pending)
 	int i = 0;
 	list_for_each_entry_safe(req, next, q, list) {
 		if (!req->urb) {
-			brcmf_err("bad req\n");
+			brcmf_err(NULL, "bad req\n");
 			break;
 		}
 		i++;
@@ -559,10 +563,11 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 
 static void brcmf_usb_rx_fill_all(struct brcmf_usbdev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct brcmf_usbreq *req;
 
 	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP) {
-		brcmf_err("bus is not up=%d\n", devinfo->bus_pub.state);
+		brcmf_err(pub, "bus is not up=%d\n", devinfo->bus_pub.state);
 		return;
 	}
 	while ((req = brcmf_usb_deq(devinfo, &devinfo->rx_freeq, NULL)) != NULL)
@@ -599,6 +604,7 @@ brcmf_usb_state_change(struct brcmf_usbdev_info *devinfo, int state)
 static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
+	struct brcmf_pub *pub = devinfo->pub;
 	struct brcmf_usbreq  *req;
 	int ret;
 	unsigned long flags;
@@ -612,7 +618,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq,
 					&devinfo->tx_freecount);
 	if (!req) {
-		brcmf_err("no req to send\n");
+		brcmf_err(pub, "no req to send\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
@@ -625,7 +631,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	brcmf_usb_enq(devinfo, &devinfo->tx_postq, req, NULL);
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
-		brcmf_err("brcmf_usb_tx usb_submit_urb FAILED\n");
+		brcmf_err(pub, "brcmf_usb_tx usb_submit_urb FAILED\n");
 		brcmf_usb_del_fromq(devinfo, req);
 		req->skb = NULL;
 		brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req,
@@ -719,6 +725,7 @@ brcmf_usb_sync_complete(struct urb *urb)
 static int brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 			    void *buffer, int buflen)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	int ret;
 	char *tmpbuf;
 	u16 size;
@@ -748,7 +755,7 @@ static int brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
 	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->ctl_urb, GFP_ATOMIC);
 	if (ret < 0) {
-		brcmf_err("usb_submit_urb failed %d\n", ret);
+		brcmf_err(pub, "usb_submit_urb failed %d\n", ret);
 		goto finalize;
 	}
 
@@ -800,6 +807,7 @@ brcmf_usb_dlneeded(struct brcmf_usbdev_info *devinfo)
 static int
 brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct bootrom_id_le id;
 	u32 loop_cnt;
 	int err;
@@ -825,7 +833,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 		brcmf_usb_dl_cmd(devinfo, DL_RESETCFG, &id, sizeof(id));
 		return 0;
 	} else {
-		brcmf_err("Cannot talk to Dongle. Firmware is not UP, %d ms\n",
+		brcmf_err(pub, "Cannot talk to Dongle. Firmware is not UP, %d ms\n",
 			  BRCMF_USB_RESET_GETVER_SPINWAIT * loop_cnt);
 		return -EINVAL;
 	}
@@ -835,6 +843,7 @@ brcmf_usb_resetcfg(struct brcmf_usbdev_info *devinfo)
 static int
 brcmf_usb_dl_send_bulk(struct brcmf_usbdev_info *devinfo, void *buffer, int len)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	int ret;
 
 	if ((devinfo == NULL) || (devinfo->bulk_urb == NULL))
@@ -850,7 +859,7 @@ brcmf_usb_dl_send_bulk(struct brcmf_usbdev_info *devinfo, void *buffer, int len)
 	devinfo->ctl_completed = false;
 	ret = usb_submit_urb(devinfo->bulk_urb, GFP_ATOMIC);
 	if (ret) {
-		brcmf_err("usb_submit_urb failed %d\n", ret);
+		brcmf_err(pub, "usb_submit_urb failed %d\n", ret);
 		return ret;
 	}
 	ret = brcmf_usb_ioctl_resp_wait(devinfo);
@@ -860,6 +869,7 @@ brcmf_usb_dl_send_bulk(struct brcmf_usbdev_info *devinfo, void *buffer, int len)
 static int
 brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	unsigned int sendlen, sent, dllen;
 	char *bulkchunk = NULL, *dlpos;
 	struct rdl_state_le state;
@@ -882,7 +892,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 	/* 2) Check we are in the Waiting state */
 	if (rdlstate != DL_WAITING) {
-		brcmf_err("Failed to DL_START\n");
+		brcmf_err(pub, "Failed to DL_START\n");
 		err = -EINVAL;
 		goto fail;
 	}
@@ -911,7 +921,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 			memcpy(bulkchunk, dlpos, sendlen);
 			if (brcmf_usb_dl_send_bulk(devinfo, bulkchunk,
 						   sendlen)) {
-				brcmf_err("send_bulk failed\n");
+				brcmf_err(pub, "send_bulk failed\n");
 				err = -EINVAL;
 				goto fail;
 			}
@@ -922,7 +932,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 		err = brcmf_usb_dl_cmd(devinfo, DL_GETSTATE, &state,
 				       sizeof(state));
 		if (err) {
-			brcmf_err("DL_GETSTATE Failed\n");
+			brcmf_err(pub, "DL_GETSTATE Failed\n");
 			goto fail;
 		}
 
@@ -931,7 +941,7 @@ brcmf_usb_dl_writeimage(struct brcmf_usbdev_info *devinfo, u8 *fw, int fwlen)
 
 		/* restart if an error is reported */
 		if (rdlstate == DL_BAD_HDR || rdlstate == DL_BAD_CRC) {
-			brcmf_err("Bad Hdr or Bad CRC state %d\n",
+			brcmf_err(pub, "Bad Hdr or Bad CRC state %d\n",
 				  rdlstate);
 			err = -EINVAL;
 			goto fail;
@@ -968,6 +978,7 @@ static int brcmf_usb_dlstart(struct brcmf_usbdev_info *devinfo, u8 *fw, int len)
 
 static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	struct rdl_state_le state;
 
 	brcmf_dbg(USB, "Enter\n");
@@ -989,7 +1000,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 			return -ENODEV;
 		/* The Dongle may go for re-enumeration. */
 	} else {
-		brcmf_err("Dongle not runnable\n");
+		brcmf_err(pub, "Dongle not runnable\n");
 		return -EINVAL;
 	}
 	brcmf_dbg(USB, "Exit\n");
@@ -999,6 +1010,7 @@ static int brcmf_usb_dlrun(struct brcmf_usbdev_info *devinfo)
 static int
 brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 {
+	struct brcmf_pub *pub = devinfo->pub;
 	int err;
 
 	brcmf_dbg(USB, "Enter\n");
@@ -1006,7 +1018,7 @@ brcmf_usb_fw_download(struct brcmf_usbdev_info *devinfo)
 		return -ENODEV;
 
 	if (!devinfo->image) {
-		brcmf_err("No firmware!\n");
+		brcmf_err(pub, "No firmware!\n");
 		return -ENOENT;
 	}
 
@@ -1109,7 +1121,7 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	return &devinfo->bus_pub;
 
 error:
-	brcmf_err("failed!\n");
+	brcmf_err(NULL, "failed!\n");
 	brcmf_usb_detach(devinfo);
 	return NULL;
 }
@@ -1143,7 +1155,7 @@ static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(dev, devinfo->settings);
 	if (ret) {
-		brcmf_err("brcmf_attach failed\n");
+		brcmf_err(NULL, "brcmf_attach failed\n");
 		return ret;
 	}
 	devinfo->pub = bus->drvr;
@@ -1175,7 +1187,7 @@ static void brcmf_usb_probe_phase2(struct device *dev,
 	devinfo = bus->bus_priv.usb->devinfo;
 	ret = check_file(fw->data);
 	if (ret < 0) {
-		brcmf_err("invalid firmware\n");
+		brcmf_err(NULL, "invalid firmware\n");
 		release_firmware(fw);
 		goto error;
 	}
@@ -1259,7 +1271,7 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	ret = brcmf_fw_get_firmwares(dev, 0, devinfo->fw_name, NULL,
 				     brcmf_usb_probe_phase2);
 	if (ret) {
-		brcmf_err("firmware request failed: %d\n", ret);
+		brcmf_err(NULL, "firmware request failed: %d\n", ret);
 		goto fail;
 	}
 
@@ -1313,7 +1325,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	/* Check that the device supports only one configuration */
 	if (usb->descriptor.bNumConfigurations != 1) {
-		brcmf_err("Number of configurations: %d not supported\n",
+		brcmf_err(NULL, "Number of configurations: %d not supported\n",
 			  usb->descriptor.bNumConfigurations);
 		ret = -ENODEV;
 		goto fail;
@@ -1322,7 +1334,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if ((usb->descriptor.bDeviceClass != USB_CLASS_VENDOR_SPEC) &&
 	    (usb->descriptor.bDeviceClass != USB_CLASS_MISC) &&
 	    (usb->descriptor.bDeviceClass != USB_CLASS_WIRELESS_CONTROLLER)) {
-		brcmf_err("Device class: 0x%x not supported\n",
+		brcmf_err(NULL, "Device class: 0x%x not supported\n",
 			  usb->descriptor.bDeviceClass);
 		ret = -ENODEV;
 		goto fail;
@@ -1332,7 +1344,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if ((desc->bInterfaceClass != USB_CLASS_VENDOR_SPEC) ||
 	    (desc->bInterfaceSubClass != 2) ||
 	    (desc->bInterfaceProtocol != 0xff)) {
-		brcmf_err("non WLAN interface %d: 0x%x:0x%x:0x%x\n",
+		brcmf_err(NULL, "non WLAN interface %d: 0x%x:0x%x:0x%x\n",
 			  desc->bInterfaceNumber, desc->bInterfaceClass,
 			  desc->bInterfaceSubClass, desc->bInterfaceProtocol);
 		ret = -ENODEV;
@@ -1356,12 +1368,12 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		}
 	}
 	if (devinfo->rx_pipe == 0) {
-		brcmf_err("No RX (in) Bulk EP found\n");
+		brcmf_err(NULL, "No RX (in) Bulk EP found\n");
 		ret = -ENODEV;
 		goto fail;
 	}
 	if (devinfo->tx_pipe == 0) {
-		brcmf_err("No TX (out) Bulk EP found\n");
+		brcmf_err(NULL, "No TX (out) Bulk EP found\n");
 		ret = -ENODEV;
 		goto fail;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 8eff2753abad..b992234a0dee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -33,24 +33,27 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_if *ifp;
+	struct brcmf_pub *pub;
 	const struct brcmf_vndr_dcmd_hdr *cmdhdr = data;
 	struct sk_buff *reply;
 	int ret, payload, ret_len;
 	void *dcmd_buf = NULL, *wr_pointer;
 	u16 msglen, maxmsglen = PAGE_SIZE - 0x100;
 
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	ifp = vif->ifp;
+	pub = ifp->drvr;
+
 	if (len < sizeof(*cmdhdr)) {
-		brcmf_err("vendor command too short: %d\n", len);
+		brcmf_err(pub, "vendor command too short: %d\n", len);
 		return -EINVAL;
 	}
 
-	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
-	ifp = vif->ifp;
-
 	brcmf_dbg(TRACE, "ifidx=%d, cmd=%d\n", ifp->ifidx, cmdhdr->cmd);
 
 	if (cmdhdr->offset > len) {
-		brcmf_err("bad buffer offset %d > %d\n", cmdhdr->offset, len);
+		brcmf_err(pub, "bad buffer offset %d > %d\n", cmdhdr->offset,
+			  len);
 		return -EINVAL;
 	}
 
@@ -58,11 +61,11 @@ static int brcmf_cfg80211_vndr_cmds_dcmd_handler(struct wiphy *wiphy,
 	ret_len = cmdhdr->len;
 	if (ret_len > 0 || len > 0) {
 		if (len > BRCMF_DCMD_MAXLEN) {
-			brcmf_err("oversize input buffer %d\n", len);
+			brcmf_err(pub, "oversize input buffer %d\n", len);
 			len = BRCMF_DCMD_MAXLEN;
 		}
 		if (ret_len > BRCMF_DCMD_MAXLEN) {
-			brcmf_err("oversize return buffer %d\n", ret_len);
+			brcmf_err(pub, "oversize return buffer %d\n", ret_len);
 			ret_len = BRCMF_DCMD_MAXLEN;
 		}
 		payload = max(ret_len, len) + 1;
-- 
2.11.0
