Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169A43F0B5
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141882; cv=none; b=aAwal1uezW8nWy5qGUpJW4EbNsTSUDRUnQZaS6Sbm15NEJ5zgtSkXBYRqYrYRQxvb8I4WUikw1Djh6TAoJDink3td2capzSCcqKh5sIwr0jra0nTnXgdoftg8ucIU28OCzLIlxebX2ooN3Ijok9bSJ1jepw10/YdiLuoryXuYrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141882; c=relaxed/simple;
	bh=Afrj00FFmDDDxpOGiERI9dscuRLv1MZkjcFE4PfkElo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EfCmDzGFk45TjkGpehvzKrFwzNrLCcnxq2nZPTH3XyG5bRfLzzvLqFy1lNkk/jwHHhJil9ly+bZB1a+NPVlmlc9jZITDXQRA3r5uKYVOV6xOC/OAjHzcBri6Y9lId59w7EPIhPUgHSPCdWA6Hb9kr8plU9n7D0o36W3KokqjvG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kh11mCzy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kh11mCzy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141873; x=1815677873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Afrj00FFmDDDxpOGiERI9dscuRLv1MZkjcFE4PfkElo=;
  b=Kh11mCzy9QxCyjitzpdFLqtkq/QM89UkGNeDrbbE/FBB+YVgqkLYen+H
   fLyn41+ZGOPLeZiwrMnjnqDIrgoyqNfU2ribQe/fl7lba+Iq6LcLQdOAq
   auRj+h8vqSpN2cfx/2sYPwDYckJMBMEdO1fYXb1ALYscC66rL4BsYbTUw
   b7OrA7D2A3KSz7CoQz+7yn8+X4m6H0Z65HtWe5q6nUJXJ+7EGb7C7maUv
   FKx/3JNM4SLkWtZWB+8XZxvwW3cY+RaeDIn+1aqMwBuzpzdUEGh/8t58v
   753pcvu6ykd/UI42Ndx9BXNfUKwZijP3iaQFIeUbki/ja3/FSs7V7Plt/
   A==;
X-CSE-ConnectionGUID: Jo2eXQFUSW2tfwT5I2IUlw==
X-CSE-MsgGUID: AVbqaLsASGyuoONbpl2QTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160896"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160896"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:45 -0700
X-CSE-ConnectionGUID: hX1VPk8lTpGsBVQkPsAEuw==
X-CSE-MsgGUID: UkyCzSBWQM6Ggdq1bAVg8w==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:44 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-fixes 05/15] wifi: iwlwifi: fw: validate SMEM response size
Date: Wed, 15 Jul 2026 21:57:05 +0300
Message-Id: <20260715215523.fbdb0016a91d.I5f6c6e04589a24a233559191170ccb43372dee63@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The SMEM parsers cast firmware response payloads directly to shared
memory configuration structures. A short response can leave fields
outside the received payload while the driver still dereferences them.

Check the response payload length before reading the base fields in
both parser variants. Require the full legacy extended layout before
reading internal TX FIFO data. Valid responses keep the same parsed
values.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 28 ++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index 344ddde85b18..20ed26a1bb00 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2021, 2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021, 2025-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -14,9 +14,17 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_shared_mem_cfg *mem_cfg = (void *)pkt->data;
 	int i, lmac;
-	int lmac_num = le32_to_cpu(mem_cfg->lmac_num);
-	u8 api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
-					     SHARED_MEM_CFG_CMD, 0);
+	int lmac_num;
+	u8 api_ver;
+
+	if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+			 offsetofend(struct iwl_shared_mem_cfg, lmac_smem[1]),
+			 "bad shared mem notification size\n"))
+		return;
+
+	lmac_num = le32_to_cpu(mem_cfg->lmac_num);
+	api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
+					  SHARED_MEM_CFG_CMD, 0);
 
 	/* Note: notification has 3 entries, but we only expect 2 */
 	if (IWL_FW_CHECK(fwrt, lmac_num > ARRAY_SIZE(fwrt->smem_cfg.lmac),
@@ -30,7 +38,7 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 
 	if (api_ver >= 4 &&
 	    !IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg),
-			  "bad shared mem notification size\n")) {
+			  "bad shared mem notification size (v4)\n")) {
 		fwrt->smem_cfg.rxfifo2_control_size =
 			le32_to_cpu(mem_cfg->rxfifo2_control_size);
 	}
@@ -53,6 +61,11 @@ static void iwl_parse_shared_mem(struct iwl_fw_runtime *fwrt,
 	struct iwl_shared_mem_cfg_v2 *mem_cfg = (void *)pkt->data;
 	int i;
 
+	if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+			 offsetof(struct iwl_shared_mem_cfg_v2, rxfifo_addr),
+			 "bad shared mem notification size\n"))
+		return;
+
 	fwrt->smem_cfg.num_lmacs = 1;
 
 	fwrt->smem_cfg.num_txfifo_entries = ARRAY_SIZE(mem_cfg->txfifo_size);
@@ -67,6 +80,11 @@ static void iwl_parse_shared_mem(struct iwl_fw_runtime *fwrt,
 	/* new API has more data, from rxfifo_addr field and on */
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
+		if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+				 sizeof(*mem_cfg),
+				 "bad shared mem notification size (extend)\n"))
+			return;
+
 		BUILD_BUG_ON(sizeof(fwrt->smem_cfg.internal_txfifo_size) !=
 			     sizeof(mem_cfg->internal_txfifo_size));
 
-- 
2.34.1

