Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:44153 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZHYPJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 11:09:00 -0400
Received: by vws2 with SMTP id 2so2680711vws.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 08:09:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251211217-7816-1-git-send-email-netrolller.3d@gmail.com>
References: <1251211217-7816-1-git-send-email-netrolller.3d@gmail.com>
Date: Tue, 25 Aug 2009 11:09:01 -0400
Message-ID: <b6c5339f0908250809q3e74a36ud9b04338ba18496@mail.gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Fix and simplify Qdiv roundup
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/25 Gábor Stefanik <netrolller.3d@gmail.com>:
> The Qdiv roundup routine is essentially a fixed-point
> division algorithm, using only integer math.
> However, the version in the specs had a major error
> that has been recently fixed (a missing quotient++).
>
> Replace Qdiv roundup with a rewritten, simplified version.

Hi!

> @@ -1042,20 +1042,14 @@ static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
>        quotient = dividend / divisor;
>        remainder = dividend % divisor;
>
> -       rbit = divisor & 0x1;
> -       roundup = (divisor >> 1) + rbit;
> -
>        while (precision != 0) {
> -               tmp = remainder - roundup;
>                quotient <<= 1;
> -               if (remainder >= roundup)
> -                       remainder = (tmp << 1) + rbit;
> -               else
> -                       remainder <<= 1;
> +               quotient |= (remainder << 1) / divisor;
> +               remainder = (remainder << 1) % divisor;
>                precision--;
>        }

Unless precision is 0, this just added a bunch of divides into
the inner loop, which might be a big surprise to anyone expecting
this to be fast...

-- 
Bob Copeland %% www.bobcopeland.com
