Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:12251 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXJICbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 22:31:33 -0400
Received: by nz-out-0506.google.com with SMTP id s18so813880nze
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 19:31:33 -0700 (PDT)
Message-ID: <40f31dec0710081931y7573dafeidf414c0d89ab11b9@mail.gmail.com> (sfid-20071009_033146_707983_AFDC3D7A)
Date: Tue, 9 Oct 2007 05:31:32 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/6] ath5k: Ported new initval changes from OpenBSD to ath5k
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20071008203852.GB7633@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo>
	 <40f31dec0710070249p5ed648c8u61e8fe3768d934da@mail.gmail.com>
	 <20071008203852.GB7633@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/8, Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sun, Oct 07, 2007 at 02:49:23AM -0700, Nick Kossifidis wrote:
> > 2007/10/5, Luis R. Rodriguez <mcgrof@gmail.com>:
> > > Ported new initval changes from OpenBSD to ath5k to ar5212_ini[] and
> > > ar5212_ini_mode[].
> >
> > NACK
> >
> > Nothing new was introduced in OpenBSD cvs that i haven't already
> > included!, what have you ported ???
>
> Actually, you are right, an oversight by my part. Thanks for catching
> this. However after verying this I did find the one type. Please
> review.
>
> > > This also adds an O(log(N)) bitswap for one byte
> > > on ath5k_hw_bitswap(), thanks to Tom from OpenBSD.
> >
> > ACK it's used for modifying rf buffer settings...
>
> I think its easier to just new patches. I'll do so but please first
> review the small change below.
>
>   Luis
>
>
> diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
> index 1537517..f826422 100644
> --- a/drivers/net/wireless/ath5k/reg.h
> +++ b/drivers/net/wireless/ath5k/reg.h
> @@ -1980,4 +1980,4 @@ after DFS is enabled */
>  #define        AR5K_PHY_GAIN_2GHZ              0xa20c
>  #define        AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX  0x00fc0000
>  #define        AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX_S        18
> -#define        AR5K_PHY_GAIN_2GHZ_INI_5111     0x6480416c
> +#define        AR5K_PHY_GAIN_2GHZ_INI_5111     0x6448416a
>

I'll post a pach series asap here with my fixes against current
wireless-dev including your fixes on base.c/h and any other fixes
posted so far that are not included yet i hope now wireless-dev will
boot for me so i can also test them. About PHY_GAIN i did some tests
before ending up with this value, it comes from initialization of 5211
and after testing 5211+5111 and 5212+5111 combinations it seems it
performs better. The ideal solution would be to read antenna gain from
eeprom and somehow calculate this value dynamicaly instead of putting
a static one.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
