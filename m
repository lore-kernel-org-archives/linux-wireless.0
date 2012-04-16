Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab2DPWBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/16] iwlwifi: phy db channel to tx power channel group
Date: Mon, 16 Apr 2012 14:57:07 -0700
Message-Id: <1334613430-30720-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000153_602031_6F480BFD)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Implement mapping of channel to TX power channel group,
for sending channel specific data before add context.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-phy-db.c |   20 ++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-phy-db.h |    6 ++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index d65305d..1a791af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -228,8 +228,24 @@ static u16 channel_id_to_papd(u16 ch_id)
 
 static u16 channel_id_to_txp(struct iwl_phy_db *phy_db, u16 ch_id)
 {
-	/* TODO David*/
-	return 0;
+	struct iwl_phy_db_chg_txp *txp_chg;
+	int i;
+	u8 ch_index = ch_id_to_ch_index(ch_id);
+	if (ch_index == 0xff)
+		return 0xff;
+
+	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++) {
+		txp_chg = (void *)phy_db->calib_ch_group_txp[i].data;
+		if (!txp_chg)
+			return 0xff;
+		/*
+		 * Looking for the first channel group that its max channel is
+		 * higher then wanted channel.
+		 */
+		if (le16_to_cpu(txp_chg->max_channel_idx) >= ch_index)
+			return i;
+	}
+	return 0xff;
 }
 
 int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
index ba91a8b..5e86305 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
@@ -108,6 +108,12 @@ enum iwl_phy_db_section_type {
 	IWL_PHY_DB_MAX
 };
 
+/* for parsing of tx power channel group data that comes from the firmware*/
+struct iwl_phy_db_chg_txp {
+	__le32 space;
+	__le16 max_channel_idx;
+} __packed;
+
 struct iwl_phy_db *iwl_phy_db_init(struct iwl_shared *shrd);
 
 void iwl_phy_db_free(struct iwl_phy_db *phy_db);
-- 
1.7.0.4

