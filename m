Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2EPUty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:49:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] iwlwifi: remove ucode16 option
Date: Wed, 16 May 2012 22:49:47 +0200
Message-Id: <1337201389-21553-2-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224959_900142_AE54C836)
In-Reply-To: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
References: <1337201389-21553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ucode16 option is still very much work in
progress, so there's no need to ask any users
about it. Remove the option and code for now,
we'll put it back when it's actually working.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig      |    8 -
 drivers/net/wireless/iwlwifi/Makefile     |    1 -
 drivers/net/wireless/iwlwifi/iwl-phy-db.c |  288 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-phy-db.h |  129 -------------
 4 files changed, 426 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index db6c6e5..2463c06 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -137,11 +137,3 @@ config IWLWIFI_EXPERIMENTAL_MFP
 	  even if the microcode doesn't advertise it.
 
 	  Say Y only if you want to experiment with MFP.
-
-config IWLWIFI_UCODE16
-	bool "support uCode 16.0"
-	depends on IWLWIFI
-	help
-	  This option enables support for uCode version 16.0.
-
-	  Say Y if you want to use 16.0 microcode.
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 406f297..d615eac 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -18,7 +18,6 @@ iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 
-iwlwifi-$(CONFIG_IWLWIFI_UCODE16) += iwl-phy-db.o
 iwlwifi-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-testmode.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
deleted file mode 100644
index f166955..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ /dev/null
@@ -1,288 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#include <linux/slab.h>
-#include <linux/string.h>
-
-#include "iwl-debug.h"
-#include "iwl-dev.h"
-
-#include "iwl-phy-db.h"
-
-#define CHANNEL_NUM_SIZE	4	/* num of channels in calib_ch size */
-
-struct iwl_phy_db *iwl_phy_db_init(struct device *dev)
-{
-	struct iwl_phy_db *phy_db = kzalloc(sizeof(struct iwl_phy_db),
-					    GFP_KERNEL);
-
-	if (!phy_db)
-		return phy_db;
-
-	phy_db->dev = dev;
-
-	/* TODO: add default values of the phy db. */
-	return phy_db;
-}
-
-/*
- * get phy db section: returns a pointer to a phy db section specified by
- * type and channel group id.
- */
-static struct iwl_phy_db_entry *
-iwl_phy_db_get_section(struct iwl_phy_db *phy_db,
-		       enum iwl_phy_db_section_type type,
-		       u16 chg_id)
-{
-	if (!phy_db || type < 0 || type >= IWL_PHY_DB_MAX)
-		return NULL;
-
-	switch (type) {
-	case IWL_PHY_DB_CFG:
-		return &phy_db->cfg;
-	case IWL_PHY_DB_CALIB_NCH:
-		return &phy_db->calib_nch;
-	case IWL_PHY_DB_CALIB_CH:
-		return &phy_db->calib_ch;
-	case IWL_PHY_DB_CALIB_CHG_PAPD:
-		if (chg_id < 0 || chg_id >= IWL_NUM_PAPD_CH_GROUPS)
-			return NULL;
-		return &phy_db->calib_ch_group_papd[chg_id];
-	case IWL_PHY_DB_CALIB_CHG_TXP:
-		if (chg_id < 0 || chg_id >= IWL_NUM_TXP_CH_GROUPS)
-			return NULL;
-		return &phy_db->calib_ch_group_txp[chg_id];
-	default:
-		return NULL;
-	}
-	return NULL;
-}
-
-static void iwl_phy_db_free_section(struct iwl_phy_db *phy_db,
-				    enum iwl_phy_db_section_type type,
-				    u16 chg_id)
-{
-	struct iwl_phy_db_entry *entry =
-				iwl_phy_db_get_section(phy_db, type, chg_id);
-	if (!entry)
-		return;
-
-	kfree(entry->data);
-	entry->data = NULL;
-	entry->size = 0;
-}
-
-void iwl_phy_db_free(struct iwl_phy_db *phy_db)
-{
-	int i;
-
-	if (!phy_db)
-		return;
-
-	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CFG, 0);
-	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_NCH, 0);
-	iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CH, 0);
-	for (i = 0; i < IWL_NUM_PAPD_CH_GROUPS; i++)
-		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_PAPD, i);
-	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++)
-		iwl_phy_db_free_section(phy_db, IWL_PHY_DB_CALIB_CHG_TXP, i);
-
-	kfree(phy_db);
-}
-
-int iwl_phy_db_set_section(struct iwl_phy_db *phy_db,
-			   enum iwl_phy_db_section_type type, u8 *data,
-			   u16 size, gfp_t alloc_ctx)
-{
-	struct iwl_phy_db_entry *entry;
-	u16 chg_id = 0;
-
-	if (!phy_db)
-		return -EINVAL;
-
-	if (type == IWL_PHY_DB_CALIB_CHG_PAPD ||
-	    type == IWL_PHY_DB_CALIB_CHG_TXP)
-		chg_id = le16_to_cpup((__le16 *)data);
-
-	entry = iwl_phy_db_get_section(phy_db, type, chg_id);
-	if (!entry)
-		return -EINVAL;
-
-	kfree(entry->data);
-	entry->data = kmemdup(data, size, alloc_ctx);
-	if (!entry->data) {
-		entry->size = 0;
-		return -ENOMEM;
-	}
-
-	entry->size = size;
-
-	if (type == IWL_PHY_DB_CALIB_CH) {
-		phy_db->channel_num = le32_to_cpup((__le32 *)data);
-		phy_db->channel_size =
-		      (size - CHANNEL_NUM_SIZE) / phy_db->channel_num;
-	}
-
-	return 0;
-}
-
-static int is_valid_channel(u16 ch_id)
-{
-	if (ch_id <= 14 ||
-	    (36 <= ch_id && ch_id <= 64 && ch_id % 4 == 0) ||
-	    (100 <= ch_id && ch_id <= 140 && ch_id % 4 == 0) ||
-	    (145 <= ch_id && ch_id <= 165 && ch_id % 4 == 1))
-		return 1;
-	return 0;
-}
-
-static u8 ch_id_to_ch_index(u16 ch_id)
-{
-	if (WARN_ON(!is_valid_channel(ch_id)))
-		return 0xff;
-
-	if (ch_id <= 14)
-		return ch_id - 1;
-	if (ch_id <= 64)
-		return (ch_id + 20) / 4;
-	if (ch_id <= 140)
-		return (ch_id - 12) / 4;
-	return (ch_id - 13) / 4;
-}
-
-
-static u16 channel_id_to_papd(u16 ch_id)
-{
-	if (WARN_ON(!is_valid_channel(ch_id)))
-		return 0xff;
-
-	if (1 <= ch_id && ch_id <= 14)
-		return 0;
-	if (36 <= ch_id && ch_id <= 64)
-		return 1;
-	if (100 <= ch_id && ch_id <= 140)
-		return 2;
-	return 3;
-}
-
-static u16 channel_id_to_txp(struct iwl_phy_db *phy_db, u16 ch_id)
-{
-	struct iwl_phy_db_chg_txp *txp_chg;
-	int i;
-	u8 ch_index = ch_id_to_ch_index(ch_id);
-	if (ch_index == 0xff)
-		return 0xff;
-
-	for (i = 0; i < IWL_NUM_TXP_CH_GROUPS; i++) {
-		txp_chg = (void *)phy_db->calib_ch_group_txp[i].data;
-		if (!txp_chg)
-			return 0xff;
-		/*
-		 * Looking for the first channel group that its max channel is
-		 * higher then wanted channel.
-		 */
-		if (le16_to_cpu(txp_chg->max_channel_idx) >= ch_index)
-			return i;
-	}
-	return 0xff;
-}
-
-int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
-				enum iwl_phy_db_section_type type, u8 **data,
-				u16 *size, u16 ch_id)
-{
-	struct iwl_phy_db_entry *entry;
-	u32 channel_num;
-	u32 channel_size;
-	u16 ch_group_id = 0;
-	u16 index;
-
-	if (!phy_db)
-		return -EINVAL;
-
-	/* find wanted channel group */
-	if (type == IWL_PHY_DB_CALIB_CHG_PAPD)
-		ch_group_id = channel_id_to_papd(ch_id);
-	else if (type == IWL_PHY_DB_CALIB_CHG_TXP)
-		ch_group_id = channel_id_to_txp(phy_db, ch_id);
-
-	entry = iwl_phy_db_get_section(phy_db, type, ch_group_id);
-	if (!entry)
-		return -EINVAL;
-
-	if (type == IWL_PHY_DB_CALIB_CH) {
-		index = ch_id_to_ch_index(ch_id);
-		channel_num = phy_db->channel_num;
-		channel_size = phy_db->channel_size;
-		if (index >= channel_num) {
-			IWL_ERR(phy_db, "Wrong channel number %d", ch_id);
-			return -EINVAL;
-		}
-		*data = entry->data + CHANNEL_NUM_SIZE + index * channel_size;
-		*size = channel_size;
-	} else {
-		*data = entry->data;
-		*size = entry->size;
-	}
-	return 0;
-}
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
deleted file mode 100644
index c34c6a9..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.h
+++ /dev/null
@@ -1,129 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#ifndef __IWL_PHYDB_H__
-#define __IWL_PHYDB_H__
-
-#include <linux/types.h>
-
-#define IWL_NUM_PAPD_CH_GROUPS	4
-#define IWL_NUM_TXP_CH_GROUPS	8
-
-struct iwl_phy_db_entry {
-	u16	size;
-	u8	*data;
-};
-
-struct iwl_shared;
-
-/**
- * struct iwl_phy_db - stores phy configuration and calibration data.
- *
- * @cfg: phy configuration.
- * @calib_nch: non channel specific calibration data.
- * @calib_ch: channel specific calibration data.
- * @calib_ch_group_papd: calibration data related to papd channel group.
- * @calib_ch_group_txp: calibration data related to tx power chanel group.
- */
-struct iwl_phy_db {
-	struct iwl_phy_db_entry	cfg;
-	struct iwl_phy_db_entry	calib_nch;
-	struct iwl_phy_db_entry	calib_ch;
-	struct iwl_phy_db_entry	calib_ch_group_papd[IWL_NUM_PAPD_CH_GROUPS];
-	struct iwl_phy_db_entry	calib_ch_group_txp[IWL_NUM_TXP_CH_GROUPS];
-
-	u32 channel_num;
-	u32 channel_size;
-
-	/* for an access to the logger */
-	struct device *dev;
-};
-
-enum iwl_phy_db_section_type {
-	IWL_PHY_DB_CFG = 1,
-	IWL_PHY_DB_CALIB_NCH,
-	IWL_PHY_DB_CALIB_CH,
-	IWL_PHY_DB_CALIB_CHG_PAPD,
-	IWL_PHY_DB_CALIB_CHG_TXP,
-	IWL_PHY_DB_MAX
-};
-
-/* for parsing of tx power channel group data that comes from the firmware*/
-struct iwl_phy_db_chg_txp {
-	__le32 space;
-	__le16 max_channel_idx;
-} __packed;
-
-struct iwl_phy_db *iwl_phy_db_init(struct device *dev);
-
-void iwl_phy_db_free(struct iwl_phy_db *phy_db);
-
-int iwl_phy_db_set_section(struct iwl_phy_db *phy_db,
-			   enum iwl_phy_db_section_type type, u8 *data,
-			   u16 size, gfp_t alloc_ctx);
-
-int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
-				enum iwl_phy_db_section_type type, u8 **data,
-				u16 *size, u16 ch_id);
-
-#endif /* __IWL_PHYDB_H__ */
-- 
1.7.10

