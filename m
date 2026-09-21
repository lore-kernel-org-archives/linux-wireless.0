Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B6448CE6
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023184; cv=none; b=UP9FjK6naZdNnh0NdAzuEpxwcZzWYlD5gSfmJcAzgwhShs9IZSMBWbaGHSH2sYubQQEvGIWalzCb4v7WeC27axjpriCP5WhHFRTNXaEUtNJXvYkVnjwP3I//h4QQCWMwmhkqWtMfEHqiqnxTj2YDt+CWDBXd6vnppBn9PhEkhkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023184; c=relaxed/simple;
	bh=npvholtZdCpKTSUoAEOl/CfFRnwFTCSMvnNL/PMuM5I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jM9j/j2XOCXu36LD13z71jHgBin8QinMLhDjd746hPZhi3ttZs3wiSKW9S+a6HO9dHvml1rVGvZapCYbdxqqXBJFwun+Fhg0m+tVX860AZUy1MR34WwqFLBOUlbqfqYdccB6fuHGYQh9OMc4BRjbTB5zhAP51vACuk6WVPKxtl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kl21zplA; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kl21zplA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023183; x=1821559183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=npvholtZdCpKTSUoAEOl/CfFRnwFTCSMvnNL/PMuM5I=;
  b=kl21zplA6Lm6d9ybeEtScn9BODA9MA/VvpuFEavXgWSiNSCQexAreFfr
   C5cvsaNSB0VkjI182nbcy+wXiB5WeW1JQyPpMLlQXdvAB/YUslTqj3eAH
   LZ6izK3MIcynEcqXgjPPDUwhG4x7WPgoajjzd8lQ9h+Dp2X1Zyj92nBBU
   d3ol5YJEOfy3E8HczsZWmpCntWWy3xc7Pu63yoN1qH4KN/V7MsDpoSOGC
   ovdiqnGIBcmALjMmZACNMwOqnF9aGn3WQmYksNtVZFHy6S+VpOYk6R+sK
   DHr+t5LL1AOgQd/aW8UkJ6xa48hsTFB2wOm6lxrRuVPExks6mlKba/7Y1
   g==;
X-CSE-ConnectionGUID: J7+DubOkShyqiTMYKKsLkg==
X-CSE-MsgGUID: m2/lYcQNQhO3DD3zk2LUNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128788"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128788"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:42 -0700
X-CSE-ConnectionGUID: rxBdMGBlTreH9ni2WgzVEQ==
X-CSE-MsgGUID: t2EiRwfgS1C8xXdw/IPGlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762036"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: pcie: validate txq_id in txq_disable
Date: Mon, 21 Sep 2026 23:41:18 +0300
Message-Id: <20260921233730.c96ee7e007bc.Ie593dfd5451be69a5e6deca248a4b443e168ac88@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_trans_pcie_txq_disable() computed SCD_TX_STTS_QUEUE_OFFSET(txq_id)
and dereferenced trans_pcie->txqs.txq[txq_id] before checking that
txq_id is within range or that the queue was allocated.

Bail out with a WARN_ON when txq_id is out of range or the queue is not
allocated, and only compute the status address after the checks pass.
We don't really want to disable the command queue either, so check that
as well.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
index dc2fe0c4f68c..060074c2871b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
@@ -1276,9 +1276,17 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 				bool configure_scd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 stts_addr = trans_pcie->scd_base_addr +
-			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 	static const u32 zero_val[4] = {};
+	u32 stts_addr;
+
+	if (WARN_ON(txq_id < 0 ||
+		    txq_id >= trans->mac_cfg->base->num_of_queues ||
+		    txq_id == trans->conf.cmd_queue ||
+		    !trans_pcie->txqs.txq[txq_id]))
+		return;
+
+	stts_addr = trans_pcie->scd_base_addr +
+		    SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 
 	trans_pcie->txqs.txq[txq_id]->frozen_expiry_remainder = 0;
 	trans_pcie->txqs.txq[txq_id]->frozen = false;
-- 
2.34.1

