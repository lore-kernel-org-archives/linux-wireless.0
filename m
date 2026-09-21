Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59DD43C05E
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023189; cv=none; b=kD0WadXHvDjffNiM1+8xeDbMQ4XenDFypUattuw6HbG+gHeiy3vfTk0cKw+7Fs47wZUcpJSOEpzF8iSNYNAO+cSRbtWo6WfwET0pcHBNkEkmVFUHhOfO7+GBuHt94jQbassudHJo62Y5574ngJKmGTs/V0iBbVNWuoDQw7HT5EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023189; c=relaxed/simple;
	bh=Nvj1aSRBgJvA3CDMGi6Xxt92G/Z/z7vn/lBJMxVhH30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lOqKPVqODK6Jv9Q2f/FsZBx2uA7nH0kSRPkotMbYnRWgZA4I8BrGM4tLM8WZBivIZN3GZYGcKFj8R1zzqyTqorOR0sqSpSQ5Zj0vhOMzdNbHuz+kY9FyN0a0cK0TS2EetcITEPybG4cjgpD5yS6QiiLR7K/HOwc7qjS7AMc4fbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mf6Y1K5T; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mf6Y1K5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023187; x=1821559187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nvj1aSRBgJvA3CDMGi6Xxt92G/Z/z7vn/lBJMxVhH30=;
  b=mf6Y1K5TVorzlW7XswSBLEBfn2BOeAUKDJVSZW8QHUwlS/MQp07vTl1I
   iqg6t+kIsVb4p5aDtmdMNeJgCObLfw3i+r5IwHZbJ+P8cSnW4GIwge78z
   NZnKEqh6WUndHR/VnFdholBre3+7UUMHPIlp7TV8a0O1nXIcSckAiviv5
   gphH6sD7+cdiJYs5b3E+O9QugZQFXwlZeOJRWvsH0TXbvJmjpiZry6xId
   jYu1UOnA+RGLyv00BJclHNotvFhLB3vV9qJJ6Elv2uQ7GMjRmcWxYs23L
   DR5tEMOLh4d8c99DC7Ies59i5b62QcCNF/actDRzZlcjBsAb27vEMD9Ck
   Q==;
X-CSE-ConnectionGUID: kYfvhXT6QziPTMzAjSHToQ==
X-CSE-MsgGUID: qqdImUyRSWquMttkMRiS/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128802"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128802"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:47 -0700
X-CSE-ConnectionGUID: XpHlvh+OQgeXWr3LmIbioA==
X-CSE-MsgGUID: LfJkeiomRw6RrqryCdVehg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762098"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: mld: explicitly include mld.h in hcmd.h
Date: Mon, 21 Sep 2026 23:41:22 +0300
Message-Id: <20260921233731.252cd5ae36b1.I5ea033fff1dcabd46e7d66f15c140dce2c5c9a1f@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

hcmd.h relies on mld.h. Make this dependency explicit.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/hcmd.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h b/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
index 19e1c9e509cf..761ef73dd9a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
@@ -5,6 +5,8 @@
 #ifndef __iwl_mld_hcmd_h__
 #define __iwl_mld_hcmd_h__
 
+#include "mld.h"
+
 static inline int iwl_mld_send_cmd(struct iwl_mld *mld, struct iwl_host_cmd *cmd)
 {
 	/* No commands, including the d3 related commands, should be sent
-- 
2.34.1

