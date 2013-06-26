Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1759 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/9] brcmfmac: add broken scatter-gather DMA support
Date: Wed, 26 Jun 2013 14:20:18 +0200
Message-ID: <1372249222-4858-6-git-send-email-arend@broadcom.com> (sfid-20130626_142100_967082_0DD81C71)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

DMA engine of some old SDIO host controllers require block size alignment for
data length of each scatterlist item. This patch introduces an intermediate
buffer list to support this kind of platform. It decreases the throughput
because of an extra memcpy in critical data path. So don't turn this on unless
it's necessary.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   78 +++++++++++++++++++---
 include/linux/platform_data/brcmfmac-sdio.h      |    5 ++
 2 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 70cd0e9..e3f3c48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -331,10 +331,11 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 			     bool write, u32 addr, struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
-	unsigned int max_blks, max_req_sz;
+	unsigned int max_blks, max_req_sz, orig_offset, dst_offset;
 	unsigned short max_seg_sz, seg_sz;
-	unsigned char *pkt_data;
-	struct sk_buff *pkt_next = NULL;
+	unsigned char *pkt_data, *orig_data, *dst_data;
+	struct sk_buff *pkt_next = NULL, *local_pkt_next;
+	struct sk_buff_head local_list, *target_list;
 	struct mmc_request mmc_req;
 	struct mmc_command mmc_cmd;
 	struct mmc_data mmc_dat;
@@ -371,6 +372,32 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 					   req_sz);
 	}
 
+	target_list = pktlist;
+	/* for host with broken sg support, prepare a page aligned list */
+	__skb_queue_head_init(&local_list);
+	if (sdiodev->pdata && sdiodev->pdata->broken_sg_support && !write) {
+		req_sz = 0;
+		skb_queue_walk(pktlist, pkt_next)
+			req_sz += pkt_next->len;
+		req_sz = ALIGN(req_sz, sdiodev->func[fn]->cur_blksize);
+		while (req_sz > PAGE_SIZE) {
+			pkt_next = brcmu_pkt_buf_get_skb(PAGE_SIZE);
+			if (pkt_next == NULL) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+			__skb_queue_tail(&local_list, pkt_next);
+			req_sz -= PAGE_SIZE;
+		}
+		pkt_next = brcmu_pkt_buf_get_skb(req_sz);
+		if (pkt_next == NULL) {
+			ret = -ENOMEM;
+			goto exit;
+		}
+		__skb_queue_tail(&local_list, pkt_next);
+		target_list = &local_list;
+	}
+
 	host = sdiodev->func[fn]->card->host;
 	func_blk_sz = sdiodev->func[fn]->cur_blksize;
 	/* Blocks per command is limited by host count, host transfer
@@ -380,13 +407,15 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	max_req_sz = min_t(unsigned int, host->max_req_size,
 			   max_blks * func_blk_sz);
 	max_seg_sz = min_t(unsigned short, host->max_segs, SG_MAX_SINGLE_ALLOC);
-	max_seg_sz = min_t(unsigned short, max_seg_sz, pktlist->qlen);
-	seg_sz = pktlist->qlen;
+	max_seg_sz = min_t(unsigned short, max_seg_sz, target_list->qlen);
+	seg_sz = target_list->qlen;
 	pkt_offset = 0;
-	pkt_next = pktlist->next;
+	pkt_next = target_list->next;
 
-	if (sg_alloc_table(&st, max_seg_sz, GFP_KERNEL))
-		return -ENOMEM;
+	if (sg_alloc_table(&st, max_seg_sz, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto exit;
+	}
 
 	while (seg_sz) {
 		req_sz = 0;
@@ -396,7 +425,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		memset(&mmc_dat, 0, sizeof(struct mmc_data));
 		sgl = st.sgl;
 		/* prep sg table */
-		while (pkt_next != (struct sk_buff *)pktlist) {
+		while (pkt_next != (struct sk_buff *)target_list) {
 			pkt_data = pkt_next->data + pkt_offset;
 			sg_data_sz = pkt_next->len - pkt_offset;
 			if (sg_data_sz > host->max_seg_size)
@@ -423,8 +452,8 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		if (req_sz % func_blk_sz != 0) {
 			brcmf_err("sg request length %u is not %u aligned\n",
 				  req_sz, func_blk_sz);
-			sg_free_table(&st);
-			return -ENOTBLK;
+			ret = -ENOTBLK;
+			goto exit;
 		}
 		mmc_dat.sg = st.sgl;
 		mmc_dat.sg_len = sg_cnt;
@@ -457,7 +486,34 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 		}
 	}
 
+	if (sdiodev->pdata && sdiodev->pdata->broken_sg_support && !write) {
+		local_pkt_next = local_list.next;
+		orig_offset = 0;
+		skb_queue_walk(pktlist, pkt_next) {
+			dst_offset = 0;
+			do {
+				req_sz = local_pkt_next->len - orig_offset;
+				req_sz = min_t(uint, pkt_next->len - dst_offset,
+					       req_sz);
+				orig_data = local_pkt_next->data + orig_offset;
+				dst_data = pkt_next->data + dst_offset;
+				memcpy(dst_data, orig_data, req_sz);
+				orig_offset += req_sz;
+				dst_offset += req_sz;
+				if (orig_offset == local_pkt_next->len) {
+					orig_offset = 0;
+					local_pkt_next = local_pkt_next->next;
+				}
+				if (dst_offset == pkt_next->len)
+					break;
+			} while (!skb_queue_empty(&local_list));
+		}
+	}
+
+exit:
 	sg_free_table(&st);
+	while ((pkt_next = __skb_dequeue(&local_list)) != NULL)
+		brcmu_pkt_buf_free_skb(pkt_next);
 
 	return ret;
 }
diff --git a/include/linux/platform_data/brcmfmac-sdio.h b/include/linux/platform_data/brcmfmac-sdio.h
index 1ade657..b717499 100644
--- a/include/linux/platform_data/brcmfmac-sdio.h
+++ b/include/linux/platform_data/brcmfmac-sdio.h
@@ -90,6 +90,10 @@ void __init brcmfmac_init_pdata(void)
  * oob_irq_nr, oob_irq_flags: the OOB interrupt information. The values are
  * used for registering the irq using request_irq function.
  *
+ * broken_sg_support: flag for broken sg list support of SDIO host controller.
+ * Set this to true if the SDIO host controller has higher align requirement
+ * than 32 bytes for each scatterlist item.
+ *
  * power_on: This function is called by the brcmfmac when the module gets
  * loaded. This can be particularly useful for low power devices. The platform
  * spcific routine may for example decide to power up the complete device.
@@ -116,6 +120,7 @@ struct brcmfmac_sdio_platform_data {
 	bool oob_irq_supported;
 	unsigned int oob_irq_nr;
 	unsigned long oob_irq_flags;
+	bool broken_sg_support;
 	void (*power_on)(void);
 	void (*power_off)(void);
 	void (*reset)(void);
-- 
1.7.10.4


