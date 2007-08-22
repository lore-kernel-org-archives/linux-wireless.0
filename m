Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023AbXHVJgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 05:36:45 -0400
Received: from [131.234.74.113]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1INmdo-0005o6-F2
	for linux-wireless@vger.kernel.org; Wed, 22 Aug 2007 10:36:44 +0100
Message-Id: <20070822093635.263993000@sipsolutions.net>
References: <20070822093602.028331000@sipsolutions.net>
Date: Wed, 22 Aug 2007 11:36:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/4] mac80211: remove set_key_idx callback
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No existing drivers use this callback, hence there's no telling
how it might be used. In fact, it is unlikely to be of much use
as-is because the default key index isn't something that the
driver can do much with without knowing which interface it was
for etc. And if it needs the key index for the transmitted frame,
it can get it by keeping a reference to the key_conf structure
and looking it up by hw_key_idx.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |   13 -------------
 net/mac80211/key.c     |    4 ----
 2 files changed, 17 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-22 10:26:14.879500061 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-22 10:26:54.429500061 +0200
@@ -733,19 +733,6 @@ struct ieee80211_ops {
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
--- wireless-dev.orig/net/mac80211/key.c	2007-08-22 10:19:21.489500061 +0200
+++ wireless-dev/net/mac80211/key.c	2007-08-22 10:26:54.429500061 +0200
@@ -264,10 +264,6 @@ void ieee80211_set_default_key(struct ie
 
 		if (sdata->default_key)
 			ieee80211_debugfs_key_add_default(sdata);
-
-		if (sdata->local->ops->set_key_idx)
-			sdata->local->ops->set_key_idx(
-				local_to_hw(sdata->local), idx);
 	}
 }
 

-- 

