Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452D628DB55
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442957; cv=none; b=Zo5ndK3JD9D5sUsQaOJbSjdfS5Ns8UDLiFGnZTPl07PXSKz/wd6C54PfNNc4nqrKBpZRVrz0T2cldbfCPYAYj48no0XVnWhz2bRoEJ7RBaQZS3XXWpxChfpvy6nw1RFTg7OFc2EiwZnw2PigZGikNT0c5bS50C4jLbzipjchv6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442957; c=relaxed/simple;
	bh=TKp9t3vzPNHsyrL+pBGOd4j280XeKTPGJYMF6WWpS98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dCNLVqdcHP06Aj+8HqXmKlbh0uwoGGfx+xZBc3TFKbTIy/Ldvvp3FD21M+ANOCPIt12Ry5k4when4Nu6pOUzpF3gb9Ra8DQ/Wmwjo0PZo1rGg8oVwJCdwOCzPFmTapZZeLr0OULvl95Y6OVG7dJqfLONnlcwIDTVZTF/j77Mbxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNHlmtyr; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNHlmtyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442957; x=1821978957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKp9t3vzPNHsyrL+pBGOd4j280XeKTPGJYMF6WWpS98=;
  b=VNHlmtyrJPo2C/E64Sz4ZOztpj7etaN9oc/ml4qAStLI9ZgMdgohB+Dr
   n/Gubx4tQJc1IroxHf4UefDObLPE9FK/e99RHoHQnxNIOrVzELiQ7TgWg
   5UNYBtqFVRhRo1BLxgKzJ7cB0ZQ76V3SsqcPjSov7Wwngqxg0lQjJru2g
   sHnj6D91OdTHU1ag5gK7eOxOqbuZ1xJoij5LDNyNGCM6o7ad+zFqQRI/3
   P+Wa3tPjco3iw2gBE/dGJT1EIowW1tMCyP0V12l6ZuJgsrNEPYzOK663a
   96Pwxklt3v0uKdi1XTREDE+E5uL23T/QFoTEK+groUDBbWoF/TeWnBGhc
   A==;
X-CSE-ConnectionGUID: RcoUHBP/RwOw9kry9aIiBA==
X-CSE-MsgGUID: tY6q5BmtQpaqvF7P8glMMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533302"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533302"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:56 -0700
X-CSE-ConnectionGUID: NJ/gnJYyQlqOz++L+1xBPQ==
X-CSE-MsgGUID: WZnUQ0VYRJCf31UOT0jaaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274197026"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:55 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 13/15] wifi: iwlwifi: support RX BAID modify command version 3
Date: Sat, 26 Sep 2026 20:17:32 +0300
Message-Id: <20260926201527.46c77de75c0b.Ie41b1d43f945a0c5e2bb68981a0cec0c62111233@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Version 3 of the RX BAID allocation modify command shrinks the tid
field to a u8 and adds a window size field, so that the window size
can be updated while moving a BAID to a new AP. A window size of 0
tells the firmware to keep the current one, which is what we need
for now.

Add the new layout and pick it based on the command version.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/datapath.h  | 29 +++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mld/agg.c  |  7 ++++-
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index b17babef71c0..3fbcb2e4bfe0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -522,17 +522,34 @@ struct iwl_rx_baid_cfg_cmd_alloc {
 } __packed; /* RX_BAID_ALLOCATION_ADD_CMD_API_S_VER_1 */
 
 /**
- * struct iwl_rx_baid_cfg_cmd_modify - BAID modification data
+ * struct iwl_rx_baid_cfg_cmd_modify_v2 - BAID modification data
  * @old_sta_id_mask: old station ID mask
  * @new_sta_id_mask: new station ID mask
  * @tid: TID of the BAID
  */
-struct iwl_rx_baid_cfg_cmd_modify {
+struct iwl_rx_baid_cfg_cmd_modify_v2 {
 	__le32 old_sta_id_mask;
 	__le32 new_sta_id_mask;
 	__le32 tid;
 } __packed; /* RX_BAID_ALLOCATION_MODIFY_CMD_API_S_VER_2 */
 
+/**
+ * struct iwl_rx_baid_cfg_cmd_modify - BAID modification data
+ * @old_sta_id_mask: old station ID mask
+ * @new_sta_id_mask: new station ID mask
+ * @tid: TID of the BAID
+ * @reserved: reserved
+ * @win_size: RX BA session window size to apply to the modified BAID,
+ *	0 means keep the current one
+ */
+struct iwl_rx_baid_cfg_cmd_modify {
+	__le32 old_sta_id_mask;
+	__le32 new_sta_id_mask;
+	u8 tid;
+	u8 reserved;
+	__le16 win_size;
+} __packed; /* RX_BAID_ALLOCATION_MODIFY_CMD_API_S_VER_3 */
+
 /**
  * struct iwl_rx_baid_cfg_cmd_remove_v1 - BAID removal data
  * @baid: the BAID to remove
@@ -555,7 +572,8 @@ struct iwl_rx_baid_cfg_cmd_remove {
  * struct iwl_rx_baid_cfg_cmd - BAID allocation/config command
  * @action: the action, from &enum iwl_rx_baid_action
  * @alloc: allocation data
- * @modify: modify data
+ * @modify_v2: modify data (version 2)
+ * @modify: modify data (version 3)
  * @remove_v1: remove data (version 1)
  * @remove: remove data
  */
@@ -563,11 +581,12 @@ struct iwl_rx_baid_cfg_cmd {
 	__le32 action;
 	union {
 		struct iwl_rx_baid_cfg_cmd_alloc alloc;
+		struct iwl_rx_baid_cfg_cmd_modify_v2 modify_v2;
 		struct iwl_rx_baid_cfg_cmd_modify modify;
 		struct iwl_rx_baid_cfg_cmd_remove_v1 remove_v1;
 		struct iwl_rx_baid_cfg_cmd_remove remove;
-	}; /* RX_BAID_ALLOCATION_OPERATION_API_U_VER_2 */
-} __packed; /* RX_BAID_ALLOCATION_CONFIG_CMD_API_S_VER_2 */
+	}; /* RX_BAID_ALLOCATION_OPERATION_API_U_VER_3 */
+} __packed; /* RX_BAID_ALLOCATION_CONFIG_CMD_API_S_VER_3 */
 
 /**
  * struct iwl_rx_baid_cfg_resp - BAID allocation response
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index c45c47337509..ea1f02380ad4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -660,6 +660,7 @@ int iwl_mld_update_sta_baids(struct iwl_mld *mld,
 		.modify.new_sta_id_mask = cpu_to_le32(new_sta_mask),
 	};
 	u32 cmd_id = WIDE_ID(DATA_PATH_GROUP, RX_BAID_ALLOCATION_CONFIG_CMD);
+	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, cmd_id, 2);
 	int baid;
 
 	/* mac80211 will remove sessions later, but we ignore all that */
@@ -667,6 +668,7 @@ int iwl_mld_update_sta_baids(struct iwl_mld *mld,
 		return 0;
 
 	BUILD_BUG_ON(sizeof(struct iwl_rx_baid_cfg_resp) != sizeof(baid));
+	BUILD_BUG_ON(sizeof(cmd.modify) != sizeof(cmd.modify_v2));
 
 	for (baid = 0; baid < ARRAY_SIZE(mld->fw_id_to_ba); baid++) {
 		struct iwl_mld_baid_data *data;
@@ -683,7 +685,10 @@ int iwl_mld_update_sta_baids(struct iwl_mld *mld,
 			  "BAID data for %d corrupted - expected 0x%x found 0x%x\n",
 			  baid, old_sta_mask, data->sta_mask);
 
-		cmd.modify.tid = cpu_to_le32(data->tid);
+		if (cmd_ver >= 3)
+			cmd.modify.tid = data->tid;
+		else
+			cmd.modify_v2.tid = cpu_to_le32(data->tid);
 
 		ret = iwl_mld_send_cmd_pdu(mld, cmd_id, &cmd);
 		if (ret)
-- 
2.34.1

