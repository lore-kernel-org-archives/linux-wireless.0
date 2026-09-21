Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7844838E
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023178; cv=none; b=hOQQaX/3Nby04BiQbiK3OonjBsPJVOXag1+iPs+hQp2bFGjnJVS9gDdj0+BPecsMrFrIbE9pbFkar7sxTX462wLwMyv44GKAlCULQFMNIUF9KvLvQqN1JorJfRcMJUx+Yny3LiuqQtO2H4DnOFPo2Rg43f21AVYaeN3GJiKaC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023178; c=relaxed/simple;
	bh=cHSUlZH99eKhZLa5twtC/ujV9vqPZukey/goNkWVRRY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MIBKRxRDBWxvjAfamRtTGKEpuAzgC2ksKti0AIj4H34YIe+cRTm4cyQDGXXA2ONkgpL8cRmoV3JNHtKoBWTuUrUVzVfcwWBKKPslxW4UF/Q90MQ9JhBd16vbBbdMtpftaGZj05CEFDFqJffmeu2Ouwf7RPLyMp+i2++gd1Umjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfAZ6g3r; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfAZ6g3r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023174; x=1821559174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cHSUlZH99eKhZLa5twtC/ujV9vqPZukey/goNkWVRRY=;
  b=dfAZ6g3rnhJFp0C2XDtQcIPKz8ENMu0al0vMA2NV2CF6/eilOcLHoMLD
   T9QXf0HtYSOFO+bLuYUsfP46+VFOJ4K/uZhp1CxU+oAvABt6GgGXsJOjp
   GxIEqHz5JUPj6ksrMPcrAJ0KuS5Mzh8HKUXp2QNZT7vvW9UbEwu44t0cd
   sufwwfP933vcsvisCL65P0TJEY41HVJrKD5S8vg43J21csfq22kYS6w/6
   vv6W13F/X/rrp88hGj/jgrCekC8g32mkDfTjU3Kct4U7yUy9hNcZ+F0Uw
   wY0RnOrHyWyvpEOfPG6duSJGhbXW8n7tN4dIMUz7wroKD+SQwv/swSfnw
   g==;
X-CSE-ConnectionGUID: DtuY5diYSoOW0P1HnBgbgA==
X-CSE-MsgGUID: YeCXsHdOQXyEtPBu5HNE+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128767"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128767"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:34 -0700
X-CSE-ConnectionGUID: L5s398aUSxiHJe11cAOE3w==
X-CSE-MsgGUID: xiOAYSX6RJqzVaSYfC2uDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761933"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:33 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: mvm: wait for 6 missed beacons before disconnection
Date: Mon, 21 Sep 2026 23:41:12 +0300
Message-Id: <20260921233730.025f2655b3b1.Ieceece6d8f660399e844ea4dadac414243e35d07@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In case we keep getting data from the AP, wait for 6 missed beacons
since last Rx before disconnecting.
This will give the firmware a chance to send NDPs to the AP and avoid
disconnecting if the AP is still there.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c64e4ed00986..fb1fc9c42280 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -42,7 +42,7 @@
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
-#define IWL_MVM_MISSED_BEACONS_SINCE_RX_THOLD 4
+#define IWL_MVM_MISSED_BEACONS_SINCE_RX_THOLD 6
 #define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
 #define IWL_MVM_MISSED_BEACONS_THRESHOLD_LONG 19
 
-- 
2.34.1

