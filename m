Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:60527 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423226AbcBQNs7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 08:48:59 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] staging: rtl8723au: core: rtw_recv: remove useless codes
Date: Wed, 17 Feb 2016 21:48:24 +0800
Message-Id: <9d4d1b0ad0a2401c6735992831daf68857513872.1455715186.git.geliangtang@163.com> (sfid-20160217_144941_324527_C16D890F)
In-Reply-To: <cover.1455715186.git.geliangtang@163.com>
References: <cover.1455715186.git.geliangtang@163.com>
In-Reply-To: <bd3727aef9540d81cbd558b0666e630cd0a90950.1455715186.git.geliangtang@163.com>
References: <cover.1455715186.git.geliangtang@163.com> <bd3727aef9540d81cbd558b0666e630cd0a90950.1455715186.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some useless codes in rtw_free_recvframe23a_queue() and
recvframe_defrag(), so remove them.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index bd93e76..d1e0f65 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -200,7 +200,6 @@ static void rtw_free_recvframe23a_queue(struct rtw_queue *pframequeue)
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


