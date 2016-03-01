Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:47211 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbcCAPgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:36:37 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] staging: rtl8723au: core: rtw_recv: use list_first_entry_or_null()
Date: Tue,  1 Mar 2016 23:35:31 +0800
Message-Id: <f7e4ee69330e0a135625aaf9d99502e5798f0a32.1456845896.git.geliangtang@163.com> (sfid-20160301_163758_388688_D97E97F4)
In-Reply-To: <cover.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com>
In-Reply-To: <cover.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_first_entry_or_null() instead of list_empty() + container_of()
to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 42 ++++++++-----------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 0a7741c..a4dacc3 100644
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
@@ -247,21 +240,13 @@ struct recv_buf *rtw_dequeue_recvbuf23a (struct rtw_queue *queue)
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
-- 
2.5.0


