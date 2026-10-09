Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C74F85B2
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569675; cv=none; b=H9yPZ5wqoUwka7dOp1BFsBs/58+QYvFZkgsmFkgzMn4T+K1kurXcImADgysnbrm7GofOc7AWZ9AdVqCC4NvYM5PCMKU450STlyQrWC1WWvbqk7mdKLXjVT8IIhUP5ijiZitCGwRGwfwQjSnvmTYjpMMaZDDQodHKPP9Vttx0ecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569675; c=relaxed/simple;
	bh=HwdVMxDTxrp+wl1AGUEmwtmlWpDJC1+qA/JSe+h0Wgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQf1lML54R7cErroLlUIcbV9g4dgCkEKytHtV8c6dmnSOgQ7m7bHUbXo6rh9rXkbfxtPPnWuY57RCyRORjPBNe2X7fMqWAlUzV8rM6KJmVzlyjvqVWt6CcqybZ2SjhFdTAaWylY+5N4wi6Au9TvBgFQi2qHw1lFkATQEINVtImQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ikNKCM9i; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ikNKCM9i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=xDegsTfQa7ltgJQT36YOck72G7u0nvmcdE9oFoF9BSI=;
	t=1791569674; x=1792779274; b=ikNKCM9iAn+zM7c2QkXioHJFvi9DuYUdRS3kySV0MzOJha0
	3xiZzBh42y8WvUX9JPUTR4JT07Weh+iI6rc4l/jiGORZWm4mNAb94iEpVv4I/uVqNr9xF7Xyh7tU+
	gER5CeHLRLpT/YeaZB3Lwdku7+0V41k/oWE70aViiY1xKZnd9KIUcYskt1UMzSKApqdCeeFNcyxyr
	Whjbwk6nXyx++NB4W4/5vGxdSWGqkezfECeyI+YFVWlokOvpahcup4xrcxfi8KP3DXDHdHY0qIe7g
	gmNgn0wjxV5vt+59n3Gk5yE8kSZ76PZnD9I4BFP5RFVTNAWXTO5BOWdXSGphEwcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF72-0000000AtGH-0Qk0;
	Fri, 09 Oct 2026 20:14:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 11/17] wifi: mac80211: don't require wiphy mutex for probe_peer
Date: Fri,  9 Oct 2026 20:10:10 +0200
Message-ID: <20261009201417.4501c07ff31e.Ic87a72afcaea6b9a8c92f7f063bf33a2744a7992@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The comment about wiphy mutex is stale since the cookie
cleanup, and everything else can be under RCU, we just
have to drop the warning in case it races AP stop.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index daabac9fc6e6..0acbb2415a02 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5223,11 +5223,17 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	int size;
 	int ret;
 
-	/* the lock is needed to assign the cookie later */
-	lockdep_assert_wiphy(local->hw.wiphy);
+	guard(rcu)();
+
+	/* do_stop() synchronizes RCU before the interface type can change */
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
 
 	switch (ieee80211_vif_type_p2p(&sdata->vif)) {
 	case NL80211_IFTYPE_AP:
+		/* NULL if the interface was a station when checked */
+		if (!peer)
+			return -EINVAL;
 		fromds = true;
 		break;
 	case NL80211_IFTYPE_STATION:
@@ -5253,8 +5259,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 			 * per-link address for the client's link.
 			 */
 			link_id = sta->deflink.link_id;
-			conf = wiphy_dereference(local->hw.wiphy,
-						 sdata->vif.link_conf[link_id]);
+			conf = rcu_dereference(sdata->vif.link_conf[link_id]);
 			if (!conf)
 				return -ENOLINK;
 			src_addr = conf->addr;
@@ -5269,9 +5274,8 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 		/* MLD transmissions must not rely on the band */
 		band = 0;
 	} else {
-		chanctx_conf = wiphy_dereference(local->hw.wiphy,
-						 sdata->vif.bss_conf.chanctx_conf);
-		if (WARN_ON(!chanctx_conf))
+		chanctx_conf = rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
+		if (!chanctx_conf)
 			return -EINVAL;
 		band = chanctx_conf->def.chan->band;
 		link_id = 0;
@@ -5318,9 +5322,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	local_bh_disable();
-	rcu_read_lock();
 	ieee80211_xmit(sdata, sta, skb);
-	rcu_read_unlock();
 	local_bh_enable();
 
 	return 0;
-- 
2.56.0

