Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519D4746D6
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246393; cv=none; b=W3zQbFT6kf1gFN6GWWrfwbKoOmp2xfTCPUP+mh3aKM95XBpwc0YvIocaxg5QHT4WVwsw5H9iWrKkDNICWgyNB4DasHdoWhkVzFoT08GIeaXO7YY9bZP3MNNjPVritVurn6Y6V6U+ugqPRcOEzIQDGHnze1VQ8p0nPi9CNCY0qWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246393; c=relaxed/simple;
	bh=TKp9t3vzPNHsyrL+pBGOd4j280XeKTPGJYMF6WWpS98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hq60us05iDaNq8ri8Paw8nZFCXRAzsTRqPc4XY3Pz3Wx8OzRU0lLycdhWMSsNUooyOJTIfZuGpnHi+f8jjJ+fkErVdjSFfpTpA1CCw+F4aFADLTnCKTo5KDCQv7UlJhpIPi0w7OulPr9O86cz9XUCTdn2mv0qeGkmAj589H4ayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoO0MjZ7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoO0MjZ7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246391; x=1821782391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TKp9t3vzPNHsyrL+pBGOd4j280XeKTPGJYMF6WWpS98=;
  b=eoO0MjZ7As471VaKo53K6c/c0qdF+ovyDjv2Ueu7AaGn9ZdlHHEJkywL
   +XhT2P0rkVO25bzWZ1xYB21SKdfTFPTsfEYZ/GF+Ku3I0C4r/QvbooOBv
   R3A5Zq4V9V1MxBUY/jwPtpNzTpaW9BBmtyBVdd7qHXD1i5MglN8+BgVoy
   SQM9QqOqHvLB4SHufI1jjE8n2tybMUloy4/yaYst1leIX7/P9KvXNk0jT
   J/0uc0HtJf9mL7lX76giabGlMZ6aqZyKIF6MQQTp9voLDXbPV8k9fQ5rW
   gNxl/XbC44BsRDhxwgupV2suWkxpqE0P8WizA6965B07yoYXT4gHZ/QMF
   g==;
X-CSE-ConnectionGUID: IguurAH2Q12M8Ay6qMg5Fw==
X-CSE-MsgGUID: V727ihXERjKAWlyMQrrGLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134908"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134908"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:51 -0700
X-CSE-ConnectionGUID: /BsDC/vCS2S/C4lSuw99Wg==
X-CSE-MsgGUID: GYlhlB7RRSyCsfrmBQUURg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: support RX BAID modify command version 3
Date: Thu, 24 Sep 2026 13:41:27 +0300
Message-Id: <20260924133942.a480a348faec.Ie41b1d43f945a0c5e2bb68981a0cec0c62111233@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
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

