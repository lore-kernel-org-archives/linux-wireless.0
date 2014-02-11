Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60737 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaBKImH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 03:42:07 -0500
Received: from fb07-iapwap2.localnet ([134.176.19.122]) by mail.gmx.com
 (mrgmx102) with ESMTPSA (Nemesis) id 0MBZ9u-1W5xed3mti-00AUki for
 <linux-wireless@vger.kernel.org>; Tue, 11 Feb 2014 09:42:06 +0100
From: Marc Dietrich <marvin24@gmx.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marek Belisko <marek@goldelico.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	"ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"rob@landley.net" <rob@landley.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"neilb@suse.de" <neilb@suse.de>,
	"hns@goldelico.com" <hns@goldelico.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: rfkill-regulator: Add devicetree support.
Date: Tue, 11 Feb 2014 09:42 +0100
Message-ID: <1905162.oG8AgdvPKu@fb07-iapwap2> (sfid-20140211_094231_623879_75E9B5B9)
In-Reply-To: <20140210101842.GS25314@e106331-lin.cambridge.arm.com>
References: <1391802529-29861-1-git-send-email-marek@goldelico.com> <20140210101842.GS25314@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 10. Februar 2014, 10:18:42 schrieb Mark Rutland:
> On Fri, Feb 07, 2014 at 07:48:49PM +0000, Marek Belisko wrote:
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: Marek Belisko <marek@goldelico.com>
> > ---
> > Based on Neil's patch and extend for documentation and bindings include.
> > 
> >  .../bindings/net/rfkill/rfkill-relugator.txt       | 28 ++++++++++++++++
> >  include/dt-bindings/net/rfkill-regulator.h         | 23 +++++++++++++
> >  net/rfkill/rfkill-regulator.c                      | 38
> >  ++++++++++++++++++++++ 3 files changed, 89 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt create
> >  mode 100644 include/dt-bindings/net/rfkill-regulator.h
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt
> > b/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt new
> > file mode 100644
> > index 0000000..cdb7dd7
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/rfkill/rfkill-relugator.txt
> > @@ -0,0 +1,28 @@
> > +Regulator consumer for rfkill devices
> 
> What exactly is an "rfkill" device? How is it used? How does it relate
> to other devices in the DT?
> 
> To me, this looks like a leak of a Linux abstraction.
> 
> > +
> > +Required properties:
> > +- compatible   : Must be "rfkill-regulator".
> > +- label  : Name of rfkill device.
> 
> What's this for? Why does this need a label in the DT? Surely this can
> be implied by the relationship to a particular radio device?
> 
> > +- type  : Type of rfkill device.
> > +
> > +Possible values (defined in include/dt-bindings/net/rfkill-regulator.h):
> > +	RFKILL_TYPE_ALL
> > +	RFKILL_TYPE_WLAN
> > +	RFKILL_TYPE_BLUETOOTH
> > +	RFKILL_TYPE_UWB
> > +	RFKILL_TYPE_WIMAX
> > +	RFKILL_TYPE_WWAN
> > +	RFKILL_TYPE_GPS
> > +	RFKILL_TYPE_FM
> > +	RFKILL_TYPE_NFC
> 
> What do these mean? Why can these not be implied by a relationship to
> any devices of these particular types?

This problem comes up from time to time. rfkill-gpio has a similar problem, 
btw. You can of course list an rfkill property inside the device node where it 
is connected to, but what are you going to to if there is no device node, e.g. 
the device is enumerated on a bus (e.g. usb, pci, ...)?

In such cases it may be better to define a standalone rfkill node similar to 
the "backlight" device, even if it just contains a gpio or regulator.

Marc

