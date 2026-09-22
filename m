Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5845628F
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073326; cv=none; b=XYZbUJ9pwJUXWBLeHqNWlL1DLnpzMLgoeccU0/fc2vN8yS1xwRxWOUbbME4iEMXMqkQhFDHSPSkGTWnquV2EyJDH4gsEAthznRf4LTtcJgnzWw+hsxh/wnjXq7/MbDXbSuqLD3AuYnxq56qX7BEDopOGGU3WKWuxOLAN+gXK86s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073326; c=relaxed/simple;
	bh=yDS+RMz9XGsfpGb+FE/OvFRU3l828N3SZkspApEg+C4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JmWVhtmQBYtem/C/Tc6dn+mOVKK+DCgSW7mqU9kaozYw/ebIyXqAvWASkmJz2DLlCAopakxK6Od2XIjSipU5XROI6Tvg08Q7Q0+z+1ZXUTAXuLl+xHSBFGzUIq82KXl7QSDfzD/SJFes/TDsXIG4/w9C7wyFC86NA+pAnlicElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ED9jbRDX; arc=none smtp.client-ip=192.198.163.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ED9jbRDX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790073325; x=1821609325;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yDS+RMz9XGsfpGb+FE/OvFRU3l828N3SZkspApEg+C4=;
  b=ED9jbRDX2wqCH66OMcwPpOaThfykmIKQHVzdNf1sa+L2VeoFw8vamA9M
   jCXv/vQDVptw0qSKYpG2uPXDAvLVrI02v76M6/ncYJmE2iySxaj4pTwtC
   /UjbQR0B4N4HzpzporyuseB1CEp7FXsl0uu7qPuQemRM3QTQS0ZMkS5hd
   vut74+TUxjt23HE+wN+8B6FUEiFLYPQPQXIxyW83NqyeBO/VaUWS1cHqc
   mS8xU/0tl7qHdgMHdJMTviLVnsPkZDO6KYQVQfHc254BQHdwLd6/XsGzo
   yrM/zxA8P3XcpzjtypNmfsZSsiu7Ei7FoYpm1DOJ9APJFDPHtF6Uhg9f7
   A==;
X-CSE-ConnectionGUID: H51vIF4MQz+WECQDwaMq0w==
X-CSE-MsgGUID: PoAseX7+QCaBIIP0AoDnSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="1166513"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="1166513"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:35:24 -0700
X-CSE-ConnectionGUID: ZwyKaGiaQLucqGjoXTlvOg==
X-CSE-MsgGUID: wEFaAuM9QbWKamad5BDkVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="272575631"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:35:23 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 wireless-next] wifi: cfg80211: require zero terminator in valid_regdb country table
Date: Tue, 22 Sep 2026 13:37:17 +0300
Message-Id: <20260922133709.3d75b1440a1b.Ib92fa3a47e4cd5109c6139e9a4aac85c50f9be22@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

valid_regdb() walks the regulatory.db country table and returns
true as soon as either:
- a zero coll_ptr entry (the required terminator) is found, or
- the next country entry would no longer fit in the buffer.

The second case silently accepts a database image whose country
table reaches the end of the buffer without a zero-terminator.
The callers of valid_regdb() assume that every country is zero
terminated.

Exit immediately upon zero terminator, don't accept a database
without a zero terminator.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a8336baf85dc..f01b19075c58 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -820,13 +820,13 @@ static bool valid_regdb(const u8 *data, unsigned int size)
 	country = &hdr->country[0];
 	while ((u8 *)(country + 1) <= data + size) {
 		if (!country->coll_ptr)
-			break;
+			return true;
 		if (!valid_country(data, size, country))
 			return false;
 		country++;
 	}
 
-	return true;
+	return false;
 }
 
 static void set_wmm_rule(const struct fwdb_header *db,
-- 
2.34.1

