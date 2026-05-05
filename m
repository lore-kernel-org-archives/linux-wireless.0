Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546048C8D4
	for <linux-wireless@vger.kernel.org>; Tue,  5 May 2026 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777999632; cv=none; b=e72BhzQpktVLw5QAAiX3Lh6jJMxB3DQOc/KRUrel1CuRMuCtoipcfPORiS9qUWydzvKZ1MvbIWeT+HYhFOVQO/8NlIEBP/u13MhKNYD/pBVUjfwq3Yw4ef9ok4GWP4O45o4loaZgbDUmIgjBLoRpIA7dcXECdd/VxnCgigXFGl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777999632; c=relaxed/simple;
	bh=lCmxcN+v0FFE9HdnugQFPfSM9zej4qPEsANm7NSVmuk=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=qm413ZMLAzrKgfR3UmcNMaTp0CQU89IIIaUTt4DhTHgbjEYkzo50kioZxcCU2HijjymTPxuYrnpR4ZpsgHd4uw3YQfnRoDZ/QSUBjR4O2dg7fhpDNvwCXWck5EYV4oq0NT/LQioFm8mSA2Zyzb0MXxc0NZ+z3+Uyz5gIUPcZ3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bf7bwH7/; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bf7bwH7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777999632; x=1809535632;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lCmxcN+v0FFE9HdnugQFPfSM9zej4qPEsANm7NSVmuk=;
  b=bf7bwH7/ZUT5NByHob4k23ThbAAbLP7baHXmIFK1CEkiqpP1AgI40SmN
   3lChZ2ls3DJCQel0CGVj7J6QYbmNSBk0SSnf4tO33CR2xMpku35u1Z31b
   W4K9Bsztvvcqpsv53r6zdl13BCTG5zNO4AL/36oe+IqA5rgoB03IiU/zw
   kvd2/nMlZKDHlo2R2Xp31dD+XlcdbM2d05ll/XDQ/v5kE4OnGHuAAJLd0
   bIxg/rVVUH/UC4isRWt0h+l5ql6UONr/SjF+rx40N4yO9WvkzzeuvEVoi
   cqS4LzOcqMpyec5u3BhjcYXjAZdfZS7sIEW+axWaM33K+L4nGmybLLBgl
   g==;
X-CSE-ConnectionGUID: KFLy/pHdREO9BLsxQidpBQ==
X-CSE-MsgGUID: D58Ig0nsSnaSG6JbN/u7oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="89181533"
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="89181533"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:47:11 -0700
X-CSE-ConnectionGUID: N/UhKIR6TN+2yxtfOETaOg==
X-CSE-MsgGUID: dKiz5QOEQqS9GndzbhBGMQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:46:26 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wifi: cfg80211: don't allow NAN DATA on multi radio devices
Date: Tue,  5 May 2026 19:46:13 +0300
Message-Id: <20260505194607.ff87e6fcff56.If201aa58119d2a6b08223ecb63bc2869f63ff5a1@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

The support for NAN DATA was added for single radio devices only. For
example, checking the interface combinations is done for a single radio.
Prevent registration with NAN DATA interface type for multi radio
devices.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4dd1981a3629..62ab5e4639be 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -882,7 +882,7 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 
 	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN_DATA)) &&
-		    !wiphy->nan_capa.phy.ht.ht_supported))
+		    (!wiphy->nan_capa.phy.ht.ht_supported || wiphy->n_radio > 1)))
 		return -EINVAL;
 
 	if (WARN_ON(wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS)))
-- 
2.34.1

