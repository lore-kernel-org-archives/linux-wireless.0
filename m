Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:52994 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXEMSun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2007 14:50:43 -0400
Date: Sun, 13 May 2007 14:50:38 -0400
From: Jeff Garzik <jeff@garzik.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Message-ID: <20070513185038.GA27009@havoc.gtf.org>
References: <200705111559.41153.flamingice@sourmilk.net> <20070512191749.GA6018@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070512191749.GA6018@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 12, 2007 at 03:17:49PM -0400, John W. Linville wrote:
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

I don't claim the delays were superfluous, I was just wondering if they
were papering over write-posting bugs.

	Jeff



