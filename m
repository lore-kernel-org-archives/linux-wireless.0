Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbYAXQzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 11:55:20 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200801241226.28394.bruno@thinktube.com>
References: <20080118125252.6455.41047.stgit@one>
	 <1201099729.3454.17.camel@johannes.berg>
	 <200801241226.28394.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DRp4eqzo7jYwFCwQe7sb"
Date: Thu, 24 Jan 2008 17:55:04 +0100
Message-Id: <1201193704.3454.137.camel@johannes.berg> (sfid-20080124_165547_277591_331A3C2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DRp4eqzo7jYwFCwQe7sb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> i can see now how you could interpret this as only applying to timers, bu=
t i=20
> think that does just not make sense - why would you want to sync timers a=
nd=20
> adapt beacon intervals if you don't share the same BSSID?

Hmm. Well I thought that was pretty much just for optimising performance
but now that I think about it again...

> i agree that the standard is quite ambigious when it comes to IBSS, but=20
> practically speaking, it is necessary to merge IBSS cells most of the tim=
e if=20
> you want to have IBSS working as expected. therefore i tend to interpret =
the=20
> ambigious parts of the standard in a way that will improve functionality.

I think "working as expected" is stretching it a bit ;) How do you
expect IBSS to work? I'd expect only the simplest use case from it:
start IBSS on one station and have another one in the vicinity find it
while scanning and join it. That works regardless of merging or not.

> please see my last post where i suggest to use:
>=20
> +               if (rx_status->flag & RX_FLAG_TSFT)
> +                       /* in order for correct IBSS merging we need mact=
ime*/
> +                       mactime =3D rx_status->mactime;
> +               else if (local && local->ops && local->ops->get_tsf)
> +                       /* second best option: get current TSF */
> +                       mactime =3D local->ops->get_tsf(local_to_hw(local=
));
> +               else
> +                       /* can't merge without knowing the TSF */
> +                       mactime =3D -1LLU;
>=20
> instead.

Not sure. That's a bit on a fine line, if you have a slow device
get_tsf() might be well off and this could trigger a BSSID change in
both stations.

johannes

--=-DRp4eqzo7jYwFCwQe7sb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5jC56Vg1VMiehFYAQKwLw/+LVZXHRygamCeC6gsLJKWsEizkRUUj/39
iQ3GzAIL9HkpMBBDfhU2sNt79SQsCdY48Z+34A8ugPXmkMOWabAQNt8U4cL6zDIJ
KlyKuLKJ9/VFZa2Lonoj6x6nXExfCKE+CIG4iqIYrAAgO9v40JGKsBfPVP7m35H3
+KCNZ0YLazMaJfAUettd2uGSUZksYatlJ8Zk88dCkrCDx3k16yYcatBhOavRe27V
Xs7g7/0RCux5HploSG7m+FaJp36nltQbFzlCMREvqTf70bSsyP3jlM04Q+SzMnRi
tKxXn9alwnndR0ifbRW0VzFPkeYIMyF06R51cZStTki7LYYDYBwsp5LlAIhuKUx5
3bSUESpZUJ3YZuntsOhhQIDep+hxpaidTnCEzOoosaP44ymvXFRDuZqBq+qPTle1
WdGAmZDdESdywh+kE3/YIj1JuUpI/jCtbA+IJbv5/pm/lq7BawKaO4hOUeVWyVsb
a/ZU3KFuYJCGHG9CyyTJ4HRtiAzcglPT6uCwepn5E52Q1LCW71Umxbnxme0TUQUP
U/BGssVCqU6HijPiPi+jYXr6wXSFgd4Sq75QyDpSYKNdW1eJRPYnunEQSpkpqdij
R/QDTT09Tm80XPrh7Ec0wxq5AQ+eK43DNnHhRVDyLv+CFvvWdb+C/7v7UDLXG3Mi
r7nMHpdOAL0=
=W6bw
-----END PGP SIGNATURE-----

--=-DRp4eqzo7jYwFCwQe7sb--

