Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759510AbXH3PKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:10:52 -0400
Subject: [PATCH] mac80211: remove set_key_idx callback
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 17:12:03 +0200
Message-Id: <1188486723.3978.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No existing drivers use this callback, hence there's no telling
how it might be used. In fact, it is unlikely to be of much use
as-is because the default key index isn't something that the
driver can do much with without knowing which interface it was
for etc. And if it needs the key index it can get it from the
set_key() callback too, and which key is default is something
mac80211 needs for key selection but the driver shouldn't need.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |   13 -------------
 net/mac80211/key.c     |    4 ----
 2 files changed, 17 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-30 14:35:34.042051253 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-30 14:35:35.042051253 +0200
@@ -648,19 +648,6 @@ struct ieee80211_ops {
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
 
-	/*
-	 * Set TX key index for default/broadcast keys. This is needed in cases
-	 * where wlan card is doing full WEP/TKIP encapsulation (wep_include_iv
-	 * is not set), in other cases, this function pointer can be set to
-	 * NULL since the IEEE 802.11 module takes care of selecting the key
-	 * index for each TX frame.
-	 *
-	 * TODO: If you use this callback in your driver tell us if you need
-	 *	 any other information from it to make it easier, like the
-	 *	 key_conf instead.
-	 */
-	int (*set_key_idx)(struct ieee80211_hw *hw, int idx);
-
 	/* Enable/disable IEEE 802.1X. This item requests wlan card to pass
 	 * unencrypted EAPOL-Key frames even when encryption is configured.
 	 * If the wlan card does not require such a configuration, this
--- wireless-dev.orig/net/mac80211/key.c	2007-08-30 14:35:32.122051253 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-30 14:35:35.042051253 +0200
@@ -250,10 +250,6 @@ void ieee80211_set_default_key(struct ie
 
 		if (sdata->default_key)
 			ieee80211_debugfs_key_add_default(sdata);
-
-		if (sdata->local->ops->set_key_idx)
-			sdata->local->ops->set_key_idx(
-				local_to_hw(sdata->local), idx);
 	}
 }
 


