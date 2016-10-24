Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49107 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935051AbcJXOgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 10:36:55 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Date: Mon, 24 Oct 2016 16:36:51 +0200
Message-ID: <4116422.yZP7iyh9mq@prime> (sfid-20161024_163712_475199_3642E09D)
In-Reply-To: <1477318562.4085.28.camel@sipsolutions.net>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com> <3178350.ZYYEYN7rIx@prime> <1477318562.4085.28.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1674394.Csatchs6FI"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1674394.Csatchs6FI
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, October 24, 2016 4:16:02 PM CEST Johannes Berg wrote:
> On Mon, 2016-10-24 at 15:42 +0200, Simon Wunderlich wrote:
> > Otherwise, it would be pretty much impossible to perform CSAs to
> > another DFS channel.
> 
> I was told that to do that you'd need another NIC that's pre-CAC'ing
> another channel.

Here is the portion from ETSI 301 893 v1.8.1 [1] (the most recent one to my 
knowledege), section 4.7.1.4 which describes operation from master devices 
(Access Points):

<snip>

b) A master device shall only start operations on Available Channels. At  
installation (or reinstallation) of the equipment, the RLAN is assumed to have 
no Available Channels within the band 5 250 MHz to 5 350 MHz and/or 5 470 MHz 
to 5 725 MHz. In such a case, before starting operations on one or more of 
these channels, the master device shall perform either a Channel Availability 
Check or an Off-Channel CAC to ensure that there are no radars operating on 
any selected channel. If no radar has been detected, the channel(s) becomes an
Available Channel(s) and remains as such until a radar signal is detected 
during the In-Service Monitoring.

The Channel Availability Check or the Off-Channel CAC may be performed over a 
wider bandwidth such that all channels within the tested bandwidth become 
Available Channels. 

NOTE 1:The initial Channel Availability Check may be activated manually at 
installation or reinstallation of the equipment.

c) Once the RLAN has started operations on an Available Channel, then that 
channel becomes an Operating Channel. During normal operation, the master 
device shall monitor all Operating Channels (In-Service Monitoring) to ensure 
that there is no radar operating within these channel(s). If no radar was 
detected on an Operating Channel but the RLAN stops operating on that channel, 
then the channel becomes an Available Channel.

NOTE 2:An RLAN is allowed to start transmissions on multiple (adjacent or non-
adjacent) Available Channels. In this case all these channels become Operating 
Channels.

<snap>

As I interpret this, (b) states explicitly that we can have many available 
channels. We only need to mark channels where we detect a radar. 

BTW, there was also something like a 24h disconnect previously, which was 
removed in 2009 [2].

Cheers,
     Simon

[1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.08.01_60/
en_301893v010801p.pdf
[2] http://www.wlan-skynet.de/docs/rechtliches/etsi_301_893.shtml (german 
only)
> 
> johannes


--nextPart1674394.Csatchs6FI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYDhyDAAoJEKEr45hCkp6hBJEP/3Fe+NGd6VwDHNdLBbt2gq80
KGhm9p6HrBtR7MdkhCDg+vt7S8Ah6bQ+aQD7cpJDfYSP7nO01IosPIRukqBseZGU
K5wgGP/7kM0ou5WxG123IVrp71NTyiXu9klo4VnbNvfKWLziK9ENyt8yNvI4VloP
3xaS9KoRPibql4x9j1ZdK6iZ2op5sQ4o4dMXfeoJ4zy4T+gnz5tuTPyFSY2/mUIR
cNn6pU9fdrq29uGXnByyapZ5rnKWEl6W+7Bu/6KmrydLxYjpb1mUpi5vd8x2b2Zx
eoc2L3Kowe46u5p6R0ZbClwID6mabBYx4ghUAygvdUdGsHBVxIiJgQsRy1k1RWVX
VSymhXZjuDuR6qn7KwoS8E3LyhBMtDFL3Efb6mfKeLXkvoriAQUiesgO+WaXQnaO
jfb+136If8BiK+XL6ensyiTf208S381rZOi5k7f+Oz9Ogbnvil8b6VDgWy1aQV3Z
JTdcXj7pzzqw+Wv1DsiUe4CSTJ1yTzkIJqbzFWG/gH/YnsAPjKJuZoYNeYTZTdS9
omfNMom1G4pA6VUOOaR38iUWgE4ktgQNoi3HXRmG081Yr0dFBN4QcQFlLNCIVFpU
tHQKNule9RI8019V1+ASVinliIkFZYM6HKXeRpGD67Gu88p8B6ZRSty45Q7KCqAO
8Gg9ZreRxkcYmiI0KOe9
=dI9I
-----END PGP SIGNATURE-----

--nextPart1674394.Csatchs6FI--
