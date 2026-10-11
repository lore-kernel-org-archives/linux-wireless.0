Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A2437852
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716729; cv=none; b=GCpxUU5N6lc90j65mgHBp5ICNpPl1hmuVcUKE951G4vzPlxNX8fUJWGXie3h48IxxbYWjo/k3WmFK4Z9Hs5m9T0Ge5gqNyjpjpGCCu7oG7QOaeTgadgONUK5rgmzu7poJd+AYtOzsoWleU0bB8YvKMs70owLPuincSKVyM0co/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716729; c=relaxed/simple;
	bh=wLzocw6DKOazBdI1s/IAB47duWtxJMS3ophLmADfVjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OhXdHJkaoHb6i2ZQoTLrJOnTdXbN/c6/VOMOglEZVTZqXTv31ooIy/HvSLHLO5P+EP/ZZQBTQ5rNiccG+oxQEuqgPROAOVTeyk94i55dG2FlwNN+LhekpfZKTQVVAgqPrgHLGmUy/huRfojw16L7EHbLs8UjQXCtHhxciE1mYT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZSdiXpd; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZSdiXpd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716729; x=1823252729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wLzocw6DKOazBdI1s/IAB47duWtxJMS3ophLmADfVjo=;
  b=cZSdiXpdyXJ/s+ZjYeuAAKFU5BEwrOrSkb4Rbf50qNwCMRbwrNECrPxk
   QaGvSFE7BXThWtjF+73WFp55KAkp/zwzWUJiTbMDE+0FRMNH1drzwDszI
   ftM2NXeeupO81h4yh0DpcE9raHDKr02+yd5Im6BxOHH2oFgwDOuAkCu+T
   PNgiunYAC5spk+ks34CT+jIIKh2wJpj4JPlgN6kk4sb2oWzGwdioonuK8
   Uy5qCdMAhcmW82/Qs01LJGOFiFeziVMLw5kz74Z8Elxy5xlANaT4rVpnh
   uiAiNs//c6z0+LXHMK3CGpiNXfmtpNQzljX7EuDX1ipFAhOVMh/VgE4Dd
   Q==;
X-CSE-ConnectionGUID: d9atikXAS3WVrgTXsJu0fQ==
X-CSE-MsgGUID: Bx3oF0j5TTi5OdestTbHRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454176"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454176"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:28 -0700
X-CSE-ConnectionGUID: zyTKIBWgSM+KRE0GS145Jw==
X-CSE-MsgGUID: +waZrIhMRi66qF0ulfuU6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="650988"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:26 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 06/13] wifi: iwlwifi: mvm: remove dead sta check in rx_monitor_no_data
Date: Sun, 11 Oct 2026 14:07:07 +0300
Message-Id: <20261011140453.2d0a56daefed.I2bd50c74f1f50e0fd87996333b804d2731dbd0fa@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

sta is never assigned in iwl_mvm_rx_monitor_no_data(), so the
sta ? &sta->deflink : NULL expression is dead code. Drop the variable
and pass NULL directly. Drop the unneeded RCU read lock,
ieee80211_rx_napi() takes the RCU read lock on its own.
Spotted by Coverity.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c01c704929ba..77a3d8dcab57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2427,7 +2427,6 @@ void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_no_data_ver_3 *desc = (void *)pkt->data;
 	u32 rssi;
-	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
 	struct iwl_mvm_rx_phy_data phy_data;
 	u32 format;
@@ -2541,9 +2540,7 @@ void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
 				      RX_NO_DATA_RX_VEC2_EHT_NSTS_MSK) + 1;
 	}
 
-	rcu_read_lock();
-	ieee80211_rx_napi(mvm->hw, sta ? &sta->deflink : NULL, skb, napi);
-	rcu_read_unlock();
+	ieee80211_rx_napi(mvm->hw, NULL, skb, napi);
 }
 
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
-- 
2.34.1

