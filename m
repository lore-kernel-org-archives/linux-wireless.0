Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB25D35A3A4
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773946170; cv=none; b=b6sASzplEYwGPVYUa91TMoJtyCgYjX0xxBu4rRbW8vl3R0DPK5CFbpMwXa8s35o5k03KarEGJGNRzuuZvSYHqGZ0WDdAvoPd0kDfO0pnX8bVI/U5DBN1PfhztM5l5/VGmgURUe2mCXiDAFVHjI20H7HD2jO+FL/Vy87ERpfMXi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773946170; c=relaxed/simple;
	bh=HhfFfOfO9zvoUvhftWocVSlC7ODvXWyD+pRNhLmSCSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LVWsW32kDBOIo9HY8QFQqp4YcKG5I0DrSgFrZe5V4//m6brDMwjRrnksQYY92h4n49C5SvR5P+nXEreXkuTMJyeQGFPNatwuJs4RZLxamKays12t+Zs5Xki7QsZOrConZWrx56PJJOqYqaAQxhlycsCLWqWzaweeuvMJqZAb0sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+g+o9bx; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+g+o9bx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773946169; x=1805482169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HhfFfOfO9zvoUvhftWocVSlC7ODvXWyD+pRNhLmSCSY=;
  b=Q+g+o9bxW3x4Tnji95q609d6lbLHYCMe7h/ZJ9ZVfHWWEx2EgrsbXjA5
   tR0x3ZQBenumQcIz+9/YN56Op3dzR0nUSr6INkPpJwEqw9ltfeOh/As7o
   oB9LCbTARc/rIt62/KtPLIHYv4ljeeUFhAlhfj1ZUyhaip+k92s/o3CgS
   6N+18khU3MPYutnKNE1sCjzHUFBHKmiNL2fGSQP/Qe8SqbehINp8kK3dY
   E4/60Aqy+ZS/CHL3hqZfvsH5v28KOdwSmTP29YIiBua4PSGb8HPRDQMpq
   LzaWEcJ/vmqwQWvjcOqXowqGCd9DZndGmtlVOiAqivbFNzC6wR4bPxNQ5
   Q==;
X-CSE-ConnectionGUID: jLSHkAz2Syar+33H3guLnQ==
X-CSE-MsgGUID: 7oQRW4WTSpqq+MHpcAVVjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="85656494"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="85656494"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 11:49:29 -0700
X-CSE-ConnectionGUID: HdmkKFYiQ66j8noBXMuYgA==
X-CSE-MsgGUID: 5+nGpWOxRR2aDRVKg0g/hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="227998597"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 11:49:27 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: remove IWL_MAX_WD_TIMEOUT
Date: Thu, 19 Mar 2026 20:48:54 +0200
Message-Id: <20260319204647.15341c4081ed.I639a1d65799ce5502e5c83e8889bcc5eda5ec4dc@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319184855.1981384-1-miriam.rachel.korenblit@intel.com>
References: <20260319184855.1981384-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This define is not used, remove it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 45cf2bc68e41..5f40cd15e27f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -85,7 +85,6 @@ enum iwl_nvm_type {
 #define IWL_WATCHDOG_DISABLED	0
 #define IWL_DEF_WD_TIMEOUT	2500
 #define IWL_LONG_WD_TIMEOUT	10000
-#define IWL_MAX_WD_TIMEOUT	120000
 
 #define IWL_DEFAULT_MAX_TX_POWER 22
 #define IWL_TX_CSUM_NETIF_FLAGS (NETIF_F_IPV6_CSUM | NETIF_F_IP_CSUM |\
-- 
2.34.1

