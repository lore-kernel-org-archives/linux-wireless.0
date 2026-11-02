Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655838;
	b=l84UHa7f/MoxEgGubgA8Fxap1WFoze8o2lfQ3o/50uP6TE6iwIORtADCLJDHKMyB73YA
	 WYk8l+1WxBhKxwwDXqc4VyqKLiwUqIHq7d4bbkQkv2Bf/f0ivTJaahDQ8tzBme3PSYC9F
	 CuuKEaWX/WzdhaetegPVxCLhs+BpUSy+QX+O4gEnSh7xp+uNK5BXLqoP8l6dLZMfQDzrm
	 pV/CJ0ZKz57PHfP3k7j3flHv7OIf5qZTMziYJ6TSJXW95xqiU9y5/qRn4ofbEbXqsFfB5
	 Ddyygchum8LxMzxnoAZZMS7dXc8ayhEaUZotjXdt6ogesEsf6wkdGlltWJ3398ziwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655838;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AJeOWVPzPpURRiQuonps6badd471Heqm9FDQrYkHK0g=;
	b=rXBzt/WHOffmQZet4ouH39xkhJnSkGh3qJf/CxPZlfpeUl4ZTBwgcixE2Wr2w6VzlMt5
	 ovo4MlE46eLJyrZwOoSVjqdOta/+CmEyzA/JOgpu/KP5yR5DoxuVfq1dnzfynUV02Fgcr
	 POYrj0HiJIsAkd34rUoXL/N42NKrD6xi8Nxch/cJH5nUxi8LccycM/6hKpqA5kFMvoK9F
	 2LWGpXC5c8euw8Stu59WG4kzkjjDwSQXNfbG+D1ZRc1rQMWNeg/G8HtnxoUaE61WJFytg
	 3WczS45iU9KX5MRwNwnlMsKmasliLtNd9d/nrol+I0oH/KQEqIS84IKEhg/csoIGjjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QgbRGHx0;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9973606D80A
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=QgbRGHx0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=AJeOWVPzPpURRiQuonps6badd471Heqm9FDQrYkHK0g=;
	t=1793655837; x=1794865437; b=QgbRGHx0G8RcOvwevElF62f2bAjHyH50XEi+gzQ6Vl6mD4R
	NTaibhhzoRmxN+AW56+5hmsLEvbQBgQGNUeyT85FPTo84qiSvfyhYrnwbjsq3IM47C/QbuRdglZ8J
	RnshKVSa+d1/SO0porQ/Ss0u255Tsu0bVNfa384tJ74i/WFJfu30RRcFQqKe3/cbXikNITK+dPzsl
	ZZsU+BGVfs++fXBMITU812rzjQQZPAgwBRZq4STMXJE0sA7fg7yisNRcBnsCgdIZJuBxs5MgwjyXp
	6Co2zLy/QP97ffQby477U7C5Jf/Rb2OoTQ2eEgGTzoY7Iqkh7Ex++LAnpIPcGaLQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzoo-000000020tw-3G2o;
	Mon, 02 Nov 2026 22:43:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 5/7] wifi: mac80211: add sta_info_alloc_with_links()
Date: Mon,  2 Nov 2026 22:42:41 +0100
Message-ID: <20261102224349.afbaee552695.Ic42518fe014505f88487c649c7a208a1317d87cf@changeid>
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

For SMD Transition, we'll need to allocate a station with
multiple links, refactor the existing code to add such a
function.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 96 ++++++++++++++++++++++++++++++++++++++---
 net/mac80211/sta_info.h |  8 ++++
 2 files changed, 97 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3c2e08808e99..a86da3c70152 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -677,9 +677,11 @@ __sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	sta->sta.cur = &sta->sta.deflink.agg;
-	sta->sta.deflink.link_conf = link_data_pub_link_conf(link);
-	if (WARN_ON(!sta->sta.deflink.link_conf))
-		goto free;
+	if (link) {
+		sta->sta.deflink.link_conf = link_data_pub_link_conf(link);
+		if (WARN_ON(!sta->sta.deflink.link_conf))
+			goto free;
+	}
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->ps_lock);
@@ -826,6 +828,62 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	return __sta_info_alloc(sdata, &sdata->deflink, addr, -1, addr, gfp);
 }
 
+struct sta_info *
+sta_info_alloc_with_links(struct ieee80211_sub_if_data *sdata,
+			  const u8 *mld_addr,
+			  const u8 *link_addrs[IEEE80211_MLD_MAX_NUM_LINKS])
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int first = -1;
+
+	if (WARN_ON(!link_addrs))
+		return NULL;
+
+	for (int link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
+		if (!link_addrs[link_id])
+			continue;
+		first = link_id;
+		break;
+	}
+
+	if (WARN_ON(first < 0))
+		return NULL;
+
+	sta = __sta_info_alloc(sdata, NULL, mld_addr, first,
+			       link_addrs[first], GFP_KERNEL);
+	if (!sta)
+		return NULL;
+
+	for (int link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
+		struct sta_link_alloc *alloc;
+
+		if (!link_addrs[link_id] || link_id == first)
+			continue;
+
+		alloc = kzalloc_obj(*alloc);
+		if (!alloc)
+			goto free;
+
+		if (sta_info_alloc_link(local, &alloc->info, GFP_KERNEL)) {
+			kfree(alloc);
+			goto free;
+		}
+
+		sta_info_add_link(sta, link_id, &alloc->info, &alloc->sta);
+		memcpy(alloc->info.addr, link_addrs[link_id], ETH_ALEN);
+		memcpy(alloc->sta.addr, link_addrs[link_id], ETH_ALEN);
+
+		sta->sta.valid_links |= BIT(link_id);
+	}
+
+	return sta;
+
+free:
+	sta_info_free(local, sta);
+	return NULL;
+}
+
 struct sta_info *sta_info_alloc_with_link(struct ieee80211_link_data *link,
 					  const u8 *mld_addr,
 					  const u8 *link_addr)
@@ -969,9 +1027,25 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (err)
 		goto out_drop_sta;
 
-	if (sta->sta.valid_links) {
-		err = link_sta_info_hash_add(local, &sta->deflink);
+	for (int i = 0; i < ARRAY_SIZE(sta->link); i++) {
+		struct link_sta_info *link_sta;
+
+		if (!(sta->sta.valid_links & BIT(i)))
+			continue;
+
+		link_sta = wiphy_dereference(local->hw.wiphy, sta->link[i]);
+		if (WARN_ON(!link_sta))
+			continue;
+
+		err = link_sta_info_hash_add(local, link_sta);
 		if (err) {
+			for (int j = 0; j < i; j++) {
+				link_sta = wiphy_dereference(local->hw.wiphy,
+							     sta->link[j]);
+				if (link_sta)
+					link_sta_info_hash_del(local,
+							       link_sta);
+			}
 			sta_info_hash_del(local, sta);
 			goto out_drop_sta;
 		}
@@ -1037,8 +1111,16 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 
 	return 0;
  out_remove:
-	if (sta->sta.valid_links)
-		link_sta_info_hash_del(local, &sta->deflink);
+	for (int i = 0; i < ARRAY_SIZE(sta->link); i++) {
+		struct link_sta_info *link_sta;
+
+		if (!(sta->sta.valid_links & BIT(i)))
+			continue;
+
+		link_sta = wiphy_dereference(local->hw.wiphy, sta->link[i]);
+		if (link_sta)
+			link_sta_info_hash_del(local, link_sta);
+	}
 	sta_info_hash_del(local, sta);
 	list_del_rcu(&sta->list);
  out_drop_sta:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5187e3eadf30..110788c0d623 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -928,6 +928,14 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_alloc_with_link(struct ieee80211_link_data *link,
 					  const u8 *mld_addr,
 					  const u8 *link_addr);
+/*
+ * Note: Unlike sta_info_alloc_with_link(), none of the link stations
+ * actually get a link_conf pointer! Must be set later.
+ */
+struct sta_info *
+sta_info_alloc_with_links(struct ieee80211_sub_if_data *sdata,
+			  const u8 *mld_addr,
+			  const u8 *link_addrs[IEEE80211_MLD_MAX_NUM_LINKS]);
 
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
 
-- 
2.56.0

