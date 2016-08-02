Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web01.01d.eu ([5.200.27.195]:33022 "EHLO web01.01d.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbcHBTBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 15:01:30 -0400
From: Shiva Kerdel <shiva@exdev.nl>
To: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	geliangtang@163.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Shiva Kerdel <shiva@exdev.nl>
Subject: [PATCH] Staging: rtl8723au: rtw_xmit: Fixed operators spacing style issues
Date: Tue,  2 Aug 2016 20:05:30 +0200
Message-Id: <20160802180530.2594-1-shiva@exdev.nl> (sfid-20160802_210215_141086_F56A0045)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed spaces around operators to fix their coding style issues.

Signed-off-by: Shiva Kerdel <shiva@exdev.nl>
---
 drivers/staging/rtl8723au/core/rtw_xmit.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index 3de40cf..56228a5 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -174,7 +174,7 @@ int _rtw_init_xmit_priv23a(struct xmit_priv *pxmitpriv,
 	rtw_alloc_hwxmits23a(padapter);
 	rtw_init_hwxmits23a(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 
-	for (i = 0; i < 4; i ++)
+	for (i = 0; i < 4; i++)
 		pxmitpriv->wmm_para_seq[i] = i;
 
 	sema_init(&pxmitpriv->tx_retevt, 0);
@@ -421,7 +421,7 @@ static int update_attrib(struct rtw_adapter *padapter,
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	int res = _SUCCESS;
-	struct ethhdr *ehdr = (struct ethhdr *) skb->data;
+	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 	pattrib->ether_type = ntohs(ehdr->h_proto);
 
@@ -640,7 +640,7 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	int curfragnum, length;
 	u8 *pframe, *payload, mic[8];
-	u8 priority[4]= {0x0, 0x0, 0x0, 0x0};
+	u8 priority[4] = {0x0, 0x0, 0x0, 0x0};
 	u8 hw_hdr_offset = 0;
 	int bmcst = is_multicast_ether_addr(pattrib->ra);
 
@@ -667,10 +667,10 @@ static int xmitframe_addmic(struct rtw_adapter *padapter,
 	if (pattrib->encrypt == WLAN_CIPHER_SUITE_TKIP) {
 		/* encode mic code */
 		if (stainfo) {
-			u8 null_key[16]={0x0, 0x0, 0x0, 0x0,
-					 0x0, 0x0, 0x0, 0x0,
-					 0x0, 0x0, 0x0, 0x0,
-					 0x0, 0x0, 0x0, 0x0};
+			u8 null_key[16] = {0x0, 0x0, 0x0, 0x0,
+					   0x0, 0x0, 0x0, 0x0,
+					   0x0, 0x0, 0x0, 0x0,
+					   0x0, 0x0, 0x0, 0x0};
 
 			pframe = pxmitframe->buf_addr + hw_hdr_offset;
 
@@ -961,11 +961,11 @@ static int rtw_make_wlanhdr(struct rtw_adapter *padapter, u8 *hdr,
 					/* DBG_8723A("tx ampdu seqnum(%d) < tx_seq(%d)\n", pattrib->seqnum, tx_seq); */
 					pattrib->ampdu_en = false;/* AGG BK */
 				} else if (SN_EQUAL(pattrib->seqnum, tx_seq)) {
-					psta->BA_starting_seqctrl[pattrib->priority & 0x0f] = (tx_seq+1)&0xfff;
+					psta->BA_starting_seqctrl[pattrib->priority & 0x0f] = (tx_seq + 1)&0xfff;
 					pattrib->ampdu_en = true;/* AGG EN */
 				} else {
 					/* DBG_8723A("tx ampdu over run\n"); */
-					psta->BA_starting_seqctrl[pattrib->priority & 0x0f] = (pattrib->seqnum+1)&0xfff;
+					psta->BA_starting_seqctrl[pattrib->priority & 0x0f] = (pattrib->seqnum + 1)&0xfff;
 					pattrib->ampdu_en = true;/* AGG EN */
 				}
 			}
@@ -1164,8 +1164,8 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_notice_,
 				 "rtw_xmiaframe_coalesce23a: keyid =%d pattrib->iv[3]=%.2x pframe =%.2x %.2x %.2x %.2x\n",
 				 padapter->securitypriv.dot11PrivacyKeyIndex,
-				 pattrib->iv[3], *pframe, *(pframe+1),
-				 *(pframe+2), *(pframe+3));
+				 pattrib->iv[3], *pframe, *(pframe + 1),
+				 *(pframe + 2), *(pframe + 3));
 			pframe += pattrib->iv_len;
 			mpdu_len -= pattrib->iv_len;
 		}
@@ -1190,7 +1190,7 @@ int rtw_xmitframe_coalesce23a(struct rtw_adapter *padapter, struct sk_buff *skb,
 		pdata += mem_sz;
 		data_len -= mem_sz;
 
-		if ((pattrib->icv_len >0) && (pattrib->bswenc)) {
+		if ((pattrib->icv_len > 0) && (pattrib->bswenc)) {
 			memcpy(pframe, pattrib->icv, pattrib->icv_len);
 			pframe += pattrib->icv_len;
 		}
-- 
2.9.2

