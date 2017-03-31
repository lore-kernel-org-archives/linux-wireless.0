Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64095 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbdCaMIV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 08:08:21 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <mkenna@codeaurora.org>,
        "Maharaja Kennadyrajan" <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix the Transmit Power Control stats display format
Date: Fri, 31 Mar 2017 17:39:40 +0530
Message-ID: <1490962180-24054-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20170331_140824_313186_F04C53DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

This patch helps to fix TPC stats to display the stats
properly. Here cosmetic change has been done to print the
TPC stats for all the cases 1.CDD 2.STBC 3.TXBF

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 00b424d..1339cc3 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1816,7 +1816,7 @@ static void ath10k_tpc_stats_fill(struct ath10k *ar,
 			 tpc_stats->num_tx_chain,
 			 tpc_stats->rate_max);
 
-	for (j = 0; j < tpc_stats->num_tx_chain ; j++) {
+	for (j = 0; j < WMI_TPC_FLAG; j++) {
 		switch (j) {
 		case WMI_TPC_TABLE_TYPE_CDD:
 			if (tpc_stats->flag[j] == ATH10K_TPC_TABLE_TYPE_FLAG) {
-- 
1.9.1
