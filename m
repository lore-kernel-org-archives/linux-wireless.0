Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9D25B099
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861486; cv=none; b=grG20IpV7CWlZjVLjyjhYVz/1cmrjLAdu7v8ps94xSxamP2GUMU7cZatBduMAhT3bltitK7nVX35zhjKVI7EFz9nZe+qa1ZMVWJS5IbaQrZCD0MO15nwOmRDekI/trQQgZ3l4oMyFPciXp3kHdFe4PfSdQsbDs2DkHcihacyLSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861486; c=relaxed/simple;
	bh=M8QOqKdcX7oA61feu60W+KnSIdO3qBc4+KQlIFzAwX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k9WKQEHS77c3km5r0eNua82Rjc1SroB2F6apBP2n+unnnm2qyPz9uQP9oXNiqOeZvmKrZemthGGfFH1VsiX4nM/rujtxiWO8zmXZG/g1tvaBEq9JHvbVP2pxj48O4IFjm4EldSEpkEGh6LZ3xbsc/vTsVJtuYUfwb9RZidS8Zi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQohueWn; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQohueWn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861483; x=1822397483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M8QOqKdcX7oA61feu60W+KnSIdO3qBc4+KQlIFzAwX8=;
  b=JQohueWnpyZiCHTtmh2RdGMKfg9nRRiNDqk4IEEyZUS3Yn7EuxPstxLt
   IFm+Ctnng/WyQCe7r5G2ZriaBKuuc77ziVueud8rScSY7Gh6uUA+ESO19
   h2g7wkTtby4MtQwXYR9vU0TFedGrkm3kN+5GyppHSD51Zmx0/zuJ2FZ1Y
   TvydPEJZ8IwWESmO7tyH7VfwlUArYTWl2PtP2d3ncouuxgiIiP8dA/eYp
   U82KPYPMza+hY4af8NhmnhdKaB0HqGUm/haIaRn1KoshAdHvGh0QN5+ST
   5DylIHiFMq33eGsJokSe10M3kHYufPToAoaaDpUKBP4VrCswrUU4aI+a2
   A==;
X-CSE-ConnectionGUID: nG03CCFYS5G1em6rasQMsA==
X-CSE-MsgGUID: lPsLPzWhT4Sc1MrRIsBFiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750522"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750522"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:19 -0700
X-CSE-ConnectionGUID: EwCU4cWbQBqauP+I/h4Jdg==
X-CSE-MsgGUID: BZk+pdLcTui1DPYwGW8mgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26440"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:17 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 3/7] wifi: cfg80211: nan: check Rx registration for NAN beacons
Date: Thu,  1 Oct 2026 16:33:07 +0300
Message-Id: <20261001162941.788c566446b6.I691a657e94dacc4e15d9a3b6d3fe95e5984ad999@changeid>
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

Instant Communication requires user space to track the NAN beacons, so
let it register for Rx of beacons on a NAN interface, but allow it
only if the driver advertises Instant Communication support.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/mlme.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index a0d1cde26f0c..801d5b811ac1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -749,6 +749,15 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 		return -EINVAL;
 	}
 
+	/* NAN beacons are only reported while Instant Communication is used */
+	if (wdev->iftype == NL80211_IFTYPE_NAN &&
+	    (frame_type & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON &&
+	    !(wdev->wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM)) {
+		NL_SET_ERR_MSG(extack,
+			       "Instant Communication is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	nreg = kzalloc(sizeof(*reg) + match_len, GFP_KERNEL);
 	if (!nreg)
 		return -ENOMEM;
-- 
2.34.1

