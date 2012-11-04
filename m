Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34331 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2KDLKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2012 06:10:45 -0500
Received: by mail-ob0-f174.google.com with SMTP id uo13so4868171obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2012 03:10:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <508EB783.9080000@candelatech.com>
References: <508EB783.9080000@candelatech.com>
Date: Sun, 4 Nov 2012 13:10:44 +0200
Message-ID: <CAFtRNNwgM-EF=rkzSupRZxXD8r-Yppt4KCDQV5B0-JxGP6da8Q@mail.gmail.com> (sfid-20121104_121107_105043_A422D514)
Subject: Re: Any thoughts on how to best shield u.fl connectors on NICs?
From: Nick Kossifidis <mickflemm@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/29 Ben Greear <greearb@candelatech.com>:
> It appears hard to get well-shielded u.fl (IPEX) to SMA pigtails, and all of
> the
> modern ath9k NICs I've seen use u.fl connectors on the NIC.
>
> I have found a vendor that will do double-shielded 1.32mm cable, and I have
> some of those
> on order, but the way u.fl connectors are made it seems there is always a
> bit of un-shielded
> cable where the connector is crimped onto the cable.
>
> I am curious if anyone has any suggestions or experience with connecting
> u.fl NICs to
> SMA cables in a highly shielded manner...
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Ben ;-)

I've used a setup like this on the lab I work at to do some mac/phy
experiments and spectrum analyzer measurements on ath5k cards

card -> ufl-sma pigtail -> sma -> rf cable -> nmale -> attenuator <-
nmale <- rf cable <- sma <- pigtail <- card

This was done on 2 pair of cards for both tx and rx antenas (using the
debug mode on ath5k that does tx on one antenna and rx on the other
one). Then the attenuator of the tx path of link a was connected
together with the attenuator of the rx path of link b. The idea was to
mix one link's rx path with the other link's tx path to see at what
channel distance we could get the cards to sense non-idle channel and
cause one of the two links to lose packets etc.

If you maintain a sane channel distance (more than 2 channels) you
won't have any problems, if you want to transmit closer or even on the
same channel then no matter what you do you'll always have some
interference, even the angle of the ufl connector matters. I suggest
you go for mmcx connectors and pcmcia cards (that are fully shielded)
and even there there is still leakage at some point (you can measure
it with a spectrum analyzer) that might affect your measurements. It
worked for us (here is a related paper btw
http://www.eu-mesh.eu/files/publications/RWS2008.pdf)

The closer you can get to a "shielded" approach with a mini-pci card
is a card with mmcx connectors and shielding around them like this one
http://www.ubnt.com/sr7115

Then use high quality mmcx pigtails and cables (e.g. check out
http://www.fab-corp.com/) and keep them to some distance from each
other and "stacked" (see photos below).

If you have multiple cards on the same box and want a highly shielded
environment you also have to worry about IF leakage and you can't get
rid of this one by maintaining channel distance. Most of the
mini-pci(-e) cards should have shielding around the RF chip but only
from one side of the card, leaving the back side exposed. Wraping them
with foil etc will result heat problems and increased thermal noise so
it's not an option. Again I suggest you go with pcmcia cards or
expresscards.

As for the antenna trace from the chip to the ufl port if it's length
is not a multiple of the half-wavelength of the channel you are at you
don't need to worry much about it.

Finaly I suggest you go for 5Ghz, not only because there are few APs
out there that operate on 5Ghz but also because of the band's
propagation properties etc.

Now does it all matter ?

In my opinion unless you want to do some highly acurate lab
measurements for academic usage, it doesn't. In practice even on
highly congested environments you can get your links to work just fine
if you design them propertly, you don't have to go extreme on
shielding. Here are a few examles of some of our outdoor setups on
awmn (all on 5Ghz)...

Example 1:

3 mini-pci cards very close together
http://info.awmn.net/album.php?albumid=68&attachmentid=29795
and another 3 (and many more :P)
http://info.awmn.net/album.php?albumid=68&attachmentid=29812
on this rooftop
http://info.awmn.net/album.php?albumid=68&attachmentid=29802

Example 2 (this one is one of our "stable" bases):

Again 3 cards very close together
http://info.awmn.net/album.php?albumid=37&attachmentid=25537
on a tower mast on top of mount Parnitha, together with cell phone
towers and tv broadcast antennas (some of them are actually very close
to our IF btw)
http://info.awmn.net/album.php?albumid=37&attachmentid=25415
that goes like this in the winter :P
http://info.awmn.net/album.php?albumid=22&attachmentid=24869

In my experience you should focus on these factors for start:

a) Your antenna (you might notice we use handmade antennas using
offset dishes or dish antennas to reduce front-to-back ratio, very few
grid antennas, mostly used for backup 2.4 links)
b) Minimize rf cable length (you 'll notice that most boxes are
mounted right behind the antenna, that's because you 'll get more
interference from the rf cables than your pigtails and the dielectric
inside the cables is more vulnerable to moisture etc)
c) Channel and band selection (go for 5Ghz, use non overlaping
channels and in case of too-many antennas like the first example,
chose carefuly which box will operate on which channel, maintain a
distance between them and make sure the antennas look on oposite
directions).
d) Make sure your cards are not back to back since the back sides are
not shielded (you'll notice they are "stacked").

Good luck and have fun ;-)

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
