Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44654A3862
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861488; cv=none; b=tsmuEUfC52ezQw9yynWwQe6Aw1+EaVYgjrpEnpiNzqeftYWHP0gvXMGIuRA/AThQE/tOszALMrHSbDiHfPZhotLNDFSTG1cH9YXxXZirwQfvOUqiTmprjZL7tHihKtZUMR6KRSLkAV18bKOIQonY7EVMHEu0Nmw/NoTsIytqbIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861488; c=relaxed/simple;
	bh=vRrGriymWlxe110puVK9lUwTmzzsKSnPTirCYjnzFvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J6moEI4c64/c/yhIzzrbo0+Fr3QsoXp5YUIvRktr/mUi5p8+C3PsxUBeJyrwKgTdJTidAcTF+GAOLE9j5kZMU3gQe3LUeJHYTWNGl9FDSaI4BMnfDbdrhkNzKwXGYovU6hWuWQhnRcd2hb93GwXcKYizDHhGiIEGn107+kz5c9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAQl3/gn; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAQl3/gn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861484; x=1822397484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vRrGriymWlxe110puVK9lUwTmzzsKSnPTirCYjnzFvg=;
  b=AAQl3/gnK+GBoh4eWL/JUm4ywpAMeH2Fp1m8hHxEFdZ3tiWP3eglXJkt
   bC+4MDgdDZ10tyQw/IZXAGZqGzIeyBO/aGWRTrcoOUIPgudFi5rAMASt+
   Nf84/u8d2/eTUGA/8bu7iBTNWcrT5VfebZxLKN3mbyZ+qtiEM7hKeCQ9f
   n+jKgiuHQEgW64TLief4xPmjQBFqHxzlaKsmQRgwO0V69FfkZDXLxDlqy
   jTX6vOCdJvywVxbgy6N7YjNz2+U+JWbwYRu7kZLJt7KhwVFksdwpAi8oD
   DYzoEhRF6vk2rTfVORD02z7ake23z78XINvBLHoGbUNrvDbbL5QLEDlzy
   A==;
X-CSE-ConnectionGUID: YBupIbUuTGGAO/x3JBzTHA==
X-CSE-MsgGUID: lD0B+THZRDueUNVgUOvLHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750527"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750527"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:20 -0700
X-CSE-ConnectionGUID: 1XdexusoSOCEikmGOE5/gw==
X-CSE-MsgGUID: cohI05PpRUK1W03Vb168IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26445"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:19 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 4/7] wifi: mac80211: nan: allow Rx registration for NAN beacons
Date: Thu,  1 Oct 2026 16:33:08 +0300
Message-Id: <20261001162941.42c8f2a8e1b2.Ibb92f6652a447acbf47f5b8d654fe34a0fd845e0@changeid>
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
let it register for Rx of beacons on a NAN interface. Add support for
passing beacon on NAN Device interface when instant communication is
enabled.

Add a helper function to identify NAN beacons, based on the BSSID
and the beacon frame content. Skip NAN beacons so they would not
be used to update the BSS table.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/linux/ieee80211-nan.h | 26 ++++++++++++++++++++++++++
 net/mac80211/main.c           |  7 ++++++-
 net/mac80211/rx.c             | 11 ++++++++++-
 net/mac80211/scan.c           |  4 ++++
 4 files changed, 46 insertions(+), 2 deletions(-)

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
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7816395681fa..b889d2a7ef75 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -745,8 +745,13 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 	[NL80211_IFTYPE_NAN] = {
 		.tx = 0xffff,
+		/*
+		 * Beacon Rx registration is needed to let user space handle
+		 * service discovery when Instant Communication is enabled.
+		 */
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-			BIT(IEEE80211_STYPE_AUTH >> 4),
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_BEACON >> 4),
 	},
 	[NL80211_IFTYPE_NAN_DATA] = {
 		.tx = 0xffff,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3990b7a7299..8dde57a9112f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4536,7 +4536,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
+	bool nan_beacon = ieee80211_is_nan_beacon((struct ieee80211_mgmt *)hdr,
+						  skb->len);
 	bool multicast;
+
 	static const u8 nan_network_id[ETH_ALEN] __aligned(2) = {
 		0x51, 0x6F, 0x9A, 0x01, 0x00, 0x00
 	};
@@ -4545,6 +4548,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		return sdata->vif.type == NL80211_IFTYPE_STATION && bssid;
 
 	multicast = is_multicast_ether_addr(hdr->addr1);
+	/* Only a NAN interface may handle NAN beacons */
+	if (nan_beacon && sdata->vif.type != NL80211_IFTYPE_NAN)
+		return false;
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
@@ -4681,7 +4687,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		 * Accept only frames that are addressed to the NAN cluster
 		 * (based on the Cluster ID). From these frames, accept only
 		 *  - public action frames,
-		 *  - authentication frames to the local address, and
+		 *  - authentication frames to the local address,
+		 *  - NAN beacons, when Instant Communication is enabled, and
 		 *  - robust management frames except disassoc.
 		 */
 		if (!ether_addr_equal(sdata->u.nan.conf.cluster_id, hdr->addr3))
@@ -4691,6 +4698,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (ieee80211_is_auth(hdr->frame_control) &&
 		    ether_addr_equal(sdata->vif.addr, hdr->addr1))
 			return true;
+		if (nan_beacon)
+			return sdata->u.nan.conf.instant_comm;
 		if (!ieee80211_is_disassoc(hdr->frame_control) &&
 		    ieee80211_is_robust_mgmt_frame(skb))
 			return true;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a4bca412e577..fc8d090bfd7c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -353,6 +353,10 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 		if (!ieee80211_is_s1g_beacon(mgmt->frame_control) &&
 		    !is_broadcast_ether_addr(mgmt->da))
 			return;
+
+		/* NAN beacons are not a BSS, don't add to the BSS table */
+		if (ieee80211_is_nan_beacon(mgmt, skb->len))
+			return;
 	}
 
 	/* Do not update the BSS table in case of only monitor interfaces */
-- 
2.34.1

