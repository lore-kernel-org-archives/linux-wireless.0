Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta21.charter.net ([216.33.127.81]:63505 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1FFAaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 20:30:19 -0400
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: linville@tuxdriver.com
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] iwlwifi: remove unecessary if statement
Date: Sun,  5 Jun 2011 19:30:11 -0500
Message-Id: <1307320211-31371-1-git-send-email-Gregory.Dietsche@cuw.edu> (sfid-20110606_023050_968248_5C77717F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the code always returns ret regardless, so if(ret) check is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index a95ad84..e40ad23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -163,9 +163,6 @@ static int iwlagn_send_rxon_assoc(struct iwl_priv *priv,
 
 	ret = iwl_send_cmd_pdu_async(priv, ctx->rxon_assoc_cmd,
 				     sizeof(rxon_assoc), &rxon_assoc, NULL);
-	if (ret)
-		return ret;
-
 	return ret;
 }
 
-- 
1.7.2.5

