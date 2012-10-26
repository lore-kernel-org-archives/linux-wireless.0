Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:64264 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 11:19:11 -0400
Date: Fri, 26 Oct 2012 17:18:32 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Javier Cardona <javier@cozybit.com>
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 1/2] ath9k_htc: Add support for NL80211_IFTYPE_MESH_POINT
 interfaces
Message-ID: <20121026151832.GW7023@ritirata.org> (sfid-20121026_171915_856284_FEA743A1)
References: <1351108774-7450-1-git-send-email-javier@cozybit.com>
 <1351108774-7450-2-git-send-email-javier@cozybit.com>
 <CAG6hwVNfvcy90tWqFqMDbQqHQmr1X5j6XSyvehspZ0PftzLE-A@mail.gmail.com>
 <CAPjQAd9BgoE_sHyWoeUHmsqeOMm+-AwNGvAdV8Gf0NMBg4f9pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yO52jeZL+8sEiVPY"
In-Reply-To: <CAPjQAd9BgoE_sHyWoeUHmsqeOMm+-AwNGvAdV8Gf0NMBg4f9pA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--yO52jeZL+8sEiVPY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, Oct 25, 2012 at 11:44:19AM -0700, Javier Cardona wrote:
> >> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/n=
et/wireless/ath/ath9k/htc_drv_init.c
> >> index d98255e..9c5c63c 100644
> >> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> >> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> >> @@ -707,6 +707,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_pr=
iv *priv,
> >>                 IEEE80211_HW_SUPPORTS_PS |
> >>                 IEEE80211_HW_PS_NULLFUNC_STACK |
> >>                 IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> >> +               IEEE80211_HW_SUPPORTS_PER_STA_GTK |
> >> +               IEEE80211_HW_MFP_CAPABLE |
> >>                 IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
> >>
> >>         hw->wiphy->interface_modes =3D
> >> @@ -714,9 +716,11 @@ static void ath9k_set_hw_capab(struct ath9k_htc_p=
riv *priv,
> >>                 BIT(NL80211_IFTYPE_ADHOC) |
> >>                 BIT(NL80211_IFTYPE_AP) |
> >>                 BIT(NL80211_IFTYPE_P2P_GO) |
> >> -               BIT(NL80211_IFTYPE_P2P_CLIENT);
> >> +               BIT(NL80211_IFTYPE_P2P_CLIENT) |
> >> +               BIT(NL80211_IFTYPE_MESH_POINT);
> >>
> >>         hw->wiphy->flags &=3D ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> >> +       hw->wiphy->flags |=3D WIPHY_FLAG_IBSS_RSN;
> >>
> >>         hw->wiphy->flags |=3D WIPHY_FLAG_IBSS_RSN |
> >
> > Ahem. Antonio added this in:
> > http://comments.gmane.org/gmane.linux.kernel.wireless.general/84066,
> > but that patch also seems to suggest per-STA GTKs are not supported by
> > the HW, so we shouldn't claim support above?
>=20
> (Just to let the list know what we just discussed in person...)
>=20
> I removed the redundant WIPHY_FLAG_IBSS_RSN and the setting of
> IEEE80211_HW_SUPPORTS_PER_STA_GTK.  We'll retest the series and
> resubmit.
> If anyone interested, the reworked series lives here:
> https://github.com/cozybit/open80211s/tree/ft-ath9k-htc-support
>=20

IIRC, per-STA GTK is missing the driver support, so it should not be a HW
constraint. However it is not a problem because group frames are encrypted =
in
SW.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--yO52jeZL+8sEiVPY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCKqcgACgkQpGgxIkP9cwcPkwCdFLpispAJCMtVv3TRcsLoastE
IdIAoJiDdujW4RZ2OHWsMj0qRDGViztn
=tQtX
-----END PGP SIGNATURE-----

--yO52jeZL+8sEiVPY--
