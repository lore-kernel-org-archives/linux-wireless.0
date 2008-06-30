Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299AbYF3J1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/33] iwlwifi: keep the STATUS_EXIT_PENDING flag till the end of down flow
Date: Mon, 30 Jun 2008 17:23:15 +0800
Message-Id: <1214817813-17639-16-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_009567_CA0498E2)
In-Reply-To: <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

This patch avoids unsetting STATUS_EXIT_PENDING in the middle of the
down flow.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 144b1da..1b2d9f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2103,7 +2103,9 @@ static void __iwl4965_down(struct iwl_priv *priv)
 			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 					STATUS_GEO_CONFIGURED |
 			       test_bit(STATUS_IN_SUSPEND, &priv->status) <<
-					STATUS_IN_SUSPEND;
+					STATUS_IN_SUSPEND |
+			       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
+					STATUS_EXIT_PENDING;
 		goto exit;
 	}
 
@@ -2118,7 +2120,9 @@ static void __iwl4965_down(struct iwl_priv *priv)
 			test_bit(STATUS_IN_SUSPEND, &priv->status) <<
 				STATUS_IN_SUSPEND |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
-				STATUS_FW_ERROR;
+				STATUS_FW_ERROR |
+		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
+				STATUS_EXIT_PENDING;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL,
-- 
1.5.3.6

