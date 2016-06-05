Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbcFERQR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 13:16:17 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] NFC: hci: delete unused nfc_llc_get_rx_head_tail_room()
Date: Sun,  5 Jun 2016 19:16:11 +0200
Message-Id: <20160605171611.25529-1-dvlasenk@redhat.com> (sfid-20160605_191826_545672_C89D2AB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It used to be EXPORTed, but then EXPORT usage was cleaned up
(in 2012), without noticing that the function has no users at all
(and curiously, never had any users).

Delete it.

While at it, remove non-static "inline" hints on nearby functions:
these hints don't work across compilation units anyway,
and these functions are not used in their .c file, thus they are
never inlined. IOW: "inline" here does not help in any way.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Christophe Ricard <christophe.ricard@gmail.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 include/net/nfc/llc.h |  4 ----
 net/nfc/hci/llc.c     | 17 +++++------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/include/net/nfc/llc.h b/include/net/nfc/llc.h
index c25fbde..7ecb457 100644
--- a/include/net/nfc/llc.h
+++ b/include/net/nfc/llc.h
@@ -37,10 +37,6 @@ struct nfc_llc *nfc_llc_allocate(const char *name, struct nfc_hci_dev *hdev,
 				 int tx_tailroom, llc_failure_t llc_failure);
 void nfc_llc_free(struct nfc_llc *llc);
 
-void nfc_llc_get_rx_head_tail_room(struct nfc_llc *llc, int *rx_headroom,
-				   int *rx_tailroom);
-
-
 int nfc_llc_start(struct nfc_llc *llc);
 int nfc_llc_stop(struct nfc_llc *llc);
 void nfc_llc_rcv_from_drv(struct nfc_llc *llc, struct sk_buff *skb);
diff --git a/net/nfc/hci/llc.c b/net/nfc/hci/llc.c
index 1399a03..3d699cb 100644
--- a/net/nfc/hci/llc.c
+++ b/net/nfc/hci/llc.c
@@ -133,36 +133,29 @@ void nfc_llc_free(struct nfc_llc *llc)
 	kfree(llc);
 }
 
-inline void nfc_llc_get_rx_head_tail_room(struct nfc_llc *llc, int *rx_headroom,
-					  int *rx_tailroom)
-{
-	*rx_headroom = llc->rx_headroom;
-	*rx_tailroom = llc->rx_tailroom;
-}
-
-inline int nfc_llc_start(struct nfc_llc *llc)
+int nfc_llc_start(struct nfc_llc *llc)
 {
 	return llc->ops->start(llc);
 }
 EXPORT_SYMBOL(nfc_llc_start);
 
-inline int nfc_llc_stop(struct nfc_llc *llc)
+int nfc_llc_stop(struct nfc_llc *llc)
 {
 	return llc->ops->stop(llc);
 }
 EXPORT_SYMBOL(nfc_llc_stop);
 
-inline void nfc_llc_rcv_from_drv(struct nfc_llc *llc, struct sk_buff *skb)
+void nfc_llc_rcv_from_drv(struct nfc_llc *llc, struct sk_buff *skb)
 {
 	llc->ops->rcv_from_drv(llc, skb);
 }
 
-inline int nfc_llc_xmit_from_hci(struct nfc_llc *llc, struct sk_buff *skb)
+int nfc_llc_xmit_from_hci(struct nfc_llc *llc, struct sk_buff *skb)
 {
 	return llc->ops->xmit_from_hci(llc, skb);
 }
 
-inline void *nfc_llc_get_data(struct nfc_llc *llc)
+void *nfc_llc_get_data(struct nfc_llc *llc)
 {
 	return llc->data;
 }
-- 
1.8.1.4

