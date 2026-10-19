Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636464D37DC
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 10:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792407410; cv=none; b=oxA/eI//EeGDemSlN4yvjeSS1H0Biny9nS6d+gXB/ztEuc5m+etILNiF7cqGaAEr+GKtDIWp3GXq1Psbjvc/eTNEMySeWMHclq+lyLBG/Zi+eKvl+DJc/OQ9jLsnjxI/0Co9LyHcA8xi8nqzLnDfLqhiLDmyuUw0TzG0pP8GhTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792407410; c=relaxed/simple;
	bh=2cDHITn9/rHN9K0ogaC3csc9nAYPxFcQwICaO2xLmKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg6dDLamR6B63d+2D22zWNwkltsMEMttdGCl8mZrdcBthhOyfQkNWrSK/gg6O03fcYMPTUtb1uGXlSaWJKG/lRGOL9FEDCx0Zu8Rx71JiK5r9t6hTxLZUvCf0nfG0zzqIUQnCG++D2Z75ymQAfuQn0m/k3cCL4gyHbLTnVAMkA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2DK9xCd; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2DK9xCd"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48c45111bebso1181124f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 03:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792407405; x=1793012205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NeauCzO5ecKjHDuQguGvUZNFFmU3DC+5tCqSrByEIF0=;
        b=U2DK9xCd/PRX0rUCRuMM64RCP2NHv3hsaPeg9m2epUnTyVVbvM3dwmM5OiDb/O69YL
         76tYUtzvf/j5eq6s3tttZoe3V8D1VMZXm7IGEFCTTh+r0Fp6urlqcd3wz24kdtxp7b8i
         iyaIMn6OAjXt3sG/ACi6LtaDLW8jZgxwdJIlSIT8O2Q9mxvENwGUuzuKHIqgj8iilW1i
         2SLq1uV6Tn1HL7nOinHMCaiptRS6up5VrSbVBD6C/60zOdMa9I75FWjrCcTaeER570Wp
         M5cZFFrBVR4ts6+pQrK1yQpvsndKxhi444gkiqQJWs4mSYrkCc6LFaSTVUQs4b3Ue/VZ
         Yb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792407405; x=1793012205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NeauCzO5ecKjHDuQguGvUZNFFmU3DC+5tCqSrByEIF0=;
        b=Lf7L/3kYqcTAlEOk+zi/g1upHUbjLU7yfJnrBFmnh2mNCGFFZ8RIir9LAMoJ4f63nn
         BCtB2AZX9RVBRG+5TnrlJXbK+GDhvx2DBZ5p2orAs7LSP0xgptcucdUpqguOa8HbMNk3
         HssKcJ6vIZiu1OpKwjFyxSlDxyNarDU57S0X2IQQtpp6EHs1jb+j+c6HnuPwzz5JulxJ
         LjKD+Rg3m/NW3iErp+CP1R4zTAbBadvbhKvmCQlIIg914f4OsR87CfPbS4TsYIvLJy73
         KCnGiv3HClPhmnWEcR6mE9Voht8DvIl0wrvrA0VX4Q69py77lhnr3iKZOkOP083+gLrc
         2OOg==
X-Forwarded-Encrypted: i=1; AKwUvByYARD6NAyu+4kRTpgyb2rg3n6gbrSgsg/uTOZSUtOoDLnysE2Uown6jMNsxtmOX15oDao3PHXYrg4U8V1TCQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYI9aqLNc3pqTr9QVYryXgC7HFNAypVwuEPfSAUHclf0Luo2yyOy
	Jj61bh6fag80hKusxTEH4CLBN//ekFiZU94t2nZNXkGIwTGsOotNk4Ui
X-Gm-Gg: AYBFou2kWFPI74KsIOTiJfkoIEjms9yHbzbrRShXmGYrhU8dxbergrx//Y2coHGe9vb
	xIfj+hJPdxwz/wkGH8jxQq/gDVkcyonljehunmkQpWTet4DJC3V5y7HZ20CG/qUqrxUp3KAfh4k
	eUX3pKvkqyZ49hBHP0tghFXozcW+xL/nGoJLwlA49hf1Fnv8nA7sIBuYs0LBQD3ceqPBazrlU++
	rHOC5up3Cn6C5zJK2CFw4ZlLm62LHjT8Vacbor2APmQSmiw0KsECw7beZHJKYsNuWka+y1ulUdd
	t8FDMQY0xpP3U7gea/S/FHlElLqPfVCFM9/7xk6748rnlVtScnMYhvO4+RN1ohRqJ3raHH+yO1n
	sT/kLihaA1udMV2pUA/dFcDOCMcLdwgOFsAIlQSPJcVWsL2MtZLI2z3LrR6b2Eu9jnFIdhU0uVW
	6GplzSD3PIBoNYzETolQahU/rUF/Dm68M9zrocu7dZt+iEAqh2qnuo1s77ZWT5hgh/vLb+SHDq2
	+l3
X-Received: by 2002:a05:6000:4915:b0:48e:d7c:4bc8 with SMTP id ffacd0b85a97d-48e0d7c4df8mr11376386f8f.7.1792407405195;
        Mon, 19 Oct 2026 03:56:45 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd5128f1sm22740936f8f.59.2026.10.19.03.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 03:56:44 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in AP mode
Date: Mon, 19 Oct 2026 12:56:43 +0200
Message-ID: <20261019105643.3282423-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f4aea8175e4f4082afd50fa94787137d@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-19, Ping-Ke Shih wrote:
> It'd be better to see every count stays on the air. Will you implement
> to handle TBTT events? Can you share a draft first or a separate patch
> (e.g. patch 3/3 to improve missing count)?

The USB chips raise no TBTT interrupt, so the countdown work reads the
TSF and queues itself for 10 ms after the next TBTT. That gives a
download about 80 ms to run late before a beacon goes out without it;
one later than that is still followed by its successor at once, as in
v6. A TSF that moved by more than a beacon interval, an IBSS merge or
a reset, restarts the schedule from the TBTT ahead.

On the 8821CU the downloads land 13 to 22 ms after the TBTT; with a
60 ms delay on every second download the sniffer saw 9, 8, 7, 6, 5,
4, 3, 2, 1 for count 10, with 95 ms it saw 9, 8, 8, 6, 6, 4, 4, 2, 2,
and the AP switched at the same time in all cases.

The idea, on top of 2/2:

	/* csa_start: the first download goes with the TBTT ahead */
	tsf = read_tsf(rtwvif->port);     /* 64 bit, 0x560 for port 0 */
	csa_tbtt = tsf - tsf % beacon_int;
	csa_queue();

	/* csa_queue, after every download */
	csa_tbtt += beacon_int;           /* the TBTT this download is for */
	delay = csa_tbtt + 10ms - read_tsf();
	if (delay > beacon_int + 10ms || delay < -beacon_int)
		/* the TSF moved (IBSS merge, reset): start over */
		csa_tbtt = next TBTT after now, delay = csa_tbtt + 10ms - now;
	queue_delayed_work(csa_beacon_work, max(delay, 0));

So a download on time runs 10 ms after its TBTT; one late by less
than ~80 ms still makes the next beacon; one later than that gets a
delay of zero for its successor, the catch-up of v6. Nothing else
changes, the download and ieee80211_csa_finish() stay as they are.

One thing I do not have: the TSF registers of the ports other than 0,
for an AP that comes up next to a station interface. rtw88 only names
REG_USTIME_TSF; is it 0x568 for port 1, and where are ports 2 to 4?
If this is the way you want it, it becomes patch 3/3 of v7 with 1/2
and 2/2 unchanged.

Thanks,
Mehmet
