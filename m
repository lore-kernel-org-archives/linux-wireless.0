Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7F6432313
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716724; cv=none; b=nmXVlmTWUCuo7/upAb15NZhuEVa0AhCgFcThPIX156HtyimMjz73151QIx7nrh4EuOseahMlMV6zoBm0jFhDu13BoPtQk/ix2Hddy2g0PQGLFEHmVsa0sJ7NKaDf9blidnwD8mzQRpj1au0MYHNZy2YuqM0lySneLy3bVMZEyME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716724; c=relaxed/simple;
	bh=sfw46tGEkHuIB5jI8cf2WchfRZR5isoYlPwqnPMNzBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VuWxqalgJdbvkoxIF4SEfSuXn8ghIQjtOkqbb3/gu4da8yxw4J/VNdwndGLJtmp2FDhi3VndnN2DYhYF3HlWyh3pTqbC+GO4hYFUrnJ+mCZ7UkT/9UTY8bvJGoEklxEIOYGby1hDHLyOdxQsSSHsmIV9fa3eI/Ni2I0uTdGwIgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NK8H6whf; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NK8H6whf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716722; x=1823252722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sfw46tGEkHuIB5jI8cf2WchfRZR5isoYlPwqnPMNzBA=;
  b=NK8H6whfeQXU/Hs+btwBcJINHezfOY2hUliAQ6D+kCtOcfHupxMXb5fI
   Lgg4WMDCbeztQTAzwHxqZ8mD8FD+1d583hgPWZjesIZnvByUEyxEHqcZc
   nT5QAmT/0rshtk59K1rkCBxeyIGK7qSfbaqnjszTFTSPfoffGf6Grg42D
   fhRObjjnc4ns8ISll3tL4CpQzPUXCDWIm207TLqpXSRclKSe6vAGUcbZa
   AMAYgJIhRV0c6rKqY4ydEfh2GSuXzBfoFEPoYbUMXzukJBdfLRjBrJ6gv
   ZbRto8tc1GSBhJyHtTyiSD7+dfcxCzFzPJRqiSYOr62fTn0XqK6WhAtTJ
   Q==;
X-CSE-ConnectionGUID: ebdPWDOjRq+nwjhEdhQJBw==
X-CSE-MsgGUID: CstpCEoaQESVKLOasLFAOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454169"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454169"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:22 -0700
X-CSE-ConnectionGUID: DAEJM3/EQVS1PdNRyIGzpw==
X-CSE-MsgGUID: QJPJDvg7Q6K/EQu1+3YKuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650934"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 02/13] wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware
Date: Sun, 11 Oct 2026 14:07:03 +0300
Message-Id: <20261011140453.dfca0c8b560a.I7a3e1f0e91f0d0c6f4c5f1e6a33dc7c0c5e9ad11@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When converting a v3 rate to the v1 format, the MCS index was read
from the mask of the NSS field and written into the mask of the MCS
field. This is obviously wrong, we must not mix the NSS and the MCS.

Fixes: 3592c0083fb2 ("wifi: iwlwifi: mvm: fix beacon template/fixed rate")
Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index e97ab2c9e5ba..b2f34d1f2c48 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1356,8 +1356,8 @@ __le32 iwl_mvm_v3_rate_to_fw(u32 rate, u8 rate_ver)
 	case RATE_MCS_MOD_TYPE_VHT:
 		result = RATE_MCS_VHT_MSK_V1;
 		result |= u32_encode_bits(u32_get_bits(rate,
-						       RATE_VHT_MCS_NSS_MSK),
-					  RATE_MCS_CODE_MSK);
+						       RATE_MCS_CODE_MSK),
+					  RATE_VHT_MCS_RATE_CODE_MSK);
 		result |= u32_encode_bits(u32_get_bits(rate, RATE_MCS_NSS_MSK),
 					  RATE_VHT_MCS_NSS_MSK);
 		break;
-- 
2.34.1

