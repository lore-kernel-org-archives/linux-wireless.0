Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:50036 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbcBGDbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 22:31:02 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] staging: rtl8723au: core: rtw_recv: remove useless codes
Date: Sun,  7 Feb 2016 11:29:59 +0800
Message-Id: <eab3a03d1254ca4e8089a72fdd31620b35d8f46f.1454815347.git.geliangtang@163.com> (sfid-20160207_043200_841674_44F201A3)
In-Reply-To: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
References: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
In-Reply-To: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
References: <74d9cc12c94c351d2961d20a8d9f8a2dcdaed4b9.1454815347.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some useless codes in rtw_free_recvframe23a_queue() and
recvframe_defrag(), so remove them.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v3:
 - split it into three patches.
Changes in v2:
 - drop the coding style fixing in v1.
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 18b7d03..b36bc6b 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -201,7 +201,6 @@ static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
 	spin_lock(&pframequeue->lock);
 
 	phead = get_list_head(pframequeue);
-	plist = phead->next;
 
 	list_for_each_entry_safe(hdr, ptmp, phead, list) {
 		rtw_free_recvframe23a(hdr);
@@ -1567,7 +1566,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
 	struct list_head *plist, *phead;
-	u8	*data, wlanhdr_offset;
+	u8	wlanhdr_offset;
 	u8	curfragnum;
 	struct recv_frame *pnfhdr, *ptmp;
 	struct recv_frame *prframe, *pnextrframe;
@@ -1596,10 +1595,6 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 
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


