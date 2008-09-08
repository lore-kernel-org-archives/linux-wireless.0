Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYIHIIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:08:16 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com> (sfid-20080908_011410_000288_CE56DC5D)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 (sfid-20080908_011410_000288_CE56DC5D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9n5wxn+S7wchaq8GvS4d"
Date: Mon, 08 Sep 2008 09:58:29 +0200
Message-Id: <1220860709.31304.19.camel@johannes.berg> (sfid-20080908_100821_650312_89B0FA5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9n5wxn+S7wchaq8GvS4d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:

> why I'm hitting unathorized prot messag for subif_start_xmit.
> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this

and no, netif_carrier_off() doesn't immediately stop the queues, it just
schedules the link watch which will _eventually_ remove the qdiscs and
attach the noop qdisc.

johannes

--=-9n5wxn+S7wchaq8GvS4d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxNsiAAoJEKVg1VMiehFYZCkP/A9h4WrE0f/Wt/zCPwbwGKft
rJ5RACRk4QQB2DtDFu8nDUwpzeSnfdiUrsEZx7aTk2vc2noNQjkOZRx8oKngO9YM
NpifWYEmpntbVNilzSJWwN5TVTNEdrSe3SAFSADMzDt+bEddpcX/o6AAeMbq0ZnC
fWtKubbe1Xd8Ho1mOSGZ20mCN85Brx8jyEVsRYKyAcuArY66GAvBIeyzd/Z1Ja9M
9DbKt9XqaXOTYrvuH0kXjcaco+sw4RWhCv8nJgMSxvsoFxn8Bsc/GymiRMBhHUdS
+iweILXKo3OeQB/wzwqP98DgrvK7TY+FpyRBDrtOgv3FGnmREKK1l3wJLMY4seKN
3vuY7zu8gsl1Lhnd0VpTwPQuS1uqbYNJceDJBs2xfXz9I0jmUNPJCb33kZ6L/iJX
2Ff2YaJ8OZCs6ZlGDhrVxSt/C9e/83Y/AWHAUL0ceVd4xGdmUeq3zciYGwdEzdjo
UBcrh3ufNXYQdk8c0NNdaJCIEMncZE+Zvvu7o8PXek/9ijH9ky3+MFrTl64nj1uq
OETcLGqh8GEUAvNZpZUIk9KyUhJfjLjRNNQaxPG4RIn5Aza+Yx9kJ0Dmv7QQ9vy4
i6co3DXGOcdDK5R1XTOsJz5W8nrVcrjpqOrs+NJBo8dsNtnyTsPFp9kffU0dzSRe
28ALpSEuSSY8Tb3YXlw7
=HZVB
-----END PGP SIGNATURE-----

--=-9n5wxn+S7wchaq8GvS4d--

