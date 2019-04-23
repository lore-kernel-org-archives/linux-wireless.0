Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBB5C282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3AD206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfDWJK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58970 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725888AbfDWJKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:54 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS0-0000FN-8K; Tue, 23 Apr 2019 12:10:52 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 04/16] iwlwifi: mvm: support v2 of the WoWLAN patterns command
Date:   Tue, 23 Apr 2019 12:10:31 +0300
Message-Id: <20190423091043.7156-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Add new definitions for the WoWLAN patterns API version 2 and support
for version 2 of the WoWLAN patterns command without implementing the
new features.  With this commit we only supporting the existing
bitmask pattern match.  Use the new version only if the TLV is set.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/d3.h    | 136 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   |  58 +++++++-
 3 files changed, 184 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index 86ea0784e1a3..31231b223aae 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -214,7 +214,7 @@ struct iwl_proto_offload_cmd_v3_large {
 #define IWL_WOWLAN_MIN_PATTERN_LEN	16
 #define IWL_WOWLAN_MAX_PATTERN_LEN	128
 
-struct iwl_wowlan_pattern {
+struct iwl_wowlan_pattern_v1 {
 	u8 mask[IWL_WOWLAN_MAX_PATTERN_LEN / 8];
 	u8 pattern[IWL_WOWLAN_MAX_PATTERN_LEN];
 	u8 mask_size;
@@ -227,7 +227,7 @@ struct iwl_wowlan_pattern {
 /**
  * struct iwl_wowlan_patterns_cmd - WoWLAN wakeup patterns
  */
-struct iwl_wowlan_patterns_cmd {
+struct iwl_wowlan_patterns_cmd_v1 {
 	/**
 	 * @n_patterns: number of patterns
 	 */
@@ -236,9 +236,129 @@ struct iwl_wowlan_patterns_cmd {
 	/**
 	 * @patterns: the patterns, array length in @n_patterns
 	 */
-	struct iwl_wowlan_pattern patterns[];
+	struct iwl_wowlan_pattern_v1 patterns[];
 } __packed; /* WOWLAN_PATTERN_ARRAY_API_S_VER_1 */
 
+#define IPV4_ADDR_SIZE	4
+#define IPV6_ADDR_SIZE	16
+
+enum iwl_wowlan_pattern_type {
+	WOWLAN_PATTERN_TYPE_BITMASK,
+	WOWLAN_PATTERN_TYPE_IPV4_TCP_SYN,
+	WOWLAN_PATTERN_TYPE_IPV6_TCP_SYN,
+	WOWLAN_PATTERN_TYPE_IPV4_TCP_SYN_WILDCARD,
+	WOWLAN_PATTERN_TYPE_IPV6_TCP_SYN_WILDCARD,
+}; /* WOWLAN_PATTERN_TYPE_API_E_VER_1 */
+
+/**
+ * struct iwl_wowlan_ipv4_tcp_syn - WoWLAN IPv4 TCP SYN pattern data
+ */
+struct iwl_wowlan_ipv4_tcp_syn {
+	/**
+	 * @src_addr: source IP address to match
+	 */
+	u8 src_addr[IPV4_ADDR_SIZE];
+
+	/**
+	 * @dst_addr: destination IP address to match
+	 */
+	u8 dst_addr[IPV4_ADDR_SIZE];
+
+	/**
+	 * @src_port: source TCP port to match
+	 */
+	__le16 src_port;
+
+	/**
+	 * @dst_port: destination TCP port to match
+	 */
+	__le16 dst_port;
+} __packed; /* WOWLAN_IPV4_TCP_SYN_API_S_VER_1 */
+
+/**
+ * struct iwl_wowlan_ipv6_tcp_syn - WoWLAN Ipv6 TCP SYN pattern data
+ */
+struct iwl_wowlan_ipv6_tcp_syn {
+	/**
+	 * @src_addr: source IP address to match
+	 */
+	u8 src_addr[IPV6_ADDR_SIZE];
+
+	/**
+	 * @dst_addr: destination IP address to match
+	 */
+	u8 dst_addr[IPV6_ADDR_SIZE];
+
+	/**
+	 * @src_port: source TCP port to match
+	 */
+	__le16 src_port;
+
+	/**
+	 * @dst_port: destination TCP port to match
+	 */
+	__le16 dst_port;
+} __packed; /* WOWLAN_IPV6_TCP_SYN_API_S_VER_1 */
+
+/**
+ * union iwl_wowlan_pattern_data - Data for the different pattern types
+ *
+ * If wildcard addresses/ports are to be used, the union can be left
+ * undefined.
+ */
+union iwl_wowlan_pattern_data {
+	/**
+	 * @bitmask: bitmask pattern data
+	 */
+	struct iwl_wowlan_pattern_v1 bitmask;
+
+	/**
+	 * @ipv4_tcp_syn: IPv4 TCP SYN pattern data
+	 */
+	struct iwl_wowlan_ipv4_tcp_syn ipv4_tcp_syn;
+
+	/**
+	 * @ipv6_tcp_syn: IPv6 TCP SYN pattern data
+	 */
+	struct iwl_wowlan_ipv6_tcp_syn ipv6_tcp_syn;
+}; /* WOWLAN_PATTERN_API_U_VER_1 */
+
+/**
+ * struct iwl_wowlan_pattern_v2 - Pattern entry for the WoWLAN wakeup patterns
+ */
+struct iwl_wowlan_pattern_v2 {
+	/**
+	 * @pattern_type: defines the struct type to be used in the union
+	 */
+	u8 pattern_type;
+
+	/**
+	 * @reserved: reserved for alignment
+	 */
+	u8 reserved[3];
+
+	/**
+	 * @u: the union containing the match data, or undefined for
+	 *     wildcard matches
+	 */
+	union iwl_wowlan_pattern_data u;
+} __packed; /* WOWLAN_PATTERN_API_S_VER_2 */
+
+/**
+ * struct iwl_wowlan_patterns_cmd - WoWLAN wakeup patterns command
+ */
+struct iwl_wowlan_patterns_cmd {
+	/**
+	 * @n_patterns: number of patterns
+	 */
+	__le32 n_patterns;
+
+	/**
+	 * @patterns: the patterns, array length in @n_patterns
+	 */
+	struct iwl_wowlan_pattern_v2 patterns[];
+} __packed; /* WOWLAN_PATTERN_ARRAY_API_S_VER_2 */
+
 enum iwl_wowlan_wakeup_filters {
 	IWL_WOWLAN_WAKEUP_MAGIC_PACKET			= BIT(0),
 	IWL_WOWLAN_WAKEUP_PATTERN_MATCH			= BIT(1),
@@ -383,7 +503,11 @@ enum iwl_wowlan_wakeup_reason {
 	IWL_WOWLAN_WAKEUP_BY_D3_WAKEUP_HOST_TIMER		= BIT(14),
 	IWL_WOWLAN_WAKEUP_BY_RXFRAME_FILTERED_IN		= BIT(15),
 	IWL_WOWLAN_WAKEUP_BY_BEACON_FILTERED_IN			= BIT(16),
-
+	IWL_WAKEUP_BY_11W_UNPROTECTED_DEAUTH_OR_DISASSOC	= BIT(17),
+	IWL_WAKEUP_BY_PATTERN_IPV4_TCP_SYN			= BIT(18),
+	IWL_WAKEUP_BY_PATTERN_IPV4_TCP_SYN_WILDCARD		= BIT(19),
+	IWL_WAKEUP_BY_PATTERN_IPV6_TCP_SYN			= BIT(20),
+	IWL_WAKEUP_BY_PATTERN_IPV6_TCP_SYN_WILDCARD		= BIT(21),
 }; /* WOWLAN_WAKE_UP_REASON_API_E_VER_2 */
 
 struct iwl_wowlan_gtk_status_v1 {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 1cc56003b349..42cbf57857af 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -311,6 +311,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
 	IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS    = (__force iwl_ucode_tlv_api_t)50,
 	IWL_UCODE_TLV_API_MBSSID_HE		= (__force iwl_ucode_tlv_api_t)52,
+	IWL_UCODE_TLV_API_WOWLAN_TCP_SYN_WAKE	= (__force iwl_ucode_tlv_api_t)53,
 	IWL_UCODE_TLV_API_FTM_RTT_ACCURACY      = (__force iwl_ucode_tlv_api_t)54,
 
 	NUM_IWL_UCODE_TLV_API
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 83fd7f93d9f5..60f5d337f16d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -385,10 +385,10 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 	}
 }
 
-static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
-				 struct cfg80211_wowlan *wowlan)
+static int iwl_mvm_send_patterns_v1(struct iwl_mvm *mvm,
+				    struct cfg80211_wowlan *wowlan)
 {
-	struct iwl_wowlan_patterns_cmd *pattern_cmd;
+	struct iwl_wowlan_patterns_cmd_v1 *pattern_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = WOWLAN_PATTERNS,
 		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
@@ -399,7 +399,7 @@ static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
 		return 0;
 
 	cmd.len[0] = sizeof(*pattern_cmd) +
-		wowlan->n_patterns * sizeof(struct iwl_wowlan_pattern);
+		wowlan->n_patterns * sizeof(struct iwl_wowlan_pattern_v1);
 
 	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
 	if (!pattern_cmd)
@@ -426,6 +426,50 @@ static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
 	return err;
 }
 
+static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
+				 struct cfg80211_wowlan *wowlan)
+{
+	struct iwl_wowlan_patterns_cmd *pattern_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = WOWLAN_PATTERNS,
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+	};
+	int i, err;
+
+	if (!wowlan->n_patterns)
+		return 0;
+
+	cmd.len[0] = sizeof(*pattern_cmd) +
+		wowlan->n_patterns * sizeof(struct iwl_wowlan_pattern_v2);
+
+	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
+	if (!pattern_cmd)
+		return -ENOMEM;
+
+	pattern_cmd->n_patterns = cpu_to_le32(wowlan->n_patterns);
+
+	for (i = 0; i < wowlan->n_patterns; i++) {
+		int mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
+
+		pattern_cmd->patterns[i].pattern_type =
+			WOWLAN_PATTERN_TYPE_BITMASK;
+
+		memcpy(&pattern_cmd->patterns[i].u.bitmask.mask,
+		       wowlan->patterns[i].mask, mask_len);
+		memcpy(&pattern_cmd->patterns[i].u.bitmask.pattern,
+		       wowlan->patterns[i].pattern,
+		       wowlan->patterns[i].pattern_len);
+		pattern_cmd->patterns[i].u.bitmask.mask_size = mask_len;
+		pattern_cmd->patterns[i].u.bitmask.pattern_size =
+			wowlan->patterns[i].pattern_len;
+	}
+
+	cmd.data[0] = pattern_cmd;
+	err = iwl_mvm_send_cmd(mvm, &cmd);
+	kfree(pattern_cmd);
+	return err;
+}
+
 static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				struct ieee80211_sta *ap_sta)
 {
@@ -851,7 +895,11 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_send_patterns(mvm, wowlan);
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_WOWLAN_TCP_SYN_WAKE))
+		ret = iwl_mvm_send_patterns(mvm, wowlan);
+	else
+		ret = iwl_mvm_send_patterns_v1(mvm, wowlan);
 	if (ret)
 		return ret;
 
-- 
2.20.1

