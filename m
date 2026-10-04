Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994FB48F83B
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140499; cv=none; b=hlnhP6PNz3Jcar6+G2GSHMjHhYNuOuedNBeuszt2ICdX2Jo8U9MJr8SdozNx/SsAozX1AnQHum/GMMXfXP//wnrwByozk5YFDLa1h572iPnits8p8/7mtXyFKxm1/9ruqf1VEfZnjGq2d+nNFe2Z6Ls9zvvxrjgBwGf2PMDGqKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140499; c=relaxed/simple;
	bh=Cr+xZbYOtVVJCKyD41+sdr69Mr/m46GlDJ8LZ75jNIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndougtNj0LVS57ysyEHJ6MrpJ58EdkdyAty4TiR/ET/XWLCBvJVhqPRAhmniYX79J70z7D/z4Ih1S/OUDchJDzzHyzti4U43yTf15v0Bb1osm7zCwKFBHgqkjBy+fx8t9ucjZ7Be5ZLFqjuJ9/4PZjCiT+aLbg+YPD44ebGq0Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EXfExF6u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EXfExF6u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fKHHik5MiDtW3gewfyfeO+T/VlUNy2g5OO32T+uGVOU=;
	t=1791140493; x=1792350093; b=EXfExF6uhLUE6Ly6ZlfNlNcFDSu8rTNC9LSA4mKI5p4ysBv
	cKkFteMgjWgHQXpqM7CHJ8pObVP0xqw1Lvk/Bfx0F/7ZA2Uf6PGvlWwyQXXFvCUkHUP9erxUI9pFO
	unjQ8zT7TJpe7PmlgvyZ0FP/ujJ33bvWJzbMTGLlT0j1fGjDIJnJaHRt3qs674Gkf3kQgdvGRHVHi
	hl/YKhlM+v+pPV1g5kv93caGW/PNLzGyoSGE3j/xj34bEN+BAUr/wCKCKUTj+mkqfKqJ3IdHKOHlO
	N5LT8RZ3qWSL9Wb2fsKktAtgXHi7QdGubDqxLxdw2W8C9LE6j3p+iMu9Ap607hVA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSj-00000004Jlo-2nZE;
	Sun, 04 Oct 2026 21:01:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 06/18] wifi: cfg80211: reg: set intersected regd under wiphy mutex
Date: Sun,  4 Oct 2026 21:01:20 +0200
Message-ID: <20261004210122.1976c4c8f0b3.Id7ac6e91aecb976f1897aa3a211a3eb7c871831e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When regulatory request is intersected, the wiphy's regd
is replaced holding only the RTNL, while the non-intersected
case holds the wiphy mutex - we document access to need it.

Current readers that don't hold RTNL also don't get into it,
but it's more consistent and I want to remove the RTNL later.

Also move the similar code in reg_process_hint_driver() to
the same pattern as preparation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1a67d146bf2b..ed4d43a8cb78 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2859,12 +2859,12 @@ reg_process_hint_driver(struct wiphy *wiphy,
 		if (IS_ERR(regd))
 			return REG_REQ_IGNORE;
 
-		tmp = get_wiphy_regdom(wiphy);
 		ASSERT_RTNL();
 		scoped_guard(wiphy, wiphy) {
+			tmp = get_wiphy_regdom(wiphy);
 			rcu_assign_pointer(wiphy->regd, regd);
+			rcu_free_regdom(tmp);
 		}
-		rcu_free_regdom(tmp);
 	}
 
 
@@ -3946,9 +3946,11 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 	 * However if a driver requested this specific regulatory
 	 * domain we keep it for its private use
 	 */
-	tmp = get_wiphy_regdom(request_wiphy);
-	rcu_assign_pointer(request_wiphy->regd, rd);
-	rcu_free_regdom(tmp);
+	scoped_guard(wiphy, request_wiphy) {
+		tmp = get_wiphy_regdom(request_wiphy);
+		rcu_assign_pointer(request_wiphy->regd, rd);
+		rcu_free_regdom(tmp);
+	}
 
 	rd = NULL;
 
-- 
2.55.0

