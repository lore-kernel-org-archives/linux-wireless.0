Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20084 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbaCTJSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:18:13 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/4] brcmfmac: only show error message when brcmf_sdiod_regrw_helper() fails
Date: Thu, 20 Mar 2014 10:18:02 +0100
Message-ID: <1395307083-31523-4-git-send-email-arend@broadcom.com> (sfid-20140320_101824_297408_0BD657C8)
In-Reply-To: <1395307083-31523-1-git-send-email-arend@broadcom.com>
References: <1395307083-31523-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the function brcmf_sdiod_request_data() an error message is logged,
but the calling function retries it. This patch will only log an error
message when retry limit is reached. The low-level error is still
logged by a SDIO debug message.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   41 +++++++++++-----------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 6e8718b..a16e644 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -269,26 +269,17 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 		break;
 	}
 
-	if (ret) {
-		/*
-		 * SleepCSR register access can fail when
-		 * waking up the device so reduce this noise
-		 * in the logs.
-		 */
-		if (addr != SBSDIO_FUNC1_SLEEPCSR)
-			brcmf_err("failed to %s data F%d@0x%05x, err: %d\n",
-				  write ? "write" : "read", fn, addr, ret);
-		else
-			brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
-				  write ? "write" : "read", fn, addr, ret);
-	}
+	if (ret)
+		brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
+			  write ? "write" : "read", fn, addr, ret);
+
 	return ret;
 }
 
 static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 				   u8 regsz, void *data, bool write)
 {
-	u8 func_num;
+	u8 func;
 	s32 retry = 0;
 	int ret;
 
@@ -302,9 +293,9 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	 * The rest: function 1 silicon backplane core registers
 	 */
 	if ((addr & ~REG_F0_REG_MASK) == 0)
-		func_num = SDIO_FUNC_0;
+		func = SDIO_FUNC_0;
 	else
-		func_num = SDIO_FUNC_1;
+		func = SDIO_FUNC_1;
 
 	do {
 		if (!write)
@@ -312,16 +303,26 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 		/* for retry wait for 1 ms till bus get settled down */
 		if (retry)
 			usleep_range(1000, 2000);
-		ret = brcmf_sdiod_request_data(sdiodev, func_num, addr, regsz,
+		ret = brcmf_sdiod_request_data(sdiodev, func, addr, regsz,
 					       data, write);
 	} while (ret != 0 && ret != -ENOMEDIUM &&
 		 retry++ < SDIOH_API_ACCESS_RETRY_LIMIT);
 
 	if (ret == -ENOMEDIUM)
 		brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_NOMEDIUM);
-	else if (ret != 0)
-		brcmf_err("failed with %d\n", ret);
-
+	else if (ret != 0) {
+		/*
+		 * SleepCSR register access can fail when
+		 * waking up the device so reduce this noise
+		 * in the logs.
+		 */
+		if (addr != SBSDIO_FUNC1_SLEEPCSR)
+			brcmf_err("failed to %s data F%d@0x%05x, err: %d\n",
+				  write ? "write" : "read", func, addr, ret);
+		else
+			brcmf_dbg(SDIO, "failed to %s data F%d@0x%05x, err: %d\n",
+				  write ? "write" : "read", func, addr, ret);
+	}
 	return ret;
 }
 
-- 
1.7.9.5

