Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ACA442FD9
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142349; cv=none; b=ZIWy+lPBLi94GMA2r/Al4EthTKi29IwiCCsx3+s+EbJvQAs6yhi9CxFIy4SLtVkNAKyYbh7mHwyq7uxoJrDQPqq3ZuxcwJsfh9/PY8iS/AKBJxo6gBJtT334ENAEeZ77tzQ3glCKtUmK9nerM7J8amOh2MvKHip8QC+kaj4789Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142349; c=relaxed/simple;
	bh=e7/4RZ7o0hYwtd79bnw94pRaZXV+RWUCVslOJKISg4w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LVHiHaAdwu+KBc6T7CS7QRH1dCDEPWt7YE+X5gL36rtjzufQdM+zuUtuHM+yKF7gVS1cPFlxu/aHnb17zsAxqySInVE7tGK48jzABtEyKq23t68ZOb5HUFWSzW9857WhQzsbRw/UyE2YP9w4gYnFsZJAyHFpobuIxGb2ltoFn28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mfOjSRLm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mfOjSRLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142333; x=1815678333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e7/4RZ7o0hYwtd79bnw94pRaZXV+RWUCVslOJKISg4w=;
  b=mfOjSRLmxMLNR1+fc+Dh1FSiV82T9aLdZ2MU3w6oV0j2vU0NdyUhgre7
   N+PJXjJo7HObVRSx7kr9vVVKxSkJ8DssMjAIO9Ph9r4K/OzNmHbiSQi4d
   E4e+I5zYru/9LQLjONXz8YzMmSuYhMM1Rc3s59UzuLO0DSY+p3wLQzRrA
   3pbZ9qNDu7lic3WNex1Hv4U6eHh9bRXudkV75G2ho2wQn4IRYDMJzsR/T
   hgoDY4uWU005CMOhmAMUg+Zi2y+awI4YsSMXZJ6epOkGGksCvhfR/LL4I
   B8pmZuLdbrbHIbeV5VQbCooI5axpQQQaO1rln7TKPQLkK6nfQauUZIDWN
   A==;
X-CSE-ConnectionGUID: Ibhr4aU7TfaorhWIe4mgVQ==
X-CSE-MsgGUID: 15gEVNlqTZSMciOz8sVRGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340734"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340734"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:07 -0700
X-CSE-ConnectionGUID: jiPGlhnXQ5e64+TssC2cvQ==
X-CSE-MsgGUID: uqmneGNRRvKs79dscLkGMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852018"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: mld: fix read in wake packet notification handler
Date: Wed, 15 Jul 2026 22:04:26 +0300
Message-Id: <20260715220243.94c526d2c66e.I065a19a9dcc7f45a7457667c0f625fcd2c7bf6b6@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

In iwl_mld_handle_wake_pkt_notif(), expected_size was initialized from
notif->wake_packet_length before the IWL_FW_CHECK that validates the
payload covers sizeof(*notif).

Move the assignment of expected_size to after the size check so that
notif->wake_packet_length is only accessed once the payload length has
been validated.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index c9c0e3c729c9..3b785c53948f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -705,7 +705,7 @@ iwl_mld_handle_wake_pkt_notif(struct iwl_mld *mld,
 {
 	const struct iwl_wowlan_wake_pkt_notif *notif = (void *)pkt->data;
 	u32 actual_size, len = iwl_rx_packet_payload_len(pkt);
-	u32 expected_size = le32_to_cpu(notif->wake_packet_length);
+	u32 expected_size;
 
 	if (IWL_FW_CHECK(mld, len < sizeof(*notif),
 			 "Invalid WoWLAN wake packet notification (expected size=%zu got=%u)\n",
@@ -718,6 +718,7 @@ iwl_mld_handle_wake_pkt_notif(struct iwl_mld *mld,
 			 wowlan_status->wakeup_reasons))
 		return true;
 
+	expected_size = le32_to_cpu(notif->wake_packet_length);
 	actual_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif,
 				     wake_packet);
 
-- 
2.34.1

