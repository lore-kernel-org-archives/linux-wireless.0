Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYJ0PHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 11:07:50 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18693.52244.207787.514254@localhost.localdomain> (sfid-20081027_151408_926406_DCAAAD08)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
	 <18688.17545.136327.991699@gargle.gargle.HOWL>
	 <1224773124.6002.32.camel@johannes.berg>
	 <18693.52244.207787.514254@localhost.localdomain>
	 (sfid-20081027_151408_926406_DCAAAD08)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JO+JVWQbEQMe+UhCdL6L"
Date: Mon, 27 Oct 2008 16:07:45 +0100
Message-Id: <1225120065.3796.4.camel@johannes.berg> (sfid-20081027_160755_391183_9F86A484)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JO+JVWQbEQMe+UhCdL6L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 19:41 +0530, Sujith wrote:

> > > How would mac80211 buffer frames ?=20
> >=20
> > Well I suppose it would just put them on a list in the sta_info struct.
> >=20
>=20
> A list for each TID, no ?

Right.

> To summarize a bit about the state/control information that mac80211 need=
s
> to maintain for an aggregation session:
>=20
> * Block Ack state for each TID (sequence numbers, BA window etc.)
> * Maintain a list of buffers for each <RA,TID> (setup, teardown etc.)
> * Handle retransmission of unacked frames.
>=20
> Forming an aggregate would involve the following.
> ( These might depend on HW caps as well as the recipient STA's caps)
>=20
> * Aggregate length
> * Delimiters
> * Padding of sub-frames
>=20
> TX control information will probably need to pass aggr. specific informat=
ion
> (number of delimiters etc.)
>=20
> The API for aggregation can extend the ampdu_action() callback.
> Adding a few more states can probably suffice initially.

Sounds good to me. If you need more space in TX control information...
Not sure what to do then. We could take out 'vif' and put that into the
tx() arguments instead, for example.

> We'll work on this and come up with an RFC.

Great!

johannes

--=-JO+JVWQbEQMe+UhCdL6L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBdk9AAoJEKVg1VMiehFYmLUQAIIEhNO8xTQ0/eOkhmexP/uJ
6Uxx0yd3wHcZ+6vuIBFDCK5bzSL+K0lnV3RjctrvMbHGemNRHEe6PWWvsrBf0p7c
bs6iuCjepeMr1dbED/rEi8UBPNhOPte/atirNdikeQxg53DEmOUXTDfFYaHkamqW
SVRqvApBzRDpqkWiWPa4knsYpWsszyh4Vj5pyYtax1Mq4HwaWhVoBnCbangFOdYu
+2nvYM8Ugjq9TRTtMlwQr6wyK3ckEzNDsq89NK4o8G9rsiFQUhKtQ1Szv2fBWt6f
oV5WWWHeYrMtLAcPCC4rPH88UHTJIOX3/xMjVPfJK0SMbnY0QDFkwjrS1HY1Rrs3
ptb1e9PfSBJq+FfmUxXHh21O9KSMcHdpTR/34QASnxw5EsMmlr3MwbxnEemDpKbx
kqBMmwAl72U13bkVrLo08p3S23fGQdGrkLz3Ngl7PpjxPlQng1U2x+X5kSXgDRCn
f0BOM/6hx5KIcuikLWyNrrpd9P1lCcZ3nKe2Zt8ZXDDdNB6Gf7fi3U6/DGXKTPQy
yRW1VEED0AgMrcJg7X3La2QSSfTsUCJHgCiIhBvlHNphO1pxNpN2CYuUk0Ui3EQ+
R6P08mz9rcff984HYHs7OdFzdsyEPNwSMqMPSo8oa++ZF/0WDF+SN5bu8g4UtgY7
4T/ot+Hd9XEyqqEfoVde
=BpKn
-----END PGP SIGNATURE-----

--=-JO+JVWQbEQMe+UhCdL6L--

