Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993031;
	b=ZYCIdfyx3fGpEsMYdAJqWyrrSyGS3s2j8xnspHIq2BiM00qeRrFMM008axWcMWiSSDcU
	 aicjfNp+4HwnRa9+aoio2kRKD1g/4xP6T0JRmX6MbIBu+agV5/ylFU5iwxm5O99liHdg8
	 dwNWuapovoND6elZur/CHbz76u5VCgmDwFH3N/4Jf5VMubSLVdkl971riPrplOK/j/lPt
	 KgF37ddpPQusBbsTExYzPiZ9F8hDddz3uV0CareFH79l60FEUMCLv30TjV7v4CHQ4/bPU
	 s62pOnmiwv90KS24iDTvneTM0bnJtDwJveSwNlQiEOJVexPe53TFJlQZ4ibPRHWvpLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993031;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PlHRGv3hpXOigTkBWMZantlDdrKpKbsHvwgadjEfoCA=;
	b=BYOcp0T8Bi656tu2WHjNpvMrNZmBz6v9e3ojFdVljhyhJ+fo2g9QmYySzocTqXq4M9Xm
	 qiGKrclq8tijUMd9yALMmz++bdr0LWW9bbboA+99MbwhixwW0WO9irGCsboCKNuUjjo80
	 BtmtXoojqaseml/uLHder53xyPc5AC/TYVpuLb1CmF2dxr+ewPN9O7y7fXtNMGQ8wid5w
	 SGeCjrugVNnDc6lGOuVUX1XfX7oyBoG8534gmZ6kbadB3dNm5IB14PCpdD6OwXcVNrCiS
	 HWPS1kxu46kLTKVHto7hlgG07mUI+Erk3B2iY1CPabZoXopfG3roBsVjujvN19T1rpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="LSI/U2Hn";
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921F8606A31E
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 921F8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LSI/U2Hn
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a07025cce4so1624173b3a.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993030; x=1793597830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PlHRGv3hpXOigTkBWMZantlDdrKpKbsHvwgadjEfoCA=;
        b=LSI/U2HnYyVqA+iQi2AooE6n23J5O6tQOFsC8ml/zCnKvI+k195rEnghaC+hT/eAzS
         aC4lrtcm3Wk1hAUFnJwYWDqiXosCUXYuWxXOW2PCGoblMENojWagbHgoCM+D1aqQg7iC
         wMePXsmLsVEYwuutSbYSCPj9wfvEq2aR6YZO/lzUyGFRmvvWOI3y6gm4Q8umiS1OeKPs
         mLNbhkKxYLXwG4Bqp/cIuJ2jloPBWmzUeGa5vloo9Lghyt1Rq+Q1NmFKkJyGFlwET7d2
         Zsdoq1pVk8q3Pf8IPaMTzKK9YIPXkYY50RGfXfCSgs50pLLyQKpjAby29fX8BYb/5Zcw
         HHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993030; x=1793597830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PlHRGv3hpXOigTkBWMZantlDdrKpKbsHvwgadjEfoCA=;
        b=etMyKFveqgnvJXBfPcyYfXr8oZSSiwhgpX7v8pM4i2tTibOv6SX753FvkScudtner7
         W2OP9rj6835Y/wSoxh24B3ummUgfqn4srSfRcZqwCE3c1z+UC9OcbAbl7/71nu7i0IgA
         Ajcu0ZMUdArRvjNUf6GOixmXauWl1prZvoq0QT+J+rfvLjW4dBXqJkaA354z6q6FftPk
         fJoeyJzpLcKIE87E3AG6s4F4sKmNwAukPF9ItkFPpQ9F2bhDHMP4Jx24a+luuow8kome
         d6wMNLsDHpid/g252tzmEumDtGONDyXBrtK2cH2QTgnlGJBIfcQn0hN9J4K6AieLdLs9
         2YHg==
X-Gm-Message-State: AFq9FYKVeN/B8L3GHZOMnyIUbz6vfOJPmRUNatx6A+ZdB7e8dotk07RF
	03LCsuWIPHOlJOj37Vyr/OFFy0BOl0GSisJM8kkW+QMJVhhu1udQ1Yc4AelNdJqXQd1raw==
X-Gm-Gg: AYBFou3AHZEWiOLVAt8uN2H6vDkxU3J/NWUHh5EDNh6RFN7IoLnvBOSu8PyHKUNvmjs
	hTHYjJTLeFikW13V/SYFkShLVZP4QO/kt2mpZoNI+ljqHq2+AUzez72mdmF4PVvWxQhLEPEPXYW
	bWew/+H1T1oACq5qOAoBw1yfFDzVvyb12q93IpfCL++5Co7T1LdbbWWWPHbLJrdaai0UVrcCYwm
	a/TVyArI2zPLJRjKJ4xSFxtzbds8R2128AsleUuvAJyEHIqp/bizraFtzQGnSWHDEVvn2CeL/li
	qoHMNN3vrRCkBsVeUWJxv/lQ3vJWgTMH9YI8Ts1UoWoAhTNiWNXkfgKYh6bBI4E9U1KGdmu80CY
	kDOxYUZb6ZorVhm7CDz8ek3n9wBX8gmWkLFcIHjIgpY/b7xS2JGZjAiF+m2JLg4WXVmvIQ3Jxel
	8FlnsewyQARgS/LvhD6kByLwEVbLrkLz3mQHPSdQBU0Th87M4zvx96Uae9s73Er9UnyHMgclNvN
	1BiXj3OTxL15U5pslbMSKZ3IQQyOw0lixERbde7NDt8UkthLV14arUOy5OXJ7ccOFC2VqFGkUA0
	tYcLPEBnfaQNQTbpPnkfgB/Vlg==
X-Received: by 2002:a05:6a00:4c8c:b0:8a0:3ef7:42da with SMTP id d2e1a72fcca58-8a364e5ceafmr4607160b3a.4.1792993029730;
        Sun, 25 Oct 2026 22:37:09 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:09 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH wireless-next 06/17] wifi: brcmsmac: pass the band to the PLCP and frame timing helpers
Date: Mon, 26 Oct 2026 13:36:12 +0800
Message-ID: <20261026053633.361454-7-ragulbaby@gmail.com>
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

The functions computing the PLCP headers, frame and response times,
RTS/CTS durations, L-SIG lengths and PHY control words take the driver
state, but only use the band type, PHY type and basic rate table of the
current band from it.  Pass those instead and give the functions the
brcmu_ prefix, so that they can move to brcmutil for other drivers of
the d11 core.

Their error messages lose the device name, and BRCMS_ISLCNPHY() and
BRCMS_ISSSLPNPHY() become plain PHY type tests, which they are for the
PHY types brcmsmac supports.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |  31 ++-
 .../broadcom/brcm80211/brcmsmac/main.c        | 249 +++++++++---------
 .../broadcom/brcm80211/brcmsmac/main.h        |  10 +-
 3 files changed, 150 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index b42e43c88..19ffa72e2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -720,14 +720,13 @@ void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session)
 
 	/* reset the mixed mode header durations */
 	if (txh->MModeLen) {
-		u16 mmodelen = brcms_c_calc_lsig_len(wlc, rspec,
-						     session->ampdu_len);
+		u16 mmodelen = brcmu_calc_lsig_len(rspec, session->ampdu_len);
 		txh->MModeLen = cpu_to_le16(mmodelen);
 		preamble_type = BRCMS_MM_PREAMBLE;
 	}
 	if (txh->MModeFbrLen) {
-		u16 mmfbrlen = brcms_c_calc_lsig_len(wlc, rspec_fallback,
-						     session->ampdu_len);
+		u16 mmfbrlen = brcmu_calc_lsig_len(rspec_fallback,
+						   session->ampdu_len);
 		txh->MModeFbrLen = cpu_to_le16(mmfbrlen);
 		fbr_preamble_type = BRCMS_MM_PREAMBLE;
 	}
@@ -753,17 +752,21 @@ void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session)
 		     TXC_PREAMBLE_RTS_FB_SHORT)
 			rts_fbr_preamble_type = BRCMS_SHORT_PREAMBLE;
 
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
-						   rspec, rts_preamble_type,
-						   preamble_type,
-						   session->ampdu_len, true);
+		durid = brcmu_compute_rtscts_dur(wlc->band->bandtype,
+						 wlc->band->basic_rate,
+						 use_cts, rts_rspec,
+						 rspec, rts_preamble_type,
+						 preamble_type,
+						 session->ampdu_len, true);
 		rts->duration = cpu_to_le16(durid);
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
-						   rts_rspec_fallback,
-						   rspec_fallback,
-						   rts_fbr_preamble_type,
-						   fbr_preamble_type,
-						   session->ampdu_len, true);
+		durid = brcmu_compute_rtscts_dur(wlc->band->bandtype,
+						 wlc->band->basic_rate,
+						 use_cts,
+						 rts_rspec_fallback,
+						 rspec_fallback,
+						 rts_fbr_preamble_type,
+						 fbr_preamble_type,
+						 session->ampdu_len, true);
 		txh->RTSDurFallback = cpu_to_le16(durid);
 		/* set TxFesTimeNormal */
 		txh->TxFesTimeNormal = rts->duration;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index c9a5877c1..1725f0634 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -349,12 +349,12 @@ static u8 brcms_fifo_to_ac(u8 fifo)
 }
 
 /* Find basic rate for a given rate */
-static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
+static u8 brcmu_basic_rate(const u8 *basic_rate, u32 rspec)
 {
 	if (is_mcs_rate(rspec))
-		return wlc->band->basic_rate[brcmu_mcs_table[rspec & RSPEC_RATE_MASK]
+		return basic_rate[brcmu_mcs_table[rspec & RSPEC_RATE_MASK]
 		       .leg_ofdm];
-	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
+	return basic_rate[rspec & RSPEC_RATE_MASK];
 }
 
 static u16 frametype(u32 rspec, u8 mimoframe)
@@ -365,10 +365,9 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 }
 
 /* currently the best mechanism for determining SIFS is the band in use */
-static u16 get_sifs(struct brcms_band *band)
+static u16 brcmu_get_sifs(int bandtype)
 {
-	return band->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME :
-				 BPHY_SIFS_TIME;
+	return bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : BPHY_SIFS_TIME;
 }
 
 /*
@@ -576,15 +575,14 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
  * calculate frame duration of a given rate and length, return
  * time in usec unit
  */
-static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
-				    u8 preamble_type, uint mac_len)
+static uint brcmu_calc_frame_time(int bandtype, u32 ratespec,
+				  u8 preamble_type, uint mac_len)
 {
 	uint nsyms, dur = 0, Ndps, kNdps;
 	uint rate = rspec2rate(ratespec);
 
 	if (rate == 0) {
-		brcms_err(wlc->hw->d11core, "wl%d: WAR: using rate of 1 mbps\n",
-			  wlc->pub->unit);
+		pr_err("WAR: using rate of 1 mbps\n");
 		rate = BRCM_RATE_1M;
 	}
 
@@ -611,7 +609,7 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
 
 		dur += APHY_SYMBOL_TIME * nsyms;
-		if (wlc->band->bandtype == BRCM_BAND_2G)
+		if (bandtype == BRCM_BAND_2G)
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
 	} else if (is_ofdm_rate(rate)) {
 		dur = APHY_PREAMBLE_TIME;
@@ -623,7 +621,7 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
 			 Ndps);
 		dur += APHY_SYMBOL_TIME * nsyms;
-		if (wlc->band->bandtype == BRCM_BAND_2G)
+		if (bandtype == BRCM_BAND_2G)
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
 	} else {
 		/*
@@ -3368,15 +3366,15 @@ brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 			      wlc->stf->txstreams);
 }
 
-/* derive wlc->band->basic_rate[] table from 'rateset' */
-static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
-			      struct brcms_c_rateset *rateset)
+/* derive basic_rate[] table 'br' from 'rateset' */
+static void brcmu_rate_lookup_init(u8 *br,
+				   const struct brcms_c_rateset *hw_rateset,
+				   struct brcms_c_rateset *rateset)
 {
 	u8 rate;
 	u8 mandatory;
 	u8 cck_basic = 0;
 	u8 ofdm_basic = 0;
-	u8 *br = wlc->band->basic_rate;
 	uint i;
 
 	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
@@ -3394,9 +3392,8 @@ static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
 
 		if (rate > BRCM_MAXRATE) {
-			brcms_err(wlc->hw->d11core, "brcms_c_rate_lookup_init: "
-				  "invalid rate 0x%X in rate set\n",
-				  rateset->rates[i]);
+			pr_err("%s: invalid rate 0x%X in rate set\n", __func__,
+			       rateset->rates[i]);
 			continue;
 		}
 
@@ -3417,8 +3414,8 @@ static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 	 * to high, filling in holes in the lookup table
 	 */
 
-	for (i = 0; i < wlc->band->hw_rateset.count; i++) {
-		rate = wlc->band->hw_rateset.rates[i];
+	for (i = 0; i < hw_rateset->count; i++) {
+		rate = hw_rateset->rates[i];
 
 		if (br[rate] != 0) {
 			/* This rate is a basic rate.
@@ -3501,7 +3498,9 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 				     (bool)(wlc->pub->_n_enab & SUPPORT_11N));
 
 		/* init basic rate lookup */
-		brcms_c_rate_lookup_init(wlc, &default_rateset);
+		brcmu_rate_lookup_init(wlc->band->basic_rate,
+				       &wlc->band->hw_rateset,
+				       &default_rateset);
 	}
 
 	/* sync up phy/radio chanspec */
@@ -3633,10 +3632,10 @@ static void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 	for (i = 0; i < rs.count; i++) {
 		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
-		/* for a given rate brcms_basic_rate returns the rate at
+		/* for a given rate brcmu_basic_rate returns the rate at
 		 * which a response ACK/CTS should be sent.
 		 */
-		basic_rate = brcms_basic_rate(wlc, rate);
+		basic_rate = brcmu_basic_rate(wlc->band->basic_rate, rate);
 		if (basic_rate == 0)
 			/* This should only happen if we are using a
 			 * restricted rateset.
@@ -5640,8 +5639,8 @@ bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_bss_cfg *bsscfg,
 }
 
 static uint
-brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
-		      u8 preamble_type)
+brcmu_calc_ack_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		    u8 preamble_type)
 {
 	uint dur = 0;
 
@@ -5650,35 +5649,35 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 	 * is less than or equal to the rate of the immediately previous
 	 * frame in the FES
 	 */
-	rspec = brcms_basic_rate(wlc, rspec);
+	rspec = brcmu_basic_rate(basic_rate, rspec);
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
 	dur =
-	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
-				(DOT11_ACK_LEN + FCS_LEN));
+	    brcmu_calc_frame_time(bandtype, rspec, preamble_type,
+				  (DOT11_ACK_LEN + FCS_LEN));
 	return dur;
 }
 
 static uint
-brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
-		      u8 preamble_type)
+brcmu_calc_cts_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		    u8 preamble_type)
 {
-	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
+	return brcmu_calc_ack_time(bandtype, basic_rate, rspec, preamble_type);
 }
 
 static uint
-brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
-		     u8 preamble_type)
+brcmu_calc_ba_time(int bandtype, const u8 *basic_rate, u32 rspec,
+		   u8 preamble_type)
 {
 	/*
 	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
 	 * is less than or equal to the rate of the immediately previous
 	 * frame in the FES
 	 */
-	rspec = brcms_basic_rate(wlc, rspec);
+	rspec = brcmu_basic_rate(basic_rate, rspec);
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
-	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
-				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
-				    FCS_LEN));
+	return brcmu_calc_frame_time(bandtype, rspec, preamble_type,
+				     (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
+				      FCS_LEN));
 }
 
 /* brcms_c_compute_frame_dur()
@@ -5697,10 +5696,12 @@ brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
 {
 	u16 dur, sifs;
 
-	sifs = get_sifs(wlc->band);
+	sifs = brcmu_get_sifs(wlc->band->bandtype);
 
 	dur = sifs;
-	dur += (u16) brcms_c_calc_ack_time(wlc, rate, preamble_type);
+	dur += (u16)brcmu_calc_ack_time(wlc->band->bandtype,
+					wlc->band->basic_rate, rate,
+					preamble_type);
 
 	if (next_frag_len) {
 		/* Double the current DUR to get 2 SIFS + 2 ACKs */
@@ -5708,13 +5709,13 @@ brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
 		/* add another SIFS and the frag time */
 		dur += sifs;
 		dur +=
-		    (u16) brcms_c_calc_frame_time(wlc, rate, preamble_type,
-						 next_frag_len);
+		    (u16)brcmu_calc_frame_time(wlc->band->bandtype, rate,
+					       preamble_type, next_frag_len);
 	}
 	return dur;
 }
 
-/* The opposite of brcms_c_calc_frame_time */
+/* The opposite of brcmu_calc_frame_time */
 static uint
 brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 		   u8 preamble_type, uint dur)
@@ -5910,8 +5911,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
  * Broken out for PRQ.
  */
 
-static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
-			     uint length, u8 *plcp)
+static void brcmu_cck_plcp_set(int rate_500, uint length, u8 *plcp)
 {
 	u16 usec = 0;
 	u8 le = 0;
@@ -5938,9 +5938,7 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 		break;
 
 	default:
-		brcms_err(wlc->hw->d11core,
-			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
-			  rate_500);
+		pr_err("%s: unsupported rate %d\n", __func__, rate_500);
 		rate_500 = BRCM_RATE_1M;
 		usec = length << 3;
 		break;
@@ -5958,7 +5956,7 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
+static void brcmu_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
 {
 	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
 	plcp[0] = mcs;
@@ -5973,7 +5971,7 @@ static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
 static void
-brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
+brcmu_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 {
 	u8 rate_signal;
 	u32 tmp = 0;
@@ -5994,27 +5992,25 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
-				 uint length, u8 *plcp)
+static void brcmu_compute_cck_plcp(u32 rspec, uint length, u8 *plcp)
 {
 	int rate = rspec2rate(rspec);
 
-	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
+	brcmu_cck_plcp_set(rate, length, plcp);
 }
 
 static void
-brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
-		     uint length, u8 *plcp)
+brcmu_compute_plcp(u32 rspec, uint length, u8 *plcp)
 {
 	if (is_mcs_rate(rspec))
-		brcms_c_compute_mimo_plcp(rspec, length, plcp);
+		brcmu_compute_mimo_plcp(rspec, length, plcp);
 	else if (is_ofdm_rate(rspec))
-		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
+		brcmu_compute_ofdm_plcp(rspec, length, plcp);
 	else
-		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
+		brcmu_compute_cck_plcp(rspec, length, plcp);
 }
 
-/* brcms_c_compute_rtscts_dur()
+/* brcmu_compute_rtscts_dur()
  *
  * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
  * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
@@ -6026,53 +6022,53 @@ brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
  * frame_len		next MPDU frame length in bytes
  */
 u16
-brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-			   u32 rts_rate,
-			   u32 frame_rate, u8 rts_preamble_type,
-			   u8 frame_preamble_type, uint frame_len, bool ba)
+brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
+			 u32 rts_rate,
+			 u32 frame_rate, u8 rts_preamble_type,
+			 u8 frame_preamble_type, uint frame_len, bool ba)
 {
 	u16 dur, sifs;
 
-	sifs = get_sifs(wlc->band);
+	sifs = brcmu_get_sifs(bandtype);
 
 	if (!cts_only) {
 		/* RTS/CTS */
 		dur = 3 * sifs;
 		dur +=
-		    (u16) brcms_c_calc_cts_time(wlc, rts_rate,
-					       rts_preamble_type);
+		    (u16)brcmu_calc_cts_time(bandtype, basic_rate, rts_rate,
+					     rts_preamble_type);
 	} else {
 		/* CTS-TO-SELF */
 		dur = 2 * sifs;
 	}
 
 	dur +=
-	    (u16) brcms_c_calc_frame_time(wlc, frame_rate, frame_preamble_type,
-					 frame_len);
+	    (u16)brcmu_calc_frame_time(bandtype, frame_rate,
+				       frame_preamble_type, frame_len);
 	if (ba)
 		dur +=
-		    (u16) brcms_c_calc_ba_time(wlc, frame_rate,
-					      BRCMS_SHORT_PREAMBLE);
+		    (u16)brcmu_calc_ba_time(bandtype, basic_rate, frame_rate,
+					    BRCMS_SHORT_PREAMBLE);
 	else
 		dur +=
-		    (u16) brcms_c_calc_ack_time(wlc, frame_rate,
-					       frame_preamble_type);
+		    (u16)brcmu_calc_ack_time(bandtype, basic_rate, frame_rate,
+					     frame_preamble_type);
 	return dur;
 }
 
-static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
+static u16 brcmu_phytxctl1_calc(u16 phytype, u32 rspec)
 {
 	u16 phyctl1 = 0;
 	u16 bw;
 
-	if (BRCMS_ISLCNPHY(wlc->band)) {
+	if (phytype == PHY_TYPE_LCN) {
 		bw = PHY_TXC1_BW_20MHZ;
 	} else {
 		bw = rspec_get_bw(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
-			brcms_err(wlc->hw->d11core, "phytxctl1_calc: bw %d is "
-				  "not supported yet, set to 20L\n", bw);
+			pr_err("%s: bw %d is not supported yet, set to 20L\n",
+			       __func__, bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
 	}
@@ -6084,8 +6080,8 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		phyctl1 = rspec_phytxbyte2(rspec);
 		/* set the upper byte of phyctl1 */
 		phyctl1 |= (brcmu_mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (is_cck_rate(rspec) && !BRCMS_ISLCNPHY(wlc->band)
-		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
+	} else if (is_cck_rate(rspec) && phytype != PHY_TYPE_LCN &&
+		   phytype != PHY_TYPE_SSN) {
 		/*
 		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
 		 * Data Rate. Eventually MIMOPHY would also be converted to
@@ -6098,8 +6094,7 @@ static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		/* get the phyctl byte from rate phycfg table */
 		phycfg = brcmu_rate_legacy_phyctl(rspec2rate(rspec));
 		if (phycfg == -1) {
-			brcms_err(wlc->hw->d11core, "phytxctl1_calc: wrong "
-				  "legacy OFDM/CCK rate\n");
+			pr_err("%s: wrong legacy OFDM/CCK rate\n", __func__);
 			phycfg = 0;
 		}
 		/* set the upper byte of phyctl1 */
@@ -6395,8 +6390,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 	/* (3) PLCP: determine PLCP header and MAC duration,
 	 * fill struct d11txh */
-	brcms_c_compute_plcp(wlc, rspec[0], phylen, plcp);
-	brcms_c_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
+	brcmu_compute_plcp(rspec[0], phylen, plcp);
+	brcmu_compute_plcp(rspec[1], phylen, plcp_fallback);
 	memcpy(&txh->FragPLCPFallback,
 	       plcp_fallback, sizeof(txh->FragPLCPFallback));
 
@@ -6421,9 +6416,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	} else if (use_rifs) {
 		/* NAV protect to end of next max packet size */
 		durid =
-		    (u16) brcms_c_calc_frame_time(wlc, rspec[0],
-						 preamble_type[0],
-						 DOT11_MAX_FRAG_LEN);
+		    (u16)brcmu_calc_frame_time(wlc->band->bandtype, rspec[0],
+					       preamble_type[0],
+					       DOT11_MAX_FRAG_LEN);
 		durid += RIFS_11N_TIME;
 		h->duration_id = cpu_to_le16(durid);
 	}
@@ -6537,26 +6532,30 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		else
 			rts_phylen = DOT11_RTS_LEN + FCS_LEN;
 
-		brcms_c_compute_plcp(wlc, rts_rspec[0], rts_phylen, rts_plcp);
+		brcmu_compute_plcp(rts_rspec[0], rts_phylen, rts_plcp);
 
 		/* fallback rate version of RTS PLCP header */
-		brcms_c_compute_plcp(wlc, rts_rspec[1], rts_phylen,
-				 rts_plcp_fallback);
+		brcmu_compute_plcp(rts_rspec[1], rts_phylen, rts_plcp_fallback);
 		memcpy(&txh->RTSPLCPFallback, rts_plcp_fallback,
 		       sizeof(txh->RTSPLCPFallback));
 
 		/* RTS frame fields... */
 		rts = (struct ieee80211_rts *)&txh->rts_frame;
 
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
-					       rspec[0], rts_preamble_type[0],
-					       preamble_type[0], phylen, false);
+		durid = brcmu_compute_rtscts_dur(wlc->band->bandtype,
+						 wlc->band->basic_rate,
+						 use_cts, rts_rspec[0],
+						 rspec[0], rts_preamble_type[0],
+						 preamble_type[0], phylen,
+						 false);
 		rts->duration = cpu_to_le16(durid);
 		/* fallback rate version of RTS DUR field */
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
-					       rts_rspec[1], rspec[1],
-					       rts_preamble_type[1],
-					       preamble_type[1], phylen, false);
+		durid = brcmu_compute_rtscts_dur(wlc->band->bandtype,
+						 wlc->band->basic_rate,
+						 use_cts, rts_rspec[1],
+						 rspec[1], rts_preamble_type[1],
+						 preamble_type[1], phylen,
+						 false);
 		txh->RTSDurFallback = cpu_to_le16(durid);
 
 		if (use_cts) {
@@ -6631,15 +6630,17 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		u16 phyctl1 = 0;
 
-		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[0]);
+		phyctl1 = brcmu_phytxctl1_calc(wlc->band->phytype, rspec[0]);
 		txh->PhyTxControlWord_1 = cpu_to_le16(phyctl1);
-		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[1]);
+		phyctl1 = brcmu_phytxctl1_calc(wlc->band->phytype, rspec[1]);
 		txh->PhyTxControlWord_1_Fbr = cpu_to_le16(phyctl1);
 
 		if (use_rts || use_cts) {
-			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[0]);
+			phyctl1 = brcmu_phytxctl1_calc(wlc->band->phytype,
+						       rts_rspec[0]);
 			txh->PhyTxControlWord_1_Rts = cpu_to_le16(phyctl1);
-			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[1]);
+			phyctl1 = brcmu_phytxctl1_calc(wlc->band->phytype,
+						       rts_rspec[1]);
 			txh->PhyTxControlWord_1_FbrRts = cpu_to_le16(phyctl1);
 		}
 
@@ -6651,14 +6652,14 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		if (is_mcs_rate(rspec[0]) &&
 		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodelen =
-			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
+			    brcmu_calc_lsig_len(rspec[0], phylen);
 			txh->MModeLen = cpu_to_le16(mmodelen);
 		}
 
 		if (is_mcs_rate(rspec[1]) &&
 		    (preamble_type[1] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodefbrlen =
-			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
+			    brcmu_calc_lsig_len(rspec[1], phylen);
 			txh->MModeFbrLen = cpu_to_le16(mmodefbrlen);
 		}
 	}
@@ -6670,17 +6671,21 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		/* WME: Update TXOP threshold */
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) && frag == 0) {
 			frag_dur =
-			    brcms_c_calc_frame_time(wlc, rspec[0],
-					preamble_type[0], phylen);
+			    brcmu_calc_frame_time(wlc->band->bandtype, rspec[0],
+						  preamble_type[0], phylen);
 
 			if (rts) {
 				/* 1 RTS or CTS-to-self frame */
 				dur =
-				    brcms_c_calc_cts_time(wlc, rts_rspec[0],
-						      rts_preamble_type[0]);
+				    brcmu_calc_cts_time(wlc->band->bandtype,
+							wlc->band->basic_rate,
+							rts_rspec[0],
+							rts_preamble_type[0]);
 				dur_fallback =
-				    brcms_c_calc_cts_time(wlc, rts_rspec[1],
-						      rts_preamble_type[1]);
+				    brcmu_calc_cts_time(wlc->band->bandtype,
+							wlc->band->basic_rate,
+							rts_rspec[1],
+							rts_preamble_type[1]);
 				/* (SIFS + CTS) + SIFS + frame + SIFS + ACK */
 				dur += le16_to_cpu(rts->duration);
 				dur_fallback +=
@@ -6696,9 +6701,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 							  preamble_type[0], 0);
 
 				dur_fallback =
-				    brcms_c_calc_frame_time(wlc, rspec[1],
-							preamble_type[1],
-							phylen);
+				    brcmu_calc_frame_time(wlc->band->bandtype,
+							  rspec[1],
+							  preamble_type[1],
+							  phylen);
 				dur_fallback +=
 				    brcms_c_compute_frame_dur(wlc, rspec[1],
 							  preamble_type[1], 0);
@@ -6862,19 +6868,20 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		rts_rspec = rspec;
 	else if (wlc->band->gmode && wlc->protection->_g && !is_cck_rate(rspec))
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
-		 * Use the brcms_basic_rate() lookup to find the best basic rate
+		 * Use the brcmu_basic_rate() lookup to find the best basic rate
 		 * under the target in case 11 Mbps is not Basic.
 		 * 6 and 9 Mbps are not usually selected by rate selection, but
 		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
 		 * is more robust.
 		 */
-		rts_rspec = brcms_basic_rate(wlc, BRCM_RATE_11M);
+		rts_rspec = brcmu_basic_rate(wlc->band->basic_rate,
+					     BRCM_RATE_11M);
 	else
 		/* calculate RTS rate and fallback rate based on the frame rate
 		 * RTS must be sent at a basic rate since it is a
 		 * control frame, sec 9.6 of 802.11 spec
 		 */
-		rts_rspec = brcms_basic_rate(wlc, rspec);
+		rts_rspec = brcmu_basic_rate(wlc->band->basic_rate, rspec);
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		/* set rts txbw to correct side band */
@@ -7105,8 +7112,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
  *   len = 3(nsyms + nstream + 3) - 3
  */
 u16
-brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
-		      uint mac_len)
+brcmu_calc_lsig_len(u32 ratespec, uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
 
@@ -7159,7 +7165,7 @@ brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	u16 dur, sifs;
 	uint i;
 
-	sifs = get_sifs(wlc->band);
+	sifs = brcmu_get_sifs(wlc->band->bandtype);
 
 	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
@@ -7176,14 +7182,15 @@ brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 		entry_ptr = brcms_b_rate_shm_offset(wlc->hw, rate);
 
 		/* Calculate the Probe Response PLCP for the given rate */
-		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
+		brcmu_compute_plcp(rate, frame_len, plcp);
 
 		/*
 		 * Calculate the duration of the Probe Response
 		 * frame plus SIFS for the MAC
 		 */
-		dur = (u16) brcms_c_calc_frame_time(wlc, rate,
-						BRCMS_LONG_PREAMBLE, frame_len);
+		dur = (u16)brcmu_calc_frame_time(wlc->band->bandtype, rate,
+						 BRCMS_LONG_PREAMBLE,
+						 frame_len);
 		dur += sifs;
 
 		/* Update the SHM Rate Table entry Probe Response values */
@@ -7215,8 +7222,8 @@ static void brcms_c_beacon_write(struct brcms_c_info *wlc,
 	len = min_t(size_t, beacon->len, BCN_TMPL_LEN);
 	wlc->bcn_rspec = ieee80211_get_tx_rate(ieee_hw, tx_info)->hw_value;
 
-	brcms_c_compute_plcp(wlc, wlc->bcn_rspec,
-			     len + FCS_LEN - D11_PHY_HDR_LEN, beacon->data);
+	brcmu_compute_plcp(wlc->bcn_rspec,
+			   len + FCS_LEN - D11_PHY_HDR_LEN, beacon->data);
 
 	/* "Regular" and 16 MBSS but not for 4 MBSS */
 	/* Update the phytxctl for the beacon based on the rspec */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
index d81de701a..347d9a4a8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.h
@@ -614,13 +614,13 @@ int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 
 int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
-u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec, uint mac_len);
+u16 brcmu_calc_lsig_len(u32 ratespec, uint mac_len);
 u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 			       bool use_rspec, u16 mimo_ctlchbw);
-u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-			       u32 rts_rate, u32 frame_rate,
-			       u8 rts_preamble_type, u8 frame_preamble_type,
-			       uint frame_len, bool ba);
+u16 brcmu_compute_rtscts_dur(int bandtype, const u8 *basic_rate, bool cts_only,
+			     u32 rts_rate, u32 frame_rate,
+			     u8 rts_preamble_type, u8 frame_preamble_type,
+			     uint frame_len, bool ba);
 void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			    struct ieee80211_sta *sta, void (*dma_callback_fn));
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
-- 
2.53.0

