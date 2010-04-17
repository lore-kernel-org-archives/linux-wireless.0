Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56804.mail.re3.yahoo.com ([66.196.97.78]:30925 "HELO
	web56804.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751651Ab0DQNJv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 09:09:51 -0400
Message-ID: <79834.90907.qm@web56804.mail.re3.yahoo.com>
Date: Sat, 17 Apr 2010 06:09:51 -0700 (PDT)
From: Walter <goldenstranger@yahoo.com>
Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
To: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
In-Reply-To: <201004171445.13785.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Ivo van Doorn <ivdoorn@gmail.com>
> Subject: Re: [rt2x00] rt3070 fails to initialize with rt2800usb
> To: "Walter" <goldenstranger@yahoo.com>
> Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
> Date: Saturday, April 17, 2010, 8:45 AM
> On Saturday 17 April 2010, Walter
> wrote:
> > I've been monitoring the community's work for the
> rt3070 chips and especially your recent success towards
> improving the driver.
> > 
> > I would like to share something with the rt2x00
> development team which may or may not be known.
> > 
> > The rt3070 card I own fails to initialize with the
> latest (working) compat-wireless release. When I plug the
> USB card, rt2800usb doesn't automatically load and when I
> manually modprobe the driver it does not recognize it as
> well.
> > 
> > Looking in to the rt2800usb.c file I found the
> 'problem'. The VIDs aren't properly set. Mine shows
> 148f:3070. Although a line is included in the "#ifdef
> CONFIG_RT2800USB_RT30XX", the module won't initialize the
> card.
> > 
> > I fixed the problem by adding my device here:
> > 
> >     /* Ralink */
> >     { USB_DEVICE(0x148f, 0x2770),
> USB_DEVICE_DATA(&rt2800usb_ops) },
> >     { USB_DEVICE(0x148f, 0x2870),
> USB_DEVICE_DATA(&rt2800usb_ops) },
> >     /* Samsung */ 
> > 
> > which now looks like:
> > 
> >     /* Ralink */
> >     { USB_DEVICE(0x148f, 0x2770),
> USB_DEVICE_DATA(&rt2800usb_ops) },
> >     { USB_DEVICE(0x148f, 0x2870),
> USB_DEVICE_DATA(&rt2800usb_ops) },
> >         {
> USB_DEVICE(0x148f, 0x3070),
> USB_DEVICE_DATA(&rt2800usb_ops) },
> >     /* Samsung */
> > 
> > This pertains to the rt3071 as well.
> 
> That USB ID is already known, did you compile the driver
> with support
> for CONFIG_RT2800USB_RT30XX enabled?
> 
> Ivo

Yes, compat-wireless ships with ''CONFIG_RT2800USB_RT30XX=y'' in config.mk, but the card's VIDs aren't shown in modinfo rt2800usb when compiled, thus the module doesn't recognize the card at all. The only workaround I rustled up is the above mentioned one. 


      
