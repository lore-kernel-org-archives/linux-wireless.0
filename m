Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:6314 "EHLO
	mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161120AbcBQK1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:30 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 17/21] brcmfmac: fix sdio sg table alloc crash
Date: Wed, 17 Feb 2016 11:27:06 +0100
Message-Id: <1455704830-10088-18-git-send-email-arend@broadcom.com> (sfid-20160217_112835_062804_8398BA97)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With commit 7d34b0560567 ("brcmfmac: Move all module parameters to
one place") a bug was introduced causing a null pointer exception.
This patch fixes the bug by initializing the sg table till after
the settings have been initialized.

Reported-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 40 ++++++++--------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  5 +++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  1 +
 3 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 1922de4..25cd712 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -878,11 +878,24 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	return 0;
 }
 
-static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
+void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 {
+	struct sdio_func *func;
+	struct mmc_host *host;
+	uint max_blocks;
 	uint nents;
 	int err;
 
+	func = sdiodev->func[2];
+	host = func->card->host;
+	sdiodev->sg_support = host->max_segs > 1;
+	max_blocks = min_t(uint, host->max_blk_count, 511u);
+	sdiodev->max_request_size = min_t(uint, host->max_req_size,
+					  max_blocks * func->cur_blksize);
+	sdiodev->max_segment_count = min_t(uint, host->max_segs,
+					   SG_MAX_SINGLE_ALLOC);
+	sdiodev->max_segment_size = host->max_seg_size;
+
 	if (!sdiodev->sg_support)
 		return;
 
@@ -1020,9 +1033,6 @@ static void brcmf_sdiod_host_fixup(struct mmc_host *host)
 
 static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdio_func *func;
-	struct mmc_host *host;
-	uint max_blocks;
 	int ret = 0;
 
 	sdiodev->num_funcs = 2;
@@ -1053,26 +1063,6 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		goto out;
 	}
 
-	/*
-	 * determine host related variables after brcmf_sdiod_probe()
-	 * as func->cur_blksize is properly set and F2 init has been
-	 * completed successfully.
-	 */
-	func = sdiodev->func[2];
-	host = func->card->host;
-	sdiodev->sg_support = host->max_segs > 1;
-	max_blocks = min_t(uint, host->max_blk_count, 511u);
-	sdiodev->max_request_size = min_t(uint, host->max_req_size,
-					  max_blocks * func->cur_blksize);
-	sdiodev->max_segment_count = min_t(uint, host->max_segs,
-					   SG_MAX_SINGLE_ALLOC);
-	sdiodev->max_segment_size = host->max_seg_size;
-
-	/* allocate scatter-gather table. sg support
-	 * will be disabled upon allocation failure.
-	 */
-	brcmf_sdiod_sgtable_alloc(sdiodev);
-
 	ret = brcmf_sdiod_freezer_attach(sdiodev);
 	if (ret)
 		goto out;
@@ -1083,7 +1073,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-	brcmf_sdiod_host_fixup(host);
+	brcmf_sdiod_host_fixup(sdiodev->func[2]->card->host);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 6776e45..c790fa8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4113,6 +4113,11 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 		goto fail;
 	}
 
+	/* allocate scatter-gather table. sg support
+	 * will be disabled upon allocation failure.
+	 */
+	brcmf_sdiod_sgtable_alloc(bus->sdiodev);
+
 	/* Query the F2 block size, set roundup accordingly */
 	bus->blocksize = bus->sdiodev->func[2]->cur_blksize;
 	bus->roundup = min(max_roundup, bus->blocksize);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 5ec7a6d..23f2231 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -342,6 +342,7 @@ int brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 /* Issue an abort to the specified function */
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn);
+void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev);
 void brcmf_sdiod_change_state(struct brcmf_sdio_dev *sdiodev,
 			      enum brcmf_sdiod_state state);
 #ifdef CONFIG_PM_SLEEP
-- 
1.9.1

