Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396FE1FF7B3
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 08:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770192074; cv=none; b=aRwSKNq/nIa1dTlCOpALpD0pXVT15QYdHT4AW4OCgl+yatrEYMBzWBeyIURM7SWXS5gcrpRX1GsqC6d13RNz91A9FvDldpM+pvjgcrcRDJrnoGeWY/EBz/xSyqX+mR2AU70MlUcsy91K9e+tqI7H18TZ9KGd0oaNFWH+OCUJ5i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770192074; c=relaxed/simple;
	bh=jChZOFyfVAkUwehK2VPjnnIZgAsClarnWhSGFHek3dQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=gxTsRQM+1sbeZxGLXon4cKLlatBdzThh6CKNZ6kEjyhXQeiKVamHJ2lq/IMyslpkGl9UgOZIqTTCx9wnI/LI6TiVw9YwZc+b8O4j9buj7DZlOX5Zd4pjDlnbbjWz6o6xi4i4DIZQSds7ZqaoaH2YSlSx6KPvS3iaBeiuFm/3B0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JvlluKgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JvlluKgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D7EC4CEF7
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 08:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770192073;
	bh=jChZOFyfVAkUwehK2VPjnnIZgAsClarnWhSGFHek3dQ=;
	h=References:In-Reply-To:Reply-To:From:Date:Subject:To:From;
	b=JvlluKgqtqaLFtt0tbqlueAX8GrFqq1+/ponQsu40LI9EQg6iol6EBiJBWxoZIOzj
	 QbTe1XlqaQBnMLXND1Zkx3A5zJQGg8ozRfbvt6HS8PR9lp1nwzmmlchAZYW2nWUiqt
	 7fne3XdJaL9xpzCmBRKbwREM1WxJr9iUeP+HYX75WSPOWtNhY8nMdT/F+q7uK2UG22
	 YnjUK0ATmRR/P331ygxZ/NlLftg534FBOGkARbJohssO3ArwPiOH7twbeAiPOsBm6H
	 +1hu0JIrRFxjbg7fWzCCGfDgXbZV3umQIgnhsIk2YAJiqf5eyrwLx+tdJg81N4bDKF
	 UlhElVbg3uekw==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-382fe06aa94so55109461fa.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2026 00:01:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVlw6EwOb9rmJgYWia2HGY67ibn3pT9ycZ5dx5TBlpMTF42uQIPZWou11cExFLz7mGM25/ZrbcvV+Puam2GPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwavqFgcjEmxLiFSnutXl6gGSr17a6cPzkJKunt2zan0BQ/8CR+
	xMMhNWoZtarBuxkdssITOzc0aFrMWJe1nnqnTlCHpjfFmz8tK5RRS7IoDhEjeT2kSHn5BGMa87z
	wSLC8+ml7WRFjRbJMfZYs1mVKh8RkF9o=
X-Received: by 2002:a05:651c:41d8:b0:383:18aa:50c4 with SMTP id
 38308e7fff4ca-38691c6de06mr9221921fa.6.1770192071748; Wed, 04 Feb 2026
 00:01:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aYL8hbqyYUSaF9vn@wens.tw>
In-Reply-To: <aYL8hbqyYUSaF9vn@wens.tw>
Reply-To: wens@kernel.org
From: Chen-Yu Tsai <wens@kernel.org>
Date: Wed, 4 Feb 2026 16:00:58 +0800
X-Gmail-Original-Message-ID: <CAGb2v643iTkHNR3zvg+griMMQ0HT6M1__QkRyG4nDGHOk=D-ag@mail.gmail.com>
X-Gm-Features: AZwV_QhK_rrv5PvgbofP3QdHMQYBxZhVyWmoIfTgvE2UXUJZJpF_MnhZEZyGD0M
Message-ID: <CAGb2v643iTkHNR3zvg+griMMQ0HT6M1__QkRyG4nDGHOk=D-ag@mail.gmail.com>
Subject: Re: [ANN] wireless-regdb: master-2026-02-04
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oops, please ignore this email.

It has the wrong tag and URL.

ChenYu

On Wed, Feb 4, 2026 at 4:00=E2=80=AFPM Chen-Yu Tsai <wens@kernel.org> wrote=
:
>
> A new release of wireless-regdb (master-2025-10-07) is available at:
>
> https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb=
-2025.10.07.tar.xz
>
> The short log of changes since the master-2025-07-10 release is below.
>
> --
>
> Andrew Yong (3):
>       wireless-regdb: Update broken link in regulatory.bin(5) manpage
>       wireless-regdb: Update regulatory info for Malaysia (MY) for 2024
>       wireless-regdb: Update regulatory info for Malaysia (MY) for 2025
>
> Chen-Yu Tsai (2):
>       wireless-regdb: Update regulatory info for Canada (CA) for 2025
>       wireless-regdb: update regulatory database based on preceding chang=
es
>
> Ping-Ke Shih (1):
>       wireless-regdb: Update regulatory info for Tunisia (TN) on 6GHz for=
 2025
>
> Richard Huynh (1):
>       wireless-regdb: Update regulatory info for Australia (AU) for 2025
>
