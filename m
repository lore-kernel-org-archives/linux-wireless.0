Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D935FF58;
	Tue,  4 Aug 2026 03:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785812816; cv=none; b=co2oWw3Fiz4hSt7b14t37/Js79lCsdOwIAoKFc1DF/XViZTq2H/JCzGbw1dqoz8kqT05F9pypMnA0cI8VAriPa0Ql1trTIBLkQ6w9hx8cbcboGYstJCCz39w4UkHlNBiAPj3nf2LmVc/SxSLp9LzL6kl0z+M3+DBQzjmbsHViO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785812816; c=relaxed/simple;
	bh=k0mMFqdpUeIGUJWcE8zf8upLpurr6N8tRtReEiW/iuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IpBA57f6v8s/u05kY2uZPTknIaLm2M8STh7OY+wlEYl+PrW7dlCm9YVwGIamBNYCq3ONpbGLKGnZb1xSBEYMgIgAxLMHdejPMGWsqNW7W430ahoUK1n1jWEM/KL/3a+pxUGAonVV60amXN+/IBLN7L3j7b9an0tsxwvm1lBDc2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=BmzRu1Xy; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="BmzRu1Xy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785812814; x=1817348814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0mMFqdpUeIGUJWcE8zf8upLpurr6N8tRtReEiW/iuE=;
  b=BmzRu1Xy9esaEzfVMkrSuEgkrcgC3R/1tMa7j9ceiqAdMBD43yCZme53
   u3EPUynjNKfsVlqenYfHa5EkaHc6JCSlreWrFIJXhDTzLxQ16PSP+6teh
   ScMJPicWBtQPZtS1df0BgElTLM5NR69leSQYwbLdugfUSfPFC6S93r5zd
   M=;
X-CSE-ConnectionGUID: e5O7K65tQwOZzJazrS1zmQ==
X-CSE-MsgGUID: JqlvlVO4SgyC8ZTQvZtnVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="140544365"
X-IronPort-AV: E=Sophos;i="6.25,203,1779141600"; 
   d="scan'208";a="140544365"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 05:05:43 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 05:05:43 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 4 Aug 2026 05:05:41 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Jason Huang <jason.huang2@infineon.com>, Carella Chen
	<carella.chen@infineon.com>, Johannes Berg <johannes@sipsolutions.net>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] wifi: nl80211: add roam offload extended feature
Date: Tue, 4 Aug 2026 11:04:49 +0800
Message-ID: <20260804030450.232028-2-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260804030450.232028-1-Jason.Huang2@infineon.com>
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
 MUCSE809.infineon.com (172.23.29.35)

From: Jason Huang <jason.huang2@infineon.com>

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
index 66b4cfd8de86..2b96a18def9b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -7112,6 +7112,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_PROBE_AP: Driver supports probing the associated AP
  *	in STA mode using @NL80211_CMD_PROBE_PEER.
  *
+ * @NL80211_EXT_FEATURE_ROAM_OFFLOAD: Driver supports Fast Transition or
+ *	Opportunistic Key Caching roaming offload in station mode.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -7194,6 +7197,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ROC_ADDR_FILTER,
 	NL80211_EXT_FEATURE_SET_KEY_LTF_SEED,
 	NL80211_EXT_FEATURE_PROBE_AP,
+	NL80211_EXT_FEATURE_ROAM_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 55161ddb56b4..7dbd4caf2609 100644
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

