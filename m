Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793162497;
	b=3qvD0biQrFJlhk1Ax7cz9/4KM8n/aAv8TT8aomUQgx3Wq7sdyjgnou7QnrF/exusmGcL
	 PLn0hVKsJEpTj2FYr+ZB7PDwN3IDV9mGvY2MPerNnxMJreoFMirBkbfQcs0ttDYgMx8RT
	 Q5ZFgBLEd/X6wxQajF++uJhLnmBC9wrFnH1GI6PI8BvfFodTPvMop61FDzs0IL2nOunoJ
	 ZjODNmbHMjYlDLCKYTPtRfQq8k4fHgh3jAx169fCo3VVhnlQ7jJBMJcW+qKzar8Dz5bjT
	 XHrNatObpMQZRIbpMFPDJSSW4FymjWmZJFw9598zRBqargTwoapbeqHEwqFzft9Nn4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793162497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RgnLwm7jME7dLSPWA5NR9OIlJ+/VcsQqGQdujMYqqLk=;
	b=gGv9Bh1gXIdpAuxUpyPPRqEMt7h3mkF1ipBMdzlCIv4rcwL7QvF3JNg54ezI9co68Taz
	 qJGZxCe75YGjaN6oK+KsVWkNRa0+qH5DKK+pf7zPXZQFUwZlDCR7FB9D9o2QaDDQCEeDX
	 rYM0oJkU5yXFMBwYldQ95DlazGHaLJSJV/WMqw+u8Iw/OW45N2TbwM0Jtjo755nJuotI4
	 fn0buuZUpoNmfq+p4aMGLRjMAahiC2Qg3/wh7ja688/FfNb2I9Vi0NnhxKxmmWsd5L5ij
	 YKDfNpJa2uUa9etWoEjgZH0XRjww/6LZ5Ua2PG16mtQZ1aEJwjGJ/H5AddP55AzeKpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="skgf6e/R";
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE81606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 04:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BE81606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=skgf6e/R
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-89f28c3ac7bso234301b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 21:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793162497; x=1793767297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RgnLwm7jME7dLSPWA5NR9OIlJ+/VcsQqGQdujMYqqLk=;
        b=skgf6e/RARXyhPhtwp3PrkEDpmWwy4NJqEloTLTDXdBfQzhN6iNe5IEkdMPTkx1M5J
         tQSHatGR0KjIDZ6SzoNeyJG8/Ew1TPGy2k084i3Wrxfk3WMKJ9OG/JpE4Xuh+ooZpJ0O
         KQgnnnfpEM8BWA0g9WLL6rKRRLGW02fdAXVe5nWKGDsx1Qo+c/TPU94GzSrUrA3MrHdo
         MQm/SpLLxdkTN/Y3JGXXAFuh/eDVki1nd3DTXXDZmY1dYRpq++I1J7GzVAYraw88Lvse
         Q+JMYR00YOC4unlSGUp/z58EUvoy2uVXosfFceDLKJKjDkEKsuZlfRHNmqiNTwPhWz8d
         eI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793162497; x=1793767297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RgnLwm7jME7dLSPWA5NR9OIlJ+/VcsQqGQdujMYqqLk=;
        b=um0AxgJhVZKnFYGfIe0cM/349UigHbjeOF4U/E95qkyWmjeUFNU9u/Yz0v9/FYif+I
         s15zjYgD7gezRLau3IdKKTIpPsyqiV/UZ6IJNzzpxmThZqY7IJB/mUlDcAtnKXe5e36e
         FEKOlbi56X46/Cz5YQSdHT8eKYSjJUpX/BoC6qeDiGn+CPpJd3ngdyF/fU/d2usglIvT
         JhyGs2VphSWyB76idEFjvYuiib7M8amgxdnpmfHVC6kUG/COkWiBfgkU1gxGUeqeXdnV
         h2NYJWHx7X35PxqcICTRnLyg55XHV76KorQCVmVOwEqbwDfDDX43+2Y42O8a0A8TKJOx
         tJtA==
X-Gm-Message-State: AFq9FYIu5ElWAIPb1QUkrrocP2ejB4bgtX742AJJC09U7XmWAcYdfxwZ
	0wtBSk3rfkPXBymJqZ/J0TJJqXAAj91AIsuE2bF5CPKz3LVtVak3+7vewzilBMn2aCU=
X-Gm-Gg: AYBFou0rWSb9VeIpGxjuz/EDbhu6SM+3XNplKGdAOFnSFX+YT2RyAldRqPygyoDk/s+
	b97yfmwF1qR6AW2VpTRlNlCKScweQvZzeJqMqEZxSG9XwemV1KJRXProv7KtxluMK0HAbcL4y5f
	r3a2eKEEoaF9ADBY0R8VX8pWXeQUOITrphMq14zNsev43HEcwk6MAZzriedW4tuxeJJ5Hx3VcgO
	JjKBZso6dU+nDn8HQDj3UwwyRUpEn7y2kFKTsduvyhJE0E1ml/EAX0Vta6fZXjCdc1qH1vvyP1m
	TDBF8xDpkh97K9qyz6TZhYooMAkSf2Ba3/eIVEyt84Mt7DnWZ5gcM9J/mHxOLWONnofVVqmgUmL
	s8mlIUJcWkGCX1/kyjv1WlmGpt+8uVxgIhRpJh157UGzK1ccLoNUDVnksPwzBJLWVI6X5HIRARs
	M4A1Dbihsz+WQkodZ3y78h0A2/W5xcFxpx6IIH7gT8Y+B8BbqBNNjIaW6U3h6bZmjYILwzlLVxO
	tWX7usQUmMHM0iaBEfWsfO8g5tlApuZOW8iiV1T+G9VvrWeUlc1ccdLeXskGYT63FT4YDV8RKwR
	3u2piBid4vNUDPpqm6rFAsLY9L8pHbRhsopG5+jNDy0iwH5TWM3G2nRcIE1bNeaVYspgkus9rQ3
	hxE+romj+1RCeeszWtv588hE0JvKFap2aykqkQo/Lsp/k0iey+KigQj0=
X-Received: by 2002:a05:6300:6698:b0:3e8:b7fd:626c with SMTP id adf61e73a8af0-3e902291d87mr1088898637.20.1793162497022;
        Tue, 27 Oct 2026 21:41:37 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfc5ccsm630826b3a.40.2026.10.27.21.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 21:41:36 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: remove ieee80211_rx_beacon_freq_valid
Date: Wed, 28 Oct 2026 15:41:18 +1100
Message-ID: <20261028044118.1422069-3-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028044118.1422069-1-lachlan.hodges@morsemicro.com>
References: <20261028044118.1422069-1-lachlan.hodges@morsemicro.com>
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

Remove ieee80211_rx_beacon_freq_valid() and replace it with the same
freq offset aware comparison used elsewhere, since we now expect the
1MHz primary to be reported at all times.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 net/mac80211/mlme.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6ec45a9f7221..f9ede2d80523 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8095,38 +8095,6 @@ static bool ieee80211_mgd_ssid_mismatch(struct ieee80211_sub_if_data *sdata,
 	return memcmp(elems->ssid, cfg->ssid, cfg->ssid_len);
 }
 
-static bool
-ieee80211_rx_beacon_freq_valid(struct ieee80211_local *local,
-			       struct ieee80211_mgmt *mgmt,
-			       struct ieee80211_rx_status *rx_status,
-			       struct ieee80211_chanctx_conf *chanctx)
-{
-	u32 pri_2mhz_khz;
-	struct ieee80211_channel *s1g_sibling_1mhz;
-	u32 pri_khz = ieee80211_channel_to_khz(chanctx->def.chan);
-	u32 rx_khz = ieee80211_rx_status_to_khz(rx_status);
-
-	if (rx_khz == pri_khz)
-		return true;
-
-	if (!chanctx->def.s1g_primary_2mhz)
-		return false;
-
-	/*
-	 * If we have an S1G interface with a 2MHz primary, beacons are
-	 * sent on the center frequency of the 2MHz primary. Find the sibling
-	 * 1MHz channel and calculate the 2MHz primary center frequency.
-	 */
-	s1g_sibling_1mhz = cfg80211_s1g_get_primary_sibling(local->hw.wiphy,
-							    &chanctx->def);
-	if (!s1g_sibling_1mhz)
-		return false;
-
-	pri_2mhz_khz =
-		(pri_khz + ieee80211_channel_to_khz(s1g_sibling_1mhz)) / 2;
-	return rx_khz == pri_2mhz_khz;
-}
-
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 				     struct ieee80211_hdr *hdr, size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -8180,8 +8148,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		return;
 	}
 
-	if (!ieee80211_rx_beacon_freq_valid(local, mgmt, rx_status,
-					    chanctx_conf)) {
+	if (ieee80211_rx_status_to_khz(rx_status) !=
+	    ieee80211_channel_to_khz(chanctx_conf->def.chan)) {
 		rcu_read_unlock();
 		return;
 	}
-- 
2.43.0

