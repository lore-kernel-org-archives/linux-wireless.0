Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbYBFTUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 14:20:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] iwlwifi: do not clear GEO_CONFIGURED bit when calling _down
Date: Wed,  6 Feb 2008 11:20:38 -0800
Message-Id: <1202325640-9577-2-git-send-email-reinette.chatre@intel.com> (sfid-20080206_192050_752805_601D936B)
In-Reply-To: <1202325640-9577-1-git-send-email-reinette.chatre@intel.com>
References: <1202325640-9577-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The geos information is set up during probe and should only
be removed during pci_remove, not during _down.
This is a temporary fix until the setting of the status bits
have been cleaned up (to explicitly match all setting with
clearing of status bits).

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2e20e8e..6002326 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6185,6 +6185,8 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 					STATUS_RF_KILL_HW |
 			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 					STATUS_RF_KILL_SW |
+			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
+					STATUS_GEO_CONFIGURED |
 			       test_bit(STATUS_IN_SUSPEND, &priv->status) <<
 					STATUS_IN_SUSPEND;
 		goto exit;
@@ -6196,6 +6198,8 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 				STATUS_RF_KILL_SW |
+			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
+				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_IN_SUSPEND, &priv->status) <<
 				STATUS_IN_SUSPEND |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f2daaaa..110968e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6599,6 +6599,8 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 					STATUS_RF_KILL_HW |
 			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 					STATUS_RF_KILL_SW |
+			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
+					STATUS_GEO_CONFIGURED |
 			       test_bit(STATUS_IN_SUSPEND, &priv->status) <<
 					STATUS_IN_SUSPEND;
 		goto exit;
@@ -6610,6 +6612,8 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 				STATUS_RF_KILL_SW |
+			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
+				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_IN_SUSPEND, &priv->status) <<
 				STATUS_IN_SUSPEND |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
-- 
1.5.3.4

