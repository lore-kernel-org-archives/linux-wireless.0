Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C874051EDF7
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168593; cv=none; b=hXHZdL+ZoIqXDYyKBOZGBjdbC+IRTr0Yz9ZKgHRuigInecb1uoX133syvaxQEQU5ApxM+MRiJIfH9xwcIfbQuCIHH+RfgH7UIFzh7pznr5FPrlCwEXlW+xRi9WWgXV8YtUv1OL3hroM5A0XSJcwovtIof5GW/UW6af153QdmcXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168593; c=relaxed/simple;
	bh=wTjtzF0m8bGEBmaTST8OiO4dGyy9N+SAFM2KD0WQGMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P86VWgfGtDQuDTQR7dBotADrrM8hV0eUUefOSAoPc88juUPGjG6dQJB3LLHJtzfxZbbJHJdhSZSR9zLchM2F2apzYInMfsXbZubrgGMx06esfRxWxXO2ElYrCrGiNANGVyLs+hhWSMgC30nZwtuy4DYlXGrBYySQkeDZkS+NPiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYdP9Z41; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYdP9Z41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168591; x=1821704591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wTjtzF0m8bGEBmaTST8OiO4dGyy9N+SAFM2KD0WQGMU=;
  b=dYdP9Z41u+2a0wgPRKEDd20g5mh9QvK0wBN/oZd1wVxFIETbS2tEdmP8
   /MToE1AfUL+4L4TfDNQFHMXIAEElWXbeiNxG1w8t453HFYowiJ5ZkkaW+
   d18VPeIImIVmmTEZ1T2CCNDq7zIpQCgBL5hLj1x1ZS4mCY3vNJYSWW515
   EnQmq9aGLHOOHhbeUjfESPhthIoqwi4FFrVFwJSrQjg1AXSJtMNTFy7gv
   udpcqCVpIuuAhsytLKdQKtF8oYUCxKhPnGzG5AK7euf+XZrC6E39FXQC4
   NuoHajz+9hJ6CZFq92xvXsaaLp752jAwJGqMruf5JmX7ERUFuEFXW9T1c
   Q==;
X-CSE-ConnectionGUID: NXstrlhHREGk0QFex4oHJA==
X-CSE-MsgGUID: kVpnTPp1Q+GJVIzBfmJ3Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781324"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781324"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
X-CSE-ConnectionGUID: j5L3uEsfTL+0VIKGNe3XZA==
X-CSE-MsgGUID: M84ltqVSRqKX2VxtCbVfOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697037"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:06 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: fix some UHR ELR bits
Date: Wed, 23 Sep 2026 16:04:48 +0300
Message-Id: <20260923160318.3fa552b3d795.I8098855c931e1f9df16951e2d527bb079eca0549@changeid>
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

From: Johannes Berg <johannes.berg@intel.com>

These were wrong in the driver based on the hardware
definitions, fix them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 699343cf0279..a8f1edf19bbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -1347,7 +1347,7 @@ struct iwl_uhr_elr_sigs {
 #define OFDM_RX_VECTOR_UHR_ELR_PPDU_TYPE		0x00000003
 #define OFDM_RX_VECTOR_UHR_ELR_USIG_STA_ID		0x00001ffc
 #define OFDM_RX_VECTOR_UHR_ELR_VALIDATE			0x0000e000
-#define OFDM_RX_VECTOR_UHR_ELR_CRC_OK			0x00010000
+#define OFDM_RX_VECTOR_UHR_ELR_CRC_OK			0x40000000
 	__le32 usig_a2_uhr_elr;
 #define OFDM_RX_VECTOR_UHR_ELR_VER_ID			0x00000007
 #define OFDM_RX_VECTOR_UHR_ELR_UPLINK_FLAG		0x00000008
@@ -1363,7 +1363,7 @@ struct iwl_uhr_elr_sigs {
 #define OFDM_RX_VECTOR_UHR_ELR_SIG_ID_INDX		0x00000e00
 #define OFDM_RX_VECTOR_UHR_ELR_STA_RU			0x000ff000
 #define OFDM_RX_VECTOR_UHR_ELR_STA_RU_PS160		0x00100000
-#define OFDM_RX_VECTOR_UHR_ELR_SIG2_CRC_OK		0x00200000
+#define OFDM_RX_VECTOR_UHR_ELR_SIG2_CRC_OK		0x40000000
 	__le32 uhr_sig_elr2;
 };
 
-- 
2.34.1

