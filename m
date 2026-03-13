Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA8838B7AD
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2026 09:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773393954; cv=pass; b=ptR4Vrblw+Uop3usTQ+4GdwpEE9AYQDijpfJN7pQZ010Z47dSHpotPtpvMAwJBwnbVy+zMwYXgujtFTpMmtWBYiPp36WGUXuXawwUm8CAZCR5Dttqu599WTgtvERln6mD1u3RynJ1JfivpuStZaByMdqMGuGZWfrD6QxbP9p4yY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773393954; c=relaxed/simple;
	bh=R1NwV0LXXc/zvK/w6c8fB48SQpuGOGnBeLroa+NK0Iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L3uMnhn3nFkp4MphHgNiHpUliemavkmAFhLGeUMcHUwxOxMjgyMF/Vz0QRZfcS0zMsJPTy+T1tfKvH3OrTgwdmNHlg6488SFqiErfsi0tVTQow9ZK7FKi2V0Ydp+mOLsOAaNVLS+WDPELDcXdnP4KCUZZnMvHk40iJbe3r6qTa0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HJ0jCcGN; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HJ0jCcGN"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7991db3dc98so19489037b3.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2026 02:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773393952; cv=none;
        d=google.com; s=arc-20240605;
        b=WIq7H3iYCu7GWLw4RDZeEcJjfmoYcJBIVCYZGRmxbKo/sJd/riF2LZOZK3DA9CTZ4J
         AWt0+pJdGcQgmWqOxo0fs4HyXeUL6+D+VfH7O59neCKHBajgUPT06+Gy8id935uoM8M4
         19AbXbsZuywSK327SSIYuwLVn4hsBlMht3WKYCyQaUkAFxcimFyyQHMPe+tfo7mlE88M
         jOoLt2vmt5QzzrY408VJ0/t/VHA6Rd4eO/NWKERt9IOLJ1LKmeNwbz4BbwC1LFS7w55y
         ZlIufw30QtT9FPhsrypct8Z+IgiadviCHNwHq0NAza7eQiSi+howuxzrnWsA6XVgZA4n
         yXRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S6AbwQfs68Y/ZT/F/BP8uawPhfCqbPsmdSCLuQaKQUs=;
        fh=ugkJ5XDgspsejw73J+Hsy8UTTOgR6s43EamSzV9zNik=;
        b=FAavecxz4AndBO82lStVB1yZg33LVChozZs+XVTiq5qZDPrzQpVfe85YFDN0iNzTs0
         VU+i2mEDuNfRCQ+v+X6h8uz53e394cNzIjQI3cpDT2v2smS2ultVzDiOeX1tcIg9HJmX
         3i+qN/K/NOge/rRjpBmsvdSP+attHgjLiQZPhF3yh5S2A0/Z4cHOyplAU+ydhPxkfJKm
         yppF0CL4HVWWBe5jn8lqVU8kSgrtpnH7Tn/bFs7OaKLPPqwp9yeH55m86RJNg9BoTgWk
         4mJBDsp0GyWmFAwHofZfXVwVnSAODp7ll+/AGvwCRIaU8ipQxybm58Dmpub2H6rAiT3x
         dmGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773393952; x=1773998752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S6AbwQfs68Y/ZT/F/BP8uawPhfCqbPsmdSCLuQaKQUs=;
        b=HJ0jCcGNdUodsGNj0QEEWPv7V2STIUT/7d5dOSz6Qe23r8lvT46gIfvvLc2cMnsO7X
         XMewyyyYb8ExuDLSMXI6YQtcVLEgYQyw4+61Q3TvxspYnzqoNasyd9vX4sBsTq97Xtj4
         nd2NzGqxi31rdPmN8GQtSDGWimvqtyiMOP9F3aBw8kejzXBy+BpwmJ/KA35dK3aB0mBx
         D887zTGPcks/mAS6HH6MDRN+uwrlUkvbm12yOnDIH36lIk1bRLsFfqwe/wXKN6ymsCb1
         ud5UtRNvE3FrvxCz4BMRub9StimWETitQ0zBTaewq458YieZBN4L7OHIy+p17+bN8meG
         t9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773393952; x=1773998752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S6AbwQfs68Y/ZT/F/BP8uawPhfCqbPsmdSCLuQaKQUs=;
        b=tVNF9IxCqqdZXZDHfa8yCU9NmC7BENVsJOaNL+0GpTrHLoFYSwUrqMl0HJHClGayOx
         cMu2cWX/p1WYwZVoPO1aZK0ZmmK3xMmjf7KEOyI1QHq4R5kyFMRxs8OOB5amDYB5gtpg
         iywFq23CTzsYJkN0PFJONas1vI+jTbjXUVNEbjjLfyoyjA+mgZoSXcqMieOn9o9pK+Vj
         fTRsTuv34BV5/hys1wRIeUB/H1bdPc5a8pmUlz81dDcmWa/YbHqyKacZyU7jhwS2uL27
         NCq8cxVUOIV0Vzy66eWJULfHZnklvqTVL0gri+1cmTBuehlhiIFiyN+vwLAExqnqPJNF
         MrUQ==
X-Gm-Message-State: AOJu0YxQUNzFN6+HlTRzZdk077BhAd+ezUk0cMD1P6opTvXr8m1Lwk5p
	OhRX5U8Ml9o9k5kScS58MbRUZsPqHVsNkVHnsvVwdwFPVnyk1XB1d2Vah5ESGifd0iiucmB9+zN
	tHpID5eIju86gAF0gUXeFK45BYSFA2ds=
X-Gm-Gg: ATEYQzzIfe83GIyNBxt+njeIcvYCgwPUr4m+WMHv6jhoziJuEYSgtPpJc6oRVR62R1q
	nwFCv01MhZBfSPhKpI52AvpcAEj67hJvi9vlM+z32nKlcCHmyey3Qsg468JcMvxNdtudqYOJ0h+
	uQl7zU/fW5xgHEOlEUDqGL9RbRQivDhxiQx4H5qBVdNEojKU0FXIHdXl1FYoYEZi/+oF6NQnzHG
	Sne+zkWV7sjR2GYw5QnXE4fOtyRWTZ/SSqGzZadhCbJg3CCqrNf96w1eCAQP++rVO/E8eU5Eoix
	EdW6+eiEDDC4WWzEBiyuAHCgBsxKC+vfCQmbBWNcG1UNaqTrY3N/eu01v9ea+7fZwcs0AIvsd3Y
	Bofu63SE=
X-Received: by 2002:a05:690c:6d84:b0:79a:2312:527f with SMTP id
 00721157ae682-79a231274aamr6596967b3.3.1773393952284; Fri, 13 Mar 2026
 02:25:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310160013.515096-1-kartikey406@gmail.com> <b1c14b931bf62b114ca44c18f2724a601efa76f5.camel@sipsolutions.net>
In-Reply-To: <b1c14b931bf62b114ca44c18f2724a601efa76f5.camel@sipsolutions.net>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 13 Mar 2026 14:55:40 +0530
X-Gm-Features: AaiRm53sVKNeDwLx7RoTUou00lp76y6h3Y-GQVdqaaH_HRrSUfDJEU_KeWDxfGA
Message-ID: <CADhLXY6j53Rm1ySgEzxjfzwDGRb3_kqF-chKnPWaguX9OzJCmg@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: fix WARN_ON_ONCE in ieee80211_tdls_oper
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 12:42=E2=80=AFPM Johannes Berg
<johannes@sipsolutions.net> wrote:

> On Tue, 2026-03-10 at 21:30 +0530, Deepanshu Kartikey wrote:
> I think that check needs to be earlier, otherwise side effects happen
> (TDLS_PEER_AUTH flag).
>
> Also, I'm a bit confused, how is it possible the sta_info_get() worked,
> but there's no TDLS? Maybe really what it needs is
>
>                 sta =3D sta_info_get(sdata, peer);
> -               if (!sta)
> +               if (!sta || !sta->sta.tdls)
>                         return -ENOLINK;
>
> instead?
>
> johannes

Thanks for the clarification. I have sent the v2 patch.

Deepanshu
