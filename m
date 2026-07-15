Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F042587F
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142320; cv=none; b=uufejBbNkXzj5tj5Qo2nQs/qQNpg9qPu9ciN6GChewXV3vY8ONgBR07Gll16VgltfxcCh0QMaQPUj6h8i0YtCBceZKA+68BOCDDIi5OiRAgJFAEfAnU6ur11YXOkRKf+dTkwpPe3PYdv/keA2p06z7cOess1dnHwH7QenjM3Vks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142320; c=relaxed/simple;
	bh=Chn3KijgEUjD6VrdOkqxB0qhtcaDSGxEePpooeDJULA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j/NOEpvXv/pBVCgKQO9dc6cfRu+X1mLGSxmf1Znvp84tC6H7GfAirTsmR/W4E8mhKJCcRCv41qcZz9zwZFqtEvRPXfdZ52pgQGF5dRtNRoxCa48RKUcbMWA7FQEtqDUL4g2czvXflSWh06zGGyKB8fQLKOPOLcDrvagrqK8FLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B9TW2yWh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B9TW2yWh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142315; x=1815678315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Chn3KijgEUjD6VrdOkqxB0qhtcaDSGxEePpooeDJULA=;
  b=B9TW2yWhKPqZ4ltwC85DvVKMbVk6E9MBLwpVkshlkES1wWcP3r/a35fF
   f77eghWDf26po3oUxJGLRfBkAKZQ6MmtGG6yZyo9mV7fxN7H1q2aApD/p
   k85ZBcOnII3eiSRdUgS5hxXBX3dht/PUR70csoFv3+uPBsWC6Cv1GLvUz
   tcCMpl6ubi94k/G6VJrt4CbMMSttmXIRCSAm1sheQe9MseHAG2dGxv0x/
   4oNyaRLyggLqf78ortRf7VaXAzg/VOmKCnBEcXShzc2b+QJTofc9w6w4+
   RL+FXMTt0wje2JHLp/JZ3xRmdmwRyaLk+2z4SSfoWu2oyvNZPuiBiFRQD
   A==;
X-CSE-ConnectionGUID: auUDIeHmRSSITPYvSc0yRQ==
X-CSE-MsgGUID: NRvTyqTyR4WrHd4Rjlt5BQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340718"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340718"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:01 -0700
X-CSE-ConnectionGUID: /AhCGcDUSK6VrTP+g9B8Nw==
X-CSE-MsgGUID: M7TgMOYtTkqImOa+9PfwKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851934"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
Date: Wed, 15 Jul 2026 22:04:22 +0300
Message-Id: <20260715220243.355998ec4fbe.I40f3427657b897e911bdf4ebf8e494745508d126@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwl_mvm_frob_txf_key_iter() tracks the last matched byte position
in loop variable 'i'. When a full key match is found (match ==
keylen), 'i' points at the last byte of the matched key. The
memset start offset should therefore be i + 1 - keylen, not
i - keylen; the current code zeroes one byte before the match
and leaves the final key byte un-sanitised.

Fixes: 12d60c1efc29 ("iwlwifi: mvm: scrub key material in firmware dumps")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 6ae9f87d5221..da4c67a91113 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -954,7 +954,7 @@ static void iwl_mvm_frob_txf_key_iter(struct ieee80211_hw *hw,
 		}
 		match++;
 		if (match == keylen) {
-			memset(txf->buf + i - keylen, 0xAA, keylen);
+			memset(txf->buf + i + 1 - keylen, 0xAA, keylen);
 			match = 0;
 		}
 	}
-- 
2.34.1

