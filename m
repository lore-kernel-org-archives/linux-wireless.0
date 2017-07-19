Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:56134 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933714AbdGSTIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:08:38 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 03/34] brcmfmac: Split brcmf_sdiod_regrw_helper() up.
Date: Wed, 19 Jul 2017 20:07:51 +0100
Message-Id: <20170719190822.10857-4-ian@mnementh.co.uk> (sfid-20170719_210846_373734_750444D5)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	This large function is concealing a LOT of obscure logic about
how the hardware functions. Time to split it up.

This first patch splits the function into two pieces - read and write,
doing away with the rw flag in the process.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 94 +++++++++++++++++-----
 1 file changed, 73 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index db983168ceba..5b9a21d6b6b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -300,8 +300,8 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	return ret;
 }
 
-static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
-				   u8 regsz, void *data, bool write)
+static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32 addr,
+				   u8 regsz, void *data)
 {
 	u8 func;
 	s32 retry = 0;
@@ -322,13 +322,66 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
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
 
@@ -341,12 +394,13 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
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
 
@@ -364,13 +418,11 @@ brcmf_sdiod_set_sbaddr_window(struct brcmf_sdio_dev *sdiodev, u32 address)
 	addr[2] = (address >> 24) & SBSDIO_SBADDRHIGH_MASK;
 
 	for (i = 0; i < 3; i++) {
-		err = brcmf_sdiod_regrw_helper(sdiodev,
-					       SBSDIO_FUNC1_SBADDRLOW + i,
-					       1, &addr[i], true);
+		brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SBADDRLOW + i, addr[i],
+					&err);
 		if (err) {
 			brcmf_err("failed at addr: 0x%0x\n",
 				  SBSDIO_FUNC1_SBADDRLOW + i);
-			break;
 		}
 	}
 
@@ -405,8 +457,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 1, &data,
-					  false);
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, 1, &data);
 	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
 	if (ret)
@@ -424,8 +475,9 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 4, &data,
-					  false);
+
+	retval = brcmf_sdiod_reg_read(sdiodev, addr, 4, &data);
+
 	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
 done:
@@ -441,8 +493,8 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 1, &data,
-					  true);
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 1, &data);
+
 	if (ret)
 		*ret = retval;
 }
@@ -456,8 +508,8 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 4, &data,
-					  true);
+
+	retval = brcmf_sdiod_reg_write(sdiodev, addr, 4, &data);
 
 done:
 	if (ret)
-- 
2.11.0
