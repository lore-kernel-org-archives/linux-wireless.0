Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYBYQDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 11:03:23 -0500
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203695866.7082.49.camel@johannes.berg> (sfid-20080222_155831_933711_8528D283)
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)  <1203695866.7082.49.camel@johannes.berg>
	 (sfid-20080222_155831_933711_8528D283)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RITpKS7HVSkvfpTHBkrq"
Date: Mon, 25 Feb 2008 17:03:12 +0100
Message-Id: <1203955392.13162.111.camel@johannes.berg> (sfid-20080225_160332_317111_E485CC4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RITpKS7HVSkvfpTHBkrq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +	int	(*dump_station)(struct wiphy *wiphy, struct net_device *dev,
> > +			       int idx, u8 *mac, struct station_info *sinfo);
>=20
> How do you use this? I can see that the "idx" is used to iterate, but
> this cannot possibly provide race-free access because the implementation
> in mac80211's cfg.c needs to give up the lock. I think we need to change
> this to
>=20
> int (*dump_stations)(wiphy, dev,
> 		     void (*callback)(wiphy, dev, data, mac, sinfo),
> 		     void *data);
>=20
> The same seems to apply to nl80211_dump_mpath() and the corresponding
> callback.
>=20
> An alternative would be to provide start_station_dump() and
> stop_station_dump() callbacks for the locking, or, something I wouldn't
> really like to see, document the interface to lock when idx =3D=3D 0 and
> unlock when the return value is -ENOENT or something...

Ok, I changed my mind, it has to be with conditional locking even for
the RTNL because .dumpit callbacks can be invoked multiple times for a
single dump operation and need to keep all locks (even the rtnl) across
the calls.

Can you do that in both nl80211 and mac80211 for both STAs and paths?
Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.

johannes

--=-RITpKS7HVSkvfpTHBkrq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Lmv6Vg1VMiehFYAQLgmw//WhHd6LTCX14jGV96ZmrV0XX+bMeNFX2R
UWBZ+8JzIHp9kCeftMOMKLj0XGEEbt99GmFUDrEksg4OTbAma4DrVpt8aSdE9wKr
wsoOyIZ9CDhm7XkyL9CQJrY4Rp0WO0WG0FIgT8GP0QJLL6xa31OkMt3bqD8+cs/I
Wn6DySdwq3TosZLxaQQ4Gm6Ns/z8EDBYlj1FWj+GYxA6frQE8rnRf0umqChaX8yr
HNVC6eQ/l86FU21D5m5dVDCzbXwvWjLAMaOGDcw/yDHBfr34c7+I7rVrW7FHuXL0
KZF8ShGK/KOnYi0m/CKbckAmPEyFolrTwfyte/fxynDfO6IL616dQoxJKHRdZ6rA
xEvDeHm/qsMtYwYazKHHRSD0MUMDQPhzelb9Q/qZWMtrMt09dmtBrVcugVaFFgff
/NSwrgVtuNBU3yqzKeyFAPTuCxqnc1wRMrv4zTC8Kzsv/q0vFwCO/9hat7E9as7Q
98+0AAeAe2sWsIbmLO2rSeuq/sSAs03vUeupVlK6ERaWfA+noaxW1wryr64biGXl
7Znxv21mwlncBAvOSU6aEa/yTqug65BCOXzI0F54VSSV2RzKq1k3HVEwaHmQGDqq
8JPD9c/iztyXSjZWv5ODdKy9V04Ehra/+artvE6w40LEyjpDlXaUdXY3OpHNf8/+
gojNKbLKNzI=
=LF+/
-----END PGP SIGNATURE-----

--=-RITpKS7HVSkvfpTHBkrq--

