Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0628A521880
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168604; cv=none; b=cSpVfqwpqMDSX7ilDhMqDtfphzkil9RHWbVC5YgfBUPRKR38uz3wtEyamjezpZaA7OUFjiYSayYzaq5cRpQqG+pW/6AVpTl9UC+Hty/zELoQRUnwNBbLwpq0H7Lod/Pm6sn9AQOBz50NfpUc0y2cVO1aDaM96Eh1XCcyp1zPTj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168604; c=relaxed/simple;
	bh=8x/vld9dgRtlecIZqnWa2V5wCShwTEcbZSxTMh7JrYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cVBIM9WfErWuuwybOvtuSwLEyv+fX+Nvmx3MBpuBxMGQU6Ob2ZK27k9EwTSInFL6iTFj+WWRV/ZL++HRRNoTs0zU7HZ1k/Hc3AGLk/R22lcQ4zYpmVSEFvCzzLwSWm4myuilgPUr/pbocFaNsK14ALsuXMlZCEAzgIkJvYyYvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sm4WCzKg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sm4WCzKg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168602; x=1821704602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8x/vld9dgRtlecIZqnWa2V5wCShwTEcbZSxTMh7JrYI=;
  b=Sm4WCzKg2h1D/YWfMT5ED4R7jNTX0+j/ITjL9ZJL3LHZCFAU/DcWHf1r
   11SJWcjYkX3KfbbC2y9ly0M7J4CXMbxWZRRRviykZu8O/MqZhzlkaJsWt
   6VVAh1mApvvdji7PDlXdSUyIu8TgwC02gbCaP9yWhSmqrMbi0Imy66+9M
   vJZZaEjq2bI2HPV1qLODXm+IwsPp1syBkPWtwzCnfPsnkZ1Y6+/jO/DVq
   JZdL5kb+b4/hX1am2iaGQI9ktxJ+30eJFfs11m3RKXwEmA3bbjAX0glWr
   m665NBwbwe2cRf5GCouEngeYRiGkUhciiWL0gdDU9Kh94Ma+a6oVF7fBk
   Q==;
X-CSE-ConnectionGUID: /NPjOZDbT6y5aKLxqLi4kQ==
X-CSE-MsgGUID: LEMv5c6zSkind6v7QqVXKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781356"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781356"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:18 -0700
X-CSE-ConnectionGUID: 4b4XsHbnQV2FfNZ0Xk5ADg==
X-CSE-MsgGUID: VlGFT+3xSsa4JDxuCuHTdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697106"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: support for another device ID
Date: Wed, 23 Sep 2026 16:04:56 +0300
Message-Id: <20260923160318.af9e8f9c1548.I1fd3aa97da28065966952c36edcdb99acd5313cb@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Add support of another flavor of AX231.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index a3e6c9e09a3b..a117c378b1f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1018,6 +1018,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 /* GF RF */
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax211_name, RF_TYPE(GF)),
 	IWL_DEV_INFO(iwl_rf_ot, iwl_ax231_name, RF_TYPE(GF), SUBDEV(0x0294)),
+	IWL_DEV_INFO(iwl_rf_ot, iwl_ax231_name, RF_TYPE(GF), SUBDEV(0x4294)),
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax411_name, RF_TYPE(GF), CDB),
 	IWL_DEV_INFO(iwl_rf_gf, iwl_ax210_name, DEVICE(0x2725)),
 
-- 
2.34.1

