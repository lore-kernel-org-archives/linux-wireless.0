Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:25989 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYDQTGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 15:06:47 -0400
Received: by mu-out-0910.google.com with SMTP id i10so201918mue.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2008 12:06:44 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Add IEEE80211_KEY_FLAG_PAIRWISE
Date: Thu, 17 Apr 2008 21:11:18 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804172111.18641.IvDoorn@gmail.com> (sfid-20080417_200652_924916_B7E74C03)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a new flag to the ieee80211_key_conf structure.
This flag will inform the driver the key is pairwise rather then
a shared key.

This is important for drivers who support both types of keys,
and need to be informed which type of key this is. Alternative
would be drivers checking the address argument of set_key(),
but it will be safer when mac80211 is more explicit.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 27ef9f7..740c11c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -621,11 +621,14 @@ enum ieee80211_key_alg {
  * @IEEE80211_KEY_FLAG_GENERATE_MMIC: This flag should be set by
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
+ * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
+ *	that the key is pairwise rather then a shared key.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
+	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
 };
 
 /**
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 150d66d..88b211a 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -323,6 +323,13 @@ void ieee80211_key_link(struct ieee80211_key *key,
 		 */
 		if (sta->flags & WLAN_STA_WME)
 			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
+
+		/*
+		 * This key is for a specific sta interface,
+		 * inform the driver that it should try to store
+		 * this key as pairwise key.
+		 */
+		key->conf.flags |= IEEE80211_KEY_FLAG_PAIRWISE;
 	} else {
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
 			struct sta_info *ap;
