Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2846 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759237Ab3JONpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/12] brcmfmac: rename variable max_seg_sz to
 max_seg_cnt for clarity
Date: Tue, 15 Oct 2013 15:44:48 +0200
Message-ID: <1381844697-24881-4-git-send-email-arend@broadcom.com> (sfid-20131015_154533_574521_03949C01)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable max_seg_sz in brcmf_sdio_buffrw() respresents the maximum
number of buffers that can be sent in one MMC transfer request. Rename
it to max_seg_cnt to avoid confusion.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e13b1a6..5dfc96c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -332,7 +332,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
 	unsigned int max_blks, max_req_sz, orig_offset, dst_offset;
-	unsigned short max_seg_sz, seg_sz;
+	unsigned short max_seg_cnt, seg_sz;
 	unsigned char *pkt_data, *orig_data, *dst_data;
 	struct sk_buff *pkt_next = NULL, *local_pkt_next;
 	struct sk_buff_head local_list, *target_list;
@@ -406,13 +406,14 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 	max_blks = min_t(unsigned int, host->max_blk_count, 511u);
 	max_req_sz = min_t(unsigned int, host->max_req_size,
 			   max_blks * func_blk_sz);
-	max_seg_sz = min_t(unsigned short, host->max_segs, SG_MAX_SINGLE_ALLOC);
-	max_seg_sz = min_t(unsigned short, max_seg_sz, target_list->qlen);
+	max_seg_cnt = min_t(unsigned short, host->max_segs,
+			    SG_MAX_SINGLE_ALLOC);
+	max_seg_cnt = min_t(unsigned short, max_seg_cnt, target_list->qlen);
 	seg_sz = target_list->qlen;
 	pkt_offset = 0;
 	pkt_next = target_list->next;
 
-	if (sg_alloc_table(&st, max_seg_sz, GFP_KERNEL)) {
+	if (sg_alloc_table(&st, max_seg_cnt, GFP_KERNEL)) {
 		ret = -ENOMEM;
 		goto exit;
 	}
@@ -444,7 +445,7 @@ static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
 				pkt_next = pkt_next->next;
 			}
 
-			if (req_sz >= max_req_sz || sg_cnt >= max_seg_sz)
+			if (req_sz >= max_req_sz || sg_cnt >= max_seg_cnt)
 				break;
 		}
 		seg_sz -= sg_cnt;
-- 
1.7.10.4


