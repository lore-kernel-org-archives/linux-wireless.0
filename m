Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993023;
	b=anPrzivbtn4B+ZdngDgLuVpAHHX6Vv29iYsQRRBCTWNZDdyAUAcs3oouB/6enoOfFWSP
	 byVDn8UFAeF6rqW9VCNew4XEdsMEy1VrpciXIp2BNcCBjrmM9CLXedrI/oybI+GMV7405
	 8fsvZNfLSZfFHsqZJrRgmkeAMUyQg+PpC1Pke+Ge5J/MlmZrL6/rwPskki7B1AAYxaMxB
	 Aen91hGoyKwZRQMkWnkc41WFQigMIYZhsFbEKw5LX9go8i9USabuE0At+oE0DSnRIn7Lr
	 keFSJNQU5kGACeTLuwWp2Yx0huhjtSfAAcUH/Hh4uThdM/6PSmq1Ew5+GDMtglEhUXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GlUubqa9MSphGSL0vJJZGwNftzoxye8o8z0vyQIt648=;
	b=JhflLktqyUmtiCaWFKDXVt/VWfnKGXqJUcHj4dMm1pUj2CjlSWKp5HcB3pJ8n8jFwGXa
	 R4OMR9coN0AwLPP9oi1Iv3vPCurbKX0F0OfQJQpGuBjM7ZaBD9+9Zcgi6EheVychGclt+
	 s8LZBeJMIgB9tg2Iax7QRtL2sVjDEtOSogGdFoAFeYwX8LFcoP8XTt1MDSHHe5bIxE6Ya
	 HSk7Yxo+FLDHyQn5TnT87nhBjuBAYC4/miiwcvJuRDqV5BvnJo497Dc7FhmKEJVOKufD1
	 yx7CBIzZPuJjl0/UD57U4IcJxYLJHr9aSaVEXVHGVzeRpjq1yfiHjI92P4WO0Q057LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Z06hZLsr;
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3E8606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F3E8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Z06hZLsr
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a06210b29fso902283b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993022; x=1793597822; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GlUubqa9MSphGSL0vJJZGwNftzoxye8o8z0vyQIt648=;
        b=Z06hZLsrYJ6kSQBqRoZBJ1a9H+53WrKU2KxWDI3cJNioiE8vU//XcRpHHJxCd3aP14
         lXoFad9VPD6+Gq11QCHnEHj4QAeQCDCkXh4+m6rvEXHGoBVqAy9Y6F6GjJ9sQAvEXF9A
         hBfQH/ZVUDv4ebDsUjhHXHd8Zjh/6XhXDfMm6GKsXtis9XDCarow2MYXdeKXaFj4Ikfk
         kolegIUD+z44mZt3v9gwWwYyHd4I7Uq60Y08oizmlAvPzUjY82RTRSrlqiXlB1/0uzLh
         cg+HN/0wki2pdIV17m0w5IwNos1TSZQ67peiuC2+8N51M5lIX6KWD1+bmSTxxGJcVKTp
         q+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993022; x=1793597822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GlUubqa9MSphGSL0vJJZGwNftzoxye8o8z0vyQIt648=;
        b=nBNQElu8stW/a+fYXn12iPpwaXTgHG2Asp1Zt46NdaTmYYfhbZ4H4YR6ULwRuROHms
         6aRwjeOIR4MgVr4dNZVv7MhxsF2gwquCp04AnCouyAhvPt7aoOhGdIbMD+eCwRtLgL2W
         hUyH1Os51DkU1D4W3nqWBAGUaOAFmnLEik5eiQfCJejXBNVGrJguV3eRppffHBd4ZDN1
         moZcfk6JdW++DV2fcdCZtmvu92A9MvxrKmwEdX39p8i3kV3i3lTJss9ZhIljKt5gkoL3
         F/xVUjhIMn92AqQU9usIpA6SNs00j879eBb3GiBeU0VujqijAtJSIPNZJSpc9uoB1tt5
         IU2A==
X-Gm-Message-State: AFq9FYIu5WXrm7tQAF1DmV+W+oK1NH6pT4tWJxTgJUClPfy+gYX7vzym
	3BpUVaQyvBtfEmX5SJxktV+WC5LmDNDEVgjvoGLGl/HKNVqW4hGyfNOoqMShgu2O49RnGA==
X-Gm-Gg: AYBFou3We9ItYxGreK1G3ElVs55sVrtDElsx6rDWS2MmkunN1zqAOKKDRz3JJvDCYGm
	14bMDYX7ChpicU+2I5X45o+fGwLe47r/QxHSsBZfFnFVf3+mSU6i3raGi6b6ppAAdh352cUUTZ9
	plypa53zI4KTODyzEQIYpT3ELjq+oDZu1dSRQ3cU2MFi7OUydZMQI4B273RvqLHDfzRcXb18KXx
	vj1dwCfDPSpz/eqO9zrOSYLhqVmcqQpPP1/FMsFSd1IBF5eVv2o40/queKQGtyBXV30Vffl1cx/
	YHsuxE6GNdTBtvqppfU4Mq+DYtWsH5orMcJRQ1JgiHMPt6OzfnMYEuNc6NO+hHg33SjTRgELeyG
	IcXFWQhy+U7mj6ooPTLZD3CKYQoWFxZ2G6Fq11gRMN+OYiiTVjwptmpqvE38wiSws4jt2piQt10
	hfgY4p/kjsQWlv3iHJ41c8bCak45D6rYgIpmIlfQs93aiL7gla2d9TTeUjO3Oqd7KDuNc0mZSUX
	fuwoqfaogHJWrBsZfhRuh73X34utkYB5ZF+C6hbLc0XFv+4sKOacbMNEEN43xNfEXfONMFgj9zk
	Whua0YYOrjrh4Gi4UocKy/Qlkg==
X-Received: by 2002:a05:6a00:1d9e:b0:89e:99a6:4671 with SMTP id d2e1a72fcca58-8a3688b1545mr4442946b3a.36.1792993022461;
        Sun, 25 Oct 2026 22:37:02 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:02 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 04/17] wifi: brcmsmac: give the rate tables and helpers a brcmu_ prefix
Date: Mon, 26 Oct 2026 13:36:10 +0800
Message-ID: <20261026053633.361454-5-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
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

Prepare rate.c for move to brcmutil, which exports them.
Rename brcms_c_ to brcmu_.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/main.c        | 87 +++++++++---------
 .../broadcom/brcm80211/brcmsmac/rate.c        | 88 +++++++++----------
 .../broadcom/brcm80211/brcmsmac/rate.h        | 68 +++++++-------
 3 files changed, 121 insertions(+), 122 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index ec3aeaa7b..3a383b0d1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -352,7 +352,7 @@ static u8 brcms_fifo_to_ac(u8 fifo)
 static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 {
 	if (is_mcs_rate(rspec))
-		return wlc->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK]
+		return wlc->band->basic_rate[brcmu_mcs_table[rspec & RSPEC_RATE_MASK]
 		       .leg_ofdm];
 	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
 }
@@ -3361,11 +3361,11 @@ static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
 static void
 brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 {
-	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
-		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
-		brcms_chspec_bw(wlc->default_bss->chanspec),
-		wlc->stf->txstreams);
+	brcmu_rateset_default(rs, NULL, wlc->band->phytype,
+			      wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
+			      (bool)(wlc->pub->_n_enab & SUPPORT_11N),
+			      brcms_chspec_bw(wlc->default_bss->chanspec),
+			      wlc->stf->txstreams);
 }
 
 /* derive wlc->band->basic_rate[] table from 'rateset' */
@@ -3496,9 +3496,9 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 		brcms_default_rateset(wlc, &default_rateset);
 
 		/* fill in hw_rate */
-		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
-				   false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
+		brcmu_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
+				     false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
+				     (bool)(wlc->pub->_n_enab & SUPPORT_11N));
 
 		/* init basic rate lookup */
 		brcms_c_rate_lookup_init(wlc, &default_rateset);
@@ -3583,8 +3583,8 @@ static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
 	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
-	basic_phy_rate = rate_info[basic_rate] & BRCMS_RATE_MASK;
+	phy_rate = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
+	basic_phy_rate = brcmu_rate_info[basic_rate] & BRCMS_RATE_MASK;
 	index = phy_rate & 0xf;
 	basic_index = basic_phy_rate & 0xf;
 
@@ -3606,13 +3606,13 @@ brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		if (wlc->band->bandtype == BRCM_BAND_5G)
-			rs_dflt = &ofdm_mimo_rates;
+			rs_dflt = &brcmu_ofdm_mimo_rates;
 		else
-			rs_dflt = &cck_ofdm_mimo_rates;
+			rs_dflt = &brcmu_cck_ofdm_mimo_rates;
 	} else if (wlc->band->gmode)
-		rs_dflt = &cck_ofdm_rates;
+		rs_dflt = &brcmu_cck_ofdm_rates;
 	else
-		rs_dflt = &cck_rates;
+		rs_dflt = &brcmu_cck_rates;
 
 	return rs_dflt;
 }
@@ -3626,8 +3626,8 @@ static void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 
 	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
-	brcms_c_rateset_copy(rs_dflt, &rs);
-	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+	brcmu_rateset_copy(rs_dflt, &rs);
+	brcmu_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
 	/* walk the phy rate table and update SHM basic rate lookup table */
 	for (i = 0; i < rs.count; i++) {
@@ -3894,8 +3894,9 @@ static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 		/* Fix the hardware rateset based on bw.
 		 * Mainly add MCS32 for 40Mhz, remove MCS 32 for 20Mhz
 		 */
-		brcms_c_rateset_bw_mcs_filter(&wlc->band->hw_rateset,
-			wlc->band->mimo_cap_40 ? brcms_chspec_bw(chanspec) : 0);
+		brcmu_rateset_bw_mcs_filter(&wlc->band->hw_rateset,
+					    wlc->band->mimo_cap_40 ?
+					    brcms_chspec_bw(chanspec) : 0);
 	}
 
 	/* update some mac configuration since chanspec changed */
@@ -4712,10 +4713,10 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 
 	/* init bss rates to the band specific default rate set */
-	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
-		band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
-		brcms_chspec_bw(chanspec), wlc->stf->txstreams);
+	brcmu_rateset_default(&bi->rateset, NULL, band->phytype,
+			      band->bandtype, false, BRCMS_RATE_MASK_FULL,
+			      (bool)(wlc->pub->_n_enab & SUPPORT_11N),
+			      brcms_chspec_bw(chanspec), wlc->stf->txstreams);
 
 	if (wlc->pub->_n_enab & SUPPORT_11N)
 		bi->flags |= BRCMS_BSS_HT;
@@ -5207,7 +5208,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	switch (gmode) {
 	case GMODE_LEGACY_B:
 		shortslot = BRCMS_SHORTSLOT_OFF;
-		brcms_c_rateset_copy(&gphy_legacy_rates, &rs);
+		brcmu_rateset_copy(&brcmu_gphy_legacy_rates, &rs);
 
 		break;
 
@@ -5240,7 +5241,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	/* Use the default 11g rateset */
 	if (!rs.count)
-		brcms_c_rateset_copy(&cck_ofdm_rates, &rs);
+		brcmu_rateset_copy(&brcmu_cck_ofdm_rates, &rs);
 
 	if (ofdm_basic) {
 		for (i = 0; i < rs.count; i++) {
@@ -5277,8 +5278,8 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc)
 		wlc->pub->_n_enab = SUPPORT_11N;
 	wlc->default_bss->flags |= BRCMS_BSS_HT;
 	/* add the mcs rates to the default and hw ratesets */
-	brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
-			      wlc->stf->txstreams);
+	brcmu_rateset_mcs_build(&wlc->default_bss->rateset,
+				wlc->stf->txstreams);
 	for (i = 0; i < wlc->pub->_nbands; i++)
 		memcpy(wlc->bandstate[i]->hw_rateset.mcs,
 		       wlc->default_bss->rateset.mcs, MCSSET_LEN);
@@ -5302,7 +5303,7 @@ brcms_c_set_internal_rateset(struct brcms_c_info *wlc,
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
 	memcpy(&new, &rs, sizeof(struct brcms_c_rateset));
-	if (brcms_c_rate_hwrs_filter_sort_validate
+	if (brcmu_rate_hwrs_filter_sort_validate
 	    (&new, &wlc->bandstate[bandunit]->hw_rateset, true,
 	     wlc->stf->txstreams))
 		goto good;
@@ -5311,11 +5312,9 @@ brcms_c_set_internal_rateset(struct brcms_c_info *wlc,
 	if (brcms_is_mband_unlocked(wlc)) {
 		bandunit = OTHERBANDUNIT(wlc);
 		memcpy(&new, &rs, sizeof(struct brcms_c_rateset));
-		if (brcms_c_rate_hwrs_filter_sort_validate(&new,
-						       &wlc->
-						       bandstate[bandunit]->
-						       hw_rateset, true,
-						       wlc->stf->txstreams))
+		if (brcmu_rate_hwrs_filter_sort_validate(&new,
+							 &wlc->bandstate[bandunit]->hw_rateset,
+							 true, wlc->stf->txstreams))
 			goto good;
 	}
 
@@ -5610,7 +5609,7 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	/* for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
+	phy_rate = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
 	index = phy_rate & 0xf;
 
 	/* Find the SHM pointer to the rate table entry by looking in the
@@ -5984,7 +5983,7 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
 	 * transmitted first
 	 */
-	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
+	rate_signal = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
 	memset(plcp, 0, D11_PHY_HDR_LEN);
 	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
 
@@ -6084,7 +6083,7 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
 		phyctl1 = rspec_phytxbyte2(rspec);
 		/* set the upper byte of phyctl1 */
-		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
+		phyctl1 |= (brcmu_mcs_table[mcs].tx_phy_ctl3 << 8);
 	} else if (is_cck_rate(rspec) && !BRCMS_ISLCNPHY(wlc->band)
 		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
 		/*
@@ -6097,7 +6096,7 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 	} else {		/* legacy OFDM/CCK */
 		s16 phycfg;
 		/* get the phyctl byte from rate phycfg table */
-		phycfg = brcms_c_rate_legacy_phyctl(rspec2rate(rspec));
+		phycfg = brcmu_rate_legacy_phyctl(rspec2rate(rspec));
 		if (phycfg == -1) {
 			brcms_err(wlc->hw->d11core, "phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
@@ -6988,7 +6987,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 	plcp = p->data;
 
-	rspec = brcms_c_compute_rspec(rxh, plcp);
+	rspec = brcmu_compute_rspec(rxh, plcp);
 	if (is_mcs_rate(rspec)) {
 		rx_status->rate_idx = rspec & RSPEC_RATE_MASK;
 		rx_status->encoding = RX_ENC_HT;
@@ -7162,8 +7161,8 @@ brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 
 	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
-	brcms_c_rateset_copy(rs_dflt, &rs);
-	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+	brcmu_rateset_copy(rs_dflt, &rs);
+	brcmu_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
 	/*
 	 * walk the phy rate table and update MAC core SHM
@@ -7958,10 +7957,10 @@ brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
 		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
 		/* fill in hw_rateset */
-		brcms_c_rateset_filter(&wlc->band->defrateset,
-				   &wlc->band->hw_rateset, false,
-				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
+		brcmu_rateset_filter(&wlc->band->defrateset,
+				     &wlc->band->hw_rateset, false,
+				     BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
+				     (bool)(wlc->pub->_n_enab & SUPPORT_11N));
 	}
 
 	/*
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
index ac577c8e8..95ccc1177 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
@@ -25,7 +25,7 @@
  * Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate
  * value
  */
-const u8 rate_info[BRCM_MAXRATE + 1] = {
+const u8 brcmu_rate_info[BRCM_MAXRATE + 1] = {
 	/*  0     1     2     3     4     5     6     7     8     9 */
 /*   0 */ 0x00, 0x00, 0x0a, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00,
 /*  10 */ 0x00, 0x37, 0x8b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x8f, 0x00,
@@ -41,7 +41,7 @@ const u8 rate_info[BRCM_MAXRATE + 1] = {
 };
 
 /* rates are in units of Kbps */
-const struct brcms_mcs_info mcs_table[MCS_TABLE_SIZE] = {
+const struct brcms_mcs_info brcmu_mcs_table[MCS_TABLE_SIZE] = {
 	/* MCS  0: SS 1, MOD: BPSK,  CR 1/2 */
 	{6500, 13500, CEIL(6500 * 10, 9), CEIL(13500 * 10, 9), 0x00,
 	 BRCM_RATE_6M},
@@ -187,7 +187,7 @@ legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
 
 /* Hardware rates (also encodes default basic rates) */
 
-const struct brcms_c_rateset cck_ofdm_mimo_rates = {
+const struct brcms_c_rateset brcmu_cck_ofdm_mimo_rates = {
 	12,
 	/*  1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48, */
 	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -198,7 +198,7 @@ const struct brcms_c_rateset cck_ofdm_mimo_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset ofdm_mimo_rates = {
+const struct brcms_c_rateset brcmu_ofdm_mimo_rates = {
 	8,
 	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
@@ -228,7 +228,7 @@ static const struct brcms_c_rateset ofdm_40bw_mimo_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset cck_ofdm_rates = {
+const struct brcms_c_rateset brcmu_cck_ofdm_rates = {
 	12,
 	/*  1b,   2b, 5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,*/
 	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -239,7 +239,7 @@ const struct brcms_c_rateset cck_ofdm_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset gphy_legacy_rates = {
+const struct brcms_c_rateset brcmu_gphy_legacy_rates = {
 	4,
 	/*  1b,   2b,   5.5b, 11b Mbps */
 	{ 0x82, 0x84, 0x8b, 0x96},
@@ -248,7 +248,7 @@ const struct brcms_c_rateset gphy_legacy_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset ofdm_rates = {
+const struct brcms_c_rateset brcmu_ofdm_rates = {
 	8,
 	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
@@ -257,7 +257,7 @@ const struct brcms_c_rateset ofdm_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset cck_rates = {
+const struct brcms_c_rateset brcmu_cck_rates = {
 	4,
 	/*  1b,   2b,   5.5,  11 Mbps */
 	{ 0x82, 0x84, 0x0b, 0x16},
@@ -288,7 +288,7 @@ static inline u8 ofdm_phy2mac_rate(u8 rlpt)
 /* check if rateset is valid.
  * if check_brate is true, rateset without a basic rate is considered NOT valid.
  */
-static bool brcms_c_rateset_valid(struct brcms_c_rateset *rs, bool check_brate)
+static bool brcmu_rateset_valid(struct brcms_c_rateset *rs, bool check_brate)
 {
 	uint idx;
 
@@ -306,7 +306,7 @@ static bool brcms_c_rateset_valid(struct brcms_c_rateset *rs, bool check_brate)
 	return false;
 }
 
-void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams)
+void brcmu_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams)
 {
 	int i;
 	for (i = txstreams; i < MAX_STREAMS_SUPPORTED; i++)
@@ -318,9 +318,9 @@ void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams)
  * bit(s) preserved, and check if resulting rateset is valid.
 */
 bool
-brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
-				   const struct brcms_c_rateset *hw_rs,
-				   bool check_brate, u8 txstreams)
+brcmu_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
+				     const struct brcms_c_rateset *hw_rs,
+				     bool check_brate, u8 txstreams)
 {
 	u8 rateset[BRCM_MAXRATE + 1];
 	u8 r;
@@ -333,7 +333,7 @@ brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
 	for (i = 0; i < count; i++) {
 		/* mask off "basic rate" bit, BRCMS_RATE_FLAG */
 		r = (int)rs->rates[i] & BRCMS_RATE_MASK;
-		if ((r > BRCM_MAXRATE) || (rate_info[r] == 0))
+		if (r > BRCM_MAXRATE || brcmu_rate_info[r] == 0)
 			continue;
 		rateset[r] = rs->rates[i];	/* preserve basic bit! */
 	}
@@ -352,14 +352,14 @@ brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
 	for (i = 0; i < MCSSET_LEN; i++)
 		rs->mcs[i] = (rs->mcs[i] & hw_rs->mcs[i]);
 
-	if (brcms_c_rateset_valid(rs, check_brate))
+	if (brcmu_rateset_valid(rs, check_brate))
 		return true;
 	else
 		return false;
 }
 
 /* calculate the rate of a rx'd frame and return it as a ratespec */
-u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
+u32 brcmu_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 {
 	int phy_type;
 	u32 rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
@@ -408,8 +408,8 @@ u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 }
 
 /* copy rateset src to dst as-is (no masking or sorting) */
-void brcms_c_rateset_copy(const struct brcms_c_rateset *src,
-			  struct brcms_c_rateset *dst)
+void brcmu_rateset_copy(const struct brcms_c_rateset *src,
+			struct brcms_c_rateset *dst)
 {
 	memcpy(dst, src, sizeof(struct brcms_c_rateset));
 }
@@ -424,8 +424,8 @@ void brcms_c_rateset_copy(const struct brcms_c_rateset *src,
  * 'xmask' is the copy mask (typically 0x7f or 0xff).
  */
 void
-brcms_c_rateset_filter(struct brcms_c_rateset *src, struct brcms_c_rateset *dst,
-		       bool basic_only, u8 rates, uint xmask, bool mcsallow)
+brcmu_rateset_filter(struct brcms_c_rateset *src, struct brcms_c_rateset *dst,
+		     bool basic_only, u8 rates, uint xmask, bool mcsallow)
 {
 	uint i;
 	uint r;
@@ -450,17 +450,17 @@ brcms_c_rateset_filter(struct brcms_c_rateset *src, struct brcms_c_rateset *dst,
 	if (mcsallow && rates != BRCMS_RATES_CCK)
 		memcpy(&dst->mcs[0], &src->mcs[0], MCSSET_LEN);
 	else
-		brcms_c_rateset_mcs_clear(dst);
+		brcmu_rateset_mcs_clear(dst);
 }
 
 /* select rateset for a given phy_type and bandtype and filter it, sort it
  * and fill rs_tgt with result
  */
 void
-brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
-			const struct brcms_c_rateset *rs_hw,
-			uint phy_type, int bandtype, bool cck_only,
-			uint rate_mask, bool mcsallow, u8 bw, u8 txstreams)
+brcmu_rateset_default(struct brcms_c_rateset *rs_tgt,
+		      const struct brcms_c_rateset *rs_hw,
+		      uint phy_type, int bandtype, bool cck_only,
+		      uint rate_mask, bool mcsallow, u8 bw, u8 txstreams)
 {
 	const struct brcms_c_rateset *rs_dflt;
 	struct brcms_c_rateset rs_sel;
@@ -470,37 +470,37 @@ brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_SSN))) {
 		if (bandtype == BRCM_BAND_5G)
 			rs_dflt = (bw == BRCMS_20_MHZ ?
-				   &ofdm_mimo_rates : &ofdm_40bw_mimo_rates);
+				   &brcmu_ofdm_mimo_rates : &ofdm_40bw_mimo_rates);
 		else
 			rs_dflt = (bw == BRCMS_20_MHZ ?
-				   &cck_ofdm_mimo_rates :
+				   &brcmu_cck_ofdm_mimo_rates :
 				   &cck_ofdm_40bw_mimo_rates);
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_LP)) {
 		rs_dflt = (bandtype == BRCM_BAND_5G) ?
-			  &ofdm_rates : &cck_ofdm_rates;
+			  &brcmu_ofdm_rates : &brcmu_cck_ofdm_rates;
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_A)) {
-		rs_dflt = &ofdm_rates;
+		rs_dflt = &brcmu_ofdm_rates;
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_G)) {
-		rs_dflt = &cck_ofdm_rates;
+		rs_dflt = &brcmu_cck_ofdm_rates;
 	} else {
 		/* should not happen, error condition */
-		rs_dflt = &cck_rates;	/* force cck */
+		rs_dflt = &brcmu_cck_rates;	/* force cck */
 	}
 
 	/* if hw rateset is not supplied, assign selected rateset to it */
 	if (!rs_hw)
 		rs_hw = rs_dflt;
 
-	brcms_c_rateset_copy(rs_dflt, &rs_sel);
-	brcms_c_rateset_mcs_upd(&rs_sel, txstreams);
-	brcms_c_rateset_filter(&rs_sel, rs_tgt, false,
-			   cck_only ? BRCMS_RATES_CCK : BRCMS_RATES_CCK_OFDM,
-			   rate_mask, mcsallow);
-	brcms_c_rate_hwrs_filter_sort_validate(rs_tgt, rs_hw, false,
-					   mcsallow ? txstreams : 1);
+	brcmu_rateset_copy(rs_dflt, &rs_sel);
+	brcmu_rateset_mcs_upd(&rs_sel, txstreams);
+	brcmu_rateset_filter(&rs_sel, rs_tgt, false,
+			     cck_only ? BRCMS_RATES_CCK : BRCMS_RATES_CCK_OFDM,
+			     rate_mask, mcsallow);
+	brcmu_rate_hwrs_filter_sort_validate(rs_tgt, rs_hw, false,
+					     mcsallow ? txstreams : 1);
 }
 
-s16 brcms_c_rate_legacy_phyctl(uint rate)
+s16 brcmu_rate_legacy_phyctl(uint rate)
 {
 	uint i;
 	for (i = 0; i < LEGACY_PHYCFG_TABLE_SIZE; i++)
@@ -510,21 +510,21 @@ s16 brcms_c_rate_legacy_phyctl(uint rate)
 	return -1;
 }
 
-void brcms_c_rateset_mcs_clear(struct brcms_c_rateset *rateset)
+void brcmu_rateset_mcs_clear(struct brcms_c_rateset *rateset)
 {
 	uint i;
 	for (i = 0; i < MCSSET_LEN; i++)
 		rateset->mcs[i] = 0;
 }
 
-void brcms_c_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams)
+void brcmu_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams)
 {
-	memcpy(&rateset->mcs[0], &cck_ofdm_mimo_rates.mcs[0], MCSSET_LEN);
-	brcms_c_rateset_mcs_upd(rateset, txstreams);
+	memcpy(&rateset->mcs[0], &brcmu_cck_ofdm_mimo_rates.mcs[0], MCSSET_LEN);
+	brcmu_rateset_mcs_upd(rateset, txstreams);
 }
 
 /* Based on bandwidth passed, allow/disallow MCS 32 in the rateset */
-void brcms_c_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw)
+void brcmu_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw)
 {
 	if (bw == BRCMS_40_MHZ)
 		setbit(rateset->mcs, 32);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
index 7c1d43323..e20913bdf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
@@ -22,13 +22,13 @@
 #include "pub.h"
 #include "phy_hal.h"
 
-extern const u8 rate_info[];
-extern const struct brcms_c_rateset cck_ofdm_mimo_rates;
-extern const struct brcms_c_rateset ofdm_mimo_rates;
-extern const struct brcms_c_rateset cck_ofdm_rates;
-extern const struct brcms_c_rateset ofdm_rates;
-extern const struct brcms_c_rateset cck_rates;
-extern const struct brcms_c_rateset gphy_legacy_rates;
+extern const u8 brcmu_rate_info[];
+extern const struct brcms_c_rateset brcmu_cck_ofdm_mimo_rates;
+extern const struct brcms_c_rateset brcmu_ofdm_mimo_rates;
+extern const struct brcms_c_rateset brcmu_cck_ofdm_rates;
+extern const struct brcms_c_rateset brcmu_ofdm_rates;
+extern const struct brcms_c_rateset brcmu_cck_rates;
+extern const struct brcms_c_rateset brcmu_gphy_legacy_rates;
 extern const struct brcms_c_rateset rate_limit_1_2;
 
 struct brcms_mcs_info {
@@ -48,7 +48,7 @@ struct brcms_mcs_info {
 
 #define BRCMS_MAXMCS	32	/* max valid mcs index */
 #define MCS_TABLE_SIZE	33	/* Number of mcs entries in the table */
-extern const struct brcms_mcs_info mcs_table[];
+extern const struct brcms_mcs_info brcmu_mcs_table[];
 
 #define MCS_TXS_MASK	0xc0	/* num tx streams - 1 bit mask */
 #define MCS_TXS_SHIFT	6	/* num tx streams - 1 bit shift */
@@ -56,23 +56,23 @@ extern const struct brcms_mcs_info mcs_table[];
 /* returns num tx streams - 1 */
 static inline u8 mcs_2_txstreams(u8 mcs)
 {
-	return (mcs_table[mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT;
+	return (brcmu_mcs_table[mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT;
 }
 
 static inline uint mcs_2_rate(u8 mcs, bool is40, bool sgi)
 {
 	if (sgi) {
 		if (is40)
-			return mcs_table[mcs].phy_rate_40_sgi;
-		return mcs_table[mcs].phy_rate_20_sgi;
+			return brcmu_mcs_table[mcs].phy_rate_40_sgi;
+		return brcmu_mcs_table[mcs].phy_rate_20_sgi;
 	}
 	if (is40)
-		return mcs_table[mcs].phy_rate_40;
+		return brcmu_mcs_table[mcs].phy_rate_40;
 
-	return mcs_table[mcs].phy_rate_20;
+	return brcmu_mcs_table[mcs].phy_rate_20;
 }
 
-/* Macro to use the rate_info table */
+/* Macro to use the brcmu_rate_info table */
 #define	BRCMS_RATE_MASK_FULL 0xff /* Rate value mask with basic rate flag */
 
 /*
@@ -176,7 +176,7 @@ static inline bool is_mcs_rate(u32 ratespec)
 static inline bool is_ofdm_rate(u32 ratespec)
 {
 	return !is_mcs_rate(ratespec) &&
-	       (rate_info[ratespec & RSPEC_RATE_MASK] & BRCMS_RATE_FLAG);
+	       (brcmu_rate_info[ratespec & RSPEC_RATE_MASK] & BRCMS_RATE_FLAG);
 }
 
 static inline bool is_cck_rate(u32 ratespec)
@@ -203,37 +203,37 @@ static inline u8 cck_phy2mac_rate(u8 signal)
 	return signal/5;
 }
 
-/* Rates specified in brcms_c_rateset_filter() */
+/* Rates specified in brcmu_rateset_filter() */
 #define BRCMS_RATES_CCK_OFDM	0
 #define BRCMS_RATES_CCK		1
 #define BRCMS_RATES_OFDM		2
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate
  * rateset */
-bool brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
-					    const struct brcms_c_rateset *hw_rs,
-					    bool check_brate, u8 txstreams);
+bool brcmu_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
+					  const struct brcms_c_rateset *hw_rs,
+					  bool check_brate, u8 txstreams);
 /* copy rateset src to dst as-is (no masking or sorting) */
-void brcms_c_rateset_copy(const struct brcms_c_rateset *src,
-			  struct brcms_c_rateset *dst);
+void brcmu_rateset_copy(const struct brcms_c_rateset *src,
+			struct brcms_c_rateset *dst);
 
 /* would be nice to have these documented ... */
-u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
+u32 brcmu_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
 
-void brcms_c_rateset_filter(struct brcms_c_rateset *src,
-			    struct brcms_c_rateset *dst, bool basic_only,
-			    u8 rates, uint xmask, bool mcsallow);
+void brcmu_rateset_filter(struct brcms_c_rateset *src,
+			  struct brcms_c_rateset *dst, bool basic_only,
+			  u8 rates, uint xmask, bool mcsallow);
 
-void brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
-			     const struct brcms_c_rateset *rs_hw, uint phy_type,
-			     int bandtype, bool cck_only, uint rate_mask,
-			     bool mcsallow, u8 bw, u8 txstreams);
+void brcmu_rateset_default(struct brcms_c_rateset *rs_tgt,
+			   const struct brcms_c_rateset *rs_hw, uint phy_type,
+			   int bandtype, bool cck_only, uint rate_mask,
+			   bool mcsallow, u8 bw, u8 txstreams);
 
-s16 brcms_c_rate_legacy_phyctl(uint rate);
+s16 brcmu_rate_legacy_phyctl(uint rate);
 
-void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams);
-void brcms_c_rateset_mcs_clear(struct brcms_c_rateset *rateset);
-void brcms_c_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams);
-void brcms_c_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw);
+void brcmu_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams);
+void brcmu_rateset_mcs_clear(struct brcms_c_rateset *rateset);
+void brcmu_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams);
+void brcmu_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw);
 
 #endif				/* _BRCM_RATE_H_ */
-- 
2.53.0

