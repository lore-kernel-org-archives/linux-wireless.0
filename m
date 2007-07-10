Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbXGKJkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:00 -0400
Subject: Re: Problems with promiscuous mode fixed - wireshark
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910707071309u101a890fl3e1013c10226961d@mail.gmail.com>
References: <9e4733910707071309u101a890fl3e1013c10226961d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TE7FQCawuwhNp/bnpcPl"
Date: Wed, 11 Jul 2007 00:54:52 +0200
Message-Id: <1184108092.3738.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TE7FQCawuwhNp/bnpcPl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-07 at 16:09 -0400, Jon Smirl wrote:
> I've fixed the promiscuous problem but I don't know what the cause
> was. I noticed that when I captured a lot of packets with libpcap, it
> and the adapter were reporting the same number of packets seen. That
> implied that nothing was missing which made me suspect wireshark.
> Deleting the .wireshark directory made all of the missing packets
> appear. So I must have done something to wireshark to make it filter
> out packets that weren't directed to me in a way that it remembered
> the filter across restarts, but I don't know what I did to get it in
> that mode. tcpdump was getting the packets, but I was writing them to
> a file and using wireshark to look at them.

Weird. I'll try to remember that for next time :)

> Something is still wrong with the radio tap headers. Using the bcm4318
> all of my packets say they were captured on channel 3, when they were
> captured from channel 1. This may be a problem with wireshark. The
> beacons show channel 1 in tcpdump, and channel 3 in wireshark.

That can actually happen; getting packets from channel 1 on channel 3
isn't uncommon. Double-check with iwconfig.

> Have the structures for radio tap been changed? That could explain
> things if wireshark is compiled with the old version. I'm using
> 0.99.4-6 from ubuntu.

Well, wireshark does in fact have missing definitions for some radiotap
things and I think one or two things are actually wrong as well, but
nothing that would have this effect.

> So now I can get back to my original goal of get zd1211/rt2x00 to run
> on an ARM with mac80211 and OLSR. I can say that the zd1211 and rt2x00
> mac80211 drivers appear to be working much better now than they were
> six months ago.

:)

johannes

--=-TE7FQCawuwhNp/bnpcPl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlA48/ETPhpq3jKURAghcAJ9RtxREcr+CtpodUysMeDxTdYQ74wCeL0nz
4WpRLvfDftkYqPk9lyZP464=
=92b3
-----END PGP SIGNATURE-----

--=-TE7FQCawuwhNp/bnpcPl--

