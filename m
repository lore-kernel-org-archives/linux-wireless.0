Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28304 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbdDDQtn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:49:43 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: Fix compile time sanity check for CE4 buffer size
Date: Tue, 4 Apr 2017 22:22:56 +0530
Message-ID: <1491324776-8418-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170404_184947_950262_2B40AA2D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

In 'ath10k_ce_alloc_pipe' the compile time sanity check to
ensure that there is sufficient buffers in CE4 for HTT Tx
MSDU descriptors, but this did not take into account of the
case with 'peer flow control' enabled, fix this.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[thanks to Michal for the suggestion]

 drivers/net/wireless/ath/ath10k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 9ac0a73..ee1090c 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1051,7 +1051,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 	 */
 	BUILD_BUG_ON(2 * TARGET_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-	BUILD_BUG_ON(2 * TARGET_10X_NUM_MSDU_DESC >
+	BUILD_BUG_ON(2 * TARGET_10_4_NUM_MSDU_DESC_PFC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
 	BUILD_BUG_ON(2 * TARGET_TLV_NUM_MSDU_DESC >
 		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-- 
1.9.1
