Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:37148 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbcBWAjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 19:39:08 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: use list_first_entry*
Date: Tue, 23 Feb 2016 08:38:01 +0800
Message-Id: <d02bee6044ac90c6b2d0d08a351ba6828fbe35d8.1456187207.git.geliangtang@163.com> (sfid-20160223_013914_020914_9F47F8EA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_first_entry*() instead of container_of() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 49 +++++++++----------------------
 drivers/staging/rtl8723au/core/rtw_xmit.c | 26 +++++-----------
 2 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 0a7741c..b095d09 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -104,21 +104,14 @@ void _rtw_free_recv_priv23a(struct recv_priv *precvpriv)
 struct recv_frame *rtw_alloc_recvframe23a(struct rtw_queue *pfree_recv_queue)
 {
 	struct recv_frame *pframe;
-	struct list_head *plist, *phead;
 	struct rtw_adapter *padapter;
 	struct recv_priv *precvpriv;
 
 	spin_lock_bh(&pfree_recv_queue->lock);
 
-	if (list_empty(&pfree_recv_queue->queue))
-		pframe = NULL;
-	else {
-		phead = get_list_head(pfree_recv_queue);
-
-		plist = phead->next;
-
-		pframe = container_of(plist, struct recv_frame, list);
-
+	pframe = list_first_entry_or_null(&pfree_recv_queue->queue,
+					  struct recv_frame, list);
+	if (pframe) {
 		list_del_init(&pframe->list);
 		padapter = pframe->adapter;
 		if (padapter) {
@@ -243,25 +236,17 @@ int rtw_enqueue_recvbuf23a(struct recv_buf *precvbuf, struct rtw_queue *queue)
 	return _SUCCESS;
 }
 
-struct recv_buf *rtw_dequeue_recvbuf23a (struct rtw_queue *queue)
+struct recv_buf *rtw_dequeue_recvbuf23a(struct rtw_queue *queue)
 {
 	unsigned long irqL;
 	struct recv_buf *precvbuf;
-	struct list_head *plist, *phead;
 
 	spin_lock_irqsave(&queue->lock, irqL);
 
-	if (list_empty(&queue->queue)) {
-		precvbuf = NULL;
-	} else {
-		phead = get_list_head(queue);
-
-		plist = phead->next;
-
-		precvbuf = container_of(plist, struct recv_buf, list);
-
+	precvbuf = list_first_entry_or_null(&queue->queue,
+					    struct recv_buf, list);
+	if (precvbuf)
 		list_del_init(&precvbuf->list);
-	}
 
 	spin_unlock_irqrestore(&queue->lock, irqL);
 
@@ -1079,22 +1064,17 @@ static int validate_recv_ctrl_frame(struct rtw_adapter *padapter,
 
 		if ((psta->state & WIFI_SLEEP_STATE) &&
 		    (pstapriv->sta_dz_bitmap & CHKBIT(psta->aid))) {
-			struct list_head *xmitframe_plist, *xmitframe_phead;
+			struct list_head *xmitframe_phead;
 			struct xmit_frame *pxmitframe;
 			struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
 			spin_lock_bh(&pxmitpriv->lock);
 
 			xmitframe_phead = get_list_head(&psta->sleep_q);
-			xmitframe_plist = xmitframe_phead->next;
-
-			if (!list_empty(xmitframe_phead)) {
-				pxmitframe = container_of(xmitframe_plist,
-							  struct xmit_frame,
-							  list);
-
-				xmitframe_plist = xmitframe_plist->next;
-
+			pxmitframe = list_first_entry_or_null(xmitframe_phead,
+							      struct xmit_frame,
+							      list);
+			if (pxmitframe) {
 				list_del_init(&pxmitframe->list);
 
 				psta->sleepq_len--;
@@ -1542,7 +1522,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	u8 wlanhdr_offset;
 	u8 curfragnum;
 	struct recv_frame *pnfhdr, *ptmp;
@@ -1554,8 +1534,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
 
 	phead = get_list_head(defrag_q);
-	plist = phead->next;
-	prframe = container_of(plist, struct recv_frame, list);
+	prframe = list_first_entry(phead, struct recv_frame, list);
 	list_del_init(&prframe->list);
 	skb = prframe->pkt;
 
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index b82b182..3de40cf 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -1443,24 +1443,18 @@ Must be very very cautious...
 */
 static struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 {
-	struct xmit_frame *pxframe = NULL;
-	struct list_head *plist, *phead;
+	struct xmit_frame *pxframe;
 	struct rtw_queue *pfree_xmit_queue = &pxmitpriv->free_xmit_queue;
 
 	spin_lock_bh(&pfree_xmit_queue->lock);
 
-	if (list_empty(&pfree_xmit_queue->queue)) {
+	pxframe = list_first_entry_or_null(&pfree_xmit_queue->queue,
+					   struct xmit_frame, list);
+	if (!pxframe) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
 			 "rtw_alloc_xmitframe:%d\n",
 			 pxmitpriv->free_xmitframe_cnt);
-		pxframe =  NULL;
 	} else {
-		phead = get_list_head(pfree_xmit_queue);
-
-		plist = phead->next;
-
-		pxframe = container_of(plist, struct xmit_frame, list);
-
 		list_del_init(&pxframe->list);
 		pxmitpriv->free_xmitframe_cnt--;
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
@@ -1477,22 +1471,18 @@ static struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 
 struct xmit_frame *rtw_alloc_xmitframe23a_ext(struct xmit_priv *pxmitpriv)
 {
-	struct xmit_frame *pxframe = NULL;
-	struct list_head *plist, *phead;
+	struct xmit_frame *pxframe;
 	struct rtw_queue *queue = &pxmitpriv->free_xframe_ext_queue;
 
 	spin_lock_bh(&queue->lock);
 
-	if (list_empty(&queue->queue)) {
+	pxframe = list_first_entry_or_null(&queue->queue,
+					   struct xmit_frame, list);
+	if (!pxframe) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
 			 "rtw_alloc_xmitframe23a_ext:%d\n",
 			 pxmitpriv->free_xframe_ext_cnt);
-		pxframe =  NULL;
 	} else {
-		phead = get_list_head(queue);
-		plist = phead->next;
-		pxframe = container_of(plist, struct xmit_frame, list);
-
 		list_del_init(&pxframe->list);
 		pxmitpriv->free_xframe_ext_cnt--;
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_,
-- 
2.5.0


