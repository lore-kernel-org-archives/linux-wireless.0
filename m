Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57248 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZAFRgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:36:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 09:36:52 -0800
Date: Tue, 6 Jan 2009 09:36:47 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Gertjan van Wingerde <gwingerde@kpnplanet.nl>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Message-ID: <20090106173647.GP6834@tesla> (sfid-20090106_183656_741134_3A3F9BA8)
References: <200901042021.10904.IvDoorn@gmail.com> <200901052321.46422.IvDoorn@gmail.com> <20090105234546.GK6834@tesla> <200901061832.20529.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901061832.20529.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 09:32:20AM -0800, Ivo van Doorn wrote:
> > > Sure, I was a bit doubting about the timing of the call, I noticed that zd1211rw called it during the start()
> > > callback function. Would that be the best location? Or right after ieee80211_register_hw()?
> >
> > Doesn't really matter, so long as its after ieee80211_register_hw() has been called
> > would be nice.
> 
> Ok.
> 
> > > > 2. I'm still puzzled how to handle the two different values that the EEPROM has, namely one for the bg band and one for the a band. I've handled it by registering the one associated with the configured band, but that seems to be unlikely to be correct. I still haven't found a better way to handle this.
> > >
> > > Because of this I hadn't looked very deep into rt61 and rt73 yet.
> > >
> > > > The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
> > >
> > > For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
> > > comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.
> >
> > Based on the documentation from the EEPROM for all devices I read that its recommended
> > that the EEPROM *not be relied on for the regulatory domain*, instead it recommends the
> > windows registry be used.
> >
> > Based on tests for the devices with only one band, do are you seeing an actual regulatory
> > domain in the EEPROM?
> 
> I have to check, but I don't think I have any hardware with valid domain values.
> 
> > To deal with the issue of having two separate EEPROM values for a regulatory domain
> > and since the documentation indicates to not rely on it I would advise to allow users
> > to be compliant by selecting the country they are in. wpa_supplicant has support for
> > selecting country now, and so does iw. Eventually I see Network Manager letting users
> > select the country. But you guys are the maintainers and developers so you will know
> > better.
> 
> Well it is fine with me,  understood from earlier discussion that it was advised that drivers
> attempted to set the domain if they could. Hence the reason I had added reading the EEPROM
> for domain values to the TODO list. But it is true that it is quite rare that there are valid values
> for it. So it would be fine with me by letting the user handle it completely.

I see -- well if there are *some* cards that do have valid EEPROM values then it seems worth it
to do the actual regulatory_hint(), for dual band cards you can probably just not support it. But
its up to you guys. Just my advice based on the documentation I have read so far.

  Luis
