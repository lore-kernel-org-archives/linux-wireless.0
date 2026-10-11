Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFD9431E65
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716723; cv=none; b=OWV+80lA1w2UMjWKzjs4+hMZeREKaof1EKgfU2qlUX7uct24O5a0gvxeWPByH8i4gKiGf9bXP8HexrTMfE/i7dnu+QAyqWX/3hjl50LOJxTlBRb6juNtbFcCQZRY+qvtveCxm697FRfmKptAZfcbRv9LfdYAy7FYe8CeF8+c7pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716723; c=relaxed/simple;
	bh=fpN13TRKWqAWvORrKBtkt9bKj5hSuav51kJPt0wMOd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n/+iCZEmxT+uIKsQ5lZ4RiQhIAc5aYFko1ynklFuPvf9gIB0Zo7SIItlbfdqWvvnrbCkx0Baa/akZKsN88K8coq5PEXjo/kLRjL3a6S6/XGLtezdxvcTvRHKbuCFVw+4oG/STOuzmMsDGTQWGFL+ZwAFIjt39qk3SOc9t7nAahA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S9j+0MMM; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S9j+0MMM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716721; x=1823252721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fpN13TRKWqAWvORrKBtkt9bKj5hSuav51kJPt0wMOd0=;
  b=S9j+0MMMpo3AtXzm2Z3EvJP3IbCAQT9KCf0XXo372kVuIsGWBW7Mb9ww
   UpaCHPfFYbU3eXpTbrxSu5BJK+nGRpzadSbVLxJmz7bGOaJZRkCDQOGZd
   XL4dV//eeV0YUMymld4N7lCN/kNgFucf9uxqeKGNVExOR5MT+ECmlhVN5
   k52DglkEHi/tEyI5NyHtn3YVdV+uruaROWtpK55xe7lyC8kgacwLARhT6
   dJQYPBKZEsDiobNe/O9Uf35tXmGoyWGiw95WGL16wSi/2TtF7Rp7zbQOv
   KMOTBxfDBQ5v2UQPjEFpjeTEBil87SO8OApxntCDDS/79vIF8NdJ6eO1e
   Q==;
X-CSE-ConnectionGUID: UCCeMyYRQ+OUmvSF8vkjdw==
X-CSE-MsgGUID: pfk8cPrRRXudPgjw3B2zRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454167"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454167"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:20 -0700
X-CSE-ConnectionGUID: /XvigSV0SYKId/3SiY4ZnQ==
X-CSE-MsgGUID: 1AFV9znyTQSMvUoGBVA1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650925"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 01/13] wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 109
Date: Sun, 11 Oct 2026 14:07:02 +0300
Message-Id: <20261011140453.603d3010fb29.I53bc9bf1f5931e573fd55b62eef8be16270e6a92@changeid>
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

Start supporting Core 109 FW on these devices.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
index 3cc3ffd0aa1c..f6e0f0c8a82e 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/bz.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_BZ_UCODE_CORE_MAX	108
+#define IWL_BZ_UCODE_CORE_MAX	109
 
 /* Lowest firmware core release supported */
 #define IWL_BZ_UCODE_CORE_MIN	102
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
index f6dd1f9733fb..f62a0bf29754 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/dr.c
@@ -9,7 +9,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_DR_UCODE_CORE_MAX	108
+#define IWL_DR_UCODE_CORE_MAX	109
 
 /* Lowest firmware core release supported */
 #define IWL_DR_UCODE_CORE_MIN	102
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
index 467888c8d2cb..220b0d181f42 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/sc.c
@@ -10,7 +10,7 @@
 #include "fw/api/txq.h"
 
 /* Highest firmware core release supported */
-#define IWL_SC_UCODE_CORE_MAX	108
+#define IWL_SC_UCODE_CORE_MAX	109
 
 /* Lowest firmware core release supported */
 #define IWL_SC_UCODE_CORE_MIN	102
-- 
2.34.1

