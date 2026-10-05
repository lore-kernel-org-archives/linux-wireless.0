Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED847426E
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194744; cv=none; b=ACHO+Dox9lPUIeAwTpkOnVaOlyho0o/xO2Vo1333ASaBwR/056CO1BSFgfxfWFk/C+X7I0saVOwUeGHVtUQOE+AQrydDm+lQTKcAyPB00L5GHZK2KWNgWpmuGdX2iipaYKY3cm2SuBV/4gSi/xowFhleRet+UPoV81GVF7/Ne+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194744; c=relaxed/simple;
	bh=Cr+xZbYOtVVJCKyD41+sdr69Mr/m46GlDJ8LZ75jNIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY8KvPQje1sl5mUMiQFaUsNEIJPE5ZCb94S+NdLvX+Fbpj+1M9Fnk3a6emt5OEI71d1lrKGCvHF7WxR+3o/oCG/R2lWeJPaq2sNHn21xku2UNVtRkrQG33/TRqhEADaHS3Fg6G/OW77WbBfojzgptE2MI254rjQYw6HVRE6zjUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CzLnOVq6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CzLnOVq6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fKHHik5MiDtW3gewfyfeO+T/VlUNy2g5OO32T+uGVOU=;
	t=1791194741; x=1792404341; b=CzLnOVq6ix917lzFpDY4LFa6zDwm2v1HKmDfTarzUdy/y+F
	x5oPJS13X9bUxluuog3FDt0i4SQqVyVC38m9cw5iiKxRCv7R69VWo2r3T/Gy06CFviTGQKZQUbKaq
	QLqX+QfC9Re+XGxIbEarXv85rxyB01TaA0w5xMv9bSPB85QVwZR8kPCzvl9SotuLNiTYRkm/5WL6G
	s1LosmFje8U/d1l/mcFqgaA21jIxTgvHQ4c5CmzCS2fB/JxmjZRUj8LZPT66DjpHxz31wXIX9oHq1
	wSd57ABrBU+wDaCyWAArDbaqpM0d3UrgoCq+wtx2h4akKFkIpcsu+yYrpcjb1IjA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZg-00000005Bml-40sx;
	Mon, 05 Oct 2026 12:05:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 06/18] wifi: cfg80211: reg: set intersected regd under wiphy mutex
Date: Mon,  5 Oct 2026 12:03:33 +0200
Message-ID: <20261005120526.8e1edc77d053.Id7ac6e91aecb976f1897aa3a211a3eb7c871831e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005100525.1991059-20-johannes@sipsolutions.net>
References: <20261005100525.1991059-20-johannes@sipsolutions.net>
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

