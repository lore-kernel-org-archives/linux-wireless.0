Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:48217 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358AbcCAPgi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 10:36:38 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] staging: rtl8723au: core: rtw_recv: use list_first_entry()
Date: Tue,  1 Mar 2016 23:35:33 +0800
Message-Id: <02a8be1627748f73df967fe4e55d98f6f0b01562.1456845896.git.geliangtang@163.com> (sfid-20160301_163822_946845_38487405)
In-Reply-To: <cover.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com>
In-Reply-To: <ad37740a77700b2c0ebb5b3d8977a78af6874067.1456845896.git.geliangtang@163.com>
References: <cover.1456845896.git.geliangtang@163.com> <f7e4ee69330e0a135625aaf9d99502e5798f0a32.1456845896.git.geliangtang@163.com> <ad37740a77700b2c0ebb5b3d8977a78af6874067.1456845896.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use list_first_entry() instead of container_of() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/staging/rtl8723au/core/rtw_recv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index a4dacc3..ceb4a07 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1522,7 +1522,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
-	struct list_head *plist, *phead;
+	struct list_head *phead;
 	u8 wlanhdr_offset;
 	u8 curfragnum;
 	struct recv_frame *pnfhdr, *ptmp;
@@ -1534,8 +1534,7 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
 
 	phead = get_list_head(defrag_q);
-	plist = phead->next;
-	prframe = container_of(plist, struct recv_frame, list);
+	prframe = list_first_entry(phead, struct recv_frame, list);
 	list_del_init(&prframe->list);
 	skb = prframe->pkt;
 
-- 
2.5.0


