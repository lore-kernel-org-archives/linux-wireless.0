Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40898 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbcEJUbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:25 +0300
Message-Id: <1462910797-20303-29-git-send-email-luca@coelho.fi> (sfid-20160510_223119_087571_9FE9CFE7)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 29/41] iwlwifi: mvm: remove redundant alloc_ctx parameter
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

iwl_phy_db_set_section() is get called only from atomic
context, the alloc_ctx parameter is not needed. Remove it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 6 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index ecfa491..7beba9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -221,8 +221,8 @@ void iwl_phy_db_free(struct iwl_phy_db *phy_db)
 }
 IWL_EXPORT_SYMBOL(iwl_phy_db_free);
 
-int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
-			   gfp_t alloc_ctx)
+int iwl_phy_db_set_section(struct iwl_phy_db *phy_db,
+			   struct iwl_rx_packet *pkt)
 {
 	struct iwl_calib_res_notif_phy_db *phy_db_notif =
 			(struct iwl_calib_res_notif_phy_db *)pkt->data;
@@ -269,7 +269,7 @@ int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
 		return -EINVAL;
 
 	kfree(entry->data);
-	entry->data = kmemdup(phy_db_notif->data, size, alloc_ctx);
+	entry->data = kmemdup(phy_db_notif->data, size, GFP_ATOMIC);
 	if (!entry->data) {
 		entry->size = 0;
 		return -ENOMEM;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
index 2410387..d34de3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h
@@ -73,8 +73,8 @@ struct iwl_phy_db *iwl_phy_db_init(struct iwl_trans *trans);
 
 void iwl_phy_db_free(struct iwl_phy_db *phy_db);
 
-int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
-			   gfp_t alloc_ctx);
+int iwl_phy_db_set_section(struct iwl_phy_db *phy_db,
+			   struct iwl_rx_packet *pkt);
 
 
 int iwl_send_phy_db_data(struct iwl_phy_db *phy_db);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index b70f453..7057f35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -535,7 +535,7 @@ static bool iwl_wait_phy_db_entry(struct iwl_notif_wait_data *notif_wait,
 		return true;
 	}
 
-	WARN_ON(iwl_phy_db_set_section(phy_db, pkt, GFP_ATOMIC));
+	WARN_ON(iwl_phy_db_set_section(phy_db, pkt));
 
 	return false;
 }
-- 
2.8.1

