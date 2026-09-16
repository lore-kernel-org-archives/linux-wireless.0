Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA644A99B0
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552920; cv=none; b=NJOmK0nPl2gLOZV8KumNGazjwoxDNJepX1YDbp9ohLBC1ue1+Dl2zpqK7/ve9AssE+QjVOWZbtxesAfc7ddQNrYKUqJ8x5GAKvlu+n6gwKcf8/i6X59mFBPR6h8v5CQXq6EtWdLrkOg+bq7cnU+FYsKwFxKP6vui88NUAQBv5wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552920; c=relaxed/simple;
	bh=nTzxdQMiGir6DJVTUK1B273qbbcmsTejXnE8upxOr68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y0D396DyhtBYmFIamBWQE9LoOhklotrKg/vbjxlXDUbRD0bgj5EWQxXwTIVSTHZnPfbZhJpJE4B2WbpDv5b9yirsLNg0uc7pj+h3H/X7JiUWO/HDj82XjhzAI2RAVpCByTDEh1Z+D6F46R/JgxXXtMC47x14viaWPgdGWi+ilII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NcvN8vFI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NcvN8vFI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=55g/XW6iL32Sv6GtGWeUV7V1FeFTfdW8I6MDQ05RbX8=; t=1789552896; x=1790762496; 
	b=NcvN8vFIBnvp2XxLu9mslehZVz970a2nm3hi3fQ9m76jSwny8RMv7Ao7L8K6pglGodAgwfvHgFi
	GzVG+juM8cVwYDESjUwunwsZE5DsPvIKTriOJFCCco/QzpRLvyLsI5/qAvpuUna8EnIeUwRQFf30C
	n8fHrxnai+Gq2q85hsAc2f85OiRpyuavtq8Sn2H8DOQKWbvPHS/eWL0PIP136tP1DEB2PqmHbkEYm
	V/4MuL+iqwG7eTghm/AtA6jsjQuKBMp4I7vWheInBSefH/HK2yhe0kIfr/0t7xUHF1wRKL8n6c/KG
	TnXj0yrca4ZhYBavFKKFHcFkXwkFBVEIkUog==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mSJ-00000000bUb-17uR;
	Wed, 16 Sep 2026 12:01:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: WARN on 40 MHz HT/HE mismatch
Date: Wed, 16 Sep 2026 12:01:26 +0200
Message-ID: <20260916120127.efa58d51d11f.Ie29dc83578893945231db3badfcb7b4a2e2775ba@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This happened to me and was tricky to debug, of course it
shouldn't happen with correct drivers, WARN in this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..ecd16374e4a1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1322,12 +1322,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G;
 
 			/* currently no support for HE client where HT has 40 MHz but not HT */
-			if (iftd->he_cap.has_he &&
-			    iftd->types_mask & (BIT(NL80211_IFTYPE_STATION) |
-						BIT(NL80211_IFTYPE_P2P_CLIENT)) &&
-			    sband->ht_cap.ht_supported &&
-			    sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
-			    !(iftd->he_cap.he_cap_elem.phy_cap_info[0] & he_40_mhz_cap))
+			if (WARN_ON(iftd->he_cap.has_he &&
+				    iftd->types_mask & (BIT(NL80211_IFTYPE_STATION) |
+							BIT(NL80211_IFTYPE_P2P_CLIENT)) &&
+				    sband->ht_cap.ht_supported &&
+				    sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
+				    !(iftd->he_cap.he_cap_elem.phy_cap_info[0] &
+				      he_40_mhz_cap)))
 				return -EINVAL;
 
 			/* no support for per-band vendor elems with MLO */
-- 
2.55.0

