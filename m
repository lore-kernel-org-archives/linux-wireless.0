Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F78C351C25
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028809; cv=none; b=IXGkAPV2PiB7QFjg39W60HwIkKx11eqv3vo8i1OEcCurWch84+MJXkYYexBiOOAoGarmkomGOQJNs9M6HS+FVJg46fBxpI05E70Z4VsAcFEO8sPheoP5bZPcx3ZpSm5oDo4nvX497S9onAnRenUrB56iHc5GFR9D+j/xww4i1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028809; c=relaxed/simple;
	bh=Rn5WoE9aqjgy/fQcTFSuQUYdNpb3qzLFOIilqo9QWZA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kNBeKBIw7EqO3sChz4/6vsLoOJmK2wNaRgGYfrVVGfr48h2hPeFtV4iaYpl6IqKRRn5CX0Da5oWiQO7yr6/S//2bEbkD/KAnDjX8mDx5z1Jly+U684MthixmH/AHyXISApuab9aOlUl7DdUCPkrG1OqfivEIXtzrTPbVTO76NOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1PLXh9v; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1PLXh9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028808; x=1815564808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rn5WoE9aqjgy/fQcTFSuQUYdNpb3qzLFOIilqo9QWZA=;
  b=b1PLXh9vbPAt2zlXsAQ9eT4/U5RnmXnnaA8aBrtuPvuOf2cKNIEs+n5Z
   /lIav2JSzGXKWHH8cMEC/Xsjr2kdpa92Vm1cAzlipcgjZfD9Jn/Spjk3H
   cUYkKdg9Rb/Mq9mJGHHdGNXXp102m8wbgI/sASAnFb5haIp4FeKg/xRza
   fsnnUHlrW/4FX4vc18oSTScm8V0NYCsxg68rcvy4fTuAPliaRLzlHoxmv
   X1uVMV8U6CY9p5fQUwBjDhz+lj7P/sS7mT9jb2N13OPv+iUwcvfZXRPC3
   /kkg2hsxMY6dPrxxm99FCcFLGH12V4rBjSN6XvBImklvgcNA3PXbKwQ5v
   A==;
X-CSE-ConnectionGUID: dfo7MzVJRgiJppddZof8Lw==
X-CSE-MsgGUID: J1bTXuRmQ3uB7Aq1eIH0dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469616"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469616"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:27 -0700
X-CSE-ConnectionGUID: XcFR858ER8mtzNoYmLNyyQ==
X-CSE-MsgGUID: aHerJwKkRwaZS5tlwx/2qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255883014"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:25 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mld: reset the driver state upon firmware recovery
Date: Tue, 14 Jul 2026 14:32:41 +0300
Message-Id: <20260714143119.ff1c9e05e0a9.I8df8d4a0384065fd2a32cf258339be77084c55bd@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
References: <20260714143119.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Just like we did in iwlmvm, we also need to clear the mld state when the
firmware was killed because of the device being powered off during
suspend.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c      | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 17286b3341c0..4065d8e4fa8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -543,8 +543,7 @@ iwl_mld_mac80211_tx(struct ieee80211_hw *hw,
 	iwl_mld_tx_skb(mld, skb, NULL);
 }
 
-static void
-iwl_mld_restart_cleanup(struct iwl_mld *mld)
+void iwl_mld_restart_cleanup(struct iwl_mld *mld)
 {
 	iwl_cleanup_mld(mld);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
index aad04d7b2617..f3302997b28f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __iwl_mld_mac80211_h__
 #define __iwl_mld_mac80211_h__
@@ -9,5 +10,6 @@
 
 int iwl_mld_register_hw(struct iwl_mld *mld);
 void iwl_mld_recalc_multicast_filter(struct iwl_mld *mld);
+void iwl_mld_restart_cleanup(struct iwl_mld *mld);
 
 #endif /* __iwl_mld_mac80211_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 99506f354bfa..093bdc130704 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -748,6 +748,7 @@ static void iwl_mld_device_powered_off(struct iwl_op_mode *op_mode)
 
 	wiphy_lock(mld->wiphy);
 	iwl_mld_stop_fw(mld);
+	iwl_mld_restart_cleanup(mld);
 	mld->fw_status.in_d3 = false;
 	wiphy_unlock(mld->wiphy);
 }
-- 
2.34.1

