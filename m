Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1032 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/19] brcmfmac: determine sd host controller related
 variable earlier
Date: Fri, 29 Nov 2013 12:25:07 +0100
Message-ID: <1385724324-6361-3-git-send-email-arend@broadcom.com> (sfid-20131129_122545_126056_EA47FC1E)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "eb9c174 brcmfmac: determine host controller related
variables during probe" was not implemented correctly as the
information is already needed in brcmf_sdbrcm_probe(). This patch
moves it to brcmf_sdioh_attach() instead.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   32 +++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 009d2a0..225493a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -278,6 +278,9 @@ static int brcmf_sdioh_enablefuncs(struct brcmf_sdio_dev *sdiodev)
 int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 {
 	int err_ret = 0;
+	struct mmc_host *host;
+	struct sdio_func *func;
+	uint max_blocks;
 
 	brcmf_dbg(SDIO, "\n");
 
@@ -299,6 +302,20 @@ int brcmf_sdioh_attach(struct brcmf_sdio_dev *sdiodev)
 
 	brcmf_sdioh_enablefuncs(sdiodev);
 
+	/*
+	 * determine host related variables after brcmf_sdio_probe()
+	 * as func->cur_blksize is properly set and F2 init has been
+	 * completed successfully.
+	 */
+	func = sdiodev->func[2];
+	host = func->card->host;
+	sdiodev->sg_support = host->max_segs > 1;
+	max_blocks = min_t(uint, host->max_blk_count, 511u);
+	sdiodev->max_request_size = min_t(uint, host->max_req_size,
+					  max_blocks * func->cur_blksize);
+	sdiodev->max_segment_count = min_t(uint, host->max_segs,
+					   SG_MAX_SINGLE_ALLOC);
+	sdiodev->max_segment_size = host->max_seg_size;
 out:
 	sdio_release_host(sdiodev->func[1]);
 	brcmf_dbg(SDIO, "Done\n");
@@ -327,8 +344,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	int err;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
-	struct mmc_host *host;
-	uint max_blocks;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "Class=%x\n", func->class);
@@ -376,19 +391,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		goto fail;
 	}
 
-	/*
-	 * determine host related variables after brcmf_sdio_probe()
-	 * as func->cur_blksize is properly set and F2 init has been
-	 * completed successfully.
-	 */
-	host = func->card->host;
-	sdiodev->sg_support = host->max_segs > 1;
-	max_blocks = min_t(uint, host->max_blk_count, 511u);
-	sdiodev->max_request_size = min_t(uint, host->max_req_size,
-					  max_blocks * func->cur_blksize);
-	sdiodev->max_segment_count = min_t(uint, host->max_segs,
-					   SG_MAX_SINGLE_ALLOC);
-	sdiodev->max_segment_size = host->max_seg_size;
 	brcmf_dbg(SDIO, "F2 init completed...\n");
 	return 0;
 
-- 
1.7.10.4


