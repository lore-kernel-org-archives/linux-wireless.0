Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:43055 "HELO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751030AbZLMMzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 07:55:31 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Julia Lawall <julia@diku.dk>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/9] drivers/net/wireless: Correct code taking the size of a pointer
References: <Pine.LNX.4.64.0912131241470.24267@ask.diku.dk>
Date: Sun, 13 Dec 2009 13:55:26 +0100
In-Reply-To: <Pine.LNX.4.64.0912131241470.24267@ask.diku.dk> (Julia Lawall's
	message of "Sun, 13 Dec 2009 12:42:07 +0100 (CET)")
Message-ID: <m2iqcbt4n5.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julia Lawall <julia@diku.dk> writes:

> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index eb1e1d0..1e74732 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2140,8 +2140,8 @@ static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
>  	rt2800_register_multiread(rt2x00dev, offset,
>  				      &iveiv_entry, sizeof(iveiv_entry));
>  
> -	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
> -	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
> +	memcpy(&iveiv_entry.iv[0], iv16, sizeof(*iv16));
> +	memcpy(&iveiv_entry.iv[4], iv32, sizeof(*iv32));

That still looks pretty bogus, the memcpy calls are overwriting the
values written by the previous rt2800_register_multiread call.  Most
likely the first two arguments need to be swapped.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
