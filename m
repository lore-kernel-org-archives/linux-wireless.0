Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E63044C66A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023189; cv=none; b=QIv1l0I/nx41KcLDU9Hj7RLMNE01RJAiUufzgnsRsgP2H7LUrkx3scGy+pSgowMwE/V73Y3zrqkaczZlYvvaV8re+kccJBoqQ4EOrKqZ8Hf8jDNiFsI0rBB4Rx5cUyIPXZBJJksUWahFdb5+enUUHawBgcFvjAp/izTZPzbMJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023189; c=relaxed/simple;
	bh=tZEtvuDyjIgsCEp+aNseIczE87v786Mq5twkf1v5+74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=biQ+9A92WoHTD3rKpMv4tOLkMLGJyul9I5Kjz10yS5yaITCwDCjDHAlZIj2dZJRjpIl1ua2Fw99nUZ6aygxjHegKqXfUuI5pSN5Cpc+mnzN8XFnEPqeqozjDwRu+elIWy7YyQxIAjZ1gJegohH7oGbp9ErrhDpIfjZutUmy6fzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HfRycgos; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HfRycgos"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023186; x=1821559186;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tZEtvuDyjIgsCEp+aNseIczE87v786Mq5twkf1v5+74=;
  b=HfRycgosq6wHOHxMmIge+8LJeG4VJ8tzuGIT9XzDatNgHOj/VblHxBi7
   XO7HbOrVNOUAzDDJAI12SujOrHwXtzaDbzYuXXNK5t2IZoGvgQeTE9Rc7
   sv1jgZWtFHAyrTUF0QdIcpWO5mW7PfWuDQk4VVKJPJ3V0wWiWeVON+yfp
   cj25CDTV/aPuBLLl9pBhPOUL5T3eAcghfI4+DF3VjPbYj7VQgOeR2QgGJ
   o4zkEigiLlaVCLd/NUlzcl7pCS/F/0MI+Liv4nxhDw0HGPlPJdaSvsoXG
   XsnWNN4oRbtesYQZ8nzpaac1GBKW1nez1kZlnlpzF56vNv+6NtRGm9LEk
   w==;
X-CSE-ConnectionGUID: 7l6uZtgxQnm0lsVg+BUimQ==
X-CSE-MsgGUID: kD2ITHSOSuidzjlXXP5X4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128799"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128799"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:46 -0700
X-CSE-ConnectionGUID: AwioA1k+Sc2yHo0GYdlhzg==
X-CSE-MsgGUID: 4CPlWoSdRrGZ5F53dreFvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762079"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 11/15] wifi: iwlwifi: Don't allocate a DRAM buffer with an invalid ID
Date: Mon, 21 Sep 2026 23:41:21 +0300
Message-Id: <20260921233731.ebd907861742.Ib74687a84e65d2e5295d338600283978a7018375@changeid>
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

A DRAM buffer allocation shouldn't have an ID of 0. If a broken TLV
contained such an id, this buffer will be allocated and a command will
be sent to the FW. regardless of the FW asserting on that or not, this
buffer will never be freed,
since in the free path we do check for INVALID...

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 5576598cc6e7..4372a171172b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -619,7 +619,7 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 	u32 num_frags, remain_pages, frag_pages;
 	int i;
 
-	if (alloc_id < IWL_FW_INI_ALLOCATION_INVALID ||
+	if (alloc_id <= IWL_FW_INI_ALLOCATION_INVALID ||
 	    alloc_id >= IWL_FW_INI_ALLOCATION_NUM)
 		return -EIO;
 
@@ -702,7 +702,7 @@ static int iwl_dbg_tlv_apply_buffer(struct iwl_fw_runtime *fwrt,
 			 IWL_UCODE_TLV_CAPA_DBG_BUF_ALLOC_CMD_SUPP))
 		return 0;
 
-	if (alloc_id < IWL_FW_INI_ALLOCATION_INVALID ||
+	if (alloc_id <= IWL_FW_INI_ALLOCATION_INVALID ||
 	    alloc_id >= IWL_FW_INI_ALLOCATION_NUM)
 		return -EIO;
 
-- 
2.34.1

