Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657436;
	b=pQ6dP6V4SNYSnGbgzu0AfvN2b6hAiB9MidQKxfEZFIiON25cH2yYN4FJUgg0vMsuYUhD
	 5uaUcSeouAbej1TYr5W5hoqtOPe11gnJwq3kInB351BV1sAzQ/P2ADzcBovPx/27mDwOw
	 pizkg7OlB/4u88RbPXSmKG6XE/T1Ta8xwYpzKLT1fq1VsoTmDlmqYePlP7XYR/f8dm/B5
	 fMJCtbAQ//1WhAZGLhy3Mgaxz7QY5im+JyP1NRokE/J6QR3SRaiGLoaN/JnRej7YA7G0O
	 pGJFGsMbcUsGpAawQc2NIiTiSVCsdUYM+2/DiyVSxXmwW5iW8lP63ofZHu5tc1UhE/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657436;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OQldY4l1pHnqTBxGE0TBUNvZ0yOl5hQJwG3arxwD9ug=;
	b=cgZGoh15UbvR/BcIHe68nz4BJBwnvWtHu5nmIaaucywJnk2WQ8itBw8ZmCLkTmWe7OQO
	 NdulKtGkUA9Heo2F2MdC4Woo8BLqKnVjvQG/Go6B6gm7xOm4UAz+rjAYpB2oRRJKf4wzn
	 SPzkiqtbXGkJd+bsIv05nw8Q+RvOh743SCuzOBJ/dQcvbfUPtIcj9K0UmHrVUmVc25FFZ
	 vSMg+Uxg35QGOdupRBkQLGpZ1g2D4v7XKj8Gk8ZasabrPCauI9QKLr1CDbm1H+tq7WllZ
	 978MlxwrURysSjetoikXkTR15sbO+XAhnsNu7AMdHduvze8bMy6YWTynadPZS0MI+8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GB977INd;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29F606A337
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=GB977INd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OQldY4l1pHnqTBxGE0TBUNvZ0yOl5hQJwG3arxwD9ug=;
	t=1793657435; x=1794867035; b=GB977INd+rW4Hehm+xdQSgAJehjrOupVDKLndEkv68ABY1D
	FAeRV8JaTpC350RPDeCmNnPDqxgnKgae6zGao/+QfEue2kEV2Mh+K1z9j11K1OdBaJVBQQiY2cp3c
	/tGv5fz0yw/qEuIlZlSfcBZL5xOMv8jwHrNthM7CEDFv+l4WhurM+ZIFl0/E1gDkG7nvhjMMDAog8
	cCLaln3eSSBciVy8Czd7JoP+Wr9XOxrdrBGtLa1SjBz6FI/P453TeCSe1gYCv4MeF7GJdiKYxWNlK
	ew2PVHrfUYSabni3la2CwYYIhgcAVa8Im4Hlg0F34EqRqU3GFM6zDl9BViHWi2OQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ea-000000022rO-1LW2;
	Mon, 02 Nov 2026 23:10:32 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/8] wifi: mac80211: refactor link handling
Date: Mon,  2 Nov 2026 23:08:21 +0100
Message-ID: <20261102231028.49ce503535aa.Idab522ee67653f0fd6666ff4ccd4d2e7076109c2@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102221028.1124852-10-johannes@sipsolutions.net>
References: <20261102221028.1124852-10-johannes@sipsolutions.net>
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

For SMD transition, we're going to have to allocate links that
are for the connection to the target AP MLD, which are not
linked into the vif/sdata yet.

Refactor the link allocation, attaching, detaching and freeing
so that we can separately allocate (and free on abandon) those
links; expose those functions.

Actually swapping over to the new links during SMD Transition
will require more work, however.

While at it add a missing synchronize_rcu() on the error path,
the links were previously published in the data structure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   5 ++
 net/mac80211/iface.c       |   1 +
 net/mac80211/link.c        | 132 ++++++++++++++++++++++++++-----------
 3 files changed, 98 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..eb31691c89d5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2265,6 +2265,11 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 			 int link_id,
 			 struct ieee80211_link_data *link,
 			 struct ieee80211_bss_conf *link_conf);
+struct ieee80211_link_data *
+ieee80211_alloc_link(struct ieee80211_sub_if_data *sdata, int link_id);
+void ieee80211_free_link(struct ieee80211_link_data *link);
+void ieee80211_link_attach(struct ieee80211_link_data *link);
+void ieee80211_link_detach(struct ieee80211_link_data *link);
 void ieee80211_link_stop(struct ieee80211_link_data *link);
 int ieee80211_vif_set_links(struct ieee80211_sub_if_data *sdata,
 			    u16 new_links, u16 dormant_links);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8bfd6bc9c9fe..0f3fab2a3490 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1252,6 +1252,7 @@ static void ieee80211_sdata_init(struct ieee80211_local *local,
 	 * MLD connection, we get a separate allocation for it.
 	 */
 	ieee80211_link_init(sdata, -1, &sdata->deflink, &sdata->vif.bss_conf);
+	ieee80211_link_attach(&sdata->deflink);
 }
 
 int ieee80211_add_virtual_monitor(struct ieee80211_local *local,
diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index ce1c95b40cd9..428759f8dec3 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -152,12 +152,7 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 		default:
 			WARN_ON(1);
 		}
-
-		ieee80211_link_debugfs_add(link);
 	}
-
-	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
-	rcu_assign_pointer(sdata->link[link_id], link);
 }
 
 void ieee80211_link_stop(struct ieee80211_link_data *link)
@@ -189,6 +184,61 @@ struct link_container {
 	struct ieee80211_bss_conf conf;
 };
 
+struct ieee80211_link_data *
+ieee80211_alloc_link(struct ieee80211_sub_if_data *sdata, int link_id)
+{
+	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
+	struct link_container *link;
+
+	link = kzalloc_obj(*link);
+	if (!link)
+		return NULL;
+
+	ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
+	ieee80211_link_setup(&link->data);
+	if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		ieee80211_set_wmm_default(&link->data, true, non_sta);
+
+	return &link->data;
+}
+
+void ieee80211_free_link(struct ieee80211_link_data *link)
+{
+	struct link_container *container =
+		container_of(link, struct link_container, data);
+
+	ieee80211_link_stop(link);
+	kfree(container);
+}
+
+void ieee80211_link_attach(struct ieee80211_link_data *link)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+
+	if (link != &sdata->deflink)
+		ieee80211_link_debugfs_add(link);
+
+	rcu_assign_pointer(sdata->vif.link_conf[link->link_id], link->conf);
+	rcu_assign_pointer(sdata->link[link->link_id], link);
+}
+
+void ieee80211_link_detach(struct ieee80211_link_data *link)
+{
+	struct ieee80211_sub_if_data *sdata = link->sdata;
+
+	/*
+	 * The deflink's debugfs lives directly in the vif directory and is
+	 * (re)created together with it in ieee80211_debugfs_recreate_netdev();
+	 * it is torn down explicitly in ieee80211_tear_down_links() after that
+	 * recreation, so skip it here.
+	 */
+	if (link != &sdata->deflink)
+		ieee80211_link_debugfs_remove(link);
+
+	rcu_assign_pointer(sdata->vif.link_conf[link->link_id], NULL);
+	rcu_assign_pointer(sdata->link[link->link_id], NULL);
+}
+
 static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 				      struct link_container **links, u16 mask)
 {
@@ -205,8 +255,9 @@ static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 		if (WARN_ON(!link))
 			continue;
 		ieee80211_remove_link_keys(link, &keys);
-		ieee80211_link_debugfs_remove(link);
 		ieee80211_link_stop(link);
+		if (link == &sdata->deflink)
+			ieee80211_link_debugfs_remove(link);
 	}
 
 	synchronize_rcu();
@@ -214,15 +265,6 @@ static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 	ieee80211_free_key_list(sdata->local, &keys);
 }
 
-static void ieee80211_free_links(struct ieee80211_sub_if_data *sdata,
-				 struct link_container **links)
-{
-	unsigned int link_id;
-
-	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++)
-		kfree(links[link_id]);
-}
-
 static int ieee80211_check_dup_link_addrs(struct ieee80211_sub_if_data *sdata)
 {
 	unsigned int i, j;
@@ -296,11 +338,10 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	unsigned long sta_rem = rem;
 	unsigned int link_id;
 	int ret;
-	struct link_container *links[IEEE80211_MLD_MAX_NUM_LINKS] = {}, *link;
+	struct link_container *links[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
-	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
 	struct sta_info *sta;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
@@ -319,12 +360,14 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 
 	/* allocate new link structures first */
 	for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
-		link = kzalloc_obj(*link);
-		if (!link) {
+		struct ieee80211_link_data *data;
+
+		data = ieee80211_alloc_link(sdata, link_id);
+		if (!data) {
 			ret = -ENOMEM;
 			goto free;
 		}
-		links[link_id] = link;
+		links[link_id] = container_of(data, struct link_container, data);
 	}
 
 	/* keep track of the old pointers for the driver */
@@ -336,18 +379,20 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 
 	/* grab old links to free later */
 	for_each_set_bit(link_id, &rem, IEEE80211_MLD_MAX_NUM_LINKS) {
-		if (rcu_access_pointer(sdata->link[link_id]) != &sdata->deflink) {
+		struct ieee80211_link_data *old_link =
+			rcu_access_pointer(sdata->link[link_id]);
+
+		if (old_link != &sdata->deflink) {
 			/*
 			 * we must have allocated the data through this path so
 			 * we know we can free both at the same time
 			 */
-			to_free[link_id] = container_of(rcu_access_pointer(sdata->link[link_id]),
+			to_free[link_id] = container_of(old_link,
 							typeof(*links[link_id]),
 							data);
 		}
 
-		RCU_INIT_POINTER(sdata->link[link_id], NULL);
-		RCU_INIT_POINTER(sdata->vif.link_conf[link_id], NULL);
+		ieee80211_link_detach(old_link);
 	}
 
 	if (!old_links)
@@ -358,16 +403,14 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!use_deflink &&
 			rcu_access_pointer(sdata->link[link_id]) == &sdata->deflink);
 
-		link = links[link_id];
-		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
-		ieee80211_link_setup(&link->data);
-		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
-			ieee80211_set_wmm_default(&link->data, true, non_sta);
+		ieee80211_link_attach(&links[link_id]->data);
 	}
 
-	if (new_links == 0)
+	if (new_links == 0) {
 		ieee80211_link_init(sdata, -1, &sdata->deflink,
 				    &sdata->vif.bss_conf);
+		ieee80211_link_attach(&sdata->deflink);
+	}
 
 	ret = ieee80211_check_dup_link_addrs(sdata);
 	if (!ret) {
@@ -397,14 +440,14 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		ret = 0;
 
 	if (ret) {
-		/* restore config */
-		memcpy(sdata->link, old_data, sizeof(old_data));
-		memcpy(sdata->vif.link_conf, old, sizeof(old));
+		/* restore config; add/rem can overlap on link 0, so detach first */
+		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS)
+			ieee80211_link_detach(&links[link_id]->data);
+		for_each_set_bit(link_id, &rem, IEEE80211_MLD_MAX_NUM_LINKS)
+			ieee80211_link_attach(old_data[link_id]);
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
-		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
-			ieee80211_link_debugfs_remove(&links[link_id]->data);
-			ieee80211_link_stop(&links[link_id]->data);
-		}
+		/* the new links were published, wait before freeing them */
+		synchronize_rcu();
 		/* and free (only) the newly allocated links */
 		memset(to_free, 0, sizeof(links));
 		goto free;
@@ -445,13 +488,16 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 free:
 	/* if we failed during allocation, only free all */
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
-		kfree(links[link_id]);
+		if (links[link_id])
+			ieee80211_free_link(&links[link_id]->data);
 		links[link_id] = NULL;
 	}
 deinit:
-	if (use_deflink)
+	if (use_deflink) {
 		ieee80211_link_init(sdata, -1, &sdata->deflink,
 				    &sdata->vif.bss_conf);
+		ieee80211_link_attach(&sdata->deflink);
+	}
 	return ret;
 }
 
@@ -463,7 +509,13 @@ int ieee80211_vif_set_links(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_vif_update_links(sdata, links, new_links,
 					 dormant_links);
-	ieee80211_free_links(sdata, links);
+
+	/*
+	 * Removed links were already stopped and RCU-synchronized in
+	 * ieee80211_tear_down_links(), so only the memory is left to free.
+	 */
+	for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++)
+		kfree(links[i]);
 
 	return ret;
 }
-- 
2.56.0

