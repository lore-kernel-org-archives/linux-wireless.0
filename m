Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A762C326C
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298703; cv=none; b=b1BRCbtLFKsO5HxMUKQfWYimWDK6DcsoS5t/9CSAFIRHrJrZgvyj3GCAHjKaqsnxiXKMP9ae5OZjHjfzInwVgbCFSssqNWMQTseVAcyzjB8bj/D091ALrVNPAFsHVxYaMEaPHY2lGzN7BNfhjCftelYpCoHfG/5f0Qx/Ht3xzME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298703; c=relaxed/simple;
	bh=8sSny09nqCHxg65/PqkJMky/10+JCVyCtOzbPdBQIws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Szlu741x6WGOu0o43c/QZkVS/TgGV99SYLpHsYoDxOoga8ffc5iST3FfiaDSlttaHYcc+5STVJUoqw7GzlVclFJn8cRE6VpstnHZc866xI0v5bHMaIN1BqFun14tn0J7K/2tg1Hu3vCPkrrAhKv06deaLKI/KsbOER7cGhtV1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7zCA4BX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7zCA4BX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298702; x=1815834702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8sSny09nqCHxg65/PqkJMky/10+JCVyCtOzbPdBQIws=;
  b=l7zCA4BX5cyd8vkKn2FFXhuBG39KL2L+3+RNFcja2FVOsLHDbCUSDV10
   5xSzB/AACt5qwd5O0LvJKVT1X1qVHaB+m1ZkrldtQ0qMQBdRlKmtL4Yyd
   SpmBdVTLdS6uU4tSeG91GlO0aL0RkhoDi6mkwdvNL4CGLacCBiJfI72RA
   A2Milk91gnDhqkSOsPABtmzik/+WArF30uS9CLM/ScuAPWAFGBPF6drt9
   kaS+CblrE93lETVMvBAosDpuYiJcWGWyNtzxW675gGvI690nGJC6J2t5J
   SDeinjpwPlB9eoKEjnNEOGgtuY52DYV4rtpKkbgTFN2OQbxAqsTX/7aMk
   Q==;
X-CSE-ConnectionGUID: IqIuFC9KQ2+zcML6s+ZeCw==
X-CSE-MsgGUID: NBPzsBoUQ5qDEKvK/brfHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925991"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925991"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:41 -0700
X-CSE-ConnectionGUID: kaQFXFP0S7m4vxn1MdGhRA==
X-CSE-MsgGUID: 3Q7h6pZ8R2OokrDd04RomQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885736"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:40 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 4/8] wifi: iwlwifi: mld: drop connection on D3 resume failure
Date: Fri, 17 Jul 2026 17:31:08 +0300
Message-Id: <20260717172958.3e10c8498f53.Icf5644b42d79e984ecc16abfa873bd37f611e778@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
References: <20260717143112.2314116-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ayala Beker <ayala.beker@intel.com>

When FW crashes on D3 exit, iwl_mld_nic_error() sets
STATUS_RESET_PENDING and queues restart wk, but mac80211's resume
callback synchronously calls iwl_trans_stop_device() which clears
the flag. As a result restart wk skips sw_reset, and the FW error
recovery buffer is never read.

The new FW boots with empty BA state and initial sequence numbers,
while the AP still holds its A-MPDU RX reorder window.
This causes MPDUs to be dropped as IWL_RX_MPDU_REORDER_BA_OLD_SN until
ADDBA is renegotiated.

We don't know how long the firmware has been in an error state
or whether the AP still considers us associated, so keeping the
connection alive is not worth it.
Call ieee80211_resume_disconnect() when iwl_mld_wait_d3_notif() fails,
and let userspace reassociate.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 301983428a63..55f9b809e764 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -2219,6 +2219,9 @@ int iwl_mld_wowlan_resume(struct iwl_mld *mld)
 	ret = iwl_mld_wait_d3_notif(mld, &resume_data, true);
 	if (ret) {
 		IWL_ERR(mld, "Couldn't get the d3 notifs %d\n", ret);
+
+		if (bss_vif->cfg.assoc)
+			ieee80211_resume_disconnect(bss_vif);
 		goto err;
 	}
 
-- 
2.34.1

