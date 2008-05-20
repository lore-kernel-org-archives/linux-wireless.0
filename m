Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbYETNjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:39:40 -0400
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <hschaa@suse.de>,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com> (sfid-20080520_153405_359637_5B9C0929)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>
	 <1211289769.6252.90.camel@johannes.berg>
	 <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com>
	 (sfid-20080520_153405_359637_5B9C0929)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FeglAafK8b5l9hIc5GTm"
Date: Tue, 20 May 2008 13:38:34 +0000
Message-Id: <1211290714.6252.93.camel@johannes.berg> (sfid-20080520_153944_822560_C3375320)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FeglAafK8b5l9hIc5GTm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Thing is, I'm not totally convinced it is wrong to the code while it ma=
y
> > or may not be wrong...
>=20
> Doesn't should be bss pinned int he bss list if you are associating to
> it. If it's not there you don't have access to it's info It looks very
> wrong to me.

Well, yes, it is a bit odd.

> > I think this patch should go in first as it
> > actually fixes the oops, and then we can discuss the merits of adding a
> > warning there separately. Maybe after we look a bit at the code and try
> > to figure out whether it can still happen after that patch from
> > Abhijeet.
>=20
> I'm not sure if this patch is complete without this warning. What is
> in the else statement is a hack and it should be obvious.

Considering that the message won't help us at all, why bother? We know
it's triggering, we know this might be a problem, and we know we can
only solve it by auditing the code. So why add a message that will get
us countless emails/complaints from people we cannot do anything about
anyway without doing the audit?

johannes

--=-FeglAafK8b5l9hIc5GTm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLUWaVg1VMiehFYAQL6PRAArJgT248MUj4X2koxS3hLSd06LZ2XHxOq
JaDioFc/uYwAMNfwzLnXaqpsTv1XICB+pTu2byXHQkAH+DSflvQns3cCF5kjJZyD
LtmRb1f0UB0/oe1ANEsyBk11LsY2IQ+DDuIOROTJg3UPDrL01SKtK16vF08QBDlR
kzYqIl4WYfkGtS/tFqWNtPKS8gZ8tnxGO7QVbGn7Cd2ye+g60ZPqIx6ByJlQHgU2
TlT6L6o4CPhJEfUg0zph0CQD/BHxhX79uB/eQyCpZrApzxdrtILYXCfPQnFSACWH
u57df76REL2V22AbQ5AXKPFWJwVhIOHr0yDV4yRxIcnWEtWzJh0V4zNS8DVVF+El
bXUnQxsOLDE2o3KNJCgxt1+CpDbHqliGAcAtkE2u71WzB4bq7GuwZaS1Osth+eWX
uLM0yGnvl6wn5XKgkcuLCyhHEQNa4nIjE3abxRzBgxryA1KY47Pm8Xy/PNbneF5J
3wvEUUEH8S7wRIEiQiIfYAiLXpmKAQVWynRaopWh9/cvzVV2wnlAuIZXUwOWf0Iz
nTa2Eo8lKXQVaaq6BsfCE3LJUG9fkTLXMJhZaHzqnT6aEQRebsdJ3BDAfHXwM26S
ZmIOGG/5pWKTLelMqdgZhc8b/xYxzLlkKgVLon52gssCzMiRImOZdVBo0zOWHB3z
tuGTceb29sc=
=e5PO
-----END PGP SIGNATURE-----

--=-FeglAafK8b5l9hIc5GTm--

