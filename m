Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444D434750D
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028797; cv=none; b=KNyWJ/HG51kIGVPv5q9K/zOxm7fCdwu2AhxEaHeNZbE9OiGFwUvQssEpnE2F/L8P8alCuqPS7xQ/QaiUrTYuca85RXhUWq6bWfsExL3RXQgy8qRDFXw0I7lPkMeaavkTpKR3yOKxrxHEC9hkbTyIJPvIFev712ukPixBUprz9ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028797; c=relaxed/simple;
	bh=Twbd1G0EESuvA9DN23mLsgMoDXe31L/E0EXKO0gd0v0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ahkDk7xEdTQsH+xdBqMIf2E7bXkbWbJD+8JKqDC196ZdZqsDFYHrEjUhN9MG06RSt/8EELvBRyJKiyoyjgZK0ztu9qpnGHQPsTtxQuSTsxoR/uKsxV9Ex7S7jSnjEbxTtEuX9FbSXRRwoILi8QANmo/vTH/I6Fb14D2UWhULLCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b2pVrNHN; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2pVrNHN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028795; x=1815564795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Twbd1G0EESuvA9DN23mLsgMoDXe31L/E0EXKO0gd0v0=;
  b=b2pVrNHNAv9u2tD2fDEiZ5JuCQ2qaEft0y0yfk+Y57yqSg2ShUmfMunC
   S+wDfG0epZWNUoAf6dhgx7VsbRobEXRQfVXV5G/7tvDia3IW9fJZVG9Eg
   SVjBPmYkyO/DCGvUdcrGZP1l31OnyUEsea9FIshPD8oDjFl0SmHVFXZM5
   zdziL/UHMEb/Wapp5/+OLiF7ursxHGpdDXeo36h7KyNN9YdBZfpexpFju
   u2MHuv1iO5ljtdwUWbJYN27cSimMmmv2HdKfldqDYxt+/2ng5lz03rm9k
   RizZ2DI1Grc37P0EI0csJ2ed7cxwHMlV0aoRoyv/cUx0V4mL62QPFUMTJ
   w==;
X-CSE-ConnectionGUID: hMqsqt+3Q7qEk7PdYxsCwA==
X-CSE-MsgGUID: /91uAVOjQjKCO1Ip1XW+lA==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469597"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469597"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:15 -0700
X-CSE-ConnectionGUID: C9/QYT00QVuZ9SgPR+p3kw==
X-CSE-MsgGUID: 8d1XN7njS0iLkFrF6Ni8RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255882940"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy
Date: Tue, 14 Jul 2026 14:32:34 +0300
Message-Id: <20260714143119.07aa49f755a2.I734a27b1b0eeb5b0e821aee3318fee8dc0a6bc03@changeid>
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

When we fail to load the fw during op-mode start, we purge the list
of the async handlers but we don't cancel the work.
Same when we stop the op-mode.

Before freeing wiphy, we need to cancel/flush any pending wiphy work,
otherwise the work will fire with a freed memory.
cfg80211 will do it anyway, but it will warn.

Cancel the work in those cases.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 78c78cf891cd..5a6c9ab20fd6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -446,6 +446,8 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	}
 
 	if (ret) {
+		/* wiphy memory is about to be freed, we should cancel any pending work */
+		wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 		wiphy_unlock(mld->wiphy);
 		rtnl_unlock();
 		goto err;
@@ -511,6 +513,7 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 	iwl_mld_thermal_exit(mld);
 
 	wiphy_lock(mld->wiphy);
+	wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 	iwl_mld_low_latency_stop(mld);
 	iwl_mld_deinit_time_sync(mld);
 	wiphy_unlock(mld->wiphy);
-- 
2.34.1

