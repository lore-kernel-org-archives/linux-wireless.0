Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40872 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752785AbcEJUbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:31:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:24 +0300
Message-Id: <1462910797-20303-28-git-send-email-luca@coelho.fi> (sfid-20160510_223106_751618_30DA3D87)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 28/41] iwlwifi: mvm: make phy_db size dynamic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Driver is agnostic to the number of the phy_db entries and
only serves the firmware as a pipe to move the data from init
image to RT image.
As the size of the arrays may change (as it does in 9000 device)
allocate it dynamically. Firmware sends the largest index first
so we can use this to know how much we should allocate.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 62 +++++++++++++++++++------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
index 4a4dea0..ecfa491 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -72,8 +73,6 @@
 #include "iwl-trans.h"
 
 #define CHANNEL_NUM_SIZE	4	/* num of channels in calib_ch size */
-#define IWL_NUM_PAPD_CH_GROUPS	9
-#define IWL_NUM_TXP_CH_GROUPS	9
 
 struct iwl_phy_db_entry {
 	u16	size;
@@ -86,14 +85,18 @@ struct iwl_phy_db_entry {
  * @cfg: phy configuration.
  * @calib_nch: non channel specific calibration data.
  * @calib_ch: channel specific calibration data.
+ * @n_group_papd: number of entries in papd channel group.
  * @calib_ch_group_papd: calibration data related to papd channel group.
+ * @n_group_txp: number of entries in tx power channel group.
  * @calib_ch_group_txp: calibration data related to tx power chanel group.
  */
 struct iwl_phy_db {
 	struct iwl_phy_db_entry	cfg;
 	struct iwl_phy_db_entry	calib_nch;
-	struct iwl_phy_db_entry	calib_ch_group_papd[IWL_NUM_PAPD_CH_GROUPS];
-	struct iwl_phy_db_entry	calib_ch_group_txp[IWL_NUM_TXP_CH_GROUPS];
+	int n_group_papd;
+	struct iwl_phy_db_entry	*calib_ch_group_papd;
+	int n_group_txp;
+	struct iwl_phy_db_entry	*calib_ch_group_txp;
 
 	struct iwl_trans *trans;
 };
@@ -143,6 +146,9 @@ struct iwl_phy_db *iwl_phy_db_init(struct iwl_trans *trans)
 
 	phy_db->trans = trans;
 
+	phy_db->n_group_txp = -1;
+	phy_db->n_group_papd = -1;
+
 	/* TODO: add default values of the phy db. */
 	return phy_db;
 }
@@ -166,11 +172,11 @@ iwl_phy_db_get_section(struct iwl_phy_db *phy_db,
 	case IWL_PHY_DB_CALIB_NCH:
 		return &phy_db->calib_nch;
 	case IWL_PHY_DB_CALIB_CHG_PAPD:
-		if (chg_id >= IWL_NUM_PAPD_CH_GROUPS)
+		if (chg_id >= phy_db->n_group_papd)
 			return NULL;
 		return &phy_db->calib_ch_group_papd[chg_id];
 	case IWL_PHY_DB_CALIB_CHG_TXP:
-		if (chg_id >= IWL_NUM_TXP_CH_GROUPS)
+		if (chg_id >= phy_db->n_group_txp)
 			return NULL;
 		return &phy_db->calib_ch_group_txp[chg_id];
 	default:
@@ -202,10 +208,14 @@ void iwl_phy_db_free(struct iwl_phy_db *phy_db)
 
 	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CFG, 0);
 	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_NCH, 0);
-	for (i = 0; i < IWL_NUM_PAPD_CH_GROUPS; i++)
+
+	for (i = 0; i < phy_db->n_group_papd; i++)
 		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_PAPD, i);
-	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++)
+	kfree(phy_db->calib_ch_group_papd);
+
+	for (i = 0; i < phy_db->n_group_txp; i++)
 		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_TXP, i);
+	kfree(phy_db->calib_ch_group_txp);
 
 	kfree(phy_db);
 }
@@ -224,9 +234,35 @@ int iwl_phy_db_set_section(struct iwl_phy_db *phy_db, struct iwl_rx_packet *pkt,
 	if (!phy_db)
 		return -EINVAL;
 
-	if (type == IWL_PHY_DB_CALIB_CHG_PAPD ||
-	    type == IWL_PHY_DB_CALIB_CHG_TXP)
+	if (type == IWL_PHY_DB_CALIB_CHG_PAPD) {
 		chg_id = le16_to_cpup((__le16 *)phy_db_notif->data);
+		if (phy_db && !phy_db->calib_ch_group_papd) {
+			/*
+			 * Firmware sends the largest index first, so we can use
+			 * it to know how much we should allocate.
+			 */
+			phy_db->calib_ch_group_papd = kcalloc(chg_id + 1,
+							      sizeof(struct iwl_phy_db_entry),
+							      GFP_ATOMIC);
+			if (!phy_db->calib_ch_group_papd)
+				return -ENOMEM;
+			phy_db->n_group_papd = chg_id + 1;
+		}
+	} else if (type == IWL_PHY_DB_CALIB_CHG_TXP) {
+		chg_id = le16_to_cpup((__le16 *)phy_db_notif->data);
+		if (phy_db && !phy_db->calib_ch_group_txp) {
+			/*
+			 * Firmware sends the largest index first, so we can use
+			 * it to know how much we should allocate.
+			 */
+			phy_db->calib_ch_group_txp = kcalloc(chg_id + 1,
+							     sizeof(struct iwl_phy_db_entry),
+							     GFP_ATOMIC);
+			if (!phy_db->calib_ch_group_txp)
+				return -ENOMEM;
+			phy_db->n_group_txp = chg_id + 1;
+		}
+	}
 
 	entry = iwl_phy_db_get_section(phy_db, type, chg_id);
 	if (!entry)
@@ -296,7 +332,7 @@ static u16 channel_id_to_txp(struct iwl_phy_db *phy_db, u16 ch_id)
 	if (ch_index == 0xff)
 		return 0xff;
 
-	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++) {
+	for (i = 0; i < phy_db->n_group_txp; i++) {
 		txp_chg = (void *)phy_db->calib_ch_group_txp[i].data;
 		if (!txp_chg)
 			return 0xff;
@@ -447,7 +483,7 @@ int iwl_send_phy_db_data(struct iwl_phy_db *phy_db)
 	/* Send all the TXP channel specific data */
 	err = iwl_phy_db_send_all_channel_groups(phy_db,
 						 IWL_PHY_DB_CALIB_CHG_PAPD,
-						 IWL_NUM_PAPD_CH_GROUPS);
+						 phy_db->n_group_papd);
 	if (err) {
 		IWL_ERR(phy_db->trans,
 			"Cannot send channel specific PAPD groups\n");
@@ -457,7 +493,7 @@ int iwl_send_phy_db_data(struct iwl_phy_db *phy_db)
 	/* Send all the TXP channel specific data */
 	err = iwl_phy_db_send_all_channel_groups(phy_db,
 						 IWL_PHY_DB_CALIB_CHG_TXP,
-						 IWL_NUM_TXP_CH_GROUPS);
+						 phy_db->n_group_txp);
 	if (err) {
 		IWL_ERR(phy_db->trans,
 			"Cannot send channel specific TX power groups\n");
-- 
2.8.1

