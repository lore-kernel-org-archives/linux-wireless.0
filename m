Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:41517 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVWeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 17:34:37 -0500
Date: Sat, 22 Dec 2012 17:34:34 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/17] cw1200:  Mini-AP implementation
Message-ID: <20121222223434.GH5120@shaftnet.org> (sfid-20121222_233441_609050_788B6CF7)
References: <1356191120-5280-1-git-send-email-pizza@shaftnet.org>
 <1356191120-5280-7-git-send-email-pizza@shaftnet.org>
 <50D61117.8020009@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SdvjNjn6lL3tIsv0"
In-Reply-To: <50D61117.8020009@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SdvjNjn6lL3tIsv0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 08:59:19PM +0100, Pontus Fuchs wrote:
> I remember fixing a tricky bug here. When loosing BSS the driver can
> in some case leave
> priv->bss_loss_status to > CW1200_BSS_LOSS_NONE.
> This blocks further processing of the BSS_LOST events from firmware
> causing link loss detection to fail.
>=20
> The fix was to clean up bss_lost_status here before canceling
> bss_loss_work and connection_loss_work:
>=20
> priv->delayed_link_loss =3D 0;
> spin_lock(&priv->bss_loss_lock);
> priv->bss_loss_status =3D CW1200_BSS_LOSS_NONE;
> spin_unlock(&priv->bss_loss_lock);
>=20
> >+			cancel_delayed_work_sync(&priv->bss_loss_work);
> >+			cancel_delayed_work_sync(&priv->connection_loss_work);
> >+#endif /* CONFIG_CW1200_USE_STE_EXTENSIONS */

The code you're referencing is partially wrapped in STE_EXTENSIONS --=20
and most of that refers to stuff that wasn't ever part of mac80211.

So I pulled the work cancellation out of the STE_EXTENSION wrapper and=20
prepended that code you suggested.=20

I'm finally done auditing and (mostly) purging all the STE_EXTENSIONS=20
stuff, so I'll be submitting another patch series shortly that=20
incorporates everything suggested so far.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--SdvjNjn6lL3tIsv0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ1jV6PuLgii2759ARAhV8AKCTOlBM7Vtzcgbr1UV7UtyZgEYHdwCfQoql
tVp25z2J5AkjRgPS5o4Xs7E=
=r1Zz
-----END PGP SIGNATURE-----

--SdvjNjn6lL3tIsv0--
