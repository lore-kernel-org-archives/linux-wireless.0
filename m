Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXCEAQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 19:16:09 -0500
Subject: Re: Question about PRISM2 header rate field
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45EAF559.5070701@warmcat.com>
References: <45EA9E39.6080706@warmcat.com>  <45EAF559.5070701@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5YKk6cEXK5Z9mtA19Hxe"
Date: Mon, 05 Mar 2007 01:15:44 +0100
Message-Id: <1173053744.6131.40.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5YKk6cEXK5Z9mtA19Hxe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, I discover in fact you need to inject starting only from the=20
> IEEE802.11 header... and indeed that does work if you do it on the=20
> "Management Interface".  I found this from hostapd sources, since=20
> wpa_supplicant doesn't seem to inject packets from userspace,

Never versions of wpa_supplicant should do this in the userspace MLME
part.

>  it seems=20
> to trigger the stack to do canned packets by a huge range of IOCTLs.  So=20
> I have unencrypted packets in both directions now without patching=20
> anything on the kernel side :-D  But, there is a but...

:)

> The packet seems to go out at a default rate, in my case 1Mbps.  Is=20
> there in fact a method for requesting the rate for injected packets, or=20
> is there at the moment a simple equivalence that all broadcasts will go=20
> out at 1Mbps?

Looks like you're right, there doesn't seem to be a way. I always
thought this was possible.

I think you should raise this point on the mailing list again. I've
proposed doing this through nl80211 to allow extensibility of the meta
information (frame rate, ....) for an injected frame instead of
conjuring up yet another meta information framework that transports
frame across netdevs, but Michael strongly opposes the idea of
transporting frames via anything but a netdev.

I could post some code for nl80211 inject that doesn't control any meta
information yet but at least has the capability of carrying it over to
the stack.

johannes

--=-5YKk6cEXK5Z9mtA19Hxe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF62Ew/ETPhpq3jKURAnM+AKCq83umfX+qgCcFOE2AReHrSXKJ1QCfTGiO
Fs8l2H+gmOgPcEmVKJVVii0=
=US2d
-----END PGP SIGNATURE-----

--=-5YKk6cEXK5Z9mtA19Hxe--

