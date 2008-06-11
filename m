Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:59651 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYFKRCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 13:02:00 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1970373ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 10:01:40 -0700 (PDT)
Subject: [PATCH 3/3] mac80211: tkip.c use a local struct tkip_ctx in
	ieee80211_get_tkip_key
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 10:01:36 -0700
Message-Id: <1213203696.5974.135.camel@brick> (sfid-20080611_190204_445074_7E69FE1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 1fc744c..c738f0c 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -153,25 +153,27 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 {
 	struct ieee80211_key *key = (struct ieee80211_key *)
 			container_of(keyconf, struct ieee80211_key, conf);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u8 *data = (u8 *) hdr;
-	u16 fc = le16_to_cpu(hdr->frame_control);
-	int hdr_len = ieee80211_get_hdrlen(fc);
-	u8 *tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
-	u8 *ta = hdr->addr2;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	u8 *data;
+	const u8 *tk;
+	struct tkip_ctx *ctx;
 	u16 iv16;
 	u32 iv32;
 
-	iv16 = data[hdr_len + 2] | (data[hdr_len] << 8);
-	iv32 = get_unaligned_le32(data + hdr_len + 4);
+	data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	iv16 = data[2] | (data[0] << 8);
+	iv32 = get_unaligned_le32(&data[4]);
+
+	tk = &key->conf.key[ALG_TKIP_TEMP_ENCR_KEY];
+	ctx = &key->u.tkip.tx;
 
 #ifdef CONFIG_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
 			iv16, iv32);
 
-	if (iv32 != key->u.tkip.tx.iv32) {
+	if (iv32 != ctx->iv32) {
 		printk(KERN_DEBUG "skb: iv32 = 0x%08x key: iv32 = 0x%08x\n",
-			iv32, key->u.tkip.tx.iv32);
+			iv32, ctx->iv32);
 		printk(KERN_DEBUG "Wrap around of iv16 in the middle of a "
 			"fragmented packet\n");
 	}
@@ -180,15 +182,15 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	/* Update the p1k only when the iv16 in the packet wraps around, this
 	 * might occur after the wrap around of iv16 in the key in case of
 	 * fragmented packets. */
-	if (iv16 == 0 || !key->u.tkip.tx.initialized)
-		tkip_mixing_phase1(tk, &key->u.tkip.tx, ta, iv32);
+	if (iv16 == 0 || !ctx->initialized)
+		tkip_mixing_phase1(tk, ctx, hdr->addr2, iv32);
 
 	if (type == IEEE80211_TKIP_P1_KEY) {
-		memcpy(outkey, key->u.tkip.tx.p1k, sizeof(u16) * 5);
+		memcpy(outkey, ctx->p1k, sizeof(u16) * 5);
 		return;
 	}
 
-	tkip_mixing_phase2(tk, &key->u.tkip.tx, iv16, outkey);
+	tkip_mixing_phase2(tk, ctx, iv16, outkey);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
-- 
1.5.6.rc2.261.ga8fbe

