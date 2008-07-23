Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:52826 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYGWUJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 16:09:57 -0400
Received: by py-out-1112.google.com with SMTP id p76so1858746pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 13:09:56 -0700 (PDT)
Subject: Re: [PATCH 1/4] Add new Atheros IEEE 802.11n ath9k driver
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1216842238.13587.31.camel@johannes.berg>
References: <20080720024341.GQ17936@ruslug.rutgers.edu>
	 <20080720024500.GR17936@ruslug.rutgers.edu>
	 (sfid-20080720_044515_228476_FA83BA3F)  <1216842238.13587.31.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 13:09:56 -0700
Message-Id: <1216843796.30386.13.camel@brick> (sfid-20080723_221001_954843_1556F33A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-23 at 21:43 +0200, Johannes Berg wrote:
> Only STA support is currently enabled
> +#ifndef howmany
> +#define howmany(x, y)   (((x)+((y)-1))/(y))
> +#endif

It's called DIV_ROUND_UP in kernel.h

> +#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
> +#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
> 
> Do you really need macros for this? Static inlines that do
> type-checking are so much nicer.

Or just open-code the ioread/writes

> +#define LE_READ_2(p)							\
> +	((u_int16_t)							\
> +	 ((((const u_int8_t *)(p))[0]) | \
> +		(((const u_int8_t *)(p))[1] << 8)))
> +

get_unaligned_le16()

> +#define LE_READ_4(p)							\
> +	((u_int32_t)							\
> +	 ((((const u_int8_t *)(p))[0]) | \
> +		(((const u_int8_t *)(p))[1] << 8) | \
> +		(((const u_int8_t *)(p))[2] << 16) | \
> +			(((const u_int8_t *)(p))[3] << 24)))
> 

get_unaligned_le32()

> Harvey will flame you for that. Rightfully.

;-)

> +	/* XXX: spin_lock_bh should not be used here, but sparse bitches
> +	 * otherwise. We should fix sparse :) */
> +	spin_lock_bh(&mcastq->axq_lock);
> 
> First and foremost you should write correct code regardless of whether
> sparse complains about it or not. Then let others review it and possibly
> submit a bug report to sparse. This is the wrong way around.
> 

Indeed.

> +/* Macro to expand scalars to 64-bit objects */
> +
> +#define	ito64(x) (sizeof(x) == 8) ? \
> +	(((unsigned long long int)(x)) & (0xff)) : \
> +	(sizeof(x) == 16) ? \
> +	(((unsigned long long int)(x)) & 0xffff) : \
> +	((sizeof(x) == 32) ?			\
> +	 (((unsigned long long int)(x)) & 0xffffffff) : \
> +	(unsigned long long int)(x))
> 
> Eww.

Consider using s64/u64 if you really need 64-bits.

Also, for anything shared with the hardware in a fixed endianness,
le16/32/64 and be16/32/64 are your friends.  To reiterate what
Johannes mentioned elsewhere.

Cheers,

Harvey

