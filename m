Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193AbXIUOf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 10:35:57 -0400
Subject: Re: wext 64-bit: network manager and wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070920205602.GA15373@bougret.hpl.hp.com>
References: <1190292526.18521.52.camel@johannes.berg>
	 <20070920165545.GA29452@bougret.hpl.hp.com>
	 <1190307669.18521.94.camel@johannes.berg>
	 <20070920205602.GA15373@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FDlwr8Z346KEVrADngd3"
Date: Fri, 21 Sep 2007 16:36:54 +0200
Message-Id: <1190385414.18521.148.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FDlwr8Z346KEVrADngd3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-20 at 13:56 -0700, Jean Tourrilhes wrote:

> > Does NM always use wpa_supplicant even in 0.6.5? I thought only later
> > versions deferred everything to it.
>=20
> 	That was my assumption as well, and the reason I spent time
> doing my patch. However, after your bug report, and before replying to
> you, I went back looking at the code, to verify.
> 	Well, as it happens, 0.6.5 uses wpa_supplicant for the scan if
> it's available (more below).

Hmm. ok.

> 	Ask Jouni ?
> 	For someone familiar with it, it's actually trivial, you just
> have to follow the patch for Wireless Tools. But for somebody
> unfamiliar, there is a huge learning curve.
> 	That's classical : all the eyes are on the kernel, and nobody
> care about userspace. We really should have more people familiar with
> the guts of wpa_supplicant.

Oh, I'm not too bad in wpa_supplicant. But I don't know how the
workaround you came up with works. I guess I'll have to dig into that.
You mentioned wpa_supplicant patches, do you still have those?

> > > 	Ok, I see what's happening. That would just prevent you to set
> > > authentication information, but that is not the root caause of your
> > > problems. I'll puch a fix ASAP to John.
> >=20
> > Not sure, this seems to make wpa_supplicant unhappy enough to not even
> > start doing anything. But then I configured it for WPA.
>=20
> 	Patch sent. Can't do harm anyway.

I'll give that a try next week.

> 	I'm currently stuck because I don't have a box handy to try
> NetworkManager on, most of my boxes are without all the Gnome
> overhead. I'll try to fix that, but it may take a few days.
> 	Meanwhile, I made a few patch just for you for NetworkManager
> 0.6.5. I could not even try to compile it (./configure dependancy), so
> beware.
>=20
> 	The first patch fix the event parsing code to use the libiw
> helpers. As you can see, this dramatically reduce the code
> complexity. However, as this code does not use the payload of events,
> it should not have been affected by the 32-64 bit issue.
>=20
> 	The second patch force NetworkManager to always use its own
> scanning code. This is a quick hack, I don't know what will be the
> interaction with wpa_supplicant and I don't know when this part of
> NetworkManager was last tested.
> 	In theory, with that change, you should start to see a list of
> networks in NetworkManager.

I may take a look, but my quad box isn't online and I usually don't have
the things fixed. In any case, my networks are all RSN-protected so if
wpa_supplicant can't talk to them that's little use to me. Hence, I'd
rather see it fixed in wpa_supplicant.

johannes

--=-FDlwr8Z346KEVrADngd3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG89cG/ETPhpq3jKURAntYAJ937mvB4kPs/juyXf9rcrMPHpWj9ACfYnDB
TQkAZLuDVv9V0Ug6at5D8JM=
=jWkg
-----END PGP SIGNATURE-----

--=-FDlwr8Z346KEVrADngd3--

