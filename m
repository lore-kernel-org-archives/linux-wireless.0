Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FFD371042
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2026 20:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867287; cv=none; b=l7IRToEjl/KNXNuIoJ4O4gYDRES7qY9ZB5xY3mPuEGJi1448iBFpaDqXhjEfjxmxc1urEPKVcxoGaLDIVrn2PJKiRkYqKHaFQ4mac5Ra8tP35v/5hklZHKKDGB6K4M+1Dnnf93waU/Ou6GCFvgsjQ9Xar8IYgT4j5UolnJ6le3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867287; c=relaxed/simple;
	bh=ZPHcxYECnEpxWf+JyA8VoMbKlY5OLyLbUHKgkaPO6gQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jt7H4U3I3AqYkOXE5SNP70BVp5Ykikn+PgtZEiDrjOCAxrsyU2vywLk/Y8Fwp5EGncus0LQZ5Owxxw4KtoA+0qRLttNP6gP9BWpl02qw4y7V2QsgJHHKgNST7aS1g9+qQr6C/uX39fg6hWPoMi2pCYS4WyxctfsXrBc7hz4g/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JztbFhOQ; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JztbFhOQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773867285; x=1805403285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZPHcxYECnEpxWf+JyA8VoMbKlY5OLyLbUHKgkaPO6gQ=;
  b=JztbFhOQWtEHUpoumMYq9jVOOcIsLKDvw/WfkSOTdk8exhBaBK4lM9Mw
   Yzd8BNksM8f0U+HEb+OLx02b9yM6HyKbDWZ9bmu8EUn1kuWHYPLIpG0mv
   LyZ9AbG0bZpbrGRWYV5DFKUEW4VO7m+YXvEgfogysFcZmgQrc6GuD2onC
   mknfjtzA9BrFKyr0kPvut2cW4tSKdGCeXKE23HnDboCO+pUzqkCOcEoNV
   o5ddXkOBGLVMIILT+RAeUoLN9KEdUoCJMU8WuX9l+/1ch8wZJGBnh+k9g
   3d0ddCexNVb2mAxvLg8TtnqQsnvR4cXmU9epcpCT4Smmsd8zAhaJpyqB9
   g==;
X-CSE-ConnectionGUID: 92+KaZQ1STOSZyUt+Z8ECw==
X-CSE-MsgGUID: 3x55K4RrRb6VAy8QmazDfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75010009"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="75010009"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:45 -0700
X-CSE-ConnectionGUID: IOz+koEtSzeYfGuiWrG6LQ==
X-CSE-MsgGUID: vLTXVJWAQOGee1rOg0uqCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="222793858"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:44 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: ensure we don't read SAR values past the limit
Date: Wed, 18 Mar 2026 22:54:17 +0200
Message-Id: <20260318225236.99aaf2df072a.I5942590b81324b17e2a369f0c354cafee0f70ef5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260318205430.614577-1-miriam.rachel.korenblit@intel.com>
References: <20260318205430.614577-1-miriam.rachel.korenblit@intel.com>
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

