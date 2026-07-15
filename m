Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05A442FBD
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142324; cv=none; b=RFDPjnp4uiloREJJ0czybX/lHnDJadkku8NnR1LR/81ErN2a1aKvwXl+mn6v4HE0AucbU8W+EJ/NbtoHLx0tbKfBbRM0ktGEh0qxjrhk3jTlWV1oY3qMsATYitAxyK7IXR3rBLrATe7lrSIZVWFcttMVDZhTSOBiT9bcc4ZlA10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142324; c=relaxed/simple;
	bh=enjgm52n+y/DqETd3amWR7xkLsq7U6EB/Qf4d4z4NFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H+o0r4VGqeX05+7ZaTsu5fp/hiTFg+ps9vjMxLfMqOAgoMu6dwQeFrZRYAIuIqzkU428UZ1IlNqrBjsWaSs2fUyypALCpWZFqDZt3LqdoPD+ZgDs6Dl06+TF2MNRdRYP8JinaVS57LQm6D0lfHkwcOAjqUKSIYmmiyuIitpCvmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EcH14dCp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EcH14dCp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142312; x=1815678312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enjgm52n+y/DqETd3amWR7xkLsq7U6EB/Qf4d4z4NFo=;
  b=EcH14dCp4zgPnSFu7/ZHMfavtYWOnVSZbTxbRiWFqpljwuQnTOkk4P5p
   uQrsi98ckT+wlP05uWxNdIrR3DkqQUIDw8zDuW8lTIFaZFoHrY6IHjUTd
   3/D8rr3ryXglvS8Vd/MB+G18MImAZ/btVDcZlg1oeZcET1ek6/b5c904E
   B4obDl28K+ojcLlwXb74gB0/7vwUl3ceXZHEu/kLO/aM27u1wNHT5XP3l
   MAFtZ1NoPKf/6IDvkG4tjlhKJFCHQ6VuvMGmavhUhBmMmMWVMySSLQeno
   C+e9XB4YR12lN6J5Ar1s/NEGGAglOEQoVvxdRXJ8KytL5JvphE/3+EA58
   w==;
X-CSE-ConnectionGUID: Uz/Ie1gARl+bLNwBfxfiJQ==
X-CSE-MsgGUID: YX4VpgAOTsu/NjX2r3ecZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340705"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340705"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:58 -0700
X-CSE-ConnectionGUID: T8XH6fq8TSWRDYrxYxPxBQ==
X-CSE-MsgGUID: zyvDKcf0StOwJPv/p+vPqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251851914"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:04:57 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
Date: Wed, 15 Jul 2026 22:04:20 +0300
Message-Id: <20260715220243.a61c65f34e87.Ie5f1a7ca43e0cc5a0ddc8305b0448ddffc09cd18@changeid>
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

The loop counter 'count' was declared as u8 while num_pc is u32.
If firmware advertises more than 255 PC entries the counter wraps
back to zero and the loop never terminates potentially causing an
infinite loop or reading past the allocated pc_data array.

Change the declaration to u32 to match num_pc.

Fixes: 2b69d242e29b ("wifi: iwlwifi: fw: print PC register value instead of address")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index c2af66899a78..bbbf3669a555 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -369,7 +369,7 @@ static void iwl_fwrt_dump_fseq_regs(struct iwl_fw_runtime *fwrt)
 void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_pc_data *pc_data;
-	u8 count;
+	u32 count;
 
 	if (!iwl_trans_device_enabled(fwrt->trans)) {
 		IWL_ERR(fwrt,
-- 
2.34.1

