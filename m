Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B1448CEC
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023191; cv=none; b=MNyUEgADYzsFKKF0nBq9MvTzq6g4jcJ1pE1msWxO8cirMro3rWv/SLQ8Ob0s89OsLkdRfnaqfh6ibaTbhphlkK5LY6BO2bz7XkxzSnjUIVDaQjosYI5v9NbjK3LNA/O8P/PJb5JyWO+49u+aiIsBCxZrcleFs4Abfq4kr9WD0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023191; c=relaxed/simple;
	bh=W4iv6HyS06coEAY+cZpo4NVL6I2sAbrVnl0ZigJFP0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AGE+4tTzaZdLj0BzofKA5Yqh23hBjVyKN6iGY8vB/xaqYtuTz68VKbf11EBIOhvSaKCCnWKhEOPiOL7lyueFedWtWBhCqdLdffKDflX3g8F+0FjIGLicR2AuzP5V+smooleg2zliV0YvSwtkQMWgoDi1PKDepNkLkJBiIrQzZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LtOqHoHb; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LtOqHoHb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023189; x=1821559189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W4iv6HyS06coEAY+cZpo4NVL6I2sAbrVnl0ZigJFP0Q=;
  b=LtOqHoHbVswZJ9k34wNnGJS8u9wwmQ/eBZKgBHxzFd8h+oW5Z9IroS6C
   QmtIi5if3lBObjMP81uIAXCOwJcLAMENSJhy/YqXWzNQoJV0Rc4pERbv6
   6FM0grUkojXO67J1jpnHsgEqJ2yOnQIHSQGN5mebjdiIGKlqL9BRZkMFZ
   1pQkDN0EacfrUSLeS8rrOZinKtX4Vp1378sdybYZoaVTdicBTzXjc9bPh
   GTq4qoSUfqQIoMi6T/s0KPLXoqYtwL14j1jEGTBUQFwOVk2YfeRdmvY2P
   NcdbrC+RVnnY5pVZru+hs11amxsxqgA55mA3Q0i9IvSGfyiUG3+aJUVGy
   w==;
X-CSE-ConnectionGUID: 7/61fYReRRmX0IFsWTNP9A==
X-CSE-MsgGUID: XVmGZLObSrGhem1gEXJetw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128804"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128804"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:49 -0700
X-CSE-ConnectionGUID: EGzbTVRISeOfFieKONHqjA==
X-CSE-MsgGUID: EQ2/6JyxQyS3RO5KeUBMKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762113"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:48 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: mld: explicitly include ieee80211-p2p.h in mac-cfg.h
Date: Mon, 21 Sep 2026 23:41:23 +0300
Message-Id: <20260921233731.13c9033a18cf.I2d3f3b8e2d4c7af0961726219974db2485e8312e@changeid>
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

Make this dependency explicit. We use the ieee80211_p2p_noa_desc
structure in the FW API file.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 01db6765855c..4a494563aa8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -7,6 +7,8 @@
 #ifndef __iwl_fw_api_mac_cfg_h__
 #define __iwl_fw_api_mac_cfg_h__
 
+#include <linux/ieee80211-p2p.h>
+
 #include "mac.h"
 #include "phy-ctxt.h"
 
-- 
2.34.1

