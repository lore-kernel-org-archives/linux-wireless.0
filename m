Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908104582E6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195073; cv=none; b=R0xKZsJh+Eb2Im5lFM6GgByu8h+RZI5G/VN7G6EoWVGLTtzCyj4oXQFEKS8gI2IKhA+B6NX1gRw1bPT8asch+bG2u8hHaVdMbfDVE9PcnRTrl/XT4+khHmleSk1xS0jqRIJJ0LoRSluZEfbzgPeuVfFV9PjxzxKFivstUbIvGFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195073; c=relaxed/simple;
	bh=aI8KNlVq+dqDE/5wr1XIs9W79DQbeXa89dlz+Pk2Fos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sc2yRqf5R/Kl244eN5cLUzuczltGWj+24dSmhGL4ueWxFDovezUkeN1YrwVvJbpFwwu0qJflQLljBrSPdCwCBi3sd+QNiV4gjv9K2+ZSkimiB/r7p5NeVU/TTqshEgmzVDwxgOLaMOlQSCS9NwCsL/QMcrEezAkWYTxA4vzd7pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=tCpxMVh3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="tCpxMVh3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=nn3Q9f3zteASoHYBKBOEPJlKexiRiQQz7ORxN2nDn9o=;
	t=1791195071; x=1792404671; b=tCpxMVh3N+ss2w4vxCxeoq8pxw88/PKZE9bIecj4t/2Bb2p
	Imb6IgFwW8Xa/UrRUwkR69yK+vDEZ13tAbjspvTtF4/HkrrVTwvdgi+LM7D09b2Rus2zW1bXAgTtL
	Z8wEEEu3w9IpUz5H/UdHsoXa2wpj60SLE1qt8HUawoEu/e/7NABExcyJCMaoRpHyjymGr3QEDu3DP
	Mc8aVG5hPZ34kSu9jJpMK3VwegA9/L/UOm+CpeBtmuDw89LKmjQ7kvstuVXlYewoWWcq49HV4jKU6
	P/17/EVZFPmhb7tCM6lxvxmnxKw6oA+BepypXhcoKDMuZ5y36k7Qdf4s2Yzw+12w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff2-00000005CGx-2jHJ;
	Mon, 05 Oct 2026 12:11:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 08/13] wifi: mac80211: refactor mgmt frames TX
Date: Mon,  5 Oct 2026 12:06:24 +0200
Message-ID: <20261005121058.08a2e00525a2.I4848c3eeb2aaf327712233f0bdb38bb48bdbbba6@changeid>
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

Refactor ieee80211_mgmt_tx() into on-channel and frame
building helper functions so we can later implement the
new mgmt_tx_unlocked() method.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 225 +++++++++++++++++++++-----------------
 1 file changed, 122 insertions(+), 103 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index c46cb81fab22..27ca2984826f 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -814,6 +814,124 @@ int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
+static bool
+ieee80211_mgmt_tx_need_offchan(struct ieee80211_sub_if_data *sdata,
+			       struct cfg80211_mgmt_tx_params *params,
+			       const struct ieee80211_mgmt *mgmt,
+			       bool mlo_sta, int *link_id)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf = NULL;
+	int i;
+
+	guard(rcu)();
+
+	/* Check all the links first */
+	for (i = 0; i < ARRAY_SIZE(sdata->vif.link_conf); i++) {
+		struct ieee80211_bss_conf *conf;
+
+		conf = rcu_dereference(sdata->vif.link_conf[i]);
+		if (!conf)
+			continue;
+
+		chanctx_conf = rcu_dereference(conf->chanctx_conf);
+		if (!chanctx_conf)
+			continue;
+
+		if (mlo_sta && params->chan == chanctx_conf->def.chan &&
+		    ether_addr_equal(sdata->vif.addr, mgmt->sa)) {
+			*link_id = i;
+			break;
+		}
+
+		if (ether_addr_equal(conf->addr, mgmt->sa)) {
+			/* If userspace requested Tx on a specific link
+			 * use the same link id if the link bss is matching
+			 * the requested chan.
+			 */
+			if (sdata->vif.valid_links &&
+			    params->link_id >= 0 && params->link_id == i &&
+			    params->chan == chanctx_conf->def.chan)
+				*link_id = i;
+
+			break;
+		}
+
+		chanctx_conf = NULL;
+	}
+
+	if (!chanctx_conf)
+		return true;
+
+	return params->chan && params->chan != chanctx_conf->def.chan;
+}
+
+static struct sk_buff *
+ieee80211_mgmt_tx_skb(struct ieee80211_sub_if_data *sdata,
+		      struct cfg80211_mgmt_tx_params *params,
+		      u64 cookie, gfp_t gfp)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	u32 flags;
+	u8 *data;
+
+	if (params->dont_wait_for_ack)
+		flags = IEEE80211_TX_CTL_NO_ACK;
+	else
+		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+			IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	if (params->no_cck)
+		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + params->len);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	data = skb_put_data(skb, params->buf, params->len);
+
+	/* Update CSA counters */
+	if (sdata->vif.bss_conf.csa_active &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
+	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
+	    params->n_csa_offsets) {
+		int i;
+		struct beacon_data *beacon = NULL;
+
+		rcu_read_lock();
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			beacon = rcu_dereference(sdata->deflink.u.ap.beacon);
+		else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+			beacon = rcu_dereference(sdata->u.ibss.presp);
+		else if (ieee80211_vif_is_mesh(&sdata->vif))
+			beacon = rcu_dereference(sdata->u.mesh.beacon);
+
+		if (beacon)
+			for (i = 0; i < params->n_csa_offsets; i++)
+				data[params->csa_offsets[i]] =
+					beacon->cntdwn_current_counter;
+
+		rcu_read_unlock();
+	}
+
+	IEEE80211_SKB_CB(skb)->flags = flags;
+	IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
+
+	skb->dev = sdata->dev;
+
+	/* make a copy to preserve the frame contents in case of encryption */
+	if (!params->dont_wait_for_ack &&
+	    ieee80211_attach_ack_skb(local, skb, &cookie, gfp)) {
+		kfree_skb(skb);
+		return NULL;
+	}
+
+	return skb;
+}
+
 int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		      struct cfg80211_mgmt_tx_params *params, u64 cookie)
 {
@@ -825,21 +943,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	bool need_offchan = false;
 	bool mlo_sta = false;
 	int link_id = -1;
-	u32 flags;
 	int ret;
-	u8 *data;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	if (params->dont_wait_for_ack)
-		flags = IEEE80211_TX_CTL_NO_ACK;
-	else
-		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-			IEEE80211_TX_CTL_REQ_TX_STATUS;
-
-	if (params->no_cck)
-		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
-
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_ADHOC:
 		if (!sdata->vif.cfg.ibss_joined)
@@ -927,52 +1034,9 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		   sdata->vif.type == NL80211_IFTYPE_NAN_DATA) {
 		/* Frames can be sent during NAN schedule */
 	} else if (!need_offchan) {
-		struct ieee80211_chanctx_conf *chanctx_conf = NULL;
-		int i;
-
-		rcu_read_lock();
-		/* Check all the links first */
-		for (i = 0; i < ARRAY_SIZE(sdata->vif.link_conf); i++) {
-			struct ieee80211_bss_conf *conf;
-
-			conf = rcu_dereference(sdata->vif.link_conf[i]);
-			if (!conf)
-				continue;
-
-			chanctx_conf = rcu_dereference(conf->chanctx_conf);
-			if (!chanctx_conf)
-				continue;
-
-			if (mlo_sta && params->chan == chanctx_conf->def.chan &&
-			    ether_addr_equal(sdata->vif.addr, mgmt->sa)) {
-				link_id = i;
-				break;
-			}
-
-			if (ether_addr_equal(conf->addr, mgmt->sa)) {
-				/* If userspace requested Tx on a specific link
-				 * use the same link id if the link bss is matching
-				 * the requested chan.
-				 */
-				if (sdata->vif.valid_links &&
-				    params->link_id >= 0 && params->link_id == i &&
-				    params->chan == chanctx_conf->def.chan)
-					link_id = i;
-
-				break;
-			}
-
-			chanctx_conf = NULL;
-		}
-
-		if (chanctx_conf) {
-			need_offchan = params->chan &&
-				       (params->chan !=
-					chanctx_conf->def.chan);
-		} else {
-			need_offchan = true;
-		}
-		rcu_read_unlock();
+		need_offchan = ieee80211_mgmt_tx_need_offchan(sdata, params,
+							      mgmt, mlo_sta,
+							      &link_id);
 	}
 
 	if (need_offchan && !params->offchan) {
@@ -980,56 +1044,11 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto out_unlock;
 	}
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + params->len);
+	skb = ieee80211_mgmt_tx_skb(sdata, params, cookie, GFP_KERNEL);
 	if (!skb) {
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	data = skb_put_data(skb, params->buf, params->len);
-
-	/* Update CSA counters */
-	if (sdata->vif.bss_conf.csa_active &&
-	    (sdata->vif.type == NL80211_IFTYPE_AP ||
-	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
-	    params->n_csa_offsets) {
-		int i;
-		struct beacon_data *beacon = NULL;
-
-		rcu_read_lock();
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			beacon = rcu_dereference(sdata->deflink.u.ap.beacon);
-		else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			beacon = rcu_dereference(sdata->u.ibss.presp);
-		else if (ieee80211_vif_is_mesh(&sdata->vif))
-			beacon = rcu_dereference(sdata->u.mesh.beacon);
-
-		if (beacon)
-			for (i = 0; i < params->n_csa_offsets; i++)
-				data[params->csa_offsets[i]] =
-					beacon->cntdwn_current_counter;
-
-		rcu_read_unlock();
-	}
-
-	IEEE80211_SKB_CB(skb)->flags = flags;
-	IEEE80211_SKB_CB(skb)->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
-
-	skb->dev = sdata->dev;
-
-	if (!params->dont_wait_for_ack) {
-		/* make a copy to preserve the frame contents
-		 * in case of encryption.
-		 */
-		ret = ieee80211_attach_ack_skb(local, skb, &cookie, GFP_KERNEL);
-		if (ret) {
-			kfree_skb(skb);
-			goto out_unlock;
-		}
-	}
 
 	if (!need_offchan) {
 		ieee80211_tx_skb_tid(sdata, skb,
-- 
2.55.0

