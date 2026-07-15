Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9CC41F5EB
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142330; cv=none; b=BVhipneJ/Luz0CK4AIR5c/3tiqywCfdKs6wIe05aV5MsZt2lT9+QXgbD0CBySGV0W7A3aJVnwH2jPB4mR2TmErl+Rbesq6iW6SQWuhipsv7dT6vrbRSr8GAQilIL8PJyIOrYOHd2I57R+1wSyMNZM8VAiFO3d9F3n8XmPd42wlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142330; c=relaxed/simple;
	bh=EgT/j8FA1cIvQLBMr2gefsskOC4W4F/EE2BK43c9AKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e+nhkTg75D+5C+a41REJNInnPKh+hSaIAg4sqrQJdeDpjvIufNJObfS0BHlMpaPT8GhNMKJRcgh7+QCpJHn3VsTq8Us6Yp2T2DE18za76CEUJUoJs5RxRSXx2NZR+mqvksOU793h5YEYtO0xvmBy+WIIiaKSMB5Vgvbw02C9mXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HoSJpRMk; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HoSJpRMk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142326; x=1815678326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EgT/j8FA1cIvQLBMr2gefsskOC4W4F/EE2BK43c9AKg=;
  b=HoSJpRMkSYfU6dG9qjmkQT8EdqTjLGk5McwM1JCCF7E/wutCCxU/Tn/f
   eXSWttFQAdbfanYjUnLv4DgPqLjK6X6SF73z9T+n5MG83xNKpNys7zH0/
   KVALFGDtvih46f9CEAy1g6RorJ7x5IFvdcnQ9u/97qolBCz6Rp6sP54kb
   qWwlxpqbAW4cjVl1u8rK/efM+wXLxMHzxlrwbsRqdJIjTT4nLlA6XZlKH
   aD63KtaVjVyruZUDJR4uaGE8vn/IBJintUkDrMzr6HSFYP51D5pO0FI4u
   QcxAp6TvOyB7hTjT1kEyJril/XxYLDFBp7HwSe/2W74y707nB9M8vSX4v
   w==;
X-CSE-ConnectionGUID: 4EltLhTnSqemJ9vRJFPRSw==
X-CSE-MsgGUID: 7Dc0FExmS4KctKg++yycKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340730"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340730"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:06 -0700
X-CSE-ConnectionGUID: JnXZh5aYS8y/AaF9TsPtpA==
X-CSE-MsgGUID: XexNMXWpSSy3rTcac3E0FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851989"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:05 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: mld: add PNVM_INIT_COMPLETE_NTFY to the hcmd names
Date: Wed, 15 Jul 2026 22:04:25 +0300
Message-Id: <20260715220243.e8da467f1883.I75ab56a022f31365042d29aff5484e4329b0f6ce@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Add it to the array of host command name so it will be printed with
iwl_get_cmd_string

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 093bdc130704..7c49d0441fdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -212,6 +212,7 @@ static const struct iwl_hcmd_names iwl_mld_reg_and_nvm_names[] = {
 	HCMD_NAME(TAS_CONFIG),
 	HCMD_NAME(SAR_OFFSET_MAPPING_TABLE_CMD),
 	HCMD_NAME(MCC_ALLOWED_AP_TYPE_CMD),
+	HCMD_NAME(PNVM_INIT_COMPLETE_NTFY),
 };
 
 /* Please keep this array *SORTED* by hex value.
-- 
2.34.1

