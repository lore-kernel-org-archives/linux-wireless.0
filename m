Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37374433046
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716738; cv=none; b=QH5M3VJyVQxfwOHwy4lxq7aDEl84skOoU2TVQXlnzfVBIw4bHIRk3P4+FfkiOBkmTMCzMC2zRjrI9CuN6iwNtFhNxVTjVq9Krh9C7H3kvLMx01P0mbxL4i+AmHENDRRAJR6DNAFbeDDGdyv6HyX9E61ZUKVaShPFYcBsfJfGrME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716738; c=relaxed/simple;
	bh=AOBtbGH9VKXKu4lmBLuDlRDrrq6PKBNBBXflt/fD5aA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=srC5IEcT6bQdZ9K28Et6FfBI76SgJ1emnK/vyzi6ftBQWcxhtSIhOvftphfBQrZZvOXzPjarbv1hyQi+xIrDNw28+QeeNR8VgQVBg+ERacFACvYKoZOgy9gOyS+ADyOdQXpvG8XQgg6nv2Bjtxr5EnwdZA4z0Yb2Vzqybl3tAyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=diVHsSA7; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="diVHsSA7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716738; x=1823252738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AOBtbGH9VKXKu4lmBLuDlRDrrq6PKBNBBXflt/fD5aA=;
  b=diVHsSA7nAANVDKPYQfeeHAqR/HIV3G4Z8r0XApHU7MwYLMK1LzwbLXf
   4SW8TLt0HcahTwsWpWGQGHtm16aurpBFvpEDhfRgGDYcibzxT3rut1r3d
   xYCqa6WJcaf9jJf+1BQdP5PvgsbB7/Rhz4Og+/Uti6FLjg8XsKGop3abW
   iTmbIlZzAq/24XNfpJGtw6GuywmlMFlyrMuHo5ZgXPQ3VjHfGsZEBAWgu
   SSd8skyFE9teHxr2BY2IICXJ3agRXX3KWj3zClvH2kEwkV+l3FuVH41do
   THuqV/wr/bqWrA7TWnRmAI3W63LrySO8DJh+7SN3a4kNmd2bczu1l4Wuv
   w==;
X-CSE-ConnectionGUID: PWvd040kQRG+hPT6HJAd4Q==
X-CSE-MsgGUID: j5TPzeRnTRmEhKRhjTSgIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454186"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454186"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:37 -0700
X-CSE-ConnectionGUID: TeWMiF7mTu6NG7XTTj7qYA==
X-CSE-MsgGUID: duXVTk4ZRE6WWFmosMjUKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651034"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:35 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 12/13] wifi: iwlwifi: support SCD_QUEUE_CONFIG_CMD version 4
Date: Sun, 11 Oct 2026 14:07:13 +0300
Message-Id: <20261011140453.534cc32f2ac6.I394c38c58ad6619e3e52b52c3bc686acbbd2e4f1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This version has a new flags field that must be set to
indicate which other fields are valid, in preparation
for moving queue pointers during SMD transition.

Only set the IWL_SCD_QUEUE_MODIFY_FLAG_STA_MSK flag on
the existing users of the command for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/datapath.h  | 20 ++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |  4 ++++
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  3 ++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index 3fbcb2e4bfe0..eddf13325df9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -608,6 +608,16 @@ enum iwl_scd_queue_cfg_operation {
 	IWL_SCD_QUEUE_MODIFY = 2,
 };
 
+/**
+ * enum iwl_scd_queue_modify_flags - scheduler queue modify flags
+ * @IWL_SCD_QUEUE_MODIFY_FLAG_RD_PTR: update the read pointer
+ * @IWL_SCD_QUEUE_MODIFY_FLAG_STA_MSK: update the station mask
+ */
+enum iwl_scd_queue_modify_flags {
+	IWL_SCD_QUEUE_MODIFY_FLAG_RD_PTR	= BIT(0),
+	IWL_SCD_QUEUE_MODIFY_FLAG_STA_MSK	= BIT(1),
+};
+
 /**
  * struct iwl_scd_queue_cfg_cmd - scheduler queue allocation command
  * @operation: the operation, see &enum iwl_scd_queue_cfg_operation
@@ -625,6 +635,8 @@ enum iwl_scd_queue_cfg_operation {
  * @u.modify.old_sta_mask: old station mask for modify
  * @u.modify.tid: TID of queue to modify
  * @u.modify.new_sta_mask: new station mask for modify
+ * @u.modify.rd_ptr: new read pointer to set for the queue (version 4)
+ * @u.modify.flags: &enum iwl_scd_queue_modify_flags (version 4)
  */
 struct iwl_scd_queue_cfg_cmd {
 	__le32 operation;
@@ -646,9 +658,11 @@ struct iwl_scd_queue_cfg_cmd {
 			__le32 old_sta_mask;
 			__le32 tid;
 			__le32 new_sta_mask;
-		} __packed modify; /* TX_QUEUE_CFG_CMD_MODIFY_API_S_VER_1 */
-	} __packed u; /* TX_QUEUE_CFG_CMD_OPERATION_API_U_VER_1 */
-} __packed; /* TX_QUEUE_CFG_CMD_API_S_VER_3 */
+			__le16 rd_ptr;
+			__le16 flags;
+		} __packed modify; /* TX_QUEUE_CFG_CMD_MODIFY_API_S_VER_1, _VER_2 */
+	} __packed u; /* TX_QUEUE_CFG_CMD_OPERATION_API_U_VER_1, _VER_2 */
+} __packed; /* TX_QUEUE_CFG_CMD_API_S_VER_3, _VER_4 */
 
 /**
  * enum iwl_sec_key_flags - security key command key flags
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index fc501ac0c1f2..44aa317b8e7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -1484,6 +1484,10 @@ int iwl_mld_update_sta_txqs(struct iwl_mld *mld,
 
 	lockdep_assert_wiphy(mld->wiphy);
 
+	if (mld->trans->conf.queue_alloc_cmd_ver >= 4)
+		cmd.u.modify.flags =
+			cpu_to_le16(IWL_SCD_QUEUE_MODIFY_FLAG_STA_MSK);
+
 	for (int tid = 0; tid <= IWL_MAX_TID_COUNT; tid++) {
 		struct ieee80211_txq *txq =
 			sta->txq[tid != IWL_MAX_TID_COUNT ?
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index e6bebd37417f..b235a4539d7c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1075,7 +1075,8 @@ int iwl_txq_dyn_alloc(struct iwl_trans *trans, u32 flags, u32 sta_mask,
 		hcmd.id = SCD_QUEUE_CFG;
 		hcmd.len[0] = sizeof(cmd.old);
 		hcmd.data[0] = &cmd.old;
-	} else if (trans->conf.queue_alloc_cmd_ver == 3) {
+	} else if (trans->conf.queue_alloc_cmd_ver == 3 ||
+		   trans->conf.queue_alloc_cmd_ver == 4) {
 		memset(&cmd.new, 0, sizeof(cmd.new));
 		cmd.new.operation = cpu_to_le32(IWL_SCD_QUEUE_ADD);
 		cmd.new.u.add.tfdq_dram_addr = cpu_to_le64(txq->dma_addr);
-- 
2.34.1

