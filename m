Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA43FD95C
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298863; cv=none; b=Le70kzF8iIN5MbJFvU2DkVPWaC1wHnf4l/mB5rIK7eNFvYbuJx3NAvmawaY9wawuIkLfUYvRyJYqPfUeGMs15xXwN6n92Zj3BH/emFvBAipCo7wHvF/kEEMUPS8vqzmY1BoCULknRVHNleTZEVF2Uo0PB+ysOmbgYNRUyb23Ca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298863; c=relaxed/simple;
	bh=w8kW7fN418UCP21rp4W4W/9IlOnapMA2n1PMDMH3zTg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rHmB6pvfzzy5XH9d/XG9fa+DkBn22wF/uVGB/1H12WtibkfFDQ4mogGIkbCjFUQmOEievfiapyzXayhn+t//090hTP3E4xm7vJ8BEvArvofvzlYBmNbJa4Nw8aieFJ1dLTbVCQL2YoS2zT/pQQDXot7K9mj/bR83hVcYWo35V80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kP+D41WF; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kP+D41WF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298862; x=1815834862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w8kW7fN418UCP21rp4W4W/9IlOnapMA2n1PMDMH3zTg=;
  b=kP+D41WFMnsaRKl79nz3SCn+urnRrPT4zMuft6aE5BCZyYRAYqWOiqa1
   nGNwG5vup5v9NBnh0OrR2Pj9rLaFldG6MBsKOyMcjKbqoHdF9jHy8upsm
   QluKYehh41y4FY4yZd9u0o7gDigFAsFwMm5ulw4qb2ATcJBtJPZ6+AZD1
   WcJ/Zzwvy7XlX4zvteHQgAdxaW0eL4tdvKXJ82Yr+GJKAViTl8Gs6cepF
   FR8LLVcyeLiJkSLIxXGSB/OAfXcOe/H+vcUmhHPr72kgG+DRdQV9RUvsb
   M+NmdOXn3rdPerCeHOPwD6m8pSXg9ySXAfXcRWLlBWBteLWUGYwRL8vdt
   g==;
X-CSE-ConnectionGUID: rULEEqvvSpWGQO+QU0borw==
X-CSE-MsgGUID: pdBq8d0pTh2+PoOz592lCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571420"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571420"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:09 -0700
X-CSE-ConnectionGUID: aCz3+dkYQbapI+E+62nJkw==
X-CSE-MsgGUID: hcIaUCw1SMWzrbsPsU8jvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035092"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:07 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 4/5] wifi: iwlwifi: uefi: bound PPAG revision bitmap shift
Date: Fri, 17 Jul 2026 17:33:39 +0300
Message-Id: <20260717173215.d116dd2efdc1.I3c6cae5cb9d0acc2d94544bc755b0754a91b10ba@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
References: <20260717143340.2321964-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Validate revision is below 32 before BIT(revision) in PPAG parsing.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 2ef0a7a920ad..014f22c42f41 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -700,7 +700,7 @@ int iwl_uefi_get_ppag_table(struct iwl_fw_runtime *fwrt)
 	return -EINVAL;
 
 parse_table:
-	if (!(BIT(data->revision) & valid_rev)) {
+	if (data->revision >= 32 || !(BIT(data->revision) & valid_rev)) {
 		ret = -EINVAL;
 		IWL_DEBUG_RADIO(fwrt,
 				"Unsupported UEFI PPAG revision:%d\n",
-- 
2.34.1

