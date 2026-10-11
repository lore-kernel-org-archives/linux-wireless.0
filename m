Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3223B433046
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716735; cv=none; b=Qe41rGyK9LObGWr1UMInKsZJQptKTToT5psGyXHWKoa0rWFyBm0MLLQKtfFYoRMpdNyDmLn/OkMHiCuujhI24ZjFzE5b87teNZisCrd4S5CPNPcVlRofNgiFYXakmmmbom5RbWXT+djYrBpW3m96W2KkTFpcww8L2wpeYFqrLKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716735; c=relaxed/simple;
	bh=yu0ES8KBgGZq3UIkBS+38PZ4XV+WgPmMjqLMmoB+qq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AI+kggpcajnP36e2zQJtiTnvDWWahUkuMtpdlN1/aZnkowB/I5teobDoK+TnmWroGMwwZBH2qakeElNhJDX4kCzalOFQiyUGi12+LztEbHpvVNSq39f2BE3v8QRLvqgqkiVsRBWci5QLI/Gh4kQcd8tIbtotKji+N4Hq4C2Rsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQX6iXF3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQX6iXF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716735; x=1823252735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yu0ES8KBgGZq3UIkBS+38PZ4XV+WgPmMjqLMmoB+qq4=;
  b=SQX6iXF3/UyOBen+K37RXA+LCvjlHCxc6cTxxdSRD0fb31MyNirtYZ48
   i5WqfFBLtOHp79nuFc0zUEzlWbsb0EQhUnmiqSU3TyvpvyHgcC/P2cZ4q
   n6OJhUDchQbGxXr7xTb8xpMIm8+JvXnTi0FeB/WhhaBJTIWLwhVxlsmCo
   aws38TO80knZbckQpBFRi16n0THHKjeCDw0m4zr6YnzOrd1WINv7kdtSt
   4bWEBYRo90bsnOh+z7JBKexja9MxR/t9XzQL2vb6X6WLC9LPTvd3R00Ga
   qGm2QAibt8XDPxlFJ5bV4FaV7P4Ug9KCKjGvgwtQPOMHfrUs/+3NzwBJT
   w==;
X-CSE-ConnectionGUID: 5eY/Txs4QqSrN90wMFY1NA==
X-CSE-MsgGUID: 5prAlFmZS4OPFaeJFMKliw==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454184"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454184"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:34 -0700
X-CSE-ConnectionGUID: pNidiz4ZTsqgxqcCD30aXw==
X-CSE-MsgGUID: E37tthBpTTugceq21L/2ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651022"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:32 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 10/13] wifi: iwlwifi: mvm: fix beacon flags compiler warning
Date: Sun, 11 Oct 2026 14:07:11 +0300
Message-Id: <20261011140453.6ea24eaa784d.I91bab31db441f9e230228c3893ff13fd7fc3e7bf@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

With clang we can hit warnings here due to different enum types
on the different sides of the ternary, but we don't really need
to care because they're plain integer variables. Cast them to
avoid the warnings.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 58a77056e607..18372ddcc0e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -932,8 +932,8 @@ u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 	u16 flags = 0;
 
 	if (rate_idx <= IWL_LAST_CCK_RATE)
-		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
-			  : IWL_MAC_BEACON_CCK_V1;
+		flags |= is_new_rate ? (u16)IWL_MAC_BEACON_CCK
+			  : (u16)IWL_MAC_BEACON_CCK_V1;
 
 	if (iwl_fw_lookup_cmd_ver(fw, TX_CMD, 0) > 8)
 		flags |= iwl_mvm_rate_idx_to_fw_idx(fw, rate_idx);
@@ -1109,8 +1109,8 @@ static int iwl_mvm_mac_ctxt_send_beacon_v9(struct iwl_mvm *mvm,
 	if (iwl_mvm_enable_fils(mvm, vif, ctx)) {
 		flags |= iwl_fw_lookup_cmd_ver(mvm->fw, BEACON_TEMPLATE_CMD,
 					       0) > 10 ?
-			IWL_MAC_BEACON_FILS :
-			IWL_MAC_BEACON_FILS_V1;
+			(u16)IWL_MAC_BEACON_FILS :
+			(u16)IWL_MAC_BEACON_FILS_V1;
 		beacon_cmd.short_ssid =
 			cpu_to_le32(~crc32_le(~0, vif->cfg.ssid,
 					      vif->cfg.ssid_len));
-- 
2.34.1

