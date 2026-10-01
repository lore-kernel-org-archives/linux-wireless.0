Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4664A9D50
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861485; cv=none; b=ox7gxxOk81Idl5i0tK7t9YZ/k8uGBCW93GB2/qxbt+ZFYoEcMsoZwPkCLYkA4LSSwhey0kjqNLC/gh2vH2AMHPK5FWgFyMqUnJGqQV34dIZ8Zl7iQ8FuVteCrX+LMmlGMRl1EPoJHD5k4Pumw2fYEmBsX+YKFs3jRV0PEeE3qQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861485; c=relaxed/simple;
	bh=4GxiW/7M38gjj1S0doj8k+FgVpI8IJUPw+8JXV8o2vI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KoFl+zkPOG7rJbIDTwI63OTiTnsLfaLvrIdlm80GAFWmIeP4tJkYcZ/pP9EaNEL6KmJ3ykaUqiM2IjKuFP/BzR1L9q4fiYEtjKOyxw6Ybc1fqbGLIc+w6+iTV6vAnGtSfXoZpCBGhk5y4VEjAjPRl9sStkpneTsflT7SNFXWztM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDKsZ8bb; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDKsZ8bb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861480; x=1822397480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GxiW/7M38gjj1S0doj8k+FgVpI8IJUPw+8JXV8o2vI=;
  b=lDKsZ8bbSNZMI24uBaDLUXJhMCVjUcXEieiMrZ6Td0emtIVLFpjsC+CO
   rBocTzMC3AYK+9pFqkU7PrwqeE8BZqR8l0ohm7T+jAXl8LJS44UIgu5oH
   zzOBeiyM4Wc304OLG6Dk1ZOpcu3wreQj2r2zbdYGBndvT455LFMzkrWrQ
   NTZrJFXUnXJf9pIzxdbsXEV5dgpBs2AU2Gx17lKXOCblqj+iAdhcwUujP
   q8H/yMAj0y32fTBkhtkTNjQNvkwFt+0IxOsAnCoUTkEcTz7nNx551Wian
   J14ovXLLa10HR1CRox/HZ6+7UsE+n+9U5GiFDkken7f9tB6qqzbSLqS/f
   A==;
X-CSE-ConnectionGUID: h8oMnY8HTTm1wnekBj7SfQ==
X-CSE-MsgGUID: j3wFwtXeTpy34hwJsv3iqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750519"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750519"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:17 -0700
X-CSE-ConnectionGUID: AIVWuzDZSA+b33dG7jxPTg==
X-CSE-MsgGUID: yukQKhnDTCa27aOe+yZqzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26430"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:16 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 2/7] wifi: mac80211: nan: Update NAN configuration copy
Date: Thu,  1 Oct 2026 16:33:06 +0300
Message-Id: <20261001162941.bf21a4300efe.Ifcb6f4f05ce650d81c159a4035c386d6f1523bc7@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Copy the Instant Communication flag when storing the NAN
configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd1a857c812d..eeab1b515e77 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -368,6 +368,7 @@ static int ieee80211_nan_conf_copy(struct cfg80211_nan_conf *dst,
 		dst->discovery_beacon_interval =
 			src->discovery_beacon_interval;
 		dst->enable_dw_notification = src->enable_dw_notification;
+		dst->instant_comm = src->instant_comm;
 		memcpy(&dst->band_cfgs, &src->band_cfgs,
 		       sizeof(dst->band_cfgs));
 
-- 
2.34.1

