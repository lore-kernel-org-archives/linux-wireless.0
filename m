Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655836;
	b=KEYWbt0LdgEnOFWVptQaQB6YM+hFSsp9Cbgl7QsxceUeBnbbjnyBDzSXgLRSTNiOatoZ
	 9by7BXn3d0sw9KojRuKnEIm/AHonyxt/4lp+jTFg2I0jJnpGNMfRm8SdXz/stcd85VSMz
	 0ssfNt1XiGg7vgSwlxKFeUjQrxLbkSKaUMQQeqadA5pHxkdmWRN4RZtMF4echet1yq7ng
	 yd02ZF0dmeOmj/seh6YCgwmtTDWF5c35Z05TcODHLHQuFTkYwRNLNXcbdQ1F/ry41rRdW
	 zYhACjtX2sI3nYVzSNllQWzxaRVNhYzPAd7TkKpPi9elH3dBF9+tJkwtxSyZdDU+0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655836;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=N4WB/P9XsI+n7MaXjGKNBuq3RGN/D3g9nmzs4959GWg=;
	b=WjqGoPWGzfJStS+IauprhcgW+Ck4iKVsP/WsKj6puV/Wb1E/0Nluh++8D30itkbSqZp1
	 SA8GGyyPrx+4v93GB6FfR+qZTr0huJpknjrQCRtXINdv+pe9Mp0cw1BERRRPdQiHtsKfR
	 2AfaKS5yAGDUrkJCQa7a/XKW0us9K61YPk8zP2AU70Fl0ZhkTb/lFNn/MdG6swAoUbeCe
	 gnCgCGRGfsB+AjcMIoSBUI3p9b0r6Ns9vu6wxvryW2dvtnVT5sS0zspkdVp362quXKKZc
	 LWc8xv5+8Hf9DHVXhff8GMc02JIEJlvPbknM+mzeU8RtJIijJyiVrfY1LvQD9pzH/Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=t1fENsXS;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B256606A33B
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=t1fENsXS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=N4WB/P9XsI+n7MaXjGKNBuq3RGN/D3g9nmzs4959GWg=;
	t=1793655836; x=1794865436; b=t1fENsXSp8Q7RopmIXX0qOQgkHW1SNnD066/xXGNFXGJMZZ
	pxMDdsedejOjWTPde29G/Ju/bPjT2YBL7OnMyZTNN4KYrsxIaonbqfJEeApuX7HDJpoMAg8yjsEPS
	xPG5QEph5v6nvmYPS+03/OfJcJBPCPB8q7o22s20MLhtJeMEDkdHzgSUOpyBm5aDDzSocoRbBnZ7X
	kp2sdTqgEfUYXdgrUFFyZruJVi3yUSFZFBo2SvGPcnprY3NB4boii49JlVK5E8ArXQdBQyPxcaL8T
	8G/M0D4Pyf93qwLxkeIM8ZLto/QSilTXNniEmTkd0Zfue+XcRYhwz8lUQCWxzPww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzoo-000000020tw-0iYp;
	Mon, 02 Nov 2026 22:43:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 4/7] wifi: mac80211: add link_sta::link_conf pointer
Date: Mon,  2 Nov 2026 22:42:40 +0100
Message-ID: <20261102224348.52ac02661ade.Ic73c00fe816e713c2d52d02fb3300a604e29597c@changeid>
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

It's relatively simple to maintain this pointer back to the
interface's link_conf, since it has to exist when the link
is added to the station. On the other hand, it's not simple
for the driver to look it up indirectly through the vif and
it won't be possible to do so during SMD Transition.

Add the pointer and keep it pointing to the right place in
mac80211.

While already touching the function prototype anyway, get
rid of the gfp_t argument that's always GFP_KERNEL.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |  4 ++++
 net/mac80211/cfg.c      | 25 ++++++++++++++++++-------
 net/mac80211/mlme.c     |  9 ++++-----
 net/mac80211/sta_info.c | 41 ++++++++++++++++++++++++++++++++++-------
 net/mac80211/sta_info.h |  9 ++++-----
 5 files changed, 64 insertions(+), 24 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2576f9a30b37..e54fa07e2cbf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2619,6 +2619,9 @@ struct ieee80211_sta_aggregates {
  * or a MLD STA(multiple entries) are stored here.
  *
  * @sta: reference to owning STA
+ * @link_conf: The per-link BSS configuration for the link that the
+ *	station belongs to. During SMD Transition, this link might
+ *	not be in vif->links[].
  * @addr: MAC address of the Link STA. For non-MLO STA this is same as the addr
  *	in ieee80211_sta. For MLO Link STA this addr can be same or different
  *	from addr in ieee80211_sta (representing MLD STA addr)
@@ -2648,6 +2651,7 @@ struct ieee80211_sta_aggregates {
  */
 struct ieee80211_link_sta {
 	struct ieee80211_sta *sta;
+	struct ieee80211_bss_conf *link_conf;
 
 	u8 addr[ETH_ALEN];
 	u8 link_id;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a4f242a23957..38898fd58692 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2925,13 +2925,19 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 	 * but we need to have a link_mac in that case as well, so use the
 	 * STA's MAC address in that case.
 	 */
-	if (params->link_sta_params.link_id >= 0)
-		sta = sta_info_alloc_with_link(sdata, mac,
-					       params->link_sta_params.link_id,
-					       params->link_sta_params.link_mac ?: mac,
-					       GFP_KERNEL);
-	else
+	if (params->link_sta_params.link_id >= 0) {
+		struct ieee80211_link_data *link;
+
+		link = wiphy_dereference(wiphy,
+					 sdata->link[params->link_sta_params.link_id]);
+		if (!link)
+			return -ENOLINK;
+
+		sta = sta_info_alloc_with_link(link, mac,
+					       params->link_sta_params.link_mac ?: mac);
+	} else {
 		sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
+	}
 
 	if (!sta)
 		return -ENOMEM;
@@ -6090,6 +6096,7 @@ ieee80211_add_link_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_link_data *link;
 	struct sta_info *sta;
 	int ret;
 
@@ -6105,6 +6112,10 @@ ieee80211_add_link_station(struct wiphy *wiphy, struct net_device *dev,
 	if (sta->sta.valid_links & BIT(params->link_id))
 		return -EALREADY;
 
+	link = wiphy_dereference(wiphy, sdata->link[params->link_id]);
+	if (!link)
+		return -ENOLINK;
+
 	ret = ieee80211_sta_allocate_link(sta, params->link_id);
 	if (ret)
 		return ret;
@@ -6123,7 +6134,7 @@ ieee80211_add_link_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* ieee80211_sta_set_link_valid frees the link upon failure */
-	return ieee80211_sta_set_link_valid(sta, params->link_id);
+	return ieee80211_sta_set_link_valid(sta, link);
 }
 
 static int
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2625103f6307..8b95a3277066 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7223,7 +7223,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (link_id != assoc_data->assoc_link_id) {
-			err = ieee80211_sta_set_link_valid(sta, link_id);
+			err = ieee80211_sta_set_link_valid(sta, link);
 			if (err)
 				goto out_err;
 		}
@@ -9764,9 +9764,8 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	if (!have_sta) {
 		if (mlo)
-			new_sta = sta_info_alloc_with_link(sdata, ap_mld_addr,
-							   link_id, cbss->bssid,
-							   GFP_KERNEL);
+			new_sta = sta_info_alloc_with_link(link, ap_mld_addr,
+							   cbss->bssid);
 		else
 			new_sta = sta_info_alloc(sdata, ap_mld_addr, GFP_KERNEL);
 
@@ -11218,7 +11217,7 @@ ieee80211_process_ml_reconf_resp(struct ieee80211_sub_if_data *sdata,
 		if (add_links_data->link[link_id].status != WLAN_STATUS_SUCCESS)
 			goto disconnect;
 
-		if (ieee80211_sta_set_link_valid(sta, link_id))
+		if (ieee80211_sta_set_link_valid(sta, link))
 			goto disconnect;
 
 		changed |= ieee80211_link_set_associated(link, cbss);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 61aadc3c695d..3c2e08808e99 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -629,8 +629,25 @@ static void sta_info_add_link(struct sta_info *sta,
 	link_sta->agg.max_rc_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_BA;
 }
 
+static struct ieee80211_bss_conf *
+link_data_pub_link_conf(struct ieee80211_link_data *link)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+	struct ieee80211_sub_if_data *bss_sdata = get_bss_sdata(sdata);
+
+	if (sdata == bss_sdata)
+		return link->conf;
+
+	if (link == &sdata->deflink)
+		return bss_sdata->deflink.conf;
+
+	return sdata_dereference(bss_sdata->vif.link_conf[link->link_id],
+				 bss_sdata);
+}
+
 static struct sta_info *
 __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_link_data *link,
 		 const u8 *addr, int link_id, const u8 *link_addr,
 		 gfp_t gfp)
 {
@@ -660,6 +677,9 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	sta->sta.cur = &sta->sta.deflink.agg;
+	sta->sta.deflink.link_conf = link_data_pub_link_conf(link);
+	if (WARN_ON(!sta->sta.deflink.link_conf))
+		goto free;
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->ps_lock);
@@ -803,16 +823,15 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				const u8 *addr, gfp_t gfp)
 {
-	return __sta_info_alloc(sdata, addr, -1, addr, gfp);
+	return __sta_info_alloc(sdata, &sdata->deflink, addr, -1, addr, gfp);
 }
 
-struct sta_info *sta_info_alloc_with_link(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_alloc_with_link(struct ieee80211_link_data *link,
 					  const u8 *mld_addr,
-					  unsigned int link_id,
-					  const u8 *link_addr,
-					  gfp_t gfp)
+					  const u8 *link_addr)
 {
-	return __sta_info_alloc(sdata, mld_addr, link_id, link_addr, gfp);
+	return __sta_info_alloc(link->sdata, link, mld_addr, link->link_id,
+				link_addr, GFP_KERNEL);
 }
 
 static int sta_info_insert_check(struct sta_info *sta)
@@ -3473,12 +3492,15 @@ void ieee80211_sta_free_link(struct sta_info *sta, unsigned int link_id)
 	sta_remove_link(sta, link_id, false);
 }
 
-int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id)
+int ieee80211_sta_set_link_valid(struct sta_info *sta,
+				 struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct link_sta_info *link_sta;
 	u16 old_links = sta->sta.valid_links;
+	int link_id = link->link_id;
 	u16 new_links = old_links | BIT(link_id);
+	struct ieee80211_bss_conf *link_conf;
 	int ret;
 
 	link_sta = rcu_dereference_protected(sta->link[link_id],
@@ -3495,6 +3517,11 @@ int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id)
 	/* we only modify under the mutex so this is fine */
 	rcu_read_unlock();
 
+	link_conf = link_data_pub_link_conf(link);
+	if (WARN_ON(!link_conf))
+		return -EINVAL;
+
+	link_sta->pub->link_conf = link_conf;
 	sta->sta.valid_links = new_links;
 
 	if (WARN_ON(!test_sta_flag(sta, WLAN_STA_INSERTED)))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0a286185125d..5187e3eadf30 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -925,11 +925,9 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  */
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				const u8 *addr, gfp_t gfp);
-struct sta_info *sta_info_alloc_with_link(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_alloc_with_link(struct ieee80211_link_data *link,
 					  const u8 *mld_addr,
-					  unsigned int link_id,
-					  const u8 *link_addr,
-					  gfp_t gfp);
+					  const u8 *link_addr);
 
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
 
@@ -1008,7 +1006,8 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_sta_allocate_link(struct sta_info *sta, unsigned int link_id);
 void ieee80211_sta_free_link(struct sta_info *sta, unsigned int link_id);
-int ieee80211_sta_set_link_valid(struct sta_info *sta, unsigned int link_id);
+int ieee80211_sta_set_link_valid(struct sta_info *sta,
+				 struct ieee80211_link_data *link);
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
-- 
2.56.0

