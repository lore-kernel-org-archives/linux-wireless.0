Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0016E181334
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784028807; cv=none; b=KLQD5JdFtgdsXfIOO4Qk8g35rX7KSdExH7HCCXu35uFVzU4dxT9fTwLg/qG3/D1+UpzH/Ke+rYp/2wj9uM9A1Vb7ojvt9LQZUF4gNcrFq8NwWOBdO99061SFisC51iiDQuRCIejk8uHi/t197ZC5PwMWB5r0UPhd1raOWhaSL+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784028807; c=relaxed/simple;
	bh=HBu8PlSRn2ZR8PsmR4sfTdOq2xxnJD5YP8it0W0I7hM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TnXbxhNFC2BtRKqcs+XOCRG6vIXwkd7lClSZFk3u1gfWuLjbjzKsap/qPfQPnfjAsKwPgOSVFRpKuE2UhDylPEARQRdcU0FSucHajE+PmaMG1XA2Gq9iI9g0hqaHfogZD5tMEvNp0NxCTUGkeDlAvbtQC6TEbxd2JbJhGA2wxBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHYtxIyi; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHYtxIyi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784028805; x=1815564805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HBu8PlSRn2ZR8PsmR4sfTdOq2xxnJD5YP8it0W0I7hM=;
  b=NHYtxIyispVFMcHA0cK5BgVN5V/VsoeSKxxvC0xUDI0YXog46RHnuOUi
   8LnMYlKcwA+6GOAQiM1wje9wrFoKCYQd1qWZrPz4hWs/nzchYAp9/XB5U
   30nA2WsqckhM0sawLwo57tOkIMo7kHnD8fbrpis8fOhsTVbf2LqlOM4as
   UDsdTGvun1EvWy7P86VMnL7wz8j5SIVzphjNyJDWvTDJ02q/z0Hr4Y5Ba
   9oSOqvE/WR870/E95wSerBo3T9Y+9iDaVTGshfgU2/rvqUrsziRpr/Heu
   Dt96pOvbkJXjl/y2Vqal7tVSTnbWoLFR+EjNXYXrPmNqZxlF5DWMGZeZ7
   w==;
X-CSE-ConnectionGUID: iAFUkuIsRSqr5p8eeyn5JA==
X-CSE-MsgGUID: ftU2fueHTHubQdIIo0uEzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="88469614"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="88469614"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:25 -0700
X-CSE-ConnectionGUID: igaaM1SfQea752qRyAcgDA==
X-CSE-MsgGUID: t9fe7a11RPuOMXN6UWetKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="255883006"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 04:33:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: mvm: cleanup the driver state after device_powered_off
Date: Tue, 14 Jul 2026 14:32:40 +0300
Message-Id: <20260714143119.dc33533ac962.I6d7cca9c4e5643a477eae1d0a4f5fc83a10d0ee7@changeid>
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

If the device was powered off during suspend, we need to reload the
firmware in resume which also means that we need to reconfigure it.

It could be tempting to just set IWL_MVM_STATUS_HW_RESTART_REQUESTED
but that would leave IWL_MVM_STATUS_IN_HW_RESTART set forever since that
recovery is not managed by mac80211.

Just call iwl_mvm_restart_cleanup() from device_powered_off().

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 74bd4038fd56..fd2a50563ab5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1129,7 +1129,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	RCU_INIT_POINTER(mvmvif->deflink.probe_resp_data, NULL);
 }
 
-static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
+void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
 	iwl_mvm_stop_device(mvm);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 979b39314981..d6bed2c08606 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1660,6 +1660,7 @@ void iwl_mvm_hwrate_to_tx_rate(u32 rate_n_flags,
 u8 iwl_mvm_rate_idx_to_fw_idx(const struct iwl_fw *fw, int rate_idx);
 u8 iwl_mvm_mac80211_ac_to_ucode_ac(enum ieee80211_ac_numbers ac);
 bool iwl_mvm_is_nic_ack_enabled(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm);
 
 static inline void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 09150feb330d..6ae9f87d5221 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -2091,7 +2091,7 @@ static void iwl_op_mode_mvm_device_powered_off(struct iwl_op_mode *op_mode)
 
 	mutex_lock(&mvm->mutex);
 	clear_bit(IWL_MVM_STATUS_IN_D3, &mvm->status);
-	iwl_mvm_stop_device(mvm);
+	iwl_mvm_restart_cleanup(mvm);
 	mvm->fast_resume = false;
 	mutex_unlock(&mvm->mutex);
 }
-- 
2.34.1

