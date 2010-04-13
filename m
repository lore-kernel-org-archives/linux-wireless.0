Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39774 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0DMHMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 03:12:08 -0400
Received: by vws18 with SMTP id 18so1536429vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 00:12:07 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 15:12:07 +0800
Message-ID: <q2t8247263b1004130012u6feafb69v834b245908573f92@mail.gmail.com>
Subject: [PATCH] ath9k: Group Key fix for VAPs
From: Daniel Yingqiang Ma <yma.cool@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I set up multiple VAPs with ath9k, I encountered an issue that
the traffic may be lost after a while.

The detailed phenomenon is
1. After a while the clients connected to one of these VAPs will get
into a state that no broadcast/multicast packets can be transfered
successfully while the unicast packets can be transfered normally.
2. Minutes latter the unitcast packets transfer will fail as well,
because the ARP entry is expired and it can't be freshed due to the
broadcast trouble.

It's caused by the group key overwritten and someone discussed this
issue in ath9k-devel maillist before, but haven't work out a fix yet.

I referred the method in madwifi, and made a patch for ath9k.
The method is to set the high bit of the sender(AP)'s address, and
associated that mac and the group key. It requires the hardware
supports multicast frame key search. It seems true for AR9160.

Not sure whether it's the correct way to fix this issue. But it seems
to work in my test. The patch is attached, feel free to revise it.

Signed-off-by: Daniel Yingqiang ma <yma.cool@gmail.com>
---

diff --git a/drivers/net/wireless/ath/ath9k/main.c
b/drivers/net/wireless/ath/ath9k/main.c
index 4faafbd..ed231aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -843,6 +843,7 @@ static int ath_key_config(struct ath_common *common,
 	struct ath_hw *ah = common->ah;
 	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
+	u8 gmac[ETH_ALEN];
 	int ret = 0;
 	int idx;

@@ -866,9 +867,30 @@ static int ath_key_config(struct ath_common *common,
 	memcpy(hk.kv_val, key->key, key->keylen);

 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-		/* For now, use the default keys for broadcast keys. This may
-		 * need to change with virtual interfaces. */
-		idx = key->keyidx;
+
+		if (key->ap_addr) {
+			/*
+			 * Group keys on hardware that supports multicast frame
+			 * key search use a mac that is the sender's address with
+			 * the high bit set instead of the app-specified address.
+			 */
+			memcpy(gmac, key->ap_addr, ETH_ALEN);
+			gmac[0] |= 0x80;
+			mac = gmac;
+
+			if (key->alg == ALG_TKIP)
+				idx = ath_reserve_key_cache_slot_tkip(common);
+			else
+				idx = ath_reserve_key_cache_slot(common);
+			if (idx < 0)
+				mac = NULL; /* no free key cache entries */
+		}
+
+		if (!mac) {
+			/* For now, use the default keys for broadcast keys. This may
+			 * need to change with virtual interfaces. */
+			idx = key->keyidx;
+		}
 	} else if (key->keyidx) {
 		if (WARN_ON(!sta))
 			return -EOPNOTSUPP;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0bf3697..70e0125 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -771,6 +771,7 @@ struct ieee80211_key_conf {
 	u8 iv_len;
 	u8 hw_key_idx;
 	u8 flags;
+	u8 *ap_addr;
 	s8 keyidx;
 	u8 keylen;
 	u8 key[0];
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 659a42d..fdef733 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -139,6 +139,7 @@ static void ieee80211_key_enable_hw_accel(struct
ieee80211_key *key)
 				     struct ieee80211_sub_if_data,
 				     u.ap);

+	key->conf.ap_addr = sdata->dev->dev_addr;
 	ret = drv_set_key(key->local, SET_KEY, &sdata->vif, sta, &key->conf);

 	if (!ret) {
