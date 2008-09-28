Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:6477 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYI1JYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 05:24:12 -0400
Received: by nf-out-0910.google.com with SMTP id d3so527343nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 02:24:10 -0700 (PDT)
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH -mm] rt2x00: fix Kconfig dependencies
Date: Sun, 28 Sep 2008 11:24:07 +0200
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
References: <48D82A43.7040604@oracle.com> <200809240045.28976.IvDoorn@gmail.com> <48DF4863.9070806@kpnplanet.nl>
In-Reply-To: <48DF4863.9070806@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809281124.07434.IvDoorn@gmail.com> (sfid-20080928_112417_831437_C41B875A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 September 2008, Gertjan van Wingerde wrote:
> Ivo,
> 
> Ivo van Doorn wrote:
> >> Ivo, please explain what rt2x00 module(s) you want to be built. In 
> >> English
> >> if possible, not in Kconfig language...
> >>      
> >
> > There are 3 kind of rt2x00 modules:
> > 	rt2x00lib
> > 	rt2x00pci/usb
> > 	rt2x00 driver (rt2400pci, rt2500pci, rt61pci, rt2500usb, rt73usb)
> >
> > When the user selects any of the rt2x00 drivers, the rt2x00pci/usb and rt2x00lib
> > are selected. For rt2x00lib there are some additional configuration options like
> > RT2X00_LIB_RFKILL and RT2X00_LIB_LEDS which will build into rt2x00lib.
> >
> > This means that when rt2400pci is selected as module, rt2x00pci and rt2x00lib
> > must be built as modules as well and when rt2400pci is selected as buildin
> > rt2x00pci and rt2x00lib must be buildin as well.
> >
> > But with the optional rt2x00lib configuration options the breakage you reported
> > is possible. So we either need:
> > 	1) Force rt2x00lib / driver to be compiled as module when RFKILL/LEDS were
> > 	    compiled as module
> > 	2) Disable config option when invalid config combination is found
> >
> > Personally I would favor 1), because 2) could lead to confusion to users
> > who think they selected everything they needed to enable support for it in
> > rt2x00.
> >    
> 
> Find attached a patch that implements option 2, along with adding a 
> warning to the user when rfkill support in rt2x00 is disabled due to the 
> invalid config combination. I've looked at implementing option 1, but 
> couldn't find a way to do it without disabling the entire rt2x00 module 
> when rfkill wasn't available.
> 
> I guess we can live with this option for now, until we have figured out 
> how to do option 1.

Sounds good, but please change RT2X00 in RT2X00_LIB

	default y if (RT2X00=y && RFKILL=y) || (RT2X00=m && RFKILL!=n)

Could you also do a similar thing for the LED handling?
That way we can fix the entire thing with a single patch. :)

Thanks,

Ivo

