Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZAFROg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:14:36 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <20090106165434.M2397@bobcopeland.com>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <20090106165434.M2397@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ULU59/xlbIEy0Fz7eH9F"
Date: Tue, 06 Jan 2009 18:14:41 +0100
Message-Id: <1231262082.3654.5.camel@johannes> (sfid-20090106_181450_618513_D33561CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ULU59/xlbIEy0Fz7eH9F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 12:07 -0500, Bob Copeland wrote:
> On Tue, 06 Jan 2009 11:45:06 -0500, Dan Williams wrote
> > You still want to tell NM to go to sleep so it doesn't see the
> > disconnection from the supplicant (triggered by the driver because it
> > was going to sleep), and thus try to reconnect, or try a different AP.
>=20
> Well, I tried it without the hack and it works (connection stays up=20
> over a short suspend period).  This is with the new mac80211 suspend
> patches, where suspend/resume looks like this:
>=20
> suspend:
>   suspend userspace (freezes NM)
>   save bssid, keys etc
>   if wlan0 up
>      ifdown wlan0 (note NM is already frozen)
>   power down hw
>=20
> resume:
>   power up hw
>   if wlan0 was up
>      ifup wlan0
>   reload config, bssid, ...
>   resume userspace
>=20
> However, _with_ the current procedure of telling NM to go to sleep, it
> tries to reconnect after resume because NM takes care of downing the
> interfaces.  As a result mac80211 never gets the chance to save the
> state of the running interfaces.

You mean restore?

Does that mean there's a race condition now, between userspace config
and the resume stuff? Can't we fix that by taking the rtnl?

johannes

--=-ULU59/xlbIEy0Fz7eH9F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY5F/AAoJEKVg1VMiehFYrqkP/AgrDuLu5vX2Vonr5PjPvRiO
FM4nB/r+v9/iu6YgNEHkX4NhQ6H37XRNTsUdFS4D/06Rm3VsyCssX9XLPVoZL0vZ
PEv4mjGIXMTw4emPvKt5fGERUWy5NKzwaBWQ6IuZbGWFsisCg3enqB4250GsUCLr
4UkQoODTuEJnpa0Y1Bjbapv11h56a+OLA15JhygJpyJxK/XTEUEFjtf62HBqB6++
y1069CoDQogYz9Ky9VQ7F+0RZ2FJuPRTL70166mQ7M2Sdwi/ijEYXD1LpcSDkgXq
Q04z7xi80yj/LQH0mDd+Pdq2sZlyqzhBF1g0qE1YLbRI71Zhm1BWkDwponwC+9Gv
Hn0prTMY7yKFOqJ13j5ZMScu5/geITiqyWuxPrDd9AlqRhpY4hABccEy6tqlHlMe
zqBGpYvRMhIcMXfTujPbiepRivOHpf5adPJY9Kelj15WhJxe0gawGhk0VYJyxSBv
FyyvIcWEwSUaaNAPWtnKl1hBfJDOKeSJ3nkiPzln4qEwwnpMt7W8ju6HYO0j5FBd
KSAxGYGZzyteO2BqqFNaJNuz4tuPzbpW063BneS0s3MMfRg5fGjl6id7gGGCvVEO
lYB4pHlDClIAsxts3aQHNrHjxR/nLDknrFNb4DORXDqUYpy1rp4/2wa2XEZYxVhd
GRMrzDI2B77wqp0pKWYM
=DJVG
-----END PGP SIGNATURE-----

--=-ULU59/xlbIEy0Fz7eH9F--

