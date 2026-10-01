Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6868D4AF169
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860723; cv=none; b=uMec2WBiY2ddJhqWcEqjtkwJUsUfL6ZlKt4oHSYqsG8d7IB3yE8iraVoiPccV6rDBMaZEVZWm7sUnda2TVjoZC30mRcVCx4fI6FtZJV6fOwz3YXdrN4DkiNQ4QlDjDHZc3afPOV5443d/rrtvjPpIL/Lzd2YyRXmqaaTsM8djs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860723; c=relaxed/simple;
	bh=5Ly8KEnwI2l7Syi782Chmf196tXc/cHY1UiwQgQryVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PpYwCsocFy9VM9VJG9f0vOnEHtuQ1i07tFuDqFeH0v6g9RG31YpZfDn4xDoTto9UNN7i9AMjlK0jiL4fc1/vtSKpXV5xZoUK1Q3Iz/LPo2urOxcWltNaiFuedd6xTdkqA6IadJ2X3COQokTlHmqezk1XkNh39bM9X47vAG3YnKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ri0emOC0; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ri0emOC0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860720; x=1822396720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Ly8KEnwI2l7Syi782Chmf196tXc/cHY1UiwQgQryVI=;
  b=Ri0emOC0zdPdggCsN2w/bAArsWKL7pocq5j/0n2QkvR/RYlcGVA+gIlT
   u3JHcrwlnEIqOxfjt3O47vI4HAborWrmJLPBP4SuWPBIkO//5W3hKF3uJ
   rhKEdah+iBR2OdhCCTB+eRccbRylfdNM0epUIHlvHFR6nobmHb6rQ4+MC
   TlaGUR1A13H2LOeSarY+EK+vmi7DBVH/ZqR1eUy4SUbQXLaod3cM/hF5g
   6klydIcrH7IkXcOOg3FGNmvt+ahAuQa80zM8CJa2iOBJTLvJVfh3Ps4eS
   WBUCoHADVM6SsRPk7NSWtFuTt4HCKF9afvtmLMFxBjDFJec1uXn5WNnap
   A==;
X-CSE-ConnectionGUID: UswB6DiMQSecclb7GlfC4Q==
X-CSE-MsgGUID: iViSNJrgSdmmnTZ4z3rf/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423628"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423628"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:40 -0700
X-CSE-ConnectionGUID: dKOPzfWTSSilLaD1l/FxIQ==
X-CSE-MsgGUID: TuxxnRWJQB2AwMX43bCAnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485529"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: mld: report beamforming in UHR sniffer
Date: Thu,  1 Oct 2026 16:20:19 +0300
Message-Id: <20261001161715.3f8de2b3592b.Ie21d26e1a25a117515907e9577a51de3bc29692b@changeid>
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

In per-user information for UHR sniffer, report whether or
not beamforming was used, according to rate_n_flags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index e59f33c39a57..738b6fb9770f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1842,6 +1842,7 @@ static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 		uhr->user[0].known |=
 			cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_MCS |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_NSS |
+				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_BF |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_2X_LDPC |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_CODING |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_USER_CAPTURED);
@@ -1859,6 +1860,10 @@ static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 			uhr->user[0].info |=
 				cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_2X_LDPC);
 
+		if (rate_n_flags & RATE_MCS_BF_MSK)
+			uhr->user[0].info |=
+				cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_BF);
+
 		if (rate_n_flags & RATE_MCS_LDPC_MSK)
 			uhr->user[0].info |=
 				cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_CODING);
-- 
2.34.1

