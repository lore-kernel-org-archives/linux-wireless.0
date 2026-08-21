Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996543932DB;
	Fri, 21 Aug 2026 07:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299016; cv=none; b=mKTF1diFBtREjWvDsZTxaBoJOdar4kWW6WkgMjb0gasfFdOztjGrQSADQOxFCZC5pMOrCfRGLi4fGexjQL4F8aNj5Q1MoBEnp0KhTI2CJ15PC8bEjUPNu2KQVGvZalCehkKIiBZ35WJlbTolX2uN1Sk+IfIYlLCjG8WOEtnf9ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299016; c=relaxed/simple;
	bh=+onrYa/k5oO0PS6kqA40NrjwtkOJgeqpwE4W0k9mQmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPm5exe1/AVzM2zC1JTOQ3hElKVFYrqlqcaU26qY3gIyviEmFawVyMGhQ18yO15FoAtAuk3p5A/GMpdKqc5OgkDqSXfj2JiV4urXDp0o59F63RR5osfAe2cdf+NYgTY0tOJQzl6sdc/moLZmj5dCgZcz54GLKxyecdi+G/CVU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=d7Iu9pf1; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="d7Iu9pf1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787299015; x=1818835015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+onrYa/k5oO0PS6kqA40NrjwtkOJgeqpwE4W0k9mQmo=;
  b=d7Iu9pf1Qdu8A+W527p7FHZOSXYNbRktWTAWgROHiNZnkMiaf3eAR351
   1BCwg+qzT+I8Y1y3H9T/nLxPqF/j2fcjElp84p+8eEiyol7wwu3qy1csO
   7B4W0A1oK4LzaAFcAz5GPBIh1fuN5vwoX2IfCDRF2GgndvXsbbT/xe3T8
   w=;
X-CSE-ConnectionGUID: xB8GWDruThiciZOxOxJxdA==
X-CSE-MsgGUID: flS8wlQETrieuky/ZmiAGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="105579461"
X-IronPort-AV: E=Sophos;i="6.25,234,1779141600"; 
   d="scan'208";a="105579461"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:56:47 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 09:56:46 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:56:42 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes.berg@intel.com>, <johannes@sipsolutions.net>,
	<arend.vanspriel@broadcom.com>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Carella Chen <carella.chen@infineon.com>,
	Jason Huang <jason.huang2@infineon.com>
Subject: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
Date: Fri, 21 Aug 2026 15:56:13 +0800
Message-ID: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE812.infineon.com (172.23.29.38) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Drivers can offload FT or OKC roaming without necessarily
advertising full 802.1X 4-way handshake offload. Add an extended
feature bit for that capability and allow PMK configuration when it is
present.

This gives userspace a way to provide PMK or PMK-R0 material needed
by firmware roaming implementations while keeping the existing 4-way
handshake offload capability unchanged.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 7 +++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..9f8d9e3d5990 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7110,6 +7110,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
  *
+ * @NL80211_EXT_FEATURE_ROAM_OFFLOAD: Driver supports Fast Transition or
+ *	Opportunistic Key Caching roaming offload in station mode.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7192,6 +7195,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_ROAM_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..15731440c57a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18434,6 +18434,7 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wiphy *wiphy = &rdev->wiphy;
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_pmk_conf pmk_conf = {};
@@ -18442,8 +18443,10 @@ static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	if (!wiphy_ext_feature_isset(&rdev->wiphy,
-				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
+	if (!wiphy_ext_feature_isset(wiphy,
+				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
+	    !wiphy_ext_feature_isset(wiphy,
+				     NL80211_EXT_FEATURE_ROAM_OFFLOAD))
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_MAC] || !info->attrs[NL80211_ATTR_PMK])

-- 
2.25.1
