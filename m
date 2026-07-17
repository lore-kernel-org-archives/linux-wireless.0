Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028D42A17F
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298848; cv=none; b=rwmsZqjiRxSsgZLT11ljc4MlyGfjcAFTYUjS0kPo5TZO97e9XvOJhc472puMf0uS5oJR/qJ10yx5ATRAy1nbaInc8NfkYjnhRGXs7WTAcND+8jv6RHncEcDm8uGX5lzB3yVhA6jRaghoeMGsiAAHPUeULY7uTDsA4X0fLsqIrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298848; c=relaxed/simple;
	bh=KSgYMC7jOREfbMrmhaRf8ZQ6r1bqkbw4I0ocQnLD1lg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jMHwnBmp/6UfsiJge81DDoG5kQ2JN0uRzl9v7y6C0iX80135GpCGbNhsSOZ7MO1qyhmwqMy3SdebeLux2GB5Hzbwcr97garUQLaH5QHkPiaJeJqAkm3ORM3g1+YQZWlF5QKJ3/Jm8hSqX/ShQmD4BILguTyFljwCUeloA2BKtIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRsH0LM9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRsH0LM9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298847; x=1815834847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KSgYMC7jOREfbMrmhaRf8ZQ6r1bqkbw4I0ocQnLD1lg=;
  b=LRsH0LM9KWh2D5mfOuzNk6LaXgN5C9jQCZWxFvFyuqBVFXv1cgaHkVuT
   DaB2Vc99vn7nKdRDWbhCdQQKf5LVkkIWBvQZf1DZbKzh9oRfl5AhCp2El
   NEfGJ+b+OQqu3P2bBERwdq+8NxlJ4lJjNVfd/FtsTy3aKseE4ZMOFniBV
   OmxtjuJwBqfJ9wYONYhA5P9iIzmgb1ps27sRVYq1mAVrdFJ9EtE85Km7T
   TD8pk1h4PTGV/aJFrEEEu5zb1ZOkswdviZVPuLCLPXAKsY5XxUXGRr7RY
   abcyP6y0fVzdnWrXB5IA6DhAzZP9f7wGxq3x7E7ksOe4Rvxp2jl4XoKhu
   A==;
X-CSE-ConnectionGUID: 5Ofc3G+IQe21EJDr129V1A==
X-CSE-MsgGUID: 0oK2aAblRrSzdmfkTCK6iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="95571415"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="95571415"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:07 -0700
X-CSE-ConnectionGUID: Bjbouz1sRC23eQ3YOTpVUg==
X-CSE-MsgGUID: AB/Y44ImSwOWmKV47lhJ8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="255035089"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:34:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 3/5] wifi: iwlwifi: acpi: validate WGDS table revision index
Date: Fri, 17 Jul 2026 17:33:38 +0300
Message-Id: <20260717173215.52a01f841f2a.Ic0131eaac31d9ff71b169138d9b0865cb39b44a9@changeid>
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

Check tbl_rev bounds before BIT(tbl_rev) to avoid undefined shifts when
firmware reports an invalid revision value.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index bf0f851a9075..430a7642e01a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -865,6 +865,11 @@ int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 						       min_size, max_size,
 						       &tbl_rev);
 		if (!IS_ERR(wifi_pkg)) {
+			if (tbl_rev < 0 ||
+			    tbl_rev >= BITS_PER_BYTE *
+			    sizeof(rev_data[idx].revisions))
+				continue;
+
 			if (!(BIT(tbl_rev) & rev_data[idx].revisions))
 				continue;
 
-- 
2.34.1

