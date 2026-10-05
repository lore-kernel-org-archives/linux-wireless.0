Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B2947255F
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195075; cv=none; b=pj93YFUJnZJ+bltdhLZq3GRCF5PkhvNEcshg9RlwdBF+rYz7vVo676ps291N2NDDeE5MKBi1juIzns9Hx91k+uodEEYcJca611FnhtdEW6yHh6z8UQ3XE7YQkIt8OqprsE4xoUbhSB8TiQYMpYk9RcJN2Gk8Gn5da9ryQeoGyOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195075; c=relaxed/simple;
	bh=mVO43rK0AuBAgbhghaaosrBw6ud9WaJA0/tRcMdiLAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dovwV59Q+qjR93X1b9PGBkGbkVIJhaiaNYuJ6XXOUrtItlz0ZUeTpNEkFr0kxrKb8GUCYVOn0V/WBrDg7R7Zvxid+Nxwm50ppzWJpdyVBM9vxAgkMpFsuArEpYBchjlhpccbDiC21xWOuGr/tbeCcYTs8e7hhJfbshOXwKyFxoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=EMerhLgs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="EMerhLgs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3DhMgH1eqbsWTtQct41WIAoWLDXFMQ2370K1F3cws98=;
	t=1791195073; x=1792404673; b=EMerhLgsP6iPNUUHFs6PtvAF+WH5Um3Jn2lMYrR4UcuRqCs
	GB0nieMUetT+a0Z1/AOaHUjseBVl4ydiZ06ZP7gd71COMvPOZa2td1zaQE1myIpvL7y9eoUy1CpR5
	4eUdZZGwYWwrjpQ9fI9gPJD8aN+zLl7rBwNYrEUqg0ndW5p5Jo3N7xP8lrSRbmn3HtEiEAcgD8MSR
	XsAZJpAe4kPLK9J0JrmUtiUerf1rJtO2LirbFSm6hLpPkxnVk3JJaGAvhB4EVzUc0ohi+5MWBXrrA
	zhUuGKJh3qchiGTIa4dEFUl+kQ6ouPgfT+aLXUYlVDqfvynEfnehcvhiD/wRdu1Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff5-00000005CGx-0w3m;
	Mon, 05 Oct 2026 12:11:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 10/13] wifi: mac80211: don't require wiphy mutex for probe_peer
Date: Mon,  5 Oct 2026 12:06:26 +0200
Message-ID: <20261005121058.44e25f9bcfdc.Ic87a72afcaea6b9a8c92f7f063bf33a2744a7992@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
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
index 56328bfffa84..078947055b17 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5179,11 +5179,17 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
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
@@ -5209,8 +5215,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 			 * per-link address for the client's link.
 			 */
 			link_id = sta->deflink.link_id;
-			conf = wiphy_dereference(local->hw.wiphy,
-						 sdata->vif.link_conf[link_id]);
+			conf = rcu_dereference(sdata->vif.link_conf[link_id]);
 			if (!conf)
 				return -ENOLINK;
 			src_addr = conf->addr;
@@ -5225,9 +5230,8 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
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
@@ -5274,9 +5278,7 @@ static int ieee80211_probe_peer(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	local_bh_disable();
-	rcu_read_lock();
 	ieee80211_xmit(sdata, sta, skb);
-	rcu_read_unlock();
 	local_bh_enable();
 
 	return 0;
-- 
2.55.0

