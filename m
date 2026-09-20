Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866E31F99A
	for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789866889; cv=none; b=on6pi20WihrkAJZXCljbCbBNR9MkhUVaoQMMCuZJq11W6LlHeaKLEFjkXSw2kdVFBr6tvQ6YnOl09L7u//gfUdqSH20RbHj0E2B8OqtRZ/uw0LDNTGLvIM8YeA0/IxkF1gBanaIman+BP4nndLJBl8RVbBWncw+aS5qPzvvK8LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789866889; c=relaxed/simple;
	bh=n8OOl8LnKzoRnOqP3z8cqH/YxfvjQ9J8yGpITcBA72E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bSMNV7C+8TKt8vDszn8dYAdJMdwfUpz9rb1n6xZrD5LX6oGyKpnIBFGydsKwKc/vAa/ZO0CvGDQbkv+3ttasvYWiuiRBQ3GQ0bmAZTH7phbDR7kDl8YvEgQlmbs/IVgfdFRCMGNqRz3+UTseeaS1r+Q5FtlcyvdijGCfY+rmdUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=permerror (bad message/signature format); arc=none smtp.client-ip=95.215.58.47
Authentication-Results:smtp.subspace.kernel.org; dkim=permerror (bad message/signature format)
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n8OOl8LnKzoRnOqP3z8cqH/YxfvjQ9J8yGpITcBA72E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789866885; v=1; x=1790471685;
 b=REXdxl8lR8Y82uiViJpvS2s+lkWtSa5XXT+KQDcVw0xmn2mKZ5dFMyku6ZOvUbUCEv7t85Hy
 PkJQ8d7O33aGW/I0YEjBWeqkGfXUyaxddfrKMglNHEVG3brvBPvPKt5FUtJXZcxuMjnDk35azEK
 K6HQU826jzsyNXa/rbmdUBRc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2aae6ed2e79647d9;
	Sun, 20 Sep 2026 01:14:45 +0000
X-Mizu-Trace-ID: 2aae6ed2e79647d9
X-Migadu-Flow: FLOW_OUT
From: sunliming
To: miriam.rachel.korenblit@intel.com,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	daniel.gabay@intel.com
Cc: kees@kernel.org,
	elver@google.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH RESEND] wifi: iwlwifi: pcie: add NULL check for trans->dbg.dest_tlv in dump_monitor
Date: Sun, 20 Sep 2026 09:14:20 +0800
Message-ID: <20260920011420.99715-1-sunliming>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

