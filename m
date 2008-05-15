Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYEOF4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 02/26] iwlwifi: remove iwl4965_nic_start function
Date: Thu, 15 May 2008 13:53:54 +0800
Message-Id: <1210830858-3410-3-git-send-email-yi.zhu@intel.com> (sfid-20080515_075622_237063_CA071B0A)
In-Reply-To: <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch moves the contant of iwl4965_nic_start to the only place it is
being used.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d0f948d..1a2d376 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3958,13 +3958,6 @@ static void iwl4965_dealloc_ucode_pci(struct iwl_priv *priv)
 	iwl_free_fw_desc(priv->pci_dev, &priv->ucode_boot);
 }
 
-static void iwl4965_nic_start(struct iwl_priv *priv)
-{
-	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv, CSR_RESET, 0);
-}
-
-
 /**
  * iwl4965_read_ucode - Read uCode images from disk file.
  *
@@ -4454,7 +4447,8 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		}
 
 		/* start card; "initialize" will load runtime ucode */
-		iwl4965_nic_start(priv);
+		/* Remove all resets to allow NIC to operate */
+		iwl_write32(priv, CSR_RESET, 0);
 
 		IWL_DEBUG_INFO(DRV_NAME " is coming up\n");
 
-- 
1.5.3.6

