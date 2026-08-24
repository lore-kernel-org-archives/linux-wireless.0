Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728BB3AA1BB
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787559370; cv=pass; b=hDi3BR+ZAHmQW8Mi+U4cFrGEEZ0UBaDwHBESSqnapQzG7LoM3atnqV4izuqIU9yDP4zzcCNLAGBfI0L2eu0b5Dn+XaMOJM8Olf/c/tsfPPe7OYVJRhLoGyi9o++QCdMjtOfFDKjiWBDwYLqIg+1jqbWnIo573NdH5XTxUPLTU9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787559370; c=relaxed/simple;
	bh=v83smgx7ztvH3J6UYTs3bXMHXtPgYKSC9j+n3kf0ejo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ueZF+5EIpP+ffrcKoP9pX6jDoOgabNyG3YjP0Tb3a9x7hP6BHUXDF0bYIV13eEyfOUqBhdY8C6ZP47ei1My/2FcU7e8CfSxf9nRu5XQSanmS7MzLn1qVx6MXggqEHfQDYwdRDDk3JckFjfiG/Y6mf8p8w7YrhPLKzBnvjldd8sU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JYJ5Qx+w; arc=pass smtp.client-ip=209.85.128.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYJ5Qx+w"
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-836eac5682bso56914057b3.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 01:16:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787559365; cv=none;
        d=google.com; s=arc-20260327;
        b=m9tHj4CROjSm66Twq8CKgf83OZ38BGoHvujT0BE8AOfCftMdYjJG7zBmaj+YTwkbDs
         /d6Bc+q+NE5kYcry5sPat8RsoNcmVcamUelj/wvmG6owN42KX/q+l++UQJvwhH5z+lA/
         9MUPy9NJdPsEigcOg9KLmOHPd/9je33JGwO3jJWvV6FrLk/d8O7YKrpgS9UwaDbr4EiZ
         BvcZRyuy3N2sWodHGUJXbHo/ofYhGT7OsG8vmzQbpaltN2lDtNpvxw0rPzjRlwrmCaEe
         oeEnmjWFOiR3oosa4wLdVTHmp99dBxLKUJBnfZSpxChDuRp3e39zLRmbPQP8pr9rfbGS
         VmJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y8fsAv1K91Un6gSOD8KCR5sbE7jcf0afTaQzn8RTJQw=;
        fh=A5BFOlfGtNtLLVvovqo+K1m+qjaXwsuvZvBwq/NsLuU=;
        b=EFFK62nR26+tz+8FuydE2DMOtAamBtjamwZtNvyAkpcg2yPR2Xb8o3Myg1r6UtKcZw
         FpSDU9XmpWulepSMI7xNcUf1z4UTruaR8I3ZCwIb3pwREYL3fL6OHnGgbp7CTBK1UC6C
         y6CQ5a3EzvyARsf4QjgcivgFnV5m3ikYuD0RSj6StfxE+kyuDs5tiBK+1MIibryNgCwC
         3pNGc2g/hYH/2IjojgalZNeC1KucY/17sBdzy0o/7B88k3jfURLeRBG9isiVYoLaQPqn
         X1GdmXIUO4bVeoeFS7E2Z/qruWa2mqLp3Sk+4JAfW10Qjllolcxq3oaaXwsCNLpFFXgk
         9K+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787559365; x=1788164165; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y8fsAv1K91Un6gSOD8KCR5sbE7jcf0afTaQzn8RTJQw=;
        b=JYJ5Qx+w25aEo2x/eWP8r7Um0A/Um/WUvJ+WHZUAnkwSEzZTp15STLTpo2mWlni+XC
         dLNOXJmyR0bJNfz/TMNdmHcMXF6oHpIQpTi1HgCLJSr7j5HoentfYCPSWTll7Mf0sPh1
         o59d6UOksKlkWrSJBPFI2TsLA8Py1CBxqJ1VKA9tKsXzUWw27FBD+cwCIJfVIqWC6nd/
         fCge47FGrrZWZwasxizTGg3D+vT+MVhUYQxZ9JcmRHwax5wtnO4ElUobDSXgNQTwj9Fp
         F/gvkWUxn+Xq0oEdHVid971wWSKq1bQ3wK+gVoD2/dljAWXtsjp6xDkzy9lULZee9VEY
         luAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787559365; x=1788164165;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y8fsAv1K91Un6gSOD8KCR5sbE7jcf0afTaQzn8RTJQw=;
        b=Cof8s2utgJ8ng8cAQf6UjZHV2V5Y25D7giM2WucSn1e18Cvac3yRumAZbrVPfZnXNy
         olwrujBts6iLtuDP+O/mzP7M7i0rD4FRhFl/+EqIk7wX6rBEiDycmS8QodvpTAtu7AEG
         7XHDmMJdrTeclLrpT2nMY/Lbd698du39y84U5sfEAbQZxqncN2X2HvbHY+0Zqdw4iG9h
         GxD3+QiFDdy4BxdNwKqvb3Nw7fit8KnNSS8Sqty216qgLsO+6MSpgvOtjGiln2V7Yf4u
         8DTuUQYqdzhxUGeVOUWO+dCB9bNuu8nd2p41wARBQWK8aOplT6WLVwAE6g/0OtvhauQP
         CJQA==
X-Gm-Message-State: AFuF++mXjvu05ZlafLhjoxmguWN9xWa68LyyNsU3tuLEDdOJFtsoORQy
	TShxs/iBpBo1y8ywWY1jfkcJveMpqqrnfZKiRHaIwUs72YQCYi4PW1ITT2Upxcldzr0tBIN3IIg
	zV/Z70G51w/8HWZ5BteugthYNW/XXVmIyIThBCsi6fw==
X-Gm-Gg: AR+sD11qZUI8zt2yW9y82+0cOlSpSOcVsbg7Ii+FQuEc9aIpoYUz/3rZ7fyOuSqasWV
	nhGRzBVEEo/FknAKlb9NeRqBiFyHklxC2fZMemGea1E1NLZQ0g/uRpspHKX0qWuKrJx+GLwq2tw
	EUIxpE+5C5uS8wYZQWR7SUPsTAYwQ4vwlLdPCeikiN9v4HVQ+4YRcTmnHMD95zbA67evOFAHYo9
	Tm9NY/ofDfRuGtHAAm6oW924sj0x0OlhToDu8n9IQQ9W0F+XHM54OdKfyhJs8vg9CYRd/3IOfaP
	VAeq8zYB/pWg1ovNmJUfdE1okh9cgnE9BFGivJ3KKdMHQOVXC9VhYK3OOTCLW9IDcrOzOu0joHW
	xp7iKujTMEBxgQITPj21BQAv5349hLh4cD5XyBp6fNU9gpnJZW9l0Npz4xA==
X-Received: by 2002:a05:690c:b96:b0:82d:8dc0:9cf with SMTP id
 00721157ae682-8470c1665aemr134502787b3.13.1787559365355; Mon, 24 Aug 2026
 01:16:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
 <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
 <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com> <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com>
In-Reply-To: <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com>
From: Ibrahim Hossain Abir <xbowpc@gmail.com>
Date: Mon, 24 Aug 2026 14:15:54 +0600
X-Gm-Features: AcwNN1VAObvE3DgFeXTbISGv9Hi8oremEZygJwgnlwIVruZknGGCk1Czd7Ce4bg
Message-ID: <CAJF5HCsYhv-JTMvXRHLesuOFsVFnySqEKWYzK6_B-bWEoAEW0g@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: wens@kernel.org
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi ChenYu,

Understood. I have reached out directly to the Spectrum Division of
BTRC (sohel@btrc.gov.bd) requesting technical clarification on
explicit EIRP limits and standards for 5925=E2=80=936425 MHz.

I will update this thread as soon as I receive an official response from th=
em.

Thanks,
Ibrahim Hossain Abir


On Mon, Aug 24, 2026 at 1:39=E2=80=AFPM Chen-Yu Tsai <wens@kernel.org> wrot=
e:
>
> On Mon, Aug 24, 2026 at 3:23=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@gmai=
l.com> wrote:
> >
> > Hi ChenYu,
> >
> > Thank you for the review.
> >
> > Regarding the reference:
> > The official BTRC circular (dated Sept 15, 2024) specifically
> > authorizes the 5925=E2=80=936425 MHz frequency range for Wi-Fi/WLAN/IoT=
 shared
> > usage in Bangladesh. However, this notice does not define explicit
> > EIRP power limits, TPC, or DFS requirements.
> >
> > In the initial patch, standard conservative limits (such as 23 dBm for
> > 6 GHz LPI) were derived from standard Wi-Fi 6E/7 spectrum norms.
> >
> > Could you advise on how wireless-regdb prefers to handle cases where
> > the regulatory body approves the band without listing explicit EIRP
> > limits in their notice? Would setting a conservative default (like 20
> > dBm / 100 mW EIRP) for 5925=E2=80=936425 MHz be acceptable for Patch v2=
?
>
> As previously mentioned we cannot accept random limits without justificat=
ion.
> The regulatory body needs to specify limits, or outright state they defer
> to some other standard.
>
> Please help reach out to the regulatory body for clarification. They shou=
ld
> provide the information, otherwise folks doing the certification have not=
hing
> to base it off of.
>
>
> Thanks
> ChenYu
>
> > Thanks,
> > Ibrahim Hossain Abir
> >
> >
> > On Mon, Aug 24, 2026 at 10:38=E2=80=AFAM Chen-Yu Tsai <wens@kernel.org>=
 wrote:
> > >
> > > On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbowpc@=
gmail.com> wrote:
> > > >
> > > > wireless-regdb: update regulatory rules for Bangladesh (BD)
> > > >
> > > > Update regulatory rules for Bangladesh (BD) based on the official B=
TRC
> > > > (Bangladesh Telecommunication Regulatory Commission) directive date=
d
> > > > September 15, 2024.
> > > >
> > > > Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz (592=
5-6425 MHz).
> > > >
> > > > Official BTRC Notice:
> > > > https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
> > >
> > > This only says that the lower 6 GHz range is allowed. It does not say
> > > what the power limits are, or if there are any other restrictions.
> > >
> > > > User Impact Reference:
> > > > https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Detected=
-on-Intel-AX211-in-Bangladesh/m-p/1740885
> > > >
> > > > Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> > > > ---
> > > >  db.txt | 8 +++++---
> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/db.txt b/db.txt
> > > > index 0000000..1111111 100644
> > > > --- a/db.txt
> > > > +++ b/db.txt
> > > > @@ -223,5 +223,7 @@ country BD: DFS-JP
> > > >   (2402 - 2482 @ 40), (20)
> > > > - (5735 - 5835 @ 80), (30)
> > > > + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > > > + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> > > > + (5725 - 5850 @ 80), (30)
> > > > + (5925 - 6425 @ 320), (23), NO-OUTDOOR
> > >
> > > A reference with the band and power limits, as well as any other
> > > restrictions like DFS or TPC (andif TPC is required, what is the
> > > limit if TPC is not implemented) needs to be provided. We cannot
> > > put random numbers into the database without justification.
> > >
> > >
> > > Thanks
> > > ChenYu
