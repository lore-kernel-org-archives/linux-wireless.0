Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08A61E7C23
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787559498; cv=none; b=DhzosiRZc58LlTbqJWi4zsmjfQ8XakVXiC6hm83yIfGkVORRnQ6OcMTWRQuH3oromXLCCkjuG/0uJgQxdI3i9SSo8fLs/O4onBqBZ4qhmvFsYx8I6n+ASXEq1GTQRnEWkbUfm8WbjPy5kOPKlHp/CtaLP91rDYyk1oKK8BsIbsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787559498; c=relaxed/simple;
	bh=1dNtjkPdGPOdSoc8D2vfGUkHn7OOKugmS3Q+RYnCjmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OHxHEfeYLuFqo3zEagQUkCARYwUGqiwxoKDO2pykJceI85SDFpsKRc/i/GGutKGqBha7FhgZ26Clt42n4lmYe1Lk4zSv4At4MeAdiXe/qXWAANrKujdskozjc+LfOEWHFMLBme+CWU4Xc+Vdxx4XI9vvDXCQDMGyCXPsX+7YGyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bexmzRqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bexmzRqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C78D1F00A3D
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 08:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787559497;
	bh=5LiJ6TZO52m4OOCLiCd71T+aefYjNDmhG2YJrXqJqxc=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=bexmzRqtF9JdHrYVsyp2yLgJhXylIfXLpXcS/tvkzZZ/HHNuqjnJqv0NRkPsXlK1p
	 p9h0CDYOyO3l0jF5s6s/arPLS4No2GOl1HwNZY5zQ2JRSQhGFa/9orzitZri9NewcD
	 FRjEN+YFrJIPmUx+9SNaRTyY7fETG6KPVlMEnMkOEASwbhFYlSFbt9C0HZqfDATDzz
	 j6w+0AE9BenW9gKp+U7vZWK8Dglmv8zHZlMnM6YfWa3Qu+1h7BPOZ0v/mix3R1l0KU
	 9vA66OuOHxNQ76wL/TJYGqXq35CBlmocgAdQ9xXHTbttsSTH09dR1e1IkmP0wDYD1r
	 p8WEzJcZczbjQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39db07589caso26466671fa.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 01:18:17 -0700 (PDT)
X-Gm-Message-State: AFuF++m8BuASRVzwroJ1Vz8tmGjhMI5LvVeYjx/AujHCIPHmA45V8YOc
	7MLjL2ZBhkOb6HUZmiHUY8mPl9E7Gykv/dq2hqs91V9FDYiLd/IILsvMcGiW40G/TquaFEMlKYB
	4J/1a3+IS12vh7xFhplzOnGVU2wstVEM=
X-Received: by 2002:a05:651c:41d3:b0:39b:695:32a3 with SMTP id
 38308e7fff4ca-3a1c1ea8683mr34487621fa.13.1787559495827; Mon, 24 Aug 2026
 01:18:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
 <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
 <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com>
 <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com> <CAJF5HCsYhv-JTMvXRHLesuOFsVFnySqEKWYzK6_B-bWEoAEW0g@mail.gmail.com>
In-Reply-To: <CAJF5HCsYhv-JTMvXRHLesuOFsVFnySqEKWYzK6_B-bWEoAEW0g@mail.gmail.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 24 Aug 2026 16:18:03 +0800
X-Gmail-Original-Message-ID: <CAGb2v65qs7NkSEL8Zg3x8a8aytV47uauNo6gj2XMi7_FfADz0Q@mail.gmail.com>
X-Gm-Features: AcwNN1XDB_opVvJUZeDD4_gg9MMwroqOpuME4HWa5-J3xyPciLYF7H2EolzrP88
Message-ID: <CAGb2v65qs7NkSEL8Zg3x8a8aytV47uauNo6gj2XMi7_FfADz0Q@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: Ibrahim Hossain Abir <xbowpc@gmail.com>
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 4:16=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@gmail.=
com> wrote:
>
> Hi ChenYu,
>
> Understood. I have reached out directly to the Spectrum Division of
> BTRC (sohel@btrc.gov.bd) requesting technical clarification on
> explicit EIRP limits and standards for 5925=E2=80=936425 MHz.

If possible, could you ask for status updates on the 5 GHz bands
as well? You intended to add them in your patch.

> I will update this thread as soon as I receive an official response from =
them.
>
> Thanks,
> Ibrahim Hossain Abir
>
>
> On Mon, Aug 24, 2026 at 1:39=E2=80=AFPM Chen-Yu Tsai <wens@kernel.org> wr=
ote:
> >
> > On Mon, Aug 24, 2026 at 3:23=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@gm=
ail.com> wrote:
> > >
> > > Hi ChenYu,
> > >
> > > Thank you for the review.
> > >
> > > Regarding the reference:
> > > The official BTRC circular (dated Sept 15, 2024) specifically
> > > authorizes the 5925=E2=80=936425 MHz frequency range for Wi-Fi/WLAN/I=
oT shared
> > > usage in Bangladesh. However, this notice does not define explicit
> > > EIRP power limits, TPC, or DFS requirements.
> > >
> > > In the initial patch, standard conservative limits (such as 23 dBm fo=
r
> > > 6 GHz LPI) were derived from standard Wi-Fi 6E/7 spectrum norms.
> > >
> > > Could you advise on how wireless-regdb prefers to handle cases where
> > > the regulatory body approves the band without listing explicit EIRP
> > > limits in their notice? Would setting a conservative default (like 20
> > > dBm / 100 mW EIRP) for 5925=E2=80=936425 MHz be acceptable for Patch =
v2?
> >
> > As previously mentioned we cannot accept random limits without justific=
ation.
> > The regulatory body needs to specify limits, or outright state they def=
er
> > to some other standard.
> >
> > Please help reach out to the regulatory body for clarification. They sh=
ould
> > provide the information, otherwise folks doing the certification have n=
othing
> > to base it off of.
> >
> >
> > Thanks
> > ChenYu
> >
> > > Thanks,
> > > Ibrahim Hossain Abir
> > >
> > >
> > > On Mon, Aug 24, 2026 at 10:38=E2=80=AFAM Chen-Yu Tsai <wens@kernel.or=
g> wrote:
> > > >
> > > > On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbowp=
c@gmail.com> wrote:
> > > > >
> > > > > wireless-regdb: update regulatory rules for Bangladesh (BD)
> > > > >
> > > > > Update regulatory rules for Bangladesh (BD) based on the official=
 BTRC
> > > > > (Bangladesh Telecommunication Regulatory Commission) directive da=
ted
> > > > > September 15, 2024.
> > > > >
> > > > > Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz (5=
925-6425 MHz).
> > > > >
> > > > > Official BTRC Notice:
> > > > > https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
> > > >
> > > > This only says that the lower 6 GHz range is allowed. It does not s=
ay
> > > > what the power limits are, or if there are any other restrictions.
> > > >
> > > > > User Impact Reference:
> > > > > https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Detect=
ed-on-Intel-AX211-in-Bangladesh/m-p/1740885
> > > > >
> > > > > Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> > > > > ---
> > > > >  db.txt | 8 +++++---
> > > > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/db.txt b/db.txt
> > > > > index 0000000..1111111 100644
> > > > > --- a/db.txt
> > > > > +++ b/db.txt
> > > > > @@ -223,5 +223,7 @@ country BD: DFS-JP
> > > > >   (2402 - 2482 @ 40), (20)
> > > > > - (5735 - 5835 @ 80), (30)
> > > > > + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > > > > + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> > > > > + (5725 - 5850 @ 80), (30)
> > > > > + (5925 - 6425 @ 320), (23), NO-OUTDOOR
> > > >
> > > > A reference with the band and power limits, as well as any other
> > > > restrictions like DFS or TPC (andif TPC is required, what is the
> > > > limit if TPC is not implemented) needs to be provided. We cannot
> > > > put random numbers into the database without justification.
> > > >
> > > >
> > > > Thanks
> > > > ChenYu
