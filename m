Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49311 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab0ECR2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 13:28:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johill@sipsolutions.net, reinette.chatre@intel.com,
	Adel Gadllah <adel.gadllah@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: Change the TPT calculations sanity-check to WARN_ON
Date: Mon,  3 May 2010 13:25:49 -0400
Message-Id: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adel Gadllah <adel.gadllah@gmail.com>

Currently it is a BUG_ON() which will hang the machine once triggered.

(Changed from WARN_ON to WARN_ON_ONCE. -- JWL)

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8f8d5e3..ca63ff9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2079,8 +2079,9 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	 * actual average throughput */
 
 	/* Sanity-check TPT calculations */
-	BUG_ON(window->average_tpt != ((window->success_ratio *
-			tbl->expected_tpt[index] + 64) / 128));
+	if (WARN_ON_ONCE(window->average_tpt != ((window->success_ratio *
+				tbl->expected_tpt[index] + 64) / 128)))
+		return;
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl &&
-- 
1.6.6.1

