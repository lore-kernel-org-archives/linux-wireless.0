Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:44778 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcASLj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 06:39:28 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: fix sdio sg table alloc crash
Date: Tue, 19 Jan 2016 12:39:24 +0100
Message-ID: <1453203564-15974-1-git-send-email-arend@broadcom.com> (sfid-20160119_123932_595400_32579B82)
MIME-Version: 1.0
Content-Type: text/plain
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
index 5363739..b98db8a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -879,11 +879,24 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
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
 
@@ -1021,9 +1034,6 @@ static void brcmf_sdiod_host_fixup(struct mmc_host *host)
 
 static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 {
-	struct sdio_func *func;
-	struct mmc_host *host;
-	uint max_blocks;
 	int ret = 0;
 
 	sdiodev->num_funcs = 2;
@@ -1054,26 +1064,6 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
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
@@ -1084,7 +1074,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		ret = -ENODEV;
 		goto out;
 	}
-	brcmf_sdiod_host_fixup(host);
+	brcmf_sdiod_host_fixup(sdiodev->func[2]->card->host);
 out:
 	if (ret)
 		brcmf_sdiod_remove(sdiodev);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index dd66143..a14d9d9d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4114,6 +4114,11 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
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

