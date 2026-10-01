Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F094A688D
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860735; cv=none; b=k3AMBJ0fft0Mo0VYW0LUSj/veEndJr6m/MmdluvEekmKoYDzOucbkN7TPnzPGrs9Ke0wC0tUubTAWzUuZbYy0TrmxWq+XqtfiYnNvJ5tFxDSP4q/HIUtG9gLbF5blcSuYgHUAovzoijoQvTNF36uddfk+W8upUb0318N/Opzaio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860735; c=relaxed/simple;
	bh=qoO5wXQBEFrYkyCxdkTEFff4EyMQwFJQzYX0mzi0Cog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FkDri1DGHBUfiQKCBYrZOJcDenvJsWGSXhQyummyufnhSrlEu17QOrD8AbuHI5lsr+pNsTXjm2sQ1kXYKF6olqjbC+IQeoEYNHartkt4UVx54FASgc8TVDM+4RIIqDlyHxPGDcvNa9h7jIhBifFUWFfe0oi+j95I2sgTVsC3MCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L73qgVYG; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L73qgVYG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860732; x=1822396732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qoO5wXQBEFrYkyCxdkTEFff4EyMQwFJQzYX0mzi0Cog=;
  b=L73qgVYGyCh+QBTJU7u982l6fneH4NYsNz9+utwTvNVPDyVkRY1Qo9ca
   QfxKS0iPBzU52oz70I3/FXT+ZUuzHH/tl/QrCt9Xxd03X/+1HMhQ+R7dP
   BAPxz6hEaySO8xW/Tef+Qa36//NCvZz1HfnRNKRmdd8IKRE/Oci0QNd6J
   uYpnr3UmLHpNV81m7qYSwSh1/c06DctTIl1D7TSelxyxPUDYmKm7c8yIG
   z6fDou94FjadUflK/5gLL3NenG4dCVICTKCMqO87azw4aldIazk0CmbYP
   ycLnzcgPfays1Xuq5cOnZLIU30NJbikOJSkdhLVjD5asq6VDgz8E3ePW3
   Q==;
X-CSE-ConnectionGUID: se37lsUPRXyGmYVmoH9Jng==
X-CSE-MsgGUID: 0PLywatWQ7q+qYCTC9DHxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423643"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423643"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:51 -0700
X-CSE-ConnectionGUID: jf3trLcCS/OydxdUXLrKVw==
X-CSE-MsgGUID: pRsaaRCpTQC/Zl6mqHHfOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485566"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:51 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: don't mask ucode_ver in iwl_sar_geo_support()
Date: Thu,  1 Oct 2026 16:20:27 +0300
Message-Id: <20261001161715.5e290d456f51.Ic33c983411e93201e5e05a9d3df5af524de09b9a@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the firmwares used by iwlmvm and iwlmld set
IWL_UCODE_TLV_API_NEW_VERSION. Since iwl_sar_geo_support is not called
by iwldvm, simplify the ucode_ver check.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/regulatory.c    | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index c7de45323935..b6707312c188 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -199,21 +199,22 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 
 bool iwl_sar_geo_support(struct iwl_fw_runtime *fwrt)
 {
+	u32 ucode_ver = fwrt->fw->ucode_ver;
+
 	/*
 	 * The PER_CHAIN_LIMIT_OFFSET_CMD command is not supported on
 	 * earlier firmware versions.  Unfortunately, we don't have a
-	 * TLV API flag to rely on, so rely on the major version which
-	 * is in the first byte of ucode_ver.  This was implemented
-	 * initially on version 38 and then backported to 17.  It was
-	 * also backported to 29, but only for 7265D devices.  The
-	 * intention was to have it in 36 as well, but not all 8000
-	 * family got this feature enabled.  The 8000 family is the
-	 * only one using version 36, so skip this version entirely.
+	 * TLV API flag to rely on, so rely on the ucode version.  This
+	 * was implemented initially on version 38 and then backported
+	 * to 17.  It was also backported to 29, but only for 7265D
+	 * devices.  The intention was to have it in 36 as well, but not
+	 * all 8000 family got this feature enabled.  The 8000 family is
+	 * the only one using version 36, so skip this version entirely.
 	 */
-	return IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) >= 38 ||
-		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 17 &&
+	return ucode_ver >= 38 ||
+		(ucode_ver == 17 &&
 		 fwrt->trans->info.hw_rev != CSR_HW_REV_TYPE_3160) ||
-		(IWL_UCODE_SERIAL(fwrt->fw->ucode_ver) == 29 &&
+		(ucode_ver == 29 &&
 		 ((fwrt->trans->info.hw_rev & CSR_HW_REV_TYPE_MSK) ==
 		  CSR_HW_REV_TYPE_7265D));
 }
-- 
2.34.1

