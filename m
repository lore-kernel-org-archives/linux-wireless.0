Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYFYKcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 06:32:50 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806250330s15168d22i50e61498fbba6af7@mail.gmail.com> (sfid-20080625_123022_363374_D86DDC8E)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 <1213910734.8967.117.camel@johannes.berg>
	 <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com>
	 <1214388133.21847.8.camel@johannes.berg>
	 <1ba2fa240806250330s15168d22i50e61498fbba6af7@mail.gmail.com>
	 (sfid-20080625_123022_363374_D86DDC8E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VMvCLS1Y24wCtyNW8zmr"
Date: Wed, 25 Jun 2008 12:32:10 +0200
Message-Id: <1214389930.21847.12.camel@johannes.berg> (sfid-20080625_123253_448034_F4F19087)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VMvCLS1Y24wCtyNW8zmr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 13:30 +0300, Tomas Winkler wrote:

> >> So the bug is still in mac80211. Fragments are scheduled to different
> >> TIDs and hence to different queues.
> >> Investigating further. If you have something in mind let me know
> >
> > Hmm, yes, I do indeed, try
> >
> > skb_copy_queue_mapping(frag, first);
> >
> > where you previously added the cb copy.

> Yeah just found that too 2 min ago :)

:)

Before it happens again, can you think of anything else we need to copy?

johannes

--=-VMvCLS1Y24wCtyNW8zmr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYh6mAAoJEKVg1VMiehFYJbUP/12kXZVuv2QNO29rrEWZaVf0
emT+tse/Qs+m5o0Hl/xISaaBPLMwixj7YnyLLCzd7aPC60NVp3nCpjC1ZLp6LmYk
mFKJ5Knv7WZVqz1OgGbJEQrOwahKT4+I3wWex2QGYWwMNOTCZUAB3itOh2VajI8b
0eW0yjjMF/Bgm0H43mm3AlgEi6ONVQcTCScoXggJE7YNktwlB+rhmsUMP9I81pRR
olNkRrWmCf9tlZxGOtclvrIDLiRc0wffrkljNfzup6mJsAg8fLykQsa7fBR5CUMb
/scv2Uq7OHaDUpZgMgqEFoB5V2GEKISS67J2YRGRyjNfcn4hTlhmmaWg9qG5BAMB
8vRKUC6YDTYkSx2eXlhqkZN5lQDOCGM7VGNHUfMSk3rBxk71fCoexzT1b7F6cMIG
UmKV1WI0GEXmzbrCBES66lxLjTV1vdHgwVv7SRnHnUAMFMdxik97j7gUtJfzdHD1
fQNJi1dycI2U5WwW8L5RVI4NnH/qVW6deRXpPooptLhpqlbEmnVu+VPaizHcomBh
TpWLwf79jjL868QqP7nWMyhEWo+8M0TmtJV6FrQ2VQriIGF9u6gAstV51e25JGo0
2tXMAFl610cBedKmtpJ8TcMfCrz6Pqcxz3yrkeS/oDFUPyj/1Cr3eEygQM9mBRxq
8t6SvpxBop6bcWpHBy3b
=CYks
-----END PGP SIGNATURE-----

--=-VMvCLS1Y24wCtyNW8zmr--

