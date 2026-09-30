Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F58945D5F5
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754910; cv=none; b=ElcNYhoHaYIPG+6Ws7eNUKOOm0aDKEMDUYko9eIyZc3JItiDcnwvwgDDe0fHL4ihk4XGfTz/DB5auiXPYBz/yXIuyMw/J8dxRuATBw1vNHjHACRbOhCBRZai5bKyS+AnfAbF1G9+rvdWdtt0BX5MLUCJrXiYP8M6M3UL4nBrMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754910; c=relaxed/simple;
	bh=eOLQdp9qIif6T5+vt5GglzHKqV8LxNIBD/cC5Yn1s6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b4X+p80mQDPpAPwUcnPV1WWEQ+nKFxVdreofuMlUuqRtMo3CYA0nWGf9zSgv24pycMhkBM1poncgkb2bxuyM1RxkLOg1oyIZxlUY+Hj+YkW8LCknKDSLjqf4/q3JA1aliMUE0NjLC8Mjw0tu/3USIlELRscEXGjRmbGsFIIBCZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQsApaDe; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQsApaDe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754909; x=1822290909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOLQdp9qIif6T5+vt5GglzHKqV8LxNIBD/cC5Yn1s6I=;
  b=IQsApaDeJu2jNiCxZ+44Ic5SCwy+WfgIEHy2usVs7Fnjd40bD3aOZ1el
   7bjjnIgFO0GBdpMPDM4+Q7FjeDzJw72abuMvKdAqwQDpQXpLWC6ipJqU4
   Z/L2iVPtHdidXoQf40v6V1BD+ZmMT55dA3O5BW0sq4WmzEMu9BH9+/PZi
   Ik+MqiVGU0lEjqfquM/0OF9YdsjlcAobaAFH8XYriRMSvL3gukqewwwNR
   hV2geiUQgpL/PaGuGae8oEhwWSpwc0VZPpjewi1yAaCV8OTQ36qltFUt4
   bdwM4L8xgayHG6I6Ov+NNWi5KDTIxJWQG/TJ64puKV6eNSGTeMiRqfwqR
   w==;
X-CSE-ConnectionGUID: A/leEFP7ROefFDeRoKnREQ==
X-CSE-MsgGUID: aNYjTENqSrq4hkjHAZF0xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296840"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296840"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:09 -0700
X-CSE-ConnectionGUID: W5u1icC6Rl+vOtoQ5LuJVQ==
X-CSE-MsgGUID: mnCS9sP4SYyyDMRSHKEDfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278963021"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:55:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mld: remove unused fields from the firmware API
Date: Wed, 30 Sep 2026 10:56:43 +0300
Message-Id: <20260930104825.56b2350ccd51.Iac2bd1f57b2c4bbdfe33efab31111a7de02bdf16@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

ENABLE_STORE_BEACON is not defined in the firmware API and is never set
by the driver.

STA_CONFIG_CMD's trig_rnd_alloc was never used by the firmware either.

Remove both.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h | 3 +--
 drivers/net/wireless/intel/iwlwifi/mld/sta.c   | 7 +------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index d3bed0216df4..9f7407c4f980 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -366,7 +366,6 @@ enum iwl_wowlan_flags {
 	ENABLE_L3_FILTERING	= BIT(1),
 	ENABLE_NBNS_FILTERING	= BIT(2),
 	ENABLE_DHCP_FILTERING	= BIT(3),
-	ENABLE_STORE_BEACON	= BIT(4),
 	HAS_BEACON_PROTECTION	= BIT(5),
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 7957ac11b0cd..97f013330f06 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -465,8 +465,8 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
 	struct iwl_sta_cfg_cmd cmd = {};
 	int fw_id = iwl_mld_fw_sta_id_from_link_sta(mld, link_sta);
-	bool is_6ghz, uora_exists;
 	u32 link_mask;
+	bool is_6ghz;
 
 	lockdep_assert_wiphy(mld->wiphy);
 
@@ -479,7 +479,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 			return -EINVAL;
 
 		is_6ghz = false;
-		uora_exists = false;
 
 		link_mask = iwl_mld_get_nan_link_mask(mld);
 	} else {
@@ -495,7 +494,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 
 		link_mask = BIT(mld_link->fw_id);
 		is_6ghz = link->chanreq.oper.chan->band == NL80211_BAND_6GHZ;
-		uora_exists = link->uora_exists;
 	}
 
 	cmd.sta_id = cpu_to_le32(fw_id);
@@ -554,9 +552,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 	}
 
 	if (link_sta->he_cap.has_he) {
-		cmd.trig_rnd_alloc =
-			cpu_to_le32(uora_exists ? 1 : 0);
-
 		/* PPE Thresholds */
 		iwl_mld_fill_pkt_ext(mld, link_sta, &cmd.pkt_ext);
 
-- 
2.34.1

