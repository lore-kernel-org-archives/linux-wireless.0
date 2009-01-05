Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52564 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZAEXpv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 18:45:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 15:45:50 -0800
Date: Mon, 5 Jan 2009 15:45:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Gertjan van Wingerde <gwingerde@kpnplanet.nl>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Message-ID: <20090105234546.GK6834@tesla> (sfid-20090106_004554_433254_0C487C1B)
References: <200901042021.10904.IvDoorn@gmail.com> <20090105200809.GH6834@tesla> <49627BCB.4020200@kpnplanet.nl> <200901052321.46422.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901052321.46422.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 02:21:46PM -0800, Ivo van Doorn wrote:
> On Monday 05 January 2009, Gertjan van Wingerde wrote:
> > On 01/05/09 21:08, Luis R. Rodriguez wrote:
> > > On Sun, Jan 04, 2009 at 11:21:10AM -0800, Ivo van Doorn wrote:
> > >
> > >> rt2500pci and rt2500usb contain a special field in the EEPROM
> > >> which indicates which regulatory domain the card belongs to.
> > >> This code can easily be translated into a country code which
> > >> we can send as alpha2 hint for CRDA.
> > >>
> > >> Please note that most cards will have 0xffff as EEPROM value,
> > >> and thus do not provide a regulatory hint through the EEPROM.
> > >>
> > >> Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>
> 
> John: Please drop this patch, a more correct patch should be merged later
> which is based on the code from Gertjan.
> 
> > > I believe regulatory_hint() is being called before the ieee80211_register_hw()
> > > call. This is not a requirement right now but I believe this should be the case
> > > in the future as we want cfg80211 to keep track a few things for the driver, like
> > > the regulatory domain it wants in case of conflicts with other drivers. I'm working
> > > on this right now so just wanted to throw that out there.
> > >
> > > Is it possible to move the regulatory_hint() to be used after ieee80211_register_hw()
> > > is called?
> 
> Sure, I was a bit doubting about the timing of the call, I noticed that zd1211rw called it during the start()
> callback function. Would that be the best location? Or right after ieee80211_register_hw()?

Doesn't really matter, so long as its after ieee80211_register_hw() has been called
would be nice.

> > The things that kept me from submitting it so far are:
> > 1. The conversion to a country code for the a-band EEPROM values is not complete / correct. So far I've been unable to map the possible code described in the EEPROM spec to real country codes.
> 
> I recall there would be a possibility to provide a custom definition for the domain, not sure if that ever went in.

Nope, we determined its not necessary because it was only required for Intel driver and
we found a better solution for them.

> > 2. I'm still puzzled how to handle the two different values that the EEPROM has, namely one for the bg band and one for the a band. I've handled it by registering the one associated with the configured band, but that seems to be unlikely to be correct. I still haven't found a better way to handle this.
> 
> Because of this I hadn't looked very deep into rt61 and rt73 yet.
> 
> > The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
> 
> For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
> comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.

Based on the documentation from the EEPROM for all devices I read that its recommended
that the EEPROM *not be relied on for the regulatory domain*, instead it recommends the
windows registry be used.

Based on tests for the devices with only one band, do are you seeing an actual regulatory
domain in the EEPROM?

To deal with the issue of having two separate EEPROM values for a regulatory domain
and since the documentation indicates to not rely on it I would advise to allow users
to be compliant by selecting the country they are in. wpa_supplicant has support for
selecting country now, and so does iw. Eventually I see Network Manager letting users
select the country. But you guys are the maintainers and developers so you will know
better.

  Luis
