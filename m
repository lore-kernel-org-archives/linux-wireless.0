Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F97042D75A;
	Wed,  5 Aug 2026 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785927712; cv=none; b=e702e5ucxKdVzq3gLMJMkXTeFJscp/mGL12Z8dqQuryVbjSjA1ttW+l9NOwo1Gu7PZgIEv/5a5gLnT/VxVY0cWfO8tNO3bQKzDK5tLLlQYypQc9oPzIWnzAaAkB+Vt72UzvbBF8+MquZySZxE8aVV2F+Cs0O1bvGgrBiav3sZSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785927712; c=relaxed/simple;
	bh=k0mMFqdpUeIGUJWcE8zf8upLpurr6N8tRtReEiW/iuE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TaUSvcFgVNel4mWeLfuk6954X6x8u5HN5Tjz2LAgMrjyp+ROuRMHp3qpsepQehcsFWbbD7xIPeHqrtlkPTAL/lpuKBrBJUgy5mjLkoyRujKnBcNLZVsTFnAP6a1qe7RlYYDGdMgEY7NYyYN7EOxVg8vzvH+1P6i4Mabs2d6ALPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=h85lqeJO; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="h85lqeJO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785927709; x=1817463709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k0mMFqdpUeIGUJWcE8zf8upLpurr6N8tRtReEiW/iuE=;
  b=h85lqeJOqzI2QWCWBoqwRiarrRWP2Y/8uTMtCuf9DQDzq55O0qSy6ixt
   mONRpZ2xidRRD/2+WIVHOLHxaYc1jStbxLvU4kngtLYuLircCzb+D2Fxg
   HWPJnMp0LGhxOBplr8lw1Z3o0zPU2ZX7N+RoaRByP92tq7FbVeK7cwILn
   s=;
X-CSE-ConnectionGUID: 83XlJYR1SwirlFjVegv2Rg==
X-CSE-MsgGUID: AXoC4P63R26CECiWrVMt0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="154630386"
X-IronPort-AV: E=Sophos;i="6.25,206,1779141600"; 
   d="scan'208";a="154630386"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 13:01:38 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 5 Aug
 2026 13:01:37 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 13:01:35 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <wlan-kernel-dev-list@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>, Carella Chen <carella.chen@infineon.com>,
	Johannes Berg <johannes@sipsolutions.net>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] wifi: nl80211: add roam offload extended feature
Date: Wed, 5 Aug 2026 19:01:16 +0800
Message-ID: <20260805110116.35884-3-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260805110116.35884-1-Jason.Huang2@infineon.com>
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
 <20260805110116.35884-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE821.infineon.com (172.23.29.47) To
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

