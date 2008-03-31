Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbYDALrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:47:00 -0400
Subject: Re: mac80211 MLME scanning - BSS list trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@clemson.edu>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240803310710w24a057j7687411cb20985db@mail.gmail.com> (sfid-20080331_151036_058996_694F6D84)
References: <1206865999.22530.187.camel@johannes.berg>
	 <1ba2fa240803310710w24a057j7687411cb20985db@mail.gmail.com>
	 (sfid-20080331_151036_058996_694F6D84)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-giKjmk9sXKEovoBretF1"
Date: Mon, 31 Mar 2008 20:40:40 +0200
Message-Id: <1206988840.5143.5.camel@johannes.berg> (sfid-20080401_124723_517033_FDA0BA48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-giKjmk9sXKEovoBretF1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  The second problem is the one Bill Moss and Vladimir Koutny were runni=
ng
> >  into. As soon as we receive a probe response from a BSS, we never agai=
n
> >  update it from beacons, hence userspace can never find an AP during
> >  passive scanning if we've seen that BSSID before during an active scan=
.

[...]

> For example WMM parameters are not present in beacon but are present
> in probe response.
> What is needed here is being selective what is updated and what not.
> What is for sure you need at least one probe response before you can asso=
ciate.

Hm, isn't that particular information also contained in association
responses? I don't think receiving probe responses is really required,
which IEs do you have in mind that aren't also part of the association
exchange?

It does seem that the current code is not correct if we allow going from
"have IE" to "don't have IE" when updating from beacons, but I don't see
why probe responses should actually be required, and we certainly do not
try to enforce that.

In any case, do you have any idea how to fix this problem? Simply update
things selectively? Do you want to take over handling it? :)

Also, I'm not sure why it shows up with iwlwifi but no other hardware,
does iwlwifi filter out probe responses if it got a beacon for the same
BSSID or something like that?

johannes

--=-giKjmk9sXKEovoBretF1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/EwJqVg1VMiehFYAQK2+RAAwsJcHagto1nLL6kYq52zo1knIsrk/3nL
7lGCwZIJoXw99PU6ZGT95dRyQ21TlAk7lPCcm/xgu2hakeLStKub2yX7G/iW1oL+
Q21msyfzx3OyLV+AT+/OlwNUvvetUOG35c96xg3yVcyt1TWOjt85Rf8gPbsd+0QF
bSbEt81S+YeYm/iDRS01maNX/fB+mgo3IrcvJkdB+pHMwnNg6qgx0uaQ8K0hvBYI
H4I0Zn9FUZFX9E8jcg6uFqkafCw2pRBYaxZ4Kr36R5noiWU8V7R64tDtqFlkttsx
NNiZgZHfLwt7fEv37zv4fdGyIMguZimNE/mLqIHOGEs3XkQD3/Trdx/kizKt84a9
580YMHorLvIxOc9PvFHKGPN65xqaLQENeV/hNCGqFLMcFsvxap0Cv4PtcVfeaqg2
09xVuY6fA3L3g4a5E9Oy2ZoHrxInbX6sJjT0qLpC0wyq2A4BsqxkQcoESSlO7mNH
fWnfVhiAU3GPw8DDk0guC/lvfWc5pDXwZsaqU7I2A7cMviSrF5gP8kYvR2nO7ocu
zMEdfq5e7v84R0+tIiXEsOt+RmE7HG/IPQGHhw5Q8CYO6ZqyojZjvK+YTYLPFQyI
LJ/Mab5tlAfhKq8UvbQpMj2TzMYbNu4D2ysTVztsoxNXp4/2DCotBGP5/GrzPbEd
4zlwaGhvK1o=
=3wot
-----END PGP SIGNATURE-----

--=-giKjmk9sXKEovoBretF1--

