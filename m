Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C23E44E7
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 19:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006361; cv=none; b=HGGrNbmho6gCBQn8rl2eYMmr5i85pzZ1uCgcFrGJzLsIsyd0suy9qYnhuj80jshWOEwlOklUHtNTQeaY9m2Ui1ts3PUGKTVMELaQE/X8dfBWpTiOL+QGTbYMhjESFKm2z3nW674ZHRyQS+gIIc9XHKBqbPgF3jDxpHikcdjj/a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006361; c=relaxed/simple;
	bh=PC2KL+vUm/shlMps+rClPwH26+6+yvztVlQHl8sgdKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT6TFZwqqYUch+5zFOXeBMvIqo4gvOBIzD1O/JF5dZxG099mTnQsodWuZ9iPc+yGBnppQ1RX3E7l+nOxCy/dtTMr61LU3bRIys8pcm9Pk+EbsufUtcfBIBXpDsZTfdAUbTS/902xjO88+pDeukPDgt0sxt/H3G+j3ECRB4Qz8PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rpF0nKdo; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rpF0nKdo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Sui8eVvAsb1YgRpcClpCwLoolfW5wAe69QJ5Sct+MOA=;
	t=1792006359; x=1793215959; b=rpF0nKdo580v3b7EKN4orpTUzdK9SAbK1UKLFqBe4zvjjcB
	0/C1O/KeBmpPsInuS6uEXejrpqwZ/oJJVnWfCtpuLe9lhNuUwRg1U3fTY6jOAQzVjH4AKWT1/YseX
	sOfJ4EFNJiENIzvNsQ8fbkQFldv01kHJQ99ZCzGiVKBI2LAfz6CLU8Fs93QZd2O8muepWfoE4oetQ
	6yMyjLWdop9qPe3gJXv70JvdtPHJUvSzouRN6Ka3nPzXByL6+4Xx4bhClE4I2qv67BFxsppkYa1WF
	2j5a9FJDs8Am/pFDUozzr99Pxlq3pXNVhKjKBgvt0Qwkd1CVnQ0qjGv9XUu5Yluw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH4iK-000000020zZ-1tIe;
	Wed, 14 Oct 2026 21:32:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 1/4] wifi: mac80211: handle missing tailroom in SW crypto
Date: Wed, 14 Oct 2026 21:30:31 +0200
Message-ID: <20261014213231.4ef857381e93.I96121b2c2ee72fa9246796e2ed0793cd320dd1e4@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014193231.886495-6-johannes@sipsolutions.net>
References: <20261014193231.886495-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The TX path reserves tailroom if crypto_tx_tailroom_needed_cnt is
non-zero, and key control paths make sure this is always set if
needed. However, this adds quite a bit of complexity and, in most
cases, latency to the key control paths.

In order to remove that latency (which is due to waiting for any
concurrent TX to complete while changing the counter), prepare
the software crypto path to just expand the tailroom if needed.

In most cases, this actually can't hit: new keys will mostly be
offloaded to hardware and then it's not needed, sometimes they
can't actually be used by the TX path at all, etc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 11 +++++++++++
 net/mac80211/wep.c         |  4 ++--
 net/mac80211/wpa.c         | 38 +++++++++++++++++++++++---------------
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 56ebe73f1bb8..392d037d9302 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -54,6 +54,17 @@ struct ieee80211_mesh_fast_tx;
 #define IEEE80211_ENCRYPT_HEADROOM 8
 #define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
+/* tailroom accounting can race with TX, expand if needed */
+static inline int ieee80211_crypto_tx_tailroom(struct sk_buff *skb, int tail)
+{
+	int tail_need = tail - skb_tailroom(skb);
+
+	if (!tail || likely(tail_need <= 0 && !skb_cloned(skb)))
+		return 0;
+
+	return pskb_expand_head(skb, 0, max(tail_need, 0), GFP_ATOMIC);
+}
+
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
 
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 93b8668079a7..cb966ce2b5bc 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -3,7 +3,7 @@
  * Software WEP encryption implementation
  * Copyright 2002, Jouni Malinen <jkmaline@cc.hut.fi>
  * Copyright 2003, Instant802 Networks, Inc.
- * Copyright (C) 2023 Intel Corporation
+ * Copyright (C) 2023, 2026 Intel Corporation
  */
 
 #include <linux/netdevice.h>
@@ -137,7 +137,7 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	size_t len;
 	u8 rc4key[3 + WLAN_KEY_LEN_WEP104];
 
-	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN))
+	if (ieee80211_crypto_tx_tailroom(skb, IEEE80211_WEP_ICV_LEN))
 		return -1;
 
 	iv = ieee80211_wep_add_iv(local, skb, keylen, keyidx);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index be3a2e95303c..a906bdc2169a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -3,7 +3,7 @@
  * Copyright 2002-2004, Instant802 Networks, Inc.
  * Copyright 2008, Jouni Malinen <j@w1.fi>
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2023, 2026 Intel Corporation
  */
 
 #include <linux/netdevice.h>
@@ -45,9 +45,6 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	if (skb->len < hdrlen)
 		return TX_DROP;
 
-	data = skb->data + hdrlen;
-	data_len = skb->len - hdrlen;
-
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_TKIP_MIC_FAILURE)) {
 		/* Need to use software crypto for the test */
 		info->control.hw_key = NULL;
@@ -66,13 +63,18 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	if (!info->control.hw_key)
 		tail += IEEE80211_TKIP_ICV_LEN;
 
-	if (WARN(skb_tailroom(skb) < tail ||
-		 skb_headroom(skb) < IEEE80211_TKIP_IV_LEN,
-		 "mmic: not enough head/tail (%d/%d,%d/%d)\n",
-		 skb_headroom(skb), IEEE80211_TKIP_IV_LEN,
-		 skb_tailroom(skb), tail))
+	if (ieee80211_crypto_tx_tailroom(skb, tail))
 		return TX_DROP;
 
+	if (WARN(skb_headroom(skb) < IEEE80211_TKIP_IV_LEN,
+		 "mmic: not enough head (%d/%d)\n",
+		 skb_headroom(skb), IEEE80211_TKIP_IV_LEN))
+		return TX_DROP;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	data = skb->data + hdrlen;
+	data_len = skb->len - hdrlen;
+
 	mic = skb_put(skb, MICHAEL_MIC_LEN);
 
 	if (tx->key->conf.flags & IEEE80211_KEY_FLAG_PUT_MIC_SPACE) {
@@ -215,8 +217,10 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	else
 		tail = IEEE80211_TKIP_ICV_LEN;
 
-	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < IEEE80211_TKIP_IV_LEN))
+	if (ieee80211_crypto_tx_tailroom(skb, tail))
+		return -1;
+
+	if (WARN_ON(skb_headroom(skb) < IEEE80211_TKIP_IV_LEN))
 		return -1;
 
 	pos = skb_push(skb, IEEE80211_TKIP_IV_LEN);
@@ -459,8 +463,10 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	else
 		tail = mic_len;
 
-	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < IEEE80211_CCMP_HDR_LEN))
+	if (ieee80211_crypto_tx_tailroom(skb, tail))
+		return -1;
+
+	if (WARN_ON(skb_headroom(skb) < IEEE80211_CCMP_HDR_LEN))
 		return -1;
 
 	pos = skb_push(skb, IEEE80211_CCMP_HDR_LEN);
@@ -674,8 +680,10 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	else
 		tail = IEEE80211_GCMP_MIC_LEN;
 
-	if (WARN_ON(skb_tailroom(skb) < tail ||
-		    skb_headroom(skb) < IEEE80211_GCMP_HDR_LEN))
+	if (ieee80211_crypto_tx_tailroom(skb, tail))
+		return -1;
+
+	if (WARN_ON(skb_headroom(skb) < IEEE80211_GCMP_HDR_LEN))
 		return -1;
 
 	pos = skb_push(skb, IEEE80211_GCMP_HDR_LEN);
-- 
2.56.0

