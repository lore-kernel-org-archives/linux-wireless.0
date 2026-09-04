Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355F4457CF
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516179; cv=pass; b=Y4VnuEWYRR0IoGcI6MwRU/E6ihsq5Z5c+6E0r0Na7oPd2SDD7zo/78Hm8M+U74/Rww+Phxg7GbkBGtyvrYD/K9N6HZ25+1e7lytGRp418VT1T29SCJ1jlzSH6BzB8bKdRuRal/jpEZnltI0JKWFsA6/3pCgOTcj19vhVK7a/ttQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516179; c=relaxed/simple;
	bh=pGoGbVBqnS7ahsUTccYh7tweM38sVvHORJEsuLi6cdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oVQ3IwiBQ0OnKoRPMTCEn97/49ZPtPRD0ABd9lJ69GEfI2RH4gIyvVDwO3ojwkZeyR4D9U2fOjM/5Gxn5P5TEk6DI6Nt0iVhEK8MB+J6KpvEBzDSpATXFsMCvBNcgCI5jA0GnKX6oCHFUtot5SZgdCRFMQnSb3I2lhEg2EFWCHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=jP9yFlcA; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="jP9yFlcA"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-865bdc6ed72so15036357b3.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 03:02:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788516177; cv=none;
        d=google.com; s=arc-20260327;
        b=ot86pMRezSYHDl8zLgx2FssvT7obtEl9fgK/U4tUHKQFP8R6ve1nixb3j97zffIQeq
         mo75mCY6xJIovan40EezNuCYG0pfOAyQ2ln9HyyFqNo41mbMGhnNgT7tpjpPZSuYU0Yn
         vYA/BPD7yfl6s4eXFgl8xVIxGFtWWoBJQkEwObZOPa4ZKS4qM2xgGB+Mt6K9+PhKLgJX
         Nv6ImFNCqT8iv4KP3ipylsOlAi3rlPtBK1dBfSase+0HUoxOZ+QS6G6/kIKm6iF55Gy6
         zkyeXpsfuaWGHWx1nkaUeln1PXRnzoSsbCjEDKmGnbP/q7Sy1kVyIRh9acBwzlAMRnac
         TcmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2+GpUgl5++J4Epmro6ZyR+jhCCz6gXnnAuRdKBDV+cg=;
        fh=i847w8/GjPHkxOu2eKCyAxBvYHGhotaJJtx/YY1Gn7E=;
        b=st2XRZOJMLajKPJ5C3aGloceCS8Xg0kHUl/18X+S5zaaBlA5zeuM5BPpiWe2slRHc/
         DNY5q8GY8750WWgKJf0lszlQLK9iwCXN1vn7CC5XlNfeW0v3X+oczkNDocKl5VxvH7sd
         YHfzPOGgYl12sQmt+g+GP4BTTwBabROEngxWwvG2fc90o3uw3UU612S+ph6zARcfseMQ
         tVUj/5ctPnvo9fjhtjrlFPvw3MWwGTL6+1OAKYbS13SaSv/NSkztDSPghv2xHYy34sdt
         pgJ8gJvpK8toqvsJ12UGxV5WWRf6nZa42cFe3d+je0TltpqYz9+u/TmvzxDdGyhnIfbt
         qkCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788516177; x=1789120977; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2+GpUgl5++J4Epmro6ZyR+jhCCz6gXnnAuRdKBDV+cg=;
        b=jP9yFlcAHUmRe1MW/i0OorVSTDVDeAEh4Zz6DxAhudPdP62UtAdnM25Ue20YXZzvWz
         JbWEUKC2JFRDZtPVoviW0/ZpbZ3+/rSZhbx7I6PwhJqD+IWJz05cfqRo3eGYuolZQ0SP
         Rl5qu5CCIQ6wixi/GGnfoXYLyIQSPiSxeo5wOQntOygqlUIwuZ3KME5QpEOApCCBJaE/
         qtGETXS3MtQfhEBDO5tdO9eq+BTvgFwcT206gpkNQIX7iH6dziutr7l1IVaGW1Wv4QB3
         VhWdy2bz/G7iBgc3kHywt21RAI0z3G4Eg3QivubV3TxI4facw5wHaGK/vdBbhXqZoGVk
         liIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788516177; x=1789120977;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2+GpUgl5++J4Epmro6ZyR+jhCCz6gXnnAuRdKBDV+cg=;
        b=Am8kp9SyToXBrjUJ78/B5EBPXCdmWArgZ1EtN1py9HCPl74OFVAt3IBqfJezKVR2IY
         vnBYlQ5v+B3L/7mvWcNZIcrSzbkLAEkDPSS/AT+OuF3wHRgT0OQMZmOxlMlH49hrIotj
         necaVoNarR52rJcxCnDOu2N9aciy6LkrwlPHhldruqsS+W1XMUVOHuSZfzCBCF7qeOWT
         TPD8r1rY4gs3OqY0PUEtX5JcX2a/Xy7PnLyY7XF57agEgz/ivKAUxhqcn/XCDvuEFqKw
         DeP3+oFxJxGv8YRQ2fvP50fSuzQPRhZVvqSY3Bkpa/9RGixecjSdZjQt0i3Wj/oVt5wE
         5oxw==
X-Gm-Message-State: AFuF++lzV7Scf0V2iVR5zXdlYlzv4UslHMen8XlXiuHraT6aicbi17uL
	Xy0c3rJ1FbrlQPowBCtea/N6phCFl8+f6nkqnpdY3yW84y4Y9G4egAljUgtc8sr4Z2mSZNwSGYl
	vTBSQYaEwUv2oOQbHOB5vJrRFT6W92M6PhDZ/6GMh
X-Gm-Gg: AYBFou05XSdxrRSNcNCRyjOVVzlHjQMLvexZadEa2/fEuAxRYH7bAe+83pexEgb1vqE
	c76QvBhFVFZ8U0bC3Xer6NoNT4YyOvSM84hkevElCzj4UMRd/ZOZOZtx9e3Vr2hsB9vJdMpUt9d
	F3yJX4jtlWNH9Vctsi3HzgGc5PrOE5X57TniKfyfAVVB4WJRZV5v+LtcAk3VK5SibNloT6YA57r
	A9yAYAC+TEVlCV3EGMeJGzvrqb6krqoeYeMmYFZQ/+Pwod2VhBm9foxSbMQWjAlbbJcZSVI7IO1
	icXHs22FPol6m79OA/o0VErq2oz2IxrU9wWXibQjYp/U/M940Fvi+oKhTqazGu4qsQpZreV196d
	tD2AqRppcVA1SgBdtmvFES+NmCyw2znWSgx9sZ6X3y7sIrK3jD/GqkYt7zhxqS7VTGJVOj/cIvi
	2qLfsEJ9wjdk1r1VZeDJ+bU3zmHkGDTb5PiSEy7ogpSlgZONjiP5TUpuT/lIBCJcVGPEni6t3Cq
	G3/jh97bJk1G9FCF25VQvyMXs4CV1Q7Xc4sHvQibCOkTLkZ6eFG9E4awt73ccVzlXud2iJKu2uF
	ZFw=
X-Received: by 2002:a05:690e:1c05:b0:66f:7d51:b5ef with SMTP id
 956f58d0204a3-66fb5922bdemr1736338d50.3.1788516162221; Fri, 04 Sep 2026
 03:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824142435.1757391-1-julius@bairaktaris.de>
 <b61760b0e284898db3dc3c7856da128ba637330e.camel@sipsolutions.net>
 <CAC1t37JMHWHNfEfK4+2uMj59+rkQATftmohmxnYM63crYGWysw@mail.gmail.com> <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
In-Reply-To: <6d033c71732e8ad2df4abcde1d38d89e2536609f.camel@sipsolutions.net>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Fri, 4 Sep 2026 10:02:03 +0000
X-Gm-Features: AcwNN1XeIT2jV2Qom9JnBJi-JPGN4JQ3k_alBzk5JtpNb6DRpWFUQm8Frc1zkWc
Message-ID: <CAC1t37LF9Y=s23DNXmg9WM6sV+ENg+hTNgRNiW5ZMEwqx9CZJg@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: scale the airtime queue limit by the
 station's weight
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, toke@toke.dk
Content-Type: text/plain; charset="UTF-8"

> ath11k doesn't appear to use ieee80211_next_txq(), so it doesn't get
> this and then AQL doesn't really work, I guess?

ath11k is using the generic handler

    drivers/net/wireless/ath/ath11k/mac.c:
        .wake_tx_queue                  = ieee80211_handle_wake_tx_queue,

which runs the ieee80211_next_txq() loop itself. What is missing is
the AQL feature bit and the airtime reporting, which my series on
ath-next adds. The numbers in this patch were taken with that series
applied, so AQL and the DRR were both active when the weight did
nothing.

> But for a driver that *does* use it, I believe this change is wrong.

I agree with that. It would have to be gated so that drivers like
ath9k don't get it.

There is also the possibility of dropping this change and letting
ath11k pass the weight to the firmware's own ATF, for which the WMI
commands are already in wmi.h but unused. I haven't tested this yet,
it's just a theory, but mac80211 would stay untouched. What do you
think?

Julius

Am Fr., 4. Sept. 2026 um 09:50 Uhr schrieb Johannes Berg
<johannes@sipsolutions.net>:
>

> On Fri, 2026-09-04 at 09:46 +0000, Julius Bairaktaris wrote:
> > Hi Johannes,
> >
> > > airtime weight is already used to select when the queues are serviced,
> > > so why should it be used for the queue depth?
> >
> > While I used AI to help me write the change, my understanding of it is
> > that on ath11k the order does not matter.
>
> ath11k doesn't appear to use ieee80211_next_txq(), so it doesn't get
> this and then AQL doesn't really work, I guess?
>
> But for a driver that *does* use it, I believe this change is wrong.
>
> johannes
