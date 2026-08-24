Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E91A34F27F
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 04:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546315; cv=none; b=WL0h+1uEFylEn0h+5YlPA32G93XYsWOWpxM2jHHDea7F84Q3Zemunlendaapa8ibOdoc6TRIFWkdLCnuApV+3ds5WJnzuPe6sGRay5xYhcMtiMAeMDDHYOGyWrBo+COfV2CII9uxCJKnPFFeCZjrBq4vg3flbd/E5jIF2YcCmG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546315; c=relaxed/simple;
	bh=yQxi0vQeXNlWoxUqRtQ1vgoJJKojHypA8ANZHd1b1ZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cezOlwex+1IJa5vrVM4knds7gaF7ndeSGvdGe9OxVfat/IFXFTwJnGnNJwDr3hF9DtgvUL8ykhgw40QDzgiQhf5BnpElTTgBADDQZE7Jc/zDVxAs0260ZywB/slDGPObGDkRQacDKp3xg4qOkeivQ5BBg797h6AmXIMR2Smxxrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPk3qHdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPk3qHdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B861F000E9
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 04:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787546313;
	bh=uhEVXwjacnboWKfDN+ktqXG/vu4w+iOXfwWiYGNFjiI=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:Cc;
	b=fPk3qHdq0a1WGX+CtMMdnsUvyq26npLw8XuFIdTAaPMURDA/I3bWUCZlW4zQ1zdo7
	 374Vdu2STxMfm33TbUvEOE2142NlBUNb30JsAIqOYHFPpJy5PL3Y1uJjeRMkjukkXy
	 FLhFcZnYNVnFCbM/YJHeRkqi9/lRYUjO/xMsHsfQaoJkejsMUw/jWkI2rTjwiHNnqZ
	 NaWS2U0T772VvGChX36DMlVe0zB7UjRZKVMATuxzQCU79oGsT2tRbVRBT5zT/k10W7
	 fdwaGqVTs9y7FrZyjmEx0tlNZbzm0vAkIVCzvE2q1DJRqC+2UOUzNyoQ3O1QhEoIyo
	 vSax+GEYKFerA==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39ca0a30148so28058331fa.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 21:38:33 -0700 (PDT)
X-Gm-Message-State: AFuF++keSaPy+mLUQlrf92kaR4XEIpTR0DrDy4RNuppnkl9H0Zj9ICms
	v2zdWiw1/heed4r1zfyJlFCg7FvvSpkP4AReXssICstRSsK6n+6g+2ETJGKSdj/AZyzWo+MtcuC
	hQrOSWyM/baNZQfPjLw2wNdgsEd0zELs=
X-Received: by 2002:a05:651c:2223:b0:3a1:b1e4:419c with SMTP id
 38308e7fff4ca-3a1c1e994f9mr30399681fa.10.1787546312444; Sun, 23 Aug 2026
 21:38:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
In-Reply-To: <CAJF5HCtEvb-aiusJuzmCvu-db4orDwsSnG+mOfCbLXXYRCbtvg@mail.gmail.com>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Mon, 24 Aug 2026 12:38:19 +0800
X-Gmail-Original-Message-ID: <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
X-Gm-Features: AcwNN1Uz_DzU818P0jHfWiAMPknVbVZcv0nbIZMxAQwh07QaW150neXxOvonvhI
Message-ID: <CAGb2v66bvMC9wU9gYknRdM+0oG7UcGquHCu5KYiwJjWZDRtk1g@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update regulatory rules for Bangladesh (BD)
To: Ibrahim Hossain Abir <xbowpc@gmail.com>
Cc: linux-wireless@vger.kernel.org, sforshee@kernel.org, 
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 4:26=E2=80=AFAM Ibrahim Hossain Abir <xbowpc@gmail.=
com> wrote:
>
> wireless-regdb: update regulatory rules for Bangladesh (BD)
>
> Update regulatory rules for Bangladesh (BD) based on the official BTRC
> (Bangladesh Telecommunication Regulatory Commission) directive dated
> September 15, 2024.
>
> Enables U-NII-1/2A, U-NII-2C (DFS), U-NII-3/4, and lower 6 GHz (5925-6425=
 MHz).
>
> Official BTRC Notice:
> https://btrc.gov.bd/pages/notices/6922ee00dbfbab28ce0c438d

This only says that the lower 6 GHz range is allowed. It does not say
what the power limits are, or if there are any other restrictions.

> User Impact Reference:
> https://community.intel.com/t5/Wireless/6-GHz-Wi-Fi-6E-Not-Detected-on-In=
tel-AX211-in-Bangladesh/m-p/1740885
>
> Signed-off-by: Ibrahim Hossain Abir <xbowpc@gmail.com>
> ---
>  db.txt | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index 0000000..1111111 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -223,5 +223,7 @@ country BD: DFS-JP
>   (2402 - 2482 @ 40), (20)
> - (5735 - 5835 @ 80), (30)
> + (5150 - 5350 @ 80), (20), NO-OUTDOOR, AUTO-BW
> + (5470 - 5725 @ 160), (20), DFS, AUTO-BW
> + (5725 - 5850 @ 80), (30)
> + (5925 - 6425 @ 320), (23), NO-OUTDOOR

A reference with the band and power limits, as well as any other
restrictions like DFS or TPC (andif TPC is required, what is the
limit if TPC is not implemented) needs to be provided. We cannot
put random numbers into the database without justification.


Thanks
ChenYu
