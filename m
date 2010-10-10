Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0JJQwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 12:52:10 -0400
Subject: [PATCH] mac80211: don't kmalloc 16 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 18:52:10 +0200
Message-ID: <1286729530.3547.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since this small buffer isn't used for DMA,
we can simply allocate it on the stack, it
just needs to be 16 bytes of which only 8
will be used for WEP40 keys.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wep.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/wep.c	2010-10-08 14:50:35.000000000 +0200
+++ wireless-testing/net/mac80211/wep.c	2010-10-08 14:51:41.000000000 +0200
@@ -222,7 +222,7 @@ static int ieee80211_wep_decrypt(struct
 				 struct ieee80211_key *key)
 {
 	u32 klen;
-	u8 *rc4key;
+	u8 rc4key[3 + WLAN_KEY_LEN_WEP104];
 	u8 keyidx;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	unsigned int hdrlen;
@@ -245,10 +245,6 @@ static int ieee80211_wep_decrypt(struct
 
 	klen = 3 + key->conf.keylen;
 
-	rc4key = kmalloc(klen, GFP_ATOMIC);
-	if (!rc4key)
-		return -1;
-
 	/* Prepend 24-bit IV to RC4 key */
 	memcpy(rc4key, skb->data + hdrlen, 3);
 
@@ -260,8 +256,6 @@ static int ieee80211_wep_decrypt(struct
 				       len))
 		ret = -1;
 
-	kfree(rc4key);
-
 	/* Trim ICV */
 	skb_trim(skb, skb->len - WEP_ICV_LEN);
 


