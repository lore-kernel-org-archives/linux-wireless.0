Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AFA375AB5
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120371; cv=none; b=eQ0K77+opNy+sbPzCcaJ9TcVJKQDMqXZmZS6MvLgedP2utQ/kh54oHNtEwEzaCB26619LST/quyJLNleq2cqV6c7IggaSsQVlizZ+61tg0uSp1A1fws8J60MZ9+4K2YL1NPjRFdqqDYr+mBwB0ijNkcOmS3WUsIOsIRRi1kKoCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120371; c=relaxed/simple;
	bh=sE/9IO/QHfhdXTRtZ0xbZVPi46FXVYCCeu/Nbn8vflw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/82HnnQfaseKfiEC5UP96e6KZsCjW60PP0clmM7M1HtyONxX3U536NQcQ+/Et3KiSB/1Cux9WDUMlr86He/0tBX0s7zqBN9OAgNvgPta5KiXjOS06LfsqrAl7oGxKp1T+AA6f1EuE84QjhD3aUtpjcswM90XKknFhJrhNxClSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fP/NtzGn; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fP/NtzGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120370; x=1822656370;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sE/9IO/QHfhdXTRtZ0xbZVPi46FXVYCCeu/Nbn8vflw=;
  b=fP/NtzGn2bzGmMD9HWk7xXYJfvk59yFhZZ9HUtKErlagByBdQpHZJizX
   V+7zqYbzBDQ4hAWGsB2QI9azcg++QbR/RTMLNUAMmkx8DEPcG6wQXtIbf
   7uaIBhiyra7hPKhWzurezJ2w9gTXa/Vw8TUuUh6qeJMXzyO2EK1YzK5sN
   +h4zhZTWXS/RFPuA6ZPxezUV0zDahqjmjN8klc49zs8A6a4K0l0+GMZiQ
   FvDtT3F7nM+QbfS/tRooWVQI1RRxxS6sb+HEveMmwTsZjYDUuI0j0NrQr
   Q/FacTHRJ4aoB4TIoFnWVVKBELdKF9oDd2CMR9TcwoggR6XgZwW/wjd4i
   w==;
X-CSE-ConnectionGUID: 2J7PniU/Q4atTVnizyBq1A==
X-CSE-MsgGUID: S4qNFCQRRJyC69OiKGZXOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328687"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328687"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:09 -0700
X-CSE-ConnectionGUID: EWINOBbbQoGnd4/7q3phFA==
X-CSE-MsgGUID: rOeeaKaCReC/aOzkgg0bRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569096"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:07 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 01/11] wifi: cfg80211: nan: add Instant Communication support
Date: Mon,  5 Oct 2026 10:40:26 +0300
Message-ID: <20261005074037.3506633-2-ilan.peer@intel.com>
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
index 97c16d4ff127..f9d590facfc0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4183,9 +4183,12 @@ struct cfg80211_nan_band_config {
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
@@ -4201,6 +4204,7 @@ struct cfg80211_nan_conf {
 	u16 scan_dwell_time;
 	u8 discovery_beacon_interval;
 	bool enable_dw_notification;
+	bool instant_comm;
 	struct cfg80211_nan_band_config band_cfgs[NUM_NL80211_BANDS];
 	const u8 *extra_nan_attrs;
 	u16 extra_nan_attrs_len;
@@ -6266,10 +6270,13 @@ struct wiphy_radio {
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
index 020387d76412..5ac9f02f5ad2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7826,6 +7826,11 @@ enum nl80211_nan_band_conf_attributes {
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
@@ -7841,6 +7846,7 @@ enum nl80211_nan_conf_attributes {
 	NL80211_NAN_CONF_SCAN_DWELL_TIME,
 	NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL,
 	NL80211_NAN_CONF_NOTIFY_DW,
+	NL80211_NAN_CONF_INSTANT_COMM,
 
 	/* keep last */
 	NUM_NL80211_NAN_CONF_ATTR,
@@ -9057,6 +9063,11 @@ enum nl80211_s1g_short_beacon_attrs {
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
@@ -9070,6 +9081,7 @@ enum nl80211_nan_capabilities {
 	NL80211_NAN_CAPA_MAX_CHANNEL_SWITCH_TIME,
 	NL80211_NAN_CAPA_CAPABILITIES,
 	NL80211_NAN_CAPA_PHY,
+	NL80211_NAN_CAPA_INSTANT_COMM,
 	/* keep last */
 	__NL80211_NAN_CAPABILITIES_LAST,
 	NL80211_NAN_CAPABILITIES_MAX = __NL80211_NAN_CAPABILITIES_LAST - 1,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..068db5de24f3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -888,6 +888,11 @@ int wiphy_register(struct wiphy *wiphy)
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
index 44f2bad08670..94d92b0ebc54 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -686,6 +686,7 @@ nl80211_nan_conf_policy[NL80211_NAN_CONF_ATTR_MAX + 1] = {
 	[NL80211_NAN_CONF_DISCOVERY_BEACON_INTERVAL] =
 		NLA_POLICY_RANGE(NLA_U8, 50, 200),
 	[NL80211_NAN_CONF_NOTIFY_DW] = { .type = NLA_FLAG },
+	[NL80211_NAN_CONF_INSTANT_COMM] = { .type = NLA_FLAG },
 };
 
 static const struct netlink_range_validation nl80211_punct_bitmap_range = {
@@ -3025,6 +3026,10 @@ static int nl80211_put_nan_capa(struct wiphy *wiphy, struct sk_buff *msg)
 	    nla_put_flag(msg, NL80211_NAN_CAPA_USERSPACE_DE))
 		goto fail;
 
+	if ((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM) &&
+	    nla_put_flag(msg, NL80211_NAN_CAPA_INSTANT_COMM))
+		goto fail;
+
 	if (nla_put_u8(msg, NL80211_NAN_CAPA_OP_MODE,
 		       wiphy->nan_capa.op_mode) ||
 	    nla_put_u8(msg, NL80211_NAN_CAPA_NUM_ANTENNAS,
@@ -16663,6 +16668,23 @@ static int nl80211_parse_nan_conf(struct wiphy *wiphy,
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
2.55.0

