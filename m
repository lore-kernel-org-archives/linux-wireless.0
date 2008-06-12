Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbYFLBtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/29] iwlwifi: fix resart flow after fw error
Date: Thu, 12 Jun 2008 09:47:04 +0800
Message-Id: <1213235239-2954-15-git-send-email-yi.zhu@intel.com> (sfid-20080612_041914_298053_5BBCE2B8)
In-Reply-To: <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Clear STATUS_FW_ERROR in the _up_ flow before reseting NIC.
UP flow will otherwise call restart again causing endless restart loop.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7a9567c..3f54dec 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2857,9 +2857,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send host commands to 4965 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
-	/* Clear out the uCode error bit if it is set */
-	clear_bit(STATUS_FW_ERROR, &priv->status);
-
 	if (iwl_is_rfkill(priv))
 		return;
 
@@ -3099,6 +3096,9 @@ static int __iwl4965_up(struct iwl_priv *priv)
 			continue;
 		}
 
+		/* Clear out the uCode error bit if it is set */
+		clear_bit(STATUS_FW_ERROR, &priv->status);
+
 		/* start card; "initialize" will load runtime ucode */
 		iwl4965_nic_start(priv);
 
-- 
1.5.3.6

