Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9CC30DD00
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787556190; cv=pass; b=RZ07k1I55w/Mi3btG/YZD1K2ZeX5bV8JOHwD8pCjQzq/tFxjutEGj561Xf1uOUeJ31pZcPbvDSovo0O4sXhK4rUED1uuGIXZ4xioXWuHzTV9JDTwYEnnquc7+lwtBA6yeedwOCAnfpQwFg801lfLcBRmVSS7Q8doFI9j62ZKATc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787556190; c=relaxed/simple;
	bh=OpUKe3Pb3NwHUx5xsoAEr7bnv3AMX2nHegPylPbV6r8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r00segex6wjwgLU34lrDodO3x36LPlAQ0bu3PJVFdVI9KsNZIcLH5XfkWu3ihXvJQ8J1gAsDQvRCM7BDGouMbHsyNu+kXZlE13LE8bxP6z/5iM51HNOSoxyaZHzgUZQnVbOpAgiTPzy+F9cy5z3GjmTtSMGT3TB+DJ0owXth5WM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4VK48VO; arc=pass smtp.client-ip=74.125.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4VK48VO"
Received: by mail-yx2-f4.google.com with SMTP id 956f58d0204a3-66c70bc1c26so1133382d50.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787556188; cv=none;
        d=google.com; s=arc-20260327;
        b=OWJdqMl/OB2Kvc+hA9ZUjBAOo8sPYP8hsOdLuYz5jA/cFZ7u7mu2QrYAgUgrHVlBvg
         S+VwlJWJRGZB/lWb8dmZzQ8s1Q9NR+nPMVa3U7QEP6T2rry3GgOxYb5/G0a3oT6gjYNV
         ljwBaAhNmt300ZPRd/4d3zb7CfSBa6oG82rDLz4PadOn8iD1M7GbN48O6399kIXOxVeX
         IAyEDbIHy/OyBf77OJRBOToKznIvARKeq6OMM7VvmxLyTPcjkzvyGUD8HprFMBGpuQ5W
         L1V7w9CXU5OX7PeXeegW7/l9kg1o10jG/oBgwEsPeLLwtj4Ydwz6uuBiDe/uBr1eMGL9
         nkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w9HQsIs34F9CkFfEOrlbBQvrjXnhasrgbQZNTVtnk84=;
        fh=A5BFOlfGtNtLLVvovqo+K1m+qjaXwsuvZvBwq/NsLuU=;
        b=MPt5fqyy0K4Xa/cfZcOxRE3OWHmo1DVEs2D9A3KnSpwTN5AX68j3pEAy3k5ksPJCnT
         B+lgdM0rVr3OX1apm9X3dGV5kMJARzDgrrNecg3H45bQxLuZvK1ovOcW29Tb8Rgu1nFI
         KAtWlBPm365aWDbjmP3Km1Z+SusoXtMuCIaGnxPbtQJmIk1EBDXD2+yUXZAyBHQUhC4b
         OxR3vQcK1gFYQiHA760elsxxmcbYpNinpneWFkbTIJ0n98/249rJBIatoFngbXEMw1Ig
         8wq/uACkhE91WM3vrEZijJJwJzDv6MEDiSZ8TxTxMcWOM3NgRcicDdIkfT4AfFPth9f5
         oiqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787556188; x=1788160988; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w9HQsIs34F9CkFfEOrlbBQvrjXnhasrgbQZNTVtnk84=;
        b=k4VK48VO6P+LjwlSRa7ZY0UB+XxgDFJQjDjGmX78eQx/q1A8eOXYQV+1phBSDI5s1i
         r/GXrG19eGu/OIbW52rvHpa8M49qh8+z5qlLH+LVX6jb/mLUnViYFBQlRMCIxWdUcXEa
         6U2Liqg//FOLwczIU/bPnbQeEwuMnxU+Lh1kldo8dwYsK3rhAlZfNpwA+4jGTEnQd3zz
         1AOwkwU0tTDNANmqmR2iIAtnWgvJziTtnj7oloXE3dsCOXeJTPWMd2pSeZI14xDdmtMI
         adVjVilQ2L972onKjdGWqzc1tnKSdb2XB131bwqnEmlFPk6MosiS7CKpy4W1ky1YjJ2L
         Yraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787556188; x=1788160988;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w9HQsIs34F9CkFfEOrlbBQvrjXnhasrgbQZNTVtnk84=;
        b=H1I+Wu3rej2BVUXSE0umwpEL65Ym/ZCQHdkbFm9PhO/bomy51LV9o4myZpWpItcKRy
         GurykNQ+zOPENhBugk2avA2Yq8MNhOFZpqJSkf8eGCBQ9c2/CkMx+TXz2xWpAoyuRRTb
         dbHvDZEt4POeNFO6Ap/Ja6U24b+egFnKUCpUiTHtisdmIQWW2BF5lNntL88MFuGLds+r
         /AuxCw2MUhOoU9A9OaV0izRSuUw7RZtMAfUzmxAOBnSrJKuz0k9vHVvQVaS7zhEAk15N
         AwGMmdinmJxxKhHMg2ShhB4BXieKRMc1A6JC2DGKGyx54GJWKAA3Wn5V1N9M2aykmX7A
         u9wQ==
X-Gm-Message-State: AFuF++lQnh6dtOBHJQs4y2BiybRctlSVdPtmGG3dHO9uDY0UjstYb2Ir
	wGjaG5dLsyQ8xaKAhDagOG2UQK6Jy/zAakxoX+k7Pn0SiqU6Knj95vLfYyU0NcIOyEtc3oa6gYB
	zQv1poMQ/OaBoMFZflcvFujljhYdUKZwEqbXYoE20kg==
X-Gm-Gg: AR+sD115btZlO9KxCL7t7VAiyAR9lsmZI7+j7z097MfACxlly9Xv5I0FcMcTa5/cSZZ
	E7m8XKLpQTu4ZvHcFT9BjkxQrUYX8+FoAacNFRfz0NDv/hNbdHvkYYj3f3j0yX9Sr71IPDECIj4
	BwCWfJ5WAHCzCxnnvWgrsI7SDT8RJIkDHr4TJaTb0l4T8PZDck9XTXTAMODdQnyjHfSwb2QwjxG
	8cdW4l7WY/6/sBQmHgtT/PsqIu3+1lM0VcnLT0odTQpoxeGrMvzDU2uZoZBvwbkdMN8XtfbtwwQ
	HA8tA3HgMm8hUauy+dLXeE2BVu2BsYHKmzHydNy6qu+gqKMQKU6ORfKREFpT9sVGeLYWapQhOHt
	ywOoJpiWnalAP0yr4UUPOEQLUcLYVmN/PcO2V1xX74S/JzMGGVN/I4eM=
X-Received: by 2002:a05:690e:4104:b0:66a:b622:5974 with SMTP id
 956f58d0204a3-66ce4a87ee9mr7426309d50.22.1787556187879; Mon, 24 Aug 2026
 00:23:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
 <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
In-Reply-To: <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
From: Ibrahim Hossain Abir <xbowpc@gmail.com>
Date: Mon, 24 Aug 2026 13:22:54 +0600
X-Gm-Features: AcwNN1VFBmOib0Kf5woET0ol44OGtNb-WbcFiLSb0pKfxwJ_FsR1Bnxdtun4z50
Message-ID: <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi ChenYu,

Thank you for the review.

Regarding the reference:
The official BTRC circular (dated Sept 15, 2024) specifically
authorizes the 5925=E2=80=936425 MHz frequency range for Wi-Fi/WLAN/IoT sha=
red
usage in Bangladesh. However, this notice does not define explicit
EIRP power limits, TPC, or DFS requirements.

In the initial patch, standard conservative limits (such as 23 dBm for
6 GHz LPI) were derived from standard Wi-Fi 6E/7 spectrum norms.

Could you advise on how wireless-regdb prefers to handle cases where
the regulatory body approves the band without listing explicit EIRP
limits in their notice? Would setting a conservative default (like 20
dBm / 100 mW EIRP) for 5925=E2=80=936425 MHz be acceptable for Patch v2?

Thanks,
Ibrahim Hossain Abir


On Mon, Aug 24, 2026 at 10:38=E2=80=AFAM Chen-Yu Tsai <wens@kernel.org> wro=
te:
>
> On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbowpc@gmai=
l.com> wrote:
> >
> > wireless-regdb: update regulatory rules for Bangladesh (BD)
> >
> > Update regulatory rules for Bangladesh (BD) based on the official BTRC
> > (Bangladesh Telecommunication Regulatory Commission) directive dated
> > September 15, 2024.
> >
> > Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz (5925-64=
25 MHz).
> >
> > Official BTRC Notice:
> > https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
>
> This only says that the lower 6 GHz range is allowed. It does not say
> what the power limits are, or if there are any other restrictions.
>
> > User Impact Reference:
> > https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Detected-on-=
Intel-AX211-in-Bangladesh/m-p/1740885
> >
> > Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> > ---
> >  db.txt | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/db.txt b/db.txt
> > index 0000000..1111111 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -223,5 +223,7 @@ country BD: DFS-JP
> >   (2402 - 2482 @ 40), (20)
> > - (5735 - 5835 @ 80), (30)
> > + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> > + (5725 - 5850 @ 80), (30)
> > + (5925 - 6425 @ 320), (23), NO-OUTDOOR
>
> A reference with the band and power limits, as well as any other
> restrictions like DFS or TPC (andif TPC is required, what is the
> limit if TPC is not implemented) needs to be provided. We cannot
> put random numbers into the database without justification.
>
>
> Thanks
> ChenYu
