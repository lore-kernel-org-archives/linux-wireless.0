Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35243 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117Ab3IYCbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 22:31:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Dmitry Khromov <icechrome@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.12 1/2] mwifiex: fix hang issue for USB chipsets
Date: Tue, 24 Sep 2013 19:31:24 -0700
Message-ID: <1380076285-29930-1-git-send-email-bzhao@marvell.com> (sfid-20130925_043143_042465_8A19E7E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Bug 60815 - Interface hangs in mwifiex_usb
https://bugzilla.kernel.org/show_bug.cgi?id=60815

We have 4 bytes of interface header for packets delivered to SDIO
and PCIe, but not for USB interface.

In Tx AMSDU case, currently 4 bytes of garbage data is unnecessarily
appended for USB packets. This sometimes leads to a firmware hang,
because it may not interpret the data packet correctly.

Problem is fixed by removing this redundant headroom for USB.

Cc: <stable@vger.kernel.org> # 3.5+
Tested-by: Dmitry Khromov <icechrome@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 3 ++-
 drivers/net/wireless/mwifiex/11n_aggr.h | 2 +-
 drivers/net/wireless/mwifiex/wmm.c      | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 21c6882..1214c58 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -150,7 +150,7 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
  */
 int
 mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			  struct mwifiex_ra_list_tbl *pra_list, int headroom,
+			  struct mwifiex_ra_list_tbl *pra_list,
 			  int ptrindex, unsigned long ra_list_flags)
 			  __releases(&priv->wmm.ra_list_spinlock)
 {
@@ -160,6 +160,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	int pad = 0, ret;
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
+	int headroom = adapter->iface_type == MWIFIEX_USB ? 0 : INTF_HEADER_LEN;
 
 	skb_src = skb_peek(&pra_list->skb_head);
 	if (!skb_src) {
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 900e1c6..892098d 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -26,7 +26,7 @@
 int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 				struct sk_buff *skb);
 int mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
-			      struct mwifiex_ra_list_tbl *ptr, int headroom,
+			      struct mwifiex_ra_list_tbl *ptr,
 			      int ptr_index, unsigned long flags)
 			      __releases(&priv->wmm.ra_list_spinlock);
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2e8f9cd..95fa359 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1239,8 +1239,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		if (enable_tx_amsdu && mwifiex_is_amsdu_allowed(priv, tid) &&
 		    mwifiex_is_11n_aggragation_possible(priv, ptr,
 							adapter->tx_buf_size))
-			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
-						  ptr_index, flags);
+			mwifiex_11n_aggregate_pkt(priv, ptr, ptr_index, flags);
 			/* ra_list_spinlock has been freed in
 			   mwifiex_11n_aggregate_pkt() */
 		else
-- 
1.8.2.3

