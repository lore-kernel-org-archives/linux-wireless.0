Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655840;
	b=lxPszd8a4KTcRgv+1pRy+Q2JAJ56Pvy1i07kH+2fwFvQOS9saW4ySJmr3KiUVr8yNeMJ
	 1mBHYonqUyawpapDEGcs0AIubYFhl6FDg+O9vZde/eFFKNun+skK75gwa0H048+Nch3B9
	 6POeHGNIbDX3hiqIkEUS6BdwAbY3J8Fy0CFTISqelUJMP/N0+DJaa6w9xJJx8T//sEgVC
	 x/YKWI2yulmXcDoU3z+yxzMtFBSkcNYS6uiADvviqDPfkyizMQ3yePpba8YW4NqxaXkZg
	 ez7h32DaaiuiAjsE7ukvr4gPMeINcLkM5y9BKvCxUlqc3KqA1kaPJcvVKJCXznGFK5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655840;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MzAtDvGaawULHM6bAnALgRWCkYH1tz+GSE3Xt0DJi9E=;
	b=u4sidmNs/UAuMxHF29WUMA0jWTMYrxB2XH/aUmG1Yd0/aS8fTgFzLVtBrjxhjdALmdyQ
	 4gF/iGt0fofbVPNQ7alFmfQ38GvLt/vnP3g+k+H3RlxaL0zjE+p53US1Tqpcbusdpv98G
	 I+GcKFVey2COtkvCWONjVIuBTCiL+rRNw+GCSC+uHjsYEAzctR4dIScstWPgkWhwvgTR8
	 dfD//jJGjE0xa4t4AmruCtu5x84+UN3MAGKUbSHt4I7yHn63g5E1rPi9GC71OwRMJz08h
	 T056rHECLN/icDzZu89FnMEOS1MqqFbv8Y0Ok/RM9p0HwPvK0hivNOCfsTp2B8Sts4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=mlocLvVC;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146B5606A32E
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=mlocLvVC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MzAtDvGaawULHM6bAnALgRWCkYH1tz+GSE3Xt0DJi9E=;
	t=1793655839; x=1794865439; b=mlocLvVCBEtS9QUv5t5PiN9fnEa2OHgkwusfQZAUFlrDgCP
	P9HNckouFDeusJKV3dgVxyvBbhz67nbFUrJO7vl6oKM9c55bXKtnzDbEdv+hTspn3UagRKYQHhtZf
	odVl2wO78L5I53BV2uae75ZsmUCegfsjhNQ1k5sw2RFR0wefQPZAAr9FGMRvGH/yuUa5ycByXH6RX
	HS7qq30Ujm4FSi7L5uoPoJW7cZfxz69+skkUbs+EUb1Al+XjNGds0eLb9BdppUidZB/C0he+i1i6w
	1D+1DKmQrPuxsXM4ziSl249iCGM5R66IME4fJw8TkPoiMMN8jHl/NU/Cy7AKbWww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzoq-000000020tw-0yrY;
	Mon, 02 Nov 2026 22:43:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 6/7] wifi: mac80211: track sta->active_links
Date: Mon,  2 Nov 2026 22:42:42 +0100
Message-ID: <20261102224349.756ad7919f4d.I14d08fa299816470230189bc7f6f604b447b78a0@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102214348.1104849-9-johannes@sipsolutions.net>
References: <20261102214348.1104849-9-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We've always assumed that a station has active_links
that are simply sta->valid_links & vif->active_links,
and while this should be true most of the time, during
SMD transition the target AP MLD will have a different
(set of) active link(s) than the vif, and needs to be
added so the state can be transferred over.

Add and track sta->active_links, and use it in a few
places. Upon allocation, a sta initially has no active
links, it's up to the caller to fix that; document it.
During link switch, the active links change with the
interface ones, do that in the drv_change_sta_links()
wrapper.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  3 +++
 net/mac80211/cfg.c        |  8 ++++++++
 net/mac80211/driver-ops.c | 13 ++++++++++---
 net/mac80211/key.c        | 10 +++++++---
 net/mac80211/mlme.c       |  8 ++++++--
 net/mac80211/sta_info.c   | 12 ++++++++++--
 net/mac80211/sta_info.h   |  1 +
 7 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e54fa07e2cbf..335eee075952 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2727,6 +2727,8 @@ struct ieee80211_link_sta {
  *	would be assigned to link[link_id] where link_id is the id assigned
  *	by the AP.
  * @valid_links: bitmap of valid links, or 0 for non-MLO
+ * @active_links: bitmap of active links, always a subset of @valid_links;
+ *	unused (0) for non-MLO
  * @spp_amsdu: indicates whether the STA uses SPP A-MSDU or not.
  * @epp_peer: indicates that the peer is an EPP peer.
  * @cip: indicates whether the STA uses control frame protection or not.
@@ -2762,6 +2764,7 @@ struct ieee80211_sta {
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
 	u16 valid_links;
+	u16 active_links;
 	u16 ext_mld_capa_ops;
 	bool epp_peer;
 	struct ieee80211_link_sta deflink;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 38898fd58692..9e47360ee8f5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2935,6 +2935,14 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 		sta = sta_info_alloc_with_link(link, mac,
 					       params->link_sta_params.link_mac ?: mac);
+
+		/*
+		 * In this path (AP side), the link the station is created for
+		 * must be active, so just set the active links.
+		 */
+		if (sta)
+			sta->sta.active_links =
+				BIT(params->link_sta_params.link_id);
 	} else {
 		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	}
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 1f3e0765a8ab..e616bfbe687b 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -515,9 +515,14 @@ int drv_set_key(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	if (WARN_ON(key->link_id >= 0 && sdata->vif.active_links &&
-		    !(sdata->vif.active_links & BIT(key->link_id))))
-		return -ENOLINK;
+	if (key->link_id >= 0) {
+		u16 active_links = sta ? sta->active_links :
+					 sdata->vif.active_links;
+
+		if (WARN_ON(active_links &&
+			    !(active_links & BIT(key->link_id))))
+			return -ENOLINK;
+	}
 
 	if (fips_enabled)
 		return -EOPNOTSUPP;
@@ -621,6 +626,8 @@ int drv_change_sta_links(struct ieee80211_local *local,
 	if (ret)
 		return ret;
 
+	sta->active_links = new_links;
+
 	/* during reconfig don't add it to debugfs again */
 	if (local->in_reconfig || local->resuming)
 		return 0;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d1e3fe37d2e3..9b6a1f0627c6 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -197,9 +197,13 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		}
 	}
 
-	if (key->conf.link_id >= 0 && sdata->vif.active_links &&
-	    !(sdata->vif.active_links & BIT(key->conf.link_id)))
-		return 0;
+	if (key->conf.link_id >= 0) {
+		u16 active_links = sta ? sta->sta.active_links :
+					 sdata->vif.active_links;
+
+		if (active_links && !(active_links & BIT(key->conf.link_id)))
+			return 0;
+	}
 
 	ret = drv_set_key(key->local, SET_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8b95a3277066..4caa1853531a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9763,11 +9763,15 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!have_sta) {
-		if (mlo)
+		if (mlo) {
 			new_sta = sta_info_alloc_with_link(link, ap_mld_addr,
 							   cbss->bssid);
-		else
+			/* the auth/assoc link is currently the active link */
+			if (new_sta)
+				new_sta->sta.active_links = BIT(link_id);
+		} else {
 			new_sta = sta_info_alloc(sdata, ap_mld_addr, GFP_KERNEL);
+		}
 
 		if (!new_sta) {
 			err = -ENOMEM;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a86da3c70152..a9c0f873266d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -672,6 +672,7 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		sta_info_add_link(sta, link_id, &sta->deflink,
 				  &sta->sta.deflink);
 		sta->sta.valid_links = BIT(link_id);
+		/* active_links isn't set yet */
 	} else {
 		sta_info_add_link(sta, 0, &sta->deflink, &sta->sta.deflink);
 	}
@@ -1087,7 +1088,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 				continue;
 
 			ieee80211_link_sta_debugfs_add(link_sta);
-			if (sdata->vif.active_links & BIT(i))
+			if (sta->sta.active_links & BIT(i))
 				ieee80211_link_sta_debugfs_drv_add(link_sta);
 		}
 	} else {
@@ -2598,7 +2599,7 @@ void ieee80211_sta_recalc_aggregates(struct ieee80211_sta *pubsta)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
-	__ieee80211_sta_recalc_aggregates(sta, sta->sdata->vif.active_links);
+	__ieee80211_sta_recalc_aggregates(sta, sta->sta.active_links);
 }
 EXPORT_SYMBOL(ieee80211_sta_recalc_aggregates);
 
@@ -3647,6 +3648,13 @@ void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id)
 		ieee80211_unlink_link_sta_keys(sta->local, link_sta);
 
 	sta->sta.valid_links &= ~BIT(link_id);
+	sta->sta.active_links &= ~BIT(link_id);
+
+	WARN(!sta->sta.valid_links || !sta->sta.active_links,
+	     "STA %pM has no links after removing %d (valid:0x%x, active:0x%x)\n",
+	     sta->sta.addr, link_id,
+	     sta->sta.valid_links,
+	     sta->sta.active_links);
 
 	if (!WARN_ON(!test_sta_flag(sta, WLAN_STA_INSERTED)))
 		drv_change_sta_links(sdata->local, sdata, &sta->sta,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 110788c0d623..4b1c441b610e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -922,6 +922,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 /*
  * Create a new STA info, caller owns returned structure
  * until sta_info_insert().
+ * Note: neither allocation function sets sta->sta.active_links!
  */
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				const u8 *addr, gfp_t gfp);
-- 
2.56.0

