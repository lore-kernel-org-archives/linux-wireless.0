Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B63C0A19
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 08:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790755631; cv=none; b=lzEYSG3HfHXP0q+itG7iexvX84phJIV8hJpicEuyA0TkMHdq59dp1u3WbmAii4UF62+Ej4iQ+PADnv5rewqbPupTdR2xRpaagDzcHOR6UE24kfR1v21kgV0UFIJ/8BpJSs4JGUBw/7HtPVb7yY3SF3eARKICRG7RUvBQ+aoB5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790755631; c=relaxed/simple;
	bh=GLawVvR5i816OxFSeK1Rs8n6C0Ll4Jkd2OCmFTFYXlg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ppJGAlFtdRYmc3WhNqTA/EgGnPS1kIdG0fqzOU7YULiXsVcvAt3au+DsE8rF3eUQ1uZWatdQ0OJHi69gmsGYRdC1xZwybf+HLRe8GF0B9sYXCAIH6Sk3v4/7PKUAanxoXXOq64M7X9Q5GtJGaK8RrFfwUSaldVKhbaqqgd54Uqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=meNgjWxy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meNgjWxy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790755630; x=1822291630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GLawVvR5i816OxFSeK1Rs8n6C0Ll4Jkd2OCmFTFYXlg=;
  b=meNgjWxyEoLwIiooRKkAFWQdYHF+FxZ31+yRBl5zIFJf8cEtv+WFUK3L
   kOvSntcsovajZgIIGlem6e5lWyiwLFVzKBG8Uo2q0o+Duvms3Rci/ghgH
   gkl0uHxQ44gITPdct76E8DfKwhTQJUqfM7tDWs6js8jR3ls21OVTG96ZQ
   aGYy09GZVA90D5Ty8X+WIxuTmrFK7BhdW8/jDN5Az7fyqeoXZ/nA+la6U
   8jJldBhdxXDx8qdPbEsgarJEviYClf98+pR+OO6hC6FrKhj8FG3d7BV+b
   exkb8RoUZvGfDqOtr1GNYkeaecQ4S83FZ7FKp38CG24E6qkq8AhFjHOVd
   A==;
X-CSE-ConnectionGUID: H2vhLG10QVK0kJQH11CLMw==
X-CSE-MsgGUID: 6YbZ9TyTSme99Mthwe1O4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="79053658"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="79053658"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 01:07:01 -0700
X-CSE-ConnectionGUID: 95k1kUQDQ1W/yLXAigKFIw==
X-CSE-MsgGUID: I5WuzlOBSweO0lfIz2j/2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="313562398"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 01:07:00 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: add protected TWT assoc flag
Date: Wed, 30 Sep 2026 11:08:57 +0300
Message-Id: <20260930110610.1eb6760356f2.Ie4962eaca97be29c7f08043d615534c7aeb3f370@changeid>
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

