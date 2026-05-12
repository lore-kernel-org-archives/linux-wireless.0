Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE4A33EAEC
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 05:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563416; cv=none; b=Gawen15DfFYxWdb/l8d9Sn4eH/rutLn9xfr6903S400eXlhRSZec60mW0RQI7BC+Tmj0JqeOXsH+sQ99vGKqg4PtXRs1S9BFZyo+g7FWjgGDOq8lKaVedyk3Fbnn84e2LuZORRphN1Klz8h2Ss9fnUbLe2XZulahEdQhsAlnmug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563416; c=relaxed/simple;
	bh=pl4WxwZpS1bHOBUQ/z6ltcNFNNshAj8z7UOaxOCX6VA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bkDg4VXdFe8Dhi5/JTezdkiE8GtY2R5ZrjLKN6l8ouQEH/Q7QDEDhT0AH9fa0AyRHHRvoU8JImBK2dpDK0L/85sjeLWWbh2zwFvYW2ipn1GYLP6/DF+xVmN33iX/KovtpKfcdZv7Y3GLK41KIImna8RID5U6fZcxDXeKtD/rTkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RKvg6e/R; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RKvg6e/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778563415; x=1810099415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pl4WxwZpS1bHOBUQ/z6ltcNFNNshAj8z7UOaxOCX6VA=;
  b=RKvg6e/RKWNXD6VzyrOc/w4HKJnauRXdFC6AZ8e7NQJ0jfSq7Zbm6IzY
   ncsG8CnxvE5y7aBJtfU/gF0gzDoVbFR6qb4wL8CkkKuO0qUhtE86QLdtw
   buCyCMa3V1tHfyYeBqi5/9XQk9fCofHML7qU0ZkTIEH3LZtHSloblb2ZD
   A8DWYwt2SXG/i1T6C/5plAN5PSEqYFPyUb+MCJyT/ft0gZcx/HBjkbPcE
   zgCJ1cz2OhRKVW/D2B3ZKeEmEVCY/pFlY60RxiWNWZY/bHeN7kxQ7f8cW
   mH344T9JvFtk8wvAQNKXVdE5yIwNlPBbYw9vHosgUqvwFcbMTolwzK7e8
   w==;
X-CSE-ConnectionGUID: 0tBDP72dSVm0zg4n2le+tw==
X-CSE-MsgGUID: NfrbSJwtTXWLetTw4f2LLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="78495103"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="78495103"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:35 -0700
X-CSE-ConnectionGUID: sxdco8+DTYWVHrijQaYZ0A==
X-CSE-MsgGUID: DXFyCiu5SiCCRrv5cmY6kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="233187586"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: mld: stop supporting iwl_compressed_ba_notif version 5 and 6
Date: Tue, 12 May 2026 08:23:04 +0300
Message-Id: <20260512082114.59e41f7e1e43.I13572fed4393935c31fbe5c565be9f385bc0da30@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
References: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

The oldest core that devices that load iwlmld op mode are supporting is core 101.
Core 101 has version 7 of iwl_compressed_ba_notif, so earlier versions
are no longer needed.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/notif.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index 692251257116..fc6550bea155 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -307,8 +307,6 @@ CMD_VERSIONS(tx_resp_notif,
 	     CMD_VER_ENTRY(8, iwl_tx_resp)
 	     CMD_VER_ENTRY(9, iwl_tx_resp))
 CMD_VERSIONS(compressed_ba_notif,
-	     CMD_VER_ENTRY(5, iwl_compressed_ba_notif)
-	     CMD_VER_ENTRY(6, iwl_compressed_ba_notif)
 	     CMD_VER_ENTRY(7, iwl_compressed_ba_notif))
 CMD_VERSIONS(tlc_notif,
 	     CMD_VER_ENTRY(3, iwl_tlc_update_notif)
-- 
2.34.1

