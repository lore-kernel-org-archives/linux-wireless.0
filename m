Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FEE39479F
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120374; cv=none; b=NOGQy0ovApUkcLEu07Qy6E+9u9V8VLHqKTGlc95zyyg/joN3okG0BK/FsDY1vVcI51zUbxVxapOL/96846F0dWFOjRIoZ9xZifGP0kvA5OR2uKyu7LOIEn5V9NaWzTAzY1FcFdBzrBTVuMSk16/8lqtcWvpnuSiZd16c2kWZqqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120374; c=relaxed/simple;
	bh=N/faCM+I0XcwdeGN9ayl+5dsKU7yEwSEgtcntsRVU+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsiEzS8JJyTm/y0CbPRrzbkpJ+7TnKWuOGQg9g1qHDhAz9/IoTkVR3yRBpwH6XqcbBKGC2fdH4aD5VPLl1KM4Swya8gzoJJh+fNvIQVbMZFuhxnttLIF9doi4OqmLx+v/XN7YIb1aaXrCPNlKVC385lvmHAlLzzqcau0EKiPVZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WRKhEOgy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WRKhEOgy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120373; x=1822656373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N/faCM+I0XcwdeGN9ayl+5dsKU7yEwSEgtcntsRVU+Q=;
  b=WRKhEOgyuzUCVaXw9wvd9HhsCSN8vhv5NQ0dLAh1x03v5OToOnWJskzt
   O7r//Y3l5aVi+J0U67M0RGSGxYaKqd7chZjIqb/3AgI4SEWIKAcijpxUS
   IOlPQWKK+nn1B7dW4HjN8IJAxCq7YeMgi62fuP7XvKKMzK5Kgrmlf2T1x
   dHQSGfEEhV9cPfJfIyQZwanu3v6RYJDUjRIPrM6nygBE1YzyzDDSSgObV
   gaNTR8ki83vrxmK403lSrOfq9UZRcL1YUyPD5UhNiZEFfcc8B2eTJ9CTe
   VQh9UqH9yictm3SAUchFnEwftcGjQ3TPsznHnRZjC3Bw1lerQjWkFLD59
   A==;
X-CSE-ConnectionGUID: tl20NWfVSaqiod8xw6kSlQ==
X-CSE-MsgGUID: /hIYfFc+QmuggSeh94OIAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328694"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328694"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:13 -0700
X-CSE-ConnectionGUID: EZfAJTc+R0iDpV3/4z6rQA==
X-CSE-MsgGUID: Fl6zcY6MR+iDyeib66ZY6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569120"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:11 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 04/11] wifi: cfg80211: do not use NAN beacons to update the BSS table
Date: Mon,  5 Oct 2026 10:40:29 +0300
Message-ID: <20261005074037.3506633-5-ilan.peer@intel.com>
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
index 9e934b185e34..c5dad787747a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3302,6 +3302,10 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
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

