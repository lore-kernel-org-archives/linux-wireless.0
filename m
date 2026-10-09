Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E250551120A
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569675; cv=none; b=EY8M9YJwWHNsuGc23Oe7whO7g11X67w1rqYnC09Q2PQE2VbrjCTzovHzMMIYRXAD1a9MmuJEg6CviG4F552VRNQNcziCZxhpj3KEOvXrwDwBcyu2DTU7qVaV/MlEd1ulT1W8sPtmMqsw4F9Lcjln1AwlNzHBf+gwin1n6MqGWKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569675; c=relaxed/simple;
	bh=gnrBbEh1vLXCHcEXI2m2abdAIu75dCvAN6J9kdN3AD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alxES+sXQkdWg/hmMpihxcSShjCo0qrcB2I+gdK4B/1C3Kn+seIDqzhILzN+wDto7Wvt5jG7dfjvLR5+afKB4LcL0yH6PdC0uStilloh5kHGVv6hKic7aHCl1TZLD2dORbI7bnZh+QBxM4p8TinDq1/zUav4XGgtWXvZ6Wu7oFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=U0QelzeX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="U0QelzeX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=+hPg2kCQ5UL7a8HIdfh4rQUalIeNfbWE3QlENQGZEOU=;
	t=1791569674; x=1792779274; b=U0QelzeXXdZRqyMpkAz+Z+J4GmpTVZ11cbm4aiPiazYsuBW
	bAxr9OaFVr0322JVsvWfZKuUc4OA4sJA4Cg3kNPem763gXUBTXFEpInUGt2pTe9vIs5iE9gD80iiG
	DnOgRzXQEKem3eE+lNqe9YWQBxVJrRA1ILVxafTz9t9Gg8PKql6Nb0CUQxqrwReiLhpsbLbbKQsme
	fnc15gDWH/joIWJcmcJlA9jXRfPf6toWHqNwj/MVBjLtglZvvI3M7tRL57smkQ4MUHaMFgRaK1vnG
	V/b/Rzd5rtQFFpcPbV4v+G6AJgSRjV7T81aK0peaCqyqWei+5lyJOvEar5IfMaHQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6z-0000000AtGH-08Ud;
	Fri, 09 Oct 2026 20:14:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 10/17] wifi: mac80211: implement mgmt_tx_unlocked()
Date: Fri,  9 Oct 2026 20:10:09 +0200
Message-ID: <20261009201417.6491f3bdeb4e.Ib10158e2729f89719b551dadb8384e89b9dce688@changeid>
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

Implement the mgmt_tx_unlocked() method and accept frames
that are transmitted on the operating channel with it, as
they don't need further handling and can go out directly.

For off-channel etc. just return -EAGAIN to fall back to
the locked version.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   1 +
 net/mac80211/ieee80211_i.h |   3 +
 net/mac80211/offchannel.c  | 109 +++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 30fe29f25928..daabac9fc6e6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6316,6 +6316,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
+	.mgmt_tx_unlocked = ieee80211_mgmt_tx_unlocked,
 	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 	.set_cqm_rssi_range_config = ieee80211_set_cqm_rssi_range_config,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 16c1e0337f3a..bf9f26234662 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2192,6 +2192,9 @@ int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 				       struct wireless_dev *wdev, u64 cookie);
 int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		      struct cfg80211_mgmt_tx_params *params, u64 cookie);
+int ieee80211_mgmt_tx_unlocked(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       struct cfg80211_mgmt_tx_params *params,
+			       u64 cookie);
 int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 				  struct wireless_dev *wdev, u64 cookie);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 27ca2984826f..44808120ff51 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -1074,6 +1074,115 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	return ret;
 }
 
+int ieee80211_mgmt_tx_unlocked(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       struct cfg80211_mgmt_tx_params *params,
+			       u64 cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	const struct ieee80211_mgmt *mgmt = (void *)params->buf;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta = NULL;
+	enum nl80211_band band;
+	struct sk_buff *skb;
+	int link_id = -1, i;
+
+	if (READ_ONCE(local->in_reconfig) || READ_ONCE(local->quiescing))
+		return -EAGAIN;
+
+	guard(rcu)();
+
+	/* do_stop() synchronizes RCU before the interface type can change */
+	if (!ieee80211_sdata_running(sdata))
+		return -EAGAIN;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_NAN_DATA:
+		if (is_multicast_ether_addr(mgmt->da))
+			return -EOPNOTSUPP;
+		fallthrough;
+	case NL80211_IFTYPE_NAN:
+		/* Frames can be sent during NAN schedule */
+		skb = ieee80211_mgmt_tx_skb(sdata, params, cookie, GFP_ATOMIC);
+		if (!skb)
+			return -ENOMEM;
+
+		__ieee80211_tx_skb_tid_band(sdata, skb,
+					    params->no_sta ? ERR_PTR(-ENOENT) :
+							     NULL,
+					    7, -1, NUM_NL80211_BANDS);
+		return 0;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (sdata->bss->active)
+			break;
+		fallthrough;
+	default:
+		return -EAGAIN;
+	}
+
+	if (!params->no_sta)
+		sta = sta_info_get_bss(sdata, mgmt->da);
+
+	if (ieee80211_is_action(mgmt->frame_control) &&
+	    mgmt->u.action.category != WLAN_CATEGORY_PUBLIC &&
+	    mgmt->u.action.category != WLAN_CATEGORY_SELF_PROTECTED &&
+	    mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT) {
+		if (!sta)
+			return -ENOLINK;
+		if (params->link_id >= 0 &&
+		    !(sta->sta.valid_links & BIT(params->link_id)))
+			return -ENOLINK;
+		link_id = params->link_id;
+	}
+
+	if ((params->chan || !sta || !sta->sta.mlo) &&
+	    ieee80211_mgmt_tx_need_offchan(sdata, params, mgmt,
+					   sta && sta->sta.mlo, &link_id))
+		return -EAGAIN;
+
+	/* things may have changed, avoid WARNs in ieee80211_tx_skb_tid() */
+	if (ieee80211_vif_is_mld(&sdata->vif)) {
+		band = 0;
+
+		if (link_id < 0 &&
+		    !ether_addr_equal(sdata->vif.addr, mgmt->sa)) {
+			for (i = 0; i < ARRAY_SIZE(sdata->vif.link_conf); i++) {
+				struct ieee80211_bss_conf *conf;
+
+				conf = rcu_dereference(sdata->vif.link_conf[i]);
+				if (conf &&
+				    ether_addr_equal(conf->addr, mgmt->sa)) {
+					link_id = i;
+					break;
+				}
+			}
+			if (link_id < 0)
+				return -EAGAIN;
+		}
+
+		if (link_id >= 0 &&
+		    !(READ_ONCE(sdata->vif.active_links) & BIT(link_id)))
+			return -EAGAIN;
+	} else {
+		struct ieee80211_chanctx_conf *chanctx_conf;
+
+		chanctx_conf =
+			rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
+		if (!chanctx_conf)
+			return -EAGAIN;
+		band = chanctx_conf->def.chan->band;
+	}
+
+	skb = ieee80211_mgmt_tx_skb(sdata, params, cookie, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	__ieee80211_tx_skb_tid_band(sdata, skb,
+				    params->no_sta ? ERR_PTR(-ENOENT) : sta,
+				    7, link_id, band);
+	return 0;
+}
+
 int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 				  struct wireless_dev *wdev, u64 cookie)
 {
-- 
2.56.0

