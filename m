Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993036;
	b=VPrzdUm9DZF+/7VkNz51EnzmBhkutYkKhgoKc3OjamKmoheTdKV2CyIGGZFHapSvMA7y
	 NhoKn3twG3kXSj1LSlNBZEOKLquIV/U4GVm7Z9K2yLVsFV9WdjPx22shCL+/+ccOp3L2C
	 UlcD6I8gGfjgZgDnT/4DvcUlTTt4Muh1qcx9AEbxBfd6j+trxOkLB+IfmX//uTCsqwGAU
	 AXLXKyFh2rk/Z//EM62HOWpDwe0cSPEV6Z45Rd/KkHiSPEKSBRxxXmYRvSrIvcbEH3z4O
	 cJzbVzndXPVTe1nrjjyiAppZrKhLsdN7rIUrLdsj3gujyQER8CVKs4kAfvcH3Gm/btw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0DF8+cxGhU7HksWZE0121VHDU90nejfZvExIM/M10UE=;
	b=4tAHLSceFPa2Nif/MNlt5JP2knjSnAJya1TP+8QSwWyWpCyfjFy+ORPKXqFL4M5RiIoW
	 bJXRWM8EKm+9FA2XqrLQZTSc5Uh2EYvtJ1u4fRLgceS4vfmDHLOvx8TKUPK8e9HCcA4fq
	 6JWM3y80yywtFQQX5QiN1ngceY8weFXCzpjE59jYxfy6ZRh6ZtfZAVkGf34tG61ypYjGL
	 j4fJ/kfURc92O5z7ja8PbM7nEevo0mfBex8J3BI5cIWiULHxxUy/vu99hhQamrTb0MLiN
	 F4v6ATo+yuZ9kro1CPYk5LDAienSnW2HvoXdEEd3G4fZX2Coe7I4fy2dxIKCWucVbuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="briXFt/c";
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93EC606A31F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E93EC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=briXFt/c
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a058f74a54so783779b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993034; x=1793597834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0DF8+cxGhU7HksWZE0121VHDU90nejfZvExIM/M10UE=;
        b=briXFt/ctlv/aiPw7NSl4NZ4kI5ZQmiPsgF1KZq5N0xeW5dmkwOPrkXS1HAL8cu6Vp
         mhkeivY1U6xkDF2vcgozYZ9uHduU1Q+JaeOG60OzQbNXTeXfODSiClA6AFIZbSDqEF+j
         dH9hRgEO7b7z4ASNI5pbV2+JXzd2Yzs+G2rAzTsrxb1k3O5hrXJomPkrAT1zzwGMNom4
         XWjKAjh128BmcnR5nujIBG9WHVc6t/bQEac3RGA3R9en+ZVy6miaM7pcUWscTJyhTUlP
         YwR9CLC9eWpfHcb1VD+iiJs+1P5CIgeKQL1lt2sNtLvZy9pT9w2qsfl5x5JOVUn9SaFd
         4+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993034; x=1793597834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0DF8+cxGhU7HksWZE0121VHDU90nejfZvExIM/M10UE=;
        b=WoDRTWX1w3tLK2jI3n92KVdk5KOwaU6pHYBe/vEI64l0OCKqA2ThNQ9WDG7zmyRaZb
         goChooUXkoepgBQ1KK6grg/kzw5ACLquSAKJN08IBOgb6XyokoJuqSyiA4JYIlW336zb
         dA24r9b200Q2P3kBTMVxqe9s47y8vIcezVBrHXcYFxkd3hOBp7cNmmYNTkWoQEVcRJ3z
         iMBGeFyZ2lencdEiUzZlKYPadkWJkMf2Kfi7FZFdOeWDuzUaJk4II9BfbeRnBo1iC69B
         dK1LfIbBQ3uqQaT7wCEkrMP4M59HbMn7ixv+XG85aiOWjFoEY/V4wrPz1b7FDs4rWrbe
         5ROg==
X-Gm-Message-State: AFq9FYICugPT+48xFrJDRMqKJY33Gvt3/x1+QgDMAvoUlPF5cpjCLmQd
	sSt7RA+jdv4nis6gPQMIa1yEdfPnLSEyeWuOodAqpaIetOXOf/MqIAoTEdnp4FrE1OJwyg==
X-Gm-Gg: AYBFou3ChpguYC8jWaBEP/hpN5o0nMkS7dMmEN2CkkC+9jXWCkhmmf4SOqZ4Z3q0Ts5
	393pDHNu2aMctxU+DgdjMq/gvqwDljhzYcVsJ0u/Jgd7wuHUK/JP9ykk/2J23VfIofX7FflnkDz
	BdrxgdlJ/qhFu/qwl8XzP9zXR2W4wxuekHb7hIpRwi8/iCYmFfr8pOBgziAZEpKdLr+x181EV4v
	MRLypLAqaL2BGYJlFVrEzPonnJR9yVKy0UR1uBxesc1b0I+W3Ln/j0sQeHMMPh1ayN2ASa5U2qE
	c6hSOYFCP25Ii+wPMwJMjme4dVkjTuzeesWfxc0VUGiFDHY6t7T7P1J0bisDcy8YeJOHMXRitD9
	iHWcL+aWD+qVaN15kun4ZNO7JR0heWfNn1gDDUBHwqPeFkVJQgBxYxVUk8MHmtStgaZXqekdT3B
	e58WIu78JbX+a6+iE7mOaNIWVDt7NWTfH42UcZJEsqHqj8ZnBqCIai23oI1uUOORSpLzivS338T
	AYISNFcH2J3p1HLwGPR5VkDqXOk3j96xPmcgA21OmvhrpOOZ08ILGkc44gLhKHbNgjMuhjzV03u
	n9BkYagjuw/COFksenkO3guhTA==
X-Received: by 2002:a05:6a00:4144:b0:8a0:4502:195e with SMTP id d2e1a72fcca58-8a367a3bb5fmr4401516b3a.60.1792993034125;
        Sun, 25 Oct 2026 22:37:14 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:13 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 07/17] wifi: brcmsmac: move the PLCP and frame timing helpers to rate.c
Date: Mon, 26 Oct 2026 13:36:13 +0800
Message-ID: <20261026053633.361454-8-ragulbaby@gmail.com>
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

Move the functions computing PLCP headers, frame and response times,
RTS/CTS durations, L-SIG lengths and PHY control words, with the basic
rate lookup they use, from main.c to rate.c, so that they move to
brcmutil with the rate helpers. brcmu_rate_legacy_phyctl() is then only
used in rate.c and becomes static.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/main.c        | 487 ------------------
 .../broadcom/brcm80211/brcmsmac/main.h        |  13 -
 .../broadcom/brcm80211/brcmsmac/rate.c        | 471 ++++++++++++++++-
 .../broadcom/brcm80211/brcmsmac/rate.h        |  50 +-
 4 files changed, 518 insertions(+), 503 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 1725f0634..f7d9480cc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -81,31 +81,13 @@
 #define EDCF_TXOP2USEC(txop)		((txop) << 5)
 #define EDCF_ECW2CW(exp)		((1 << (exp)) - 1)
 
-#define APHY_SYMBOL_TIME		4
-#define APHY_PREAMBLE_TIME		16
-#define APHY_SIGNAL_TIME		4
-#define APHY_SIFS_TIME			16
-#define APHY_SERVICE_NBITS		16
-#define APHY_TAIL_NBITS			6
-#define BPHY_SIFS_TIME			10
-#define BPHY_PLCP_SHORT_TIME		96
-
-#define PREN_PREAMBLE			24
-#define PREN_MM_EXT			12
-#define PREN_PREAMBLE_EXT		4
-
 #define DOT11_MAC_HDR_LEN		24
-#define DOT11_ACK_LEN			10
-#define DOT11_BA_LEN			4
-#define DOT11_OFDM_SIGNAL_EXTENSION	6
 #define DOT11_MIN_FRAG_LEN		256
 #define DOT11_RTS_LEN			16
 #define DOT11_CTS_LEN			10
-#define DOT11_BA_BITMAP_LEN		128
 #define DOT11_MAXNUMFRAGS		16
 #define DOT11_MAX_FRAG_LEN		2346
 
-#define BPHY_PLCP_TIME			192
 #define RIFS_11N_TIME			2
 
 /* length of the BCN template area */
@@ -348,15 +330,6 @@ static u8 brcms_fifo_to_ac(u8 fifo)
 	return fifo_to_ac_mapping[fifo];
 }
 
-/* Find basic rate for a given rate */
-static u8 brcmu_basic_rate(const u8 *basic_rate, u32 rspec)
-{
-	if (is_mcs_rate(rspec))
-		return basic_rate[brcmu_mcs_table[rspec & RSPEC_RATE_MASK]
-		       .leg_ofdm];
-	return basic_rate[rspec & RSPEC_RATE_MASK];
-}
-
 static u16 frametype(u32 rspec, u8 mimoframe)
 {
 	if (is_mcs_rate(rspec))
@@ -364,12 +337,6 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 	return is_cck_rate(rspec) ? FT_CCK : FT_OFDM;
 }
 
-/* currently the best mechanism for determining SIFS is the band in use */
-static u16 brcmu_get_sifs(int bandtype)
-{
-	return bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : BPHY_SIFS_TIME;
-}
-
 /*
  * Detect Card removed.
  * Even checking an sbconfig register read will not false trigger when the core
@@ -571,74 +538,6 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 	}
 }
 
-/*
- * calculate frame duration of a given rate and length, return
- * time in usec unit
- */
-static uint brcmu_calc_frame_time(int bandtype, u32 ratespec,
-				  u8 preamble_type, uint mac_len)
-{
-	uint nsyms, dur = 0, Ndps, kNdps;
-	uint rate = rspec2rate(ratespec);
-
-	if (rate == 0) {
-		pr_err("WAR: using rate of 1 mbps\n");
-		rate = BRCM_RATE_1M;
-	}
-
-	if (is_mcs_rate(ratespec)) {
-		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
-
-		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
-		if (preamble_type == BRCMS_MM_PREAMBLE)
-			dur += PREN_MM_EXT;
-		/* 1000Ndbps = kbps * 4 */
-		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
-				   rspec_issgi(ratespec)) * 4;
-
-		if (rspec_stc(ratespec) == 0)
-			nsyms =
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, kNdps);
-		else
-			/* STBC needs to have even number of symbols */
-			nsyms =
-			    2 *
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
-
-		dur += APHY_SYMBOL_TIME * nsyms;
-		if (bandtype == BRCM_BAND_2G)
-			dur += DOT11_OFDM_SIGNAL_EXTENSION;
-	} else if (is_ofdm_rate(rate)) {
-		dur = APHY_PREAMBLE_TIME;
-		dur += APHY_SIGNAL_TIME;
-		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
-		Ndps = rate * 2;
-		/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
-		nsyms =
-		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
-			 Ndps);
-		dur += APHY_SYMBOL_TIME * nsyms;
-		if (bandtype == BRCM_BAND_2G)
-			dur += DOT11_OFDM_SIGNAL_EXTENSION;
-	} else {
-		/*
-		 * calc # bits * 2 so factor of 2 in rate (1/2 mbps)
-		 * will divide out
-		 */
-		mac_len = mac_len * 8 * 2;
-		/* calc ceiling of bits/rate = microseconds of air time */
-		dur = (mac_len + rate - 1) / rate;
-		if (preamble_type & BRCMS_SHORT_PREAMBLE)
-			dur += BPHY_PLCP_SHORT_TIME;
-		else
-			dur += BPHY_PLCP_TIME;
-	}
-	return dur;
-}
-
 static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 				const struct d11init *inits)
 {
@@ -3366,100 +3265,6 @@ brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 			      wlc->stf->txstreams);
 }
 
-/* derive basic_rate[] table 'br' from 'rateset' */
-static void brcmu_rate_lookup_init(u8 *br,
-				   const struct brcms_c_rateset *hw_rateset,
-				   struct brcms_c_rateset *rateset)
-{
-	u8 rate;
-	u8 mandatory;
-	u8 cck_basic = 0;
-	u8 ofdm_basic = 0;
-	uint i;
-
-	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
-	memset(br, 0, BRCM_MAXRATE + 1);
-
-	/* For each basic rate in the rates list, make an entry in the
-	 * best basic lookup.
-	 */
-	for (i = 0; i < rateset->count; i++) {
-		/* only make an entry for a basic rate */
-		if (!(rateset->rates[i] & BRCMS_RATE_FLAG))
-			continue;
-
-		/* mask off basic bit */
-		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
-
-		if (rate > BRCM_MAXRATE) {
-			pr_err("%s: invalid rate 0x%X in rate set\n", __func__,
-			       rateset->rates[i]);
-			continue;
-		}
-
-		br[rate] = rate;
-	}
-
-	/* The rate lookup table now has non-zero entries for each
-	 * basic rate, equal to the basic rate: br[basicN] = basicN
-	 *
-	 * To look up the best basic rate corresponding to any
-	 * particular rate, code can use the basic_rate table
-	 * like this
-	 *
-	 * basic_rate = wlc->band->basic_rate[tx_rate]
-	 *
-	 * Make sure there is a best basic rate entry for
-	 * every rate by walking up the table from low rates
-	 * to high, filling in holes in the lookup table
-	 */
-
-	for (i = 0; i < hw_rateset->count; i++) {
-		rate = hw_rateset->rates[i];
-
-		if (br[rate] != 0) {
-			/* This rate is a basic rate.
-			 * Keep track of the best basic rate so far by
-			 * modulation type.
-			 */
-			if (is_ofdm_rate(rate))
-				ofdm_basic = rate;
-			else
-				cck_basic = rate;
-
-			continue;
-		}
-
-		/* This rate is not a basic rate so figure out the
-		 * best basic rate less than this rate and fill in
-		 * the hole in the table
-		 */
-
-		br[rate] = is_ofdm_rate(rate) ? ofdm_basic : cck_basic;
-
-		if (br[rate] != 0)
-			continue;
-
-		if (is_ofdm_rate(rate)) {
-			/*
-			 * In 11g and 11a, the OFDM mandatory rates
-			 * are 6, 12, and 24 Mbps
-			 */
-			if (rate >= BRCM_RATE_24M)
-				mandatory = BRCM_RATE_24M;
-			else if (rate >= BRCM_RATE_12M)
-				mandatory = BRCM_RATE_12M;
-			else
-				mandatory = BRCM_RATE_6M;
-		} else {
-			/* In 11b, all CCK rates are mandatory 1 - 11 Mbps */
-			mandatory = rate;
-		}
-
-		br[rate] = mandatory;
-	}
-}
-
 static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 				     u16 chanspec)
 {
@@ -5638,48 +5443,6 @@ bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_bss_cfg *bsscfg,
 	return frameid;
 }
 
-static uint
-brcmu_calc_ack_time(int bandtype, const u8 *basic_rate, u32 rspec,
-		    u8 preamble_type)
-{
-	uint dur = 0;
-
-	/*
-	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
-	 * is less than or equal to the rate of the immediately previous
-	 * frame in the FES
-	 */
-	rspec = brcmu_basic_rate(basic_rate, rspec);
-	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
-	dur =
-	    brcmu_calc_frame_time(bandtype, rspec, preamble_type,
-				  (DOT11_ACK_LEN + FCS_LEN));
-	return dur;
-}
-
-static uint
-brcmu_calc_cts_time(int bandtype, const u8 *basic_rate, u32 rspec,
-		    u8 preamble_type)
-{
-	return brcmu_calc_ack_time(bandtype, basic_rate, rspec, preamble_type);
-}
-
-static uint
-brcmu_calc_ba_time(int bandtype, const u8 *basic_rate, u32 rspec,
-		   u8 preamble_type)
-{
-	/*
-	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
-	 * is less than or equal to the rate of the immediately previous
-	 * frame in the FES
-	 */
-	rspec = brcmu_basic_rate(basic_rate, rspec);
-	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
-	return brcmu_calc_frame_time(bandtype, rspec, preamble_type,
-				     (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
-				      FCS_LEN));
-}
-
 /* brcms_c_compute_frame_dur()
  *
  * Calculate the 802.11 MAC header DUR field for MPDU
@@ -5904,207 +5667,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	return rate;
 }
 
-/*
- * Compute PLCP, but only requires actual rate and length of pkt.
- * Rate is given in the driver standard multiple of 500 kbps.
- * le is set for 11 Mbps rate if necessary.
- * Broken out for PRQ.
- */
-
-static void brcmu_cck_plcp_set(int rate_500, uint length, u8 *plcp)
-{
-	u16 usec = 0;
-	u8 le = 0;
-
-	switch (rate_500) {
-	case BRCM_RATE_1M:
-		usec = length << 3;
-		break;
-	case BRCM_RATE_2M:
-		usec = length << 2;
-		break;
-	case BRCM_RATE_5M5:
-		usec = (length << 4) / 11;
-		if ((length << 4) - (usec * 11) > 0)
-			usec++;
-		break;
-	case BRCM_RATE_11M:
-		usec = (length << 3) / 11;
-		if ((length << 3) - (usec * 11) > 0) {
-			usec++;
-			if ((usec * 11) - (length << 3) >= 8)
-				le = D11B_PLCP_SIGNAL_LE;
-		}
-		break;
-
-	default:
-		pr_err("%s: unsupported rate %d\n", __func__, rate_500);
-		rate_500 = BRCM_RATE_1M;
-		usec = length << 3;
-		break;
-	}
-	/* PLCP signal byte */
-	plcp[0] = rate_500 * 5;	/* r (500kbps) * 5 == r (100kbps) */
-	/* PLCP service byte */
-	plcp[1] = (u8) (le | D11B_PLCP_SIGNAL_LOCKED);
-	/* PLCP length u16, little endian */
-	plcp[2] = usec & 0xff;
-	plcp[3] = (usec >> 8) & 0xff;
-	/* PLCP CRC16 */
-	plcp[4] = 0;
-	plcp[5] = 0;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcmu_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
-{
-	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
-	plcp[0] = mcs;
-	if (rspec_is40mhz(rspec) || (mcs == 32))
-		plcp[0] |= MIMO_PLCP_40MHZ;
-	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
-	plcp[3] = rspec_mimoplcp3(rspec); /* rspec already holds this byte */
-	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
-	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
-	plcp[5] = 0;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void
-brcmu_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
-{
-	u8 rate_signal;
-	u32 tmp = 0;
-	int rate = rspec2rate(rspec);
-
-	/*
-	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
-	 * transmitted first
-	 */
-	rate_signal = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
-	memset(plcp, 0, D11_PHY_HDR_LEN);
-	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
-
-	tmp = (length & 0xfff) << 5;
-	plcp[2] |= (tmp >> 16) & 0xff;
-	plcp[1] |= (tmp >> 8) & 0xff;
-	plcp[0] |= tmp & 0xff;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcmu_compute_cck_plcp(u32 rspec, uint length, u8 *plcp)
-{
-	int rate = rspec2rate(rspec);
-
-	brcmu_cck_plcp_set(rate, length, plcp);
-}
-
-static void
-brcmu_compute_plcp(u32 rspec, uint length, u8 *plcp)
-{
-	if (is_mcs_rate(rspec))
-		brcmu_compute_mimo_plcp(rspec, length, plcp);
-	else if (is_ofdm_rate(rspec))
-		brcmu_compute_ofdm_plcp(rspec, length, plcp);
-	else
-		brcmu_compute_cck_plcp(rspec, length, plcp);
-}
-
-/* brcmu_compute_rtscts_dur()
- *
- * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
- * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
- * DUR for CTS-TO-SELF w/ frame    = 2 SIFS         + next frame time + 1 ACK
- *
- * cts			cts-to-self or rts/cts
- * rts_rate		rts or cts rate in unit of 500kbps
- * rate			next MPDU rate in unit of 500kbps
- * frame_len		next MPDU frame length in bytes
- */
-u16
-brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
-			 u32 rts_rate,
-			 u32 frame_rate, u8 rts_preamble_type,
-			 u8 frame_preamble_type, uint frame_len, bool ba)
-{
-	u16 dur, sifs;
-
-	sifs = brcmu_get_sifs(bandtype);
-
-	if (!cts_only) {
-		/* RTS/CTS */
-		dur = 3 * sifs;
-		dur +=
-		    (u16)brcmu_calc_cts_time(bandtype, basic_rate, rts_rate,
-					     rts_preamble_type);
-	} else {
-		/* CTS-TO-SELF */
-		dur = 2 * sifs;
-	}
-
-	dur +=
-	    (u16)brcmu_calc_frame_time(bandtype, frame_rate,
-				       frame_preamble_type, frame_len);
-	if (ba)
-		dur +=
-		    (u16)brcmu_calc_ba_time(bandtype, basic_rate, frame_rate,
-					    BRCMS_SHORT_PREAMBLE);
-	else
-		dur +=
-		    (u16)brcmu_calc_ack_time(bandtype, basic_rate, frame_rate,
-					     frame_preamble_type);
-	return dur;
-}
-
-static u16 brcmu_phytxctl1_calc(u16 phytype, u32 rspec)
-{
-	u16 phyctl1 = 0;
-	u16 bw;
-
-	if (phytype == PHY_TYPE_LCN) {
-		bw = PHY_TXC1_BW_20MHZ;
-	} else {
-		bw = rspec_get_bw(rspec);
-		/* 10Mhz is not supported yet */
-		if (bw < PHY_TXC1_BW_20MHZ) {
-			pr_err("%s: bw %d is not supported yet, set to 20L\n",
-			       __func__, bw);
-			bw = PHY_TXC1_BW_20MHZ;
-		}
-	}
-
-	if (is_mcs_rate(rspec)) {
-		uint mcs = rspec & RSPEC_RATE_MASK;
-
-		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
-		phyctl1 = rspec_phytxbyte2(rspec);
-		/* set the upper byte of phyctl1 */
-		phyctl1 |= (brcmu_mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (is_cck_rate(rspec) && phytype != PHY_TYPE_LCN &&
-		   phytype != PHY_TYPE_SSN) {
-		/*
-		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
-		 * Data Rate. Eventually MIMOPHY would also be converted to
-		 * this format
-		 */
-		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
-		phyctl1 = (bw | (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
-	} else {		/* legacy OFDM/CCK */
-		s16 phycfg;
-		/* get the phyctl byte from rate phycfg table */
-		phycfg = brcmu_rate_legacy_phyctl(rspec2rate(rspec));
-		if (phycfg == -1) {
-			pr_err("%s: wrong legacy OFDM/CCK rate\n", __func__);
-			phycfg = 0;
-		}
-		/* set the upper byte of phyctl1 */
-		phyctl1 =
-		    (bw | (phycfg << 8) |
-		     (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
-	}
-	return phyctl1;
-}
-
 /*
  * Add struct d11txh, struct cck_phy_hdr.
  *
@@ -7105,55 +6667,6 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 }
 
-/* calculate frame duration for Mixed-mode L-SIG spoofing, return
- * number of bytes goes in the length field
- *
- * Formula given by HT PHY Spec v 1.13
- *   len = 3(nsyms + nstream + 3) - 3
- */
-u16
-brcmu_calc_lsig_len(u32 ratespec, uint mac_len)
-{
-	uint nsyms, len = 0, kNdps;
-
-	if (is_mcs_rate(ratespec)) {
-		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
-				  rspec_stc(ratespec);
-
-		/*
-		 * the payload duration calculation matches that
-		 * of regular ofdm
-		 */
-		/* 1000Ndbps = kbps * 4, at the long-GI rate */
-		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec), false) * 4;
-
-		if (rspec_stc(ratespec) == 0)
-			nsyms =
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, kNdps);
-		else
-			/* STBC needs to have even number of symbols */
-			nsyms =
-			    2 *
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
-
-		/* short-GI symbols (3.6 us) in 4 us units, rounded up */
-		if (rspec_issgi(ratespec))
-			nsyms = CEIL(nsyms * 9, 10);
-		/* (+3) account for HT-SIG(2) and HT-STF(1) */
-		nsyms += (tot_streams + 3);
-		/*
-		 * 3 bytes/symbol @ legacy 6Mbps rate
-		 * (-3) excluding service bits and tail bits
-		 */
-		len = (3 * nsyms) - 3;
-	}
-
-	return (u16) len;
-}
-
 static void
 brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index 347d9a4a8..c0ab15762 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -78,14 +78,6 @@
 #define BRCMS_SHORTSLOT_OFF	0  /* Turn off short slot */
 #define BRCMS_SHORTSLOT_ON	1  /* Turn on short slot */
 
-/* value for short/long and mixmode/greenfield preamble */
-#define BRCMS_LONG_PREAMBLE	(0)
-#define BRCMS_SHORT_PREAMBLE	(1 << 0)
-#define BRCMS_GF_PREAMBLE		(1 << 1)
-#define BRCMS_MM_PREAMBLE		(1 << 2)
-#define BRCMS_IS_MIMO_PREAMBLE(_pre) (((_pre) == BRCMS_GF_PREAMBLE) || \
-				      ((_pre) == BRCMS_MM_PREAMBLE))
-
 /* promote boardrev */
 #define BOARDREV_PROMOTABLE	0xFF	/* from */
 #define BOARDREV_PROMOTED	1	/* to */
@@ -614,13 +606,8 @@ int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 
 int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
-u16 brcmu_calc_lsig_len(u32 ratespec, uint mac_len);
 u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 			       bool use_rspec, u16 mimo_ctlchbw);
-u16 brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
-			     u32 rts_rate, u32 frame_rate,
-			     u8 rts_preamble_type, u8 frame_preamble_type,
-			     uint frame_len, bool ba);
 void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			    struct ieee80211_sta *sta, void (*dma_callback_fn));
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
index 95ccc1177..1c0259139 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
@@ -14,6 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 
@@ -21,6 +23,10 @@
 #include "pub.h"
 #include "rate.h"
 
+#define DOT11_ACK_LEN			10
+#define DOT11_BA_LEN			4
+#define DOT11_BA_BITMAP_LEN		128
+
 /*
  * Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate
  * value
@@ -500,7 +506,7 @@ brcmu_rateset_default(struct brcms_c_rateset *rs_tgt,
 					     mcsallow ? txstreams : 1);
 }
 
-s16 brcmu_rate_legacy_phyctl(uint rate)
+static s16 brcmu_rate_legacy_phyctl(uint rate)
 {
 	uint i;
 	for (i = 0; i < LEGACY_PHYCFG_TABLE_SIZE; i++)
@@ -531,3 +537,466 @@ void brcmu_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw)
 	else
 		clrbit(rateset->mcs, 32);
 }
+
+/* Find basic rate for a given rate */
+u8 brcmu_basic_rate(const u8 *basic_rate, u32 rspec)
+{
+	if (is_mcs_rate(rspec))
+		return basic_rate[brcmu_mcs_table[rspec & RSPEC_RATE_MASK]
+		       .leg_ofdm];
+	return basic_rate[rspec & RSPEC_RATE_MASK];
+}
+
+/*
+ * calculate frame duration of a given rate and length, return
+ * time in usec unit
+ */
+uint brcmu_calc_frame_time(int bandtype, u32 ratespec,
+			   u8 preamble_type, uint mac_len)
+{
+	uint nsyms, dur = 0, Ndps, kNdps;
+	uint rate = rspec2rate(ratespec);
+
+	if (rate == 0) {
+		pr_err("WAR: using rate of 1 mbps\n");
+		rate = BRCM_RATE_1M;
+	}
+
+	if (is_mcs_rate(ratespec)) {
+		uint mcs = ratespec & RSPEC_RATE_MASK;
+		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
+
+		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
+		if (preamble_type == BRCMS_MM_PREAMBLE)
+			dur += PREN_MM_EXT;
+		/* 1000Ndbps = kbps * 4 */
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
+
+		if (rspec_stc(ratespec) == 0)
+			nsyms =
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, kNdps);
+		else
+			/* STBC needs to have even number of symbols */
+			nsyms =
+			    2 *
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
+
+		dur += APHY_SYMBOL_TIME * nsyms;
+		if (bandtype == BRCM_BAND_2G)
+			dur += DOT11_OFDM_SIGNAL_EXTENSION;
+	} else if (is_ofdm_rate(rate)) {
+		dur = APHY_PREAMBLE_TIME;
+		dur += APHY_SIGNAL_TIME;
+		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
+		Ndps = rate * 2;
+		/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
+		nsyms =
+		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
+			 Ndps);
+		dur += APHY_SYMBOL_TIME * nsyms;
+		if (bandtype == BRCM_BAND_2G)
+			dur += DOT11_OFDM_SIGNAL_EXTENSION;
+	} else {
+		/*
+		 * calc # bits * 2 so factor of 2 in rate (1/2 mbps)
+		 * will divide out
+		 */
+		mac_len = mac_len * 8 * 2;
+		/* calc ceiling of bits/rate = microseconds of air time */
+		dur = (mac_len + rate - 1) / rate;
+		if (preamble_type & BRCMS_SHORT_PREAMBLE)
+			dur += BPHY_PLCP_SHORT_TIME;
+		else
+			dur += BPHY_PLCP_TIME;
+	}
+	return dur;
+}
+
+/* derive basic_rate[] table 'br' from 'rateset' */
+void brcmu_rate_lookup_init(u8 *br,
+			    const struct brcms_c_rateset *hw_rateset,
+			    struct brcms_c_rateset *rateset)
+{
+	u8 rate;
+	u8 mandatory;
+	u8 cck_basic = 0;
+	u8 ofdm_basic = 0;
+	uint i;
+
+	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
+	memset(br, 0, BRCM_MAXRATE + 1);
+
+	/* For each basic rate in the rates list, make an entry in the
+	 * best basic lookup.
+	 */
+	for (i = 0; i < rateset->count; i++) {
+		/* only make an entry for a basic rate */
+		if (!(rateset->rates[i] & BRCMS_RATE_FLAG))
+			continue;
+
+		/* mask off basic bit */
+		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
+
+		if (rate > BRCM_MAXRATE) {
+			pr_err("%s: invalid rate 0x%X in rate set\n", __func__,
+			       rateset->rates[i]);
+			continue;
+		}
+
+		br[rate] = rate;
+	}
+
+	/* The rate lookup table now has non-zero entries for each
+	 * basic rate, equal to the basic rate: br[basicN] = basicN
+	 *
+	 * To look up the best basic rate corresponding to any
+	 * particular rate, code can use the basic_rate table
+	 * like this
+	 *
+	 * basic_rate = br[tx_rate]
+	 *
+	 * Make sure there is a best basic rate entry for
+	 * every rate by walking up the table from low rates
+	 * to high, filling in holes in the lookup table
+	 */
+
+	for (i = 0; i < hw_rateset->count; i++) {
+		rate = hw_rateset->rates[i];
+
+		if (br[rate] != 0) {
+			/* This rate is a basic rate.
+			 * Keep track of the best basic rate so far by
+			 * modulation type.
+			 */
+			if (is_ofdm_rate(rate))
+				ofdm_basic = rate;
+			else
+				cck_basic = rate;
+
+			continue;
+		}
+
+		/* This rate is not a basic rate so figure out the
+		 * best basic rate less than this rate and fill in
+		 * the hole in the table
+		 */
+
+		br[rate] = is_ofdm_rate(rate) ? ofdm_basic : cck_basic;
+
+		if (br[rate] != 0)
+			continue;
+
+		if (is_ofdm_rate(rate)) {
+			/*
+			 * In 11g and 11a, the OFDM mandatory rates
+			 * are 6, 12, and 24 Mbps
+			 */
+			if (rate >= BRCM_RATE_24M)
+				mandatory = BRCM_RATE_24M;
+			else if (rate >= BRCM_RATE_12M)
+				mandatory = BRCM_RATE_12M;
+			else
+				mandatory = BRCM_RATE_6M;
+		} else {
+			/* In 11b, all CCK rates are mandatory 1 - 11 Mbps */
+			mandatory = rate;
+		}
+
+		br[rate] = mandatory;
+	}
+}
+
+uint
+brcmu_calc_ack_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		    u8 preamble_type)
+{
+	uint dur = 0;
+
+	/*
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
+	 */
+	rspec = brcmu_basic_rate(basic_rate, rspec);
+	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
+	dur =
+	    brcmu_calc_frame_time(bandtype, rspec, preamble_type,
+				  (DOT11_ACK_LEN + FCS_LEN));
+	return dur;
+}
+
+uint
+brcmu_calc_cts_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		    u8 preamble_type)
+{
+	return brcmu_calc_ack_time(bandtype, basic_rate, rspec, preamble_type);
+}
+
+static uint
+brcmu_calc_ba_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		   u8 preamble_type)
+{
+	/*
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
+	 */
+	rspec = brcmu_basic_rate(basic_rate, rspec);
+	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
+	return brcmu_calc_frame_time(bandtype, rspec, preamble_type,
+				     (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
+				      FCS_LEN));
+}
+
+/*
+ * Compute PLCP, but only requires actual rate and length of pkt.
+ * Rate is given in the driver standard multiple of 500 kbps.
+ * le is set for 11 Mbps rate if necessary.
+ * Broken out for PRQ.
+ */
+
+static void brcmu_cck_plcp_set(int rate_500, uint length, u8 *plcp)
+{
+	u16 usec = 0;
+	u8 le = 0;
+
+	switch (rate_500) {
+	case BRCM_RATE_1M:
+		usec = length << 3;
+		break;
+	case BRCM_RATE_2M:
+		usec = length << 2;
+		break;
+	case BRCM_RATE_5M5:
+		usec = (length << 4) / 11;
+		if ((length << 4) - (usec * 11) > 0)
+			usec++;
+		break;
+	case BRCM_RATE_11M:
+		usec = (length << 3) / 11;
+		if ((length << 3) - (usec * 11) > 0) {
+			usec++;
+			if ((usec * 11) - (length << 3) >= 8)
+				le = D11B_PLCP_SIGNAL_LE;
+		}
+		break;
+
+	default:
+		pr_err("%s: unsupported rate %d\n", __func__, rate_500);
+		rate_500 = BRCM_RATE_1M;
+		usec = length << 3;
+		break;
+	}
+	/* PLCP signal byte */
+	plcp[0] = rate_500 * 5;	/* r (500kbps) * 5 == r (100kbps) */
+	/* PLCP service byte */
+	plcp[1] = (u8) (le | D11B_PLCP_SIGNAL_LOCKED);
+	/* PLCP length u16, little endian */
+	plcp[2] = usec & 0xff;
+	plcp[3] = (usec >> 8) & 0xff;
+	/* PLCP CRC16 */
+	plcp[4] = 0;
+	plcp[5] = 0;
+}
+
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcmu_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
+{
+	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
+	plcp[0] = mcs;
+	if (rspec_is40mhz(rspec) || (mcs == 32))
+		plcp[0] |= MIMO_PLCP_40MHZ;
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
+	plcp[3] = rspec_mimoplcp3(rspec); /* rspec already holds this byte */
+	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
+	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
+	plcp[5] = 0;
+}
+
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void
+brcmu_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
+{
+	u8 rate_signal;
+	u32 tmp = 0;
+	int rate = rspec2rate(rspec);
+
+	/*
+	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
+	 * transmitted first
+	 */
+	rate_signal = brcmu_rate_info[rate] & BRCMS_RATE_MASK;
+	memset(plcp, 0, D11_PHY_HDR_LEN);
+	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
+
+	tmp = (length & 0xfff) << 5;
+	plcp[2] |= (tmp >> 16) & 0xff;
+	plcp[1] |= (tmp >> 8) & 0xff;
+	plcp[0] |= tmp & 0xff;
+}
+
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcmu_compute_cck_plcp(u32 rspec, uint length, u8 *plcp)
+{
+	int rate = rspec2rate(rspec);
+
+	brcmu_cck_plcp_set(rate, length, plcp);
+}
+
+void
+brcmu_compute_plcp(u32 rspec, uint length, u8 *plcp)
+{
+	if (is_mcs_rate(rspec))
+		brcmu_compute_mimo_plcp(rspec, length, plcp);
+	else if (is_ofdm_rate(rspec))
+		brcmu_compute_ofdm_plcp(rspec, length, plcp);
+	else
+		brcmu_compute_cck_plcp(rspec, length, plcp);
+}
+
+/* brcmu_compute_rtscts_dur()
+ *
+ * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
+ * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
+ * DUR for CTS-TO-SELF w/ frame    = 2 SIFS         + next frame time + 1 ACK
+ *
+ * cts			cts-to-self or rts/cts
+ * rts_rate		rts or cts rate in unit of 500kbps
+ * rate			next MPDU rate in unit of 500kbps
+ * frame_len		next MPDU frame length in bytes
+ */
+u16
+brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
+			 u32 rts_rate,
+			 u32 frame_rate, u8 rts_preamble_type,
+			 u8 frame_preamble_type, uint frame_len, bool ba)
+{
+	u16 dur, sifs;
+
+	sifs = brcmu_get_sifs(bandtype);
+
+	if (!cts_only) {
+		/* RTS/CTS */
+		dur = 3 * sifs;
+		dur +=
+		    (u16)brcmu_calc_cts_time(bandtype, basic_rate, rts_rate,
+					     rts_preamble_type);
+	} else {
+		/* CTS-TO-SELF */
+		dur = 2 * sifs;
+	}
+
+	dur +=
+	    (u16)brcmu_calc_frame_time(bandtype, frame_rate,
+				       frame_preamble_type, frame_len);
+	if (ba)
+		dur +=
+		    (u16)brcmu_calc_ba_time(bandtype, basic_rate, frame_rate,
+					    BRCMS_SHORT_PREAMBLE);
+	else
+		dur +=
+		    (u16)brcmu_calc_ack_time(bandtype, basic_rate, frame_rate,
+					     frame_preamble_type);
+	return dur;
+}
+
+u16 brcmu_phytxctl1_calc(u16 phytype, u32 rspec)
+{
+	u16 phyctl1 = 0;
+	u16 bw;
+
+	if (phytype == PHY_TYPE_LCN) {
+		bw = PHY_TXC1_BW_20MHZ;
+	} else {
+		bw = rspec_get_bw(rspec);
+		/* 10Mhz is not supported yet */
+		if (bw < PHY_TXC1_BW_20MHZ) {
+			pr_err("%s: bw %d is not supported yet, set to 20L\n",
+			       __func__, bw);
+			bw = PHY_TXC1_BW_20MHZ;
+		}
+	}
+
+	if (is_mcs_rate(rspec)) {
+		uint mcs = rspec & RSPEC_RATE_MASK;
+
+		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
+		phyctl1 = rspec_phytxbyte2(rspec);
+		/* set the upper byte of phyctl1 */
+		phyctl1 |= (brcmu_mcs_table[mcs].tx_phy_ctl3 << 8);
+	} else if (is_cck_rate(rspec) && phytype != PHY_TYPE_LCN &&
+		   phytype != PHY_TYPE_SSN) {
+		/*
+		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
+		 * Data Rate. Eventually MIMOPHY would also be converted to
+		 * this format
+		 */
+		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
+		phyctl1 = (bw | (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
+	} else {		/* legacy OFDM/CCK */
+		s16 phycfg;
+		/* get the phyctl byte from rate phycfg table */
+		phycfg = brcmu_rate_legacy_phyctl(rspec2rate(rspec));
+		if (phycfg == -1) {
+			pr_err("%s: wrong legacy OFDM/CCK rate\n", __func__);
+			phycfg = 0;
+		}
+		/* set the upper byte of phyctl1 */
+		phyctl1 =
+		    (bw | (phycfg << 8) |
+		     (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
+	}
+	return phyctl1;
+}
+
+/* calculate frame duration for Mixed-mode L-SIG spoofing, return
+ * number of bytes goes in the length field
+ *
+ * Formula given by HT PHY Spec v 1.13
+ *   len = 3(nsyms + nstream + 3) - 3
+ */
+u16
+brcmu_calc_lsig_len(u32 ratespec, uint mac_len)
+{
+	uint nsyms, len = 0, kNdps;
+
+	if (is_mcs_rate(ratespec)) {
+		uint mcs = ratespec & RSPEC_RATE_MASK;
+		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
+				  rspec_stc(ratespec);
+
+		/*
+		 * the payload duration calculation matches that
+		 * of regular ofdm
+		 */
+		/* 1000Ndbps = kbps * 4, at the long-GI rate */
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec), false) * 4;
+
+		if (rspec_stc(ratespec) == 0)
+			nsyms =
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, kNdps);
+		else
+			/* STBC needs to have even number of symbols */
+			nsyms =
+			    2 *
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
+
+		/* short-GI symbols (3.6 us) in 4 us units, rounded up */
+		if (rspec_issgi(ratespec))
+			nsyms = CEIL(nsyms * 9, 10);
+		/* (+3) account for HT-SIG(2) and HT-STF(1) */
+		nsyms += (tot_streams + 3);
+		/*
+		 * 3 bytes/symbol @ legacy 6Mbps rate
+		 * (-3) excluding service bits and tail bits
+		 */
+		len = (3 * nsyms) - 3;
+	}
+
+	return (u16) len;
+}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
index e20913bdf..401fed693 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.h
@@ -22,6 +22,30 @@
 #include "pub.h"
 #include "phy_hal.h"
 
+/* value for short/long and mixmode/greenfield preamble */
+#define BRCMS_LONG_PREAMBLE	(0)
+#define BRCMS_SHORT_PREAMBLE	(1 << 0)
+#define BRCMS_GF_PREAMBLE		(1 << 1)
+#define BRCMS_MM_PREAMBLE		(1 << 2)
+#define BRCMS_IS_MIMO_PREAMBLE(_pre) (((_pre) == BRCMS_GF_PREAMBLE) || \
+				      ((_pre) == BRCMS_MM_PREAMBLE))
+
+#define APHY_SYMBOL_TIME		4
+#define APHY_PREAMBLE_TIME		16
+#define APHY_SIGNAL_TIME		4
+#define APHY_SIFS_TIME			16
+#define APHY_SERVICE_NBITS		16
+#define APHY_TAIL_NBITS			6
+#define BPHY_SIFS_TIME			10
+#define BPHY_PLCP_SHORT_TIME		96
+#define BPHY_PLCP_TIME			192
+
+#define PREN_PREAMBLE			24
+#define PREN_MM_EXT			12
+#define PREN_PREAMBLE_EXT		4
+
+#define DOT11_OFDM_SIGNAL_EXTENSION	6
+
 extern const u8 brcmu_rate_info[];
 extern const struct brcms_c_rateset brcmu_cck_ofdm_mimo_rates;
 extern const struct brcms_c_rateset brcmu_ofdm_mimo_rates;
@@ -229,11 +253,33 @@ void brcmu_rateset_default(struct brcms_c_rateset *rs_tgt,
 			   int bandtype, bool cck_only, uint rate_mask,
 			   bool mcsallow, u8 bw, u8 txstreams);
 
-s16 brcmu_rate_legacy_phyctl(uint rate);
-
 void brcmu_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams);
 void brcmu_rateset_mcs_clear(struct brcms_c_rateset *rateset);
 void brcmu_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams);
 void brcmu_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw);
 
+/* currently the best mechanism for determining SIFS is the band in use */
+static inline u16 brcmu_get_sifs(int bandtype)
+{
+	return bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : BPHY_SIFS_TIME;
+}
+
+u8 brcmu_basic_rate(const u8 *basic_rate, u32 rspec);
+uint brcmu_calc_frame_time(int bandtype, u32 ratespec,
+			   u8 preamble_type, uint mac_len);
+void brcmu_rate_lookup_init(u8 *br,
+			    const struct brcms_c_rateset *hw_rateset,
+			    struct brcms_c_rateset *rateset);
+uint brcmu_calc_ack_time(int bandtype, const u8 *basic_rate, u32 rspec,
+			 u8 preamble_type);
+uint brcmu_calc_cts_time(int bandtype, const u8 *basic_rate, u32 rspec,
+			 u8 preamble_type);
+void brcmu_compute_plcp(u32 rspec, uint length, u8 *plcp);
+u16 brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
+			     u32 rts_rate, u32 frame_rate,
+			     u8 rts_preamble_type, u8 frame_preamble_type,
+			     uint frame_len, bool ba);
+u16 brcmu_phytxctl1_calc(u16 phytype, u32 rspec);
+u16 brcmu_calc_lsig_len(u32 ratespec, uint mac_len);
+
 #endif				/* _BRCM_RATE_H_ */
-- 
2.53.0

