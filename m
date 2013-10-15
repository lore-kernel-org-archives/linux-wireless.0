Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4375 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab3JONpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:08 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/12] brcmfmac: determine host controller related
 variables during probe
Date: Tue, 15 Oct 2013 15:44:49 +0200
Message-ID: <1381844697-24881-5-git-send-email-arend@broadcom.com> (sfid-20131015_154554_899105_0EC23A8D)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of determining the limits for scatter-gather MMC transfer
request upon each transmit it is now determined during the probe
of the SDIO function.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   23 ++++++--------------
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   17 +++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    4 ++++
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 5dfc96c..8c4b506 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -26,7 +26,6 @@
 #include <linux/mmc/sdio.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
-#include <linux/mmc/host.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
 
 #include <defs.h>
@@ -331,7 +330,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			     bool write, u32 addr, struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
-	unsigned int max_blks, max_req_sz, orig_offset, dst_offset;
+	unsigned int max_req_sz, orig_offset, dst_offset;
 	unsigned short max_seg_cnt, seg_sz;
 	unsigned char *pkt_data, *orig_data, *dst_data;
 	struct sk_buff *pkt_next = NULL, *local_pkt_next;
@@ -341,7 +340,6 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	struct mmc_data mmc_dat;
 	struct sg_table st;
 	struct scatterlist *sgl;
-	struct mmc_host *host;
 	int ret = 0;
 
 	if (!pktlist->qlen)
@@ -398,17 +396,10 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		target_list = &local_list;
 	}
 
-	host = sdiodev->func[fn]->card->host;
 	func_blk_sz = sdiodev->func[fn]->cur_blksize;
-	/* Blocks per command is limited by host count, host transfer
-	 * size and the maximum for IO_RW_EXTENDED of 511 blocks.
-	 */
-	max_blks = min_t(unsigned int, host->max_blk_count, 511u);
-	max_req_sz = min_t(unsigned int, host->max_req_size,
-			   max_blks * func_blk_sz);
-	max_seg_cnt = min_t(unsigned short, host->max_segs,
-			    SG_MAX_SINGLE_ALLOC);
-	max_seg_cnt = min_t(unsigned short, max_seg_cnt, target_list->qlen);
+	max_req_sz = sdiodev->max_request_size;
+	max_seg_cnt = min_t(unsigned short, sdiodev->max_segment_count,
+			    target_list->qlen);
 	seg_sz = target_list->qlen;
 	pkt_offset = 0;
 	pkt_next = target_list->next;
@@ -429,8 +420,8 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		while (pkt_next != (struct sk_buff *)target_list) {
 			pkt_data = pkt_next->data + pkt_offset;
 			sg_data_sz = pkt_next->len - pkt_offset;
-			if (sg_data_sz > host->max_seg_size)
-				sg_data_sz = host->max_seg_size;
+			if (sg_data_sz > sdiodev->max_segment_size)
+				sg_data_sz = sdiodev->max_segment_size;
 			if (sg_data_sz > max_req_sz - req_sz)
 				sg_data_sz = max_req_sz - req_sz;
 
@@ -476,7 +467,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			addr += req_sz;
 
 		mmc_set_data_timeout(&mmc_dat, sdiodev->func[fn]->card);
-		mmc_wait_for_req(host, &mmc_req);
+		mmc_wait_for_req(sdiodev->func[fn]->card->host, &mmc_req);
 
 		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
 		if (ret != 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2a23bf2..905704e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -21,6 +21,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
 #include <linux/suspend.h>
 #include <linux/errno.h>
 #include <linux/sched.h>	/* request_irq() */
@@ -315,6 +316,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	int err;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
+	struct mmc_host *host;
+	uint max_blocks;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "Class=%x\n", func->class);
@@ -361,6 +364,20 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 		brcmf_err("F2 error, probe failed %d...\n", err);
 		goto fail;
 	}
+
+	/*
+	 * determine host related variables after brcmf_sdio_probe()
+	 * as func->cur_blksize is properly set and F2 init has been
+	 * completed successfully.
+	 */
+	host = func->card->host;
+	sdiodev->sg_support = host->max_segs > 1;
+	max_blocks = min_t(uint, host->max_blk_count, 511u);
+	sdiodev->max_request_size = min_t(uint, host->max_req_size,
+					  max_blocks * func->cur_blksize);
+	sdiodev->max_segment_count = min_t(uint, host->max_segs,
+					   SG_MAX_SINGLE_ALLOC);
+	sdiodev->max_segment_size = host->max_seg_size;
 	brcmf_dbg(SDIO, "F2 init completed...\n");
 	return 0;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 2b5407f..59c456f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -178,6 +178,10 @@ struct brcmf_sdio_dev {
 	bool irq_en;			/* irq enable flags */
 	spinlock_t irq_en_lock;
 	bool irq_wake;			/* irq wake enable flags */
+	bool sg_support;
+	uint max_request_size;
+	ushort max_segment_count;
+	uint max_segment_size;
 };
 
 /* Register/deregister interrupt handler. */
-- 
1.7.10.4


