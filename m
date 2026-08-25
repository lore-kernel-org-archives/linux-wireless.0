Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B13242D88
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787620901; cv=pass; b=PS8qnTJni1jZA1vIJhqY3uj7eksFmZOvGi/edDpGLlzfPKYK5K1WEYUYZjcAiH9udsorrTPWllmMrwUTja07EC3G85hrZGBhROdatsiAex5F7DrJ74jMSJmRJq8YP2NQlhtCRIUcWrrnmFfucmw6g1xdimxxzAp06KoewEIQHrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787620901; c=relaxed/simple;
	bh=cIhpjqjlZb2SrmbDHq82Z7uAo/C9SWiWlB+nJzFOGxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K1NYqZFjqOwGltATxCIk3cVar2nOaTU+axlfVuby/zk+28IPa0T/RnpE52Lxl0va9FvRe6cbvrGwRejWMYAqpvLHGWER3qLH5fVLdnR/I9GH3ZUlHwhXIBqyn3vZTuuB070i9oeE62CeKr4KsR6oZSf4VG/ykSGFnpnwwfuZjD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=St19guGE; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="St19guGE"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-66b32bb75beso6316137d50.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 18:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787620899; cv=none;
        d=google.com; s=arc-20260327;
        b=rW8Gl6vDTg0N139RbJ3x2zYMJZ6DGSS8jyz2uFApktQ1bWWzeESZcMnUJ7B8gKmaOX
         OFqTmwi0Y18hCAdeZvVB1Vc0unrtr1edCnNV7NTs2f0W2jFi2flhXFziM8XBzq3xr+JT
         WXvuef/Og1XBFEnfbLy/au3vf1hsKZrstS/KCdYZvcgjD2ckQVeUhodISnuL7q3w8+QY
         4PJndPMnukYHhhJ8S3up8tiT/o1JOvl0uFoi5FM72ESrq3JedvwPuKOUsgApOhrfsUhL
         qjo1RfFtsoYDR6qnqCWQAdnRCuul1xTYOpviVe4C06YZpGZXOCRdJYXXOFisDlAXwzt7
         vBcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDcS7Phc7kPvYh0sRU/4NYuCjZrmgoqZibJOvS1k/Zg=;
        fh=c+gNN+w/yfsMAA8cEPwBUL+7Xn12YeXhsU6WCmqqedo=;
        b=B8ZYpoARxSFHHJmOkZy6dj6akmxIZ4eoazT+Qw0aCt+OdK+9fAfmy7XxaA+h9jjYIT
         /Rm6nAfUGtXe0rtaPyz9wN1oGqVzlJlhTZtCgPA7Y+kOjeOel54AV36yNV3y81G1nGHd
         HuIGPktyZtAfr92n7SbeCsWu4yn5/WSfV+L1FLaYsNofraRkpBB+zN/ESRht/qafAlId
         b2Smmest0bnIWvCBmCpTPOk8Vjm7tHHFY7hXPly8Dot22DBwTYvVHBRodaYQ7JI1fJ16
         4rpL+rPV0Eb3Lfbzrgxvvca5M0eaIufj3QbGd73aaF52g0ZVDNi1BNSM1kqukvvDfYsZ
         T5OQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787620899; x=1788225699; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KDcS7Phc7kPvYh0sRU/4NYuCjZrmgoqZibJOvS1k/Zg=;
        b=St19guGEJWYEddHM/ea1K4VvqkbhzHfz45gedBES4wCNV2DWE+g+no18CPhoSfsgHe
         ncEZI6Au53+B2WGN1hzV2GsDCa1QCTm9nShF3K9uZUVFUgE0JWQqqJZVtP8a+T1N77uQ
         QdxqL2sF+NUySbP0t4nHRswnvmiMm2nPoi5jp7tv1+LTlYZ3Blq/R33CQRffKK1BJrl2
         Qb9Pmp3yF73AgsAqD9RYjZ62Z7PXinsLQTaHGobJnadijaNC75ldZWQW83g6GcRB2GfQ
         zX1Lk9wnokZRhR0hM3tmVQtGsexOxFjfiFfos+WIt/WZjcNCeg2tLEaaTaV82G6n6wjH
         wWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787620899; x=1788225699;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KDcS7Phc7kPvYh0sRU/4NYuCjZrmgoqZibJOvS1k/Zg=;
        b=mZxSab+3T3qriTufFSSbUD2WCdzndEP4+abHt3e5zrzgHLyQdf2zPn6SoNH38xVClT
         5u3WDLMStBIhmJpAH7hRTdmka0YOXfBDbuZ3aG7f+mUbQZOfZAWL3FHxC+4TNug5FkBr
         Y1/vNNt+ot8DOGfZnNShtS7H1vOaXhrcudcSc5sEFs6PHqnGttLkAfnKl4j2ifjRcvi2
         UD/vyjyUsosjmLVdpxhVm5iFQz0abyXUY4Z8vsJnfu3GDldAwXRP4z1qLgvoC7MT5uA7
         rxUfIVcLkD17C6cYQ4Vr8MhrPEhwyeUbPn7I3tnJ1HY4vpa+0tGAHaoz+xHSNLYgRmaz
         dBsg==
X-Forwarded-Encrypted: i=1; AHgh+RoMlq5DZhmgcvBJvpdRLUmRw35uSPRFiaC/w562fK6ynwiFzkEPH5FM93UC9apOhOU590Y1YF4P9kpuHMMUPg==@vger.kernel.org
X-Gm-Message-State: AFuF++lOtrhCSV6aALqZGvbTUy0Ud7521gbJNqgxzo/mINmDYx0jBi2w
	oGRpFqat60MEwlWNAAdAZUk/eMAZolU3M3YdsfHEuTbdvrg1RpwRLkBCXHPVBm1vUbZU4GZu9oq
	pdbUzaw0KseOfs/Xa4VUdfj7HGs++qUA5zA==
X-Gm-Gg: AR+sD12/7X0R2j/mhgN78Clwckb+cTs/2KUPMDFwqnd3vbmkrCpstnxH6FHx30PN2Jz
	3fIBJZ5mG9QZOgADR/YMJdjnuMuyFNlsGMpXqTycbv4+BE/+hk5NY4AevtfEHv6vqpnmUAnP8b4
	WD7gTLbkx/+TKEIF3qLgoKk6/Dz/SxRFwn9wC3FwLI6Q4MloJ2FxGjgmDZUIeSOGAJq+eQm0ry9
	HDPOeh5pcf5+7kfTXQKeGVQ5EwUEGashlhDbiYEOo7w3A54L/dEaWGNvNqkXNNRkGKutSDURlOD
	L53CZH4GWCIljPv5X9s92//gLAK06pWAChDPWJRIKDtnqdhW7/x5AqK1RvzC4AygVwp0o01fwiO
	1F9CcLPUfsp+khGA1F14Km7U1BN/jq8CX
X-Received: by 2002:a05:690e:488a:b0:668:26e7:8e20 with SMTP id
 956f58d0204a3-66cf21b391amr5445674d50.27.1787620898791; Mon, 24 Aug 2026
 18:21:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824054611.29728-1-kartikey406@gmail.com> <DKXBCZMEWM32.3EAAMGWAWQTMG@gmail.com>
In-Reply-To: <DKXBCZMEWM32.3EAAMGWAWQTMG@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 25 Aug 2026 06:51:25 +0530
X-Gm-Features: AcwNN1Vfh4gmsV1-OfBs5UCNoi1gw8-Hc01-_Nfi6Ho8bfQ-SQWxv4zM8IrOEeQ
Message-ID: <CADhLXY6Xd9xicEwYvV72KwGo7svRvXCQbvBAgaCv8cGLj31B7A@mail.gmail.com>
Subject: Re: [PATCH] wifi: mac80211: mesh: free pending CSA settings on
 interface stop
To: Nicolas Escande <nico.escande@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 9:57=E2=80=AFPM Nicolas Escande <nico.escande@gmail=
.com> wrote:
>

> Why not really handling it like the beacon data and just remove the if ?
>
>         csa =3D sdata_dereference(ifmsh->csa, sdata);
>         RCU_INIT_POINTER(ifmsh->csa, NULL);
>         kfree_rcu(csa, rcu_head);
>
> Should do the same:
>         - RCU_INIT_POINTER() will not take too much time
>         - kfree_rcu() already does a null check
>
> >       /* free all potentially still buffered group-addressed frames */
> >       local->total_ps_buffered -=3D skb_queue_len(&ifmsh->ps.bc_buf);
> >       skb_queue_purge(&ifmsh->ps.bc_buf);
>
> Thanks

I will send patch v2.

Thanks

Deepanshu
