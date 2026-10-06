Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEF21E260C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281231; cv=none; b=s7VL/ybOo/x5iPJ16yQvdAfFv1XkFxNKk+iXw5wzkjBq7hQyTwFcZ4eEZF7GkJSHXWtacr9keIb8jdIA0V55QwBwZq8uSm/jME1mgvAtSQ7tXxEaU0dcRPEciEfvCfidVibIARCPjXdt3NYNy6I/QaLulOiFI9/AOlOgFSgW2Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281231; c=relaxed/simple;
	bh=LSp662n3xigHAHE2xkrVYRtBKZN23gk39MWF8Zpdt0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj52Xz9vf2UXf7LO7hLiksTKWdRJ72ESG3a3uMDWNKAFNg+lm+bCI5HgZ1tf2DdvnRV8yUsgqn4PBM/py2HlFMlukF2cluqky4PSWJcHxlHsyE8v6dSZAVKymCozdWRlRMcPdulmKfETu0KLtb+ZpDipVzrp4+ws753xCupxBOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qsTez3O7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qsTez3O7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YApw3qQZZ+vzP78uY2MYad2TZchPsGeAdtLuHQvUiKc=;
	t=1791281229; x=1792490829; b=qsTez3O7Uzfo7PQG4U+yfiifuGd5+cUkpu9usZ9Zv3WW0Zc
	9QVSZGTpBR/+3JotD5HhCMkQksVGZA/lRZ5G3Fj8gxW+NWZvvFq6310Mtplppn8fDumYivcYsfmLJ
	4CM3wLHBC9hFo+H7hn5sdAKStJR1hek6d4CNTMwiZpX0QaoClekXdMqK80X/vY7V4zGQhNsf2NJCt
	N3i3JEY8WSAxtN99f2NaD0hSVXKsuaj/9xkQARHhJp/UQLAnu6DMghJhmhOjnfFm0PnOWcF9NxLvj
	qkH341ctcI6gnCLpgIHS4OKKUjE2LuiPpfVnCdk/9Hg0WxAdqMaeAjo9TZmyq5VA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24h-00000006XqW-2NOZ;
	Tue, 06 Oct 2026 12:07:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 07/19] wifi: cfg80211: reg: set intersected regd under wiphy mutex
Date: Tue,  6 Oct 2026 12:04:05 +0200
Message-ID: <20261006120655.a60980246fcb.Id7ac6e91aecb976f1897aa3a211a3eb7c871831e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006100655.2687533-21-johannes@sipsolutions.net>
References: <20261006100655.2687533-21-johannes@sipsolutions.net>
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
index 1626a9b7c7c9..13d6fc5a56aa 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2865,12 +2865,12 @@ reg_process_hint_driver(struct wiphy *wiphy,
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
 
 
@@ -3952,9 +3952,11 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
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

