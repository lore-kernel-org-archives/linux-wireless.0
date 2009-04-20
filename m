Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbZDTVGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:06:48 -0400
Subject: Re: WARN on return of ieee80211_if_config
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1240261096.5206.107.camel@rc-desk>
References: <1240252271.5206.63.camel@rc-desk>
	 <1240252511.4632.17.camel@johannes.local>
	 <1240261096.5206.107.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fGAvB/pJ22hrZy2IPCz6"
Date: Mon, 20 Apr 2009 23:06:14 +0200
Message-Id: <1240261574.4632.22.camel@johannes.local> (sfid-20090420_230658_843418_2D97F728)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fGAvB/pJ22hrZy2IPCz6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 13:58 -0700, reinette chatre wrote:

> > Or will this test:
> >         if (!iwl_is_alive(priv))
> >                 return -EAGAIN;
> >=20
> > kick us out before even getting to the rfkill test?
>=20
> Yes ... and it is not immediately clear that it is caused by rfkill. The
> STATUS_ALIVE bit that is tested here is cleared when machine is
> suspended. When machine is resumed and HW rfkill is set then it will not
> come up fully, see __iwl_up() that returns early with success if rfkill
> is enabled. STATUS_ALIVE will only be set again after HW rfkill is
> disabled and we initialize ucode again.

Ok... Very confusing. Can you change the patch to have a comment that
this should also be changed back when rfkill is integrated with
mac80211? Maybe I'll even do that for .31.

Thanks,
Johannes

--=-fGAvB/pJ22hrZy2IPCz6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7OPCAAoJEKVg1VMiehFYlSEP/1QU9+ONYf2GX1XMQZQht1gQ
2CzdMl5wNeu7Mh6aXlNFnP64iMrp4J7NAterAtf4HpvOtQ6gNFXRUKLKDVOC4wjw
Adsi9s0oKJR8Bm5tBdmgzEqFFpA6sntthZOwoGQnrqVP2bxSOvHpvZcftvODm4z1
rpfT4/vM4liUJGhxy0uyoYt33YTuwBKHZ9kH6BHQJlzliYsIO0E+LXIb7C8iwj64
mKqd4vRaNBEYS9OvM1t3vLTF4x6onAHdu8pPza2Hjkuu6dgGV2nXnsGnH15NgJHY
hZdsjp4EMQVIXbt/ppUXUzjrsmc4YKVaYev8N8PeyjpMGKyqGOiwqI7M2fy0EEAz
VpKji0BsSbruFVjxS6NfdpCBa/Ut/m51pDD/tScHCsFxounSrGF054QUd0eBm64c
RSGaM3/owIpeK+RPcjEAQ1t8zJCZn2+PoNdnwMuyg+keLIFOd0Ai0uZ6al1N8RQG
qlXKG02eobHFrbNXbRt7qV42B/cBTRLTxjouz5ZfhMichzHWBsTRDpLhqvmAaixB
kgT3pPgX1lTZ7xPrhr7PvoTDL2l3Tt9FtbN7IQCSLfu7moNQ9ZVaVVoA0w47uGVB
8pSBXUmx/1eOtk1tTJ3m5GOejEMy32KMDDASE8h+KZ/m+Z/fDeVOsiOrYimdfS/K
5UdkkMly6td0Kug8H2uV
=XXWN
-----END PGP SIGNATURE-----

--=-fGAvB/pJ22hrZy2IPCz6--

