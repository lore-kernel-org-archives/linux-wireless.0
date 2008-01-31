Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6474 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYAaGKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:32 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: fix merge sequence: exit on error before state change
Date: Wed, 30 Jan 2008 22:05:15 -0800
Message-Id: <1201759516-28963-5-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061039_607584_9530A3B3)
In-Reply-To: <1201759516-28963-4-git-send-email-reinette.chatre@intel.com>
References: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-2-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-3-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The intention behind the original patch:
"iwlwifi: fix possible read attempt on ucode that is not available"
was to exit before any state is changed. Due to its submission directly
to 2.6.24 it was not clear how this relates to the latest iwlwifi work.

This patch does exactly the same as the previous patch, just earlier to
prevent any state from being changed if there is an error.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 24c4156..15594fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6260,6 +6260,11 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 		return -ENODEV;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl3945_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
@@ -6272,11 +6277,6 @@ static int __iwl3945_up(struct iwl3945_priv *priv)
 		}
 	}
 
-	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERROR("ucode not available for device bringup\n");
-		return -EIO;
-	}
-
 	iwl3945_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl3945_hw_nic_init(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7220212..788e176 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6675,6 +6675,11 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 		return -ENODEV;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl4965_read32(priv, CSR_GP_CNTRL) &
 				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
@@ -6687,11 +6692,6 @@ static int __iwl4965_up(struct iwl4965_priv *priv)
 		}
 	}
 
-	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
-		IWL_ERROR("ucode not available for device bringup\n");
-		return -EIO;
-	}
-
 	iwl4965_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl4965_hw_nic_init(priv);
-- 
1.5.3.4

