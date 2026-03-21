Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979B331A41
	for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2026 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774114192; cv=none; b=er6IvW7bkxSPaLvS02gSeHn9nt6xpESJtwSsv9MHZH5A40EOY5wF4j5VuzVfzjhjoFyB+pkhlx9ovVSBmmqg3EtNc8wPXt4iTuj5mDhYLbnlqwbLXS+H+JLn6lR9OvuoVfhG5k0VYmGiPI7yqXY128+1vCtw5cOyEBlYmlKAJtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774114192; c=relaxed/simple;
	bh=WSvE82F19ePVKylyP5Jz/fFXwstJ705Z4B1on3RUkgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DYWjnWkducUnZ1pVSnleU55QaSRXhRnfmVPxUR0eIoN3OSn/xjNP1PMhaP5NxXz9wggP0amefCiYwWOt3Hzc0+K7gqVW2ZCEdDaPpO9O7tpdKZgRNKH2t++tVwMq6YdSREtx3FGcBD930sOM1NeIZ7mKusfKtxFmygLXqJy9HRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WiyS2UxD; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WiyS2UxD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774114190; x=1805650190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WSvE82F19ePVKylyP5Jz/fFXwstJ705Z4B1on3RUkgg=;
  b=WiyS2UxDOUwu9OMqi0DlIupG0Zwig/lh7cZSBwM8JKDzrgSvRs+7kEk+
   1cLAPPGV7HZYvMTbyb1eIaMnyw4kGh39uF1XRFKhQki8kxXGyYReQkdwx
   oLWM9c/A92+cVhjsCVHzVx9zoEtee9A1RA6nhR9q0MmWorr6Ieqfu0Z8X
   oYzjt3X2vm8O4HQGehoW9EpwP7mlOCZcn0aBznUxrfHeFDYx0vrT9Syfl
   BGpaCfhoTxeO7lcY/BC1ltltXhkoX6nqzBGF+o2e+FJ9YMxRBQCrZKnhH
   r2taloWSuyoZ79+S02uX9AbaXQ+7sqHYda/mH27TtfEfa7L/1dwyiRNFX
   w==;
X-CSE-ConnectionGUID: fcZcsnRxS4ieq26aJ6GyYQ==
X-CSE-MsgGUID: LmDDk0LHS8iNl7VjtR4scA==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="75244597"
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="75244597"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 10:29:50 -0700
X-CSE-ConnectionGUID: x1xSl8tRRDiCuhJJ0yM4VA==
X-CSE-MsgGUID: wp61pwNSSkON16xAYuc4Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="223813610"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 10:29:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: fix the description of SESSION_PROTECTION_CMD
Date: Sat, 21 Mar 2026 19:29:20 +0200
Message-Id: <20260321192637.56545b097d13.If468c6a666dcf3a52601604bfc8a1c4faa9d320c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260321172922.3938740-1-miriam.rachel.korenblit@intel.com>
References: <20260321172922.3938740-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The struct has been renamed to iwl_session_prot_cmd.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 25c57753ff34..b398c582b867 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2019, 2021-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2019, 2021-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -26,7 +26,7 @@ enum iwl_mac_conf_subcmd_ids {
 	 */
 	MISSED_VAP_NOTIF = 0xFA,
 	/**
-	 * @SESSION_PROTECTION_CMD: &struct iwl_mvm_session_prot_cmd
+	 * @SESSION_PROTECTION_CMD: &struct iwl_session_prot_cmd
 	 */
 	SESSION_PROTECTION_CMD = 0x5,
 	/**
-- 
2.34.1

