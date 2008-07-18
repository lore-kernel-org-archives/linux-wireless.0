Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12191 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYGRF4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:37 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/13] iwlwifi: bug fix in AGG flow - cast const to ULL
Date: Fri, 18 Jul 2008 13:53:09 +0800
Message-Id: <1216360389-5352-14-git-send-email-yi.zhu@intel.com> (sfid-20080718_081543_543089_56F3D806)
In-Reply-To: <1216360389-5352-13-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-9-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-10-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-11-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-12-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes a bug in AGG flow:
u64 bitmap = 0;
bitmap |= 1 << 32 results to be 0xffffffff80000000.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1463421..ee31c24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2130,9 +2130,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				bitmap = bitmap << sh;
 				sh = 0;
 			}
-			bitmap |= (1 << sh);
-			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%x\n",
-					   start, (u32)(bitmap & 0xFFFFFFFF));
+			bitmap |= 1ULL << sh;
+			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%llx\n",
+					   start, (unsigned long long)bitmap);
 		}
 
 		agg->bitmap = bitmap;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f91c54b..076d356 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1228,9 +1228,9 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 				bitmap = bitmap << sh;
 				sh = 0;
 			}
-			bitmap |= (1 << sh);
-			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%x\n",
-					   start, (u32)(bitmap & 0xFFFFFFFF));
+			bitmap |= 1ULL << sh;
+			IWL_DEBUG_TX_REPLY("start=%d bitmap=0x%llx\n",
+					   start, (unsigned long long)bitmap);
 		}
 
 		agg->bitmap = bitmap;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 9b50b10..9796884 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1391,7 +1391,7 @@ static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	/* For each frame attempted in aggregation,
 	 * update driver's record of tx frame's status. */
 	for (i = 0; i < agg->frame_count ; i++) {
-		ack = bitmap & (1 << i);
+		ack = bitmap & (1ULL << i);
 		successes += !!ack;
 		IWL_DEBUG_TX_REPLY("%s ON i=%d idx=%d raw=%d\n",
 			ack? "ACK":"NACK", i, (agg->start_idx + i) & 0xff,
-- 
1.5.3.6

