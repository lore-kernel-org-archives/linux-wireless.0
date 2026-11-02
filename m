Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657439;
	b=y9Tx4rPQD88xYLdnBmo2SndIwdSYssUdkC0/LPSbH6TU5E9SOox7jF89hGIOeAFI36lv
	 masr4IaVA/np06CuphT5LCOVBy2117mVLR4Zw2UHfpNmIIk0lvOMoYypzqQEps4udsOET
	 fookKae9BwRd3gJoC7yUeJH3J+Cy2RkMDPJvZdSv7VYOhdaSxRAXY/fQclQBGWKT9M7JX
	 OKJOyLbuuBO6xC0FbxmaPCLqeQlXILcpT4z/XEkNi/nbTdSkvsb9qJuXOyuTSY+WQ5O1J
	 jACVNDB+ngwLgpHq8PmVJVGhRhsAlLFS0G1IuNI/mKLKFd3pwGuriqpJkTb1Q2VlL7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657439;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=eS3k/u+lgCRPWTs076278Y+6h8y2k/I0l1r9sdIAMFw=;
	b=mkSymziJIOf/aPLffgiqM00w3shTT01A2MA3qgyZ+7HhXEJ3Y7cy8ROyQiSOFuX0lrRT
	 4BjeRp1fQJjRqmR+85ZM43cmQcZxmFPvyUTP7njzxE/KXDzv4QWV6CDe3c/VsrE/ZruZv
	 4qT9vJN3oZ2CojARPpQBJTmNK/DvD4kkCinPdk+NnYqlvnvPTrJ6Q/tQp64YuWz1VnfRz
	 l2fEcyOjXVyYb+hNWg3mmAAx3KJPMY68/zcrFIi8r391gIofsof9vswtzt/PwE+sNVNiI
	 mFsCx5r1bWgACa5NcrpJ0+a7IcXYfyYvyfdVv+/6I2HItWPw8XPqAVAXdxJ0MrFPt6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=wAWyLgz1;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C366606D813
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=wAWyLgz1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eS3k/u+lgCRPWTs076278Y+6h8y2k/I0l1r9sdIAMFw=;
	t=1793657438; x=1794867038; b=wAWyLgz1eMckNvrqCsOZ50ZmuaH2db4sbHnFFKyS7oGUuIl
	D2q09J/+2+cdQgn1uS/fg4tyYucGLTMDbxMrzRM05lv1Asmewu9fOMMlGKJOcy2CPWRwAHZf9xJQe
	KDwdwMf+EmJPgiXSl1dxVVPeEk6alosKrDTON3qrn8mmQUi7JYgx18jnCE7RyE4qUI1M0wqJFXpic
	09jyvfIxDKdrjrqwRIfG+rXtb6vn+IvLq3Cj89xrZAv+fx+ytmE2+jK6yCbTj+vCWJAyRhTwHjr9K
	D6Jlr52SA/2W5aSgf7RTAXteRCjMBNTBjfEne/pfqeTWbRpO8JqAi57TcgtvsSZg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ed-000000022rO-3Nm6;
	Mon, 02 Nov 2026 23:10:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 6/8] wifi: mac80211: implement MLE first-profile inheritance
Date: Mon,  2 Nov 2026 23:08:26 +0100
Message-ID: <20261102231028.739ebd292000.I1bbd546c869812190765f1c7d1f80b8890540ab7@changeid>
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

In association response and other cases, the per-STA profiles
in links (with complete information) inherit elements from the
outer elements. In UHR, this is extended to inherit from the
first link, so that UHR link reconfiguration and other frames
can use inheritance.

Implement the inheritance for this: add a new 'base' copy of
the parsing parameters, initialized to the original input, and
overwrite that to point to the first profile when parsing one
of the frames using this inheritance. The profile finding is
extended to allow -1 link ID to find the first one.

Also constify the parse parameters to make things clearer,
especially in ieee80211_prep_mle_link_parse() which now has
*three* such arguments.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   2 +-
 net/mac80211/parse.c       | 109 +++++++++++++++++++++++++++++--------
 2 files changed, 86 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7e6e87ccce08..80d9d6233df9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2612,7 +2612,7 @@ struct ieee80211_elems_parse_params {
 };
 
 struct ieee802_11_elems *
-ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params);
+ieee802_11_parse_elems_full(const struct ieee80211_elems_parse_params *params);
 
 static inline struct ieee802_11_elems *
 ieee802_11_parse_elems(const u8 *start, size_t len, u8 type,
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index c392ecf58b0c..fc69590753ef 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -920,9 +920,9 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 	return 0;
 }
 
-static void
+static int
 ieee80211_mle_get_sta_prof(struct ieee80211_elems_parse *elems_parse,
-			   u8 link_id)
+			   int link_id)
 {
 	struct ieee802_11_elems *elems = &elems_parse->elems;
 	const struct ieee80211_multi_link_elem *ml = elems->ml_basic;
@@ -932,6 +932,7 @@ ieee80211_mle_get_sta_prof(struct ieee80211_elems_parse *elems_parse,
 	for_each_mle_subelement(sub, (u8 *)ml, ml_len) {
 		struct ieee80211_mle_per_sta_profile *prof = (void *)sub->data;
 		ssize_t sta_prof_len;
+		int prof_link_id;
 		u16 control;
 
 		if (sub->id != IEEE80211_MLE_SUBELEM_PER_STA_PROFILE)
@@ -939,16 +940,18 @@ ieee80211_mle_get_sta_prof(struct ieee80211_elems_parse *elems_parse,
 
 		if (!ieee80211_mle_basic_sta_prof_size_ok(sub->data,
 							  sub->datalen))
-			return;
+			return -1;
 
 		control = le16_to_cpu(prof->control);
+		prof_link_id = u16_get_bits(control,
+					    IEEE80211_MLE_STA_CONTROL_LINK_ID);
 
-		if (link_id != u16_get_bits(control,
-					    IEEE80211_MLE_STA_CONTROL_LINK_ID))
+		/* a link_id of -1 matches the first per-STA profile */
+		if (link_id != -1 && link_id != prof_link_id)
 			continue;
 
 		if (!(control & IEEE80211_MLE_STA_CONTROL_COMPLETE_PROFILE))
-			return;
+			return -1;
 
 		/* the sub element can be fragmented */
 		sta_prof_len =
@@ -961,28 +964,37 @@ ieee80211_mle_get_sta_prof(struct ieee80211_elems_parse *elems_parse,
 						    IEEE80211_MLE_SUBELEM_FRAGMENT);
 
 		if (sta_prof_len < 0)
-			return;
+			return -1;
 
 		elems->prof = (void *)elems_parse->scratch_pos;
 		elems->sta_prof_len = sta_prof_len;
 		elems_parse->scratch_pos += sta_prof_len;
 
-		return;
+		return prof_link_id;
 	}
+
+	return -1;
 }
 
 static const struct element *
 ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
-			      struct ieee80211_elems_parse_params *params,
-			      struct ieee80211_elems_parse_params *sub)
+			      const struct ieee80211_elems_parse_params *params,
+			      struct ieee80211_elems_parse_params *sub,
+			      struct ieee80211_elems_parse_params *base)
 {
 	struct ieee802_11_elems *elems = &elems_parse->elems;
+	struct ieee80211_elems_parse_params new_base = *base;
 	struct ieee80211_mle_per_sta_profile *prof;
 	const struct element *ml_basic_elem = NULL;
+	size_t fixed_len = 4; /* capa/status */
 	const struct element *tmp, *ret;
 	ssize_t ml_len;
 	const u8 *end;
 
+	/* also AID in ST preparation response */
+	if (params->action_frame == IEEE80211_PARSE_ACTION_FRAME_ST_PREP_RESP)
+		fixed_len += 2;
+
 	if (params->mode < IEEE80211_CONN_MODE_EHT)
 		return NULL;
 
@@ -1020,26 +1032,68 @@ ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
 	if (params->link_id == -1)
 		return NULL;
 
-	ieee80211_mle_get_sta_prof(elems_parse, params->link_id);
+	/*
+	 * Per 35.3.3.5.2 "Inheritance from first Per-STA Profile subelement",
+	 * (Draft P802.11bn D1.5) the inheritance base is the first link and
+	 * not the outer frame elements (which don't exist) for the case of
+	 *  - EPP Capabilities And Operation Parameters frame,
+	 *  - UHR Neighboring AP Probe Response frame,
+	 *  - ST preparation request frame,
+	 *  - ST preparation response frame, and
+	 *  - ST execution response frame.
+	 *
+	 * We currently only parse the latter two.
+	 */
+	if (params->action_frame == IEEE80211_PARSE_ACTION_FRAME_ST_PREP_RESP ||
+	    params->action_frame == IEEE80211_PARSE_ACTION_FRAME_ST_EXEC_RESP) {
+		int first_link_id = ieee80211_mle_get_sta_prof(elems_parse, -1);
+
+		prof = elems->prof;
+		if (first_link_id >= 0 && prof &&
+		    elems->sta_prof_len >=
+		    sizeof(*prof) + prof->sta_info_len - 1 + fixed_len) {
+			/*
+			 * point the base parsing (to be inherited from)
+			 * to the first per-STA profile elements
+			 */
+			new_base.start = prof->variable +
+					 prof->sta_info_len - 1 + fixed_len;
+			end = (const u8 *)prof + elems->sta_prof_len;
+			new_base.len = end - new_base.start;
+			/* no link ID to look for and in MLE */
+			new_base.link_id = -1;
+
+			/* if it's the requested link, that's it */
+			if (first_link_id == params->link_id) {
+				*base = new_base;
+				elems_parse->inside_multilink = true;
+				return NULL;
+			}
+		}
+	}
+
+	if (ieee80211_mle_get_sta_prof(elems_parse, params->link_id) < 0) {
+		elems->prof = NULL;
+		elems->sta_prof_len = 0;
+		return NULL;
+	}
 	prof = elems->prof;
 
-	if (!prof)
-		return NULL;
-
-	/* check if we have the 4 bytes for the fixed part in assoc response */
-	if (elems->sta_prof_len < sizeof(*prof) + prof->sta_info_len - 1 + 4) {
+	/* check if we have the bytes for the fixed part */
+	if (elems->sta_prof_len < sizeof(*prof) + prof->sta_info_len -
+				  1 + fixed_len) {
 		elems->prof = NULL;
 		elems->sta_prof_len = 0;
 		return NULL;
 	}
 
 	/*
-	 * Skip the capability information and the status code that are expected
-	 * as part of the station profile in association response frames. Note
-	 * the -1 is because the 'sta_info_len' is accounted to as part of the
-	 * per-STA profile, but not part of the 'u8 variable[]' portion.
+	 * Skip the fixed fields that are expected as part of the station
+	 * profile. Note the -1 is because the 'sta_info_len' is accounted
+	 * to as part of the per-STA profile, but not part of the
+	 * 'u8 variable[]' portion.
 	 */
-	sub->start = prof->variable + prof->sta_info_len - 1 + 4;
+	sub->start = prof->variable + prof->sta_info_len - 1 + fixed_len;
 	end = (const u8 *)prof + elems->sta_prof_len;
 	sub->len = end - sub->start;
 
@@ -1048,6 +1102,12 @@ ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
 	sub->from_ap = params->from_ap;
 	sub->link_id = -1;
 
+	/* we changed the base for "first link" inheritance */
+	if (new_base.start != base->start) {
+		*base = new_base;
+		elems_parse->inside_multilink = true;
+	}
+
 	ret = cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
 				     sub->start, sub->len);
 	if (ret)
@@ -1085,8 +1145,9 @@ ieee80211_mle_defrag(struct ieee80211_elems_parse *elems_parse,
 }
 
 struct ieee802_11_elems *
-ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
+ieee802_11_parse_elems_full(const struct ieee80211_elems_parse_params *params)
 {
+	struct ieee80211_elems_parse_params base = *params;
 	struct ieee80211_elems_parse_params sub = {};
 	struct ieee80211_elems_parse *elems_parse;
 	const struct element *non_inherit = NULL;
@@ -1166,14 +1227,14 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 		 * the applicable profile, if requested by params->link_id >= 0.
 		 */
 		non_inherit = ieee80211_prep_mle_link_parse(elems_parse, params,
-							    &sub);
+							    &sub, &base);
 		inside_multilink = true;
 	}
 
 	elems_parse->skip_vendor =
 		cfg80211_find_elem(WLAN_EID_VENDOR_SPECIFIC,
 				   sub.start, sub.len);
-	elems->crc = _ieee802_11_parse_elems_full(params, elems_parse,
+	elems->crc = _ieee802_11_parse_elems_full(&base, elems_parse,
 						  non_inherit);
 
 	/* Override with nontransmitted/per-STA profile if found */
-- 
2.56.0

