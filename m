Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYEVTEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:04:04 -0400
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: JMF <tolas_feup@hotmail.com>,
	Alejandro Grijalba =?ISO-8859-1?Q?Mart=EDnez?=
	<sud@latinsud.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com> (sfid-20080522_205222_586288_4C9D9980)
References: <47FAB829.9010304@latinsud.com>
	 <200804081025.39645.mb@bu3sch.de> <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
	 <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>
	 <1211481278.3698.58.camel@johannes.berg>
	 <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com>
	 (sfid-20080522_205222_586288_4C9D9980)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JtQ+mjLzzytLfOpZpEAl"
Date: Thu, 22 May 2008 21:03:01 +0200
Message-Id: <1211482981.3698.61.camel@johannes.berg> (sfid-20080522_210408_768663_81E15672)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JtQ+mjLzzytLfOpZpEAl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-22 at 20:52 +0200, Stefanik G=C3=A1bor wrote:
> On Thu, May 22, 2008 at 8:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >> >> This does not work, since we use injection for other types of
> >> >>  frames. For example management frames from hostapd. We don't want
> >> >>  (and can't) make hostapd keep track of sequence numbers.
> >> >> You'll have to contact radiotap people and add a flag for this.
> >> >>  This would also solve the hardware counter problem then.
> >
> >> The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
> >> current wireless-testing:
> >
> > Reorder the two blocks and you have your answer. NO.
> >
> > johannes
> >
>=20
> Hmm, shouldn't this version fix the hostap and other non-monitor-mode cas=
es?

No, because hostapd uses monitor interfaces. Give up, it doesn't work
without an extra radiotap flag.

johannes

--=-JtQ+mjLzzytLfOpZpEAl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDXDY6Vg1VMiehFYAQI19xAAqTZ+uoBLmowDN6Vb3PVddnHr67EyklpZ
Bqutu9okidkr/fkmI+PKfeybqqkfbsJaNNnuiJPrB8hbafvGXJ3ZzHYALZx7mBY1
mQydBxNMuwKSFBtltwIzZSHeQM9icxGAfbHyY7fJYI0RK4kxNb2n1knUzq9VbLsA
ZBTi7foKT6FSR6q/HgiKeu2su2+P3IF4dqFm5w07uGdMRex42/OqMzLQcn0M0IHX
GStXg6RzJBK9gcKfDZk0mQIck8B0SUA9DiInjZeaxH1uyx6VN0q5x7HU6Dz0Bv06
nKGv2X+/N98SP3oQK1Ph0Q1hs68zavvu9nf4L8Oa85iPtRJTLyd+kecBA0zp57Bf
D5nJnfjx5HrJ3HzrC83fb0bEv9mbQQPz1FLBv09cNsgCQVvRlbbfIplKkzO1/Sjw
sIX2WsmsaZliYLZDE6BRZb0zITMkEBQNNQKOe9jm1YLLxsDXg0U9hW1QSedOkDS3
OjnwhyLsdypgi0cNaI5FDm88HX7K92H4py/WrExIu06ccO5UZXpZgJqVOQ9818+7
Buhx0fjc/ifEphKpEuuefisWzM42X9VqN+i+II36/+TvLGQ6bQMtFJGkD7ZHxQRn
rfGfTSdtKuWbFxx3SHC1AZTPMYO8w9y4Kp15VPeQJXyrHKe7xbfTRPOpBy+TmVjJ
ivDoUWhbsoM=
=o0pn
-----END PGP SIGNATURE-----

--=-JtQ+mjLzzytLfOpZpEAl--

