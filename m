Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19132396B70
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557183; cv=none; b=H6Akk3HcnqdHt1LjPbvqibkoHAGASgvAdXoH4QcziuLXMCsZ+6/gTq+XcN/Xl884tjkva53Qo+p5NA/FSqV6cpfzw8YPp1F4/2jVnGruA9C7NVXe6dRMvg9hhoW+b4I6n2UV+lUodfvuPiIxQ6aH8VNZIBlR4nMOAN+Z32UdFHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557183; c=relaxed/simple;
	bh=NucdxNcYNrM1CgA9gp8SsmBDj4UVTlZi7uXgRcG3zEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuSPcBzCUo46pl09wyFX0sjZqTTuPqfqt+UWpV99Vy7nTMrozBSxeC+Z7dGMIRG/2sssBX7j0rabXFQh0U6tTYlbM0LXRw2R1juwPuHfTK9yrPBI0fEg4WzxUS9fbWWKwpqpmZ3v9V1tGi2fAfexnJe5OGa7yIwB1z5KdQTtLII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OumuAoZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OumuAoZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397741F00A3D
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787557181;
	bh=FQETx+twl973G4FbIh3mQc++j4px3UTMu1k/gnA07m4=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=OumuAoZiYC2LdrP5CuLMMByZR7Ai+g3h9Ma6iSjQgG3DMHQf3aMSNA+NTiywS8y9r
	 RHbxUSZXNygo9WSNlAhK+V22HrpycHSfC91PAZ9HZlB0bsP4Es747tO7ubnco5mDb0
	 ClHri30/TAeA03Ivhqhv22LotgaypWxrLKh37aVQDUeyMuVLkv2MPRU39H/wbO7uYc
	 kiQg3pqy1Jl63A7zYJSsB+4yf944884MEJYGYsOFYdqhBfp9Ln0zw5WMZqzzBC2ju2
	 MmxW/ETVBhLNlDhz2k3Uuf8aM/f0yJSP8lnF3ScRJTjgIloQwa9WdZdei2x/Z4xu4A
	 9sbXv62rA19Pw==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39c9a3acd40so22966271fa.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:39:41 -0700 (PDT)
X-Gm-Message-State: AFuF++l2oUpdaj0xon6tPfCEN8nlcWRw8T80hH0RBuwR6oVpJQt90GdK
	Gjfn35V1K3iB1xaqtxdRzv2jRQLv0XeqNIidW/rLy3gYGe7SjO3UnLJxZ8VWf5rxBkPpvom8I6S
	yTJcK/OdZ0an0ztB9nHVJiR+SVCJw0BA=
X-Received: by 2002:a05:651c:b29:b0:39b:2757:c1d3 with SMTP id
 38308e7fff4ca-3a1aec08881mr57239121fa.9.1787557179643; Mon, 24 Aug 2026
 00:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
 <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com> <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com>
In-Reply-To: <CAJF5HCtAVMbarNYDkrKWE97Lib+YJk8ZE+5eWsEZ4fKVTp8tOw@mail.gmail.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 24 Aug 2026 15:39:25 +0800
X-Gmail-Original-Message-ID: <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com>
X-Gm-Features: AcwNN1W17ZcnTDpUslucQDZqrt3n9VNZpNg1C04tJ1jHKInO7qgADqCWGd4vEtQ
Message-ID: <CAGb2v66-ee1n9E2-GmFZu02HRmFFWPQ1KB-L9uPQcq1i5HSpEw@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: Ibrahim Hossain Abir <xbowpc@gmail.com>
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 3:23=E2=80=AFPM Ibrahim Hossain Abir <xbowpc@gmail.=
com> wrote:
>
> Hi ChenYu,
>
> Thank you for the review.
>
> Regarding the reference:
> The official BTRC circular (dated Sept 15, 2024) specifically
> authorizes the 5925=E2=80=936425 MHz frequency range for Wi-Fi/WLAN/IoT s=
hared
> usage in Bangladesh. However, this notice does not define explicit
> EIRP power limits, TPC, or DFS requirements.
>
> In the initial patch, standard conservative limits (such as 23 dBm for
> 6 GHz LPI) were derived from standard Wi-Fi 6E/7 spectrum norms.
>
> Could you advise on how wireless-regdb prefers to handle cases where
> the regulatory body approves the band without listing explicit EIRP
> limits in their notice? Would setting a conservative default (like 20
> dBm / 100 mW EIRP) for 5925=E2=80=936425 MHz be acceptable for Patch v2?

As previously mentioned we cannot accept random limits without justificatio=
n.
The regulatory body needs to specify limits, or outright state they defer
to some other standard.

Please help reach out to the regulatory body for clarification. They should
provide the information, otherwise folks doing the certification have nothi=
ng
to base it off of.


Thanks
ChenYu

> Thanks,
> Ibrahim Hossain Abir
>
>
> On Mon, Aug 24, 2026 at 10:38=E2=80=AFAM Chen-Yu Tsai <wens@kernel.org> w=
rote:
> >
> > On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbowpc@gm=
ail.com> wrote:
> > >
> > > wireless-regdb: update regulatory rules for Bangladesh (BD)
> > >
> > > Update regulatory rules for Bangladesh (BD) based on the official BTR=
C
> > > (Bangladesh Telecommunication Regulatory Commission) directive dated
> > > September 15, 2024.
> > >
> > > Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz (5925-=
6425 MHz).
> > >
> > > Official BTRC Notice:
> > > https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d
> >
> > This only says that the lower 6 GHz range is allowed. It does not say
> > what the power limits are, or if there are any other restrictions.
> >
> > > User Impact Reference:
> > > https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Detected-o=
n-Intel-AX211-in-Bangladesh/m-p/1740885
> > >
> > > Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> > > ---
> > >  db.txt | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/db.txt b/db.txt
> > > index 0000000..1111111 100644
> > > --- a/db.txt
> > > +++ b/db.txt
> > > @@ -223,5 +223,7 @@ country BD: DFS-JP
> > >   (2402 - 2482 @ 40), (20)
> > > - (5735 - 5835 @ 80), (30)
> > > + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> > > + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> > > + (5725 - 5850 @ 80), (30)
> > > + (5925 - 6425 @ 320), (23), NO-OUTDOOR
> >
> > A reference with the band and power limits, as well as any other
> > restrictions like DFS or TPC (andif TPC is required, what is the
> > limit if TPC is not implemented) needs to be provided. We cannot
> > put random numbers into the database without justification.
> >
> >
> > Thanks
> > ChenYu
