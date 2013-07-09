Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52702 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab3GIK14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 06:27:56 -0400
Date: Tue, 9 Jul 2013 12:27:51 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3 4/5] mac80211: add channel switch command and beacon
 callbacks
Message-ID: <20130709102751.GA21674@pandem0nium> (sfid-20130709_122800_153866_54F12245)
References: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373289250-12259-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CA+BoTQnsDGtAp4n9hYQTjhNZFzsEsaT4qnX_W7hBcutTAZvjYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
In-Reply-To: <CA+BoTQnsDGtAp4n9hYQTjhNZFzsEsaT4qnX_W7hBcutTAZvjYw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

thank you for your feedback!

On Tue, Jul 09, 2013 at 09:17:41AM +0200, Michal Kazior wrote:
> Hi Simon,
>=20
> On 8 July 2013 15:14, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> > +static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_de=
vice *dev,
> > +                                   struct cfg80211_csa_settings *param=
s)
> > +{
> > +       struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF=
(dev);
> > +       struct ieee80211_local *local =3D sdata->local;
> > +       struct ieee80211_chanctx_conf *chanctx_conf;
> > +       struct ieee80211_chanctx *chanctx;
> > +       int err;
> > +
> > +       if (!list_empty(&local->roc_list) || local->scanning)
> > +               return -EBUSY;
> > +
> > +       if (sdata->wdev.cac_started)
> > +               return -EBUSY;
> > +
> > +       /* don't handle if chanctx is used */
> > +       if (local->use_chanctx)
> > +               return -EBUSY;
> > +
> > +       rcu_read_lock();
> > +       chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > +       if (!chanctx_conf) {
> > +               rcu_read_unlock();
> > +               return -EBUSY;
> > +       }
> > +
> > +       /* don't handle for multi-VIF cases */
> > +       chanctx =3D container_of(chanctx_conf, struct ieee80211_chanctx=
, conf);
> > +       if (chanctx->refcount > 1) {
> > +               rcu_read_unlock();
> > +               return -EBUSY;
> > +       }
> > +       rcu_read_unlock();
>=20
> I'm wondering if it's a huge hassle to support drivers that depend on
> channel context API? Perhaps local->open_count could be used instead
> of local->use_chantx and chanctx->refcount?

Actually I'm not using any chanctx drivers, and as long as I can't test
I prefer to keep things disabled. :) local->open_count seems doable though,
it should be the same if there is only one channel context. I can change
that ... If you think it is safe I can enable support, nothing will happen
anyway as long as the driver don't set the "CSA supported" wiphy flag ...

>=20
> I'm also worried this can possibly do silly things if someone starts
> an interface while CSA is under way. Consider the following:
>=20
>  * start AP
>  * initiate channel switch
>   [ while channel switch is in progress and driver is yet to call
> ieee80211_csa_finish() ]
>  * start another STA interface and associate
>   [ CSA completes ]
>=20
> Upon CSA completion the STA will be moved to a different channel
> silently and most likely end up with a beacon loss quickly. I think
> mac80211 should forbid bringing up any new interfaces during CSA.

I'm afraid you are right about that - there should be some check to
prevent other devices coming up during CSA. I'll add something to
prevent that.
>=20
> It seems there's nothing preventing from multiple calls to channel
> switch callback. Is this expected? Can this work if CSA is invoked
> while other CSA is still in progress?

This should not happen as long as there is only one interface
doing a channel switch. If this is properly checked (need to fix
the point you mentioned above) that should be safe, I think?

Cheers,
	Simon

>=20
>=20
> Pozdrawiam / Best regards,
> Micha=C5=82 Kazior.

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHb5acACgkQrzg/fFk7axbJqwCePJz64EYMmZy+ohPBNWpyFM4b
LrUAoIr7pYr425mx/i0+2kswPvuVFhuu
=r9Ds
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
