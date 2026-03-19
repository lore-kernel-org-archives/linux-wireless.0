Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FA3B19CC
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2026 09:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911386; cv=none; b=f6CUOnN35do/0D/jK76TEbXspxPw6QJY3oATJSPMhM1AvxRPkQQ/8IhgpJi45pXP+8VxNvYBG7PbSNi/t/oQEbfRYa0AHz0QXzGXs0dBKtVXfx4acidLyDnvi3DSVBycOoKadLwa/d5qjuXdWwati+az7DR8Ch/+GyBLsAADh/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911386; c=relaxed/simple;
	bh=ZPHcxYECnEpxWf+JyA8VoMbKlY5OLyLbUHKgkaPO6gQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WLL8KyLqRY6eU/ON8lnQi/j+ExeEp2yarCmrK6PaWgNXF1gQj679u+p+qIWkaGyglnerpojJ72PfQAtlbKV4p4curg92YJRWEaPJUq0jlHIgV3CkQM+tTitSTu0K+3Jj2V5+wC0YHWEYTaO0nQQzvFntQxp1z1wLzRNEGkEUAcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EFjFM4NK; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EFjFM4NK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773911383; x=1805447383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZPHcxYECnEpxWf+JyA8VoMbKlY5OLyLbUHKgkaPO6gQ=;
  b=EFjFM4NKoRUv9nCzW/5ik0m7a1LzP894K73boJ2M2ItF1unxdFCnAGUy
   BZkg0GwYBY+rWq/lgQXQAjil3cwEfIZG1suQQoheD0H0rGY8LuRRc7GsH
   Wtr62DPp64R7DVaHH3wfX8k0DPFf0rcTe/+h/keoJv8Hjr8ltuDrRzSxN
   r7+hp7pessRC+B2xSvNIyW5X52onJcfRyDqpSyaQglwM7h6t7lVWM7BJn
   /uaAcf2ff+5uw/2k6aYcsxtRzfSsrPy9dHyXidiIHeiBKn6Tj3n2ShPSy
   /XVkqj1r8w78gjJMYnzPhSMmhY9HI+JPPWeK4bHp1GArcP5F5kZithxnu
   Q==;
X-CSE-ConnectionGUID: CEGI2WlTRHqRdf7+olcJiA==
X-CSE-MsgGUID: T7BmIeYARc6sfP9N3JwddQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="73992697"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="73992697"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 02:09:42 -0700
X-CSE-ConnectionGUID: JmcbmxzuSiSgK90Mw97WhA==
X-CSE-MsgGUID: 9um7lqEYRzCYKYDrY2Wwsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="218387121"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 02:09:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 02/15] wifi: iwlwifi: ensure we don't read SAR values past the limit
Date: Thu, 19 Mar 2026 11:09:14 +0200
Message-Id: <20260319110722.99aaf2df072a.I5942590b81324b17e2a369f0c354cafee0f70ef5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319090927.1090112-1-miriam.rachel.korenblit@intel.com>
References: <20260319090927.1090112-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When we fill the SAR values, we read values from the BIOS store in the
firmware runtime object and write them into the command that we send to
the firmware.
We assumed that the size of the firmware command is not longer than the
BIOS tables. This has been true until now, but this is not really safe.
We will soon have an firmware API change that will increase the size of
the table in the command and we want to make sure that we don't have a
buffer overrun when we read the firmware runtime object.
Add this safety measure.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 958e71a3c958..5793c267daf7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -241,6 +241,10 @@ static int iwl_sar_fill_table(struct iwl_fw_runtime *fwrt,
 	int profs[BIOS_SAR_NUM_CHAINS] = { prof_a, prof_b };
 	int i, j;
 
+	if (WARN_ON_ONCE(n_subbands >
+			 ARRAY_SIZE(fwrt->sar_profiles[0].chains[0].subbands)))
+		return -EINVAL;
+
 	for (i = 0; i < BIOS_SAR_NUM_CHAINS; i++) {
 		struct iwl_sar_profile *prof;
 
-- 
2.34.1

