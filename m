Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0ECRzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 13:55:08 -0400
Subject: [PATCH] iwlwifi: recalculate average tpt if not current
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	johannes@sipsolutions.net, Adel Gadllah <adel.gadllah@gmail.com>
In-Reply-To: <1272908934.7879.5748.camel@rchatre-DESK>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	 <1272908934.7879.5748.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 10:55:07 -0700
Message-ID: <1272909307.7879.5759.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We currently have this check as a BUG_ON, which is being hit by people.
Previously it was an error with a recalculation if not current, return that
code.

The BUG_ON was introduced by:
commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
Author: Guy Cohen <guy.cohen@intel.com>
Date:   Tue Sep 9 10:54:54 2008 +0800

    iwlwifi: Added support for 3 antennas

... the portion adding the BUG_ON is reverted since we are encountering the error
and BUG_ON was created with assumption that error is not encountered.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index b93e491..75a145c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2070,10 +2070,12 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	}
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
-
-	/* Sanity-check TPT calculations */
-	BUG_ON(window->average_tpt != ((window->success_ratio *
-			tbl->expected_tpt[index] + 64) / 128));
+	if (window->average_tpt != ((window->success_ratio *
+			tbl->expected_tpt[index] + 64) / 128)) {
+		IWL_ERR(priv, "expected_tpt should have been calculated by now\n");
+		window->average_tpt = ((window->success_ratio *
+					tbl->expected_tpt[index] + 64) / 128);
+	}
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl &&
-- 
1.6.3.3



