Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958AbZC1Tws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:48 -0400
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com> (sfid-20090328_201821_616590_EA31981E)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163053.344441542@sipsolutions.net>
	 <20090328045529.GF5543@bombadil.infradead.org>
	 <1238262118.4217.13.camel@johannes.local>
	 <43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com>
	 (sfid-20090328_201821_616590_EA31981E)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-znFFWm/BYGSufLNRZI1N"
Date: Sat, 28 Mar 2009 20:52:37 +0100
Message-Id: <1238269957.4217.24.camel@johannes.local> (sfid-20090328_205300_579405_62B1904D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-znFFWm/BYGSufLNRZI1N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-28 at 12:18 -0700, Luis R. Rodriguez wrote:

> >> That's fine from a logical point of view as compromise here as our
> >> ampdu start should be relatively quick. Now while I can say this
> >> from a logical point of view this patch obviously needed more
> >> testing but lets see how it holds up and I'm glad you're the one
> >> who wrote it. I'm confident there won't be any issues but that
> >> is something I cannot gaurantee just based on the review. We now
> >> need to go out and tests this. All other patches previous to this
> >> make 100% perfect sense.
> >
> > :)
> > I think it also makes more _sense_ to not ask the driver to handle thes=
e
> > frames, because we won't set the AMPDU flag correctly if the session
> > start is declined.
>=20
> Hm, wouldn't we send them as normal frames if its declined here eventuall=
y?

Yes, we take them off the sta->pending, put them through TX processing
and send them as normal frames.


> >> This piece:
> >>
> >> > +           } else if (*state !=3D HT_AGG_STATE_IDLE) {
> >> > +                   /* in progress */
> >> > +                   queued =3D true;
> >> > +                   info->flags |=3D IEEE80211_TX_INTFL_NEED_TXPROCE=
SSING;
> >> > +                   __skb_queue_tail(&tid_tx->pending, skb);
> >> > +           }
> >>
> >> Can probably be ported to stable too, to just TX_DROP.
> >
> > No, why? We're handing the frames to the driver. It wants to handle
> > those frames before agg session is started correctly. That's what I was
> > referring to before with this making more sense now.
>=20
> OK I see that but I am not sure of what's done to the skb in the old
> case if the session is note complete yet, nor now if the session gets
> declined. I can check later, right now I'm feeling lazy.

Before my patch the skb is still passed to the driver, which would need
to be able to handle it (it =3D=3D session being stopped). I'm not entirely
sure ath9k handles it properly but I suspect it does.

> > Ok that might make some sense, though as a parameter you can easily see
> > where it's coming from, I think :) I agree that the entire code is a
> > little brain twister...
>=20
> Yeah.. I had to re-read aggregation code again to get the hang of it.
> Anything we can do to make
> it easier for people to pick would be nice. I think I'll go patch up
> the aggr-tx kdoc too now, unless we
> plan on nuking some stuff soon again. I suspect the next big change
> will be to move software based
> aggregation queue handling and mapping to ACs within mac80211 for that
> type of hardware which
> we'll need for ar9170, ralink stuff, broadcom (if that ever happens)
> and our next generation 11n USB
> driver.

Right -- but I don't expect to be working on it any time soon myself.

> >> > @@ -1360,7 +1407,7 @@ int ieee80211_master_start_xmit(struct s
> >> >                    "originating device\n", dev->name);
> >> >  #endif
> >> >             dev_kfree_skb(skb);
> >> > -           return 0;
> >> > +           return NETDEV_TX_OK;
> >>
> >> All these NETDEV_TX_OK could've gone into a separate patch.
> >
> > I guess, they're also not strictly necessary since 0 =3D=3D TX_OK :)
>=20
> Sure, what I'm trying to say is these patches are pretty hard to
> review because of the topic,
> it just helps to trim them down as much as possible -- but I realize
> even that is painful.

:)

Thanks man, I really appreciate you giving them a close look!

johannes

--=-znFFWm/BYGSufLNRZI1N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzoADAAoJEKVg1VMiehFYQlgP/3I2/ysPqqGuc6Kgxd2udvEh
yYnTazVIwjeJDRCB8PaShUqDL30pKdSggQxaPmcjuKxV/lmytlppM0LSTx/E0np3
5Tf1um1T+pfbWHD1p1SZy7w/cHj/vQx2+ICrXdeIBVE2H+BFsBAikfUxUrB7np0C
TqEYpZyerL8fj+msB7jiAsUzUN1vVP5DlUIQmCnlX5Cni68hy92LkyC9x3QAxsyS
MAj2ncqz3C6DTlqb6sFsgqAEWS+w0i5bnxCbu/xA2r+DC8ZpDoqobVgSvCvDu5oq
00ok7Pvorf/+Ehje0KxUYc3dJz9eHQ6gcRqDW4yx2jQWhI8pbGk6RY/Y+XEV/ty1
YdeunSFq9AI8+v/LUE1YdM6irtFZ8BVPoMEqp3jPPbZeLKhKuPegA9l27xCtnlE6
2HSNqShTWyLGJtKeZXMieVhXhT8rkjHDEF5/RT1dkidaPnFlLncrVU1kpZc5QI+3
//4gW7Di34zd/ovXWWOw9BYEJhRuwAeVYAsLvjJ80Uh4fhse+CvOQ6gkP1Ibc7pj
cB3+nAmOoPIzH/ei8LUJ54jpqzamsG+gRJ/QZZyoYEad6IbxvjrlyNyAyeXXYQl6
MANQ/L8chhTLhLvn+1i6iqIHVrmnjPqfp9ceZx9Bq7lyMt1cCWTqv6Z3xn6aC+Ti
7SUbstQ5SQ74uGbmTKmW
=ZyDC
-----END PGP SIGNATURE-----

--=-znFFWm/BYGSufLNRZI1N--

