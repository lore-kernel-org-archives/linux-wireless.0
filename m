Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19495 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbcFPJYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 05:24:51 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	<linux-mmc@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v4 1/2] mmc: API for accessing host supported maximum segment count and size
Date: Thu, 16 Jun 2016 14:53:25 +0530
Message-ID: <1466069006-10757-1-git-send-email-akarwar@marvell.com> (sfid-20160616_112518_553098_7387FCC9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

sdio device drivers need be able to get the host supported max_segs
and max_seg_size, so that they know the buffer size to allocate while
utilizing the scatter/gather DMA buffer list.

This patch provides API for this purpose.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: v2 was submitted with minor improvement like replacing BUG_ON() with WARN_ON()
v3: Addressed below review comments from Ulf Hansson
    a) In v3, patch has been split into two separate patches.
    b) Patch 1/2 introduces an API to fetch max_seg_size and max_segs
    c) Replaced WARN_ON() with proper error code when sg_ptr->length is invalid
    d) Instead of duplicating the code in mmc_io_rw_extended(), extra bool parameter
       has been added to this function and used it in new APIs for SG.
v4: Removed WARN_ON() calls in newly added APIs. It's gets called in probe handler.
    Caller already takes care of it(Shawn Lin).
---
 drivers/mmc/core/sdio_io.c                          | 21 +++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c   |  6 +++---
 include/linux/mmc/sdio_func.h                       |  3 +++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
index 78cb4d5..b1ecacc 100644
--- a/drivers/mmc/core/sdio_io.c
+++ b/drivers/mmc/core/sdio_io.c
@@ -720,3 +720,24 @@ int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
+
+/**
+ *	sdio_get_host_max_seg_size - get host maximum segment size
+ *	@func: SDIO function attached to host
+ */
+unsigned int sdio_get_host_max_seg_size(struct sdio_func *func)
+{
+	return func->card->host->max_seg_size;
+}
+EXPORT_SYMBOL_GPL(sdio_get_host_max_seg_size);
+
+/**
+ *	sdio_get_host_max_seg_count - get host maximum segment count
+ *	@func: SDIO function attached to host
+ */
+unsigned short sdio_get_host_max_seg_count(struct sdio_func *func)
+{
+	return func->card->host->max_segs;
+}
+EXPORT_SYMBOL_GPL(sdio_get_host_max_seg_count);
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index c4b89d2..ba579f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -896,9 +896,9 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 	max_blocks = min_t(uint, host->max_blk_count, 511u);
 	sdiodev->max_request_size = min_t(uint, host->max_req_size,
 					  max_blocks * func->cur_blksize);
-	sdiodev->max_segment_count = min_t(uint, host->max_segs,
-					   SG_MAX_SINGLE_ALLOC);
-	sdiodev->max_segment_size = host->max_seg_size;
+	sdiodev->max_segment_count = min_t(uint, SG_MAX_SINGLE_ALLOC,
+					   sdio_get_host_max_seg_count(func));
+	sdiodev->max_segment_size = sdio_get_host_max_seg_size(func);
 
 	if (!sdiodev->sg_support)
 		return;
diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index aab032a..b2b91df 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -159,4 +159,7 @@ extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
 extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
 extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
 
+unsigned short sdio_get_host_max_seg_count(struct sdio_func *func);
+unsigned int sdio_get_host_max_seg_size(struct sdio_func *func);
+
 #endif /* LINUX_MMC_SDIO_FUNC_H */
-- 
1.9.1

