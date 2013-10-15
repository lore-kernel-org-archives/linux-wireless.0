Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4376 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759239Ab3JONpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/12] brcmfmac: rename brcmf_sdio_buffrw()
Date: Tue, 15 Oct 2013 15:44:51 +0200
Message-ID: <1381844697-24881-7-git-send-email-arend@broadcom.com> (sfid-20131015_154530_997957_75C7A755)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_sdio_buffrw() is intended to be used for
transfering list of packets using scatter-gather functionality.
Rename function to brcmf_sdio_sglist_rw() to clarify this.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index ea716a4..344b2d2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -315,7 +315,7 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 }
 
 /**
- * brcmf_sdio_buffrw - SDIO interface function for block data access
+ * brcmf_sdio_sglist_rw - SDIO interface function for block data access
  * @sdiodev: brcmfmac sdio device
  * @fn: SDIO function number
  * @write: direction flag
@@ -326,8 +326,9 @@ void brcmf_sdio_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
  * stack for block data access. It assumes that the skb passed down by the
  * caller has already been padded and aligned.
  */
-static int brcmf_sdio_buffrw(struct brcmf_sdio_dev *sdiodev, uint fn,
-			     bool write, u32 addr, struct sk_buff_head *pktlist)
+static int brcmf_sdio_sglist_rw(struct brcmf_sdio_dev *sdiodev, uint fn,
+				bool write, u32 addr,
+				struct sk_buff_head *pktlist)
 {
 	unsigned int req_sz, func_blk_sz, sg_cnt, sg_data_sz, pkt_offset;
 	unsigned int max_req_sz, orig_offset, dst_offset;
@@ -554,7 +555,7 @@ brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 
 	skb_queue_head_init(&pkt_list);
 	skb_queue_tail(&pkt_list, pkt);
-	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, &pkt_list);
+	err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, &pkt_list);
 	skb_dequeue_tail(&pkt_list);
 
 done:
@@ -577,7 +578,7 @@ int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 		goto done;
 
 	incr_fix = (flags & SDIO_REQ_FIXED) ? SDIOH_DATA_FIX : SDIOH_DATA_INC;
-	err = brcmf_sdio_buffrw(sdiodev, fn, false, addr, pktq);
+	err = brcmf_sdio_sglist_rw(sdiodev, fn, false, addr, pktq);
 
 done:
 	return err;
@@ -622,7 +623,7 @@ brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 	width = (flags & SDIO_REQ_4BYTE) ? 4 : 2;
 	brcmf_sdio_addrprep(sdiodev, width, &addr);
 
-	err = brcmf_sdio_buffrw(sdiodev, fn, true, addr, pktq);
+	err = brcmf_sdio_sglist_rw(sdiodev, fn, true, addr, pktq);
 
 	return err;
 }
@@ -673,8 +674,8 @@ brcmf_sdio_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		if (write)
 			memcpy(pkt->data, data, dsize);
 		skb_queue_tail(&pkt_list, pkt);
-		bcmerror = brcmf_sdio_buffrw(sdiodev, SDIO_FUNC_1, write,
-					     sdaddr, &pkt_list);
+		bcmerror = brcmf_sdio_sglist_rw(sdiodev, SDIO_FUNC_1, write,
+						sdaddr, &pkt_list);
 		skb_dequeue_tail(&pkt_list);
 		if (bcmerror) {
 			brcmf_err("membytes transfer failed\n");
-- 
1.7.10.4


