Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651943;
	b=L+qs5cFgpLdLXRLpl1bfRk3r3Anv9N32N2MPZbc8N4lYOVeu9ftPIW6sJ9TI5KrWaZ4U
	 2SVmusEhffnZS2ipgdEtbmZ/NbYZz4PjtNv36zUfewD/nn7KR23PRtAEMeY5PxDHpN088
	 M0yXQAriqMfRT/gOCxVLoIqq7dk/UoeyKRXyn9fTo+dwYAYHUsQeBFvLsf16Pf8y30ONx
	 yO0xIOJYfMVAa/E4LsldO3kSNkCpG0I1V5UkxcEEx2Xaf7dtLJ+fEtjKW3Y33qrJoCB5I
	 7NPjQMvppihDz8+q7dO4538evT9MGmTym9AoJdmMO5Y7QxwM6v5WTkwZXHula3AluzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651943;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=i8u1UPs7vb9pstdHeXE9lyb6vLU6uwZjZNVtAstVNOI=;
	b=lGxOr+t6iWDYdSwbWWnope7hDRsX2uxit8oFM5ySZhKZGSzFxfDzwxbM+BirnaMZ67J6
	 /6nbwlywmP0Gwb1gQ2K/mmynMWRKFDDygHn9Qc5iZIFBeXihdl88sUI7fOWUqrpw4MZuj
	 fIKPLXbuwCJeX7bX/KyvuabtpM1Psai7+cAS+cfFMOyma3MNFkfW4AX0qVU/xXke/OQ6w
	 HkJygtF3SQsrBYj6Wv3rsIPOeVLfsFbrmFFzVEODfng9r/vUZYx3OzIH6+Vvv/aHvioPM
	 5gYJcJB6Rlt7lDh5BkB46nu+4BzUptsnjBPQSd26mFpOfDQLrV3oJKZIuT8T7g/eXSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=X0aggZSL;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8ED606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=X0aggZSL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=i8u1UPs7vb9pstdHeXE9lyb6vLU6uwZjZNVtAstVNOI=;
	t=1793651943; x=1794861543; b=X0aggZSLOrpjP1GEMQz/tLlKAfwX2R4HtU+tNcjYEn7g0Gv
	TDCuPUFYbx5I0osGB/vzl+rMACE3Gj0p6316rnQ55om6KDcaM38tBII04IDtMsX3xQz29H8z6o9oY
	CFzE4G7SGRUmZj8a5fkV/R8ZUF4/U9aU1IIJTPyuQPSbz6mzN1pXLKBoR1xe2c1rp+ZRijW6RcQZz
	bk4rPbT5nTJ3g5BBeyPuNfF5BWXCA9gL4lO6+ieX+LRZhNm5aYsGU2NGh+5Q8fm+wwnvMnS3IDfhZ
	dEJ7QzIt0nLv7KiEEbv7vWyqWxxkmqle35QORl+dDxZE4xxjGlaKjur37BSjp1wA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyo1-00000001vzr-0sXA;
	Mon, 02 Nov 2026 21:39:01 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 23/30] wifi: mac80211: refactor fast-xmit header encapsulation
Date: Mon,  2 Nov 2026 21:23:13 +0100
Message-ID: <20261102203831.1058362-55-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

Move the 802.11 frame encapsulation using the fast-xmit
template to a separate function for future use.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 55 +++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8026aa1ff136..683e2e219a8f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3889,6 +3889,39 @@ ieee80211_tx_skb_fixup(struct sk_buff *skb, netdev_features_t features)
 	return NULL;
 }
 
+static int ieee80211_fast_tx_encap(struct ieee80211_sub_if_data *sdata,
+				   const struct ieee80211_fast_tx *fast_tx,
+				   struct sk_buff *skb,
+				   const u8 *da, const u8 *sa)
+{
+	int hw_headroom = sdata->local->hw.extra_tx_headroom;
+	int extra_head = fast_tx->hdr_len - (ETH_HLEN - 2);
+	struct ieee80211_hdr *hdr;
+
+	/* will not be crypto-handled beyond what we do here, so use false
+	 * as the may-encrypt argument for the resize to not account for
+	 * more room than we already have in 'extra_head'
+	 */
+	if (unlikely(ieee80211_skb_resize(sdata, skb,
+					  max_t(int, extra_head + hw_headroom -
+						     skb_headroom(skb), 0),
+					  ENCRYPT_NO)))
+		return -ENOMEM;
+
+	hdr = skb_push(skb, extra_head);
+	memcpy(skb->data, fast_tx->hdr, fast_tx->hdr_len);
+	memcpy(skb->data + fast_tx->da_offs, da, ETH_ALEN);
+	memcpy(skb->data + fast_tx->sa_offs, sa, ETH_ALEN);
+
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+
+		*ieee80211_get_qos_ctl(hdr) = tid;
+	}
+
+	return 0;
+}
+
 void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_fast_tx *fast_tx,
@@ -3900,8 +3933,6 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
-	int hw_headroom = sdata->local->hw.extra_tx_headroom;
-	int extra_head = fast_tx->hdr_len - (ETH_HLEN - 2);
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
@@ -3911,21 +3942,9 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb, da, sa))
 		return;
 
-	/* will not be crypto-handled beyond what we do here, so use false
-	 * as the may-encrypt argument for the resize to not account for
-	 * more room than we already have in 'extra_head'
-	 */
-	if (unlikely(ieee80211_skb_resize(sdata, skb,
-					  max_t(int, extra_head + hw_headroom -
-						     skb_headroom(skb), 0),
-					  ENCRYPT_NO)))
+	if (ieee80211_fast_tx_encap(sdata, fast_tx, skb, da, sa))
 		goto free;
 
-	hdr = skb_push(skb, extra_head);
-	memcpy(skb->data, fast_tx->hdr, fast_tx->hdr_len);
-	memcpy(skb->data + fast_tx->da_offs, da, ETH_ALEN);
-	memcpy(skb->data + fast_tx->sa_offs, sa, ETH_ALEN);
-
 	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 	info->band = fast_tx->band;
@@ -3941,12 +3960,6 @@ void __ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 #endif
 
-	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
-		u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-
-		*ieee80211_get_qos_ctl(hdr) = tid;
-	}
-
 	__skb_queue_head_init(&tx.skbs);
 
 	tx.flags = IEEE80211_TX_UNICAST;
-- 
2.56.0

