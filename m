Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE442A150
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784298701; cv=none; b=bEdRMWJziYOjFzIRosKcj7Wm/AQjCr87sB4T75bItlQXxMuMzygAyxDYaD845rWF5YRIp8RVkOe+zazGsYct89V1NrHZcNlaT1aiPmKEAQ3sAfYwTvx4l62F2wClPlMx0APycl5AP+0/hu+qPeIIhd2/9KKfGZyM6iTemlOUjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784298701; c=relaxed/simple;
	bh=g0Km5QhBPRCGOnlcW8uyx7+42A5OqXH71XhbWofQT7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WpvsQZRQEDe4abRp8R/Oo+JulzFYzUqozm01sck8TeIlhKxyVzyu3T8NSWCvGtVvTMrKb98kUtEv4Lc5k4CpzPG28CnfRn4Bxhf3RExsAbAp+XUHYRM6IJ9PLxOBF5i+BMgt8E8QKNbrRckcwk8G6CFBQ9VWqfpSIsgfj7bcyV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAQvZPyD; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAQvZPyD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784298700; x=1815834700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0Km5QhBPRCGOnlcW8uyx7+42A5OqXH71XhbWofQT7Y=;
  b=aAQvZPyDtylGcmXh5acI9BdxdIWGfHZ9aj9IVssCkjUBqzVb+ZwgkUqW
   k73X9N0byAvGY8EdsBP6A1vkFS9UUjqRR9CjxZ/F9uTgT6Q30aeSEddZu
   SE5N62savK7jIV5rE+7sjeskAFFD3eod59I1Ncq+tOYlQy+bsEywn2TlI
   fMCBJZ4qbXBuH3kPw0Y/TDqZiiu6MpADagAmuIh25OW5b9UsE6Q2jNaHL
   +nnbKP5H6zjNCImHsAunSoQEzH7eJS3dPWwxGl29CaSa9weD60cuA2676
   tqf+CcAmruOP/p9diGTzFMA5gvd//RhcjA6WuSf67U4j4URDOwoHpXEIx
   g==;
X-CSE-ConnectionGUID: zU3rpX7ZSbWg9b+yjwV9xg==
X-CSE-MsgGUID: 237K20XiSveEP7/qs3tQpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="84925983"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="84925983"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:40 -0700
X-CSE-ConnectionGUID: DMkX2Up7TDCiDmexCfKliw==
X-CSE-MsgGUID: C7XDllKoTjCUf04kQBIMCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256885729"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:31:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 3/8] wifi: iwlwifi: mvm: ignore sync frames when sync is disabled
Date: Fri, 17 Jul 2026 17:31:07 +0300
Message-Id: <20260717172958.ac73ee199a25.Ic1489244f9b02da93060f0a0e5b300a73527f265@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Gate time-sync frame interception on the active flag so frames are not
queued after time-sync teardown.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
index 2cfd0fb5e781..7bdbacb64078 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __TIME_SYNC_H__
 #define __TIME_SYNC_H__
@@ -19,6 +20,9 @@ int iwl_mvm_time_sync_config(struct iwl_mvm *mvm, const u8 *addr,
 static inline
 bool iwl_mvm_time_sync_frame(struct iwl_mvm *mvm, struct sk_buff *skb, u8 *addr)
 {
+	if (!mvm->time_sync.active)
+		return false;
+
 	if (ether_addr_equal(mvm->time_sync.peer_addr, addr) &&
 	    (ieee80211_is_timing_measurement(skb) || ieee80211_is_ftm(skb))) {
 		skb_queue_tail(&mvm->time_sync.frame_list, skb);
-- 
2.34.1

