Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B683D455172
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124219; cv=none; b=h+FpsmldSZOKTzbobI9L+Z/eB6ylQCmkIPt7pyMp9wd/hIL+oj/NOqG7QSgFDtfcyDoIg4Pv74mQVEr/hexz9VC6BtnFxRBoXXY3nZZMVsjI3EbNuCZKEPx+AiX3eiE+xFaymyo09pb1cir+q5K2CI4hsfls6QZT5grH+VvDpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124219; c=relaxed/simple;
	bh=uaDFyY7XAy+RrbM5jD7NcumCpOD4pIGHGJ7XsR34i6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IusVuxYh/VrWxUX8aCpSnHGwvnb6BI4VWIb7S3SaKiEq/4/vonmzBm5y7YSDPmlTkLWTc6TcaGhOX0TB74Dw5ueClfmJANvgfmT3JNlnSdamGA1LgfzwSStcqFkhL89OKJFmx3FqcV1Hv8CS1numQnB3vzIkjX8COzyLt22zMew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ETh2sr+w; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ETh2sr+w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124218; x=1822660218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uaDFyY7XAy+RrbM5jD7NcumCpOD4pIGHGJ7XsR34i6Y=;
  b=ETh2sr+wnrEAm78p5e7A07GtTjBx49ED6tloj/6+EU2JoW6BSQ1DbgkL
   MhxH+K5hvAt/9LIElauiGfjHTNrIn3Iwj8qbGzthxEmczAaXe/WbiEBUY
   6dT2iPDT0kyIBa5GHKi3tOLrCL6kaNx/kn0eVHZJjj32NR39Osu0/riqb
   Wvax6kunKTWJwaFnMJU3eg1d4pZErjantlL+y6w9cowhvb44e+Ut5g/HH
   K7wyXq0+suRfyBukPFvJYj0n7qDcE7SVhRzhsNsaIz7THrhDO50sYoFea
   WroMAagK23PYhnVgTvkpxFI2S/yPIvD5DSLv32VuqfVGkzyeP+SCXRFSe
   w==;
X-CSE-ConnectionGUID: ZaiBsNT9Q4KloBYwzgEDdw==
X-CSE-MsgGUID: SiAqzjf2RNaQIETo4VLv4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591427"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591427"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:18 -0700
X-CSE-ConnectionGUID: z92ce52hTXSNXT4paATrNA==
X-CSE-MsgGUID: q6c+75hVRJ+RQdTXSWymLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576886"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:16 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 04/11] wifi: cfg80211: do not use NAN beacons to update the BSS table
Date: Mon,  5 Oct 2026 11:44:51 +0300
Message-ID: <20261005084458.3666739-5-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005084458.3666739-1-ilan.peer@intel.com>
References: <20261005084458.3666739-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As NAN beacons have a different structure compared to beacons
defined in the IEEE802.11 specification, e.g., they do not contain
a SSID element etc., they cannot be used to update the BSS table.

Add a utility function to check if a frame is a NAN beacon and
use it do return early in cfg80211_inform_bss_frame_data().

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/linux/ieee80211-nan.h | 26 ++++++++++++++++++++++++++
 net/wireless/scan.c           |  4 ++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/ieee80211-nan.h b/include/linux/ieee80211-nan.h
index 455033955e54..b332a94671ba 100644
--- a/include/linux/ieee80211-nan.h
+++ b/include/linux/ieee80211-nan.h
@@ -74,4 +74,30 @@ struct ieee80211_nan_anchor_master_info {
 	     _attr = (const struct ieee80211_nan_attr *)		\
 		(_attr->data + le16_to_cpu(_attr->length)))
 
+static inline bool ieee80211_is_nan_beacon(const struct ieee80211_mgmt *mgmt,
+					   size_t len)
+{
+	const struct element *elem;
+
+	/* The NAN IE is at least 6 octets */
+	if (len < offsetofend(struct ieee80211_mgmt, u.beacon) + 6)
+		return false;
+
+	if (!ieee80211_is_beacon(mgmt->frame_control))
+		return false;
+
+	/* NAN Cluster IDs range from 50-6F-9A-01-00-00 to 50-6F-9A-01-FF-FF */
+	if (get_unaligned_be32(mgmt->bssid) != ((WLAN_OUI_WFA << 8) | 0x01))
+		return false;
+
+	elem = (const struct element *)mgmt->u.beacon.variable;
+	if (elem->id != WLAN_EID_VENDOR_SPECIFIC ||
+	    elem->datalen < 4 ||
+	    get_unaligned_be32(elem->data) !=
+	    (WLAN_OUI_WFA << 8 | WLAN_OUI_TYPE_WFA_NAN))
+		return false;
+
+	return true;
+}
+
 #endif /* LINUX_IEEE80211_NAN_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d35c826c4b1a..b7c6c856b3c9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3338,6 +3338,10 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	if (WARN_ON(!wiphy))
 		return NULL;
 
+	/* NAN beacons are not a BSS, don't add to the BSS table */
+	if (ieee80211_is_nan_beacon(mgmt, len))
+		return NULL;
+
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 		     offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-- 
2.55.0

