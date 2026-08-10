Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574FD3C2788;
	Mon, 10 Aug 2026 11:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362081; cv=none; b=lG8lB08MK3AcfKxTh2PvLS03QHC0XDxzvLCFJZN1tokOGP7A5c04hsOCPPTKug9FOGNOchOqUaEHuqBOxo8FMKEltIP5U0gfXUju40vC8gWwZjR9WmiczcNYDMNbuOPlWzAhJmi0djwYSEswtQqtmVEdljcDkDzMPBEYVXArBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362081; c=relaxed/simple;
	bh=MdaqnZs1i3Nq7L2e0On6hLwE7gYhrMzDrCG2lCeYFGw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=D6lgzTqpfCdXyEMUmSQY+GDo1HQqHctCKrIHOiJ/Lu9SZjv0Pj6aGevMoW9x1Y7ZWQKx4pXzGaOFr3eGF2OPwJ/kbW/99+zj9FHpjF4SSpmk4/qdE14iYNbcdA9KVt6h14aJd1xLIWkQAxt0a1sloMUZYdhHS/VTAaY9M0Dic0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=kljmISA9; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="kljmISA9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786362080; x=1817898080;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=MdaqnZs1i3Nq7L2e0On6hLwE7gYhrMzDrCG2lCeYFGw=;
  b=kljmISA9YCfsA8Um/20HUXP7NBXykE9FhZER1BpXrv04Kxzi1xHk4Ft2
   Un9OqV1zQn5cv06nQ/G0rNptTUDtGTGfmXOWMQ7sH8Rk8oi4ondSxgTPr
   DujKYTFMBx8tJT7l3j55lvGG1iUcoWNzP2rBeV7mC7WMZRcqbzlralLJ1
   4=;
X-CSE-ConnectionGUID: wFe7xneaSUmiMgeobyrISA==
X-CSE-MsgGUID: enFA3U8xTHCqnrPwE1WrwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="141358284"
X-IronPort-AV: E=Sophos;i="6.25,215,1779141600"; 
   d="scan'208";a="141358284"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 13:41:11 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 13:41:10 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 13:41:07 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
Date: Mon, 10 Aug 2026 19:40:53 +0800
Subject: [PATCH v3 1/5] wifi: nl80211: add roam offload extended feature
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260810-upstream-wireless-next-main-jason-11r-support-v1-v3-1-bce4f460ae0b@infineon.com>
References: <20260810-upstream-wireless-next-main-jason-11r-support-v1-v3-0-bce4f460ae0b@infineon.com>
In-Reply-To: <20260810-upstream-wireless-next-main-jason-11r-support-v1-v3-0-bce4f460ae0b@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <linux-kernel@vger.kernel.org>,
	<brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
	<wlan-kernel-dev-list@infineon.com>, <jeff.johnson@oss.qualcomm.com>,
	"Carella Chen" <carella.chen@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786362064; l=2272;
 i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id;
 bh=ELFlua0+LpTSCULhS4qD6AFxLSTiR48GcknAGiwMJNg=;
 b=0tZPN9+C7qPo8+l3OV9Fv76O1gRXIYtjDNQFrLgA/2mp6L81fvZF1N8Y4kRZCnAG+V43yHFqG
 x7msbw8p5wuBVtnI4UHIPHXpGZWY4qunmsLIfp6BnejvpBpflCQoMLg
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519;
 pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
X-ClientProxiedBy: MUCSE815.infineon.com (172.23.29.41) To
 MUCSE809.infineon.com (172.23.29.35)

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

