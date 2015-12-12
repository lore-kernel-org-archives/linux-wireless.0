Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34195 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLLNWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 08:22:51 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/2] wil6210: fix kernel OOPS when stopping interface during Rx traffic
Date: Sat, 12 Dec 2015 15:22:44 +0200
Message-Id: <1449926565-888-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20151212_142258_778812_F08BD743)
In-Reply-To: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

When network interface is stopping, some resources may
be already released by the network stack, and Rx frames
cause kernel OOPS (observed one is in netfilter code)

Proper solution is to drop packets pending in reorder buffer.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index e3d1be8..32031e7 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -261,9 +261,19 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
 			   struct wil_tid_ampdu_rx *r)
 {
+	int i;
+
 	if (!r)
 		return;
-	wil_release_reorder_frames(wil, r, r->head_seq_num + r->buf_size);
+
+	/* Do not pass remaining frames to the network stack - it may be
+	 * not expecting to get any more Rx. Rx from here may lead to
+	 * kernel OOPS since some per-socket accounting info was already
+	 * released.
+	 */
+	for (i = 0; i < r->buf_size; i++)
+		kfree_skb(r->reorder_buf[i]);
+
 	kfree(r->reorder_buf);
 	kfree(r->reorder_time);
 	kfree(r);
-- 
1.8.5.2

