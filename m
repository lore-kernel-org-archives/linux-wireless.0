Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbYJTJEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:04:34 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <43e72e890810200201l49eea95h2f67615b536311aa@mail.gmail.com> (sfid-20081020_110224_061497_5B3E0C1D)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <43e72e890810200135o1581c904i456a35298f8a56a9@mail.gmail.com>
	 <1224492335.18024.34.camel@johannes.berg>
	 <18684.17816.702853.44986@gargle.gargle.HOWL>
	 <43e72e890810200155wbe01660xe3f53de80dc7357d@mail.gmail.com>
	 <1224493038.18024.36.camel@johannes.berg>
	 <43e72e890810200201l49eea95h2f67615b536311aa@mail.gmail.com>
	 (sfid-20081020_110224_061497_5B3E0C1D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6TBWbMIpRD9btUbzlS1V"
Date: Mon, 20 Oct 2008 11:04:29 +0200
Message-Id: <1224493469.18024.38.camel@johannes.berg> (sfid-20081020_110438_435658_8E1A99BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6TBWbMIpRD9btUbzlS1V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 02:01 -0700, Luis R. Rodriguez wrote:

> > Well the fact that it's in tx_h_sequence is a bit weird, but we should
> > be able to get around not using an extra bit in skb I think. Especially
> > for this since it's only really between the driver and mac80211, and
> > after a requeue the ampdu status might actually change.
>=20
> Good point. I failed to see that. So in that case it should be as
> sujith had it before my suggestion and just handle it as he had it in
> the tx handlers. The problem though is that the RC algorithm should be
> the one to determine if an skb is part of an ampdu for aggregation or
> not IMHO. Actually this is the real question and hot topic.
>=20
> When should we aggregate and should mac80211 decide that or be left to th=
e RC.

No, the RC algorithm cannot decided that, the RC algorithm can merely
decide when to set up/tear down aggregation sessions. When a session is
up all packet belonging to that TID should go into it, surely?

johannes

--=-6TBWbMIpRD9btUbzlS1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/EmZAAoJEKVg1VMiehFYj3QP/2W4JT0myRPmboqUzPmTXvv/
JLgK9zZK4vGJacB0+Cz0evpyjxMvx7Dj29mraSmjmVFOVz7dvIjnfGqht0dmil68
soE4L9CMvtct3MSreJDOfPqlQV2otYHE1Ga7W44lZgNqiXngeBObe4n1z9UR20Tw
PWyELc+qrpcUbBJ0dqcfGnv9ItIz4J5tvtJcps6r2WW3XyWkYZLoFYJjEb+0De+3
U3IoFwBqbEjrEY8jTmzm8MXJtEbqICpKMlUc9DqSD4MRhM9WrnQxZAEKhX2ghAgP
s5cAjGMuySKBxFtwe+de9KI5iwxHuR/1YwmSwyyoPWjZWWKwlWjV9AcnFROycOEJ
d9Ae94junAJV/V2XAie97RyOfJcWmOMDORSC/T5K2fLHgwtrOTcusSmPYdeNMZwy
6q2B+MGtYP080S2ExZlecZ0oCsG4wqhO4zBvk5LYbESey5KI5AVPZv0rtZGK/jzx
FnmwtCxPO74nhmvljWzU5ovT9xH5O1s4yW9c7seolR99eXOzY13U958n0w9tiwop
JEymhpeQamkgWTq2FOOHxzNtmJBeov9S69Z1x3jESji92AhG8r1h1oPz9qS3H0+4
0lFbIxTsQmP+y7f+VtlSABhNz1jd9YBmdOZ+uSgTyFgTESXl0sJxddFfsyMjXL0D
TNuBOfbGaVBHCN0yvL5p
=heyl
-----END PGP SIGNATURE-----

--=-6TBWbMIpRD9btUbzlS1V--

