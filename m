Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2922 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022AbXENSCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 14:02:42 -0400
Date: Mon, 14 May 2007 13:45:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Message-ID: <20070514174507.GA6999@tuxdriver.com>
References: <200705111559.41153.flamingice@sourmilk.net> <20070512191749.GA6018@tuxdriver.com> <20070513185038.GA27009@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070513185038.GA27009@havoc.gtf.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 13, 2007 at 02:50:38PM -0400, Jeff Garzik wrote:
> On Sat, May 12, 2007 at 03:17:49PM -0400, John W. Linville wrote:
> > On Fri, May 11, 2007 at 03:59:40PM -0400, Michael Wu wrote:
> > 
> > > +static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
> > > +{
> > > +	eeprom->reg_data_clock = 1;
> > > +	eeprom->register_write(eeprom);
> > > +	udelay(1);
> > > +}
> > > +
> > > +static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
> > > +{
> > > +	eeprom->reg_data_clock = 0;
> > > +	eeprom->register_write(eeprom);
> > > +	udelay(1);
> > > +}
> > 
> > I'm with Jeff, these udelay's should go.  If they belong anywhere, it
> > would be in the write routines provided by the caller.  For example, the
> > routines provided by rtl8187 already have a delay in them.  Other
> > hardware might actually have a hardware timer to implement delays (hey,
> > it's possible).  Either way, this delay is superfluous.
> 
> I don't claim the delays were superfluous, I was just wondering if they
> were papering over write-posting bugs.

OK, let's straighten this out...datasheet here:

	http://ww1.microchip.com/downloads/en/DeviceDoc/21749F.pdf

Figure 1-1 and Table 1-2 on pages 4-5 indicate that both Clock High
Time and Clock Low Time have largest minimum times of 450ns.  So,
the udelay(1) here seems both appropriately sized and appropriately
placed here as part of the eeprom access protocol.

This does shift Jeff's original question re: write posting onto the
->register_write routines passed-in by rtl8187 instead.

John
-- 
John W. Linville
linville@tuxdriver.com
