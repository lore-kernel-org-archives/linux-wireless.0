Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C35442C4FA
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716727; cv=none; b=KWiyX7ouZ6IEl0tAMj4MXoHwfpD/xjC5m3xZLnd6yo93hldBr2hrJNRe4xLWE/tXnaCf8nGDm+kNgrFkwRtYmdLYkgCA9QNOt2hBCuGoMT8J+La+xcoL5DrSMQbW21Bd6cY4e0AMhsvJ8MLENaHKCKH5XfsghkAzXstOB81xbt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716727; c=relaxed/simple;
	bh=23i3a7oMBo/+46HCfvEi/jYDIDG1henldTzaHZTM5Ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J2Ivm9CtoHFuK7p3LYNg75PqmTAt485X7NIQRIfavYGsrWszWxU5pOuFYqk2+X4la4gY4ZH2yC5TBzq3+1FpAQ2nqHOUXx4uYRMmFQ7EoZSnBQlLJtuNhEXctipMrKYY0uPUXOZ/6giUppaUljO5v9t4gj0B6QICWF2Lfq0DeCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqUcUyMq; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqUcUyMq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716727; x=1823252727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=23i3a7oMBo/+46HCfvEi/jYDIDG1henldTzaHZTM5Ac=;
  b=GqUcUyMqXQPIcj3lDb1kfiAgugV/RPrk2t1emmSjOtthTxcLC7cWd+zA
   E9FSPhZIV9ROAqwGh/EGadM0m2UaC4wvdVXiujciRs5B+mfvxNW6RTw1H
   H7/X2Hm4LEjDbCjR9yVnQwkh0q362BmqfmjoeKMAdQOA3NtTxalIPQ8XQ
   AZN45qhdZe5S1d7usHCFGXQvKrbXzmkxTONhBreHLLvJTbTiCw5QQ4XAE
   yWYG3sHs6IGV5Mycsox38CSL+Z+uQ8ncSiPyxNQK2vc4sPVv6pISdgljs
   O+R3Ty79bSXITJP9udTWN4gHu3+DAjRhbMzQdUcl5AuyPwPLrRyL/hSTM
   w==;
X-CSE-ConnectionGUID: jC70QCH3RYOM8WNEW/PSzA==
X-CSE-MsgGUID: R7J4Y2aMSu2lt5dIx98QYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454175"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454175"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:27 -0700
X-CSE-ConnectionGUID: TvoLZI2uQwyml8QuxWfLIg==
X-CSE-MsgGUID: kYY3/bP3Qwi8X/gUO05XlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650966"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:25 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 05/13] wifi: iwlwifi: mld: don't enable RSS if there is one queue.
Date: Sun, 11 Oct 2026 14:07:06 +0300
Message-Id: <20261011140453.dbeea799293f.I1c37945a248f101e0bca2cd723ce6551871926ab@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

There is no point in RSS when we have only one rxq.
Don't send the command in this case - RSS will be disabled by default.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 3b9f412cdff2..c33a553488ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -47,6 +47,9 @@ static int iwl_mld_send_rss_cfg_cmd(struct iwl_mld *mld)
 
 	lockdep_assert_wiphy(mld->wiphy);
 
+	if (mld->trans->info.num_rxqs == 1)
+		return 0;
+
 	/* Do not direct RSS traffic to Q 0 which is our fallback queue */
 	for (int i = 0; i < ARRAY_SIZE(cmd.indirection_table); i++)
 		cmd.indirection_table[i] =
-- 
2.34.1

