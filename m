Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1340 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab1JUOQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:48 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 13/17] brcm80211: smac: use sk_buff list for handling
 frames in receive path
Date: Fri, 21 Oct 2011 16:16:31 +0200
Message-ID: <1319206595-17138-14-git-send-email-arend@broadcom.com> (sfid-20111021_161723_872645_00EC1953)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the receive path the frames are obtained from the dma using
multiple sk_buff that were linked using the skb next pointer.
This has been changed and it now used sk_buff lists and skb_queue
functions instead.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c  |   38 ++++++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/dma.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   21 +++++--------
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 08960ce..ae541fb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -14,7 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <linux/slab.h>
-#include <linux/skbuff.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 
@@ -901,7 +900,7 @@ static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall)
 
 /*
  * !! rx entry routine
- * returns a pointer to the next frame received, or NULL if there are no more
+ * returns the number packages in the next frame, or 0 if there are no more
  *   if DMA_CTRL_RXMULTI is defined, DMA scattering(multiple buffers) is
  *   supported with pkts chain
  *   otherwise, it's treated as giant pkt and will be tossed.
@@ -909,38 +908,40 @@ static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall)
  *   buffer data. After it reaches the max size of buffer, the data continues
  *   in next DMA descriptor buffer WITHOUT DMA header
  */
-struct sk_buff *dma_rx(struct dma_pub *pub)
+int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 {
 	struct dma_info *di = (struct dma_info *)pub;
-	struct sk_buff *p, *head, *tail;
+	struct sk_buff_head dma_frames;
+	struct sk_buff *p, *next;
 	uint len;
 	uint pkt_len;
 	int resid = 0;
+	int pktcnt = 1;
 
+	skb_queue_head_init(&dma_frames);
  next_frame:
-	head = _dma_getnextrxp(di, false);
-	if (head == NULL)
-		return NULL;
+	p = _dma_getnextrxp(di, false);
+	if (p == NULL)
+		return 0;
 
-	len = le16_to_cpu(*(__le16 *) (head->data));
+	len = le16_to_cpu(*(__le16 *) (p->data));
 	DMA_TRACE(("%s: dma_rx len %d\n", di->name, len));
-	dma_spin_for_len(len, head);
+	dma_spin_for_len(len, p);
 
 	/* set actual length */
 	pkt_len = min((di->rxoffset + len), di->rxbufsize);
-	__skb_trim(head, pkt_len);
+	__skb_trim(p, pkt_len);
+	skb_queue_tail(&dma_frames, p);
 	resid = len - (di->rxbufsize - di->rxoffset);
 
 	/* check for single or multi-buffer rx */
 	if (resid > 0) {
-		tail = head;
 		while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
-			tail->next = p;
 			pkt_len = min_t(uint, resid, di->rxbufsize);
 			__skb_trim(p, pkt_len);
-
-			tail = p;
+			skb_queue_tail(&dma_frames, p);
 			resid -= di->rxbufsize;
+			pktcnt++;
 		}
 
 #ifdef BCMDBG
@@ -959,13 +960,18 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
 		if ((di->dma.dmactrlflags & DMA_CTRL_RXMULTI) == 0) {
 			DMA_ERROR(("%s: dma_rx: bad frame length (%d)\n",
 				   di->name, len));
-			brcmu_pkt_buf_free_skb(head);
+			skb_queue_walk_safe(&dma_frames, p, next) {
+				skb_unlink(p, &dma_frames);
+				brcmu_pkt_buf_free_skb(p);
+			}
 			di->dma.rxgiants++;
+			pktcnt = 1;
 			goto next_frame;
 		}
 	}
 
-	return head;
+	skb_queue_splice_tail(&dma_frames, skb_list);
+	return pktcnt;
 }
 
 static bool dma64_rxidle(struct dma_info *di)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index ebc5bc5..d317c7c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -18,6 +18,7 @@
 #define	_BRCM_DMA_H_
 
 #include <linux/delay.h>
+#include <linux/skbuff.h>
 #include "types.h"		/* forward structure declarations */
 
 /* map/unmap direction */
@@ -80,7 +81,7 @@ extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
 
 void dma_rxinit(struct dma_pub *pub);
-struct sk_buff *dma_rx(struct dma_pub *pub);
+int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list);
 bool dma_rxfill(struct dma_pub *pub);
 bool dma_rxreset(struct dma_pub *pub);
 bool dma_txreset(struct dma_pub *pub);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 3f8a6c7..f193fab 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -8115,21 +8115,17 @@ static bool
 brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 {
 	struct sk_buff *p;
-	struct sk_buff *head = NULL;
-	struct sk_buff *tail = NULL;
+	struct sk_buff *next = NULL;
+	struct sk_buff_head recv_frames;
+
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-	/* gather received frames */
-	while ((p = dma_rx(wlc_hw->di[fifo]))) {
+	skb_queue_head_init(&recv_frames);
 
-		if (!tail)
-			head = tail = p;
-		else {
-			tail->prev = p;
-			tail = p;
-		}
+	/* gather received frames */
+	while (dma_rx(wlc_hw->di[fifo], &recv_frames)) {
 
 		/* !give others some time to run! */
 		if (++n >= bound_limit)
@@ -8140,12 +8136,11 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	dma_rxfill(wlc_hw->di[fifo]);
 
 	/* process each frame */
-	while ((p = head) != NULL) {
+	skb_queue_walk_safe(&recv_frames, p, next) {
 		struct d11rxhdr_le *rxh_le;
 		struct d11rxhdr *rxh;
-		head = head->prev;
-		p->prev = NULL;
 
+		skb_unlink(p, &recv_frames);
 		rxh_le = (struct d11rxhdr_le *)p->data;
 		rxh = (struct d11rxhdr *)p->data;
 
-- 
1.7.4.1


