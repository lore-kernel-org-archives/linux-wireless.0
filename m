Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759865AbYEVIBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 04:01:41 -0400
Subject: [PATCH] mac80211: clean up skb reallocation code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 10:00:28 +0200
Message-Id: <1211443228.3698.36.camel@johannes.berg> (sfid-20080522_100148_341949_A204D90B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up the skb reallocation code to avoid problems with
skb->truesize, not resize an skb twice for a single output path
because we didn't expand it enough during the first copy and also
removes the code to further expand it during crypto operations
which will no longer be necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c  |   97 +++++++++++++++++++++++++++++++++++++----------------
 net/mac80211/wep.c |   10 +----
 net/mac80211/wpa.c |   50 ++++++++++-----------------
 3 files changed, 91 insertions(+), 66 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-05-22 09:22:21.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-22 09:37:19.000000000 +0200
@@ -1215,6 +1215,45 @@ retry:
 
 /* device xmit handlers */
 
+static int ieee80211_skb_resize(struct ieee80211_local *local,
+				struct sk_buff *skb,
+				int head_need, bool may_encrypt)
+{
+	int tail_need = 0;
+
+	/*
+	 * This could be optimised, devices that do full hardware
+	 * crypto (including TKIP MMIC) need no tailroom... But we
+	 * have no drivers for such devices currently.
+	 */
+	if (may_encrypt) {
+		tail_need = IEEE80211_ENCRYPT_TAILROOM;
+		tail_need -= skb_tailroom(skb);
+		tail_need = max_t(int, tail_need, 0);
+	}
+
+	if (head_need || tail_need) {
+		/* Sorry. Can't account for this any more */
+		skb_orphan(skb);
+	}
+
+	if (skb_header_cloned(skb))
+		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
+	else
+		I802_DEBUG_INC(local->tx_expand_skb_head);
+
+	if (pskb_expand_head(skb, head_need, tail_need, GFP_ATOMIC)) {
+		printk(KERN_DEBUG "%s: failed to reallocate TX buffer\n",
+		       wiphy_name(local->hw.wiphy));
+		return -ENOMEM;
+	}
+
+	/* update truesize too */
+	skb->truesize += head_need + tail_need;
+
+	return 0;
+}
+
 int ieee80211_master_start_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
@@ -1222,6 +1261,7 @@ int ieee80211_master_start_xmit(struct s
 	struct net_device *odev = NULL;
 	struct ieee80211_sub_if_data *osdata;
 	int headroom;
+	bool may_encrypt;
 	int ret;
 
 	if (info->control.ifindex)
@@ -1241,13 +1281,18 @@ int ieee80211_master_start_xmit(struct s
 
 	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
 
-	headroom = osdata->local->tx_headroom + IEEE80211_ENCRYPT_HEADROOM;
-	if (skb_headroom(skb) < headroom) {
-		if (pskb_expand_head(skb, headroom, 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			dev_put(odev);
-			return 0;
-		}
+	may_encrypt = !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT);
+
+	headroom = osdata->local->tx_headroom;
+	if (may_encrypt)
+		headroom += IEEE80211_ENCRYPT_HEADROOM;
+	headroom -= skb_headroom(skb);
+	headroom = max_t(int, 0, headroom);
+
+	if (ieee80211_skb_resize(osdata->local, skb, headroom, may_encrypt)) {
+		dev_kfree_skb(skb);
+		dev_put(odev);
+		return 0;
 	}
 
 	info->control.vif = &osdata->vif;
@@ -1509,32 +1554,26 @@ int ieee80211_subif_start_xmit(struct sk
 	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
 	 * alloc_skb() (net/core/skbuff.c)
 	 */
-	head_need = hdrlen + encaps_len + meshhdrlen + local->tx_headroom;
-	head_need -= skb_headroom(skb);
+	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
 
-	/* We are going to modify skb data, so make a copy of it if happens to
-	 * be cloned. This could happen, e.g., with Linux bridge code passing
-	 * us broadcast frames. */
+	/*
+	 * So we need to modify the skb header and hence need a copy of
+	 * that. The head_need variable above doesn't, so far, include
+	 * the needed header space that we don't need right away. If we
+	 * can, then we don't reallocate right now but only after the
+	 * frame arrives at the master device (if it does...)
+	 *
+	 * If we cannot, however, then we will reallocate to include all
+	 * the ever needed space. Also, if we need to reallocate it anyway,
+	 * make it big enough for everything we may ever need.
+	 */
 
 	if (head_need > 0 || skb_header_cloned(skb)) {
-#if 0
-		printk(KERN_DEBUG "%s: need to reallocate buffer for %d bytes "
-		       "of headroom\n", dev->name, head_need);
-#endif
-
-		if (skb_header_cloned(skb))
-			I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
-		else
-			I802_DEBUG_INC(local->tx_expand_skb_head);
-		/* Since we have to reallocate the buffer, make sure that there
-		 * is enough room for possible WEP IV/ICV and TKIP (8 bytes
-		 * before payload and 12 after). */
-		if (pskb_expand_head(skb, (head_need > 0 ? head_need + 8 : 8),
-				     12, GFP_ATOMIC)) {
-			printk(KERN_DEBUG "%s: failed to reallocate TX buffer"
-			       "\n", dev->name);
+		head_need += IEEE80211_ENCRYPT_HEADROOM;
+		head_need += local->tx_headroom;
+		head_need = max_t(int, 0, head_need);
+		if (ieee80211_skb_resize(local, skb, head_need, true))
 			goto fail;
-		}
 	}
 
 	if (encaps_data) {
--- everything.orig/net/mac80211/wep.c	2008-05-22 09:22:21.000000000 +0200
+++ everything/net/mac80211/wep.c	2008-05-22 09:32:12.000000000 +0200
@@ -93,13 +93,9 @@ static u8 *ieee80211_wep_add_iv(struct i
 	fc |= IEEE80211_FCTL_PROTECTED;
 	hdr->frame_control = cpu_to_le16(fc);
 
-	if ((skb_headroom(skb) < WEP_IV_LEN ||
-	     skb_tailroom(skb) < WEP_ICV_LEN)) {
-		I802_DEBUG_INC(local->tx_expand_skb_head);
-		if (unlikely(pskb_expand_head(skb, WEP_IV_LEN, WEP_ICV_LEN,
-					      GFP_ATOMIC)))
-			return NULL;
-	}
+	if (WARN_ON(skb_tailroom(skb) < WEP_ICV_LEN ||
+		    skb_headroom(skb) < WEP_IV_LEN))
+		return NULL;
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 	newhdr = skb_push(skb, WEP_IV_LEN);
--- everything.orig/net/mac80211/wpa.c	2008-05-22 09:22:21.000000000 +0200
+++ everything/net/mac80211/wpa.c	2008-05-22 09:32:12.000000000 +0200
@@ -79,6 +79,7 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	struct sk_buff *skb = tx->skb;
 	int authenticator;
 	int wpa_test = 0;
+	int tail;
 
 	fc = tx->fc;
 
@@ -98,16 +99,13 @@ ieee80211_tx_h_michael_mic_add(struct ie
 		return TX_CONTINUE;
 	}
 
-	if (skb_tailroom(skb) < MICHAEL_MIC_LEN) {
-		I802_DEBUG_INC(tx->local->tx_expand_skb_head);
-		if (unlikely(pskb_expand_head(skb, TKIP_IV_LEN,
-					      MICHAEL_MIC_LEN + TKIP_ICV_LEN,
-					      GFP_ATOMIC))) {
-			printk(KERN_DEBUG "%s: failed to allocate more memory "
-			       "for Michael MIC\n", tx->dev->name);
-			return TX_DROP;
-		}
-	}
+	tail = MICHAEL_MIC_LEN;
+	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		tail += TKIP_ICV_LEN;
+
+	if (WARN_ON(skb_tailroom(skb) < tail ||
+		    skb_headroom(skb) < TKIP_IV_LEN))
+		return TX_DROP;
 
 #if 0
 	authenticator = fc & IEEE80211_FCTL_FROMDS; /* FIX */
@@ -188,7 +186,7 @@ static int tkip_encrypt_skb(struct ieee8
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int hdrlen, len, tailneed;
+	int hdrlen, len, tail;
 	u16 fc;
 	u8 *pos;
 
@@ -207,17 +205,13 @@ static int tkip_encrypt_skb(struct ieee8
 	len = skb->len - hdrlen;
 
 	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
-		tailneed = 0;
+		tail = 0;
 	else
-		tailneed = TKIP_ICV_LEN;
+		tail = TKIP_ICV_LEN;
 
-	if ((skb_headroom(skb) < TKIP_IV_LEN ||
-	     skb_tailroom(skb) < tailneed)) {
-		I802_DEBUG_INC(tx->local->tx_expand_skb_head);
-		if (unlikely(pskb_expand_head(skb, TKIP_IV_LEN, tailneed,
-					      GFP_ATOMIC)))
-			return -1;
-	}
+	if (WARN_ON(skb_tailroom(skb) < tail ||
+		    skb_headroom(skb) < TKIP_IV_LEN))
+		return TX_DROP;
 
 	pos = skb_push(skb, TKIP_IV_LEN);
 	memmove(pos, pos + TKIP_IV_LEN, hdrlen);
@@ -432,7 +426,7 @@ static int ccmp_encrypt_skb(struct ieee8
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int hdrlen, len, tailneed;
+	int hdrlen, len, tail;
 	u16 fc;
 	u8 *pos, *pn, *b_0, *aad, *scratch;
 	int i;
@@ -457,17 +451,13 @@ static int ccmp_encrypt_skb(struct ieee8
 	len = skb->len - hdrlen;
 
 	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
-		tailneed = 0;
+		tail = 0;
 	else
-		tailneed = CCMP_MIC_LEN;
+		tail = CCMP_MIC_LEN;
 
-	if ((skb_headroom(skb) < CCMP_HDR_LEN ||
-	     skb_tailroom(skb) < tailneed)) {
-		I802_DEBUG_INC(tx->local->tx_expand_skb_head);
-		if (unlikely(pskb_expand_head(skb, CCMP_HDR_LEN, tailneed,
-					      GFP_ATOMIC)))
-			return -1;
-	}
+	if (WARN_ON(skb_tailroom(skb) < tail ||
+		    skb_headroom(skb) < CCMP_HDR_LEN))
+		return TX_DROP;
 
 	pos = skb_push(skb, CCMP_HDR_LEN);
 	memmove(pos, pos + CCMP_HDR_LEN, hdrlen);


