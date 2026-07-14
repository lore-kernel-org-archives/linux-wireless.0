Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF337DAA3
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028037; cv=none; b=NvvtTBy9DVxEHAtUEOvDVtY5f+ayKa2+w/2cZW8a1ApEMa2uEDQoT0lUg/7E9RCRCCxj1GZGpLNyDTO0XK+AYxjWZdkdDE6dX8m69EOZvRM59yVANxbX94yspY6MjTl6mptDxBmxF1vbztBpjOdypt2zFk4fOYK6ypqMhz2pAiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028037; c=relaxed/simple;
	bh=yeEZfH5cDHGk9ahbLA7+T11RUDJ0yCVfgNSJbKlSPLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ipnRbD/wmpMaZ7cTeCoBmAn/rIIEVbfl8Hy5THKIUNFDpSigu2OSOP0+utPMFucsMFbuUS+TwpLCQVbNGJkGoWIz8j0Nvajlbx9MIz8nMrAS/mwfG/L34kXr8X0C7NCX+ciNP/LSRyOPnoDgVO8Arxb0KrLbD8VImneekIFl4HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n+M7JS1n; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+M7JS1n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028036; x=1815564036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yeEZfH5cDHGk9ahbLA7+T11RUDJ0yCVfgNSJbKlSPLE=;
  b=n+M7JS1nLEHxbaFsi/Y0tTwBgtsPX+5YXxqvUnpXUDN3bZ6inE2DOhi7
   9Q0bkkvvUi5qSvjp/qrQ60KsRoaFA7abLlX2LPji7ol0gY25ibmgblukM
   bUptgJQ9GY+4Qd8z8NNeo4WRll4nk57KYELrvvkbPIMk1Gc8Fps45tXb+
   PeV4TOn67+e3keld5BnNVT/XwHCRe2wyKwTuh2eVuKwVxxowXd6gzthuN
   UYi8BkuA1aOARcJgNmzSEByLyFrxY5xvt869eFRZNjv5TFbOZAZdM2lz0
   0GplSKxTtmd/p2OYW1cYAU68Tov0kF2PoDwI+UbcmdPlKlq/28tmfNadr
   w==;
X-CSE-ConnectionGUID: IC5iz6bjRa+2vWITjjKxVw==
X-CSE-MsgGUID: kEo2oaMbRhCMnM62tP9LWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="102200312"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="102200312"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:35 -0700
X-CSE-ConnectionGUID: VWNgdQNhRByqbDmWeMJGTg==
X-CSE-MsgGUID: 09fIIGUBRaq3OtBmMhIcBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="280250175"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:20:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 08/15] wifi: iwlwifi: mvm: validate MCC header before n_channels
Date: Tue, 14 Jul 2026 14:19:57 +0300
Message-Id: <20260714141909.cb2cef3d3e7e.Iee7b48614289da576de842157ad3730b7589a4b1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
References: <20260714141909.fdf31f494f1c.I70d01ed2023f6584fb23ea8ab344a93d222cc4c0@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

MCC response parsing read n_channels from v8/v4/v3 response variants
before ensuring the payload contained the fixed response header.

Add a minimum payload-length check for each response version before
reading n_channels, and keep the existing exact-size validation for the
channels array payload.

Assisted-by: GitHub Copilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 43 ++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 953218f1e025..f76e57399c1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2019, 2021-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2019, 2021-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -416,6 +416,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	int ret, resp_ver;
 	u32 status;
 	int resp_len, n_channels;
+	unsigned int pkt_len;
 	u16 mcc;
 
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
@@ -431,6 +432,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		return ERR_PTR(ret);
 
 	pkt = cmd.resp_pkt;
+	pkt_len = iwl_rx_packet_payload_len(pkt);
 
 	resp_ver = iwl_fw_lookup_notif_ver(mvm->fw, IWL_ALWAYS_LONG_GROUP,
 					   MCC_UPDATE_CMD, 0);
@@ -439,9 +441,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	if (resp_ver >= 8) {
 		struct iwl_mcc_update_resp_v8 *mcc_resp_v8 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v8),
+				 "MCC v8 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v8->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v8, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v8, channels, n_channels),
+				 "invalid MCC v8 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
@@ -464,9 +475,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 			       IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT)) {
 		struct iwl_mcc_update_resp_v4 *mcc_resp_v4 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v4),
+				 "MCC v4 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v4->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v4, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v4, channels, n_channels),
+				 "invalid MCC v4 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
@@ -489,9 +509,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	} else {
 		struct iwl_mcc_update_resp_v3 *mcc_resp_v3 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v3),
+				 "MCC v3 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v3->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v3, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v3, channels, n_channels),
+				 "invalid MCC v3 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
-- 
2.34.1

