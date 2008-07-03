Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYGCReJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 13:34:09 -0400
Subject: Re: [PATCH 1/1] mac80211: move netif_carrier_on to after
	ieee80211_bss_info_change_notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>
In-Reply-To: <1ba2fa240807031026k1763f64bu66fd03d0c1b254dc@mail.gmail.com> (sfid-20080703_192607_818589_169DED2C)
References: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com>
	 <1215104870.9975.17.camel@johannes.berg>
	 <1ba2fa240807031026k1763f64bu66fd03d0c1b254dc@mail.gmail.com>
	 (sfid-20080703_192607_818589_169DED2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ta19fIlI2RkfJZW44tda"
Date: Thu, 03 Jul 2008 19:33:13 +0200
Message-Id: <1215106393.9975.21.camel@johannes.berg> (sfid-20080703_193412_977364_5B2331B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ta19fIlI2RkfJZW44tda
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 20:26 +0300, Tomas Winkler wrote:
> On Thu, Jul 3, 2008 at 8:07 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> >
> >> -             netif_carrier_on(dev);
> >>               ifsta->flags |=3D IEEE80211_STA_PREV_BSSID_SET;
> >>               memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
> >>               memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALE=
N);
> >>               ieee80211_sta_send_associnfo(dev, ifsta);
> >>       } else {
> >> +             netif_carrier_off(dev);
> >>               ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
> >>               ifsta->flags &=3D ~IEEE80211_STA_ASSOCIATED;
> >> -             netif_carrier_off(dev);
> >
> > Maybe it should then be symmetric so that callers of the function have
> > to do it in both cases? Other than that, looks good.
>=20
> The sequence now is
>   configure association in the driver  -> carrier_on ..... carrier_off
> -> configure disassociation in the driver
>=20
> So this is already symmetric or I don't understand what  you mean.

Yes, the call sequence is symmetric, but I was thinking whether it would
be better API-wise to have the caller of =EF=BB=BFieee80211_set_associated(=
) do
both carrier_on and carrier_off, instead of requiring that it calls
carrier_on but calling carrier_off for it.

--=-Ta19fIlI2RkfJZW44tda
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbQ1VAAoJEKVg1VMiehFYdEoP/0IF9BHSIUNoDaTb8Nm+XDO3
qwV6t4Nd3Vq62ZUqlJ+YxWr4Y++pTJFzGHB2IJPYs7JzwMn1eFppBGIuly3bhy4s
ty807unULBTXt+YcFj9MNTUpNI7qmV7Cu2BD+hIdqkhRklhHLZ2Nv6c7ofGYk8h7
n8LIEzMtG9bA95tbyf1sHdvL9SqboXpBBzSYna2IwZHsbPwOSUHQ6jjd5yZrS4yZ
csZ3XbTE86Ui/+YJMW0MHBBftUBHv318C/+WV5aY1jkSlAzIkNWp6XD6Wki5AyEm
sZfZqgIhnWmi2+uKOovU6i+oGIkHrnNIyWvCypouM+RkLQ2acX0i9Jqg5sCxIxwq
Jsc/hGIV86ZlFrgUfbM3VCpcMdepOJdFS5tFEcoNLcenJgFmu4lTju720G6eFlww
5m2+oIKMljnl79GWisSuhrrduScTsL9m3lA/mXnGh7JXMTeo9TTMgYaW+ehT4kRT
/zSLgMPn6oVm36Svq4sXxIBrRisw3fPS9hkzwhP+F8zvpegJzFJ17jAOX9t+zVY5
ZMV/VpibAySb0Kb1RI6CgZKZ6mPhBBldW5dJOdhj2MBfvkpIfLvQ+JXcx/MEoOqr
WCDoiIKtR/uqfoYzwFzDXSE1CRsOnMCixgDbwfAQnI13+Y2lvjI9Xbybxpq+zCco
+bYya3EGbqowNVqrLOAl
=1wDs
-----END PGP SIGNATURE-----

--=-Ta19fIlI2RkfJZW44tda--

