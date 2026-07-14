Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8542380FEE
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028800; cv=none; b=SjhTkVu/GtonWYz2WklgGW6WLeNaXmh/b5Sh7aGI8MBuytdhadrg+BQQREV90tDd6YHIaxp0GkfAdEn+L4X3F6NZ5WHnhWMndZkY6PWm8srcMGmTEm3H+gNfq+5ctOwdTwHAwZN20X9yZ+ALIF+Q0l7LhanLUCqt2iOqvTFDEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028800; c=relaxed/simple;
	bh=jTe98RMCDc8g+c2+R+2zJ6feGpdPamYg7BPuXTu2UpI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WYrepHlnCRx8XW+StYcVNAXyKh+bUz3NTD6u4y6cAlfGl9/IJTmmPKz40Qte5TjN8kcwrgxEYotQWsgdSDYPGl387X7Di/bfjdtahb2eZLckn3dV2YV3QkYvZKd/4HKiqW8dFcfInc8DmlKbmdn7+yplIXNcVConQGyTNGVQfdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lalEx2io; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lalEx2io"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028799; x=1815564799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jTe98RMCDc8g+c2+R+2zJ6feGpdPamYg7BPuXTu2UpI=;
  b=lalEx2iobXa7RgYHJkjeBr9RtlRbWyeVME/nBvWkY0y9LsKXwMgeN4id
   CvpxVyIc8LkO3AUQid03QbEGjiM7DoJ8mhV8BnSAI9qr57JB7YjTW1R7w
   YRQTdpi61S3ArfpygTvYj9o7G7rwLKS1MnmyRWsiu+ElHu/lsOv+yhjg2
   6z5c9hseIbtOq5EIMiDwqOrjp1YKvmf2+cPZTeOlrKXbGQzavmKv+LIl2
   fxPtuVYTopKRavfojgcMbu1KP30K1Tz8bBd6RTMq1cLvoi5n7Je3CObCp
   BDICEDofx0xa+1zNzkX16V3jcHAX4vn9mTIzlltM+3xNCSC06KiwOfnfp
   A==;
X-CSE-ConnectionGUID: H1VI7nJsTmmd3tjElDJMdw==
X-CSE-MsgGUID: NST02gFtRAW6L0gnvUe1uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469602"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469602"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:18 -0700
X-CSE-ConnectionGUID: sBjfXIyST/a21e2E+//nNw==
X-CSE-MsgGUID: ePC15JYgRsWOjbdlbka/bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882959"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:16 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: pcie: validate txq_id in txq_enable
Date: Tue, 14 Jul 2026 14:32:36 +0300
Message-Id: <20260714143119.273be072f5ff.I0d6c36a4c06bdbb4655164c7792da32b6143731e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Avoid indexing txq arrays and queue-used bitmaps with an
invalid queue ID by adding an early bounds check in
iwl_trans_pcie_txq_enable().

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
index fdb3ba4f63c0..dc2fe0c4f68c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2021, 2023-2025 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2021, 2023-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1149,10 +1149,17 @@ bool iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			       unsigned int wdg_timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = trans_pcie->txqs.txq[txq_id];
+	struct iwl_txq *txq;
 	int fifo = -1;
 	bool scd_bug = false;
 
+	if (WARN_ONCE(txq_id < 0 ||
+		      txq_id >= trans->mac_cfg->base->num_of_queues,
+		      "queue %d out of range", txq_id))
+		return false;
+
+	txq = trans_pcie->txqs.txq[txq_id];
+
 	if (test_and_set_bit(txq_id, trans_pcie->txqs.queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
-- 
2.34.1

