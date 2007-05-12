Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2838 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbXELTcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 May 2007 15:32:41 -0400
Date: Sat, 12 May 2007 15:17:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Message-ID: <20070512191749.GA6018@tuxdriver.com>
References: <200705111559.41153.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705111559.41153.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 11, 2007 at 03:59:40PM -0400, Michael Wu wrote:

> +static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
> +{
> +	eeprom->reg_data_clock = 1;
> +	eeprom->register_write(eeprom);
> +	udelay(1);
> +}
> +
> +static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
> +{
> +	eeprom->reg_data_clock = 0;
> +	eeprom->register_write(eeprom);
> +	udelay(1);
> +}

I'm with Jeff, these udelay's should go.  If they belong anywhere, it
would be in the write routines provided by the caller.  For example, the
routines provided by rtl8187 already have a delay in them.  Other
hardware might actually have a hardware timer to implement delays (hey,
it's possible).  Either way, this delay is superfluous.

> +}
> +EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
> +

It's pedantic, but I hate empty lines at the end of files...

John
-- 
John W. Linville
linville@tuxdriver.com
