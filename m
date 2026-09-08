Received: from mail-ej2-f0.google.com (mail-ej2-f0.google.com [74.125.228.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779B30D3F8
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875608; cv=none; b=BfUVKxTRyXr737Tc6yxBfTTMSrEDd9wJZcITFAgP+DmAoggN1oTL8/WobmCe/McgNidQ3WhtHn9F/FTB9/t3Lu8IAIDtPckAguwjrOgCDfN6Aq5KhQdUzltvk6gaIp40Djis+4huF9gNZFcQdkMoJIZuwlxVp95Ke09K7euG2Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875608; c=relaxed/simple;
	bh=6w10aZtWST8dbz84kifnCLebTQ9jm98gnVTiM4xrOP0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLHgLZ48j+mh/YI+T+aPKcefDUMd/VIRoOMW4O6Rp2onD+dcoR5xW1vkJdXAfXpAYQ6TXTmhGzNwsvFOtOUCKHuUYue8BWBc2+Xa+1E+9U7J4igDfaFAvNCYGv2ddRs73QEnL8Aw8hUHl2YFWBuWT8C4KNZ7ZNaR5YzbHBISJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=nTvQ6NkZ; arc=none smtp.client-ip=74.125.228.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="nTvQ6NkZ"
Received: by mail-ej2-f0.google.com with SMTP id a640c23a62f3a-c166aef4f02so257804966b.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875596; x=1789480396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hU5tuogqGwKRQUNVBPxhclsz/TR0S3nVsec30dJiAaI=;
        b=nTvQ6NkZ+3XA7C41if/tjjD6mNz4pdbsC9VIYCcDE/0Wdq9FA2Kf6TeoN2BByKsgKm
         k12IX/Pj7yS4mwpj9RduT5ceEOpiGNaHiGMZKF3JN5NE3inNvc0A5PT5+j1XhyZ1m9QV
         wF3l/E8RH3Lcpdehz0EIQuNcRAm1fDN7CgUERDm2r73Z2425fsXqa4MrhVxRuG/1odET
         eXoTSNKYghZuuNg3nV3H4OqxFO5AVHHbyQCF4cq0mgHIdBtCLuUqyUyYSWtBHMVBKawz
         1KczOACQWzV8E/hDrl4rGZnktdyocmYwP8oCLuxmfh9Cpy7t1kNo5kiZ7rHN1psiQZ3I
         BBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875596; x=1789480396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hU5tuogqGwKRQUNVBPxhclsz/TR0S3nVsec30dJiAaI=;
        b=MPqXavV7pvRF/kh8pPXL3qT6kvnwU2rkS53IdVBs5StJChD8kwspT1CR6rG8yRDhQL
         G2pWsh3Z5FHMn25kCqTLUxMIGX4d4w6srfKmoC9N4ePQzV+6pmyamrod2RTxwBfEDqIm
         fAPuCV6Dm6FXRXfJaEYDTP4SsLXHHofX+lK4tldc9fiGHssgMTVJU3JDLByNqQLkWkm6
         otKW1AbvxJqAXr53ECi0r1r3BbE/nUolpdTiBCBVy9W02IG7yO+sI9DTJzPUcnEQIJsn
         0nKWc4g0gi91rl7+3xHgymt2iKRGO9R4z+KwFkJa4wyZHWaVwcD14JGdygLxy3N25NEE
         FS2A==
X-Forwarded-Encrypted: i=1; AKwUvBwrc08O/imNcpVYkcGM9E5wRyXf9KSKVPV695uik+sVU+cX3HT9630mQIzZlqZ4bPfCIahbveynP14UPtEhlA==@vger.kernel.org
X-Gm-Message-State: AFuF++mUmT+Q+rbOPuR0jupKuhbLNuhRXeMZUtcm/WcNrqctwi9/qozI
	bN6JtnFxbQNr4NZXbfh4rOnFJJwwNSyTecBkEkwb/hkbQkJigdTwnlWcbm8AmLzS1w==
X-Gm-Gg: AYBFou1DmA5SkrQKtJm/9Z1WcwszN5edsqX9EhoLSaoh+BM2HRr13j86s6aqemCd0RR
	sRHrCETNbfQXuTOfmdl4Uz0icwUZa6/VoVa2rzBeJzC1MBASqBQH70ct14TRFJF9Mee5EUa+DEC
	cH0+P6ZRSRf7hJ2oE5hGFB2aV6GXskJA94eMD4Ib36OKOznkYGSv2bQ246W0MYTVNlNkQFrhLxY
	FjjVWG6kmQYdydBDiJ9y9tH4Xml38YtD1QRKq9hpI1Fizuf1P3F7Ly49y6P02BiYkbobnUj5MZR
	HcXqI33BzLXDUy+jw6csFzsPTJeqCHARbhQ+PWO/0F+TgZO4pnQcsHHlj0ex5ibngH257cuELW5
	f1cbMmeaKtmAty6NH/YwJnJKc1h0F6Ef2p8P5xpfDfJiS7XJ7KLzw1/cgrfSwB3JY3ZxDF4UxLs
	etZt9XYGEcfzxoc5JDGyauyZvXtSqwCGt0VMxmwnZEzJXOtRf6r566nAaRasuZuxHGLzXPY923M
	nKi/uAblzVCqUcYMgdFLUwzbER+djhKr4deMPo8OiKqyUAAVp8xINDFzpOU9RuvYnY3QivGRSGz
	VBQYIX8yb9sufgEmTY+CZUArjIKUsACq3BIOqBG4OoP3xBZt4AWTxBc4kJh78jxm67wSI6rSa5y
	u8+0VyfAGeQoges00GPe77KBXigdhCFWxayS/7R5PCiS9Rn7zTU25iSifTHY7R7vcYydi90RCK5
	n2WFgAOJ18Wf9u
X-Received: by 2002:a17:907:c705:b0:c25:62db:772b with SMTP id a640c23a62f3a-c260c8b141amr1140230066b.7.1788875595843;
        Tue, 08 Sep 2026 06:53:15 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a9cbbsm633598166b.13.2026.09.08.06.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:15 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: toke@toke.dk,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the station's weight
Date: Tue,  8 Sep 2026 15:52:26 +0200
Message-ID: <20260908135314.754063-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87tso5tf12.fsf@toke.dk>
References: <20260824142435.1757391-1-julius@bairaktaris.de> <87tso5tf12.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Toke,

> So I think the reason the weight is not working is that there's no
> pushback from the driver in the wake_tx_push_queue() callback.

I agree with that. v2 gates the scaling on a hw flag the driver sets
when it has no pushback, so a driver that pulls when the hardware has
room is not touched.

> An alternative to this approach would be to impose the global limit from
> the mac80211 side by refusing to dequeue any packets into the hardware
> while local->aql_total_pending_airtime is above a certain level.

I tried that with the knobs that exist: BE aql_txq_limit 0/12000 and
aql_threshold 4000, so only the total decides who refills. Same two
stations, three runs per weight, share of the HE160 client:

    256:256   40.4  40.2  41.1
    1024:256  44.5  39.3  43.9
    256:1024  37.6  35.7  36.6

The weight does not move it. My understanding is that the deficit is
topped up too often to be scarce:

    net/mac80211/tx.c, ieee80211_next_txq():
        if (ieee80211_sta_deficit(sta, txqi->txq.ac) < 0) {
                sta->airtime[txqi->txq.ac].deficit +=
                        sta->airtime_weight;
                ...
        }

With my ath11k series a round runs for every frame from the stack and
for every completion batch, and every round adds the weight to each
station that is negative. A PPDU charges a few thousand us once, the
top-ups come tens of thousands of times a second, so a deficit is back
above zero long before the next completion frees room, and the first
queue in the list takes the room. This was measured with the series
applied, so the round frequency is mine, not upstream's. For the cap to
work the way you describe, the driver would also have to stop starting
rounds while the total is over it, like ath10k does. I haven't tried
that variant.

> The main drawback is that this means that giving a station a higher
> share of the airtime also translates into worse latency for that station

At 500/1000 I do see it now. Ping from the AP to the HE160 client under
load at 1024:256 reads 18.1, 25.1 and 19.0 ms mean with the scaling,
against 4.8, 7.4 and 6.9 at equal weights on the same image, and 4.7 to
34.2 without the scaling, three runs each. The favoured station holds
up to four times the limit in flight and its latency goes with it. The
v2 message says so. That ping goes through the client's own txq, behind
its queue in mac80211 and its limit in the hardware; a probe that enters
by another path lands in a TCL ring the download does not fill and stays
flat, which is what the ath11k cover reports.

v2 does that with IEEE80211_HW_TX_NO_PUSHBACK, set by the driver; if
there is a better way for the driver to say it I will change it.

Julius
