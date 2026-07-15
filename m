Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97D41A572
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141885; cv=none; b=LCJcBFPRtLcGBvGHdvoqPHwIx19xbXJvkgDUx14srLx8fxeZ8JNO6vh0w4FcBDFrFuWycBmZAj3UsGqHnxcWeUVDy1WantKgOxehFCL/m2pFeYn6uUxUjDD8c/ArbVWekw6GnKHhmqQdCDQ7t5iKRh441mdECji9M3Yo8toLdQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141885; c=relaxed/simple;
	bh=3YABt4p+WukkJrcSDR1ISL1tgt86m+ZFp4zt8gxzc7w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IT54fGyrGJJAX3GZGwuL/H1Gykku7vgtB94wfxer1hqQ/+GLTZIhKyCa4VyDc9s0it4LuKDe+98ambzNYN+4V6rsS4NsfJhTCwTMBvFP9lCgH/rw054+0m7wWXRum6t4YVinMDKj3JGDtEQj2FPyzIlAyKm8+t5mW3jOaOTp+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PtPTLvMi; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PtPTLvMi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141882; x=1815677882;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3YABt4p+WukkJrcSDR1ISL1tgt86m+ZFp4zt8gxzc7w=;
  b=PtPTLvMitWeP5U1FiSlVSgAGlPIDRLlp5C5h5gs7c4itvq7D93qXtJMQ
   I2+d80qXrroWOqbtwBPwGt278SZR/zdL5Kj+4Ef1ZmreznaDFRdpiGDhD
   87sYk/MsL8CXH5oNNMg3xBDPwQIPa5YhGFbvMuUmqRknOlczXtjfnq0vK
   OGASVQDJY4Z7bC1v/cvWbq1S1ZKaT30aabXZS3llvAXigOgafINVXqRT7
   AEdGKZx5pBX6GRO5KNt5mOfZDcjTtB4OBTDfSB8JQaxy5kiGTHOViGWPe
   MTEcPwOWt3oYdJ0Ddgcnb0FMMO8V6TASM1aVV/T6TlebOC3hxwH6Q9I1w
   w==;
X-CSE-ConnectionGUID: aFR0XGVdQ0ywbgMfe07JWg==
X-CSE-MsgGUID: 7Ydhw3TGTg+Jq0vFrdgZgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160905"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160905"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:49 -0700
X-CSE-ConnectionGUID: NcU1UGVER4Kl4M0mMVfOUQ==
X-CSE-MsgGUID: HjehJwgLSCWcTO2wxb65pQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-fixes 08/15] wifi: iwlwifi: mvm: fix read in wake packet notification handler
Date: Wed, 15 Jul 2026 21:57:08 +0300
Message-Id: <20260715215523.99d5cf85a528.Ic4aa736011d4fe88e0cd19723d1d48bb24642198@changeid>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

In iwl_mvm_wowlan_store_wake_pkt(), packet_len was initialized from
notif->wake_packet_length before the explicit check that len >=
sizeof(*notif).

Move the assignment of packet_len to after the size check so that
notif->wake_packet_length is only accessed once the payload length
has been validated.

Fixes: 219ed58feda9 ("wifi: iwlwifi: mvm: Add support for wowlan wake packet notification")
Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 3429d9a10e42..4eaba0bc4a1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2756,7 +2756,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 					 struct iwl_wowlan_status_data *status,
 					 u32 len)
 {
-	u32 data_size, packet_len = le32_to_cpu(notif->wake_packet_length);
+	u32 data_size, packet_len;
 
 	if (len < sizeof(*notif)) {
 		IWL_ERR(mvm, "Invalid WoWLAN wake packet notification!\n");
@@ -2775,6 +2775,7 @@ static int iwl_mvm_wowlan_store_wake_pkt(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
+	packet_len = le32_to_cpu(notif->wake_packet_length);
 	data_size = len - offsetof(struct iwl_wowlan_wake_pkt_notif, wake_packet);
 
 	/* data_size got the padding from the notification, remove it. */
-- 
2.34.1

