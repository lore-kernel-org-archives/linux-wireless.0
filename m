Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZA3IId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 03:08:33 -0500
Subject: Re: [RFC/RFT 06/11] mac80211: document TX aggregation (and small
	cleanup)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, m.sujith@gmail.com,
	tomasw@gmail.com
In-Reply-To: <20090129215152.GA27253@jm.kir.nu>
References: <20090129005450.068797016@sipsolutions.net>
	 <20090129005808.843799105@sipsolutions.net>
	 <20090129215152.GA27253@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kkPgn7zfi8yankg9dLgr"
Date: Fri, 30 Jan 2009 09:08:28 +0100
Message-Id: <1233302908.4161.8.camel@johannes.local> (sfid-20090130_090836_929335_A327480C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kkPgn7zfi8yankg9dLgr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-29 at 23:51 +0200, Jouni Malinen wrote:
> On Thu, Jan 29, 2009 at 01:54:56AM +0100, Johannes Berg wrote:
>=20
> > + * DOC: TX aggregation
>=20
> > + * When TX aggregation is started by some subsystem (usually the rate =
control
> > + * control algorithm would be appropriate) by calling the
> > + * ieee80211_start_tx_ba_session() function, the driver will be notifi=
ed via
> > + * its @ampdu_action function, with the %IEEE80211_AMPDU_TX_START acti=
on.
>=20
> Does rate control (btw, remove the duplicated "control" from the text)

Oops, thanks.

> algorithm have knowledge of whether PTK has already been configured?
> There is going to be a somewhat unfortunate timing issue with trying to
> set up aggregation before 4-way handshake has been completed if 802.11w
> is used (Action frames are dropped before the keys are set). Something
> in the system (either the request or mac80211's action on the request)
> would need to be delayed until the keys are in place in such a case.

Interesting issue, something I wasn't aware of. Yes, we'd need to delay
it in that case, not that it makes sense to set up aggregation that
early -- who knows it's going to be used? My AP at least will disable
your session if you're fairly idle (I guess to save reorder buffer
resources). We can simply delay it in mac80211, or we can just return
-EAGAIN. For iwl-agn-rs it wouldn't matter, it tries to enable
aggregation repeatedly even while it's already enabled =3D)

johannes

--=-kkPgn7zfi8yankg9dLgr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgrV5AAoJEKVg1VMiehFYa+MQAMYco6NvELIcMDGD17xB+0P+
aB40ehBgqaSy7EJW6bcrh9gx/blfUSTZJGkk3quM4HhoXUVQLUV8IszzDOYRT7WD
GL7ObkD7PVC7RxQG32PPP4RFxkxZPcgP8zcspUSlejiXQdiGK2aoTz1yV+kjkKzb
bsbauHEwW8lXrrcgvk9U55vLvHnYnPTQw7UjtnyvPQSaV4K4JKEMwpsneMwF462C
RUYdPCN5EuXkGCgTHHnrG9Hc44nN6h1Si2Qf3S0wuvzxmcG9W1H7vdttobXLaPgz
MeSsTN4BvkeJ9cc0vp4n/s9cdJr0OsiEU80l7fvdvz37DwhVJHb+56hClOovBZ/y
+2prI2Urup9SEHauMTho7joJtQi93HFQ9SLD5te7AFrRrHmEPkeZmAMuqgFS0vkd
fd5k7XNs0PKWCw9w39ag6lsT22+k+CiKVBpemf5uvEfSdPu79J0cND6ElZstLjVS
j+nW8np+El6AkXIdHeGCzdU7GKF6m0ZQ87LPCPdIrilCSkc0IEK5ysO0YF3Mpn/T
8pZsceUTd7MyE9KGVATaJ3fkn0FikunxeVYkDlTb7d27HVS3zsKeYnW+1a9iwGcc
j897mZAukHRgtYKaMjtq5DYQj2lJbgQzHQDm3nvBgcWKMnYweMJBo5Mh5+fvF4Ym
zU3IkM5ddF6jGhN7lL6e
=ukLv
-----END PGP SIGNATURE-----

--=-kkPgn7zfi8yankg9dLgr--

