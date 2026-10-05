Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDB9391E72
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120372; cv=none; b=GKVygWeb4mW0GrdgpZ+Rwon94FuSw0nG34iHKT8cNO7Gq5FQOUCbzvzoXw90Uv/3jvwLDhAA3TLdRVDg9xsL0lcAQup7yCp2VVrq4WSwLeWRcpVjRdPVH/YSdvSQyPT2b91TVfOFy4rDoQh1HVywrpBClIEgGJeCxF2asGyxNp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120372; c=relaxed/simple;
	bh=+TZal5PeplwTpQodJg1WTTf99wLEQnjHejfavZxSaGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl6dXpJ6yZXwZQN4ReBGmbOq6s/ZB9BeeKjNG58EQYmGGwU7q1dkwkK1rDyvjbkyG5rtWRjqJNhyU4f5CqKHqgTmY26j43YQLxbKr2nschGvIH6yqv340eMGpzD8FRFqf9GJuGdI89zpe4uTQ0GyE99P25+KgqxnpqsQgj+GoL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eyyroh5D; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eyyroh5D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120371; x=1822656371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+TZal5PeplwTpQodJg1WTTf99wLEQnjHejfavZxSaGo=;
  b=Eyyroh5DC4zvXqwEibDTyqs6w/y5M/eb6XShunzzmcEU/erYIj9xQvI+
   NXneoNWJqKj6pr2UaElLKgqfSZa+YKAJXcMzLXMotEz8Z4aK/IpzXeQPH
   m/+cFsggBHBcyV0GMLgvMJP+9k+sy/jwBPY/AwGAO5bklumMlryJhd9yH
   k+pAnyn2scPCZj/FLJnaY3h9ISODo7KQpSuGJSvZc6Nc//qCestiDsh5D
   eCE5sik6rniLj+yP/ic/MZWaIcpEx4G7NuPhs4UQDNYfrC6L/CkUPelLx
   7TSRPFtTs9sZSLLfC75fIuJ/mwTgO3SBeOdb8+e8ofS3VS3o+4Mv+71Do
   A==;
X-CSE-ConnectionGUID: JoiDmo4DQi+GcuvQuGyi4g==
X-CSE-MsgGUID: 3jDPrJBHTp2ZZ2OkxehloQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328690"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328690"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:10 -0700
X-CSE-ConnectionGUID: dII41WGrT0GF865qJQeADg==
X-CSE-MsgGUID: DKr7vjXITwyY48R9/NpUmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569103"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:08 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 02/11] wifi: mac80211: nan: Update NAN configuration copy
Date: Mon,  5 Oct 2026 10:40:27 +0300
Message-ID: <20261005074037.3506633-3-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy the Instant Communication flag when storing the NAN
configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..7a7acbfeeba9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -364,6 +364,7 @@ static int ieee80211_nan_conf_copy(struct cfg80211_nan_conf *dst,
 		dst->discovery_beacon_interval =
 			src->discovery_beacon_interval;
 		dst->enable_dw_notification = src->enable_dw_notification;
+		dst->instant_comm = src->instant_comm;
 		memcpy(&dst->band_cfgs, &src->band_cfgs,
 		       sizeof(dst->band_cfgs));
 
-- 
2.55.0

