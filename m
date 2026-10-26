Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015512;
	b=St81EPFpNvWkG8nnWSuz2yZ55A3mC/EbbBVUa0ZvHQg4x/p9PL3ypX/vya7xE7vsjS1y
	 YAbkzQ4C9n+iFeHbR3JMWs3DYPBf48On2a0ygn7aMVv/pLFLOx4dM5re3nVzsw1N8LjZb
	 Vgdhf2lgVbLh28oSTIE/IaPOtTK+pciBQWSf4Te5kxUMUrVQc35Zj3/qAeRFkVyjMKl7b
	 pAf91Rr6Q8w6AVNQfy8cIpixzY0lst/9P7vYQS/C1+QD5JPbaPw+r60zvAvdipJg/z2Hg
	 LzaDMt6w75aPuyiE+njPw56YvDr8X39Yl+7QNSDFYIsBthhayYpKIWDVXE6mHdjemYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015512;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TRFv4Af/t0LvMCrKxCgGx0iNJhB/gusw/tmuQBNUcKc=;
	b=yz/GzIdncQozO09rADG70V6Yh8cwltXj4yNkgl4vhatIfid10EkA+YZeO25ls93YGy2T
	 CnWPJ8FEkSS48PPzLGiXngJTWV9lKVfgU15xP1mLVQqLfpQWCUoEveUCzwPy414eUufKL
	 BeVbm1o7D5iJV1B3iVcW6f0n2ETW+qSew8UgTDgSG6KI/jiI0QgckDOhOwLPbNR01NBDg
	 nn+CvGt0VJprUmo+IIK/87/zIxrR8MetCuiDIx4ZyCVo9oFZ+MNMk39JRMkFK0i2UrmaX
	 j1a1dnyULUo91w23IxQ3Z+tkuPBdUHqIBUizCuDwBDdZwEzji1dURLIXBjmwJF0Y8xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qRyEfQVN;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F7606A33A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=qRyEfQVN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=TRFv4Af/t0LvMCrKxCgGx0iNJhB/gusw/tmuQBNUcKc=;
	t=1793015511; x=1794225111; b=qRyEfQVNbHHosRK72EoGMPyUEj8DuOFn6AMNZiwWTI1cwOQ
	CbN5mWN+LTg6lbxvX8WZPSaX+R56xjJbigsAE4u2UvvOeexBhkaA79RJop6Y/4AKFWcrvf/bNFqvZ
	M5FX6lK0+fEAc0tHxHpLe+fLHNJWJTSfkJJa/55YiMCHxVT1ScPvQJuo2BW8Y5MSEn2v45rmGxUFx
	UwpMpoBhybmp3eMo5LkLqJZmYdrqsXsg+wJZGojRi5THwoiyrEdwH5PyUigYnRBBcqF5fWMasmB27
	xapjE9HrXE3jj75jlHRE6N3wYkk9k2Joo6Gc6Rx1zI5qXF4xWECaP2pn1/kwUjgw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJEz-0000000BDPs-1v1j;
	Mon, 26 Oct 2026 12:51:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 1/6] wifi: mac80211: handle missing tailroom in SW crypto
Date: Mon, 26 Oct 2026 12:48:35 +0100
Message-ID: <20261026125145.3c660a7b6c10.I96121b2c2ee72fa9246796e2ed0793cd320dd1e4@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026115144.189706-8-johannes@sipsolutions.net>
References: <20261026115144.189706-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
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

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 11 +++++++++++
 net/mac80211/wep.c         |  4 ++--
 net/mac80211/wpa.c         | 38 +++++++++++++++++++++++---------------
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d186d1274303..0cd276fb8133 100644
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

