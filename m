Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCF4425899
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141894; cv=none; b=MXoJtHv/Oe5B9TCg5LxwvslTJcfVouIf1njGf6zqwF6pGV51DPl2KEpePoiRQ8vJL6EnvH+AkFXDZmk9pPxAHV8guiva9wMxOk9V60spwxxgZ55jyquAzupQtzI0QlwvTH00gSGwjN4TNzWE9YJW08bl3929qU0QE2a60ICaz0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141894; c=relaxed/simple;
	bh=olTH6GCwomYaR+KEBAhpxk843jgJOE3D41FGWj3xetA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=leWzFaQEOceLGwoBcvUsLdC7025nFfwyfMAs3TSOjDyh3k/7ZJb5ezRtGQKrBf+mRmQdml+C56wCOyzgqjiSg5tdvD9exLMGf5eXK+N9dsKN7a8eqOP17rVt2FaOctA4GvM87D1J8sveDJUVjrqPG3T1NNC4zf4cBRcX+h1dUcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZUsctLS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZUsctLS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141887; x=1815677887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=olTH6GCwomYaR+KEBAhpxk843jgJOE3D41FGWj3xetA=;
  b=OZUsctLSxWdw6W2sZK+zaEkV8JnKXXqkFsgCmAHK4Qpyi0XOI4h+osaR
   x0oFQpx79wQtplfcPP6zY8/zArpJwn12k3izZ0NAAVFsduPXwsB85mqU5
   fJJyxX9vwRkiQCju1KFQEsC6ySVtu6NpSYbZREg9mfFKLXVwgRXXf1I66
   ret8n3nFDcTAEDCLJL4vYvJletqdLHzMlQJYJiIXkVVfeK+Mlk5TyNckr
   We6kYcB1qxA8JkmWVL9juLGzKmZ9wYUT249DvbXMncoRScURhSv8Q8m9F
   m0/uTmnJjiVgi4TVxWbm0jzaKx47u09rKpMRANutOm4pGO/kbSIdhf+tU
   A==;
X-CSE-ConnectionGUID: GKCh38rEQLqkK7l3wTtt4Q==
X-CSE-MsgGUID: uv8mqPmdSe2zn4mN7yYmTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160917"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160917"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:54 -0700
X-CSE-ConnectionGUID: q/rWws7LRWKSPwq3LrfGYA==
X-CSE-MsgGUID: Cr4fIeadTum5CHdSm0krfw==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:53 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 11/15] wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
Date: Wed, 15 Jul 2026 21:57:11 +0300
Message-Id: <20260715215523.919edee567eb.Ie85c350e3afe2b39709d0039072740d86660f8ae@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

mvmsta->tid_data was indexed by the TFD loop counter 'i' instead of
the actual TID value 'tid'. This writes lq_color into a random tid_data
slot unrelated to the BA entry.
Since multi-TID blockack is not really in use, 'i' was always 0 and no
harm was done.
Add a out-of-bound check before accessing the array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index d8b088e7c250..e02c376296c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2134,8 +2134,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			if (tid == IWL_MGMT_TID)
 				tid = IWL_MAX_TID_COUNT;
 
+			if (IWL_FW_CHECK(mvm, tid >=
+					 ARRAY_SIZE(mvmsta->tid_data),
+					 "invalid TID %d in compressed BA\n",
+					 tid))
+				continue;
+
 			if (mvmsta)
-				mvmsta->tid_data[i].lq_color = lq_color;
+				mvmsta->tid_data[tid].lq_color = lq_color;
 
 			iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
-- 
2.34.1

