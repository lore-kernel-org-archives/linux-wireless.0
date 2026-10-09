Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453D333AD8B
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557838; cv=none; b=ZkhuwwK1NnJ6yXaGtINk0Ff3DIOxYUnyA+HTYh4yHXl/Y8uihhGCeutEd88injOA5aPrhdadWoIH5/++tTP2vyDHL4WvGvSB/9MmOEZboDO9Y90fZWK9UebT/Bbz/jgEudo11LWy1KKdj+fcGp5Zo7Pl5Bsv2MWRz4qVYQRzE8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557838; c=relaxed/simple;
	bh=obK3VRA0VO1n7q5Pg6vt2hXvhGJ+1HNEB1kpXxA67G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc1bt+GDjENymzazZQa0Oi/YKEestWNiyJselfW3/VabMiz9Trzso++dJ8EYqDZJV1bU23evbhegBpdF5wD/iCdNibTpE3wvXz52upNU0QEMbqr9zpi6A8AVHQynsw5yasDy+1U2rq9PvJ//BOyxll/Tjrjmzh9Fs/gPGEX5NoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZK5JomWa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZK5JomWa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KL4TeVT2QhMDNaG7P0ZlPC42G64CQsGHEXoxVKIO20s=;
	t=1791557837; x=1792767437; b=ZK5JomWardDxI0b+mpwPu38OLTVqDq9sU77ma7GRXFf15f2
	xzga5U6flKwYk5vQhDYne/wcOzRnPMVAutziWq7vMx6HUbJS5ZNhWEGCkV179Ruy1liC+8u+DS1oQ
	1PVm6znz/uTUgWMoNLrnc+JC3oD4b7+OahQ0ozvBbhWUb+1EDOIAIpT1jaN5+laSlOT//XbAqLa3R
	mUN9Nnx5Fl6jpDtc5vmETadIdK06OdhJrUYl/tY+hUxRW7WI3+79s0dOljdz0I1P2gOmJV8ltUyND
	tqEFvyQWyBU5Vfs+8TZdu6C0L8xuObrPMqVxzOOPM8yX83NHOZ+B8usZyPZ6/EgQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC20-0000000AlEW-2mpu;
	Fri, 09 Oct 2026 16:57:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/9] wifi: nl80211: avoid RTNL in nl80211_get_reg_do()
Date: Fri,  9 Oct 2026 16:56:16 +0200
Message-ID: <20261009165703.c4332b09ef2e.Iabc6383753a9e49ade17801c76fd5a91f7397475@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009145703.243031-11-johannes@sipsolutions.net>
References: <20261009145703.243031-11-johannes@sipsolutions.net>
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

