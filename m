Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEA0476CC7
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195075; cv=none; b=GH+ljjxUUZEUKGZv6j55XYrEXs8MR37uwHWwX+tXdq3o7Giv2/runj4i/0CTEEMsvNe2XQYJSXnO87yZf3jB/+v3lRaO/iHSzEFnXXdh2s+u+xgZ5FxZCxn9nVoZaiYEHniZiem4raVwPZcfvZXZVMJgPgzHAldl68bhbxDU5mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195075; c=relaxed/simple;
	bh=1OR1WVIxZfqf/6DQwTIBj39A7XIDSLphdSw0iGAwRCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgTEjpwK4mz2TYZXVMi8wKSiu1Smkp1fthBPf+/1kPA2G8F2ypKt0cOFyS6vFB5bGpIs/udEbW9HAgy6NgDRwQVieXLOXXShluC8LGQcWFq2aiz1uRr+KwCmd7SgJ9Djuu0C+g27GIqYC24UgNJmq/Wm5Gq8uB1bIBvNd9kX9vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CiW/RcVp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CiW/RcVp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=H6uyTvCgcMXLusE67xP4j8pkjyCsXsXvPQ/W9GmeftQ=;
	t=1791195073; x=1792404673; b=CiW/RcVpFhwEn2APh3GHg8LEh8s/dm/P//8lBpuxAuXEwYw
	hb5ybf+nbU66wbxhWssBTj+I7gVt7VfC0J1slr9PKREtCtYRq0LZ3CN5Pxh9kRX609PeAXCz8AIJf
	4FNDBB1Xn34LNqnggA66P+lXaLc5yklKSk5RCBHgbjGGUnaA16wVSnSC9tvBymU4PfJAVFLcGEz3L
	T9HipysWUCyKyDEx32qSwieJ1JmaeVN0hF4Fm+Jv2RYYIwlaCBC3NIrcanW7/L5gw8a6H9gMy8dMc
	oaVxdbCQzQl0mDDr/M5cSZ+CzzWNALX5y5iRyjzA6FnXO+xEkSi/nU3rU3PXQCYA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff3-00000005CGx-10WZ;
	Mon, 05 Oct 2026 12:11:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 09/13] wifi: mac80211: implement mgmt_tx_unlocked()
Date: Mon,  5 Oct 2026 12:06:25 +0200
Message-ID: <20261005121058.36b939addeb8.Ib10158e2729f89719b551dadb8384e89b9dce688@changeid>
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
index aff9b1023d80..56328bfffa84 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6270,6 +6270,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
+	.mgmt_tx_unlocked = ieee80211_mgmt_tx_unlocked,
 	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 	.set_cqm_rssi_range_config = ieee80211_set_cqm_rssi_range_config,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 02e50dcef27e..2f0d7a7b6685 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2189,6 +2189,9 @@ int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
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
2.55.0

