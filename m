Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9890637A4B5
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2026 08:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994180; cv=none; b=V4yCS/t1AhLkohal0mN81exlkher+tKQSY/F6QcQ3Pm+Pc8EUbAj+taudUiNse+qynP57S23L1cZ1AcfAvGr0o99OhyD1IWqUe52iUsSg0uo37O9t5u/KEJVhe04WCMr6kKBUNr6lll1jfnX7NMXsj6UtpySM0uOgUUJNnECdwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994180; c=relaxed/simple;
	bh=NSjLC68OGdRmo8BegRsHSELsqukAWCmhpYo71f+/l6E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aCirCz2GYbxDJjoAz+dRJIQmikuHJhHCVp48xO2hgO0SHGTqYNEhh+e/FR3db2wcpggZKhbOCaj2BwfUJCG6LGI+jK/1ykHVcVnJQvWjtSDhGm9nWTe53qLoKfbKYmbQ5nEHRLIRVBMr1aAe2nVPHqmK0GYWY7DaH2ZrH5PGqkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NiobahcL; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NiobahcL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773994179; x=1805530179;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=NSjLC68OGdRmo8BegRsHSELsqukAWCmhpYo71f+/l6E=;
  b=NiobahcLMU/fXgvlEk4pHDufqD6hMZZK2LB3Dd6H3ObgZ2QorOuT0Z9l
   L4Ui5jHjaSd45wePU+nDev8V/ugvcNKzSVW5QaSYp0uyIsghTymef5rQP
   PL/Jfqv6AMmedzjyGKGlOxZWUL3764Q+CNGDqaSgqA/q09Yf24bWqx9CW
   54iWRZUUFuX6SkUcJEkImEborNl99/EPTwsvANsc796drIw/VbyIlBTNu
   s3yK6k9gmSmtnqi0RoGsSTWw7b62THisuYUF+EdNQHmn2xfUHYFg5H+SU
   yzIT+BPOFLmahd1jJodIZQcRt6LmN9D0vlgnhEENO86AcWL4Yd9HwI8q4
   g==;
X-CSE-ConnectionGUID: uU8T6IR8QYKZ6iqFiIAa3w==
X-CSE-MsgGUID: xPG2+V1IQF6m6Tzih+fNZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="86154120"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="86154120"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:38 -0700
X-CSE-ConnectionGUID: BhDhgMjxSuuNZCkVlZyaYw==
X-CSE-MsgGUID: Say3qJOwRf69KY5tMftwfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="227692571"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 01:09:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: bump core version for BZ/SC/DR
Date: Fri, 20 Mar 2026 10:09:09 +0200
Message-Id: <20260320100746.3b6540a99c1c.Ie2d3bdb3dc1865ad7c865cdcbeefa41d21ea4482@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
References: <20260320080918.2567780-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Start supporting Core 102 FW on these devices.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 77db8c75e6e2..3653ddbf3ce9 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_BZ_UCODE_CORE_MAX	101
+#define IWL_BZ_UCODE_CORE_MAX	102
 
 /* Lowest firmware API version supported */
 #define IWL_BZ_UCODE_API_MIN	100
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
index a279dcfd3083..83d893b10f8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
@@ -9,7 +9,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_DR_UCODE_CORE_MAX	101
+#define IWL_DR_UCODE_CORE_MAX	102
 
 /* Lowest firmware API version supported */
 #define IWL_DR_UCODE_API_MIN	100
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index ee00b2af7a1d..749d46dc0236 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_SC_UCODE_CORE_MAX	101
+#define IWL_SC_UCODE_CORE_MAX	102
 
 /* Lowest firmware API version supported */
 #define IWL_SC_UCODE_API_MIN	100
-- 
2.34.1

