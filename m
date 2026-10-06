Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5F53DA7EC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281240; cv=none; b=N2zFWhCUtIQ5qDznQlTsovLnh2qwGQPuTT3sjcmcgxQ23mKbhyJAlaFmISLWxoB0Y6JPu9Yr7IRelsEyfipMn1JO3g0B1X4Cc5l/arOOvFGT5axjGPdFLiNwYwswEN3vFOHivsDE79LigbSTI4hS6QUS5+f2KlazpnATUgZkIv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281240; c=relaxed/simple;
	bh=UQqU3y9osYKaOFK2i5MYqPJr+ULSb81iCAB0lxlJ7co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCupCdK/Dvej7d6NQTnfOh/KfTgXsD27xZG1YcYK2WMiAApk8yEgvA6a5Qaqt7pGDSzVQWc+/i46px9vCmOVV2ES4g6cZnlc1W6om1YTrMlnT963E0p1AQsDSvyHsJDfb2ZjBPWtSwLweUd7DK5A6shRn4ZZk+WyEBAyOwL8m04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XlcoywSl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XlcoywSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=k3rZJ8qqKCV1wrOCaYFIyEpF7OroYIMG0uTpcbHNSbk=;
	t=1791281236; x=1792490836; b=XlcoywSlEkYYkAx+3Mnac10usNW8k0b96uo7x8dd6n9O//4
	g1LNHGx6ze3zYfUw4OYZ+0YKWT8Wt5K3q8EJzhOpjP0WcBd0jyoODzYxmsL8ImvEMGqy726uPdx2k
	ZypoGCQ9rhGcFs+64Tg8vQN/5Ko1RMv2tsfLpRVuh7Y3l+e+j2Oe2vQfTHYmgfqTnWrUZK2JQyeAS
	gqddko3eCrIInrapgkEB1fKRWxZ3jCdTbFAhqI+9+swQcPpS5q2ukAbLvRL7Zt5m1uj+C1Nmh6msI
	8Xd9MK2h/HnrXq+1MCJkzMo4OAEtZGdwK93n4owHeyKOQnzarQ7ZmpxMg+7bF3Eg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24o-00000006XqW-0Sjf;
	Tue, 06 Oct 2026 12:07:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v3 16/19] wifi: nl80211: read WMM reg rule under RCU
Date: Tue,  6 Oct 2026 12:04:14 +0200
Message-ID: <20261006120655.c6fce71ad991.I07ae7ed37bc8ff6d75c87e19d77e4c5379a8e167@changeid>
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

freq_reg_info() returns a pointer into the current regdomain,
so we need RTNL, cfg80211_mutex or RCU, but I want to remove
the RTNL, so just use RCU here.

Also document that this is required, we didn't say when the
function could be used at all.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 2 ++
 net/wireless/nl80211.c | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 458c474d416d..120bc91a4e79 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8197,6 +8197,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * it wants to follow we respect that unless a country IE has been received
  * and processed already.
  *
+ * Must be called within an RCU read-side critical section.
+ *
  * Return: A valid pointer, or, when an error occurs, for example if no rule
  * can be found, the return value is encoded using ERR_PTR(). Use IS_ERR() to
  * check and PTR_ERR() to obtain the numeric return value. The numeric return
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd70027b312a..dd66a3146097 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1540,9 +1540,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
 		goto nla_put_failure;
 
 	if (large) {
-		const struct ieee80211_reg_rule *rule =
-			freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
+		const struct ieee80211_reg_rule *rule;
 
+		guard(rcu)();
+		rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
 		if (!IS_ERR_OR_NULL(rule) && rule->has_wmm) {
 			if (nl80211_msg_put_wmm_rules(msg, rule))
 				goto nla_put_failure;
-- 
2.55.0

