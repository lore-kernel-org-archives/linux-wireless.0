Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3729D445AD0
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023193; cv=none; b=VZeDSjzHb+MVggkblEKsdabHgL7QwG5lNIeUtiOas0FUlSSIwxFLEEoerBD7AT6yDdQ5fd4ytxkHN7uB48iGpkp72jLkzzNDOphEfd5Wouukbe+AR63LuoQ82XzfvvEkUyiie3V4FMEEt6+7Ylg6wq28siwfiuY2tmlmXBdHcUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023193; c=relaxed/simple;
	bh=nSsq4w/R/0d1Sfxvq/348wOLgQcrhJm2aEEyVKQojYc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nMSonyqaMaOFYs5w6N1XmQDdkZjBRlNK+UxuIk+l/HjDXgfSfirixTf6wXP34Z233flmK6zFKNVBX8Aco1RuFp08LQVE205F36qNrsTGMvh1OrrMBOfCYYJpQhalzlAYP9EQo+cW0QcaSCy6va/iyW29oioAWuuSQjnQL0hLCqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zoorhz58; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zoorhz58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023191; x=1821559191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nSsq4w/R/0d1Sfxvq/348wOLgQcrhJm2aEEyVKQojYc=;
  b=Zoorhz58ZDxMqWD7wF4+g0KRKQUMHN3p0p1NMGFgJeRIelF9tqEgcObV
   ipdA3wKkuHOnwNWDImuQFG2AY8/yTwwD+hbl4yhYsHEmx66JPcjRz0dWY
   9GrAEjBjFbv5hRtYs9hmsolYg2OSJ+8aYyRwmy00wotTsG0ixigZscj6j
   YZi6kzmRocibVZVr+NdB91eXW//d2jdLkm6uNB6LzxmLiTCkURDKKHWOG
   JHVxjVTYfLPJhCpYODoOHopmPWX8vEm+/wxcJ+j/x5QXbFIhBHGMgkigP
   XHWCwff8S+VV9grVMo9g8OlUnljV7mNSknw1hIsGogDbnwRm+slhd1ClU
   A==;
X-CSE-ConnectionGUID: KNkSVhaFRTG9GHWHuyrIAg==
X-CSE-MsgGUID: hrWWPCDiSB+3H/WJ58rGew==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128805"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128805"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:50 -0700
X-CSE-ConnectionGUID: GKojMHXuS8m0tk6YM3t8mw==
X-CSE-MsgGUID: IZVILSbdSkO9uXguvLY/SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762126"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:49 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 14/15] wifi: iwlwifi: fw: add Google-ASUS TAS approved DMI match
Date: Mon, 21 Sep 2026 23:41:24 +0300
Message-Id: <20260921233731.43ea7ba69e05.Ib2ec495e6dea3db1db783d43171505bd03d24cf6@changeid>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Some Google devices with ASUS board vendor need to be included in the
TAS approved DMI list so TAS policy is applied for this platform
combination.

Add a new GOOGLE-ASUS match entry using DMI_SYS_VENDOR=Google and
DMI_BOARD_VENDOR=ASUS in the approved list. This change only extends
platform coverage and does not alter existing matching behavior.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Assisted-by: GitHubCopilot:GPT-5.3-Codex
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 1d6d38ee55b4..3ab383b569bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -167,6 +167,12 @@ static const struct dmi_system_id dmi_tas_approved_list[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
 		},
 	},
+	{ .ident = "GOOGLE-ASUS",
+	  .matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUS"),
+		},
+	},
 	{ .ident = "MSI",
 	  .matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International Co., Ltd."),
-- 
2.34.1

