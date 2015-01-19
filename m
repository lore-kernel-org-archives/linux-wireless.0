Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41577 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbASTpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 14:45:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k_htc: remove dead code in error path of ath9k_htc_txcompletion_cb
Date: Mon, 19 Jan 2015 14:02:21 -0500
Message-Id: <1421694141-18337-1-git-send-email-linville@tuxdriver.com> (sfid-20150119_204524_885372_0CBFAD2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This clause is conditioned on htc_hdr != NULL, but it will only be NULL
when that check is reached.

Coverity: CID 114318

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index a0ff5b637054..d2408da38c1c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -351,11 +351,7 @@ void ath9k_htc_txcompletion_cb(struct htc_target *htc_handle,
 
 	return;
 ret:
-	/* HTC-generated packets are freed here. */
-	if (htc_hdr && htc_hdr->endpoint_id != ENDPOINT0)
-		dev_kfree_skb_any(skb);
-	else
-		kfree_skb(skb);
+	kfree_skb(skb);
 }
 
 static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
-- 
2.1.0

