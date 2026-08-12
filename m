Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962C41922F5
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 03:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786506353; cv=none; b=mLyj2gQ9Xig7rEi6Oonm2cIHb1RAlpCoLHsJlx1Y2d+RmVJZBphUFqJvgJ/BDQe96QMfmdFyj6NZoJEgSoBWR+0iTbVIbpcvPsclc+R1xE2UUftu8HYZ1r40ym1GeHglSmYNguibC5hHcAN7g5mzoC8VyQsLHd0VWBjlbePfgmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786506353; c=relaxed/simple;
	bh=MdaqnZs1i3Nq7L2e0On6hLwE7gYhrMzDrCG2lCeYFGw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jww8B5MYOhuq7fcnOALUsi4z9QGfbB27VpGv1rD+3EHgXhMUMKJzExo+22P5mrFk2iZuD0JBn12mnViTCmokgYwFsNS4uVhOXZu7iIOWgMJ3gqid61rodXgcc0qdW3y8ysb8ORhHotT1k7YXcocwbOu7qsy9gyvOpexSnORzn9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=g0SN801M; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="g0SN801M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786506352; x=1818042352;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=MdaqnZs1i3Nq7L2e0On6hLwE7gYhrMzDrCG2lCeYFGw=;
  b=g0SN801MA3kQJFKUN36cG+j/AAMI0RPeEUE2dsLslYT+1DLMtvF87qTS
   n+PKDleY9aS9NCrtrOu6rQlKJ6kuVI/YjYtfMELD4mhDjfFH8gLQRtKlQ
   KGr8FeKHVjBBYUWbKzWQEVqQFaCwE2JCE07Sd78WGrKCJoWYXPEgFvtun
   I=;
X-CSE-ConnectionGUID: gPqtVAf+SuKKmBahO+Tdkw==
X-CSE-MsgGUID: cbJpE66sQBqWhGfgCRBb/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="172173764"
X-IronPort-AV: E=Sophos;i="6.25,218,1779141600"; 
   d="scan'208";a="172173764"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 05:45:49 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 05:45:49 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 05:45:48 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: Jason Huang <Jason.Huang2@infineon.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 1/5] wifi: nl80211: add roam offload extended feature
Date: Wed, 12 Aug 2026 11:44:52 +0800
Message-ID: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-1-b1843e1f6de4@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
References: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786505858; l=2272; i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id; bh=ELFlua0+LpTSCULhS4qD6AFxLSTiR48GcknAGiwMJNg=; b=blNXGg1AgFdZPfvPqVbqkWaBLs6LUNNEqsk/TQTgqHedg5eELl/KbOFVfDTMY3VXnTW5iI5xU XanOeXhYrV0C3R4ynj6FCnYMBRpcoCjPkQNCIu/v2lM24tDa6jn0icK
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519; pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE817.infineon.com (172.23.29.43) To
 MUCSE809.infineon.com (172.23.29.35)
Message-ID: <20260812034452.BtT1AbebcvjeqkIXSVp26p0h1XCWgDm8aDUaW6waRV0@z>

From: Carella Chen <carella.chen@infineon.com>

Drivers can offload FT or OKC roaming without necessarily
advertising full 802.1X 4-way handshake offload. Add an extended
feature bit for that capability and allow PMK configuration when it is
present.

This gives userspace a way to provide PMK or PMK-R0 material needed
by firmware roaming implementations while keeping the existing 4-way
handshake offload capability unchanged.

Assisted-by: GitHub Copilot CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

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
index 44f2bad08670..492fb567ddb1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18443,7 +18443,9 @@ static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (!wiphy_ext_feature_isset(&rdev->wiphy,
-				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
+				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_ROAM_OFFLOAD))
 		return -EOPNOTSUPP;
 
 	if (!info->attrs[NL80211_ATTR_MAC] || !info->attrs[NL80211_ATTR_PMK])

-- 
2.25.1

