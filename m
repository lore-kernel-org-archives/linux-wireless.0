Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020DD490BE4
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861482; cv=none; b=D7HL/8TlxZ6p7PS/LFyVv8NGj4kYImx51YpDmh6t0I8aaM2n6R9Pmp6FtwxcWAcY6jlN00BxpIiXF1Lt6Th3l27IRIBobEhb0Hieg/2WNSyKiCkhGHN/gbRAYbssu1UenLz15WBrUZ/5Z+b3sWvIZPMCKEz12XXWO3XR34O4McI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861482; c=relaxed/simple;
	bh=c+aG5Oh7jSirG5jMPU7qMP1r0UnErEJQb+XMu3TOfUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GEBHTJAuBVLmJqDwl/Bon7m2ZnD3qDIahyPR7W5ZQ8L5rqJ205W+uGhFyZj1Tb6/sRjKIYiHGou7vsXJVR07jve7s7Yq14Jlgj0ek4G6b8vmOxmR5n31Q1MXW2nGmxveidg31m4O/oRG4xqyM39NebL0U+R37MbjJXaWlVDJVJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfKVsrxT; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfKVsrxT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861479; x=1822397479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c+aG5Oh7jSirG5jMPU7qMP1r0UnErEJQb+XMu3TOfUU=;
  b=EfKVsrxTatfduoR2s+r+78ue42rCRLSSCxgcUfWOa5mWWEsz/oKl6dYu
   cwroiZsdGFyh9Dvg3T+BOfEMLVAYqj4ytlSRhMGgsKMbh5CFNnCwDMqZe
   1Wi62iAlJMIbmjhunAJg6KvRn6ZqiZucT1lvJ0FjSqmL0gTQVEhTsy/mK
   VRX7v1FxdqjG+Aw+DCbTdPzbar+YCI+N1XvXUXsClcwIB/hfswFw+PkdW
   3qbQkX3bEUXyoTT4Pz25UiV0RMRok30zfbQ/Ystkv0lmqVI4xTzZI9WxB
   8fKLFQ1kBcqwG5AxcNMkDKKNnuLfv+rAj3ARxuYUM+ylWgTOiCuDeEsXg
   w==;
X-CSE-ConnectionGUID: pwQgrqzORaWnT47MPhxjnw==
X-CSE-MsgGUID: +IFPIUM5QPOCTlFY7iOB2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750516"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750516"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:16 -0700
X-CSE-ConnectionGUID: qtQH4VDMSwmgjuxImnknow==
X-CSE-MsgGUID: IszHDZbcS7S7gx5ETXCDoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26426"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:15 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 1/7] wifi: cfg80211: nan: add Instant Communication support
Date: Thu,  1 Oct 2026 16:33:05 +0300
Message-Id: <20261001162941.ca5837ac07fd.Ieb5c10ae76a465bdeeadb77324e6920076e03cb4@changeid>
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

Add NL80211_NAN_CONF_INSTANT_COMM flag to let user space request that
the NAN synchronization logic starts Instant Communication (IC) as
defined in Chapter 13 of the Wi-Fi Aware Specification v4.0.

Add NL80211_NAN_CAPA_INSTANT_COMM for drivers to advertise it. The
capability requires configurable synchronization support, and IC
requests are rejected if it isn't advertised.

When IC is enabled, user space must also configure the discovery
beacon interval. The IC schedule is expected to be configured
by user space.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/cfg80211.h       |  9 ++++++++-
 include/uapi/linux/nl80211.h | 12 ++++++++++++
 net/wireless/core.c          |  5 +++++
 net/wireless/nl80211.c       | 22 ++++++++++++++++++++++
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b603f1804cc2..96b5bf8b8ff3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4191,9 +4191,12 @@ struct cfg80211_nan_band_config {
  *	that can take a value from 50-6F-9A-01-00-00 to 50-6F-9A-01-FF-FF.
  * @scan_period: period (in seconds) between NAN scans.
  * @scan_dwell_time: dwell time (in milliseconds) for NAN scans.
- * @discovery_beacon_interval: interval (in TUs) for discovery beacons.
+ * @discovery_beacon_interval: interval (in TUs) for discovery beacons. Must be
+ *	greater than 0 when @instant_comm is true.
  * @enable_dw_notification: flag to enable/disable discovery window
  *	notifications.
+ * @instant_comm: if true, start Instant Communication (IC) as defined in
+ *	Chapter 13 of the Wi-Fi Aware Specification v4.0.
  * @band_cfgs: array of band specific configurations, indexed by
  *	&enum nl80211_band values.
  * @extra_nan_attrs: pointer to additional NAN attributes.
@@ -4209,6 +4212,7 @@ struct cfg80211_nan_conf {
 	u16 scan_dwell_time;
 	u8 discovery_beacon_interval;
 	bool enable_dw_notification;
+	bool instant_comm;
 	struct cfg80211_nan_band_config band_cfgs[NUM_NL80211_BANDS];
 	const u8 *extra_nan_attrs;
 	u16 extra_nan_attrs_len;
@@ -6305,10 +6309,13 @@ struct wiphy_radio {
  * @WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC: Device supports NAN configurable
  *     synchronization.
  * @WIPHY_NAN_FLAGS_USERSPACE_DE: Device doesn't support DE offload.
+ * @WIPHY_NAN_FLAGS_INSTANT_COMM: Device can switch to Instant Communication
+ *     (IC) mode. Can only be set along with %WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC.
  */
 enum wiphy_nan_flags {
 	WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC = BIT(0),
 	WIPHY_NAN_FLAGS_USERSPACE_DE   = BIT(1),
+	WIPHY_NAN_FLAGS_INSTANT_COMM = BIT(2),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 75d4c5d6a7a3..21d98c1ec424 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7890,6 +7890,11 @@ enum nl80211_nan_band_conf_attributes {
  *	the upcoming discovery window with
  *	%NL80211_CMD_NAN_NEXT_DW_NOTIFICATION.
  *	This is a flag attribute.
+ * @NL80211_NAN_CONF_INSTANT_COMM: If set, the NAN synchronization logic will
+ *	start Instant Communication (IC) as defined in Chapter 13 of the
+ *	Wi-Fi Aware Specification v4.0.
+ *	%NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL must be set as well.
+ *	This is a flag attribute.
  * @NUM_NL80211_NAN_CONF_ATTR: Internal.
  * @NL80211_NAN_CONF_ATTR_MAX: Highest NAN configuration attribute.
  *
@@ -7905,6 +7910,7 @@ enum nl80211_nan_conf_attributes {
 	NL80211_NAN_CONF_SCAN_DWELL_TIME,
 	NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL,
 	NL80211_NAN_CONF_NOTIFY_DW,
+	NL80211_NAN_CONF_INSTANT_COMM,
 
 	/* keep last */
 	NUM_NL80211_NAN_CONF_ATTR,
@@ -9121,6 +9127,11 @@ enum nl80211_s1g_short_beacon_attrs {
  *	specification Table 79 (Capabilities field).
  * @NL80211_NAN_CAPA_PHY: nested attribute containing band-agnostic
  *	capabilities for NAN data path. See &enum nl80211_nan_phy_cap_attr.
+ * @NL80211_NAN_CAPA_INSTANT_COMM: Flag attribute indicating that the device
+ *	can switch to Instant Communication (IC) mode, as defined in Chapter 13
+ *	of the Wi-Fi Aware Specification v4.0. Can only be set if
+ *	%NL80211_NAN_CAPA_CONFIGURABLE_SYNC is set. When IC is enabled, the IC
+ *	schedule is expected to be configured by user space.
  * @__NL80211_NAN_CAPABILITIES_LAST: Internal
  * @NL80211_NAN_CAPABILITIES_MAX: Highest NAN capability attribute.
  */
@@ -9134,6 +9145,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_MAX_CHANNEL_SWITCH_TIME,
 	NL80211_NAN_CAPA_CAPABILITIES,
 	NL80211_NAN_CAPA_PHY,
+	NL80211_NAN_CAPA_INSTANT_COMM,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index dc1e0522340a..9176659345f0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -964,6 +964,11 @@ int wiphy_register(struct wiphy *wiphy)
 		    (!wiphy->nan_capa.phy.ht.ht_supported || wiphy->n_radio > 1)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM) &&
+		    !(wiphy->nan_capa.flags &
+		      WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC)))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS)))
 		return -EINVAL;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 16c63383923b..fa4379955dea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -687,6 +687,7 @@ nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 	[NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL] =
 		NLA_POLICY_RANGE(NLA_U8, 50, 200),
 	[NL80211_NAN_CONF_NOTIFY_DW] = { .type = NLA_FLAG },
+	[NL80211_NAN_CONF_INSTANT_COMM] = { .type = NLA_FLAG },
 };
 
 static const struct netlink_range_validation nl80211_punct_bitmap_range = {
@@ -3036,6 +3037,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_USERSPACE_DE))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_INSTANT_COMM))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
@@ -16780,6 +16785,23 @@ static int nl80211_parse_nan_conf(struct wiphy *wiphy,
 		conf->enable_dw_notification =
 			nla_get_flag(attrs[NL80211_NAN_CONF_NOTIFY_DW]);
 
+	conf->instant_comm = nla_get_flag(attrs[NL80211_NAN_CONF_INSTANT_COMM]);
+	if (conf->instant_comm) {
+		if (!(wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[NL80211_NAN_CONF_INSTANT_COMM],
+					    "Instant Communication is not supported");
+			return -EOPNOTSUPP;
+		}
+
+		if (!conf->discovery_beacon_interval) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    attrs[NL80211_NAN_CONF_INSTANT_COMM],
+					    "Instant Communication requires a discovery beacon interval");
+			return -EINVAL;
+		}
+	}
+
 out:
 	if (!conf->band_cfgs[NL80211_BAND_5GHZ].chan &&
 	    (!conf->bands || conf->bands & BIT(NL80211_BAND_5GHZ))) {
-- 
2.34.1

