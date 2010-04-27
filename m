Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:25509 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0D0Lla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 07:41:30 -0400
Date: Tue, 27 Apr 2010 13:15:21 +0200
From: Antonio Quartulli <ordex@ritirata.org>
To: Helmut Schaa <Helmut.Schaa@gmx.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register
 initialization.
Message-ID: <20100427111520.GA10969@ritirata.org>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
 <1270989075-2267-7-git-send-email-gwingerde@gmail.com>
 <201004261302.14682.helmut.schaa@googlemail.com>
 <201004261311.20834.Helmut.Schaa@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201004261311.20834.Helmut.Schaa@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On lun, apr 26, 2010 at 01:11:20 +0200, Helmut Schaa wrote:
> Am Montag 26 April 2010 schrieb Helmut Schaa:
> > Am Sonntag 11 April 2010 schrieb Gertjan van Wingerde:
> > > rt2x00 had preliminary support for RT3070 based devices, but the support was
> > > incomplete.
> > > Update the RT3070 register initialization to be similar to the latest Ralink
> > > vendor driver.
> > > 
> > > With this patch my rt3070 based devices start showing a sign of life.
> > 
> > Gertjan, this patch breaks rx on my 305x SoC device. See inline comments for
> > more details.
> 
> Antonio, did that patch also break rx on your PCI device with rt2872?
> If not this is only needed for SoC.
Hi, I cloned the wireless-testing git a few minutes ago.
My card (rt2x00_set_chip: Info - Chipset detected - rt: 2872, rf: 0003,
rev: 0200) on miniPCI works correctly without any kind of problem.
No hangs at all.

Regards

> 
> Thanks,
> Helmut
>  
> > [...]
> > 
> > > @@ -1643,18 +1653,12 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
> > >  {
> > >  	u8 rfcsr;
> > >  	u8 bbp;
> > > +	u32 reg;
> > > +	u16 eeprom;
> > >  
> > > -	if (rt2x00_is_usb(rt2x00dev) &&
> > > -	    !rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
> > > +	if (!rt2x00_rt(rt2x00dev, RT3070))
> > >  		return 0;
> > >  
> > > -	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
> > > -		if (!rt2x00_rf(rt2x00dev, RF3020) &&
> > > -		    !rt2x00_rf(rt2x00dev, RF3021) &&
> > > -		    !rt2x00_rf(rt2x00dev, RF3022))
> > > -			return 0;
> > > -	}
> > 
> > Any reason why you've removed this part? The following code was executed on
> > pci and soc devices when they had an 3020, 3021 or 3022 rf.
> > 
> > >  	/*
> > >  	 * Init RF calibration.
> > >  	 */
> > > @@ -1665,13 +1669,13 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
> > >  	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
> > >  	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> > >  
> > > -	if (rt2x00_is_usb(rt2x00dev)) {
> > > +	if (rt2x00_rt(rt2x00dev, RT3070)) {
> > >  		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
> > >  		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
> > >  		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> > >  		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
> > >  		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
> > > -		rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
> > > +		rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
> > >  		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
> > >  		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
> > >  		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
> > > @@ -1684,48 +1688,25 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
> > >  		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
> > >  		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
> > >  		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
> > > -		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
> > >  		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
> > > -	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
> > > -		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
> > > -		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
> > > -		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
> > > -		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
> > > -		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
> > > -		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
> > > -		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
> > > -		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
> > > -		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
> > > -		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
> > > -		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
> > > -		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
> > > -		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
> > > -		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
> > > -		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
> > > -		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
> > > -		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
> > > -		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
> > > -		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
> > > -		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
> > > -		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
> > > -		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
> > > -		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
> > > -		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
> > > -		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
> > > -		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
> > > -		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
> > > -		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
> > > -		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
> > > -		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
> > 
> > This part is actually needed for getting rx to work on the SoC devices.
> > 
> > Should I post a patch that adds this code again and is only executed on SoC
> > devices with rf3020, 3021 and 3022?
> > 
> > Thanks,
> > Helmut
> > 

-- 
Antonio Quartulli

Ognuno di noi, da solo, non vale nulla 
Ernesto "Che" Guevara
