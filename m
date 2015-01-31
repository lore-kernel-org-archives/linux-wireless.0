Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40891 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbbAaO62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 09:58:28 -0500
Received: by mail-wi0-f179.google.com with SMTP id l15so7616157wiw.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 06:58:27 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Greg Donald <gdonald@gmail.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_recv: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:01:48 +0100
Message-Id: <1422716508-4246-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_155831_939923_B0C49F07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_recv.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 559ddde..6068990 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1561,7 +1561,6 @@ static int wlanhdr_to_ethhdr (struct recv_frame *precvframe)
 		*ptr = 0x87;
 		*(ptr + 1) = 0x12;
 
-		eth_type = 0x8712;
 		/*  append rx status for mp test packets */
 
 		ptr = skb_pull(skb, (hdrlen - sizeof(struct ethhdr) + 2) - 24);
@@ -1591,17 +1590,15 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 				    struct rtw_queue *defrag_q)
 {
 	struct list_head *plist, *phead, *ptmp;
-	u8	*data, wlanhdr_offset;
+	u8	wlanhdr_offset;
 	u8	curfragnum;
 	struct recv_frame *pnfhdr;
-	struct recv_frame *prframe, *pnextrframe;
-	struct rtw_queue	*pfree_recv_queue;
+	struct recv_frame *prframe;
 	struct sk_buff *skb;
 
 
 
 	curfragnum = 0;
-	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
 
 	phead = get_list_head(defrag_q);
 	plist = phead->next;
@@ -1622,11 +1619,8 @@ struct recv_frame *recvframe_defrag(struct rtw_adapter *adapter,
 
 	phead = get_list_head(defrag_q);
 
-	data = prframe->pkt->data;
-
 	list_for_each_safe(plist, ptmp, phead) {
 		pnfhdr = container_of(plist, struct recv_frame, list);
-		pnextrframe = (struct recv_frame *)pnfhdr;
 		/* check the fragment sequence  (2nd ~n fragment frame) */
 
 		if (curfragnum != pnfhdr->attrib.frag_num) {
@@ -1684,7 +1678,7 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 	struct sta_priv *pstapriv;
 	struct list_head *phead;
 	struct recv_frame *prtnframe = NULL;
-	struct rtw_queue *pfree_recv_queue, *pdefrag_q;
+	struct rtw_queue *pdefrag_q;
 
 
 
@@ -1692,8 +1686,6 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 
 	pfhdr = precv_frame;
 
-	pfree_recv_queue = &padapter->recvpriv.free_recv_queue;
-
 	/* need to define struct of wlan header frame ctrl */
 	ismfrag = pfhdr->attrib.mfrag;
 	fragnum = pfhdr->attrib.frag_num;
@@ -1798,12 +1790,9 @@ struct recv_frame *recvframe_chk_defrag23a(struct rtw_adapter *padapter,
 int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe);
 int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 {
-	struct rx_pkt_attrib *pattrib;
 	struct sk_buff *skb, *sub_skb;
 	struct sk_buff_head skb_list;
 
-	pattrib = &prframe->attrib;
-
 	skb = prframe->pkt;
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
@@ -1921,10 +1910,8 @@ int recv_indicatepkts_in_order(struct rtw_adapter *padapter,
 	struct rx_pkt_attrib *pattrib;
 	/* u8 index = 0; */
 	int bPktInBuf = false;
-	struct recv_priv *precvpriv;
 	struct rtw_queue *ppending_recvframe_queue;
 
-	precvpriv = &padapter->recvpriv;
 	ppending_recvframe_queue = &preorder_ctrl->pending_recvframe_queue;
 	/* DbgPrint("+recv_indicatepkts_in_order\n"); */
 
-- 
1.7.10.4

