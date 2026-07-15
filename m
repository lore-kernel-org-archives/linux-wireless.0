Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EEB43F08E
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141876; cv=none; b=AgJwp2s+3GpZYCw/Xj8H+UVbt4/mtFrq5y0GOgUNfIIkM6KTReGnHHPcBPOKgqEN2XFs2BfkBHpM++twY6r4KqlYXlpHBHqwOqV6Pv0nLmgBi1hRNUkgQN7kIwDslOTtLJad/7+QqJIp0ko4rmNWZCzPND1JJ8YSohmV4QrbHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141876; c=relaxed/simple;
	bh=dGHIPAnfV6OX0kvUpmzceo+8MAlH0Ii6sasbq/Hd6Z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pjnzM5YUrY93fGNOysOB1EQhOmn/Hp3zERjJEi2gi9szHKZ0/qogSTiPEz/rKi1x7X+b33A/ZEH258EZAw1m6oge+QTymSmOThVp/mjgdHYe6QCeLUeB1Roi5G7i/8F3zSS2T8XZ8Lt2lBJY6JPG2bmX5oPizJQydihDInMWjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WYO308Z+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WYO308Z+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141870; x=1815677870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dGHIPAnfV6OX0kvUpmzceo+8MAlH0Ii6sasbq/Hd6Z4=;
  b=WYO308Z+Lsp+VJRp9Da7x5QSd3ai8YJ11WhbVak9nvHeWFtCdDJhkx08
   twHvGitSH4GOSdedxYUR7ip3uaMylAODfnh6N/ZjscPrl6BMnyKoam5j/
   x4jEpnlldtYcPXVankIsa2NJsake/7HecFDy765YFLhbwUMcIqFSrFOM/
   XQnjRSvjIsx2DOtb2CsvwOklPnX3cXeg46pipkCsLqeGmprEvUclAQONb
   vIigwD5M48Dxu/HEW1O7ZX6ZErAy4rs7UoAWLJU/CCexyte9JW87TSraD
   ASxgoZbXtHKFwgPqGc4EeWln6BiLoY8BuHYoGl+XpON1z38ajgw8ZO5I4
   g==;
X-CSE-ConnectionGUID: EGM60N6XTE+eunDM9j5sZQ==
X-CSE-MsgGUID: /TcHqiH4TkOUp2Qf3TZmsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160894"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160894"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:43 -0700
X-CSE-ConnectionGUID: bnMPmQCpSNKWMvPD1hm3Ww==
X-CSE-MsgGUID: oRau93NHSliw5svkz2cVKA==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:42 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-fixes 04/15] wifi: iwlwifi: mvm: validate SAR GEO response payload size
Date: Wed, 15 Jul 2026 21:57:04 +0300
Message-Id: <20260715215523.7e749b7d374a.I4ef54548bff6c6e7c7a57bee771ac12508aad677@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

The SAR GEO command response is cast to
iwl_geo_tx_power_profiles_resp without verifying the payload length.
A malformed or unexpected firmware response can lead to reading an
invalid structure layout.

Add an explicit size check before accessing the response data and
return -EIO when the payload size is wrong.

Fixes: f604324eefec ("iwlwifi: remove iwl_validate_sar_geo_profile() export")
Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6e507d6dcdd2..fa523be91d8a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -964,12 +964,22 @@ int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
 		return ret;
 	}
 
+	if (IWL_FW_CHECK(mvm,
+			 iwl_rx_packet_payload_len(cmd.resp_pkt) !=
+			 sizeof(*resp),
+			 "Wrong size for iwl_geo_tx_power_profiles_resp: %d\n",
+			 iwl_rx_packet_payload_len(cmd.resp_pkt))) {
+		ret = -EIO;
+		goto out;
+	}
+
 	resp = (void *)cmd.resp_pkt->data;
 	ret = le32_to_cpu(resp->profile_idx);
 
 	if (WARN_ON(ret > BIOS_GEO_MAX_PROFILE_NUM))
 		ret = -EIO;
 
+out:
 	iwl_free_resp(&cmd);
 	return ret;
 }
-- 
2.34.1

