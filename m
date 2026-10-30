Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793360062;
	b=lcijDKH4eG6GWlfClJtwUF5MkEyXS0x1Jkg7XCIBOSUQzn2hGknHIr5eNqU0ZB2mVEko
	 zyYZzMtEEsrgS5488l2XshZCYRelKhlYzz1kcfwhCFbuPoSVTVGtIycXsLrBNFmUecJW/
	 Whu1765OyRvDoBczHX7NJwEPs0pGBjHoAJmG3f25q1EAsynDPhX3SlbbkSWtp69b8Qhps
	 sKmMi8qyvsFV7LhAoE2UAXpS3JaCrPo20V4dMaxGjRvY/EtU6CUwURxuqKHNbSLZRwLz2
	 nG8mDOdxDnTlWvQLJCL5XR5wnuo2zLwz9Tp5SUt6buW4MXENslGOB2rbN53+lvqj4tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793360062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=CJXv3k/n7KXs20ZCrHngIKsI9Ju9rPGpQzEVjeHfCaE=;
	b=qaA0kp88gt6x9pKOhVvxaGPEN+CCflafzhN+7P66qLWDvAY3FLIuAOFzo04633cXKEMx
	 5Ao6okrMLOd1Zs18KuMyE3uHyC00ZnzIRimBH240guVYVUsSidnxa9JXNNGX/KrtZB/4s
	 e/ZXv04pJ0mD7pVQc8wEjZVXeD7O5KwycupCzS4T0iRRRiIVFdX9Ar77yZ59It/x8Sup2
	 9Z3jM0mcsCNUBg1GltGu8ifIbjjuoEqdi1BWl3P/k5F+6/+NkQsQyV2869tJqOx99xX9D
	 jGfg0YUqUDRqPuwa9UYf/ofh2T1sKKxOwcmzGVQwXdGl66KX6teZvXsnW1Z0II6lhqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FE2zVtbx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA01606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:34:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BA01606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FE2zVtbx
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6b19e291cc6so559910eaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 04:34:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793360061; cv=none;
        d=google.com; s=arc-20260327;
        b=KE0nJIh0FLWMmLaUxryg24o+99RL4hB1BYbKiWh4BufUHlJcwEqjL5RJoPT9c7YwZO
         geoGwTyoGlk+GejBIHfUCnKt04dxCnz+Y4rR2DB15Rsq200mHdihzJ/cN66ouhE6vp94
         xh2oUwtodFyrh9jX0LLKbDKhai/aroIU0ZrNai0eh1ZABj2CyyH2gSnRmRMNNgBc/OFQ
         1rykHBf4IHq+U6IfHkhnMVxuN5S8y1U7QHviOaAGXub8IuMIdR6Q8jZ8EyaB2ZcTAAS2
         4SW1kqPRPypVTvHF0epzPTtrEKZ+vNEU7l7OKcBzH8MS1rzgjUyO77McQp/2ZqZRQljo
         npIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CJXv3k/n7KXs20ZCrHngIKsI9Ju9rPGpQzEVjeHfCaE=;
        fh=f9hFQUVjbQq8USMzmbA7B+6DLDxgXYGTKGlXxISsNwQ=;
        b=Gp8jjL5DLOfFSSBllk2xCezb3upw1l5RHm0nLQcMi/6iNgcTzeOGvDdtyTJkl1OdBr
         G7Z4n0fG9lBcH6HfKwARdrIynjm8dKs20NhaFjFJF1pCqQ7vtrmBN7zqL9LVVcTv/n6W
         gI7KoiTCEiGd4De5XpcXCYORatAxFFw3s+MVzv0/7mqDtxjaQKZYTzQHCqsXDwhqbr1y
         ZrVPV4P/UblaJOra8FBwvC0sjSrJ4WGkKeBpj0bXemmNL/pdM8pi2816r4n3/Pf8G/mb
         mQP+OF4mR1N963g8XWh3rmdLG4aJOMdQqiqPJwyQrTUoqZwR6WvWAWg/02clEsLPnR5l
         xhug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793360061; x=1793964861; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CJXv3k/n7KXs20ZCrHngIKsI9Ju9rPGpQzEVjeHfCaE=;
        b=FE2zVtbxSuofRjs86yss68iCq8FcHOY4DtzD1sxfY12zyLwIXgYrc46UI5m0U89T12
         xj40d78w2zSXYg88OCXk8N/frh1g1kIYDjEPX0uxjwRuF4w54pxEbg81qS3QJOL/a/VK
         dp4dJ/u+rDZijJZLv2Bb+A+Gy+zrqGpFvgQiMZyzf9ALO72FJvGBHPAbRNUiYR9DMUJG
         hhmGZ9UH7aCWQvVhj17+LUYIYRiqVcU2iqHDjFrdLoldnG/yPKMWBh5ZTpTeKiKQi3RG
         VTyIWNmC7830QD3L6wGB5aGt1imejnwze+mTL/gHDKF79zwnSxSTXS4pZTDEkYpyRsYI
         nL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793360061; x=1793964861;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CJXv3k/n7KXs20ZCrHngIKsI9Ju9rPGpQzEVjeHfCaE=;
        b=ye1bOmm6s7B7PQREljgsbn6LbHXEdKrdLsmTDd28wW/62FVVEOuFrOcJZsCTlRazmE
         9+NFh5ad/G9y02Yi2cWmUeZKb2T9Nvmjvvg2diKauBzkVZnqGSsO4i9eLtR9IDBmYZPp
         eOGYbsYm0RFOm320hx6fan8WcJnJ8RxHif9FkVhbgqK/lK1DW6VPSVUK0EnN96sW/tjn
         fBqTcj9OaQw694E7PgqJVDPz5JASCZdB5NNE9MRW7HpIOhBzGyJ5D/s/Z2fhZWYAA/hB
         MhE1CVrY5McAi7CB/xDyCGFAjqJ5uvAujL1e3IOPQs0ONclZv4S5G7gFPEPZA+zXQk1Q
         1aqA==
X-Gm-Message-State: AFq9FYJ2xaHo+6YeRYQD6ayPAr0oPX1hXdwo/JbckAi8gplPrENMg0aD
	gu4GgjXBFJD//Rjrnc+nCDi2Y2FqKqV38NVHGarvpjrEWKrv1pnkZlkv6jO+Dm2nv0tlK0vE+YN
	zzOOj5E91gi4vLc3Fzxl5zfSvS5FXqwg=
X-Gm-Gg: AYBFou3XD8BnCQpEpQTfgGfB+AvjtMFHiBwYU9qxPoRFo9ZiSBxw01MsPktMRMpHdKu
	CnO+PsZrMepdENEDeTfWqwiT1NhaYGzMmGwpxZElOql3aaZ5YiR/VD7rmkA5iATIij3ihv44QrL
	iEwWCEi4lWUNIEfjlu8GZXHjrWCv7uEVWzv4DfMgDR/W28U4GT2mor4BstLtNfSW+Gx/Z2uCcz+
	PFa+QQ4aNE55i/dqM7WWTLRGX9hJ75coL5zeEfFv3emKiHDy5MtIlokAaedRS1AC7eaEayYL/pX
	zNPfjM+NygH3eWPMohuUnLg0+xyqQW9TIEHwr9o3MCgVRe1Kd0fAc2HPi2US58oCJ+tbyuFUOW/
	Cjx8aNbvH7bQWAvqpJozc1ktMV0hD9ZqdQ93XjBHqchbd/XxYrB6fkMxr+tCiijHxRcDMaXs=
X-Received: by 2002:a05:6820:221a:b0:700:5222:ca29 with SMTP id
 006d021491bc7-714f2a1abd4mr1049728eaf.70.1793360061203; Fri, 30 Oct 2026
 04:34:21 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029134752.1299130-1-hjf3108@gmail.com> <20261029134752.1299130-7-hjf3108@gmail.com>
 <20261030091743.GB27096@wp.pl>
In-Reply-To: <20261030091743.GB27096@wp.pl>
From: Jie Feng <hjf3108@gmail.com>
Date: Fri, 30 Oct 2026 19:33:44 +0800
X-Gm-Features: AclHuK-N6QpbeSEmhZfwg765GOgC1QPRQIYNjXEw7z2xfYb6Cqp8FGOOTtNKHCY
Message-ID: <CABOQOSX6mBCtTTg9eJX665t7tj65jo=9hVTgr7pmFRB6csG2Yg@mail.gmail.com>
Subject: Re: [PATCH wireless-next 6/8] wifi: rt2800: set the mac80211
 fast-xmit and aggregation flags
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 30 Oct 2026 at 17:17, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Thu, Oct 29, 2026 at 09:47:47PM +0800, Ho Jie Feng wrote:
> > Enable AMSDU TX/RX support for this driver, which can increase
> > throughput.
> >
> > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index 032cd6ac345f0..8b4458a74d33d 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -11861,6 +11861,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> >       ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
> >       ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> >       ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
> > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORT_FAST_XMIT);
>
> IFICT this flag will not take the effect since we have SUPPORTS_PS.
> Also for WAP3 (802.11w) we fallback to software encryption -
> that will prevent fast xmit as well. To truly enable
Yeah, that is true. I also have a patch that enables hwcrypto in that case.
> fast xmit, I think we would need add hardware encryption support for
> WPA3 and also compromise by remove Power Save support (which is disabled by
> default, so that's possibly fine).
I think maybe a more general patch to mac80211 to enable fast-xmit when PS
is disabled and not only checking the feature flag will be better?

> Regards
> Stanislaw
>
> > +     ieee80211_hw_set(rt2x00dev->hw, TX_AMSDU);
> > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
Although I think this flag will still be useful for this patch.
> >
> >       /*
> >        * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> > --
> > 2.53.0
> >
