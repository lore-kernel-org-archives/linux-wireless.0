Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48044 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdGPLpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:45:30 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 04/21] brcmfmac: Do away with this abomination:
Date: Sun, 16 Jul 2017 12:21:12 +0100
Message-Id: <20170716112129.10206-5-ian@mnementh.co.uk> (sfid-20170716_140042_909098_D3565BB3)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdiod_regrw_helper()
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 105 +++++++++++++++------
 1 file changed, 77 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 6ff4f10e36bb..1012df347c84 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -302,8 +302,8 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	return ret;
 }
 
-static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				   u8 regsz, void *data, bool write)
+static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   u8 regsz, void *data)
 {
 	u8 func;
 	s32 retry = 0;
@@ -324,13 +324,66 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		func = SDIO_FUNC_1;
 
 	do {
-		if (!write)
-			memset(data, 0, regsz);
 		/* for retry wait for 1 ms till bus get settled down */
 		if (retry)
 			usleep_range(1000, 2000);
+
+		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
+					       data, true);
+
+	} while (ret != 0 && ret != -ENOMEDIUM &&
+		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
+
+	if (ret == -ENOMEDIUM)
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+	else if (ret != 0) {
+		/*
+		 * SleepCSR register access can fail when
+		 * waking up the device so reduce this noise
+		 * in the logs.
+		 */
+		if (addr != SBSDIO_FUNC1_SLEEPCSR)
+			brcmf_err("failed to write data F%d@0x%05x, err: %d\n",
+				  func, addr, ret);
+		else
+			brcmf_dbg(SDIO, "failed to write data F%d@0x%05x, err: %d\n",
+				  func, addr, ret);
+	}
+
+	return ret;
+}
+
+static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   u8 regsz, void *data)
+{
+	u8 func;
+	s32 retry = 0;
+	int ret;
+
+	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
+		return -ENOMEDIUM;
+
+	/*
+	 * figure out how to read the register based on address range
+	 * 0x00 ~ 0x7FF: function 0 CCCR and FBR
+	 * 0x10000 ~ 0x1FFFF: function 1 miscellaneous registers
+	 * The rest: function 1 silicon backplane core registers
+	 */
+	if ((addr & ~REG_F0_REG_MASK) == 0)
+		func = SDIO_FUNC_0;
+	else
+		func = SDIO_FUNC_1;
+
+	do {
+		memset(data, 0, regsz);
+
+		/* for retry wait for 1 ms till bus get settled down */
+		if (retry)
+			usleep_range(1000, 2000);
+
 		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
-					       data, write);
+					       data, false);
+
 	} while (ret != 0 && ret != -ENOMEDIUM &&
 		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
@@ -343,12 +396,13 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		 * in the logs.
 		 */
 		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to %s data F%d@0x%05x, err: %d\n",
-				  write ? "write" : "read", func, addr, ret);
+			brcmf_err("failed to read data F%d@0x%05x, err: %d\n",
+				  func, addr, ret);
 		else
-			brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
-				  write ? "write" : "read", func, addr, ret);
+			brcmf_dbg(SDIO, "failed to read data F%d@0x%05x, err: %d\n",
+				  func, addr, ret);
 	}
+
 	return ret;
 }
 
@@ -356,24 +410,20 @@ static int
 brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 {
 	int err = 0, i;
-	u8 addr[3];
+	u32 addr;
 
 	if (sdiodev->state == BRCMF_SDIOD_NOMEDIUM)
 		return -ENOMEDIUM;
 
-	addr[0] = (address >> 8) & SBSDIO_SBADDRLOW_MASK;
-	addr[1] = (address >> 16) & SBSDIO_SBADDRMID_MASK;
-	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
+	addr = (address & SBSDIO_SBWINDOW_MASK) >> 8;
 
 	for (i = 0; i < 3; i++) {
-		err = brcmf_sdiod_regrw_helper(sdiodev,
-					       SBSDIO_FUNC1_SBADDRLOW + i,
-					       sizeof(u8), &addr[i], true);
-		if (err) {
-			brcmf_err("failed at addr: 0x%0x\n",
-				  SBSDIO_FUNC1_SBADDRLOW + i);
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr & 0xff,
+					&err);
+		if (err)
 			break;
-		}
+
+		addr = addr >> 8;
 	}
 
 	return err;
@@ -407,8 +457,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
-					  false);
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, sizeof(data), &data);
 	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -426,8 +475,8 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
-					  false);
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, sizeof(data), &data);
+
 	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 done:
@@ -443,8 +492,8 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
-					  true);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, sizeof(data), &data);
+
 	if (ret)
 		*ret = retval;
 }
@@ -458,8 +507,8 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
-					  true);
+
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, sizeof(data), &data);
 
 done:
 	if (ret)
-- 
2.11.0
