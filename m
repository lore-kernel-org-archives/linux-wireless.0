Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE22EC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 00:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FF4E208A3
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 00:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FF4E208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=davemloft.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbeKKKUz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 05:20:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbeKKKUz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 05:20:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::cf9])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D924145DAF39;
        Sat, 10 Nov 2018 16:34:05 -0800 (PST)
Date:   Sat, 10 Nov 2018 16:34:02 -0800 (PST)
Message-Id: <20181110.163402.130407398146253939.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     linux-wireless@vger.kernel.org
Subject: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 10 Nov 2018 16:34:05 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


[ As I am trying to remove direct SKB list pointer accesses I am
  committing this to net-next.  If this causes a lot of grief I
  can and will revert, just let me know. ]

Instead of direct SKB list pointer accesses.

The loops in this function had to be rewritten to accommodate this
more easily.

The first loop iterates now over the target list in the outer loop,
and triggers an mmc data operation when the per-operation limits are
hit.

Then after the loops, if we have any residue, we trigger the last
and final operation.

For the page aligned workaround, where we have to copy the read data
back into the original list of SKBs, we use a two-tiered loop.  The
outer loop stays the same and iterates over pktlist, and then we have
an inner loop which uses skb_peek_next().  The break logic has been
simplified because we know that the aggregate length of the SKBs in
the source and destination lists are the same.

This change also ends up fixing a bug, having to do with the
maintainance of the seg_sz variable and how it drove the outermost
loop.  It begins as:

	seg_sz = target_list->qlen;

ie. the number of packets in the target_list queue.  The loop
structure was then:

	while (seq_sz) {
		...
		while (not at end of target_list) {
			...
			sg_cnt++
			...
		}
		...
		seg_sz -= sg_cnt;

The assumption built into that last statement is that sg_cnt counts
how many packets from target_list have been fully processed by the
inner loop.  But this not true.

If we hit one of the limits, such as the max segment size or the max
request size, we will break and copy a partial packet then contine
back up to the top of the outermost loop.

With the new loops we don't have this problem as we don't guard the
loop exit with a packet count, but instead use the progression of the
pkt_next SKB through the list to the end.  The general structure is:

	sg_cnt = 0;
	skb_queue_walk(target_list, pkt_next) {
		pkt_offset = 0;
		...
		sg_cnt++;
		...
		while (pkt_offset < pkt_next->len) {
			pkt_offset += sg_data_size;
			if (queued up max per request)
				mmc_submit_one();
		}
	}
	if (sg_cnt)
		mmc_submit_one();

The variables that maintain where we are in the MMC command state such
as req_sz, sg_cnt, and sgl are reset when we emit one of these full
sized requests.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 137 ++++++++++--------
 1 file changed, 74 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 3e37c8cf82c6..b2ad2122c8c4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -342,6 +342,37 @@ static int brcmf_sdiod_skbuff_write(struct brcmf_sdio_dev *sdiodev,
 	return err;
 }
 
+static int mmc_submit_one(struct mmc_data *md, struct mmc_request *mr,
+			  struct mmc_command *mc, int sg_cnt, int req_sz,
+			  int func_blk_sz, u32 *addr,
+			  struct brcmf_sdio_dev *sdiodev,
+			  struct sdio_func *func, int write)
+{
+	int ret;
+
+	md->sg_len = sg_cnt;
+	md->blocks = req_sz / func_blk_sz;
+	mc->arg |= (*addr & 0x1FFFF) << 9;	/* address */
+	mc->arg |= md->blocks & 0x1FF;	/* block count */
+	/* incrementing addr for function 1 */
+	if (func->num == 1)
+		*addr += req_sz;
+
+	mmc_set_data_timeout(md, func->card);
+	mmc_wait_for_req(func->card->host, mr);
+
+	ret = mc->error ? mc->error : md->error;
+	if (ret == -ENOMEDIUM) {
+		brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
+	} else if (ret != 0) {
+		brcmf_err("CMD53 sg block %s failed %d\n",
+			  write ? "write" : "read", ret);
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
 /**
  * brcmf_sdiod_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
@@ -360,11 +391,11 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
 				 struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
-	unsigned int max_req_sz, orig_offset, dst_offset;
-	unsigned short max_seg_cnt, seg_sz;
+	unsigned int max_req_sz, src_offset, dst_offset;
 	unsigned char *pkt_data, *orig_data, *dst_data;
-	struct sk_buff *pkt_next = NULL, *local_pkt_next;
 	struct sk_buff_head local_list, *target_list;
+	struct sk_buff *pkt_next = NULL, *src;
+	unsigned short max_seg_cnt;
 	struct mmc_request mmc_req;
 	struct mmc_command mmc_cmd;
 	struct mmc_data mmc_dat;
@@ -404,9 +435,6 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
 	max_req_sz = sdiodev->max_request_size;
 	max_seg_cnt = min_t(unsigned short, sdiodev->max_segment_count,
 			    target_list->qlen);
-	seg_sz = target_list->qlen;
-	pkt_offset = 0;
-	pkt_next = target_list->next;
 
 	memset(&mmc_req, 0, sizeof(struct mmc_request));
 	memset(&mmc_cmd, 0, sizeof(struct mmc_command));
@@ -425,12 +453,12 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
 	mmc_req.cmd = &mmc_cmd;
 	mmc_req.data = &mmc_dat;
 
-	while (seg_sz) {
-		req_sz = 0;
-		sg_cnt = 0;
-		sgl = sdiodev->sgtable.sgl;
-		/* prep sg table */
-		while (pkt_next != (struct sk_buff *)target_list) {
+	req_sz = 0;
+	sg_cnt = 0;
+	sgl = sdiodev->sgtable.sgl;
+	skb_queue_walk(target_list, pkt_next) {
+		pkt_offset = 0;
+		while (pkt_offset < pkt_next->len) {
 			pkt_data = pkt_next->data + pkt_offset;
 			sg_data_sz = pkt_next->len - pkt_offset;
 			if (sg_data_sz > sdiodev->max_segment_size)
@@ -439,72 +467,55 @@ static int brcmf_sdiod_sglist_rw(struct brcmf_sdio_dev *sdiodev,
 				sg_data_sz = max_req_sz - req_sz;
 
 			sg_set_buf(sgl, pkt_data, sg_data_sz);
-
 			sg_cnt++;
+
 			sgl = sg_next(sgl);
 			req_sz += sg_data_sz;
 			pkt_offset += sg_data_sz;
-			if (pkt_offset == pkt_next->len) {
-				pkt_offset = 0;
-				pkt_next = pkt_next->next;
+			if (req_sz >= max_req_sz || sg_cnt >= max_seg_cnt) {
+				ret = mmc_submit_one(&mmc_dat, &mmc_req, &mmc_cmd,
+						     sg_cnt, req_sz, func_blk_sz,
+						     &addr, sdiodev, func, write);
+				if (ret)
+					goto exit_queue_walk;
+				req_sz = 0;
+				sg_cnt = 0;
+				sgl = sdiodev->sgtable.sgl;
 			}
-
-			if (req_sz >= max_req_sz || sg_cnt >= max_seg_cnt)
-				break;
-		}
-		seg_sz -= sg_cnt;
-
-		if (req_sz % func_blk_sz != 0) {
-			brcmf_err("sg request length %u is not %u aligned\n",
-				  req_sz, func_blk_sz);
-			ret = -ENOTBLK;
-			goto exit;
-		}
-
-		mmc_dat.sg_len = sg_cnt;
-		mmc_dat.blocks = req_sz / func_blk_sz;
-		mmc_cmd.arg |= (addr & 0x1FFFF) << 9;	/* address */
-		mmc_cmd.arg |= mmc_dat.blocks & 0x1FF;	/* block count */
-		/* incrementing addr for function 1 */
-		if (func->num == 1)
-			addr += req_sz;
-
-		mmc_set_data_timeout(&mmc_dat, func->card);
-		mmc_wait_for_req(func->card->host, &mmc_req);
-
-		ret = mmc_cmd.error ? mmc_cmd.error : mmc_dat.error;
-		if (ret == -ENOMEDIUM) {
-			brcmf_sdiod_change_state(sdiodev, BRCMF_SDIOD_NOMEDIUM);
-			break;
-		} else if (ret != 0) {
-			brcmf_err("CMD53 sg block %s failed %d\n",
-				  write ? "write" : "read", ret);
-			ret = -EIO;
-			break;
 		}
 	}
-
+	if (sg_cnt)
+		ret = mmc_submit_one(&mmc_dat, &mmc_req, &mmc_cmd,
+				     sg_cnt, req_sz, func_blk_sz,
+				     &addr, sdiodev, func, write);
+exit_queue_walk:
 	if (!write && sdiodev->settings->bus.sdio.broken_sg_support) {
-		local_pkt_next = local_list.next;
-		orig_offset = 0;
+		src = __skb_peek(&local_list);
+		src_offset = 0;
 		skb_queue_walk(pktlist, pkt_next) {
 			dst_offset = 0;
-			do {
-				req_sz = local_pkt_next->len - orig_offset;
-				req_sz = min_t(uint, pkt_next->len - dst_offset,
-					       req_sz);
-				orig_data = local_pkt_next->data + orig_offset;
+
+			/* This is safe because we must have enough SKB data
+			 * in the local list to cover everything in pktlist.
+			 */
+			while (1) {
+				req_sz = pkt_next->len - dst_offset;
+				if (req_sz > src->len - src_offset)
+					req_sz = src->len - src_offset;
+
+				orig_data = src->data + src_offset;
 				dst_data = pkt_next->data + dst_offset;
 				memcpy(dst_data, orig_data, req_sz);
-				orig_offset += req_sz;
-				dst_offset += req_sz;
-				if (orig_offset == local_pkt_next->len) {
-					orig_offset = 0;
-					local_pkt_next = local_pkt_next->next;
+
+				src_offset += req_sz;
+				if (src_offset == src->len) {
+					src_offset = 0;
+					src = skb_peek_next(src, &local_list);
 				}
+				dst_offset += req_sz;
 				if (dst_offset == pkt_next->len)
 					break;
-			} while (!skb_queue_empty(&local_list));
+			}
 		}
 	}
 
-- 
2.19.1

