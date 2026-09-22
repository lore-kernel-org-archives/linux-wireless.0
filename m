Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC6053CA79
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077704; cv=none; b=uvwOd+Og5oXMZ6wkG6FeTcUT3IYfmpAuVtnw1n2BQyF1X58qUhuhaINczek3yJsAr1IzD6Ze4LeVCbMC4CktkBgMpK3Y/R1mwjt2k8BeNNGkQG7WmYugm3jr/eQZSfjTYLvIYofOTwEOon1r/bkExxFtoRRT0lKcEbYJSDyNCTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077704; c=relaxed/simple;
	bh=Uvo+waccC0Hb7KEtY/XVwjDHEatHTzOUe/lYodORO/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O+QRAtbh5wtoNULudpIMQcts36sBfndfIgLt3ZBJr5ymQiRZcEvhabShI1kLT6FyTaaTwIl3rOI9Z+X8iAhN0OAYxaSk6ejEBlM1cGe3TwTXm0xh5n6jt0vU/jNhTclLZfvLOz6r+POq8q5udxAOS+/e3PmXSIVKAC9AXa+uFBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VKUg2sPZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKUg2sPZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077703; x=1821613703;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uvo+waccC0Hb7KEtY/XVwjDHEatHTzOUe/lYodORO/M=;
  b=VKUg2sPZqI98sahS95wl+uwY31HMk6FAAFc08obKcG2dBGVKpj8rCSOJ
   nbU2gsKgy8U9EV6/3E+8E5GM45ju0oK3l1cqBghO0efGVRfgANoamRCMV
   8OBCZpaZnnKK/LYplXXawgTwtdbeeOXqr6pBNu6z8NkQkXGdb1cG17c1g
   q+tMwxSgT7oJxCHn0at0Rgbb04wB4ATWxh1zTEx3vE5CUXpT67av7gOc2
   /89aFUpq37MasIa4sHBRrtCL/vxxmrfyceRSNM7mp9LoFvfzGv+AaIUla
   fzyfmi7BKAWbd86enCeZ8Z7cNz5e8OTm7QdoKZiYWJlmzT8ljfR4W0Oqp
   A==;
X-CSE-ConnectionGUID: RUCobmv2RSKy1Hh50XaQ5g==
X-CSE-MsgGUID: m3iImpS8Rs2TWdRQ6CoRvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170540"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170540"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:15 -0700
X-CSE-ConnectionGUID: NC5FKw5LRSasoaR8mC0YRA==
X-CSE-MsgGUID: AN6UUc/CRKKrM/+hu1GOZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275400"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:14 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: fix ctxt-info-v2 unwind UAF
Date: Tue, 22 Sep 2026 14:49:55 +0300
Message-Id: <20260922144819.be2c3cf96a4e.I207172d76a22c0302575f3383a044700f97a9980@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A failed ctxt-info-v2 allocation can free prph_scratch/prph_info
without clearing the stored transport pointers.

Clear stale DMA address/pointer fields during unwind.

Also add an alloc-entry WARN_ON_ONCE/-EBUSY invariant to reject re-entry
when ctxt/prph/iml state is already populated.

Also, assign iml_len only the allocation.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/ctxt-info-v2.c  | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
index 06be929a3ca5..1ea23d297713 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/dmi.h>
 #include "iwl-trans.h"
@@ -112,6 +112,14 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 	int cmdq_size = max_t(u32, IWL_CMD_QUEUE_SIZE,
 			      trans->mac_cfg->base->min_txq_size);
 
+	if (WARN_ON_ONCE(trans_pcie->ctxt_info_v2 || trans_pcie->prph_info ||
+			 trans_pcie->prph_scratch || trans_pcie->iml ||
+			 trans_pcie->ctxt_info_dma_addr ||
+			 trans_pcie->prph_info_dma_addr ||
+			 trans_pcie->prph_scratch_dma_addr ||
+			 trans_pcie->iml_dma_addr || trans_pcie->iml_len))
+		return -EBUSY;
+
 	switch (trans->conf.rx_buf_size) {
 	case IWL_AMSDU_DEF:
 		return -EINVAL;
@@ -263,7 +271,6 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 	trans_pcie->prph_scratch = prph_scratch;
 
 	/* Allocate IML */
-	trans_pcie->iml_len = fw->iml_len;
 	trans_pcie->iml = dma_alloc_coherent(trans->dev, fw->iml_len,
 					     &trans_pcie->iml_dma_addr,
 					     GFP_KERNEL);
@@ -271,6 +278,7 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 		ret = -ENOMEM;
 		goto err_free_ctxt_info;
 	}
+	trans_pcie->iml_len = fw->iml_len;
 
 	memcpy(trans_pcie->iml, fw->iml, fw->iml_len);
 
@@ -280,16 +288,21 @@ int iwl_pcie_ctxt_info_v2_alloc(struct iwl_trans *trans,
 	dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info_v2),
 			  trans_pcie->ctxt_info_v2,
 			  trans_pcie->ctxt_info_dma_addr);
+	trans_pcie->ctxt_info_dma_addr = 0;
 	trans_pcie->ctxt_info_v2 = NULL;
 err_free_prph_info:
 	dma_free_coherent(trans->dev, PAGE_SIZE, prph_info,
 			  trans_pcie->prph_info_dma_addr);
+	trans_pcie->prph_info_dma_addr = 0;
+	trans_pcie->prph_info = NULL;
 
 err_free_prph_scratch:
 	dma_free_coherent(trans->dev,
 			  sizeof(*prph_scratch),
 			prph_scratch,
 			trans_pcie->prph_scratch_dma_addr);
+	trans_pcie->prph_scratch_dma_addr = 0;
+	trans_pcie->prph_scratch = NULL;
 	return ret;
 
 }
-- 
2.34.1

