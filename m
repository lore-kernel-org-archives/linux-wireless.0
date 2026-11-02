Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657439;
	b=VGUtipB3hlkNGvm6jyv68VvXVZfjbq8VxD3iXYwIIWxfxAJEjO0rbwSY//L8MqKLlOQO
	 H+bI9scUJ1lszkLggbvCeYei8txrsAXJxRKKhLdJpDwvu1Xi3UdIuF1m24AOqWGmsomaU
	 VXjzmhGQ4Ih/nPRYFjZiIWuksMsMKQb4Lfp4qn4UAGHUBca6hYfZVv5HScTODkgvJLQay
	 E+5itU0ylQyJFBZS/LNUsSe2NWZc2JZANjFkepYV9CpAdsepN+zB+UCoJhdNIo6rIGeCw
	 AhFwXLsRrVoGB7snfFLh+bnLO+05TVWzfGIBwN2QmuUPJyiwggGLX2qrM+5PrSrV0Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657439;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qwzPzV6RrOtr/8mS/DFN1wtu1BIjopMlM1maO1EZl9I=;
	b=uO67sqbmq1AO7s+Ldhw4n/MOI3YdUOsPoaX9QY79Kw+B+nXkKl9n75fxd46k39JqUYLM
	 bFZQ+xeB6ZW5NrI1YcLKhvhvkElFGrf9YbsDwyKAfRvi99vbdU76rjMFrZSblBkR9RJcy
	 NYseVx/8RnQ32FZQGBg/3s7PI0XokZig/QaebytrDP3kcJVSX4gAWUoya6Dn/vhOcPUoz
	 YwiFdT/CLwY6FvzhgVAulUB5wJoEo1iI60z2aE8/xoGscXqUEK1jiWNPxaM3uAPdmZ7fO
	 yXVsy4YZnBScuDcMbqA6VOC97VLub/5Mv3u1M7WIPdEkOawwNj9E0cgIYypqlX/+sfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=HqVkBgWd;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9B7606A334
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=HqVkBgWd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qwzPzV6RrOtr/8mS/DFN1wtu1BIjopMlM1maO1EZl9I=;
	t=1793657439; x=1794867039; b=HqVkBgWdgxyZtpSZ/a+aNEMk3g3H1kdama+VDB1D88rAV1U
	00wzq/XFO8JOEmUSTobT84UpmV+xGxcWYQZkp8/lDNz7Qh5tzwZsbd0/asJunPKHLe/lbqHN8Hb0C
	jN9MhmsaLHtFAsfbQHJX3I/bWp+8xPUjIPprP1r2J46XrxEEnW1dZSDh5pCVy6LGOVu1q7CyZJ5Gr
	ulupAYHtGpjeYOsdBESdSIEz6gpw0TVeyPqNxRzr8ECl2f5vAvvg+QDhit3zeA+v+NZPZpDP4qVst
	wYzx3HkrWsqADWDA868DqNd1ErEzykFNJXwUGuu6SMthQ9VZSinNd5gYuKJePCcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ef-000000022rO-0n7L;
	Mon, 02 Nov 2026 23:10:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 8/8] wifi: mac80211: move assoc request elems into assoc data
Date: Mon,  2 Nov 2026 23:08:28 +0100
Message-ID: <20261102231028.0d055c096cd0.I608189946575322011d3b2f2543b6513eaa698a5@changeid>
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

These don't need to be stored in the interface, they
can be stored in the assoc data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 10 ++++------
 net/mac80211/mlme.c        | 17 ++++++++---------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 80d9d6233df9..fc75a2e98959 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -508,6 +508,10 @@ struct ieee80211_mgd_assoc_data {
 	u8 fils_kek[FILS_MAX_KEK_LEN];
 	size_t fils_kek_len;
 
+	/* separately allocated, needs to be freed */
+	u8 *req_elems;
+	size_t req_elems_len;
+
 	size_t ie_len;
 	u8 *ie_pos; /* used to fill ie[] with link[].elems */
 	u8 ie[];
@@ -631,12 +635,6 @@ struct ieee80211_if_managed {
 	 */
 	struct wiphy_delayed_work tx_tspec_wk;
 
-	/* Information elements from the last transmitted (Re)Association
-	 * Request frame.
-	 */
-	u8 *assoc_req_ies;
-	size_t assoc_req_ies_len;
-
 	struct wiphy_hrtimer_work ml_reconf_work;
 	u16 removed_links;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8081f0547434..6e9dea7b0373 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2830,14 +2830,15 @@ static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	}
 
 	pos = skb_tail_pointer(skb);
-	kfree(ifmgd->assoc_req_ies);
-	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
-	if (!ifmgd->assoc_req_ies) {
+	/* might already exist (on retry) */
+	kfree(assoc_data->req_elems);
+	assoc_data->req_elems = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	if (!assoc_data->req_elems) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
 
-	ifmgd->assoc_req_ies_len = pos - ie_start;
+	assoc_data->req_elems_len = pos - ie_start;
 
 	info.link_id = assoc_data->assoc_link_id;
 	drv_mgd_prepare_tx(local, sdata, &info);
@@ -5437,6 +5438,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vif_set_links(sdata, 0, 0);
 	}
 
+	kfree(assoc_data->req_elems);
 	kfree(assoc_data);
 }
 
@@ -7561,8 +7563,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	resp.buf = (u8 *)mgmt;
 	resp.len = len;
-	resp.req_ies = ifmgd->assoc_req_ies;
-	resp.req_ies_len = ifmgd->assoc_req_ies_len;
+	resp.req_ies = assoc_data->req_elems;
+	resp.req_ies_len = assoc_data->req_elems_len;
 	cfg80211_rx_assoc_resp(sdata->dev, &resp);
 	assoc_status = status_code == WLAN_STATUS_SUCCESS ? ASSOC_SUCCESS :
 							    ASSOC_REJECTED;
@@ -11011,9 +11013,6 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 		ifmgd->teardown_skb = NULL;
 		ifmgd->orig_teardown_skb = NULL;
 	}
-	kfree(ifmgd->assoc_req_ies);
-	ifmgd->assoc_req_ies = NULL;
-	ifmgd->assoc_req_ies_len = 0;
 	spin_unlock_bh(&ifmgd->teardown_lock);
 	timer_delete_sync(&ifmgd->timer);
 }
-- 
2.56.0

