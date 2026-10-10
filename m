Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE123BAD93
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648312; cv=none; b=UZY+SyKRUtENCI4xq3kd5SR8PeYwSEV/DCdl2/ZBEZBzOVEM3GKutCcd3jwiDNHVe3tImmc6X4Q909S8sdSLX2FBLo/wY+1xziyQXBlzWquuWh/S7QHJeYFr7C74P6xqWPdwZUOH+XckgNcEQbHuXuXail1RPy9azZ0DiW6aJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648312; c=relaxed/simple;
	bh=obK3VRA0VO1n7q5Pg6vt2hXvhGJ+1HNEB1kpXxA67G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0AJ29zxDTlerdnU2d3FHeEnUDHfCEbOqNrUWnLLf5ouc3nckMdbRDlJQ5bW81Stl5E5TEJnELSOMOFgSNQakrhVrPc5m1QL5ta75g2YRJhTIOVClO1T7hL4YvF+eDtu9je02cRpFIGZHIu3/TXJAP+JqwUraThLVytzRUzENTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RpEtJyCD; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RpEtJyCD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KL4TeVT2QhMDNaG7P0ZlPC42G64CQsGHEXoxVKIO20s=;
	t=1791648310; x=1792857910; b=RpEtJyCD2ZNogRn2bwD3qF45KU1esCErOT8nZw0wz7osn4J
	tRUNr5ANQQYylw7BVlyMpoT/paNR37weEbVFY96ia0K47ZO9rwm6lJcbY2qiyN0UzE4/XNCOZqeL4
	FgleC3Qq9o33gUZrz2nm1ksfLATpsNB3KUKI91MOi1EcnREPUHsW0nG3K/zGrLxz5aFziLV4rKVCz
	Nf0K0anm9eVb3fslMRK3Z13kfVz4aUi3e3nwMtR8RwYhazDaDI4CWTTb6w0b7qU/KkHxEnQNf9FWZ
	zmiZHBNpOueBRzWTCcN2OH907x8buKRm4bhNEHeFNYsFByQzSUSIAE1lRXR/c5XA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFZZG-0000000CP1z-0Nuj;
	Sat, 10 Oct 2026 18:05:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND wireless-next 1/9] wifi: nl80211: avoid RTNL in nl80211_get_reg_do()
Date: Sat, 10 Oct 2026 18:04:13 +0200
Message-ID: <20261010180459.ef489f51e801.Iabc6383753a9e49ade17801c76fd5a91f7397475@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261010160459.229064-11-johannes@sipsolutions.net>
References: <20261010160459.229064-11-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We don't need the RTNL here now, all the work can happen
under RCU. Drop the RTNL and do it all under RCU instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a48bd4e4f4c7..b5b9d8830af5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10841,7 +10841,7 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 	if (!hdr)
 		goto put_failure;
 
-	rtnl_lock();
+	rcu_read_lock();
 
 	if (info->attrs[NL80211_ATTR_WIPHY]) {
 		bool self_managed;
@@ -10856,44 +10856,37 @@ static int nl80211_get_reg_do(struct sk_buff *skb, struct genl_info *info)
 		self_managed = wiphy->regulatory_flags &
 			       REGULATORY_WIPHY_SELF_MANAGED;
 
-		rcu_read_lock();
-
 		regdom = get_wiphy_regdom(wiphy);
 
 		/* a self-managed-reg device must have a private regdom */
 		if (WARN_ON(!regdom && self_managed)) {
 			err = -EINVAL;
-			goto nla_put_failure_rcu;
+			goto nla_put_failure;
 		}
 
 		if (regdom &&
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY, get_wiphy_idx(wiphy)))
-			goto nla_put_failure_rcu;
-	} else {
-		rcu_read_lock();
+			goto nla_put_failure;
 	}
 
 	if (!wiphy && reg_last_request_cell_base() &&
 	    nla_put_u32(msg, NL80211_ATTR_USER_REG_HINT_TYPE,
 			NL80211_USER_REG_HINT_CELL_BASE))
-		goto nla_put_failure_rcu;
+		goto nla_put_failure;
 
 	if (!regdom)
 		regdom = rcu_dereference(cfg80211_regdomain);
 
 	if (nl80211_put_regdom(regdom, msg))
-		goto nla_put_failure_rcu;
+		goto nla_put_failure;
 
 	rcu_read_unlock();
 
 	genlmsg_end(msg, hdr);
-	rtnl_unlock();
 	return genlmsg_reply(msg, info);
 
-nla_put_failure_rcu:
-	rcu_read_unlock();
 nla_put_failure:
-	rtnl_unlock();
+	rcu_read_unlock();
 put_failure:
 	nlmsg_free(msg);
 	return err;
-- 
2.56.0

