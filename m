Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BZV2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:28:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dor Shaish <dor.shaish@intel.com>
Subject: [PATCH 4/4] iwlwifi: mvm: Remove testing of static PIC in PhyDB
Date: Tue, 26 Feb 2013 22:27:57 +0100
Message-Id: <1361914077-18749-4-git-send-email-johannes@sipsolutions.net> (sfid-20130226_222815_092170_8E97DA0A)
In-Reply-To: <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
References: <1361914034.8440.27.camel@jlt4.sipsolutions.net>
 <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

The PIC was supposed to be a small signature appended to the
PhyDB data, but the signature isn't really static and thus
attempting to check it just causes the warnings spuriously
so remove them.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-phy-db.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index 14fc8d3..3392011 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -136,12 +136,6 @@ struct iwl_calib_res_notif_phy_db {
 	u8 data[];
 } __packed;
 
-#define IWL_PHY_DB_STATIC_PIC cpu_to_le32(0x21436587)
-static inline void iwl_phy_db_test_pic(__le32 pic)
-{
-	WARN_ON(IWL_PHY_DB_STATIC_PIC != pic);
-}
-
 struct iwl_phy_db *iwl_phy_db_init(struct iwl_trans *trans)
 {
 	struct iwl_phy_db *phy_db = kzalloc(sizeof(struct iwl_phy_db),
@@ -260,11 +254,6 @@ int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
 			(size - CHANNEL_NUM_SIZE) / phy_db->channel_num;
 	}
 
-	/* Test PIC */
-	if (type != IWL_PHY_DB_CFG)
-		iwl_phy_db_test_pic(*(((__le32 *)phy_db_notif->data) +
-				      (size / sizeof(__le32)) - 1));
-
 	IWL_DEBUG_INFO(phy_db->trans,
 		       "%s(%d): [PHYDB]SET: Type %d , Size: %d\n",
 		       __func__, __LINE__, type, size);
@@ -372,11 +361,6 @@ int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
 		*size = entry->size;
 	}
 
-	/* Test PIC */
-	if (type != IWL_PHY_DB_CFG)
-		iwl_phy_db_test_pic(*(((__le32 *)*data) +
-				      (*size / sizeof(__le32)) - 1));
-
 	IWL_DEBUG_INFO(phy_db->trans,
 		       "%s(%d): [PHYDB] GET: Type %d , Size: %d\n",
 		       __func__, __LINE__, type, *size);
-- 
1.8.0

