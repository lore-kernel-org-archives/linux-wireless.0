Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A0D476CE1
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194757; cv=none; b=NUdmyRKU9pYgyHgD8/4+PEWfgv5dTsL5ywFMIi3tm++TH/EzB7X30iXHe3kPJ+9pn3DrTXhuuD1J23JBzAV9MCf94090TrKPF3/NgWk1dtlDuOmll69fGGXVOEu48ywahZtZnuy1XKGZ3pBwhsjcwNCHiielSw/ksAn0HPYbI/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194757; c=relaxed/simple;
	bh=lmAFAdbAyWNytfsMCwucn7v8XF53MusUyPUxMugpZOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV/TB+iJIWWk/0lGVShgaTuOXD1zRPDoxJCNtFlDsaANTiSblJQnWdB3WXIImSxB2lbh7DizuZ35u8a0lv/xLaOMOpz2VRNqXrVIYwoGpeqoCegJKvGAh1Xgdz8OHhesRhgmz0yMTl7VKKCGVEnFI2nEgJr9Wo6wlFcBJ9T4LEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uLJ0RPVB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uLJ0RPVB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=j/EH5TZGO1vjF7lbkJN8gANAyPBJNjfR4H6Y2LB5aEw=;
	t=1791194755; x=1792404355; b=uLJ0RPVBkbF3PUX/9TSWl+9TYxSoT0xDQlpflK1lJc8zap2
	R5I5b/CVXPOzo45pF79DQ+hw2rX248KfJlRRuTteKlM5D6vZblxWcyhJFQXyyihSWjZ7QYWOzmETC
	TsEOK3lGeuWmKiCkRFxpySI8e8PVBBf/tQ1BuUdZWi4UTexbc5fWvXXdhjbGru6lDyCSBIJWPVSg5
	XmDiowc9dcc8Eb/5LxbhFVE7jum1kwz/wC7WsPU5qqGiiKtiqsYpAR19n3smXl2a/RiWQi7TBoWQJ
	X7dNCCInMjj54BJSj/d0mgQPG+BZm9FohYyksU+b96LodXIxl0lXsXPaf0giQwhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfZx-00000005Bml-1YsY;
	Mon, 05 Oct 2026 12:05:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 15/18] wifi: nl80211: read WMM reg rule under RCU
Date: Mon,  5 Oct 2026 12:03:42 +0200
Message-ID: <20261005120526.2055aae35ac8.I07ae7ed37bc8ff6d75c87e19d77e4c5379a8e167@changeid>
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
index 1e9d0df6bd3c..3ac3fea6be32 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1538,9 +1538,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
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

