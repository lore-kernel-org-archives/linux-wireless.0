Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C724F55DD
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569666; cv=none; b=pw2Gimjhuum8EhjGNUTsQ5BPRjhaqtH534lT0WybqbwYktZc6Av7WxsHrRKszjQ2qnhbjYSdTQl7jlHtkR7DLK0q+ZoCWJDWLUhos4HrsvGJVKoVUNmnbBUSFxmDSIitJ69fZ2Zi9GwzExVv8tM8/dfyu9uWU5WO91kdm5dGD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569666; c=relaxed/simple;
	bh=2ATuOEv6Hw5N+AzVi+8a6CmQGRQAWctHBYF72lh0A0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHnO2ojZV1AginovqcH2R5kta9iEHYPf8YFJpLK4yIcqo7IImKfvBodAoxcXUw9mUrsP2LWCYFTCx4RJMkvJBuVzQQado3HjSU5cJxK0Tz2INARs25BXaUr+rLbxbi5USFR+kH8sODQ5f8PxesfEuT34iXIy2jL+AxgiyiIIj1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=N3+Okwp7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="N3+Okwp7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hEvRP2h5yvdrKT+VH7dfct2zj6xzZ8vVAoT/fvlMYl4=;
	t=1791569664; x=1792779264; b=N3+Okwp7V2FGh5HyYTr4RtPGfwcApnrUp9d2vbgTWr8TnMa
	q7t7gyoP2yztuF/jiXLRqLpByfrF5qyEghKqjwoMS/AynRDAM29P3gvYni8yg+hgeX7h/SF9peO+R
	nD3lQyIp21L+uJggub7bVk70s5+7XDgt3EQitNvAXWanoEMLiRFLWnzu2F3ExrhVvXB2XqMAaZzMh
	VFBXsgAib1cZCvEhlUX5h/2/OLKlJhHZimWUO5wcawCigIyIyXD1oCIovdxlHAtiSaisX5oXDvfxa
	NpiofpnZy9tPQOj7fGKYr6zUjnP6P2L4A4E6YYZrpvjgTe/eYQKLU/nlLC0t+LaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF6r-0000000AtGH-0uUl;
	Fri, 09 Oct 2026 20:14:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 03/17] wifi: mac80211: refactor beacon allocation
Date: Fri,  9 Oct 2026 20:10:02 +0200
Message-ID: <20261009201417.ba48af051dfa.If468a87e4c71f8fe8d0f467525a86e7921496e9a@changeid>
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

Refactor allocating/filling beacon data to a new function,
so we can reuse it for lockless beacon updates. Also split
out the bssid_indicator calculation, lockless updates will
need to ensure it didn't change.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 127 +++++++++++++++++++++++++--------------------
 1 file changed, 71 insertions(+), 56 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 08088a2656c7..0b124b04003e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1483,52 +1483,16 @@ static void ieee80211_update_ap_bandwidth(struct ieee80211_link_data *link,
 	ieee80211_recalc_chanctx_min_def(local, chanctx);
 }
 
-static int
-ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-			struct ieee80211_link_data *link,
-			struct cfg80211_beacon_data *params,
-			const struct ieee80211_csa_settings *csa,
-			const struct ieee80211_color_change_settings *cca,
-			u64 *changed)
+static struct beacon_data *
+ieee80211_alloc_beacon(struct cfg80211_mbssid_elems *mbssid,
+		       struct cfg80211_rnr_elems *rnr,
+		       int head_len, int tail_len)
 {
-	struct cfg80211_mbssid_elems *mbssid = NULL;
-	struct cfg80211_rnr_elems *rnr = NULL;
-	struct beacon_data *new, *old;
-	int new_head_len, new_tail_len;
-	int size, err;
+	struct beacon_data *new;
+	int size;
 	u8 *pos;
-	u64 _changed = BSS_CHANGED_BEACON;
-	struct ieee80211_bss_conf *link_conf = link->conf;
 
-	old = sdata_dereference(link->u.ap.beacon, sdata);
-
-	/* Need to have a beacon head if we don't have one yet */
-	if (!params->head && !old)
-		return -EINVAL;
-
-	/* new or old head? */
-	if (params->head)
-		new_head_len = params->head_len;
-	else
-		new_head_len = old->head_len;
-
-	/* new or old tail? */
-	if (params->tail || !old)
-		/* params->tail_len will be zero for !params->tail */
-		new_tail_len = params->tail_len;
-	else
-		new_tail_len = old->tail_len;
-
-	size = sizeof(*new) + new_head_len + new_tail_len;
-
-	/* new or old multiple BSSID elements? */
-	if (params->mbssid_ies) {
-		mbssid = params->mbssid_ies;
-		rnr = params->rnr_ies;
-	} else if (old && old->mbssid_ies) {
-		mbssid = old->mbssid_ies;
-		rnr = old->rnr_ies;
-	}
+	size = sizeof(*new) + head_len + tail_len;
 
 	if (mbssid) {
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1540,9 +1504,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	new = kzalloc(size, GFP_KERNEL);
 	if (!new)
-		return -ENOMEM;
-
-	/* start filling the new info now */
+		return NULL;
 
 	/*
 	 * pointers go into the block we allocated, the order in memory is
@@ -1565,11 +1527,11 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	}
 
 	new->head = pos;
-	new->head_len = new_head_len;
-	pos += new_head_len;
+	new->head_len = head_len;
+	pos += head_len;
 	new->tail = pos;
-	new->tail_len = new_tail_len;
-	pos += new_tail_len;
+	new->tail_len = tail_len;
+	pos += tail_len;
 
 	/* copy in optional mbssid_ies */
 	if (mbssid) {
@@ -1577,14 +1539,67 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 						    mbssid);
 		if (rnr)
 			ieee80211_copy_rnr_beacon(pos, new->rnr_ies, rnr);
-		/* update bssid_indicator */
-		if (new->mbssid_ies->cnt && new->mbssid_ies->elem[0].len > 2)
-			link_conf->bssid_indicator =
-					*(new->mbssid_ies->elem[0].data + 2);
-		else
-			link_conf->bssid_indicator = 0;
 	}
 
+	return new;
+}
+
+static u8 ieee80211_beacon_bssid_indicator(struct beacon_data *beacon)
+{
+	if (beacon->mbssid_ies->cnt && beacon->mbssid_ies->elem[0].len > 2)
+		return *(beacon->mbssid_ies->elem[0].data + 2);
+	return 0;
+}
+
+static int
+ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+			struct ieee80211_link_data *link,
+			struct cfg80211_beacon_data *params,
+			const struct ieee80211_csa_settings *csa,
+			const struct ieee80211_color_change_settings *cca,
+			u64 *changed)
+{
+	struct cfg80211_mbssid_elems *mbssid = params->mbssid_ies;
+	struct cfg80211_rnr_elems *rnr = mbssid ? params->rnr_ies : NULL;
+	struct beacon_data *new, *old;
+	int new_head_len, new_tail_len;
+	int err;
+	u64 _changed = BSS_CHANGED_BEACON;
+	struct ieee80211_bss_conf *link_conf = link->conf;
+
+	old = sdata_dereference(link->u.ap.beacon, sdata);
+
+	/* Need to have a beacon head if we don't have one yet */
+	if (!params->head && !old)
+		return -EINVAL;
+
+	/* new or old head? */
+	if (params->head)
+		new_head_len = params->head_len;
+	else
+		new_head_len = old->head_len;
+
+	/* new or old tail? */
+	if (params->tail || !old)
+		/* params->tail_len will be zero for !params->tail */
+		new_tail_len = params->tail_len;
+	else
+		new_tail_len = old->tail_len;
+
+	/* new or old multiple BSSID elements? */
+	if (!mbssid && old && old->mbssid_ies) {
+		mbssid = old->mbssid_ies;
+		rnr = old->rnr_ies;
+	}
+
+	new = ieee80211_alloc_beacon(mbssid, rnr, new_head_len, new_tail_len);
+	if (!new)
+		return -ENOMEM;
+
+	if (new->mbssid_ies)
+		link_conf->bssid_indicator =
+			ieee80211_beacon_bssid_indicator(new);
+
 	if (csa) {
 		new->cntdwn_current_counter = csa->count;
 		memcpy(new->cntdwn_counter_offsets, csa->counter_offsets_beacon,
-- 
2.56.0

