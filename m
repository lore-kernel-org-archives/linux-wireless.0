Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:11084 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbXEMIOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2007 04:14:47 -0400
Received: by ug-out-1314.google.com with SMTP id 44so1118426uga
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2007 01:14:45 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Date: Sun, 13 May 2007 10:13:15 +0200
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <200705111559.41153.flamingice@sourmilk.net> <20070512191749.GA6018@tuxdriver.com>
In-Reply-To: <20070512191749.GA6018@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705131013.15985.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 May 2007 21:17, John W. Linville wrote:
> On Fri, May 11, 2007 at 03:59:40PM -0400, Michael Wu wrote:
> 
> > +static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
> > +{
> > +	eeprom->reg_data_clock = 1;
> > +	eeprom->register_write(eeprom);
> > +	udelay(1);
> > +}
> > +
> > +static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
> > +{
> > +	eeprom->reg_data_clock = 0;
> > +	eeprom->register_write(eeprom);
> > +	udelay(1);
> > +}
> 
> I'm with Jeff, these udelay's should go.  If they belong anywhere, it
> would be in the write routines provided by the caller.  For example, the
> routines provided by rtl8187 already have a delay in them.  Other
> hardware might actually have a hardware timer to implement delays (hey,
> it's possible).  Either way, this delay is superfluous.

This udelay() was taken from the original implementation by Ralink,
They didn't place a comment about why the udelay should be there,
but apparently they did it for some reason...

> > +}
> > +EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
> > +
> 
> It's pedantic, but I hate empty lines at the end of files...

GCC usually complains when a file does not have a empty line
at the end of the file.

Ivo
