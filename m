Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57659 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbYJCVcw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 17:32:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 14:32:52 -0700
Date: Fri, 3 Oct 2008 07:32:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Regulatory Framework & rt2x00.
Message-ID: <20081003143239.GI5964@tesla> (sfid-20081003_233256_812608_9C8535BC)
References: <48E52D07.8050900@kpnplanet.nl> <20081002193357.GP5960@tesla> <48E67E78.8040807@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48E67E78.8040807@kpnplanet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 03, 2008 at 01:20:08PM -0700, Gertjan van Wingerde wrote:
> My tests on the Ralink devices I have show that indeed the PCI devices
> do not contain a region indication in EEPROM. However, all the USB
> devices I have do contain such an indication (or one indication per band).

Even if they have one if the docs say to ignore it then I'd ignore it.

> Do you have any sample code available on how the Atheros devices
> interact with the regulatory framework with their EEPROM values?

Nope, not yet, rigth now we register the channels based on our EEPROM,
and the user sets the regulatory domain to enhance regulatory domain
enforcement. Later once we want to allow world roaming and support
parsing Country IEs we will take on registering all our supported
channels and then use the reg_notifier() to review the data passed
for the alpha2.

> OK. I guess that depends on what model we want to have with Linux. For
> me, the user should always have the possibility to override the HW
> settings on region, as he might have taken the HW he bought in one
> region of the world to another.

This should only be possible if the devices were designed to world roam.
Remember that world roaming is part of the IEEE-802.11 specs, and by
default devices should be assumed to not be capable of it.

For example iwl3945 or iwlagn driveres are not capable of world roaming
because as of right now these devices are not designed to allow the
driver to *add* new channels.

Also keep in mind vendors tend to want to respect the EEPROM
map of the regulatory domain. This is to deal with two issues:

1. Rogue APs sending sending a strange channels for an alpha2 through
   a Country IE

2. Vendor's customers tend to like to stick sometimes to frequency
   ranges which may be old in terms of regulatory rules because
   although the device is capable of other frequencies the customer
   may not have tested the device or certified it under the other
   channels even adding a new channel may be seen as a feature.

So it really depends. The answer to these questions *are* really
vendor dependant and I what I would *highly* recommend is to take
a conservative approach unless you have the vendor's blessing
to do things differently, even if the vendor is not being
cooeperative. Keep in mind though that doing this requires
developer effort though so I can see why we won't have all drivers
using regulatory_hint() and a reg_notifier() for example. But
developers are forthcoming to write this then great -- if you
don't get vendor support to enhance this then its really up us
to decide what is best.

> So, as far as I am concerned the EEPROM
> information is just an initial setting, which may be overridden later.

It depends on the vendor and their policies. For ath9k for example
this is not true -- the regulatory infrastructure allows the driver
to use your EEPROM map in case vendors wish to think their map
is the better source of knowledge.

> So, at the moment, I'm not interested in using the notifier.

It requires quite some work so I can understand why you may not
be inclined to use it, but if you do get vendor support I'd
be nice for you to reconsider. Up to you though of course, as
you are doing the work :)

> I'm not entirely sure yet. The basic question I have is that if I have a
> device with has in EEPROM a region setting of US for the 5GHz band and
> EU for the 2GHz band, what do I pass to the regulatory_hint function?

Think about this for a second -- does this make any sense? I don't see
how. Perhaps this is why its not recommended you rely on it. In the end,
you won't know unless you ask the vendor.

  Luis
