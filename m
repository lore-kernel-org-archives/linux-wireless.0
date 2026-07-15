Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDCC43F09C
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141882; cv=none; b=gAw3ugEk2cUfidBGUjPHXCWot4+T//kf7gM8EHZML4RAa24fgCOwpHBRI8hj6MIDgNUwTA7OWxMeJsfU7gTbYtXSQqgiVHQ1KE5A4aew0m1ypmLgMJCBcybY3hWEsDdiAyR6S7emsBLsq8qFuNU0qv3pm5CC11ME+lJCCJgAV4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141882; c=relaxed/simple;
	bh=aBUC5pDlwBmPGMKeETrtQkzDCPN3DbRY2GMNO4PfkGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mV6K938SruGCqybGIPDJ1olyplYeGsFDvoIEF9U48bVmKwEnGidnN8k/rEHeiqdElth42PrRzA6MozYDNCwu1nd5Q1bm9TAr1Yga6/3Ui9dlz4d0IPTCnZ5klK3KVYTBjX4KlTSH4PHDDMb/Rm7mqplhOu7AI28yHSHybQ63iaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V2lBTKxa; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V2lBTKxa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141878; x=1815677878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aBUC5pDlwBmPGMKeETrtQkzDCPN3DbRY2GMNO4PfkGg=;
  b=V2lBTKxam4cplK4tASL1nLboAz1Vslq4sqQq6ehSWa/6deQdYy9XLlQt
   ZaZ9ASG07lKncJQL/8o1NG1yS0EtMmrbnmAGbwLYIGAL4ZweqcQRnD71w
   V7cqkCDi/PVZ8HPsmKOvElsELjJZrnhYoMsP6LFcHa+st7q1T+Y8pZaAW
   edzUv9Crm4Li5h4/LkS4gp2++fAMDxL4lncrmm9zOdIA8m0PPGmRjyCSp
   oeBm538wCHSYcQiVbjbkoijge7KUUZr89kBhdLV/Rt6QZETmYWSy0xlls
   NPDmdR6Kt2RffKFau06oMqDHOAl9JIRSLR9H2UlQQTy9Ua6OayQswCmVp
   w==;
X-CSE-ConnectionGUID: m4uyUPI7QiafEs8oj3qidg==
X-CSE-MsgGUID: s8R0anLMRVya0sXYN9rG9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160902"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160902"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:48 -0700
X-CSE-ConnectionGUID: Nwc+a3aCQGiZ0LvHV7oJ0g==
X-CSE-MsgGUID: 5fe7CUXFTzeyP4saY1UEZQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:47 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 07/15] wifi: iwlwifi: validate payload length in iwl_pnvm_complete_fn
Date: Wed, 15 Jul 2026 21:57:07 +0300
Message-Id: <20260715215523.7f2a669e5c75.I00465dcfcbccb250ae9af2d9bb305e24de1ba394@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_pnvm_complete_fn() casts pkt->data directly to
struct iwl_pnvm_init_complete_ntfy and reads the status field
without first verifying that the firmware notification payload
is large enough to contain that structure.

Add a WARN_ON_ONCE check against sizeof(*pnvm_ntf) and return
early without reading uninitialised memory if the payload is too
short.

Fixes: b3e4c0f34c17 ("iwlwifi: move PNVM implementation to common code")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index afff8d51ca95..ec0ff58ab312 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2020-2025 Intel Corporation
+ * Copyright(c) 2020-2026 Intel Corporation
  */
 
 #include "iwl-drv.h"
@@ -12,6 +12,7 @@
 #include "fw/api/alive.h"
 #include "fw/uefi.h"
 #include "fw/img.h"
+#include "fw/dbg.h"
 
 #define IWL_PNVM_REDUCED_CAP_BIT BIT(25)
 
@@ -26,6 +27,12 @@ static bool iwl_pnvm_complete_fn(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_trans *trans = (struct iwl_trans *)data;
 	struct iwl_pnvm_init_complete_ntfy *pnvm_ntf = (void *)pkt->data;
 
+	if (IWL_FW_CHECK(trans,
+			 iwl_rx_packet_payload_len(pkt) < sizeof(*pnvm_ntf),
+			 "Bad notif len: %d\n",
+			 iwl_rx_packet_payload_len(pkt)))
+		return true;
+
 	IWL_DEBUG_FW(trans,
 		     "PNVM complete notification received with status 0x%0x\n",
 		     le32_to_cpu(pnvm_ntf->status));
-- 
2.34.1

