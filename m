Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB534915A3
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140503; cv=none; b=kFEvzBCeWRp0Nz9zVZ50IaPZp9Ra6BL6Jy81zFubvQ/g1w6YJ+h62GIUqW9YGacuT/jdCQ2mZBDrEXADtGP1Zt+d6BN2fIfZfyKPpdgogEDT4GJIri94NJZPfkXyMbOXG3HLKOQ0k8LOHc7BfM9Ajn+8cdR3iQJrYXbGH/vcHZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140503; c=relaxed/simple;
	bh=o1wD1ZqMWY9Zp020XVVoW12BJUcFghiwu7OLfjjB7zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US6r7fUyAzEGzR3zW6qLRYB+GlfcuFlD6yW6aF/ra8a8h/MHh4i00GhYyJiGpYXjIqt/TSI0sKf0QEeI1UDgzP5NyPVeKF+Jk0fdo2QKAywhjPlXDLlSykuP17+YLNTpq9OhXo46L7R3dNBfWgT9MAhkzNbHciZj1/gw9sFhtbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NSzjCDpO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NSzjCDpO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/tzHe4aC1qBWAwPE4pnvFwDAjPa5lPG38+aaaEoI4W0=;
	t=1791140500; x=1792350100; b=NSzjCDpOgf6eFF4E272n8/s1w3WKntr9w3rQHMiNbtWvyhY
	SZfoMFXx6ZM8tNXMyd+qeL2hZaG72BpcXuJ5qrgAvHckDUJRLbfdEY1X17nd8FewtdN8d8amFhlf+
	JgQrix9hiuMWqc6Byfk+ftHOzui7kfbXD0n/zqaTUVVTnodSvyMdg1lQG2gFwwIV5yqaTiacsLp24
	IVU7KxfGa7FkG7mYKUciZ5HKKkk5MQvUIOezn9NG6CPt7wtv/ekGfW3tzhay0pN/JZq+LfNhpaogA
	dQQW8XlBEnU5GEAIf2n8V/Ig3ZCORr1OfM+24yi8ZgGrxYxnVkg/PuqZuxhMZoDw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSp-00000004Jlo-3eYD;
	Sun, 04 Oct 2026 21:01:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 15/18] wifi: nl80211: read WMM reg rule under RCU
Date: Sun,  4 Oct 2026 21:01:29 +0200
Message-ID: <20261004210122.4d06dce25069.I07ae7ed37bc8ff6d75c87e19d77e4c5379a8e167@changeid>
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
index eb376a54a07f..ef54cc64ddf0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8183,6 +8183,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * it wants to follow we respect that unless a country IE has been received
  * and processed already.
  *
+ * Must be called within an RCU read-side critical section.
+ *
  * Return: A valid pointer, or, when an error occurs, for example if no rule
  * can be found, the return value is encoded using ERR_PTR(). Use IS_ERR() to
  * check and PTR_ERR() to obtain the numeric return value. The numeric return
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8f206e44ba71..f96a0238f1ca 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1536,9 +1536,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
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

