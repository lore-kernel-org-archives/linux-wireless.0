Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936533AbYD1Sek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 14:34:40 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	'Dan Williams' <dcbw@redhat.com>,
	'Holger Schurig' <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <009d01c8a95d$b73b0410$0b3ca8c0@gotws1589>
References: <009d01c8a95d$b73b0410$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jNfCvKhoWN6jyD9NS0dY"
Date: Mon, 28 Apr 2008 20:34:17 +0200
Message-Id: <1209407657.29025.21.camel@johannes.berg> (sfid-20080428_203450_596154_77BD6668)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jNfCvKhoWN6jyD9NS0dY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-04-28 at 20:28 +0200, Lars Ericsson wrote:
> > > - Driver authenticating with new AP while having a valid=20
> > > association with and other AP.
> >=20
> > Yes, that is the problem, we should disassociate first. If=20
> > you can come up with a patch to send a disassoc packet in=20
> > that case (and test it,
> > preferably) that would be much welcome.
>=20
> OK. I understood that there has been a discussion about the way the drive=
r
> should handle this situation and the current behaviour is according to th=
at
> discussion.=20

Yeah but that was mostly just sidetrack.

> Is there any information document available describing the
> selected design path or is it only the code that document the design ?=20
> I think need that information if I should be able to create the patch
> requested above.

Unfortunately, there is nothing about mac80211's mlme other than the
code.

> On the other hand, that patch will only keep track of 'dual association'
> problem.=20

Well, no, that would mean we disassociate first and then only have a
single association.

> With the current wpa_supplicant, we will still have the problem
> with the driver start an association sequence as soon as 'trig' ioctl
> arrives. I think the wpa_supplicant need to modified to better cooperate
> with the driver.

That would be doable as well (though I would argue it should be done in
addition), we could use Holger's approach and delay the actual
association sequence start until a commit wext ioctl is received or a
timer expires. Then wpa_supplicant can call the commit explicitly after
doing everything.

johannes

--=-jNfCvKhoWN6jyD9NS0dY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBYYqKVg1VMiehFYAQJtpQ/9Gd7CfO9wfJuL7eX0VV9eXg9xSCGl2cb7
fe2uI78DE+/SwoAa0V6zSrZ20hfiSGrqnkBXfJAD9SFjyjSIW0xl4YF8MdcmgFuQ
MfRqhf3lWTCwgR1KuIDGAUYbiHHvBoo5mbQ6hO721kDMSV7fM1hH9Neo563t3TO/
j7H2tSNOU5+GFjsoK4hmUP9Ao9/Ii/wfCvFPi4hkFsqL+W/f5l4N4Vcx1kQdzaIa
VgJtuJqtVyxOlnPRE2sN4oi/iyMqGYV0Q4zPKxVjTvIJ1Nede2R4DNSvdVOyPFHr
uZ6rQLrT/7jLqPfTmT4tlkVc605WKjV9RFzIafbaKWhPhVZv1oBcpnMHv0PZ3U5/
eceA/S4IH4zTY1naM+pDmBhICjTJ7Tuu2BraAs1J/M4t6IhLsoUq4YClvQ+Mab3A
a6vDp7QRxmfsewQ3a9fOiu1ZasGNPuZci7oF4BchPsi/p5u0InTjDDhvgX6toUpm
3kRqBasMG0WrnUA7mWMImPA41FPmdUY11jKTbmBzN0MyrmnZoT2Ewcb1Npq5o8HN
FpVlnGJD4yAgiGRlJQZww55/frbCHv4VzHxSw+nPiUDlRxMTBzs8I3UV6Jq9kIc7
yCf+1+3oxX52jBE9b8bZRKMrpb+NPQdvFKv4jtuGI7Q/YF09W+mNZwiDN4F8HnLb
JsRUxCvvLR8=
=dsYE
-----END PGP SIGNATURE-----

--=-jNfCvKhoWN6jyD9NS0dY--

