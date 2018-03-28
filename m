Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:46491 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeC1WH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 18:07:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: avoid possible string overflow
Date: Thu, 29 Mar 2018 00:06:10 +0200
Message-Id: <20180328220635.3704458-1-arnd@arndb.de> (sfid-20180329_000749_531903_F7D97EFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The way that 'strncat' is used here raised a warning in gcc-8:

drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_tpc_stats_final_disp_tables':
drivers/net/wireless/ath/ath10k/wmi.c:4649:4: error: 'strncat' output truncated before terminating nul copying as many bytes from a string as its length [-Werror=stringop-truncation]

Effectively, this is simply a strcat() but the use of strncat() suggests
some form of overflow check. Regardless of whether this might actually
overflow, using strlcat() instead of strncat() avoids the warning and
makes the code more robust.

Fixes: bc64d05220f3 ("ath10k: debugfs support to get final TPC stats for 10.4 variants")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9649bb752bbd..42522ed115f3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4309,7 +4309,7 @@ static void ath10k_tpc_config_disp_tables(struct ath10k *ar,
 							    rate_code[i],
 							    type);
 			snprintf(buff, sizeof(buff), "%8d ", tpc[j]);
-			strncat(tpc_value, buff, strlen(buff));
+			strlcat(tpc_value, buff, sizeof(tpc_value));
 		}
 		tpc_stats->tpc_table[type].pream_idx[i] = pream_idx;
 		tpc_stats->tpc_table[type].rate_code[i] = rate_code[i];
@@ -4646,7 +4646,7 @@ ath10k_wmi_tpc_stats_final_disp_tables(struct ath10k *ar,
 							       rate_code[i],
 							       type, pream_idx);
 			snprintf(buff, sizeof(buff), "%8d ", tpc[j]);
-			strncat(tpc_value, buff, strlen(buff));
+			strlcat(tpc_value, buff, sizeof(tpc_value));
 		}
 		tpc_stats->tpc_table_final[type].pream_idx[i] = pream_idx;
 		tpc_stats->tpc_table_final[type].rate_code[i] = rate_code[i];
-- 
2.9.0
