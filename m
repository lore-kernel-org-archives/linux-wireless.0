Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732263815DB
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778563414; cv=none; b=YtfhiogVm/WN5eXD3x1NLVfmihFsrld7i/rnAIPkMqpkQR8OTKBJjqiALyNaMjGM0UJFlqxxNgFreMFcE1nWgaK3I5VF36V/niYMsYHA9rk01eL+yBUAobYqExb43mixzd7znGdpMmdJH3vb94FSPRcADv9y0hH4WEdpR2eWE/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778563414; c=relaxed/simple;
	bh=zTb793EQoBm9mclVFP2EAd5rKZ4HdJvehdvu4wWcWg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZBpNimbcRCK1ZO7t3Bo2X896tRZqBJrZ0eQLb1zb8tiN0gMtZDDRdAXwojnZe0DA3hgAtT72OHPMZGtpfjIWiqZryU87OeQat0ajPrDcg1WbVp7mpXbraxudwVOIiB1TX7LkYFdA7Vjqky3bPtiSWPX/kMpWPViHW5wdVWxpxgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQDloNp4; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQDloNp4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778563413; x=1810099413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zTb793EQoBm9mclVFP2EAd5rKZ4HdJvehdvu4wWcWg0=;
  b=cQDloNp4BC9lHRRPEwoZnNEZoWbzHwsmuzCUt6WwJCPsSV0bEf6awqk6
   cXnaYNCGZwHfAV5I3cURbkQ/khSO6KvhHHMhKjsAbAMJVRyugzqYrjyST
   8EcMIB2HhvrDDK18gyYjOWkw1h1ke/ob357UNQYWGqMz7pNBBdTnHlw0W
   tKLtBB0gT/ISSTAcXsTSsxnXkPMzPYvP0A+7Gr3s4zA2nyKIUWUvs/JNy
   sJK9teN1Xjkk3nXS6AmDaWxiJCXQtyHt2VmbNNunWUdXnIG4XeSfT8w65
   eLohxrAwlNmli6n8Tz/vWRLmBdFH/QP16aEFf6EeBJUtll2UBxhz3aw2r
   w==;
X-CSE-ConnectionGUID: E6fB/T1OQuKWxSSSgQoAag==
X-CSE-MsgGUID: Ggg1K7GARziSxUg8m1Dx/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="78495098"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="78495098"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:33 -0700
X-CSE-ConnectionGUID: O4bfqsDwRTaGPdTYXUzD/A==
X-CSE-MsgGUID: KOZ2NXXuQWSy7Zt8Y9RX/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="233187572"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 22:23:32 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: mark that we support iwl_rx_mpdu_desc version 7 and 8
Date: Tue, 12 May 2026 08:23:02 +0300
Message-Id: <20260512082114.3604e2111b27.I1f44475b56e084ee4aaeaed11b8a4fe2d27bed0c@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
References: <20260512052307.1603442-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

Mark the driver struct as matching RX_MPDU_RES_START_API_S_VER_7 and
RX_MPDU_RES_START_API_S_VER_8

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index aa4e5e9d4d4e..699343cf0279 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -735,6 +735,8 @@ struct iwl_rx_mpdu_desc {
 	     * RX_MPDU_RES_START_API_S_VER_4,
 	     * RX_MPDU_RES_START_API_S_VER_5,
 	     * RX_MPDU_RES_START_API_S_VER_6
+	     * RX_MPDU_RES_START_API_S_VER_7
+	     * RX_MPDU_RES_START_API_S_VER_8
 	     */
 
 #define IWL_RX_DESC_SIZE_V1 offsetofend(struct iwl_rx_mpdu_desc, v1)
-- 
2.34.1

