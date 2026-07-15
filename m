Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD08314B76
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139950; cv=none; b=slY7CqcfYnmYPEWgHc0Y9dQtrfSYhQMuqHVOJC4c9ZYWuyNCujZg7IF2riunDlGkTQej8NEZYG4nW60b1Z+y8OxaN6MsNPNGqqdWaBkQx5ip2TLtUd74wVvPbOpTAsZaIgRKzeD/NTxU925vkiXF9Z+HCkk0cvDKHGbdFB8T9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139950; c=relaxed/simple;
	bh=VBjH+uPqik3APzkjgbfebj+9gpVSMy8ewjGki+ucESM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lCSp9fTUmVxkAZcMhpTlxM1YnGpJ8Vomzpae6dEvwOQt4YKcOdU/W5LOhpkmggxeN5WgWv4a1SCu5Wasnw5rbWcsopXW2rxbDh8OQm3iPcJv0nzIFC04hFDf55Ux5l4pDNXLDM9p4su2DkpMr2GJpYi4Ge0o6Fc1dwXboXGD2jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y8MJelOo; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y8MJelOo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784139943; x=1815675943;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VBjH+uPqik3APzkjgbfebj+9gpVSMy8ewjGki+ucESM=;
  b=Y8MJelOoX1eKUIQqg+YrgUh7Ef11ENaKQE7rN4TkEGmb6IFAcCW3NCaN
   +ZwXdd+GeE+AXKpXxVwVU9SYZNG66H4woa61inmmdeaF1rdij8jiMLXSo
   wzP3Oj+CPWGCgAjXTUxvEV0+94Hb3EePN2VAuA8l9Aac+HHfAlHPZz8BL
   BUQun4JFerRw0CXIDWTkNg5dqaG1pQRGJS3rQveDUmYsRvuiffI7xaICe
   0aZvg9L9H0IsEViITnaEAdMWSmgv3gEP9wvs/TBAd88WW4jL0tZbpJPwd
   k0gYM4lfpoVw5AzKx/z4NBFmYUX2jBMrz0pGkSfxHzzdayqqRD7rJQtSG
   g==;
X-CSE-ConnectionGUID: 32bwpC51SiylQAvLDmc57w==
X-CSE-MsgGUID: 81HYul+WQde5pwr1Cqhxbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="107589729"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="107589729"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:25:37 -0700
X-CSE-ConnectionGUID: f6xlPPzXSqaK09VcgO6oKQ==
X-CSE-MsgGUID: K+vSudR9Ri+asCVW2z3jYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="249902665"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:25:16 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: clarify and tighten key checks
Date: Wed, 15 Jul 2026 21:24:40 +0300
Message-Id: <20260715212403.725e6b63e890.I24684374112bb94d0633d61ef76ecb8a1517f7f1@changeid>
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

Currently, we accept per-STA GTK for any interface type
if the IBSS_RSN flag is set, which doesn't make sense,
and also accept various key indices that aren't really
(meant to be) supported, such as IGTK/BIGTK on IBSS or
AP_VLAN etc.

For MESH and NAN_DATA interface types, per-STA GTKs are
required, so their support shouldn't depend on IBSS_RSN.

Conversely a driver setting IBSS_RSN doesn't really say
it also accepts per-STA GTK for other interface types.

Move more checks into cfg80211_valid_key_idx() and make
them more precise:
 - allow IGTK and, if supported, BIGTK for NAN
 - allow per-STA (RX) GTK only for
   - NAN_DATA
   - IBSS if IBSS_RSN is supported
   - MESH
 - allow B/I/GTK for station/P2P-client without mac_addr
   for RX with the current AP (historic API quirk),
   subject to support
 - allow TX GTK for AP/P2P-GO/AP_VLAN
 - allow TX IGTK/BIGTK for AP/P2P-GO subject to support

Other settings are rejected, clearing up corner cases
and disallowing unexpected settings.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/core.h        |   5 +-
 net/wireless/nl80211.c     |  11 ++--
 net/wireless/util.c        | 105 +++++++++++++++++++++++++++----------
 net/wireless/wext-compat.c |   3 +-
 4 files changed, 86 insertions(+), 38 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index df47ed6208a5..399037514943 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -443,8 +443,9 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
-bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
-			    int key_idx, bool pairwise);
+bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
+			    int key_idx, bool pairwise,
+			    const u8 *mac_addr);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev,
 				   struct key_params *params, int key_idx,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 242071ad10d6..99a1c0174bdb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5409,7 +5409,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
-	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+	if (!cfg80211_valid_key_idx(wdev, key_idx, pairwise, mac_addr))
 		return -ENOENT;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -5663,8 +5663,9 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
-	if (!cfg80211_valid_key_idx(rdev, key.idx,
-				    key.type == NL80211_KEYTYPE_PAIRWISE))
+	if (!cfg80211_valid_key_idx(wdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE,
+				    mac_addr))
 		return -EINVAL;
 
 	if (!rdev->ops->del_key)
@@ -5672,10 +5673,6 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 
 	err = nl80211_key_allowed(wdev);
 
-	if (key.type == NL80211_KEYTYPE_GROUP && mac_addr &&
-	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
-		err = -ENOENT;
-
 	if (!err)
 		err = nl80211_validate_key_link_id(info, wdev, link_id,
 				key.type == NL80211_KEYTYPE_PAIRWISE);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 24527bf321b2..3e584d0ca3e2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -241,10 +241,8 @@ bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
 	return false;
 }
 
-static bool
-cfg80211_igtk_cipher_supported(struct cfg80211_registered_device *rdev)
+static bool cfg80211_igtk_cipher_supported(struct wiphy *wiphy)
 {
-	struct wiphy *wiphy = &rdev->wiphy;
 	int i;
 
 	for (i = 0; i < wiphy->n_cipher_suites; i++) {
@@ -260,27 +258,86 @@ cfg80211_igtk_cipher_supported(struct cfg80211_registered_device *rdev)
 	return false;
 }
 
-bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
-			    int key_idx, bool pairwise)
+bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
+			    int key_idx, bool pairwise,
+			    const u8 *mac_addr)
 {
-	int max_key_idx;
-
-	if (pairwise)
-		max_key_idx = 3;
-	else if (wiphy_ext_feature_isset(&rdev->wiphy,
-					 NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
-		 wiphy_ext_feature_isset(&rdev->wiphy,
-					 NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
-		max_key_idx = 7;
-	else if (cfg80211_igtk_cipher_supported(rdev))
-		max_key_idx = 5;
-	else
-		max_key_idx = 3;
+	if (WARN_ON(!wdev))
+		return false;
 
-	if (key_idx < 0 || key_idx > max_key_idx)
+	if (key_idx < 0)
 		return false;
 
-	return true;
+	/*
+	 * Can't differentiate ciphers here so allow 0..3.
+	 * Pairwise keys must be for a station (MAC address given).
+	 */
+	if (pairwise) {
+		if (!mac_addr)
+			return false;
+
+		return key_idx < 4;
+	}
+
+	/*
+	 * For group keys, mac_addr==NULL means setting a group key
+	 * for TX, which is only supported on some interface types,
+	 * except for STATION/P2P_CLIENT, where it's setting the RX
+	 * key with the current AP (for legacy reasons.)
+	 *
+	 * Apart from that exception, a non-NULL mac_addr means RX
+	 * key being set.
+	 */
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		if (!(wdev->wiphy->flags & WIPHY_FLAG_IBSS_RSN))
+			return false;
+		fallthrough;
+	case NL80211_IFTYPE_MESH_POINT:
+		/* no support for IGTK/BIGTK (yet?) */
+		return key_idx < 4;
+	case NL80211_IFTYPE_NAN_DATA:
+		/* these always need to support per-STA GTK */
+		return key_idx < 4;
+	case NL80211_IFTYPE_NAN:
+		/* no data */
+		if (key_idx < 4)
+			return false;
+		/* NAN reused this flag */
+		if (wiphy_ext_feature_isset(wdev->wiphy,
+					    NL80211_EXT_FEATURE_BEACON_PROTECTION))
+			return key_idx <= 7;
+		return key_idx <= 5;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		/* see note about exception above */
+		if (mac_addr)
+			return false;
+		/* BIGTK support implies IGTK support */
+		if (wiphy_ext_feature_isset(wdev->wiphy,
+					    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
+			return key_idx <= 7;
+		fallthrough;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		/* no RX with [B]IGTK */
+		if (mac_addr)
+			return false;
+		if (wiphy_ext_feature_isset(wdev->wiphy,
+					    NL80211_EXT_FEATURE_BEACON_PROTECTION))
+			return key_idx <= 7;
+		fallthrough;
+	case NL80211_IFTYPE_AP_VLAN:
+		/* no RX with GTK */
+		if (mac_addr)
+			return false;
+		if (cfg80211_igtk_cipher_supported(wdev->wiphy))
+			return key_idx <= 5;
+		return key_idx <= 3;
+	default:
+		return false;
+	}
 }
 
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
@@ -288,13 +345,7 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr)
 {
-	if (!cfg80211_valid_key_idx(rdev, key_idx, pairwise))
-		return -EINVAL;
-
-	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
-		return -EINVAL;
-
-	if (pairwise && !mac_addr)
+	if (!cfg80211_valid_key_idx(wdev, key_idx, pairwise, mac_addr))
 		return -EINVAL;
 
 	switch (params->cipher) {
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 5dbf3ef4b257..d45bc08c0de4 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -454,8 +454,7 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				rejoin = true;
 			}
 
-			if (!pairwise && addr &&
-			    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+			if (!cfg80211_valid_key_idx(wdev, idx, pairwise, addr))
 				err = -ENOENT;
 			else
 				err = rdev_del_key(rdev, wdev, -1, idx, pairwise,
-- 
2.34.1

