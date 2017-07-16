Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46908 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbdGPLoQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:44:16 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 06/21] brcmfmac: Clean up SDIO IO functions.
Date: Sun, 16 Jul 2017 12:21:14 +0100
Message-Id: <20170716112129.10206-7-ian@mnementh.co.uk> (sfid-20170716_134420_635922_72F8784C)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 266 ++++++++-------------
 1 file changed, 105 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 2b527d2a2f8a..06e6a72245a7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -232,6 +232,52 @@ void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 	sdiodev->state = state;
 }
 
+static int
+brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
+{
+	int err = 0, i;
+	u32 addr;
+
+	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
+
+	for (i = 0; i < 3; i++) {
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
+					&err);
+		if (err)
+			break;
+
+		addr = addr >> 8;
+	}
+
+	return err;
+}
+
+// bar0 = top 17 bits. lowest of which seems to be SBSDIO_SB_ACCESS_2_4B_FLAG
+// if accessing a different bar, program the bar0 value into SBSDIO_FUNC1_SBADDRLOW
+// addr loses its top 17 bits and is ORed with SBSDIO_SB_ACCESS_2_4B_FLAG
+// Appears to only be required for 4 byte operations.
+// Value of sdiodev->sbwad is set here and used elsewhere (Why?)
+static int
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
+{
+	uint bar0 = *addr & SBSDIO_SBWINDOW_MASK;
+	int err = 0;
+
+	if (bar0 != sdiodev->sbwad) {
+		printk("WTAF? %08x %08x\n", bar0, sdiodev->sbwad);
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
+		if (err)
+			return err;
+
+		sdiodev->sbwad = bar0;
+	}
+
+	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
+	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+
+	return 0;
+}
+
 static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte, uint regaddr)
 {
 	int err_ret;
@@ -250,93 +296,45 @@ static inline int brcmf_sdiod_f0_writeb(struct sdio_func *func, u8 byte, uint re
 	return err_ret;
 }
 
-static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
-				    u32 addr, u8 regsz, void *data, bool write)
-{
-	struct sdio_func *func;
-	int ret = -EINVAL;
-
-	brcmf_dbg(SDIO, "rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
-		  write, fn, addr, regsz);
-
-	/* only allow byte access on F0 */
-	if (WARN_ON(regsz > 1 && !fn))
-		return -EINVAL;
-	func = sdiodev->func[fn];
-
-	switch (regsz) {
-	case 1:
-		if (write) {
-			if (fn)
-				sdio_writeb(func, *(u8 *)data, addr, &ret);
-			else
-				ret = brcmf_sdiod_f0_writeb(func, *(u8 *)data, addr);
-		} else {
-			if (fn)
-				*(u8 *)data = sdio_readb(func, addr, &ret);
-			else
-				*(u8 *)data = sdio_f0_readb(func, addr, &ret);
-		}
-		break;
-	case 2:
-		if (write)
-			sdio_writew(func, *(u16 *)data, addr, &ret);
-		else
-			*(u16 *)data = sdio_readw(func, addr, &ret);
-		break;
-	case 4:
-		if (write)
-			sdio_writel(func, *(u32 *)data, addr, &ret);
-		else
-			*(u32 *)data = sdio_readl(func, addr, &ret);
-		break;
-	default:
-		brcmf_err("invalid size: %d\n", regsz);
-		break;
-	}
-
-	if (ret)
-		brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
-			  write ? "write" : "read", fn, addr, ret);
-
-	return ret;
-}
-
 static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data)
 {
-	u8 func;
-	s32 retry = 0;
 	int ret;
 
-	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
-		return -ENOMEDIUM;
-
 	/*
 	 * figure out how to read the register based on address range
 	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
 	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
 	 * The rest: function 1 silicon backplane core registers
+	 * f0 writes must be bytewise
 	 */
-	if ((addr & ~REG_F0_REG_MASK) == 0)
-		func = SDIO_FUNC_0;
-	else
-		func = SDIO_FUNC_1;
 
-	do {
-		/* for retry wait for 1 ms till bus get settled down */
-		if (retry)
-			usleep_range(1000, 2000);
-
-		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
-					       data, true);
+	if ((addr & ~REG_F0_REG_MASK) == 0) {
+		if (WARN_ON(regsz > 1))
+			return -EINVAL;
+		ret = brcmf_sdiod_f0_writeb(sdiodev->func[0], *(u8 *)data, addr);
+	}
+	else {
+		switch (regsz) {
+			case 1:
+				sdio_writeb(sdiodev->func[1], *(u8 *)data, addr, &ret);
+				break;
+			case 4:
+				ret = brcmf_sdiod_addrprep(sdiodev, &addr);
+				if (ret)
+					goto done;
 
-	} while (ret != 0 && ret != -ENOMEDIUM &&
-		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+				sdio_writel(sdiodev->func[1], *(u32 *)data, addr, &ret);
+				break;
+			default:
+				BUG();
+				ret = -EINVAL;
+				break;
+		}
+	}
 
-	if (ret == -ENOMEDIUM)
-		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-	else if (ret != 0) {
+#if 0
+	if (ret != 0) {
 		/*
 		 * SleepCSR register access can fail when
 		 * waking up the device so reduce this noise
@@ -349,47 +347,50 @@ static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			brcmf_dbg(SDIO, "failed to write data F%d@0x%05x, err: %d\n",
 				  func, addr, ret);
 	}
+#endif
 
+done:
 	return ret;
 }
 
 static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data)
 {
-	u8 func;
-	s32 retry = 0;
 	int ret;
 
-	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
-		return -ENOMEDIUM;
-
 	/*
 	 * figure out how to read the register based on address range
 	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
 	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
 	 * The rest: function 1 silicon backplane core registers
+	 * f0 reads must be bytewise
 	 */
-	if ((addr & ~REG_F0_REG_MASK) == 0)
-		func = SDIO_FUNC_0;
-	else
-		func = SDIO_FUNC_1;
-
-	do {
-		memset(data, 0, regsz);
-
-		/* for retry wait for 1 ms till bus get settled down */
-		if (retry)
-			usleep_range(1000, 2000);
-
-		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
-					       data, false);
+	if ((addr & ~REG_F0_REG_MASK) == 0) {
+		if (WARN_ON(regsz > 1))
+			return -EINVAL;
+		*(u8 *)data = sdio_f0_readb(sdiodev->func[0], addr, &ret);
+	}
+	else {
+		switch (regsz) {
+			case 1:
+				*(u8 *)data = sdio_readb(sdiodev->func[1], addr, &ret);
+				break;
+			case 4:
+				ret = brcmf_sdiod_addrprep(sdiodev, &addr);
+				if (ret)
+					goto done;
 
-	} while (ret != 0 && ret != -ENOMEDIUM &&
-		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+				*(u32 *)data = sdio_readl(sdiodev->func[1], addr, &ret);
+				break;
+			default:
+				BUG();
+				ret = -EINVAL;
+				break;
+		}
+	}
 
-	if (ret == -ENOMEDIUM)
-		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-	else if (ret != 0) {
+#if 0
+	if (ret != 0) {
 		/*
 		 * SleepCSR register access can fail when
 		 * waking up the device so reduce this noise
@@ -402,62 +403,19 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 			brcmf_dbg(SDIO, "failed to read data F%d@0x%05x, err: %d\n",
 				  func, addr, ret);
 	}
+#endif
 
+done:
 	return ret;
 }
 
-static int
-brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
-{
-	int err = 0, i;
-	u32 addr;
-
-	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
-		return -ENOMEDIUM;
-
-	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
-
-	for (i = 0; i < 3; i++) {
-		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
-					&err);
-		if (err)
-			break;
-
-		addr = addr >> 8;
-	}
-
-	return err;
-}
-
-static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
-{
-	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
-	int err = 0;
-
-	if (bar0 != sdiodev->sbwad) {
-		err = brcmf_sdiod_set_sbaddr_window(sdiodev, bar0);
-		if (err)
-			return err;
-
-		sdiodev->sbwad = bar0;
-	}
-
-	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
-	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
-
-	return 0;
-}
 
 u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 {
-	u8 data;
+	u8 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_reg_read(sdiodev, addr, sizeof(data), &data);
-	brcmf_dbg(SDIO, "data:0x%02x\n", data);
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
 
 	if (ret)
 		*ret = retval;
@@ -470,15 +428,8 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	u32 data = 0;
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
-	if (retval)
-		goto done;
-	retval = brcmf_sdiod_reg_read(sdiodev, addr, sizeof(data), &data);
-
-	brcmf_dbg(SDIO, "data:0x%08x\n", data);
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
 
-done:
 	if (ret)
 		*ret = retval;
 
@@ -490,8 +441,7 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdiod_reg_write(sdiodev, addr, sizeof(data), &data);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
 
 	if (ret)
 		*ret = retval;
@@ -502,14 +452,8 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 {
 	int retval;
 
-	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
-	if (retval)
-		goto done;
-
-	retval = brcmf_sdiod_reg_write(sdiodev, addr, sizeof(data), &data);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
-done:
 	if (ret)
 		*ret = retval;
 }
-- 
2.11.0
