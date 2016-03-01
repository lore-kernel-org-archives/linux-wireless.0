Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:48288 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbcCAPgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:36:39 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] staging: rtl8723au: core: rtw_xmit: use list_first_entry_or_null()
Date: Tue,  1 Mar 2016 23:35:32 +0800
Message-Id: <ad37740a77700b2c0ebb5b3d8977a78af6874067.1456845896.git.geliangtang@163.com> (sfid-20160301_163703_740135_5E95AFF7)
In-Reply-To: <cover.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com>
In-Reply-To: <f7e4ee69330e0a135625aaf9d99502e5798f0a32.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com> <f7e4ee69330e0a135625aaf9d99502e5798f0a32.1456845896.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_first_entry_or_null() instead of list_empty() + container_of()
to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_xmit.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

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


