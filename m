Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYFLBuC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:50:02 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 25/29] iwlwifi: remove dead code iwl4965_calc_db_from_ratio
Date: Thu, 12 Jun 2008 09:47:15 +0800
Message-Id: <1213235239-2954-26-git-send-email-yi.zhu@intel.com> (sfid-20080612_041915_697127_90397BA1)
In-Reply-To: <1213235239-2954-25-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-23-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-24-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-25-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes iwl4965_calc_db_from_ratio which is dead code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   36 ---------------------------
 1 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 14d4432..8f1ab23 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1597,42 +1597,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	priv->rxq.read = i;
 	iwl_rx_queue_restock(priv);
 }
-/* Convert linear signal-to-noise ratio into dB */
-static u8 ratio2dB[100] = {
-/*	 0   1   2   3   4   5   6   7   8   9 */
-	 0,  0,  6, 10, 12, 14, 16, 17, 18, 19, /* 00 - 09 */
-	20, 21, 22, 22, 23, 23, 24, 25, 26, 26, /* 10 - 19 */
-	26, 26, 26, 27, 27, 28, 28, 28, 29, 29, /* 20 - 29 */
-	29, 30, 30, 30, 31, 31, 31, 31, 32, 32, /* 30 - 39 */
-	32, 32, 32, 33, 33, 33, 33, 33, 34, 34, /* 40 - 49 */
-	34, 34, 34, 34, 35, 35, 35, 35, 35, 35, /* 50 - 59 */
-	36, 36, 36, 36, 36, 36, 36, 37, 37, 37, /* 60 - 69 */
-	37, 37, 37, 37, 37, 38, 38, 38, 38, 38, /* 70 - 79 */
-	38, 38, 38, 38, 38, 39, 39, 39, 39, 39, /* 80 - 89 */
-	39, 39, 39, 39, 39, 40, 40, 40, 40, 40  /* 90 - 99 */
-};
-
-/* Calculates a relative dB value from a ratio of linear
- *   (i.e. not dB) signal levels.
- * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
-int iwl4965_calc_db_from_ratio(int sig_ratio)
-{
-	/* 1000:1 or higher just report as 60 dB */
-	if (sig_ratio >= 1000)
-		return 60;
-
-	/* 100:1 or higher, divide by 10 and use table,
-	 *   add 20 dB to make up for divide by 10 */
-	if (sig_ratio >= 100)
-		return (20 + (int)ratio2dB[sig_ratio/10]);
-
-	/* We shouldn't see this */
-	if (sig_ratio < 1)
-		return 0;
-
-	/* Use table for ratios 1:1 - 99:1 */
-	return (int)ratio2dB[sig_ratio];
-}
 
 #define PERFECT_RSSI (-20) /* dBm */
 #define WORST_RSSI (-95)   /* dBm */
-- 
1.5.3.6

