Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6409 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaAFLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/15] brcmfmac: rework SDIO register access functions
Date: Mon, 6 Jan 2014 12:40:36 +0100
Message-ID: <1389008450-28529-2-git-send-email-arend@broadcom.com> (sfid-20140106_124114_747295_739C7158)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logic in the SDIO register access functions was hard to
read and contained a lot of conditional code path. This rework
attempts to clean it up.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  227 +++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 -
 2 files changed, 96 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 2b5cde6..07015e1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -216,94 +216,104 @@ static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func,
 	return err_ret;
 }
 
-static int brcmf_sdiod_request_byte(struct brcmf_sdio_dev *sdiodev, uint rw,
-				    uint func, uint regaddr, u8 *byte)
+static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
+				    u32 addr, u8 regsz, void *data, bool write)
 {
-	int err_ret;
+	struct sdio_func *func;
+	int ret;
 
-	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x\n", rw, func, regaddr);
+	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
+		  write, fn, addr, regsz);
 
-	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_byte_wait);
+	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
 	if (brcmf_sdiod_pm_resume_error(sdiodev))
 		return -EIO;
 
-	if (rw && func == 0) {
-		/* handle F0 separately */
-		err_ret = brcmf_sdiod_f0_writeb(sdiodev->func[func],
-						regaddr, *byte);
-	} else {
-		if (rw) /* CMD52 Write */
-			sdio_writeb(sdiodev->func[func], *byte, regaddr,
-				    &err_ret);
-		else if (func == 0) {
-			*byte = sdio_f0_readb(sdiodev->func[func], regaddr,
-					      &err_ret);
+	/* only allow byte access on F0 */
+	if (WARN_ON(regsz > 1 && !fn))
+		return -EINVAL;
+	func = sdiodev->func[fn];
+
+	switch (regsz) {
+	case sizeof(u8):
+		if (write) {
+			if (fn)
+				sdio_writeb(func, *(u8 *)data, addr, &ret);
+			else
+				ret = brcmf_sdiod_f0_writeb(func, addr,
+							    *(u8 *)data);
 		} else {
-			*byte = sdio_readb(sdiodev->func[func], regaddr,
-					   &err_ret);
+			if (fn)
+				*(u8 *)data = sdio_readb(func, addr, &ret);
+			else
+				*(u8 *)data = sdio_f0_readb(func, addr, &ret);
 		}
+		break;
+	case sizeof(u16):
+		if (write)
+			sdio_writew(func, *(u16 *)data, addr, &ret);
+		else
+			*(u16 *)data = sdio_readw(func, addr, &ret);
+		break;
+	case sizeof(u32):
+		if (write)
+			sdio_writel(func, *(u32 *)data, addr, &ret);
+		else
+			*(u32 *)data = sdio_readl(func, addr, &ret);
+		break;
+	default:
+		brcmf_err("invalid size: %d\n", regsz);
+		break;
 	}
 
-	if (err_ret) {
+	if (ret) {
 		/*
 		 * SleepCSR register access can fail when
 		 * waking up the device so reduce this noise
 		 * in the logs.
 		 */
-		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
-				  rw ? "write" : "read", func, regaddr, *byte,
-				  err_ret);
+		if (addr != SBSDIO_FUNC1_SLEEPCSR)
+			brcmf_err("failed to %s data F%d@0x%05x, err: %d\n",
+				  write ? "write" : "read", fn, addr, ret);
 		else
-			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
-				  rw ? "write" : "read", func, regaddr, *byte,
-				  err_ret);
+			brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
+				  write ? "write" : "read", fn, addr, ret);
 	}
-	return err_ret;
+	return ret;
 }
 
-static int brcmf_sdiod_request_word(struct brcmf_sdio_dev *sdiodev, uint rw,
-				    uint func, uint addr, u32 *word,
-				    uint nbytes)
+static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   u8 regsz, void *data, bool write)
 {
-	int err_ret = -EIO;
-
-	if (func == 0) {
-		brcmf_err("Only CMD52 allowed to F0\n");
-		return -EINVAL;
-	}
-
-	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
-		  rw, func, addr, nbytes);
+	u8 func_num;
+	s32 retry = 0;
+	int ret;
 
-	brcmf_sdiod_pm_resume_wait(sdiodev, &sdiodev->request_word_wait);
-	if (brcmf_sdiod_pm_resume_error(sdiodev))
-		return -EIO;
+	/*
+	 * figure out how to read the register based on address range
+	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
+	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
+	 * The rest: function 1 silicon backplane core registers
+	 */
+	if ((addr & ~REG_F0_REG_MASK) == 0)
+		func_num = SDIO_FUNC_0;
+	else
+		func_num = SDIO_FUNC_1;
 
-	if (rw) {		/* CMD52 Write */
-		if (nbytes == 4)
-			sdio_writel(sdiodev->func[func], *word, addr,
-				    &err_ret);
-		else if (nbytes == 2)
-			sdio_writew(sdiodev->func[func], (*word & 0xFFFF),
-				    addr, &err_ret);
-		else
-			brcmf_err("Invalid nbytes: %d\n", nbytes);
-	} else {		/* CMD52 Read */
-		if (nbytes == 4)
-			*word = sdio_readl(sdiodev->func[func], addr, &err_ret);
-		else if (nbytes == 2)
-			*word = sdio_readw(sdiodev->func[func], addr,
-					   &err_ret) & 0xFFFF;
-		else
-			brcmf_err("Invalid nbytes: %d\n", nbytes);
-	}
+	do {
+		if (!write)
+			memset(data, 0, regsz);
+		/* for retry wait for 1 ms till bus get settled down */
+		if (retry)
+			usleep_range(1000, 2000);
+		ret = brcmf_sdiod_request_data(sdiodev, func_num, addr, regsz,
+					       data, write);
+	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
-	if (err_ret)
-		brcmf_err("Failed to %s word, Err: 0x%08x\n",
-			  rw ? "write" : "read", err_ret);
+	if (ret != 0)
+		brcmf_err("failed with %d\n", ret);
 
-	return err_ret;
+	return ret;
 }
 
 static int
@@ -311,24 +321,17 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0, i;
 	u8 addr[3];
-	s32 retry;
 
 	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
 	addr[1] = (address >> 16) & SBSDIO_SBADDRMID_MASK;
 	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
 
 	for (i = 0; i < 3; i++) {
-		retry = 0;
-		do {
-			if (retry)
-				usleep_range(1000, 2000);
-			err = brcmf_sdiod_request_byte(sdiodev, SDIOH_WRITE,
-					SDIO_FUNC_1, SBSDIO_FUNC1_SBADDRLOW + i,
-					&addr[i]);
-		} while (err != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
-
+		err = brcmf_sdiod_regrw_helper(sdiodev,
+					       SBSDIO_FUNC1_SBADDRLOW + i,
+					       sizeof(u8), &addr[i], true);
 		if (err) {
-			brcmf_err("failed at addr:0x%0x\n",
+			brcmf_err("failed at addr: 0x%0x\n",
 				  SBSDIO_FUNC1_SBADDRLOW + i);
 			break;
 		}
@@ -359,61 +362,14 @@ brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
 	return 0;
 }
 
-static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				    void *data, bool write)
-{
-	u8 func_num, reg_size;
-	s32 retry = 0;
-	int ret;
-
-	/*
-	 * figure out how to read the register based on address range
-	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
-	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
-	 * The rest: function 1 silicon backplane core registers
-	 */
-	if ((addr & ~REG_F0_REG_MASK) == 0) {
-		func_num = SDIO_FUNC_0;
-		reg_size = 1;
-	} else if ((addr & ~REG_F1_MISC_MASK) == 0) {
-		func_num = SDIO_FUNC_1;
-		reg_size = 1;
-	} else {
-		func_num = SDIO_FUNC_1;
-		reg_size = 4;
-
-		ret = brcmf_sdiod_addrprep(sdiodev, reg_size, &addr);
-		if (ret)
-			goto done;
-	}
-
-	do {
-		if (!write)
-			memset(data, 0, reg_size);
-		if (retry)	/* wait for 1 ms till bus get settled down */
-			usleep_range(1000, 2000);
-		if (reg_size == 1)
-			ret = brcmf_sdiod_request_byte(sdiodev, write,
-						       func_num, addr, data);
-		else
-			ret = brcmf_sdiod_request_word(sdiodev, write,
-						       func_num, addr, data, 4);
-	} while (ret != 0 && retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
-
-done:
-	if (ret != 0)
-		brcmf_err("failed with %d\n", ret);
-
-	return ret;
-}
-
 u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
 	u8 data;
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, false);
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+					  false);
 	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -428,9 +384,14 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, false);
+	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	if (retval)
+		goto done;
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+					  false);
 	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
+done:
 	if (ret)
 		*ret = retval;
 
@@ -443,8 +404,8 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, true);
-
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+					  true);
 	if (ret)
 		*ret = retval;
 }
@@ -455,8 +416,13 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, &data, true);
+	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	if (retval)
+		goto done;
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+					  true);
 
+done:
 	if (ret)
 		*ret = retval;
 }
@@ -879,8 +845,8 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	brcmf_dbg(SDIO, "Enter\n");
 
 	/* issue abort cmd52 command through F0 */
-	brcmf_sdiod_request_byte(sdiodev, SDIOH_WRITE, SDIO_FUNC_0,
-				 SDIO_CCCR_ABORT, &t_func);
+	brcmf_sdiod_request_data(sdiodev, SDIO_FUNC_0, SDIO_CCCR_ABORT,
+				 sizeof(t_func), &t_func, true);
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
@@ -1037,7 +1003,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	sdiodev->pdata = brcmfmac_sdio_pdata;
 
 	atomic_set(&sdiodev->suspend, false);
-	init_waitqueue_head(&sdiodev->request_byte_wait);
 	init_waitqueue_head(&sdiodev->request_word_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index a0981b3..092e9c8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -167,7 +167,6 @@ struct brcmf_sdio_dev {
 	u32 sbwad;			/* Save backplane window address */
 	struct brcmf_sdio *bus;
 	atomic_t suspend;		/* suspend flag */
-	wait_queue_head_t request_byte_wait;
 	wait_queue_head_t request_word_wait;
 	wait_queue_head_t request_buffer_wait;
 	struct device *dev;
-- 
1.7.10.4

