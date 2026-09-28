Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E9E288C81
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599446; cv=none; b=irGiK2iLDGztCMG/WPwvSE0secXiI+mkTAx2kZK7r3HlbEbWX9DjgwhIbBl7HJstx9p5iZHbjEkDXzhOR6kyJ3ZbCkDOshZBw17NJI44wwV6Jmyan1Qor7PPYX8J/4xaxjGwsPOJujv1/wZF6PT0W4QpebSk53WUhcNYtURqF0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599446; c=relaxed/simple;
	bh=6TmpMUv6Ec6AaRhu+KwR3MRAgXSL+DsREJtKNR+AHpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3WsupUTIO6zU7r5HU200vqyiGDl0Q1pYesakzhTZ4S5/sV7szruYJvGJe+wVOwTqTtbzIpXrDcCAaY9XXW5cOUrWTspQl1yo4BdDQaLYMoVrqJ1BS0EoTsRgOup11WCdvtvP1r+dxVD9fMRQ5mE62HG3VwfLq5HXrC3yPi2GGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fa67IVWO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fa67IVWO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EIx5y66/UiaI8UFnI02NqL5b6Ad7Y1xquINE0pSCIsI=;
	t=1790599445; x=1791809045; b=fa67IVWOOscyYFdNaJlE2c9G84JToU01a1nqpE6+3J3MTwN
	wCwAi/U4bT0LuNnikXm3h3xc5TOkocGqWBGd+/18jRDt0NyCQPXeYnrvYK0EeKHOsOMwdjh1UPIFW
	17fti+w+oKnh4+d9PggG2Ul6qC3/6uv68Uf8/xVaweKYHs0pw+Ulj75AEg3F896Loaj++34RHZsil
	EL0vOiQOoc27DgsB4eoDC1BCED7oof6xxnmZSmKLWpj5Nd84snTyHx8u4GdBbxTyXuoErS2Hp/SXD
	eHLuXya4E/3wcLsjNz6BnkdsijEjNSjY1f8WrgC5OXiX/b8Lmf7onq4zttuAlFZg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBAiA-0000000DYZt-11au;
	Mon, 28 Sep 2026 14:44:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: cfg80211: type-check (extended) element search functions
Date: Mon, 28 Sep 2026 14:43:59 +0200
Message-ID: <20260928144358.36f6d12bb231.I0f8702dc218b56470017d2fcf8fff2980946e818@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928144357.2e38718bb504.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
References: <20260928144357.2e38718bb504.I8b07b323ba83173b570bc07ed61f4130b8aff04f@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

When constants are given as the first argument for the element
or extended element ID, make sure they're from the right enum
by tagging the argument accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 17 +++++++++++------
 net/wireless/scan.c    |  3 ++-
 2 files changed, 13 insertions(+), 7 deletions(-)

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
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index caa9c6495f20..8fedfaeba4e0 100644
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
-- 
2.55.0

