Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90615012AB
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860727; cv=none; b=LDHav+yrInC17DF46E5rLDc+sXkpDrSpPdFEWpzFdagJcKY1s4J3hEG4HVas5HekLoCGDRH5hnuB9Tm7dILXGiT/VbsRu4LDyXaPEJYeABAgb1QE1BKvOoavBUIb/R49QGtpBTHxhfiXp1r7+OpJHJ/A7hAm7po8pv3MNiHI/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860727; c=relaxed/simple;
	bh=TpJsQBGdAtzhdISeaUPhCruqX34+QGwb7am7ykPm32Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+5F+4HpaRsZSy+C461bxUPL1P4mx17L7YpD+Ced1hIzwXliKHVHn3RrKnvBKv+JDxuRwmyphRZhKsTh/0zG7hZMrbHVtCBHXTl1vf/hSuaLzT1XICIzgDWGOfjtO2e+/CyGCOPEJcltz5LEHy2FglOJxucZcYtVDJ4PDuykufk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ff6w9Sxt; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ff6w9Sxt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860725; x=1822396725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TpJsQBGdAtzhdISeaUPhCruqX34+QGwb7am7ykPm32Q=;
  b=ff6w9Sxt0cZIVDaYDf3bNYUqR/XmdhHZDlIBmW5eoVTe9vRNHYGPLEgK
   z1E4OsPhUBsy8zyXtn6r9zCMwi9/yZ8Hp7lnKGFjpOYKvc8BGZcDRNIQq
   Cgblfzv+/XbTDNKIkVX/WZJKY9AlrxLqyqw9/S1TgyuI8a0dwUqUbC2ny
   9ZivPUw/mwTNItO4LOkEBqUljXyAa2fE8hYBW65BbFpd8owh++2DcNkp/
   yCVGDy2bU16jFhP6otAFzeC0f+v2rq6cF+Qp5xph5W8xM1k48qrP1mgH4
   4x/bCJOucfvFr4nh+ZMv0fKvgjgL+ClNsSyOioCaD2PzA/1xiSh+ZAO40
   A==;
X-CSE-ConnectionGUID: HKEqiaSpQgyupLDuH8fWWQ==
X-CSE-MsgGUID: bRExBV4aRHSQPUJTmMyaXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423633"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423633"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:44 -0700
X-CSE-ConnectionGUID: DJXhoh2zRbug7WZbqVl3mg==
X-CSE-MsgGUID: uZI63UXOSW6P49KF4zhdKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485546"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:43 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH iwlwifi-next 09/15] wifi: iwlwifi: mld: detect UHR sounding packets
Date: Thu,  1 Oct 2026 16:20:22 +0300
Message-Id: <20261001161715.1c6817d2205b.Icc0cb8f2ef738bba6105f7b909c47d6d0cf12491@changeid>
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

From: Johannes Berg <johannes.berg@intel.com>

Detect UHR sounding packets by checking their data length just like
for EHT and reporting them to the sniffer immediately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 076c4fd6f37c..c0203e74fff6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -2996,6 +2996,13 @@ void iwl_mld_handle_phy_air_sniffer_notif(struct iwl_mld *mld,
 			 !le32_get_bits(ntfy->sigs.eht.sig2,
 					OFDM_RX_FRAME_EHT_NUM_OF_DATA_SYM);
 		break;
+	case RATE_MCS_MOD_TYPE_UHR:
+		if (he_type == RATE_MCS_HE_TYPE_TRIG ||
+		    he_type == RATE_MCS_HE_TYPE_UHR_ELR)
+			break;
+		is_ndp = !le32_get_bits(ntfy->sigs.uhr.sig2,
+					OFDM_RX_UHR_NUM_OF_DATA_SYM);
+		break;
 	}
 
 	if (ntfy->status != IWL_SNIF_STAT_PLCP_RX_OK || is_ndp) {
-- 
2.34.1

