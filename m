Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793423270;
	b=2iPLDMsvL8W0tDe1y77dmRIrVKoc7NFQ+YeLyLyaKB2/3sGR74E6BKIeRdN9BWjgFiHX
	 6mkdsaU6Zk0U55zEzCoZ4ZhcoMbOCBNOGlGPMhMZEFugrwETPstzMtHsP/Bhtwk92PyUv
	 uSnWkHN90rnTOEHIPBCGbxwZx14qOJGMoCrs8XZQHfQpPEO4AYN9zAMvMLecol/PPLzSu
	 8Vr6JgVOWtcQdtPvsDxv4aRhS6kLdKky7Iq5aWnLqM3kO2X4PYQfYb1pu5++QDi6Rg7Qk
	 9T80P3Pm1EyWgEz7P6D425VqIryG/McqvLyrIphKUQc60ZOJ7nXAql21tiAlgNy7mng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793423270;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=4xPGkBxnzKhr1mAYdWs4HXPtlmr/yeVfO6PJDI7vDQQ=;
	b=coP82IXcDa86FaYVPsSetuF+9qTIFpQyY5xR/VDufcCFK83nVIQSwY6LqA3QhHV5kQ2Y
	 XEJrcHYg3FEpyrWSLtSKz8oRh1U59Kxq21UKRgwDtwmszFi1nm0C+5ZA0i63NEO9KAqW4
	 9pCvzRl0rJJAIBmieCmO6SnowV6/YYe8AJ58AGPgs62JajI1Cl3KJJ8KA7Xe0jVfQnkhL
	 INJgNsQadLvB/mkOIp7s4rGM9vXkrB88j3Kgys1s7mT5shOR0jTCaL/kpqKRrBowhuAMp
	 MbDldt7sY4PKl0rYtR2ala/YaY5gF4WdlkM4nNv8AS+DbRiSznvF9f7ORnQ88uMFA+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OykgOQis;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C56D606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 05:07:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C56D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OykgOQis
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-70b875f6f13so1279195eaf.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:07:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793423269; cv=none;
        d=google.com; s=arc-20260327;
        b=hZtiKlR2otrk1GRHzP9TpG53n5UGdYgMTAQgq28zlk1E51/cyx4mTXp6tMQmcWVEWU
         tVO9DsYbqShRlcbllGPLhB3qVcscfi6ba723Tx+/ckS3kbLTM94VldL4dmy2ONTp938d
         dl+S+xIMoQINLOzpBUJPMpq24lwVjaklzvC7Y9YRt8rQKQCcWdf9RTgSrceGalKGrEln
         y5ITD6xyhfciDXS4O4G0EwHx7VuV2CKT9YWK9hbVFgCrc/6ZANlOS82mYuhezCRVo0sZ
         2JVVmMJe8JJUNUZr/77ARzkIox8kHcBMIm3/cAMQQ+adR0apbqkB8dlJZEdcWd+bSSn3
         ioQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4xPGkBxnzKhr1mAYdWs4HXPtlmr/yeVfO6PJDI7vDQQ=;
        fh=Mn1rxSbARBnAdzGyOHrXlaaUEb5vYHVN7fbnJ812Sek=;
        b=YGiDbi3b76O0GzN6ksIxDJZ1N/MK1BUIl77fya+WQc/BNF0wjNgQKCzWUEckAbVKmN
         GbW3RtpgT+MBvVZjMpUrEo2/XKr7dzJ3hk5IKGq7nh906OTiQIX+ENH8mkw5Bdmvum9U
         OupyTsfypTn4sT0dsBNph0IO5BOY/HEIXWN5E1apMftEv/KlQ4ZZ7+ztRNveLwib/OPH
         BfuMguaS33LsgsAYDBsaTYUpP954YMvOg1ps8M0+ubTqm6S4HuwtnfVpi3i/oyWaygPY
         QHTekRGdPUCeNLNnSlQ20CavxNSodw+kB0LS0bhgoRK8MItBQYKrtDsR3GqHrKOaDTbQ
         jJ4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793423269; x=1794028069; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4xPGkBxnzKhr1mAYdWs4HXPtlmr/yeVfO6PJDI7vDQQ=;
        b=OykgOQiskyX99Ykm4FkhA488rT49ru7Dl09rElYQzgDrZ25rxKI/g9FUvEUc3VkYu3
         4z5hy2VOchuiiuwz0v31HzyftMT8LWGgf6Z9kq2m5GPY3GlszasQ7VJCXjsN5Yvk4gfh
         FU7+PSLrtbJpZ2U8DLMfLbiTZa7ztBBV1rQLk5Qi1zTGUeSj12ZoKCbD9X2yf0eyFMPP
         T0huHPiTo3TJqtJx21MBEUF3hCKjHSB19a6GFWfcwu2/jVCakk7YmO6x7vQnzHUDd7l5
         rtNEJYMVbNv6py5Qa3YykjK3EwRkOF40rIErocbTdZIzk6Dl3YzGcEfSErHpCqd7QxVR
         9etA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793423269; x=1794028069;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4xPGkBxnzKhr1mAYdWs4HXPtlmr/yeVfO6PJDI7vDQQ=;
        b=F2vBZvTaFASUjiF+XWIXnHIiaoTg0jVsgry/jV//4NQk7ExO4lzpkazXbOi+e2+FeI
         ywFc39ehjD9xTPqapqfYKuActW9FtLxbZ0N/8c/RjzptKplGINodaViwDNvQR4z/I5Wn
         hqXizof1j7+5eEfteJaqK/J1CUJbFFz74f0NHfVj7FruvC77Nh6EgMJ/GPxlF+MNghAP
         psvjSzNpdkg3J3+u0QXeFWmyIsSvcCawpNrAXOnklMryppQqSSMZnyK2QPQCb1TBZjyt
         Qld31UZ/qUH32KW3qkzuPByQ1A5QntM8KFuuHeugL7QZ7OKMH+UQd+Sz9vDJj+y26ToW
         9vuw==
X-Forwarded-Encrypted: i=1; AKwUvBz7Oho3RsRDodahYY3r8ExuRSBkdbizoJrkbvVC6YqC6F12/FpFk3Q/toXe3jQTuWboFun35HlwNLJ4XR9HpQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJKxBcYRatWVorRiuNVnYP5MKtrQQwBd89LvTi/Is1l7LY/vhth
	MS312udDQUO+dUIp7yLiZsWe9DviObmOrHkagfpSjW4Opm6nymOo53f2YZ5hJOHEJfCPydPS1Wc
	9whd51SPHmqbru8mnbmu/uKaEHZe17cQ=
X-Gm-Gg: AYBFou0Uf7qGq2zHekF6PZh7PyQf38GZ6YXMfcI9Bt0Qmj0rCM1gBHIVcThykTcen2F
	VYWLmdlgdB2Y9FMGyS5SgBTfB3scj+qvlVavmJkmQ1y41y3dG1JasZI9RzDTvBfUAbhvGihQ1Fw
	2Ks3Igl42EuiBt+MZtTFFmO9q4zBI6PyIJg3xudSlPSCAfkw6TQqlrlP9u91D6icvTm7SDygg45
	uiwc+8ymBSjH/Ta42eOdO+V4ht/PQT1zuR3MqK2B1jxss78i1s8blp0tWC1YW1t0rMRvGrqKNH3
	JZMHWfLOizWMrFKJdxIYiwZjTAhBUpr5ZzQeArxDeXq4nJgzxmbzi/y8DgFiwMwcWNUH+K5AaKF
	A+GsP72rzaGeFrZ8unG7n+XDCoiqEmBSgQtddRCxz/iKMt9rsi3ftp+BPrZTNy4GKzcBY7m8=
X-Received: by 2002:a05:6820:1381:b0:708:f388:af75 with SMTP id
 006d021491bc7-714f24d6463mr2635651eaf.46.1793423269265; Fri, 30 Oct 2026
 22:07:49 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029055212.84711-1-hjf3108@gmail.com> <20261029055212.84711-6-hjf3108@gmail.com>
 <15240b8b-31f0-4587-a7a6-28cd4d36775b@gmail.com> <b54683e9ddd81ae2a4f08ed4a8dedcfdb0209a28@linux.dev>
In-Reply-To: <b54683e9ddd81ae2a4f08ed4a8dedcfdb0209a28@linux.dev>
From: Jie Feng <hjf3108@gmail.com>
Date: Sat, 31 Oct 2026 13:07:13 +0800
X-Gm-Features: AclHuK83JN6Lp4VNyVZJsLR3hJnPUKeNGV4ZPcMI1iUesB0qxDAv_D4xNoibJG8
Message-ID: <CABOQOSU07_zFFnea_1th-RsOpjCJz0tqt-Y3aHngj2D67=x6fA@mail.gmail.com>
Subject: Re: [PATCH 5/6] wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 Oct 2026 at 02:16, Luka Gejak <luka.gejak@linux.dev> wrote:
>
> Hi Bitterblue, Jie Feng,
>
> Thanks for testing this Bitterblue. I had a look at why the scan gets so
> slow and I think I found the cause.
>
> October 30, 2026 at 3:57 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
>
> >
> > On 29/10/2026 07:52, Ho Jie Feng wrote:
> >
> > During the scans I see a lot of "timed out to flush queue 1" (and 3)
> > in dmesg. You need debug_mask=0x80000000 to see these.
>
> [ ... ]
>
> >> +void rtw88xxa_adaptivity(struct rtw_dev *rtwdev)
> >> +{
> >> +    struct rtw_dm_info *dm_info = &rtwdev->dm_info;
> >> +    int igi_diff = EDCCA_IGI_BASE - dm_info->igi_history[0];
>
> As far as I can see, igi_history[0] is not always the IGI in the hardware.
> Since 3f90942473d2 ("wifi: rtw88: Increase the RX gain before scanning")
> a sw scan writes IGI 0x1c without updating igi_history:
>
>         rtw_core_scan_start()
>           rtw_phy_dig_set_max_coverage()
>             rtw_phy_dig_write(rtwdev, DIG_CVRG_MIN)
>
> rtw_watch_dog_work() skips rtw_phy_dynamic_mechanism() while scanning, so
> if I read it right 0x8a4 keeps the value computed for the associated IGI
> for the whole scan.
>
> In the 8812au vendor driver these chips are in ODM_IC_PWDB_EDCCA, and
> phydm_adaptivity() computes the threshold from the current IGI
> (cur_ig_value) with the same formula as here. So with the gain raised and
> 0x8a4 unchanged, EDCCA seems to get more sensitive by the difference
> between the associated IGI and 0x1c. Since rtw88xxa_adaptivity_init()
> clears BIT_DIS_EDCCA, the MAC would then hold the frames.
>
> I think this matches the flush timeouts quoted above. Queue 1 and 3 are
> the LOW and HIGH priority queues, and mac80211 flushes the queues every
> time it leaves the home channel. Most of the delayed pings also came back
> together at about the time the scan finished, which is when
> rtw_core_scan_complete() writes the old IGI back.
>
> The 8812A beacon loss branch in rtw_phy_dig() switches to DIG_CVRG_MIN
> after rtw_phy_dig_recorder() has stored the other value, so the same
> mismatch seems possible outside of scans too.
>
> Jie Feng, maybe something like what rtw89 does in 280c444745aa
> ("wifi: rtw89: config EDCCA threshold during scan to prevent TX failed")
> would work here, setting 0x8a4 to 0x7f/0x7f at scan start and restoring
> it at scan complete. Or rtw88xxa_adaptivity() could use the IGI that is
> actually in the hardware and run again when the core writes the IGI,
> which would also cover the beacon loss case. I think this belongs in
> this patch for v2.
Thanks for this, I had considered dropping this patch if I couldn't
find the root cause of the high ping time.

> And one more thing Bitterblue, is there a reason for your email only
> being addressed to the mailing list. I am pretty certain that the
> author hasn't subscribed to the mailing list so your test results
> might now reach them.
>
> Best regards,
> Luka Gejak
