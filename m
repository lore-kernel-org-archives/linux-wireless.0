Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60995 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbbALVP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 16:15:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath10k: document switch case fall-through in __ath10k_scan_finish
Date: Mon, 12 Jan 2015 16:07:02 -0500
Message-Id: <1421096822-28698-1-git-send-email-linville@tuxdriver.com> (sfid-20150112_221532_487295_1C6AAA1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a comment for indicating that the ATH10K_SCAN_RUNNING case falls
through to the ATH10K_SCAN_ABORTING case in __ath10k_scan_finish.  This
will document that the lack of a break is intentional.

Coverity: CID 1260017

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c4005670cba2..695222e57728 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2213,6 +2213,7 @@ void __ath10k_scan_finish(struct ath10k *ar)
 	case ATH10K_SCAN_RUNNING:
 		if (ar->scan.is_roc)
 			ieee80211_remain_on_channel_expired(ar->hw);
+		/* fall through */
 	case ATH10K_SCAN_ABORTING:
 		if (!ar->scan.is_roc)
 			ieee80211_scan_completed(ar->hw,
-- 
2.1.0

