Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36177 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1I0IAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 04:00:13 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 73629F0330
	for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 11:00:12 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 68ED6158A63
	for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 11:00:09 +0300 (EEST)
Subject: [PATCH] ath6kl: fix TCP corruption
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Tue, 27 Sep 2011 11:00:08 +0300
Message-ID: <20110927080008.28000.50462.stgit@localhost6.localdomain6> (sfid-20110927_100017_968525_A8C9C12A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni@qca.qualcomm.com>

Commit 94e532d1a ("ath6kl: Fix system freeze under heavy data load")
aligns the skb data without checking if the skb is cloned. Because of
this ath6kl can corrupt the local TCP stack information that can result
in TCP retransmission failing and TCP connections stalling.

To avoid the corruption we need to copy the skb. Now the alignment
in ath6kl_htc_tx_buf_align() doesn't corrupt TCP packets anymore (and is
not even used for the cloned skb's that got copied since the alignment
of the data is handled at the copy time).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 348c646..0869ff3 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -317,6 +317,24 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 
 	spin_unlock_bh(&ar->lock);
 
+	if (!IS_ALIGNED((unsigned long) skb->data - HTC_HDR_LENGTH, 4) &&
+	    skb_cloned(skb)) {
+		/*
+		 * We will touch (move the buffer data to align it. Since the
+		 * skb buffer is cloned and not only the header is changed, we
+		 * have to copy it to allow the changes. Since we are copying
+		 * the data here, we may as well align it by reserving suitable
+		 * headroom to avoid the memmove in ath6kl_htc_tx_buf_align().
+		 */
+		struct sk_buff *nskb;
+
+		nskb = skb_copy_expand(skb, HTC_HDR_LENGTH, 0, GFP_ATOMIC);
+		if (nskb == NULL)
+			goto fail_tx;
+		kfree_skb(skb);
+		skb = nskb;
+	}
+
 	cookie->skb = skb;
 	cookie->map_no = map_no;
 	set_htc_pkt_info(&cookie->htc_pkt, cookie, skb->data, skb->len,

