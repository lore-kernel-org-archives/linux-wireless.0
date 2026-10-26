Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792987333;
	b=ATlq5HxW0Mh049flkhI7BOnbbBrytfE9cFTEg2nMDUvijzOviTMnxogyF28r9/GpOSS0
	 paBOdkkAGndtFYFeQayt581lRi4RZPsXkYWxhGDGF0NE+h2KtVPL5WtXkWYiecf3D/0+j
	 YZoCWFI9VEZZIggCRm7c84THXKsqagXkJ9u1WnmNHAHdw7QR7MI1pC00PfPNvyDhtkjcn
	 Ny3mC+M0ptVA5W8zVBktHFe/mXqeZfya4dxO+v2KCWIfCxZOmTq2F7xznfjbmTLDghjTF
	 CXmJ3qX59jqMv1TbKahdyPWhYKczpipOnf9nFyyTq69u0VIk7gCgu/k2cpuQHIaLD+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792987333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7IsVQT+EBQo1oTvITpYf6+rXx0JZnsNppK5scdXnmz8=;
	b=apZRlfznVwTao8NcklDVmP+zgQk/YLKgxfrSIyefLZN0JhJvM38pdZnbktCbSK8KKpj/
	 Gt2zP5UxHEULfKdN9GYJaRaLnLGy+MY6Z+wJUjxiSprmcu0+46EegzcYkPIqIZJn9O2jR
	 LEt7vYy09ZR0ThfnrbkdjQHNHxuuZYJom+plAByHkgUYKRcTxICFdb/nHnK8HWF9DjrSO
	 UqEgnev+I/yM1O4V3W3BCexT77rSOq9rJFEbv0VyblMYp610lBScWAyImQB39U3Q9r01W
	 XlL5IdOYWt8DuAS2QcJ1Jfq7Qoc+MZNUPqyP+TNzU4ZEe6ZAUK7zUndozVeEm3sE8Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=C63TgyKq;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35170606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 04:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35170606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=C63TgyKq
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3535a54bed9so4083902eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 21:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792987332; x=1793592132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7IsVQT+EBQo1oTvITpYf6+rXx0JZnsNppK5scdXnmz8=;
        b=C63TgyKqhS79//aZjYn7A72ETrj3J4Jmx7z9adsGrZ6BdiMYniJUoU8X2MjGLEb5qF
         vcdWELlXuwNjY7ri1eQ+bOPMV1ERQBlhznsdnyXlkQEOtq7nOJ7fqb8zQLMMrRsFFtvq
         7mA+K2J02rpQArtdedYi3GTZYjZ9CnHGUkBj6Q2UnWbJpF0+24YTVn6xgCf9kyWS+5jg
         cpM+e6AZV7jNUE78AVfZtoN/VyT4gydY1fme8SjZfrrsZ8ecdaFWRy4oa+7GYjFAHe1q
         ZO2+zk1KtdnNtS5RPLVatVSjtCwMfgiz30COpxkzE/YMry6lVswa+4R4O7SCp4wGY3K/
         HRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792987332; x=1793592132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7IsVQT+EBQo1oTvITpYf6+rXx0JZnsNppK5scdXnmz8=;
        b=Csm1ZzYYC6xqYBAA0W85qjaAk2SvgTVp2cgP0dvna3yCNSnYabAxdcPfzWo9ZmelDR
         YknwAS5Z+eqH728QByTeSs++ryLI/f9GrT4Ifq6kmqbOwxn+KVh72UaQ+WRkUkGv+nBs
         jsr3l+H6ZktYtRr4Kzzi8ErS4/DaljlORNf8NNirs04a5W5Q0bAv7wstYGb2wYMysRL3
         hpR3rFGSNl+mWBvJtHTpVlXM88QhAPik+vmlFQVJ1l7MOF7EWUTX7Y8HEZj61xEbc0D5
         kzP7Z+Z+6ZuTepcrbvKenwuykepn2g1bRs78oe83Q15c7clZ8BlM4a3TQ1Jd4sZODBA6
         5pFg==
X-Forwarded-Encrypted: i=1; AKwUvBx67xrYYdtzR5VWHN/P+k591ycRCq4tBEuvDWuP3tRELIUBbImJRGSxVnDkXpYuueA/mZMq7DZp1VU1SL9njg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLeQ4fHPY7Q1NgmiQeLpy7pIcVmtRTgSvOWsGA73RCtWcf42LYl
	6bv5ahAdwN/GLBLX2h/F3Q1uZLNFGBl+KQnRRv14TgQKTXXrOEa0ClytPglN1krE
X-Gm-Gg: AYBFou3RXJ1sXyCzGro+1xzcNzQQDxkJWc41uA7t20ph0OSO03DQETrFR6x2coLaOjh
	HnIkAKxiDEFM16z2Bdes+DODquD+f21w+RSPAA5dxO7ceBe93VWMFQY3lbJl2lAywZdziLsv3pn
	gGKKGl0kywwOBfZkAUnbYYj7nyq3eSlww20T4OFoFzhI04P9zlvnAVKCJK3WLt3YQkLtI123Blt
	Eunhr/eNKs8XyaV0kD9bse1cGtRC9oOCfZCxmTPU5dxjwHz3jdyXvZxRv0cRvqPhldaMX+vicnN
	Q1Y3F1mtVAjSoXjaFBfYtu4J1CZP9aKV58ffju9aUwmGUgGAMZsiDKLptuqhFHTZymYRLPIokG7
	YwthKtSNI57LjHlUhDQJLkrgi4YpZ++P/oHKN9vgHjEtlKPKBDGxnSdTfE8nZfsLO1z+GHl3cLm
	xpMMyne7bflYYnsPCnU2YimUZiajfC/M656aDhXUgVe7nOisUC6IhI9NqYQ9CUy4xYpHzyjeV9c
	/vLk9bv3bFS6QTa6Y2OE8XRQ21uCVN4ChkCI+2YjG4R5Ns17oHYkwXi9G4qB3oimMdk7PWfLdqJ
	OCGO4sV/Msgqnw4T6us2/w==
X-Received: by 2002:a05:7301:5404:b0:35c:8b96:94d9 with SMTP id 5a478bee46e88-369e8471460mr8498716eec.19.1792987332331;
        Sun, 25 Oct 2026 21:02:12 -0700 (PDT)
Received: from ZephyrLabServer.internal ([165.162.64.148])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369ff5a4d68sm6395094eec.14.2026.10.25.21.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 21:02:11 -0700 (PDT)
From: John Macias <dencity7@gmail.com>
To: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: use HT CCFS2 when computing the AP's HE and lower bandwidth
Date: Sun, 25 Oct 2026 21:01:48 -0700
Message-ID: <20261026040148.2633920-1-dencity7@gmail.com>
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

If the driver advertises VHT extended NSS BW support, hostapd announces
a 160 MHz BSS the way IEEE 802.11-2020 allows for that case: the VHT
Operation element has channel width 1, CCFS0 is the 80 MHz segment and
CCFS1 is 0, and the 160 MHz centre is in the CCFS2 field of the HT
Operation element.

ieee80211_calc_ap_he_and_lower() only looks at the VHT CCFS1, so it
sets bss_bw.he_and_lower to 80 MHz and ieee80211_sta_usable_bw() then
limits every HE and VHT station to 80 MHz. Stations parse CCFS2 and use
160 MHz towards the AP, but the AP never transmits wider than 80 MHz.

Take CCFS2 from the HT Operation element when the VHT CCFS1 is 0, as
the station side already does in ieee80211_chandef_vht_oper().

Seen with ath11k on IPQ8074 (it advertises extended NSS BW when the
firmware reports an NSS ratio) with an HE160 BSS on channel 36: peers
were created as 11ax-he80 and no frames were sent at 160 MHz. With this
change the peers are 11ax-he160, nearly all downlink data goes out at
160 MHz and an MT7925 client's download went from 810 to 1645 Mb/s.

Fixes: c9b62ab79133 ("wifi: mac80211: fix per-station PHY capability bandwidth")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: John Macias <dencity7@gmail.com>
---
 net/mac80211/cfg.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1753335e..e6fd83cb7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1366,6 +1366,13 @@ ieee80211_calc_ap_he_and_lower(struct cfg80211_beacon_data *params)
 			 */
 			ccfs0 = vht_oper->center_freq_seg0_idx;
 			ccfs1 = vht_oper->center_freq_seg1_idx;
+			/*
+			 * With extended NSS BW support the second segment
+			 * can be in the HT Operation CCFS2 field instead.
+			 */
+			if (!ccfs1 && params->ht_oper)
+				ccfs1 = le16_get_bits(params->ht_oper->operation_mode,
+						      IEEE80211_HT_OP_MODE_CCFS2_MASK);
 			if (!ccfs0)
 				return IEEE80211_STA_RX_BW_80;
 			if (ccfs1 && abs(ccfs1 - ccfs0) == 8)
-- 
2.47.3

