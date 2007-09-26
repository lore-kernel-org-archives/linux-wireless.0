Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbXIZNYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:12 -0400
Message-Id: <20070926132132.758703000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 04/12] mac80211: remove ieee80211_wep_get_keyidx
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is not used any more.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/wep.c |   19 -------------------
 net/mac80211/wep.h |    1 -
 2 files changed, 20 deletions(-)

--- wireless-dev.orig/net/mac80211/wep.c	2007-09-25 23:29:35.131571125 +0200
+++ wireless-dev/net/mac80211/wep.c	2007-09-25 23:29:35.911578504 +0200
@@ -286,25 +286,6 @@ int ieee80211_wep_decrypt(struct ieee802
 }
 
 
-int ieee80211_wep_get_keyidx(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 fc;
-	int hdrlen;
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
-		return -1;
-
-	hdrlen = ieee80211_get_hdrlen(fc);
-
-	if (skb->len < 8 + hdrlen)
-		return -1;
-
-	return skb->data[hdrlen + 3] >> 6;
-}
-
-
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
--- wireless-dev.orig/net/mac80211/wep.h	2007-09-25 23:29:35.131571125 +0200
+++ wireless-dev/net/mac80211/wep.h	2007-09-25 23:29:35.911578504 +0200
@@ -26,7 +26,6 @@ int ieee80211_wep_encrypt(struct ieee802
 			  struct ieee80211_key *key);
 int ieee80211_wep_decrypt(struct ieee80211_local *local, struct sk_buff *skb,
 			  struct ieee80211_key *key);
-int ieee80211_wep_get_keyidx(struct sk_buff *skb);
 u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_txrx_result

-- 

