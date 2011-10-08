Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45265 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1JHWv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 18:51:56 -0400
Date: Sun, 9 Oct 2011 00:51:07 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
Message-ID: <20111009005107.43a49372@milhouse> (sfid-20111009_005200_663046_8BE11C03)
In-Reply-To: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 08 Oct 2011 17:28:42 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The kernel now contains library routines to establish crc8 tables and
> to calculate the appropriate sums. Use them for ssb.

> +static u8 srom_crc8_table[CRC8_TABLE_SIZE];
> +
> +/* Polynomial:   x^8 + x^7 + x^6 + x^4 + x^2 + 1   */
> +#define SROM_CRC8_POLY	0xAB
> +
> +static inline void ltoh16_buf(u16 *buf, unsigned int size)
>  {
> +	size /= 2;
> +	while (size--)
> +		*(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
> +}
>  
> -	return crc;
> +static inline void htol16_buf(u16 *buf, unsigned int size)
> +{
> +	size /= 2;
> +	while (size--)
> +		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
>  }

>  		return -ENOMEM;
> +	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
>  	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
>  	sprom_do_read(bus, buf);
> +	/* convert to le */
> +	htol16_buf(buf, 2 * bus->sprom_size);

>  		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
>  		sprom_do_read(bus, buf);
> +		htol16_buf(buf, 2 * bus->sprom_size);
>  		err = sprom_check_crc(buf, bus->sprom_size);

> +	/* restore endianess */
> +	ltoh16_buf(buf, 2 * bus->sprom_size);
>  	err = sprom_extract(bus, sprom, buf, bus->sprom_size);

This endianness stuff is _really_ ugly.
Does this patch decrease the code size, at least? I'll almost doubt it.
If it doesn't, why are we actually doing this?
It doesn't even decrease the .data size. Worse, it converts a .const
table to a .data table.

Just my 2 cents.

-- 
Greetings, Michael.
