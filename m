Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:52816 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaB0SZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 13:25:10 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 13/14] brcmfmac: use pre-allocated scatter-gather table for txglomming
Date: Thu, 27 Feb 2014 19:25:00 +0100
Message-ID: <1393525500-4161-1-git-send-email-arend@broadcom.com> (sfid-20140227_192531_321874_66CD277B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of allocating a scatter-gather table for every transmit
reuse a pre-allocated table. The transmit path will be faster by
taking out this allocation.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Found an issue with this patch so here is V2. This replaces patch with
Message-ID: 1393356639-19169-14-git-send-email-arend@broadcom.com

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   47 ++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +---
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 07e7d25..9eea7d4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -53,6 +53,12 @@
 /* Maximum milliseconds to wait for F2 to come up */
 #define SDIO_WAIT_F2RDY	3000
 
+#define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
+#define BRCMF_DEFAULT_RXGLOM_SIZE	32  /* max rx frames in glom chain */
+
+static int brcmf_sdiod_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
+module_param_named(txglomsz, brcmf_sdiod_txglomsz, int, 0);
+MODULE_PARM_DESC(txglomsz, "maximum tx packet chain size [SDIO]");
 
 static irqreturn_t brcmf_sdiod_oob_irqhandler(int irq, void *dev_id)
 {
@@ -487,7 +493,6 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	struct mmc_request mmc_req;
 	struct mmc_command mmc_cmd;
 	struct mmc_data mmc_dat;
-	struct sg_table st;
 	struct scatterlist *sgl;
 	int ret = 0;
 
@@ -532,16 +537,11 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	pkt_offset = 0;
 	pkt_next = target_list->next;
 
-	if (sg_alloc_table(&st, max_seg_cnt, GFP_KERNEL)) {
-		ret = -ENOMEM;
-		goto exit;
-	}
-
 	memset(&mmc_req, 0, sizeof(struct mmc_request));
 	memset(&mmc_cmd, 0, sizeof(struct mmc_command));
 	memset(&mmc_dat, 0, sizeof(struct mmc_data));
 
-	mmc_dat.sg = st.sgl;
+	mmc_dat.sg = sdiodev->sgtable.sgl;
 	mmc_dat.blksz = func_blk_sz;
 	mmc_dat.flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
 	mmc_cmd.opcode = SD_IO_RW_EXTENDED;
@@ -557,7 +557,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	while (seg_sz) {
 		req_sz = 0;
 		sg_cnt = 0;
-		sgl = st.sgl;
+		sgl = sdiodev->sgtable.sgl;
 		/* prep sg table */
 		while (pkt_next != (struct sk_buff *)target_list) {
 			pkt_data = pkt_next->data + pkt_offset;
@@ -639,7 +639,7 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	}
 
 exit:
-	sg_free_table(&st);
+	sg_init_table(sdiodev->sgtable.sgl, sdiodev->sgtable.orig_nents);
 	while ((pkt_next = __skb_dequeue(&local_list)) != NULL)
 		brcmu_pkt_buf_free_skb(pkt_next);
 
@@ -863,6 +863,29 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 	return 0;
 }
 
+static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
+{
+	uint nents;
+	int err;
+
+	if (!sdiodev->sg_support)
+		return;
+
+	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE, brcmf_sdiod_txglomsz);
+	nents += (nents >> 4) + 1;
+
+	WARN_ON(nents > sdiodev->max_segment_count);
+
+	brcmf_dbg(TRACE, "nents=%d\n", nents);
+	err = sg_alloc_table(&sdiodev->sgtable, nents, GFP_KERNEL);
+	if (err < 0) {
+		brcmf_err("allocation failed: disable scatter-gather");
+		sdiodev->sg_support = false;
+	}
+
+	sdiodev->txglomsz = brcmf_sdiod_txglomsz;
+}
+
 static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
 	if (sdiodev->bus) {
@@ -880,6 +903,7 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 	sdio_disable_func(sdiodev->func[1]);
 	sdio_release_host(sdiodev->func[1]);
 
+	sg_free_table(&sdiodev->sgtable);
 	sdiodev->sbwad = 0;
 
 	return 0;
@@ -935,6 +959,11 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 					   SG_MAX_SINGLE_ALLOC);
 	sdiodev->max_segment_size = host->max_seg_size;
 
+	/* allocate scatter-gather table. sg support
+	 * will be disabled upon allocation failure.
+	 */
+	brcmf_sdiod_sgtable_alloc(sdiodev);
+
 	/* try to attach to the target device */
 	sdiodev->bus = brcmf_sdio_probe(sdiodev);
 	if (!sdiodev->bus) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 8871d94..3b8f46e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -113,8 +113,6 @@ struct rte_console {
 #define BRCMF_TXBOUND	20	/* Default for max tx frames in
 				 one scheduling */
 
-#define BRCMF_DEFAULT_TXGLOM_SIZE	32  /* max tx frames in glom chain */
-
 #define BRCMF_TXMINMAX	1	/* Max tx frames if rx still pending */
 
 #define MEMBLOCK	2048	/* Block size used for downloading
@@ -511,10 +509,6 @@ static const uint max_roundup = 512;
 
 #define ALIGNMENT  4
 
-static int brcmf_sdio_txglomsz = BRCMF_DEFAULT_TXGLOM_SIZE;
-module_param_named(txglomsz, brcmf_sdio_txglomsz, int, 0);
-MODULE_PARM_DESC(txglomsz, "maximum tx packet chain size [SDIO]");
-
 enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_NORMAL,
 	BRCMF_SDIO_FT_SUPER,
@@ -2321,7 +2315,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		__skb_queue_head_init(&pktq);
 		if (bus->txglom)
 			pkt_num = min_t(u8, bus->tx_max - bus->tx_seq,
-					brcmf_sdio_txglomsz);
+					bus->sdiodev->txglomsz);
 		pkt_num = min_t(u32, pkt_num,
 				brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol));
 		spin_lock_bh(&bus->txqlock);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 5e53eb1..3deab79 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -180,6 +180,8 @@ struct brcmf_sdio_dev {
 	uint max_request_size;
 	ushort max_segment_count;
 	uint max_segment_size;
+	uint txglomsz;
+	struct sg_table sgtable;
 };
 
 /* sdio core registers */
-- 
1.7.10.4

