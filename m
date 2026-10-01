Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB86547044
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860734; cv=none; b=ojfVK7wKJiM9iA1sLnvjRlxKCcwwdzN6xJkzTcgnKkX3/s8bbOIKrLKWcNX8f7y1+Wq8GZ7fLIVZnl7bIrM+hbOXjONq6y/MjFRsItyL5DwaqDRmpoOF01m3YQ8Sdi9wcnxzL8SZK89ACJmjI9Qo8CIBWrYl7A8UP8Lpufc5LHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860734; c=relaxed/simple;
	bh=Jw8TLq8nKmSg/G6sRnrUHzqzFgLpoVKncxGimMtuJwo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bc2CO88Klf6s5L2vW4UnxZZlbpgI50yb0sfldG2QANwhGFqfLNdE9WK/vBLW/fUhMYMFTFyE6SHkdeaXomi1E0WvPSLpEBp3STvlLCEkcBidt8qXpa35YipiULQvvs2/rvk9tDG2aDYsby18mULnr8/BBkjhCK2Eqbx7M9akXNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOx9MjQC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOx9MjQC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860731; x=1822396731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jw8TLq8nKmSg/G6sRnrUHzqzFgLpoVKncxGimMtuJwo=;
  b=YOx9MjQCtVFaDIpCm4QZ2hkIoM5CAQX7YSbhvGf81peqb2VSLhT3435Y
   qsgM/TjoKSbES6XNbwKO3zL3L7Osu1lNS81cOWs074hy6pEvXl5beIXfL
   Vl0ZKQTIPeJdgE0HRbu26N/zeBKIrWrlW8KaYwhBtdHyRVsS+0a/zKldW
   77GvdeS0jcOPh2wrkbrrhoJCQJz5VTNYSSZiEU1sLKH8l7eBo3Mv0Zgpp
   GeerCgHQ4Hb/H9EO5xTBq15FlVX/VWxRYK4+Nz9qvBimLwdLxpvwohWZ+
   c4q0tw8ChASkwNRsKOOhI4Evqy7Wl7pmp+0vqIQDART0T7w959mI4Vxvc
   g==;
X-CSE-ConnectionGUID: 0OGiIoLeTguyTjg2FkXK0w==
X-CSE-MsgGUID: JupADfMHSy6mv03f9Dszcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423641"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423641"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:50 -0700
X-CSE-ConnectionGUID: P3o7cpdSQvmXd3tpUiqakA==
X-CSE-MsgGUID: t4xZCtUSQJWTIlAnu/6GHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485562"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: mld: add support for WoWLAN CIGTK API
Date: Thu,  1 Oct 2026 16:20:26 +0300
Message-Id: <20261001161715.45aa7d3f2421.I1c53d0b8f1a1f1b3a4e35a86b5a6a5c04ff5f1a2@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware added CIGTK rekey support for D3:

 - KEK_KCK_MATERIAL_CMD version 5 has a new cigtk_cipher field.
 - WOWLAN_INFO_NOTIFICATION version 7 reports the CIGTK material of
   the active link, and MLO keys can now be of type CIGTK.

The CIGTK material itself is not used yet, this is done in a
separate patch.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/commands.h  |  5 +-
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    | 62 +++++++++++++++-
 .../wireless/intel/iwlwifi/fw/api/offload.h   |  5 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   | 71 +++++++++++++++++--
 4 files changed, 133 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index f76f76e54c4e..dbb0e7c194df 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -569,8 +569,9 @@ enum iwl_legacy_cmds {
 
 	/**
 	 * @WOWLAN_KEK_KCK_MATERIAL: &struct iwl_wowlan_kek_kck_material_cmd_v2,
-	 * &struct iwl_wowlan_kek_kck_material_cmd_v3 or
-	 * &struct iwl_wowlan_kek_kck_material_cmd_v4
+	 * &struct iwl_wowlan_kek_kck_material_cmd_v3,
+	 * &struct iwl_wowlan_kek_kck_material_cmd_v4 or
+	 * &struct iwl_wowlan_kek_kck_material_cmd
 	 */
 	WOWLAN_KEK_KCK_MATERIAL = 0xe4,
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index a0379aca99d7..c469ea965157 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -422,6 +422,7 @@ struct iwl_wowlan_config_cmd {
 #define WOWLAN_IGTK_MIN_INDEX	4
 #define WOWLAN_BIGTK_KEYS_NUM	2
 #define WOWLAN_BIGTK_MIN_INDEX	6
+#define WOWLAN_CIGTK_KEYS_NUM	2
 
 /*
  * WOWLAN_TSC_RSC_PARAMS
@@ -531,6 +532,20 @@ struct iwl_wowlan_kek_kck_material_cmd_v4 {
 	__le32  bigtk_cipher;
 } __packed; /* KEK_KCK_MATERIAL_API_S_VER_4 */
 
+struct iwl_wowlan_kek_kck_material_cmd {
+	__le32  sta_id;
+	u8	kck[IWL_KCK_MAX_SIZE];
+	u8	kek[IWL_KEK_MAX_SIZE];
+	__le16	kck_len;
+	__le16	kek_len;
+	__le64	replay_ctr;
+	__le32  akm;
+	__le32  gtk_cipher;
+	__le32  igtk_cipher;
+	__le32  bigtk_cipher;
+	__le32  cigtk_cipher;
+} __packed; /* KEK_KCK_MATERIAL_API_S_VER_5 */
+
 struct iwl_wowlan_get_status_cmd {
 	__le32  sta_id;
 } __packed; /* WOWLAN_GET_STATUSES_CMD_API_S_VER_1 */
@@ -812,19 +827,21 @@ struct iwl_wowlan_info_notif_v1 {
 } __packed; /* WOWLAN_INFO_NTFY_API_S_VER_1 */
 
 /* MAX MLO keys of non-active links that can arrive in the notification */
-#define WOWLAN_MAX_MLO_KEYS 18
+#define WOWLAN_MAX_MLO_KEYS 24
 
 /**
  * enum iwl_wowlan_mlo_gtk_type - GTK types
  * @WOWLAN_MLO_GTK_KEY_TYPE_GTK: GTK
  * @WOWLAN_MLO_GTK_KEY_TYPE_IGTK: IGTK
  * @WOWLAN_MLO_GTK_KEY_TYPE_BIGTK: BIGTK
+ * @WOWLAN_MLO_GTK_KEY_TYPE_CIGTK: CIGTK
  * @WOWLAN_MLO_GTK_KEY_NUM_TYPES: number of key types
  */
 enum iwl_wowlan_mlo_gtk_type {
 	WOWLAN_MLO_GTK_KEY_TYPE_GTK,
 	WOWLAN_MLO_GTK_KEY_TYPE_IGTK,
 	WOWLAN_MLO_GTK_KEY_TYPE_BIGTK,
+	WOWLAN_MLO_GTK_KEY_TYPE_CIGTK,
 	WOWLAN_MLO_GTK_KEY_NUM_TYPES
 }; /* WOWLAN_MLO_GTK_KEY_TYPE_API_E_VER_1 */
 
@@ -931,11 +948,51 @@ struct iwl_wowlan_info_notif_v5 {
 	struct iwl_wowlan_mlo_gtk mlo_gtks[];
 } __packed; /* WOWLAN_INFO_NTFY_API_S_VER_5 */
 
+/**
+ * struct iwl_wowlan_info_notif_v6 - WoWLAN information notification
+ * @gtk: GTK data
+ * @igtk: IGTK data
+ * @bigtk: BIGTK data
+ * @replay_ctr: GTK rekey replay counter
+ * @pattern_number: number of the matched patterns
+ * @qos_seq_ctr: QoS sequence counters to use next
+ * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
+ * @num_of_gtk_rekeys: number of GTK rekeys
+ * @transmitted_ndps: number of transmitted neighbor discovery packets
+ * @received_beacons: number of received beacons
+ * @tid_tear_down: bit mask of tids whose BA sessions were closed
+ *	in suspend state
+ * @station_id: station id
+ * @num_mlo_link_keys: number of &struct iwl_wowlan_mlo_gtk structs
+ *	following this notif
+ * @tid_offloaded_tx: tid used by the firmware to transmit data packets
+ *	while in wowlan
+ * @mlo_gtks: array of GTKs of size num_mlo_link_keys
+ */
+struct iwl_wowlan_info_notif_v6 {
+	struct iwl_wowlan_gtk_status gtk[WOWLAN_GTK_KEYS_NUM];
+	struct iwl_wowlan_igtk_status igtk[WOWLAN_IGTK_KEYS_NUM];
+	struct iwl_wowlan_igtk_status bigtk[WOWLAN_BIGTK_KEYS_NUM];
+	__le64 replay_ctr;
+	__le16 pattern_number;
+	__le16 qos_seq_ctr;
+	__le32 wakeup_reasons;
+	__le32 num_of_gtk_rekeys;
+	__le32 transmitted_ndps;
+	__le32 received_beacons;
+	u8 tid_tear_down;
+	u8 station_id;
+	u8 num_mlo_link_keys;
+	u8 tid_offloaded_tx;
+	struct iwl_wowlan_mlo_gtk mlo_gtks[];
+} __packed; /* WOWLAN_INFO_NTFY_API_S_VER_6 */
+
 /**
  * struct iwl_wowlan_info_notif - WoWLAN information notification
  * @gtk: GTK data
  * @igtk: IGTK data
  * @bigtk: BIGTK data
+ * @cigtk: CIGTK data
  * @replay_ctr: GTK rekey replay counter
  * @pattern_number: number of the matched patterns
  * @qos_seq_ctr: QoS sequence counters to use next
@@ -956,6 +1013,7 @@ struct iwl_wowlan_info_notif {
 	struct iwl_wowlan_gtk_status gtk[WOWLAN_GTK_KEYS_NUM];
 	struct iwl_wowlan_igtk_status igtk[WOWLAN_IGTK_KEYS_NUM];
 	struct iwl_wowlan_igtk_status bigtk[WOWLAN_BIGTK_KEYS_NUM];
+	struct iwl_wowlan_igtk_status cigtk[WOWLAN_CIGTK_KEYS_NUM];
 	__le64 replay_ctr;
 	__le16 pattern_number;
 	__le16 qos_seq_ctr;
@@ -968,7 +1026,7 @@ struct iwl_wowlan_info_notif {
 	u8 num_mlo_link_keys;
 	u8 tid_offloaded_tx;
 	struct iwl_wowlan_mlo_gtk mlo_gtks[];
-} __packed; /* WOWLAN_INFO_NTFY_API_S_VER_6 */
+} __packed; /* WOWLAN_INFO_NTFY_API_S_VER_7 */
 
 /**
  * struct iwl_wowlan_wake_pkt_notif - WoWLAN wake packet notification
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/offload.h b/drivers/net/wireless/intel/iwlwifi/fw/api/offload.h
index bb801650a565..078116fab054 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/offload.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/offload.h
@@ -3,7 +3,7 @@
  * Copyright (C) 2012-2014 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2021-2025 Intel Corporation
+ * Copyright (C) 2021-2026 Intel Corporation
  */
 #ifndef __iwl_fw_api_offload_h__
 #define __iwl_fw_api_offload_h__
@@ -20,7 +20,8 @@ enum iwl_prot_offload_subcmd_ids {
 	/**
 	 * @WOWLAN_INFO_NOTIFICATION: Notification in
 	 * &struct iwl_wowlan_info_notif_v1, iwl_wowlan_info_notif_v3,
-	 * &struct iwl_wowlan_info_notif_v5 or &struct iwl_wowlan_info_notif
+	 * &struct iwl_wowlan_info_notif_v5, &struct iwl_wowlan_info_notif_v6
+	 * or &struct iwl_wowlan_info_notif
 	 */
 	WOWLAN_INFO_NOTIFICATION = 0xFD,
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 7a7d07a7914d..ce959363f62c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -598,6 +598,37 @@ iwl_mld_convert_wowlan_notif_v5(const struct iwl_wowlan_info_notif_v5 *notif_v5,
 	}
 }
 
+static void
+iwl_mld_convert_wowlan_notif_v6(const struct iwl_wowlan_info_notif_v6 *notif_v6,
+				struct iwl_wowlan_info_notif *notif)
+{
+	/* v6 is identical to the new format, except that it has no CIGTK */
+	BUILD_BUG_ON(sizeof(notif->gtk) != sizeof(notif_v6->gtk));
+	BUILD_BUG_ON(sizeof(notif->igtk) != sizeof(notif_v6->igtk));
+	BUILD_BUG_ON(sizeof(notif->bigtk) != sizeof(notif_v6->bigtk));
+
+	memcpy(notif->gtk, notif_v6->gtk, sizeof(notif_v6->gtk));
+	memcpy(notif->igtk, notif_v6->igtk, sizeof(notif_v6->igtk));
+	memcpy(notif->bigtk, notif_v6->bigtk, sizeof(notif_v6->bigtk));
+
+	notif->replay_ctr = notif_v6->replay_ctr;
+	notif->pattern_number = notif_v6->pattern_number;
+	notif->qos_seq_ctr = notif_v6->qos_seq_ctr;
+	notif->wakeup_reasons = notif_v6->wakeup_reasons;
+	notif->num_of_gtk_rekeys = notif_v6->num_of_gtk_rekeys;
+	notif->transmitted_ndps = notif_v6->transmitted_ndps;
+	notif->received_beacons = notif_v6->received_beacons;
+	notif->tid_tear_down = notif_v6->tid_tear_down;
+	notif->station_id = notif_v6->station_id;
+	notif->num_mlo_link_keys = notif_v6->num_mlo_link_keys;
+	notif->tid_offloaded_tx = notif_v6->tid_offloaded_tx;
+
+	if (notif_v6->num_mlo_link_keys)
+		memcpy(notif->mlo_gtks, notif_v6->mlo_gtks,
+		       notif_v6->num_mlo_link_keys *
+		       sizeof(struct iwl_wowlan_mlo_gtk));
+}
+
 static bool iwl_mld_validate_wowlan_notif_size(struct iwl_mld *mld, u32 len,
 					       const void *notif_data,
 					       int version)
@@ -619,12 +650,23 @@ static bool iwl_mld_validate_wowlan_notif_size(struct iwl_mld *mld, u32 len,
 
 		num_mlo_keys = notif_v5->num_mlo_link_keys;
 	} else if (version == 6) {
+		const struct iwl_wowlan_info_notif_v6 *notif_v6 = notif_data;
+
+		expected_len = sizeof(*notif_v6);
+
+		if (IWL_FW_CHECK(mld, len < expected_len,
+				 "Invalid wowlan_info_notif v6 (expected=%u got=%u)\n",
+				 expected_len, len))
+			return false;
+
+		num_mlo_keys = notif_v6->num_mlo_link_keys;
+	} else if (version == 7) {
 		const struct iwl_wowlan_info_notif *notif = notif_data;
 
 		expected_len = sizeof(*notif);
 
 		if (IWL_FW_CHECK(mld, len < expected_len,
-				 "Invalid wowlan_info_notif v6 (expected=%u got=%u)\n",
+				 "Invalid wowlan_info_notif v7 (expected=%u got=%u)\n",
 				 expected_len, len))
 			return false;
 
@@ -683,9 +725,27 @@ iwl_mld_handle_wowlan_info_notif(struct iwl_mld *mld,
 		iwl_mld_convert_wowlan_notif_v5(_notif, converted_notif);
 		notif = converted_notif;
 	} else if (wowlan_info_ver == 6) {
+		const struct iwl_wowlan_info_notif_v6 *_notif =
+			(void *)pkt->data;
+
+		if (!iwl_mld_validate_wowlan_notif_size(mld, len, _notif, 6))
+			return true;
+
+		converted_notif = kzalloc_flex(*converted_notif, mlo_gtks,
+					       _notif->num_mlo_link_keys,
+					       GFP_ATOMIC);
+		if (!converted_notif) {
+			IWL_ERR(mld,
+				"Failed to allocate memory for converted wowlan_info_notif\n");
+			return true;
+		}
+
+		iwl_mld_convert_wowlan_notif_v6(_notif, converted_notif);
+		notif = converted_notif;
+	} else if (wowlan_info_ver == 7) {
 		notif = (void *)pkt->data;
 
-		if (!iwl_mld_validate_wowlan_notif_size(mld, len, notif, 6))
+		if (!iwl_mld_validate_wowlan_notif_size(mld, len, notif, 7))
 			return true;
 	} else {
 		/* smaller versions are not supported */
@@ -1834,9 +1894,12 @@ iwl_mld_send_kek_kck_cmd(struct iwl_mld *mld,
 			 struct iwl_mld_suspend_key_iter_data data,
 			 int ap_sta_id)
 {
-	struct iwl_wowlan_kek_kck_material_cmd_v4 kek_kck_cmd = {};
+	u8 cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, WOWLAN_KEK_KCK_MATERIAL, 4);
+	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
 	struct iwl_mld_rekey_data *rekey_data =
 		&mld_vif->wowlan_data.rekey_data;
+	u32 cmd_size = cmd_ver == 5 ? sizeof(kek_kck_cmd) :
+		sizeof(struct iwl_wowlan_kek_kck_material_cmd_v4);
 
 	memcpy(kek_kck_cmd.kck, rekey_data->kck,
 	       rekey_data->kck_len);
@@ -1855,7 +1918,7 @@ iwl_mld_send_kek_kck_cmd(struct iwl_mld *mld,
 			 rekey_data->akm);
 
 	return iwl_mld_send_cmd_pdu(mld, WOWLAN_KEK_KCK_MATERIAL,
-				    &kek_kck_cmd);
+				    &kek_kck_cmd, cmd_size);
 }
 
 static int
-- 
2.34.1

