Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:45306 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425356AbcBROUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 09:20:33 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] staging: rtl8723au: core: rtw_recv: remove useless codes
Date: Thu, 18 Feb 2016 22:19:30 +0800
Message-Id: <30e1fa83bf812ef6f56221165a278560064150d7.1455804404.git.geliangtang@163.com> (sfid-20160218_152040_610396_0EEC9377)
In-Reply-To: <cover.1455804404.git.geliangtang@163.com>
References: <cover.1455804404.git.geliangtang@163.com>
In-Reply-To: <b11787ff9cdc31b4335a654d88affd2dd229bc14.1455804404.git.geliangtang@163.com>
References: <cover.1455804404.git.geliangtang@163.com> <b11787ff9cdc31b4335a654d88affd2dd229bc14.1455804404.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some useless codes in rtw_free_recvframe23a_queue() and
recvframe_defrag(), so remove them.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 0b4593c..d1e0f65 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -195,12 +195,11 @@ using spinlock to protect
 static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
 {
 	struct recv_frame *hdr, *ptmp;
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 
 	spin_lock(&pframequeue->lock);
 
 	phead = get_list_head(pframequeue);
-	plist = phead->next;
 
 	list_for_each_entry_safe(hdr, ptmp, phead, list)
 		rtw_free_recvframe23a(hdr);
@@ -1547,7 +1546,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
 	struct list_head *plist, *phead;
-	u8	*data, wlanhdr_offset;
+	u8	wlanhdr_offset;
 	u8	curfragnum;
 	struct recv_frame *pnfhdr, *ptmp;
 	struct recv_frame *prframe, *pnextrframe;
@@ -1576,10 +1575,6 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 
 	curfragnum++;
 
-	phead = get_list_head(defrag_q);
-
-	data = prframe->pkt->data;
-
 	list_for_each_entry_safe(pnfhdr, ptmp, phead, list) {
 		pnextrframe = (struct recv_frame *)pnfhdr;
 		/* check the fragment sequence  (2nd ~n fragment frame) */
-- 
2.5.0


