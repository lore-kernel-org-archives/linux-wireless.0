Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYCaL7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 07:59:16 -0400
Subject: Re: "Try to stop Tx aggregation on non active TID" messages
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com> (sfid-20080330_125632_683065_10482C70)
References: <1206568750.22530.8.camel@johannes.berg>
	 <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com>
	 <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com>
	 (sfid-20080330_125632_683065_10482C70)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-elQfTSS8IFoRz4Oz6XHX"
Date: Mon, 31 Mar 2008 13:59:10 +0200
Message-Id: <1206964750.5468.9.camel@johannes.berg> (sfid-20080331_125920_820762_662ED4BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-elQfTSS8IFoRz4Oz6XHX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > yes, i noticed that. the prints are coming of course from the MLME
> > itself that can be called while no session is in progress and checks
> > the status when called.
> > i'll do a quick check to decide which way is better (outside check of
> > the state machine or just a silent discard of non active TIDs
> > requests) and fix it.
> > Ron
>=20
> ok, i checked it. i think it is the same as the Rx issue we had. those
> prints can be eliminated by .config file's MAC80211_HT_DEBUG. if we
> don't use this flag what's the use of it? if we do use it, i would
> like to insert the Rx prints back as well.

Well, yes, but I think most debugging features in mac80211 should enable
us to see things going wrong, not totally flood us in messages. YMMV,
but if these things drown you in messages then even developers will not
enable them by default which means that they've effectively been made
useless [1]. Hence, I think _DEBUG symbols should be ok to enable by
default, not print too many messages but enable just some important
messages and further debugging checks.

Now, maybe that message is actually one of such debugging checks, in
that it tells you when you did a wrong (i.e. while not enabled) call.
But then mac80211 itself shouldn't do such calls.

johannes

[1] as, incidentally, you can see in the current wireless tree from a
few days ago, iwlwifi with debugging doesn't even compile!

--=-elQfTSS8IFoRz4Oz6XHX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/DSDaVg1VMiehFYAQJf3g/8C8kZgHfHijW3466i9/BBRqb/aWfHC+dm
+gSvUCnMRDEBjmLuqBYeYLo003EWdMWKbRk2YmyZJHrTIfe5AMmunvnl0V5Kx9RS
dpmGyjnc5q3MH55Vc8uTlI10UqQh9yhLpbaOQayoGQt6I3vqUT29EpVXSbNhVDAH
GwsTWCDPmjFEalsal8Jox7LI4CsDI2TRW2BIf0hZWCiz6RGZeUAsdV4SV+gA+umb
0vbaUa1zm8DyCPdR6EdYmyTFM+IVHznr6wigj6LoXJnORUnXpS956p0n6/CoEK4d
dqNa9prF32urDnqu2jv1/w7UUxQNWG2T0RptDXRnYtSz6wMeIdw7Ze85kUYVfqug
n+xwa8rT9eYXpReiQtRN8hNmH+SJ4IMLkRW+j/go6ZWnBOHTrJq2PfW0ToDp1oKc
BA3GD4EKlXGgTSdPBp/GaQFMmZ9wFlYAx5WQUDbKm3J1XbQ7pLkAZFWiugJRF1m2
UokCLf1APWe9ZqCHjqyuBoyDORWT1bB1g6TqlvVYFLqJYdxGUzxXTrkScxDpe3GB
KVaGC+d5K6S4VOPtBIoP4HGQ638ZdhubEK11oVvWsfq1uIWg7VIXoeaeiqZonwTc
dsVnxUfj0/wOMHhsNlp5Hps+YvO105dfRz1/04pFW76I0AmlI8gxOc1JLDJ/lNcJ
kjvQ7f7uuPA=
=J4ju
-----END PGP SIGNATURE-----

--=-elQfTSS8IFoRz4Oz6XHX--

