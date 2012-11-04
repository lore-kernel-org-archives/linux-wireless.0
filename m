Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43722 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2KDRUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 12:20:14 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3444748wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 09:20:12 -0800 (PST)
Message-ID: <1352049606.3056.30.camel@Route3278> (sfid-20121104_182030_673956_AC0B6A34)
Subject: [PATCH] staging: vt6656: free skbuff and relocate on bReAllocSkb ==
 FALSE.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 04 Nov 2012 17:20:06 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bReAllocSkb == FALSE is when data is not fed to user land.

Free and relocate skbuff.

Where data is not sent return = FALSE from RXbBulkInProcessData.

This appears to reduce false errors when a reused skbuff has old data.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/dpc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 28edf9e..5ad7abb 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -617,7 +617,7 @@ RXbBulkInProcessData (
                 //Discard beacon packet which channel is 0
                 if ( (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl)) == WLAN_FSTYPE_BEACON) ||
                      (WLAN_GET_FC_FSTYPE((pRxPacket->p80211Header->sA3.wFrameCtl)) == WLAN_FSTYPE_PROBERESP) ) {
-                    return TRUE;
+			return FALSE;
                 }
             }
             pRxPacket->byRxChannel = (*pbyRxSts) >> 2;
@@ -912,7 +912,7 @@ RXbBulkInProcessData (
                      pDevice->skb->protocol = htons(ETH_P_802_2);
                      memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                      netif_rx(pDevice->skb);
-                     pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
+			return TRUE;
                  }
 
                 return FALSE;
@@ -1534,6 +1534,11 @@ RXvFreeRCB(
     ASSERT(!pRCB->Ref);     // should be 0
     ASSERT(pRCB->pDevice);  // shouldn't be NULL
 
+	if (bReAllocSkb == FALSE) {
+		kfree_skb(pRCB->skb);
+		bReAllocSkb = TRUE;
+	}
+
     if (bReAllocSkb == TRUE) {
         pRCB->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
         // todo error handling
-- 
1.7.10.4


