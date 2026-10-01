Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672D4A3F39
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860716; cv=none; b=UYqLQfiEj61JHIARfWLaq5y8IvVn2Xd+QnRJPQtCptY48l4ZnyN7KcfYvQL2WJNl+js/VEFs9r/Jr3qcdBSrvrF4aeZC52ElHrsJmPTMwAuMa8LRopQ9AfoORxJZdwZndz49IuWH/3zxHh6ja49RNdZm4Gq+n0kgFWgZGlxfCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860716; c=relaxed/simple;
	bh=ve2VVcB2Dsqj2YF03y3fJXuHy5f5u8Uq6MVETcDpiyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bfqUEr1N7uUVFk8gOXlVH93BOeIkobWoO/AMRJRczgd4nyn3nJhMAEv3mU77RXSL2QoxCpfTpKSNJ0VUam2b9dQ9K/UBA1kYjVw6LHxnA86i+xjB23xJ9vOFrKZdlt0d6yjDvP9NJNr2CdP6pERMBSUorZkOcAH3IH1AtVxYt0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9XqgDAu; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9XqgDAu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860713; x=1822396713;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ve2VVcB2Dsqj2YF03y3fJXuHy5f5u8Uq6MVETcDpiyY=;
  b=e9XqgDAuJMxNyLI4q7HwP+s9S15EIlAzbHK+z7vZ09kvIx8xAljrDfSw
   20DJxlfkt0YRTN3adw6kV5Y7eFASJJbAJbgWTAlqmY8THOl3c5lNPAv80
   L6HymS4h/eiIEli8uIpTe1VV09MRzlWQDgwj8Ulk57r+/kuuL/Bxk2m+o
   NAdpZuvUCRuv1llfaovNSReDOwN/V7QJj6r8IRn0orACDFFB/LJDepWyQ
   ISFZMF8umhYvJv/QTfUp/CT7fg2Z6sy8vVLeCnlvGQssOzwxifeSDHhgR
   CBUI8lhWq2MrDJJVdGBfZ/yyDx+fQzpbzv9KWF3joT/6SPmvYqBsfkbp0
   w==;
X-CSE-ConnectionGUID: SgVlwkAvTlu5h5M4z0WtYQ==
X-CSE-MsgGUID: Kaorun0YQaGM4R9V67dX2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423616"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423616"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:32 -0700
X-CSE-ConnectionGUID: tqKffit0Q5ifsjqqf+XAfQ==
X-CSE-MsgGUID: i2az31e3TE+Biec8gBGunw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485502"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:32 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mld: add STA_CONFIG_CMD version 4
Date: Thu,  1 Oct 2026 16:20:14 +0300
Message-Id: <20261001161715.b62474b1ccef.I51756391283ec42a40dd38a3586ad89759fb82d1@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Version 4 replaces the unused trig_rnd_alloc field with cip_defer and
epp_robust:

 - cip_defer tells the firmware to delay the usage of the unicast
   control frame protection key until after association.
 - epp_robust tells the firmware that EPP robust individually addressed
   management frame support was negotiated, so that the protected
   action categories are used for specific unicast action frames.

Add the matching EPP_ROBUST_CONNECTION flag to the WoWLAN config
command flags for the D3 path.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h    |  1 +
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index 9f7407c4f980..a0379aca99d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -366,6 +366,7 @@ enum iwl_wowlan_flags {
 	ENABLE_L3_FILTERING	= BIT(1),
 	ENABLE_NBNS_FILTERING	= BIT(2),
 	ENABLE_DHCP_FILTERING	= BIT(3),
+	EPP_ROBUST_CONNECTION	= BIT(4),
 	HAS_BEACON_PROTECTION	= BIT(5),
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 9579e691cc87..6e536f48acdb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -940,8 +940,13 @@ struct iwl_sta_cfg_cmd_v2 {
  * @mimo_protection: indicates whether the sta uses mimo protection or not
  * @ack_enabled: indicates that the AP supports receiving ACK-
  *	enabled AGG, i.e. both BACK and non-BACK frames in a single AGG
- * @trig_rnd_alloc: indicates that trigger based random allocation
- *	is enabled according to UORA element existence
+ * @cip_defer: delay the usage of the unicast control frame protection until
+ *	after association.
+ *	Only supported from command version 4, must be left cleared otherwise.
+ * @epp_robust: indicates that EPP robust individually addressed management
+ *	frame support was negotiated during association.
+ *	Only supported from command version 4, must be left cleared otherwise.
+ * @reserved1: Reserved for alignment
  * @tx_ampdu_spacing: minimum A-MPDU spacing:
  *	4 - 2us density, 5 - 4us density, 6 - 8us density, 7 - 16us density
  * @tx_ampdu_max_size: maximum A-MPDU length: 0 - 8K, 1 - 16K, 2 - 32K,
@@ -979,7 +984,9 @@ struct iwl_sta_cfg_cmd {
 	__le32 mimo;
 	__le32 mimo_protection;
 	__le32 ack_enabled;
-	__le32 trig_rnd_alloc;
+	u8 cip_defer;
+	u8 epp_robust;
+	__le16 reserved1;
 	__le32 tx_ampdu_spacing;
 	__le32 tx_ampdu_max_size;
 	__le32 sp_length;
@@ -996,7 +1003,7 @@ struct iwl_sta_cfg_cmd {
 	u8 nmi_sta_id;
 	u8 ndi_local_addr[ETH_ALEN];
 	u8 reserved[2];
-} __packed; /* STA_CMD_API_S_VER_3 */
+} __packed; /* STA_CMD_API_S_VER_3, STA_CMD_API_S_VER_4 */
 
 /**
  * struct iwl_aux_sta_cmd - command for AUX STA configuration
-- 
2.34.1

