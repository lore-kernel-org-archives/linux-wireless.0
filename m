Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYAUSGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 13:06:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.co
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: fix possible read attempt on ucode that is not available
Date: Mon, 21 Jan 2008 10:05:08 -0800
Message-Id: <1200938708-31309-1-git-send-email-reinette.chatre@intel.com> (sfid-20080121_180628_352701_3FCA4D2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a NULL pointer dereference that can occur when the
ucode is not loaded at the time __iwl_up is called.

The problem was reported at http://kerneloops.org/raw.php?rawid=2765&msgid=

The patch is against 2.6.24-rc8. Is it possible to get this fix into
2.6.24?

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a6b0e0..0b3ec7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6342,6 +6342,11 @@ static int __iwl_up(struct iwl_priv *priv)
 		return 0;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl_hw_nic_init(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6cd57c2..15a45f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6698,6 +6698,11 @@ static int __iwl_up(struct iwl_priv *priv)
 		return 0;
 	}
 
+	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
+		IWL_ERROR("ucode not available for device bringup\n");
+		return -EIO;
+	}
+
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
 	rc = iwl_hw_nic_init(priv);
-- 
1.5.3.4

