Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053948;
	b=QhJN5Jrb/Rmu8gi6rf+cMc7DiUiqX1ko0FytMOAgRcsDO+w7vcFulPOKFVyN/kh5EPs3
	 /YO32DfvoT5JYEEHrQh17VGpuYeoW/G6SKpcCIZjYHm21vF1czLD9wIWXrbIH3lYX07Op
	 Ch8houFFm79jnGKuhSgA92eirhKQCIJT8/P6tpvHepmPzLmWQaN46ThQzZ81MXWxqwDDp
	 xsWsQK3WbITp0At/FmZth01U/qx9193SRYJl5MsMBR2tKf79gcqpxS0/JagdyoyYr/agb
	 oXY3sskmJ5Af3/2Odb+RWBnbcpqAsIBR5pMfEs/dZoHPFDzXfe3saejmcJnL2JiB+rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8rXduDRKJP8drgeo5JnRezfiCAk6F66eeBkch8vfFZw=;
	b=eHQsT40xc4s8V7Ehe7x0ZRngwftTnsQeGtYsml5cl7cdXKKFlSL9n/1E12q/+fifcnU8
	 CiytdbIG72QUCvqVntktANPzSjPj3vn7r6YMCatHbCpwyubAGo9Vxxa5t7vkMPSIiIZlc
	 KjOfIx+Jnm/JtpIsV6L+5oe+Loy1Pqd9ModHljLGvY+17SRHdZhn2fsDwOAqnmPOpaWRB
	 s6F7lcqYSUdYA68VQVqCN35SAWQoAzn1XBnQrI36/M+aYbbnWxAcsQIXYX9j93rlrDKYt
	 d+jPXrLdtnOCzzYJRMwMjc86Kswxzjmk7zvs3SvmqvpouVQSoatrwm7fCj9zlDKxDjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HwRuhF6M;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2331606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 22:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2331606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HwRuhF6M
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso2457700f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793053946; x=1793658746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8rXduDRKJP8drgeo5JnRezfiCAk6F66eeBkch8vfFZw=;
        b=HwRuhF6M+Y66D48I35HkC/WvYHV4sTTX1rD0qaNjeay0lN5WIzYdDyQA8rX1ak4GqR
         mgrkEzMgbdiStyVxLOvv3vIyiDX4YQQ3iBVjE794ZRVYi6HGB0gQECYxdTYMPPpvkyvp
         29w/hfSBgvSW5zfhJDiDIzUgbnHD0QLoZXaEEoRjenbetrJki4n7RS1+x94YO+NnsV3Z
         Xjix2v1h7SVPMcxEAexgee+afdRv4mDBCtHoncnXIrNPwdSq4gR+gG2hFON12d6uJL5d
         GVYZxep4DLSsCALe7+D3ZyFm/jW/LPNOeKxqTAK5pPc3rFtyQTqyPSFbOfnvTixmNhEi
         BU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793053946; x=1793658746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8rXduDRKJP8drgeo5JnRezfiCAk6F66eeBkch8vfFZw=;
        b=kyK0NIVbZdqL5TNz++//3J0J/P7FldD+jdOaQqTwDy1tnrMT+53rnb1V+lOcSrCuDY
         8V0Jsw9Lw8WdhZS6vB3gxEEHdB0jTbWhRi7Q2BN7GrtqxzT0e4ry+vsONNhtOAHRgUHK
         OSPXIoPtu3J32+pKxhsxPgq/7GUthZNzQRwxodG18UTFJTp53NzJk5/b0cKDpBGlNERs
         VTQs/aIgMNzqQsNAyvJgppibvD8pZzcM6IEf3mQFbGJ263Gc03bwnDYsTgXmQWvjhWIT
         JjvKFrUCZu3gR175jqTmS0guN67tI1Y+tsPYZR+Y6iXQ6B12n0I4Ryp1CW6hSLc5Qyf+
         OLmg==
X-Forwarded-Encrypted: i=1; AKwUvByY5P1AEyQQ81x1+KCZVMn7h2J12ZQ23A4RaqgpY6hKB0nN+uAAjwVuL84vVZN3i/AtPHaUycNH5zfyEc9erA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJyietkMGQPjFetU4vVSg1EhRjIB5yuDHkDhZAJ8wExDOm58IRg
	SKf5I+aq2X3o4GKBL094+4cJ/u0XJTR4dJVtpP6yci0Y77pGBIOieG0=
X-Gm-Gg: AYBFou0UeTwq1L1n/+/hpDwjKMYcuagVUbJg1z/oopGCJ6F1rO1daQtvp83Dd8zG5SS
	Q67wJxRfhyjnBcj2gMWAGLlmo+grCUYz5ggFIreW/cbgc8gf5FK7IQ+/JvrKk+EpE9ue4n8hENg
	B2UQ282nB9x53IbRkG5A7bXrfmJLDVXenzsI+IydmUDT2pXqsPSeSC6aw7ILygki6pRFo65s+hE
	imiTBuZV8kXki4Ncjsd+uZegvQ1wxOUKY/ikvF72MJuHudIGVCMAMVh2dIFNLP4UtyMWJjLysgP
	z3at08Yzl6B0U4R27h8qizCM9ql5v9AU7ui+6xtgbOGY3YAzIa6XNLX2IM0Qo0UbVz7Q3qtCTL0
	Pm8G639FjIsyLy2eDDihP/CsjdW89zaWyUz02sRHOFU7BjfyVhwQs1oqqSu7WEVMLDyxWL/guNm
	c/V2Zks4API/pPkhKOAoHVaxCvq0cjzKK1Yv3HyCDUQ4bVtVBHEbEQNJ2BqN6GHL3xA4MhoQrHs
	wA4QNfjxgnfUbyIfvt+gVtLu2hpRSZG00sipw==
X-Received: by 2002:a05:6000:2a87:b0:48e:2c2f:59eb with SMTP id ffacd0b85a97d-48e3eb9a023mr11905332f8f.12.1793053945957;
        Mon, 26 Oct 2026 15:32:25 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb851sm16239300f8f.26.2026.10.26.15.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 15:32:24 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Kees Cook <kees@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	tristan@talencesecurity.com
Subject: [PATCH v2 wireless 3/3] wifi: p54: replace open-coded IE search with cfg80211_find_ie()
Date: Mon, 26 Oct 2026 22:32:21 +0000
Message-ID: <20261026223222.2093813-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

Replace the hand-rolled p54_find_ie() with cfg80211_find_ie() at both
call sites.  The old function had a buggy short-frame guard
(sizeof(mgmt) compares against pointer size, not struct size) and
open-coded the IE iteration that cfg80211_find_ie() already provides
correctly.

Add a pre-subtraction length guard at both call sites to prevent an
unsigned underflow when computing the IE area length from a truncated
beacon frame.

In p54_beacon_format_ie_tim() the returned pointer is cast to non-const
u8 * because the caller modifies the buffer via memmove(); this matches
existing in-tree precedent (ath10k, wlcore, cw1200, nxpwifi).

Fixes: e5ea92a7528d ("p54: AP & Ad-hoc testing")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/intersil/p54/lmac.h |  3 ---
 drivers/net/wireless/intersil/p54/main.c | 30 ++++++------------------
 drivers/net/wireless/intersil/p54/txrx.c | 12 +++++++---
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/lmac.h b/drivers/net/wireless/intersil/p54/lmac.h
index 8adde6ba35ab8..d9cbffb74a265 100644
--- a/drivers/net/wireless/intersil/p54/lmac.h
+++ b/drivers/net/wireless/intersil/p54/lmac.h
@@ -553,7 +553,4 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
 			u16 offset, u16 len);
 struct p54_rssi_db_entry *p54_rssi_find(struct p54_common *p, const u16 freq);
 
-/* utility */
-u8 *p54_find_ie(struct sk_buff *skb, u8 ie);
-
 #endif /* LMAC_H */
diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 57a62108cbc35..30f235d470bb4 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -71,28 +71,6 @@ static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
 	return p54_update_beacon_tim(priv, sta->aid, set);
 }
 
-u8 *p54_find_ie(struct sk_buff *skb, u8 ie)
-{
-	struct ieee80211_mgmt *mgmt = (void *)skb->data;
-	u8 *pos, *end;
-
-	if (skb->len <= sizeof(mgmt))
-		return NULL;
-
-	pos = (u8 *)mgmt->u.beacon.variable;
-	end = skb->data + skb->len;
-	while (pos < end) {
-		if (pos + 2 + pos[1] > end)
-			return NULL;
-
-		if (pos[0] == ie)
-			return pos;
-
-		pos += 2 + pos[1];
-	}
-	return NULL;
-}
-
 static int p54_beacon_format_ie_tim(struct sk_buff *skb)
 {
 	/*
@@ -100,12 +78,18 @@ static int p54_beacon_format_ie_tim(struct sk_buff *skb)
 	 * The dummy TIM MUST be at the end of the beacon frame,
 	 * because it'll be overwritten!
 	 */
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	size_t ie_start = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	u8 *tim;
 	u8 dtim_len;
 	u8 dtim_period;
 	u8 *next;
 
-	tim = p54_find_ie(skb, WLAN_EID_TIM);
+	if (skb->len < ie_start)
+		return 0;
+
+	tim = (u8 *)cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
+				    skb->len - ie_start);
 	if (!tim)
 		return 0;
 
diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 9f491334c8d04..7f952fcf16da7 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -293,9 +293,11 @@ static int p54_rssi_to_dbm(struct p54_common *priv, int rssi)
  */
 static void p54_pspoll_workaround(struct p54_common *priv, struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (void *) skb->data;
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	size_t ie_start = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	struct ieee80211_tim_ie *tim_ie;
-	u8 *tim;
+	const u8 *tim;
 	u8 tim_len;
 	bool new_psm;
 
@@ -310,7 +312,11 @@ static void p54_pspoll_workaround(struct p54_common *priv, struct sk_buff *skb)
 	if (!ether_addr_equal_64bits(hdr->addr3, priv->bssid))
 		return;
 
-	tim = p54_find_ie(skb, WLAN_EID_TIM);
+	if (skb->len < ie_start)
+		return;
+
+	tim = cfg80211_find_ie(WLAN_EID_TIM, mgmt->u.beacon.variable,
+			       skb->len - ie_start);
 	if (!tim)
 		return;
 
-- 
2.47.3

