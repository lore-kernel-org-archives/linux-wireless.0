Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF0543304D;
	Wed, 14 Oct 2026 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791981845; cv=none; b=nksVPUamGar7NhLE0VYHOMRKgUZ4XR2fyh2JdTEjBEqVmKL13P0T4iPD0IusgEq8zwisiKXFXf5rp29Z6bVtgcJbPqQLbH7XQ6tu+48mNTvIFd/O+4QweVrA6Fqd2OUByUxNYLW6QjEPuM1inE8CjL7tTMopYYaEXFR3wkhGQvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791981845; c=relaxed/simple;
	bh=C+4m1lh9z426f2AOlWGrtkGhBX1dSUecUAxUP0YO7Qw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iVlvMzupbuerMBQrMURn1nnGisOlrTm1Yz+4yfNi8toLiIeX71eUUDZd0pZhyu6uma2wpJPJ2/5I8VbbdHUilJz5o0GF+wzWG2oQdkJFYba10WW+ZbCWOw2GyCpxJO5Mdv71PqXtC+j4qMPJGDZT2/nlH/AQ1PMGohtMFIMRqB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNrcHXk+; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNrcHXk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791981843; x=1823517843;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=C+4m1lh9z426f2AOlWGrtkGhBX1dSUecUAxUP0YO7Qw=;
  b=SNrcHXk+pkurUpfeCs2wnYWk/CXNzfduDQoHv74MIQT4SG5djpZKVh8r
   7jd9wffje3cjk1WJp4i0KY0gGVl3a0Bmjkg53IldOLvYYTpXhU93tUQsj
   yFYRvKTkRxpBBq7kXNEJflJ/xlFm6OI7xp/947qpAwqLuZijLtU/ISGJo
   Iv11DdcZmgeUtQfCYJ2JMxoqmTlAxRSgfPSAmDo5oBlOC3xht4ThkQCEM
   c/hLbKF97C4QG4I3//GiMZoC26wVrIgd9Iq5fWBK/BM7qxcJXSytLAfLo
   s5zNVII3qtdfwovp36fyZICaYNi2dy/nIfS1ZHAzWdD1VO3LMsBIx40VL
   w==;
X-CSE-ConnectionGUID: jXOTGH1WQ0SwpDAPbqFcPA==
X-CSE-MsgGUID: m0l2yOM9S12ym1cc8O71zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="736360"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="736360"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 05:44:02 -0700
X-CSE-ConnectionGUID: Dx4RydmJTwiKSfhFgLSIUg==
X-CSE-MsgGUID: VO/xskiQS+uWPUxxKb8dOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1394465"
Received: from ygaur-x299-aorus-gaming-3-pro.iind.intel.com ([10.223.75.72])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 05:44:00 -0700
From: Yogesh Gaur <yogesh.gaur@intel.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	luciano.coelho@intel.com,
	yogesh.gaur@intel.com
Subject: [PATCH iwlwifi-next] wifi: iwlwifi: pcie: return a real errno from read_config32()
Date: Wed, 14 Oct 2026 18:13:57 +0530
Message-Id: <20261014124357.2569535-1-yogesh.gaur@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_read_config_dword() can also return a positive PCIBIOS_* error code
(e.g. PCIBIOS_DEVICE_NOT_FOUND for a disconnected device), but
iwl_trans_pcie_read_config32() passes it through unchanged and
iwl_dump_ini_config_iter() only checks for ret < 0. The error is missed,
so the loop keeps reading and stores 0xffffffff in the dump.

Convert the return value with pcibios_err_to_errno().

Fixes: f696a7ee254f ("iwlwifi: yoyo: add PCI config space region type")
Signed-off-by: Yogesh Gaur <yogesh.gaur@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 28b276c65952..cfaadddfe06a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -2562,8 +2562,12 @@ int iwl_trans_pcie_read_mem_no_grab(struct iwl_trans *trans, u32 addr,
 int iwl_trans_pcie_read_config32(struct iwl_trans *trans, u32 ofs,
 				 u32 *val)
 {
-	return pci_read_config_dword(IWL_TRANS_GET_PCIE_TRANS(trans)->pci_dev,
-				     ofs, val);
+	int ret;
+
+	ret = pci_read_config_dword(IWL_TRANS_GET_PCIE_TRANS(trans)->pci_dev,
+				    ofs, val);
+
+	return pcibios_err_to_errno(ret);
 }
 
 #define IWL_FLUSH_WAIT_MS	2000
-- 
2.34.1

