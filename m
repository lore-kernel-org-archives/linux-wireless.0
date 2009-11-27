Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZK0JU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:20:58 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259290376.13126.219.camel@debian>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
	 <1259290376.13126.219.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5jSaHKyn3w6O/zXVsiU5"
Date: Fri, 27 Nov 2009 10:20:53 +0100
Message-ID: <1259313653.5428.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5jSaHKyn3w6O/zXVsiU5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 10:52 +0800, Zhu Yi wrote:

> > Also -- you lost the extra TX headroom which I think mac80211 as an AP
> > requires since it could forward these frames? Or does that not happen?
> > Not sure right now why that was there to start with.=20
>=20
> Yes, I'd like to hear more feedback on this. I think it's a trade off
> between performance optimization and clean interface. As we already use
> dev_alloc_skb to reserve 32 bytes headroom, it should be enough for most
> of the current drivers.=20

Is it? I don't think so. Many drivers go up beyond that as far as I
know. Then some do different things like putting it in a different DMA
block.

> While for those drivers really need a bigger
> extra headroom and support Rx aggregation, this probably means
> ieee80211_skb_resize. But the resize should always happen for every
> packet from the IP stack, right?

No, davem and I optimised that away a long time ago via using
netdev->needed_headroom and netdev->needed_tailroom. It even works for
bridges and their slave devices, iirc.

johannes

--=-5jSaHKyn3w6O/zXVsiU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD5nxAAoJEODzc/N7+QmaMXMP/ivFxRvFOrliLavKs28FbOld
9gs8fitGvGrardeGbAE6lVTkBwR467FptG445kbv6wU/Vbs+SqcBnf9c+qFVrpxT
PutuhaCzRBdR2NHV/eNOr/sh2SPU/tRLVX3fJCt5RVhsU/jmaK0L+ZZlNka3FwsV
9+5mjQ56WHTWvE0qrs2YUMMvfoZDdipKjUIYNKPHZ8kLugSk6ayjpyU9EUPTwTo2
+tr51GSsPXxO5pEHkYVhxkCAJTR5xg+vN5jGIoZy3GbKd+Ck0LydJnBkZyIfV/Vb
UYZV4aaWa37LI0ajLK2fgHmoNv4+Z0eA145gJS6Nam/0367TZm7XjIc7zemrnqmy
HRie8CWUrnPpYdeAEXVby6zeGFP6bFMdwnX5wYyv0Rosv8OHXLW+sPueT0flEpLL
QFkyX76fl8JuAz4q7HJQRzzoTAco5e0EDNLv/CuN7W4EuInhDJRINpi3kToxFwJG
WVCA9sgJK4LS2vqdegH3iZFjW0N96/IadVwhaTLESxT0K7iK+nQ5vjnnWYthLXQ0
4JWtuYXw2f8PpjVVX2FcIqEXT0my+3cDuTMmEmo8N0nSCV+liLLzMT7PIra8X9O2
BCyFAvq7K5G7wHpN4ODR6tOzo2rV93+X3Pw9G0O16h8V7Kxy510J0DW9Zz9bvpAJ
/cHZm69Ss9Og6woB88oV
=85wr
-----END PGP SIGNATURE-----

--=-5jSaHKyn3w6O/zXVsiU5--

