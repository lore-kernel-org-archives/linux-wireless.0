Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733291E32D6;
	Thu,  6 Aug 2026 05:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785994994; cv=none; b=mWuHBWsC7yKc8WHR94V8Dy2Z1SszpDfQj4OrkC7gKNpVypUj+1K10nEbC2138728l20T6ioxRmADYfW48aeyGfCL1fAYAQ2Lw0G8mO2H20sU2cdc9wwuHuiqUADVuB9uzZ+ettOt83eS9zCKVhbUFFdmESyVh0C+/becPH5Gl0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785994994; c=relaxed/simple;
	bh=n8OOl8LnKzoRnOqP3z8cqH/YxfvjQ9J8yGpITcBA72E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SaKIRKXK7W4rDBWoLOve+tutyy9VzgPq183MV/uyykRmmCXw1VsEvVuIcb3Lf1UcsjdQGGYXCSBOcbH7RBcvYSkeOz7luTVsDrSrswczjaDLr2kNzENz7UgVCOQUKLk3YHjBgfK0wgoCOh5T9ffZ1a8z8AIrSEqmMvAro/9A1i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=permerror (bad message/signature format); arc=none smtp.client-ip=37.59.57.117
Authentication-Results:smtp.subspace.kernel.org; dkim=permerror (bad message/signature format)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: sunliming
To: miriam.rachel.korenblit@intel.com,
	emmanuel.grumbach@intel.com,
	johannes.berg@intel.com,
	itamar.shalev@intel.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sunliming <sunliming@kylinos.cn>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH] wifi: iwlwifi: pcie: add NULL check for trans->dbg.dest_tlv in dump_monitor
Date: Thu,  6 Aug 2026 13:42:08 +0800
Message-ID: <20260806054209.457073-1-sunliming>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: sunliming <sunliming@kylinos.cn>

Fix below smatch warnings:
drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c:3527 iwl_trans_pcie_dump_monitor()
error: we previously assumed 'trans->dbg.dest_tlv' could be null

Fixes: c8a00a6e89ff ("wifi: iwlwifi: pcie: move generation specific
files to a folder")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 28b276c65952..9cea0fe9e578 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -3516,7 +3516,8 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 
 			iwl_trans_pcie_read_mem(trans, base, fw_mon_data->data,
 						monitor_len / sizeof(u32));
-		} else if (trans->dbg.dest_tlv->monitor_mode == MARBH_MODE) {
+		} else if (trans->dbg.dest_tlv &&
+				(trans->dbg.dest_tlv->monitor_mode == MARBH_MODE)) {
 			monitor_len =
 				iwl_trans_pci_dump_marbh_monitor(trans,
 								 fw_mon_data,
-- 
2.43.0

