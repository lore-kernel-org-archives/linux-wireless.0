Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2546E019
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 11:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805844; cv=none; b=BYvjprfIGL92cZtEYABGkV6gA9yYVjAXEB/CMhEn1Ro4tr1eyi2FWUgcsZpSBXdf4rUPXrkIzwtPzVp+/7XxLa74MyoKWkrMBP+PCG2SEMAST+7CNLtAfD3Nd2hcw9grmN25mKEcMbqFfIjdoYXOShKkpkCTer8CR8XQ+p1lM38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805844; c=relaxed/simple;
	bh=QMRie0Bd/g14faPiyIsEh19E1kHmEa5B7+5L25/YE9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tlH1zsK/Cq+TyH5whhxt6RKjne0EoZBCMkFzsHjhVv1x8Kj12owGYeAP6A0+gR4nw4quV9VlL/why+sOYlLtP8fJGc65336XEzDG7+UOazBQcOc+9WdVDJZnAaKVXajCrXzstnGHwRabenFN80SK6jPc15yTwRgZl1K16oLDJ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9clNpM+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9clNpM+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784805842; x=1816341842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QMRie0Bd/g14faPiyIsEh19E1kHmEa5B7+5L25/YE9Q=;
  b=G9clNpM+65rsoaL5RZud4cDF8FvRia7VbIjE5B6JgK9VNbyvWrt5D/xZ
   vp4txTVxzDsmCdEgLMHqCKO02/H22uejw1htMI6+Qnz//U9XQrRBs8yJs
   oCLQFxlOiniggjb5PaIeuleJ0GEqS7hilAXInUZQIK1bWQExBeN4zDrrn
   6pIuMvdQHnWG69BPGYZjl3i9rHQVbqunNzVApEdmSU+0LQB00B8JTdjCG
   m1Fw1dk4LwV+K7ykqUc6zX8KLn7Gg/UY10TPJf1wpWU4gIIfxvOgE8x/k
   dMEY/5Yo6Ehc6BequNGkFlROeOTTyckon3o+DxJwo0niPd2Z0uJTmsqDk
   Q==;
X-CSE-ConnectionGUID: EWgl31ABSi+MnCj5P9b25A==
X-CSE-MsgGUID: HQWLBl5QQ+STfG+OAwn9RA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="87999889"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="87999889"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 04:24:01 -0700
X-CSE-ConnectionGUID: y6f/jAQwR8qqQzGCEI2WVw==
X-CSE-MsgGUID: ap62dCdYT/qbWUOF3p+ZJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="256581998"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 04:24:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 2/2] wifi: iwlwifi: bump core version for BZ/SC/DR
Date: Thu, 23 Jul 2026 14:23:37 +0300
Message-Id: <20260723142324.ed92b1d7f927.I6dd10d2f9a04a36751aea9e238fecfa62fe280a6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723142324.c576a8c7560b.I5cc1277d0ef31409f6a3364342a3f35cd9318ceb@changeid>
References: <20260723142324.c576a8c7560b.I5cc1277d0ef31409f6a3364342a3f35cd9318ceb@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Start supporting Core 107 FW on these devices.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 606362463dc7..1099d8cfe6aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_BZ_UCODE_CORE_MAX	106
+#define IWL_BZ_UCODE_CORE_MAX	107
 
 /* Lowest firmware core release supported */
 #define IWL_BZ_UCODE_CORE_MIN	102
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
index 946975294b4f..a89a2c75687f 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
@@ -9,7 +9,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_DR_UCODE_CORE_MAX	106
+#define IWL_DR_UCODE_CORE_MAX	107
 
 /* Lowest firmware core release supported */
 #define IWL_DR_UCODE_CORE_MIN	102
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index e8240c1782ac..16abf0147fe4 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_SC_UCODE_CORE_MAX	106
+#define IWL_SC_UCODE_CORE_MAX	107
 
 /* Lowest firmware core release supported */
 #define IWL_SC_UCODE_CORE_MIN	102
-- 
2.34.1

