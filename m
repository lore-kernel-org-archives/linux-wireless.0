Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7E4F4059
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617120; cv=none; b=iKAMbZ8tQrGV6rhV+LkP8oYSw8Vv/0NIZfdPWXEdk86i5pFLfEWIHqJ3Wa9rXVfrj6W8Sdbbw0J+fMhBQs4EVjpfYhTY+hJK0s3vPxOHjDKy4TvxJFWRChFv0+4bSrteSKlZpgW9qH5zmjlecPcrv21J/5q6ArUvo2U5P6OYPOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617120; c=relaxed/simple;
	bh=NJPDXEZ6DiNU34rgzB0aBhJqMpZq7rEHBDILZnhhEi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQsScHpQ3kZpT/ynBv+hoLOJFIleMZ1JxyvMvwLdJf682BLM9p60xkkz4+oUWguspi5C8BIhg7IA4w+gIcjviCVnElyBgwEy7+mXXuQS5L79zipA0W4Bux5tQb4T9Yp1zCbz38VT7B8rD3Ok9eFkLT72RXR+BHlNZDqNooHHgg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Vh2ImSpF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Vh2ImSpF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=4Buc/ESPBgeYs4IvGslv0f34klHqT5Cq5xMIrLCqMCQ=;
	t=1790617119; x=1791826719; b=Vh2ImSpFZEI63gisZxSN/eCmNkyoYmP/QHoS0U+r+aKV5Bk
	9oxdhxepabRi/glQjk+NNDTwYPTE+u8RMo6QTJts8YSw86njn50/Qe5cz7LupzhHA/Hd56TXy49c+
	OBncvejSF4yN1dBWWNC7xN6r9V7t8h9ur3mAfJFJUs7L5pkR2U0i9+kd/+4SJM8kxNlHgtozavhhN
	yU1ShFhnk4jrDIN1zWTfoKqEmWcd2mKMUdalOY5wREhkAfwnClB4KqS1lm9PMvkuPVWkYYOMBugQx
	7WoRYJQKsngDHAhBvjaBv3/CZ5yqeF4toKHGydBJYArMD6w9lo4A5BG3AL6+txfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBFJE-0000000Dl7I-3u24;
	Mon, 28 Sep 2026 19:38:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next v2 2/2] wifi: ieee80211: type-check (extended) element functions
Date: Mon, 28 Sep 2026 19:38:32 +0200
Message-ID: <20260928193832.706fb927f309.I0f8702dc218b56470017d2fcf8fff2980946e818@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928193832.a3deb0415eaf.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
References: <20260928193832.a3deb0415eaf.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Type-check element finding functions and element iteration macros,
so that when constants are given for the (extended) ID they must
be from the appropriate enum, otherwise an enum compare compiler
warning will trigger.

Two places are using element iteration for subelements, but don't
have the outer element as a struct element, so they need casts to
avoid the warning now, but overall this will flag issues like the
one in the previous commit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: also type-check iteration macros
---
 include/linux/ieee80211.h | 17 +++++++++++++----
 include/net/cfg80211.h    | 17 +++++++++++------
 net/mac80211/mlme.c       |  2 +-
 net/wireless/scan.c       |  5 +++--
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 73ac5336a17a..66f9ebe79c61 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2730,6 +2730,10 @@ struct element {
 	u8 data[];
 } __packed;
 
+/* trigger enum comparison warnings if applicable (constant id) */
+#define element_iteration_typecheck(type, id)				\
+	(((type)0 == (id)) || true)
+
 /* element iteration helpers */
 #define for_each_element(_elem, _data, _datalen)			\
 	for (_elem = (const struct element *)(_data);			\
@@ -2741,11 +2745,15 @@ struct element {
 
 #define for_each_element_id(element, _id, data, datalen)		\
 	for_each_element(element, data, datalen)			\
-		if (element->id == (_id))
+		if (element_iteration_typecheck(enum ieee80211_eid,	\
+						_id) &&			\
+		    element->id == (_id))
 
 #define for_each_element_extid(element, extid, _data, _datalen)		\
 	for_each_element(element, _data, _datalen)			\
-		if (element->id == WLAN_EID_EXTENSION &&		\
+		if (element_iteration_typecheck(enum ieee80211_eid_ext,	\
+						extid) &&		\
+		    element->id == WLAN_EID_EXTENSION &&		\
 		    element->datalen > 0 &&				\
 		    element->data[0] == (extid))
 
@@ -2753,10 +2761,11 @@ struct element {
 	for_each_element(sub, (element)->data, (element)->datalen)
 
 #define for_each_subelement_id(sub, id, element)			\
-	for_each_element_id(sub, id, (element)->data, (element)->datalen)
+	for_each_element_id(sub, (u8)id, (element)->data, (element)->datalen)
 
 #define for_each_subelement_extid(sub, extid, element)			\
-	for_each_element_extid(sub, extid, (element)->data, (element)->datalen)
+	for_each_element_extid(sub, (u8)extid, (element)->data,		\
+			       (element)->datalen)
 
 /**
  * for_each_element_completed - determine if element parsing consumed all data
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b603f1804cc2..2e3dfee85019 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7858,7 +7858,8 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
  * byte array to match.
  */
 const struct element *
-cfg80211_find_elem_match(u8 eid, const u8 *ies, unsigned int len,
+cfg80211_find_elem_match(enum ieee80211_eid eid,
+			 const u8 *ies, unsigned int len,
 			 const u8 *match, unsigned int match_len,
 			 unsigned int match_offset);
 
@@ -7887,7 +7888,7 @@ cfg80211_find_elem_match(u8 eid, const u8 *ies, unsigned int len,
  * byte array to match.
  */
 static inline const u8 *
-cfg80211_find_ie_match(u8 eid, const u8 *ies, unsigned int len,
+cfg80211_find_ie_match(enum ieee80211_eid eid, const u8 *ies, unsigned int len,
 		       const u8 *match, unsigned int match_len,
 		       unsigned int match_offset)
 {
@@ -7920,7 +7921,7 @@ cfg80211_find_ie_match(u8 eid, const u8 *ies, unsigned int len,
  * having to fit into the given data.
  */
 static inline const struct element *
-cfg80211_find_elem(u8 eid, const u8 *ies, int len)
+cfg80211_find_elem(enum ieee80211_eid eid, const u8 *ies, int len)
 {
 	return cfg80211_find_elem_match(eid, ies, len, NULL, 0, 0);
 }
@@ -7940,7 +7941,8 @@ cfg80211_find_elem(u8 eid, const u8 *ies, int len)
  * Note: There are no checks on the element length other than
  * having to fit into the given data.
  */
-static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
+static inline const u8 *cfg80211_find_ie(enum ieee80211_eid eid,
+					 const u8 *ies, int len)
 {
 	return cfg80211_find_ie_match(eid, ies, len, NULL, 0, 0);
 }
@@ -7961,10 +7963,13 @@ static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
  * having to fit into the given data.
  */
 static inline const struct element *
-cfg80211_find_ext_elem(u8 ext_eid, const u8 *ies, int len)
+cfg80211_find_ext_elem(enum ieee80211_eid_ext ext_eid,
+		       const u8 *ies, int len)
 {
+	u8 _ext_eid = ext_eid;
+
 	return cfg80211_find_elem_match(WLAN_EID_EXTENSION, ies, len,
-					&ext_eid, 1, 0);
+					&_ext_eid, 1, 0);
 }
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3a17d1ccd32a..3ec10c7bf8bb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7982,7 +7982,7 @@ ieee80211_mgd_check_cross_link_csa(struct ieee80211_sub_if_data *sdata,
 	subelems = (u8 *)elems->ml_basic + common_size;
 	subelems_len = elems->ml_basic_len - common_size;
 
-	for_each_element_id(sub, IEEE80211_MLE_SUBELEM_PER_STA_PROFILE,
+	for_each_element_id(sub, (u8)IEEE80211_MLE_SUBELEM_PER_STA_PROFILE,
 			    subelems, subelems_len) {
 		struct ieee80211_mle_per_sta_profile *prof = (void *)sub->data;
 		struct ieee80211_link_data *link;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index caa9c6495f20..dfbb4e0bbbab 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1436,7 +1436,8 @@ void cfg80211_bss_flush(struct wiphy *wiphy)
 EXPORT_SYMBOL(cfg80211_bss_flush);
 
 const struct element *
-cfg80211_find_elem_match(u8 eid, const u8 *ies, unsigned int len,
+cfg80211_find_elem_match(enum ieee80211_eid eid,
+			 const u8 *ies, unsigned int len,
 			 const u8 *match, unsigned int match_len,
 			 unsigned int match_offset)
 {
@@ -2785,7 +2786,7 @@ cfg80211_defrag_mle(const struct element *mle, const u8 *ie, size_t ielen,
 	ielen = mle_len - common_size;
 
 	idx = 0;
-	for_each_element_id(elem, IEEE80211_MLE_SUBELEM_PER_STA_PROFILE,
+	for_each_element_id(elem, (u8)IEEE80211_MLE_SUBELEM_PER_STA_PROFILE,
 			    ie, ielen) {
 		res->sta_prof[idx] = (void *)elem->data;
 		res->sta_prof_len[idx] = elem->datalen;
-- 
2.55.0

