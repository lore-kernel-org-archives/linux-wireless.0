Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3D446C00
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109924; cv=none; b=Qmcs0Xp4dwuT/dzVW5ChMShr/7nUVIyG+mYEmQ0s9w+SCjT65T6bB36UIYjkauDSVWYtyvzQRPXpsrQLSarcdYaVzt1VG96S6wNZ1ul4YlwQdqoEuNJC14YjQm9ragRrilq41+txptVtrba5ECa22iHoHsM3yhy8EsWnlPP+TKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109924; c=relaxed/simple;
	bh=70rbNOtNs63e/UKfl7ehRujdDIugfxCS/6x09bymZD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PwggW2GSjv9lz3JcdqrBQQDdE9KhZrm44uGX1FlPvVcdyDxq+KKthzAuqdtw6xEvucPABbQRCmowGZ4TUFE/wsxN5gCCvz8wxNmiiesnpvldeci5KgDu3p3YXgpXumqNyppm4Shozs7DRKoCNRLJHxA+TczXF7hHL+mTYuQ1npA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=NMqIfFuH; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="NMqIfFuH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1789109917; x=1820645917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=70rbNOtNs63e/UKfl7ehRujdDIugfxCS/6x09bymZD8=;
  b=NMqIfFuHyXSevu96vIAVNpJk+v7Gm7YJdhp/YGBIeqr2i3pBfWe8ILqm
   qnZw512MhOoLh97Vys5V8rTWawUTxizIqvi5+urIeqoIg5aRNv6T42qah
   Ne4MBZthW/KAfBjMYkOmIFY2H9vVMV0Syj17NmzbDkHjxhSZGIvSirVSQ
   8=;
X-CSE-ConnectionGUID: uj2evjEhQ+2lFHij1RbTng==
X-CSE-MsgGUID: n8jir+qpSiS1giyhfsJkPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="178082309"
X-IronPort-AV: E=Sophos;i="6.27,96,1787004000"; 
   d="scan'208";a="178082309"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:57:22 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 11 Sep
 2026 08:57:21 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:57:19 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <brcm80211@lists.linux.dev>,
	<wlan-kernel-dev-list@infineon.com>
Subject: [PATCH v6 1/5] wifi: nl80211: add fast roam offload extended feature
Date: Fri, 11 Sep 2026 14:56:52 +0800
Message-ID: <20260911065656.1269623-2-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911065656.1269623-1-Jason.Huang2@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260911065656.1269623-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE813.infineon.com (172.23.29.39) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Drivers can offload FT or OKC roaming without necessarily advertising
full 802.1X 4-way handshake offload. Add an extended feature bit for
that capability and allow PMK configuration when it is present.

This gives userspace a way to provide PMK or PMK-R0 material needed by
fast roaming firmware implementations while keeping the existing 4-way
handshake offload capability unchanged.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..920d5e2d9966 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7110,6 +7110,10 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
  *
+ * @NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD: Driver supports fast roaming
+ *	offload in station mode, including Fast Transition or Opportunistic
+ *	Key Caching.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7192,6 +7196,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..e4850129a582 100644
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
@@ -18442,7 +18443,9 @@ static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+	if (!wiphy_ext_feature_isset(wiphy,
+				     NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD) &&
+	    !wiphy_ext_feature_isset(wiphy,
 				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
 		return -EOPNOTSUPP;
 
@@ -18472,6 +18475,7 @@ static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wiphy *wiphy = &rdev->wiphy;
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const u8 *aa;
@@ -18480,7 +18484,9 @@ static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+	if (!wiphy_ext_feature_isset(wiphy,
+				     NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD) &&
+	    !wiphy_ext_feature_isset(wiphy,
 				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
 		return -EOPNOTSUPP;
 
-- 
2.25.1

