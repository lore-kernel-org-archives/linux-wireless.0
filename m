Return-Path: <SRS0=lllw=RN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF66C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 20:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A89D920657
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Mar 2019 20:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XsrzGXdw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfCJUfA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Mar 2019 16:35:00 -0400
Received: from nbd.name ([46.4.11.11]:34716 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbfCJUfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Mar 2019 16:35:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5o2MsVNkzNL84m/nFWj3MQUC497QJXm07dy7tbErHIo=; b=XsrzGXdwybf5WRhZKWFfJKANJo
        DaBxDMK2VyemxHFkj6e3L6Q832D92ipeLmWvGBYI8yezjDuK+QC3hl+jeNz2763ImfOWMiKjzKkbZ
        S2Krdvt8JkZjz/BHIbiu+UXEP1b1/9K11eJk4Qj0/9QTV4lW39lk5WnuT/F42QAwx0wg=;
Received: by maeck-2.local (Postfix, from userid 501)
        id 230E151FA5D4; Sun, 10 Mar 2019 21:34:54 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] mac80211: add hdrlen to ieee80211_tx_data
Date:   Sun, 10 Mar 2019 21:34:53 +0100
Message-Id: <20190310203454.47968-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This is preparation for adding support for inserting padding between the
802.11 header and LLC data

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/tx.c          | 10 ++++++----
 net/mac80211/util.c        |  5 ++++-
 net/mac80211/wep.c         | 11 ++++++-----
 net/mac80211/wep.h         |  1 +
 net/mac80211/wpa.c         | 13 +++++--------
 6 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e170f986d226..5b2626ca0e44 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -179,6 +179,7 @@ struct ieee80211_tx_data {
 	struct ieee80211_tx_rate rate;
 
 	unsigned int flags;
+	unsigned int hdrlen;
 };
 
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8a49a74c0a37..ee9b7860b1b1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -925,7 +925,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int frag_threshold = tx->local->hw.wiphy->frag_threshold;
-	int hdrlen;
+	int hdrlen = tx->hdrlen;
 	int fragnum;
 
 	/* no matter what happens, tx->skb moves to tx->skbs */
@@ -946,8 +946,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
 		return TX_DROP;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
 	/* internal error, why isn't DONTFRAG set? */
 	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
 		return TX_DROP;
@@ -1178,6 +1176,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
+	tx->hdrlen = ieee80211_hdrlen(hdr->frame_control);
+
 	if (likely(sta)) {
 		if (!IS_ERR(sta))
 			tx->sta = sta;
@@ -3559,6 +3559,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	tx.local = local;
 	tx.skb = skb;
 	tx.sdata = vif_to_sdata(info->control.vif);
+	tx.hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (txq->sta)
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
@@ -3585,7 +3586,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 		if (tx.key &&
 		    (tx.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV))
-			pn_offs = ieee80211_hdrlen(hdr->frame_control);
+			pn_offs = tx.hdrlen;
 
 		ieee80211_xmit_fast_finish(sta->sdata, sta, pn_offs,
 					   tx.key, skb);
@@ -4029,6 +4030,7 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 	hdr = (void *)skb->data;
 	tx.sta = sta_info_get(sdata, hdr->addr1);
 	tx.skb = skb;
+	tx.hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
 	if (ieee80211_tx_h_select_key(&tx) != TX_CONTINUE) {
 		rcu_read_unlock();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4c1655972565..e93e51636984 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1503,6 +1503,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
+	unsigned int hdrlen;
 	int err;
 
 	/* 24 + 6 = header + auth_algo + auth_transaction + status_code */
@@ -1526,8 +1527,10 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 		skb_put_data(skb, extra, extra_len);
 
 	if (auth_alg == WLAN_AUTH_SHARED_KEY && transaction == 3) {
+		hdrlen = ieee80211_hdrlen(mgmt->frame_control);
 		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-		err = ieee80211_wep_encrypt(local, skb, key, key_len, key_idx);
+		err = ieee80211_wep_encrypt(local, skb, hdrlen, key,
+					    key_len, key_idx);
 		WARN_ON(err);
 	}
 
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index bfe9ed9f4c48..f2f71d4956e5 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -89,11 +89,11 @@ static void ieee80211_wep_get_iv(struct ieee80211_local *local,
 
 static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				struct sk_buff *skb,
+				unsigned int hdrlen,
 				int keylen, int keyidx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	unsigned int hdrlen;
 	u8 *newhdr;
 
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
@@ -101,7 +101,6 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	if (WARN_ON(skb_headroom(skb) < IEEE80211_WEP_IV_LEN))
 		return NULL;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, IEEE80211_WEP_IV_LEN);
 	memmove(newhdr, newhdr + IEEE80211_WEP_IV_LEN, hdrlen);
 
@@ -160,6 +159,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
  */
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
+			  unsigned int hdrlen,
 			  const u8 *key, int keylen, int keyidx)
 {
 	u8 *iv;
@@ -169,7 +169,7 @@ int ieee80211_wep_encrypt(struct ieee80211_local *local,
 	if (WARN_ON(skb_tailroom(skb) < IEEE80211_WEP_ICV_LEN))
 		return -1;
 
-	iv = ieee80211_wep_add_iv(local, skb, keylen, keyidx);
+	iv = ieee80211_wep_add_iv(local, skb, hdrlen, keylen, keyidx);
 	if (!iv)
 		return -1;
 
@@ -307,13 +307,14 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_key_conf *hw_key = info->control.hw_key;
 
 	if (!hw_key) {
-		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
+		if (ieee80211_wep_encrypt(tx->local, skb, tx->hdrlen,
+					  tx->key->conf.key,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
 	} else if ((hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
 		   (hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
-		if (!ieee80211_wep_add_iv(tx->local, skb,
+		if (!ieee80211_wep_add_iv(tx->local, skb, tx->hdrlen,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 9615749d1f65..ad0a52b4ed0a 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -22,6 +22,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
 int ieee80211_wep_encrypt(struct ieee80211_local *local,
 			  struct sk_buff *skb,
+			  unsigned int hdrlen,
 			  const u8 *key, int keylen, int keyidx);
 int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 58d0b258b684..271857b3f38a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -44,7 +44,7 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
 	    skb->len < 24 || !ieee80211_is_data_present(hdr->frame_control))
 		return TX_CONTINUE;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	if (skb->len < hdrlen)
 		return TX_DROP;
 
@@ -195,7 +195,6 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 
 static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int hdrlen;
@@ -210,7 +209,7 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -431,7 +430,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -661,7 +660,7 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	hdrlen = tx->hdrlen;
 	len = skb->len - hdrlen;
 
 	if (info->control.hw_key)
@@ -799,7 +798,6 @@ static ieee80211_tx_result
 ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 			    struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen;
@@ -815,8 +813,7 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 		     pskb_expand_head(skb, iv_len, 0, GFP_ATOMIC)))
 		return TX_DROP;
 
-	hdrlen = ieee80211_hdrlen(hdr->frame_control);
-
+	hdrlen = tx->hdrlen;
 	pos = skb_push(skb, iv_len);
 	memmove(pos, pos + iv_len, hdrlen);
 
-- 
2.17.0

