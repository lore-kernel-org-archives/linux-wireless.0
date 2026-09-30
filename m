Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E325A3655F0
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758862; cv=none; b=HWSgQ9SIG05qhYJqpqpxf6lqWtB9cR1TTTTAt49tsjT9rTK6/DLKr8+nkhZl3yQIs4iJWVd8vtW5XN2FERBZCuR48V46o3zvCKJlttUBhk4fSKr00an0M6+rXhVSeOj5RVvJdptUpJox0rE3CvVmOB6T3bkpgqTlbYQO9j2Er10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758862; c=relaxed/simple;
	bh=lFaMKbMuKv9tKAlb8aZVhhTUjQ5NcM8X3M+SHaoMvco=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=knpwdffDN2WeAes2e7CYmHjCqZJYvBbuA+5yErP+HPZOibeZ5IMBjW/cGU2NM5mufXhACLDFuuO/dB0oJ7j3t6cYfPqVmTLqrsqjHaGLOvy+dEqbe3ZsbecQTOEcGM8evrrytkbRJsHyjeq4wiolpI+89g45Cx2i5HnDl7MQ3Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FGQyOBmL; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FGQyOBmL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790758861; x=1822294861;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lFaMKbMuKv9tKAlb8aZVhhTUjQ5NcM8X3M+SHaoMvco=;
  b=FGQyOBmLVoIN3cf8WnSjV1w7yGHqZNoHg/xWqmBEh5oK6eUGuGRzb2qt
   Kd2tKmWERDnvtF5zF+JYNxYWaoPH3xBAGi5yvxsDfREA2axHIhpuNDPjT
   Z5/py2xH+6m+Pag0md98f5YEEkS2rSz/b17cRx+Oe2x79i29HkKCjbZgC
   p250cza1e8cTsQXeboZhXily/0VgsKEOyUOLs4rb/tjG7afiEiFpSvsn3
   0ymSkNWhQzsBxd/BuuXvs+I/16qKAFYq/VIKuDvyNP/Frp85lcvRAvvCx
   2BMbPmh71UCx05vBkr1aGd/hS/va3MFnGxJlkL8T1AqDLRkUH/Inht2fX
   A==;
X-CSE-ConnectionGUID: w2EzJ3e4Q2aEHpicujxV8w==
X-CSE-MsgGUID: v4p6mOMPQU+jpc+de91gEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102062814"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102062814"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:01:00 -0700
X-CSE-ConnectionGUID: 81imFtiBQk+QHPqH1FxavQ==
X-CSE-MsgGUID: djzvY4dCQpmbakUSy1666w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="274240814"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:00:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 wireless-next 1/2] wifi: cfg80211: add protected TWT assoc flag
Date: Wed, 30 Sep 2026 12:02:56 +0300
Message-Id: <20260930120021.1eb6760356f2.Ie4962eaca97be29c7f08043d615534c7aeb3f370@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Protected TWT support is indicated in RSNX, but RSNX may
be used from security profile now, and not be present in
the association response frame, so the logic in mac80211
to determine it doesn't/won't really work.

Add a flag for wpa_supplicant to indicate if protected
TWT is supported in the association, it can easily check
this based on the RSNX data that was used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
Resending again with the following mac80211 cleanup

 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 5 +++++
 net/wireless/nl80211.c       | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b603f1804cc2..bdf01b9f8ac7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3407,6 +3407,7 @@ struct cfg80211_ml_reconf_req {
  * @ASSOC_REQ_SPP_AMSDU: SPP A-MSDUs will be used on this connection (if any)
  * @ASSOC_REQ_DISABLE_UHR: Disable UHR
  * @ASSOC_REQ_CIP: Enable Control Integrity Protocol
+ * @ASSOC_REQ_PROTECTED_TWT: Enable protected TWT
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT			= BIT(0),
@@ -3419,6 +3420,7 @@ enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_SPP_AMSDU			= BIT(7),
 	ASSOC_REQ_DISABLE_UHR			= BIT(8),
 	ASSOC_REQ_CIP				= BIT(9),
+	ASSOC_REQ_PROTECTED_TWT			= BIT(10),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 75d4c5d6a7a3..7dae0860a1b8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3228,6 +3228,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_CIP_CAPABILITIES: The Control Integrity Protocol for the
  *	station.
  *
+ * @NL80211_ATTR_ASSOC_PROTECTED_TWT: Enable protected TWT for the association,
+ *	requires protected TWT support (flag attribute)
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3833,6 +3836,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_ASSOC_CIP,
 	NL80211_ATTR_CIP_CAPABILITIES,
 
+	NL80211_ATTR_ASSOC_PROTECTED_TWT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 16c63383923b..06b30bfea270 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1100,6 +1100,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FRAME_NO_STA] = { .type = NLA_FLAG },
 	[NL80211_ATTR_ASSOC_CIP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
+	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -13421,6 +13422,13 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		req.flags |= ASSOC_REQ_CIP;
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_ASSOC_PROTECTED_TWT])) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_PROTECTED_TWT))
+			return -EINVAL;
+		req.flags |= ASSOC_REQ_PROTECTED_TWT;
+	}
+
 	req.link_id = nl80211_link_id_or_invalid(info->attrs);
 
 	if (info->attrs[NL80211_ATTR_MLO_LINKS]) {
-- 
2.34.1

