Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62021 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYJCWpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 18:45:46 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 15:45:46 -0700
Date: Fri, 3 Oct 2008 08:45:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Regulatory Framework & rt2x00.
Message-ID: <20081003154533.GK5964@tesla> (sfid-20081004_004556_630954_0215CDC1)
References: <48E52D07.8050900@kpnplanet.nl> <20081002193357.GP5960@tesla> <48E67E78.8040807@kpnplanet.nl> <20081003143239.GI5964@tesla> <48E69A8F.1060001@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48E69A8F.1060001@kpnplanet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 03, 2008 at 03:19:59PM -0700, Gertjan van Wingerde wrote:
> Luis R. Rodriguez wrote:
> >
> > This should only be possible if the devices were designed to world roam.
> > Remember that world roaming is part of the IEEE-802.11 specs, and by
> > default devices should be assumed to not be capable of it.
> >
> > For example iwl3945 or iwlagn driveres are not capable of world roaming
> > because as of right now these devices are not designed to allow the
> > driver to *add* new channels.
> >
> > Also keep in mind vendors tend to want to respect the EEPROM
> > map of the regulatory domain. This is to deal with two issues:
> >
> > 1. Rogue APs sending sending a strange channels for an alpha2 through
> >     a Country IE
> >
> > 2. Vendor's customers tend to like to stick sometimes to frequency
> >     ranges which may be old in terms of regulatory rules because
> >     although the device is capable of other frequencies the customer
> >     may not have tested the device or certified it under the other
> >     channels even adding a new channel may be seen as a feature.
> >
> > So it really depends. The answer to these questions *are* really
> > vendor dependant and I what I would *highly* recommend is to take
> > a conservative approach unless you have the vendor's blessing
> > to do things differently, even if the vendor is not being
> > cooeperative. Keep in mind though that doing this requires
> > developer effort though so I can see why we won't have all drivers
> > using regulatory_hint() and a reg_notifier() for example. But
> > developers are forthcoming to write this then great -- if you
> > don't get vendor support to enhance this then its really up us
> > to decide what is best.
> >
> 
> Hmm, interesting. I would have assumed that in this era whether people
> are traveling round the world that vendors would create some more robust
> HW that is capable of coping with that. For instance, for my real-life
> job I do travel round the world a lot, and I'm using the built-in (as
> well as the Ralink PC-card I have) basically everywhere.

Well due to the "regulatory boogeyman", as Sam likes to call it,
companies which do not have solid regulatory infrastructure tend to
like to simply not world roam or simply not deal with this in FOSS.

Fortunately now we have a pretty beefy regulatory infrastructure though
so this can change now. Keep in mind that you *shouldn't* run into
problems unless you hit channels on band edges which are usually the
ones that may get removed, like channels 12 and 13 on the 2 GHZ band,
for example.

> >> I'm not entirely sure yet. The basic question I have is that if I have a
> >> device with has in EEPROM a region setting of US for the 5GHz band and
> >> EU for the 2GHz band, what do I pass to the regulatory_hint function?
> >>
> >
> > Think about this for a second -- does this make any sense? I don't see
> > how. Perhaps this is why its not recommended you rely on it. In the end,
> > you won't know unless you ask the vendor.
> >
> 
> Yep, that's exactly the issue I had with this. It doesn't make sense to
> me to have multiple (potentially) different region codes programmed in
> EEPROM. 

Right, well I mean, it could make sense if although its "US" for 2 GHz
and "EU" for 5 GHz that this is not really an EEPROM country code but
more rather an EEPROM code for the collection of channels on each band.
In regulatory world these are called SKUs [1]. So If you start thinking
of it in terms of SKUs you then then to find what the SKU means and
simply just use that to only register those channels. This would be a
very conservative approach but it limits your devices to not be
able to world roam later. If instead you use a reg_notifier() to
review the regulatory changes and if the initiator is the user
(REGDOM_SET_BY_USER) you can then override any changes by crda as your
driver may claim to know better. That was the whole point of
reg_notifier() -- in case you want to say you know better in case of a
user override. This can then let you world roam later if the initiator
is REGDOM_SET_BY_COUNTRY_IE and you want to be more flexible there.

As you can see this requires quite a bit of work and knowledge of the
device's regulatory information and the original intentions behind the
design of the device. This is why its difficult to simply assume
you can build it on your own without vendor involvement and why I was
recommending a more conservative approach.

> Note that the example I gave is a real-life example. The EEPROM
> of my rt73usb device contain exactly these EEPROM settings for the
> region information :-(

Heh yeah, if you think in terms of SKUs it makes a little more sense, I
hope.

[1] http://en.wikipedia.org/wiki/Stock-keeping_unit
