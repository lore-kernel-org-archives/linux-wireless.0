Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255E6457E4E
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754892; cv=none; b=Hu3I/i15mnpajm83XkMBkpw6aZeBDP+Ugh7VP5E23IqkeOMJdbxLtLq25/86VAwiF0fMJ177TrrnQ1JAgGNsKp56/XtRWIni8XJuecGg2std0EymzSlIaGP98DopkSlO8PeafYQnf5O7LZmY/mX2FSR5+IzexpX/vGn7EjcyGq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754892; c=relaxed/simple;
	bh=3GftMHPVlyZBoDIDr2pcqILa2F1/w1uu/2VVKhKqLwk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kSOmBx5oUZsJm3fKaKpRnH3SBESrcN+Jj8EHFAOuUsmQX+NjaKtF+gjDM8Gt75Rdw52pwru0yLLTXeN8aC6pjb2AlfX61l0/tZypJjwQotg3tg9i9eDoKTqiVa22JzY9h/741EQB6GaKCxmaUyOTLh6emJ7xL3PvIlQrR16/Vp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XAkbjEct; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XAkbjEct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754891; x=1822290891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3GftMHPVlyZBoDIDr2pcqILa2F1/w1uu/2VVKhKqLwk=;
  b=XAkbjEctLAltZeLLMi8+Jq3fbbeNbtVbdRuoloEWV4Eq+JIPAf25ktJf
   vyjPOZI//vEnyZVdA6PlZkmRRUabbJWyWE5AnUfd112JY7xz7R+LiYHA3
   70LAkuAbPYAP+uIGPHBJCVJWD4fpdx/1oJ1U0+v7mx4kptToVM+Kp1YPy
   FCl9fPn8DaSPWSnncykLTze7ygmk59JDOzEOu1WGz6UkCLSIVtXL+CdQA
   BnX4PqLQSABjMfpKgVecWZVncet05TN0703o8ad9CM+O86+yFVq8Ri5NJ
   GU2lQxZN+0q1SYeqVafzyf561eOgJgIgkWzM9WDZ0engXSCZfWGI1q1tZ
   Q==;
X-CSE-ConnectionGUID: y/Kkr4H8TWmhmm1J7SSnkA==
X-CSE-MsgGUID: 2wVTB6SzR9m6Gb6q9XDT1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296817"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296817"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:51 -0700
X-CSE-ConnectionGUID: yTRlOpfYQEOm5SCsb2oflQ==
X-CSE-MsgGUID: mGyXGhUhT+O1V5IsXHSgSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962913"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: mld: fake a valid NSS field when needed
Date: Wed, 30 Sep 2026 10:56:31 +0300
Message-Id: <20260930104824.820a1624928b.Ib41003bd4e10f0fe6d7f4aa1038291be330c3175@changeid>
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

We hit a WARNING in mac80211 in sniffer that complains that
rx_status->nss is 0. This happens on frames that the firmware doesn't
really understand and when that happens, somehow the STBC bit is set.
The driver divides the number of antennas by 2 to get the NSS with STBC
set because each stream requires 2 antennas. Since NSTS=1, NSS end up
being 0.

Since we don't have devices with more than 2 antennas, just consider
that when we receive STBC traffic, we have one spatial stream.

Since this problem has been seen on HE traffic only, don't apply this
logic on VHT / HT code paths.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 5f18aa551af5..8fa438fd7815 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -553,7 +553,10 @@ iwl_mld_decode_he_tb_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 
 	nsts = le32_get_bits(phy_data->ntfy->sigs.he_tb.tb_rx1,
 			     OFDM_UCODE_TRIG_BASE_RX_NSTS) + 1;
-	rx_status->nss = nsts >> !!(rate_n_flags & RATE_MCS_STBC_MSK);
+
+	rx_status->nss = nsts;
+	if (rate_n_flags & RATE_MCS_STBC_MSK)
+		rx_status->nss = 1;
 }
 
 static void
@@ -589,7 +592,9 @@ iwl_mld_decode_he_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 		break;
 	}
 
-	rx_status->nss = nsts >> !!(rate_n_flags & RATE_MCS_STBC_MSK);
+	rx_status->nss = nsts;
+	if (rate_n_flags & RATE_MCS_STBC_MSK)
+		rx_status->nss = 1;
 
 	he->data1 |= cpu_to_le16(IEEE80211_RADIOTAP_HE_DATA1_LDPC_XSYMSEG_KNOWN |
 				 IEEE80211_RADIOTAP_HE_DATA1_DOPPLER_KNOWN);
-- 
2.34.1

