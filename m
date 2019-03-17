Return-Path: <SRS0=pME5=RU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC490C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 18:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9374220854
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Mar 2019 18:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="VScwj7W8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCQSTE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Mar 2019 14:19:04 -0400
Received: from nbd.name ([46.4.11.11]:52988 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfCQSTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Mar 2019 14:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+2CUSeFgBBvT37UKP0dqPM/OqNZfmicQl8iDyGEAb5Q=; b=VScwj7W8Ngj0fr8TNQVpMixwnz
        sFR5XkffDNELGpOho/A/hNRiZ/jh2KFFdtThNfh6NF2Hw6+oidaqTAbmx6V3cAPbXgrx+Dl1OfexO
        4cbZFPGt82D6nnqlJ1KlsMrIjWmNBiN/8apgoPR42aHYrGC+7s9vZrjT/LUtFhYeGetw=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5aNC-0000SK-Tq; Sun, 17 Mar 2019 19:19:03 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id AB3205318943; Sun, 17 Mar 2019 19:18:59 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH] mac80211: optimize skb resizing
Date:   Sun, 17 Mar 2019 19:18:59 +0100
Message-Id: <20190317181859.71841-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When forwarding unicast packets from ethernet to batman-adv over 802.11s
(with forwarding disabled), the typical required headroom to transmit
encrypted packets on mt76 is 32 (802.11) + 6 (802.11s) + 8 (CCMP) +
2 (padding) + 6 (LLC) + 18 (batman-adv) - 14 (old ethernet header) = 58 bytes.

On systems where NET_SKB_PAD is 64 this leads to a call to pskb_expand_head
for every packet, since mac80211 also tries to allocate 16 bytes status
headroom for radiotap headers.

This patch fixes these unnecessary reallocations by only requiring the extra
status headroom in ieee80211_tx_monitor()
If however a reallocation happens before that call, the status headroom gets
added there as well, in order to avoid double reallocation.

The patch also cleans up the code by moving the headroom calculation to
ieee80211_skb_resize.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |  2 +
 net/mac80211/status.c      |  5 ++
 net/mac80211/tx.c          | 96 ++++++++++++++++----------------------
 3 files changed, 48 insertions(+), 55 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5b2626ca0e44..a36bfa1b43a9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1779,6 +1779,8 @@ void ieee80211_clear_fast_xmit(struct sta_info *sta);
 int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 			      const u8 *buf, size_t len,
 			      const u8 *dest, __be16 proto, bool unencrypted);
+int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb, int hdrlen, int hdr_add);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 0af1c7a99d6c..1452011d7e91 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -670,6 +670,11 @@ void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
 		}
 	}
 
+	if (ieee80211_skb_resize(NULL, skb, 0, 0)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	/* send frame to monitor interfaces now */
 	rtap_len = ieee80211_tx_radiotap_len(info);
 	if (WARN_ON_ONCE(skb_headroom(skb) < rtap_len)) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 72279fb318e0..e22de40a7790 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1939,37 +1939,53 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 /* device xmit handlers */
-
-static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb,
-				int head_need, bool may_encrypt)
+int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb, int hdr_len, int hdr_extra)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
-	bool enc_tailroom;
-	int tail_need = 0;
+	int head_need, head_max;
+	int tail_need, tail_max;
+	bool enc_tailroom = false;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
-	enc_tailroom = may_encrypt &&
-		       (sdata->crypto_tx_tailroom_needed_cnt ||
-			ieee80211_is_mgmt(hdr->frame_control));
-
-	if (enc_tailroom) {
-		tail_need = IEEE80211_ENCRYPT_TAILROOM;
-		tail_need -= skb_tailroom(skb);
-		tail_need = max_t(int, tail_need, 0);
+	if (sdata && !hdr_len &&
+	    !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
+		hdr = (struct ieee80211_hdr *) skb->data;
+		enc_tailroom = (sdata->crypto_tx_tailroom_needed_cnt ||
+				ieee80211_is_mgmt(hdr->frame_control));
+		hdr_len += sdata->encrypt_headroom;
+	}
+
+	head_need = head_max = hdr_len;
+	tail_need = tail_max = 0;
+	if (!sdata) {
+		head_need = head_max = local->tx_headroom;
+	} else {
+		head_max += hdr_extra;
+		head_max += max_t(int, local->tx_headroom,
+				  local->hw.extra_tx_headroom);
+		head_need += local->hw.extra_tx_headroom;
+
+		tail_max = IEEE80211_ENCRYPT_TAILROOM;
+		if (enc_tailroom)
+			tail_need = tail_max;
 	}
 
 	if (skb_cloned(skb) &&
 	    (!ieee80211_hw_check(&local->hw, SUPPORTS_CLONED_SKBS) ||
 	     !skb_clone_writable(skb, ETH_HLEN) || enc_tailroom))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
-	else if (head_need || tail_need)
+	else if (head_need > skb_headroom(skb) ||
+		 tail_need > skb_tailroom(skb))
 		I802_DEBUG_INC(local->tx_expand_skb_head);
 	else
 		return 0;
 
-	if (pskb_expand_head(skb, head_need, tail_need, GFP_ATOMIC)) {
+	head_max = max_t(int, 0, head_max - skb_headroom(skb));
+	tail_max = max_t(int, 0, tail_max - skb_tailroom(skb));
+
+	if (pskb_expand_head(skb, head_max, tail_max, GFP_ATOMIC)) {
 		wiphy_debug(local->hw.wiphy,
 			    "failed to reallocate TX buffer\n");
 		return -ENOMEM;
@@ -1985,18 +2001,8 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
-	int headroom;
-	bool may_encrypt;
-
-	may_encrypt = !(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT);
 
-	headroom = local->tx_headroom;
-	if (may_encrypt)
-		headroom += sdata->encrypt_headroom;
-	headroom -= skb_headroom(skb);
-	headroom = max_t(int, 0, headroom);
-
-	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
+	if (ieee80211_skb_resize(sdata, skb, 0, 0)) {
 		ieee80211_free_txskb(&local->hw, skb);
 		return;
 	}
@@ -2765,30 +2771,14 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	skb_pull(skb, skip_header_bytes);
 	padsize = ieee80211_hdr_padsize(&local->hw, hdrlen);
-	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
+	head_need = hdrlen + encaps_len + meshhdrlen;
 	head_need += padsize;
 
-	/*
-	 * So we need to modify the skb header and hence need a copy of
-	 * that. The head_need variable above doesn't, so far, include
-	 * the needed header space that we don't need right away. If we
-	 * can, then we don't reallocate right now but only after the
-	 * frame arrives at the master device (if it does...)
-	 *
-	 * If we cannot, however, then we will reallocate to include all
-	 * the ever needed space. Also, if we need to reallocate it anyway,
-	 * make it big enough for everything we may ever need.
-	 */
-
-	if (head_need > 0 || skb_cloned(skb)) {
-		head_need += sdata->encrypt_headroom;
-		head_need += local->tx_headroom;
-		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
-			ieee80211_free_txskb(&local->hw, skb);
-			skb = NULL;
-			return ERR_PTR(-ENOMEM);
-		}
+	if (ieee80211_skb_resize(sdata, skb, head_need,
+				 sdata->encrypt_headroom)) {
+		ieee80211_free_txskb(&local->hw, skb);
+		skb = NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	if (encaps_data)
@@ -3414,7 +3404,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
 	int extra_head = fast_tx->hdr_len - (ETH_HLEN - 2);
-	int hw_headroom = sdata->local->hw.extra_tx_headroom;
 	struct ethhdr eth;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_hdr *hdr = (void *)fast_tx->hdr;
@@ -3466,10 +3455,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	 * as the may-encrypt argument for the resize to not account for
 	 * more room than we already have in 'extra_head'
 	 */
-	if (unlikely(ieee80211_skb_resize(sdata, skb,
-					  max_t(int, extra_head + hw_headroom -
-						     skb_headroom(skb), 0),
-					  false))) {
+	if (unlikely(ieee80211_skb_resize(sdata, skb, extra_head, 0))) {
 		kfree_skb(skb);
 		return true;
 	}
-- 
2.17.0

