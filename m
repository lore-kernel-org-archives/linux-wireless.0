Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891F53655E7
	for <linux-wireless@vger.kernel.org>; Tue, 12 May 2026 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614501; cv=none; b=Jt2BJ7dWxLCePUDqxrlAr1GGohZPMv8M/qf4uAmQRmhnIkFQUP8A+xigQpIPHllqA7v5nJB/bOpbpkoOKWgWpC/4XFlhDGxDY0STPFeBlAou8rUpURogzoouzKnc5IkbAyhznvOoo5+CUW5TvQuNueTKd4o5G0qbAPTsIDi+IgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614501; c=relaxed/simple;
	bh=kJAfYg1+Bl9XaFWnIqUMvcI3CFjzee1Np8S3T3UTRf8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EPSJUyi3J7o/pW3ZxwVIYpvaAbuewU+l2z51jsGFif9Bl0IE8rOS9ec2WFGR357neNWGzDqyN6ShTG63/O+NKAl5OKmFfA82RSOZIDh/tcUv56Fk4LQo26dZwuuaPawut3/qzfRm6I4i5dMxxxH1GqIpgtDLGFvaZOfGeAOH2QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUSAQUgR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUSAQUgR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778614501; x=1810150501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kJAfYg1+Bl9XaFWnIqUMvcI3CFjzee1Np8S3T3UTRf8=;
  b=eUSAQUgRRh2fFH/F+pNGFVYKxCCKU7lwejJCqoI8BK/u2izyxZhQdX4L
   t5sI4IJQevZtVhEOh2OiwnLh3+B0u68sZSiLadu3Qk4iW87PZXicW6vU1
   GMPJvrroUo+bc6VC+yRRrIdvsF6uqhfjZrhApUrCbxIKORRl7RNxtk/yX
   +rGzX6UHQUqS2daMCBJ1vIIq+Bz/PzlZbzmSUMVdFTJxeRPIc4FUpTzmQ
   Y0AY1y0mVfs8PKQmnQmsUzxZrHiiWJK37JuvldwPjX2Vu2XZVGrA9PvE1
   NJLMBm3rHfO4+zLDd1P15xsQjUUauViXfnfZ2VMevSoXxN60rYleXmh7M
   g==;
X-CSE-ConnectionGUID: 7MRFZRCpQZ60I5aQY4IDaw==
X-CSE-MsgGUID: e4ivcMO+TGuiMpsrGyl4Jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83148778"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83148778"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:35:00 -0700
X-CSE-ConnectionGUID: I/JsYcrXQEyADDWqmNRYrQ==
X-CSE-MsgGUID: sfT1B78sRFWZe4fNQ0ojOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="231471720"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 12:34:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: call iwl_mld_free_ap_early_key() for AP only
Date: Tue, 12 May 2026 22:34:31 +0300
Message-Id: <20260512222731.d67d658b421d.Ife2d1f3b17119ce696582ce6a2a69026d368d8af@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
References: <20260512193441.2352467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

The driver supports intalling IGTK on a NAN device interface. When
the IGTK is removed, iwl_mld_free_ap_early_key() is called which
results in a warning since no links are attached to this interface.
The iwl_mld_free_ap_early_key() function should be called for AP or
IBSS interfaces only. Check the interface type before calling it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 4315b1b2b36b..41bc47e4e00c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2227,7 +2227,9 @@ static void iwl_mld_set_key_remove(struct iwl_mld *mld,
 	}
 
 	/* if this key was stored to be added later to the FW - free it here */
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
+	    (vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_ADHOC))
 		iwl_mld_free_ap_early_key(mld, key, mld_vif);
 
 	/* We already removed it */
-- 
2.34.1

