Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZCZIQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:16:24 -0400
Subject: Re: [PATCH 1/8] mac80211: rewrite fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903251821i7b582601r877662790ceb747c@mail.gmail.com> (sfid-20090326_022139_298504_9302A810)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163051.784425387@sipsolutions.net>
	 <43e72e890903251821i7b582601r877662790ceb747c@mail.gmail.com>
	 (sfid-20090326_022139_298504_9302A810)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a1mp4Vk0NxYTlxuDhNl+"
Date: Thu, 26 Mar 2009 09:15:49 +0100
Message-Id: <1238055349.4331.6.camel@johannes.local> (sfid-20090326_091628_620190_E8743345)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a1mp4Vk0NxYTlxuDhNl+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 18:21 -0700, Luis R. Rodriguez wrote:

> > -static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buf=
f *skb,
> > +static int __ieee80211_tx(struct ieee80211_local *local,
> >                          struct ieee80211_tx_data *tx)
> >  {
> > +       struct sk_buff *skb =3D tx->skb, *next;
> >        struct ieee80211_tx_info *info;
> > -       int ret, i;
> > +       int ret;
> > +       bool fragm =3D false;
> >
> > -       if (skb) {
> > +       local->mdev->trans_start =3D jiffies;
> > +
> > +       while (skb) {
> >                if (ieee80211_queue_stopped(&local->hw,
> >                                            skb_get_queue_mapping(skb)))
> >                        return IEEE80211_TX_PENDING;
> >
> > -               ret =3D local->ops->tx(local_to_hw(local), skb);
> > -               if (ret)
> > -                       return IEEE80211_TX_AGAIN;
> > -               local->mdev->trans_start =3D jiffies;
> > -               ieee80211_led_tx(local, 1);
> > -       }

> I see only one possible regression with this patch and that is that it
> seems you forgot to update the mdev->trans_start in the new loop on
> each fragment.

Well, that was actually intentional. Since none of the code here can
block the time between the various assignments of trans_start would be
_very_ small, and as such the multiple assignments can't really be
necessary.

> As far as I can tell this would only introduce a regression with if
> someone is using a netdev watchdog on the mdev, if we don't care about
> that and I'm not missing any other case where this could be affected
> we might as well remove that first update as at least for mac80211 its
> completely untouched.

netdev watchdog is always running for all netdevs :)

> Other than that:
>=20
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Thanks for looking!

johannes

--=-a1mp4Vk0NxYTlxuDhNl+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyzmyAAoJEKVg1VMiehFYDW8P/2JjFG4RjgiWYHdxzmx+G3nb
ShBaIU/emFtzrVL+NVcR0qdxWbyh3r43oMdLcZb+h3E7NbxMNioNsHiUYsUMx/MJ
GpbkBnxJ7f3a+MCcmETnPW+B0cz9wE85yIgr0V8uKqMl+YCzp3Z2BQvmtoeB9/vh
bcpdd+Cf7oKEZRU83S1FC9M5FqcBKdPbgrZEOhiKEGQ/D7TmM0lMef1Ymkwfazia
lrwQXPG7lWYt1abgfprp70cVc7IbPyqfBTNY2f0HfP3Z/S1uUbOAWBI6bJ8TTGhW
DFzlqCPwyqRl2801b4OgseJ80XRhJ/amfJwHCCPKtlCCfTs/gBuGcqXXAc3OJ3Kj
yGlOyTzEh+AwjWSAinkR1M/vuNJhx1Gy76X7J0lHCiOFc9ld74lAHtOpBe2zB0P5
F/uIqosEpAnz+TKnQN6KWxNKI6/OrhPq38jfM7SfkmkSR69KBNJIdxmbOFLJNxuM
4mcdJr6sO2a8XfBvnTb3MrxUVlhOh9jec04YdsvBvKZFlnB5RE/EOqZVXPgEVi9/
kRzjNs2LLCnF3N7c3UZLW+W0m2LDBZOUtAX08zjrkM2N+cfsLD14k+mlHMg9eKbI
8vJSrtF4ESZ3fzgHmRFKnG9dl7+EmY7SwcOtjhd0mtbozQ3eD8dAqk4vDDcP5Jlx
kZKgRVzzBRNYTcPUyrqi
=NVio
-----END PGP SIGNATURE-----

--=-a1mp4Vk0NxYTlxuDhNl+--

