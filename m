Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYBFQ3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 11:29:05 -0500
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com> (sfid-20080206_161856_935506_9270D886)
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 <1202309885.9965.3.camel@johannes.berg>
	 <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com>
	 (sfid-20080206_161856_935506_9270D886)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7f1UN1t1Lw0lcG6yz9dX"
Date: Wed, 06 Feb 2008 17:28:49 +0100
Message-Id: <1202315330.9965.16.camel@johannes.berg> (sfid-20080206_162909_053168_8D8D219B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7f1UN1t1Lw0lcG6yz9dX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Maybe I'm locked in concepts of iwlwifi but I believe also other
> drivers uses similar concept. I think USB has some URB complete
> handler etc.  So iwlwifi get interrupt (asynchronous) when packet is
> transmitted (TX response flow) and driver retrieves the information of
> transmitting. This is NOT done in TX contexts so you have to store
> tx_status between TX flows and TX response flow so you can feed it
> back to ieee80211_tx_status_irqsafe

Ah. But where's the difference between "TX response" and "TX status"
then? Anyway, yes, you do have to store the info between ->tx() and
tx_status().

> Not sure which flow will free this pointer ? Iwlwifi keeps tx_status
> attached to TBD so it have to be sure it won't be overriden somewhere
> in the stack.  But it might be a case that I'm not understand here
> something

I'd think that mac80211 would free it. I guess we should then have
something like

static inline struct ieee80211_tx_status *
ieee80211_alloc_tx_status(size_t num_rate_ctrl)
{
	struct ieee80211_tx_status *s;
	s =3D kzalloc(... the expression you had earlier...);
	if (s)
		s->num_rate_control =3D num_rate_control;
	return s;
}

so that we can change that w/o changing all drivers. In fact, you'd
probably already allocate that in the TX flow and keep it around until
TX status.

Mind you, I'm just writing whatever comes to my head ;) Better ideas
welcome, especially since this makes tx_status_irqsafe() and tx_status()
behave completely differently. Incidentally, why does iwlwifi use both
depending on in_interrupt(), or rather, why isn't the content statically
known?

johannes

--=-7f1UN1t1Lw0lcG6yz9dX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6ngQKVg1VMiehFYAQKo0hAAifVCn7600CrfkElbLl4OGgAN4SWpiH/j
FozF3ob73h7n6A3T3dxCGKZMYqx5RJGO4XSZTjQK1LRftHdFno5Kaz5KoX7a/yrA
Z/MqD3/ROTI6DQXprG031x7+71KwEt4eKUSumnG5kilWYu4qpvoLZweW+G8nhPNQ
npipH56Lq3GaoJ804CepnHKh4HygP7UAu5M/e0F3jrep5tV4699gOVl9pNYXYI45
cMy2RD0F/50xJfMuEk0JevjxWTXrc72hWu2YBk1RT3lvOvgj3HRqqmULmNOuwjWm
C1t0DzdHKqbXgn12LPhag/blfn1UeifZE3uNxlEgVoivRLm9HTeXUh+BIitUBQbx
BB75eRLC+HBXTGK7o9bRWpsDqkAR6ARNueMu3nPo93Ij/V/mkbR0AsE8IUbG68K4
Rm9FREkEpksmDViRfy+BXs2DE+hil6q9rBV42R6T26YctO9X7PS2nC6jCboQ9AWM
N4M/yoeRo0FMMRiosnjQtUE3v8SoXOLyctK2UkpF1JD/45NGc0igJOtV0TwXJrQ7
ea3TU94k+qTHbmYp+JpHmD8T8FY/Xz0LxMptStYCcGgCJxbqNZXkF2YudT/lh6fZ
0aa35Ioz9IXFIGyGCP2vYVrCQenyg8Pn323iFIXlBnbtbiPKA2d7Amjdq2mnV9py
x0BX0BNJyOA=
=qJFE
-----END PGP SIGNATURE-----

--=-7f1UN1t1Lw0lcG6yz9dX--

