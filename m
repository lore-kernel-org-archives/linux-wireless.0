Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYGCR63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 13:58:29 -0400
Subject: Re: [PATCH 1/1] mac80211: move netif_carrier_on to after
	ieee80211_bss_info_change_notify
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, Guy Cohen <guy.cohen@intel.com>
In-Reply-To: <1ba2fa240807031045q74065c7bna6e66b5aa219d41c@mail.gmail.com> (sfid-20080703_194548_657379_3D82C675)
References: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com>
	 <1215104870.9975.17.camel@johannes.berg>
	 <1ba2fa240807031026k1763f64bu66fd03d0c1b254dc@mail.gmail.com>
	 <1215106393.9975.21.camel@johannes.berg>
	 <1ba2fa240807031045q74065c7bna6e66b5aa219d41c@mail.gmail.com>
	 (sfid-20080703_194548_657379_3D82C675)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k/GZIsF2kicYEJjdD+YB"
Date: Thu, 03 Jul 2008 19:57:32 +0200
Message-Id: <1215107852.9975.23.camel@johannes.berg> (sfid-20080703_195839_556303_4D5262E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k/GZIsF2kicYEJjdD+YB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 20:45 +0300, Tomas Winkler wrote:
> On Thu, Jul 3, 2008 at 8:33 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2008-07-03 at 20:26 +0300, Tomas Winkler wrote:
> >> On Thu, Jul 3, 2008 at 8:07 PM, Johannes Berg <johannes@sipsolutions.n=
et> wrote:
> >> >
> >> >> -             netif_carrier_on(dev);
> >> >>               ifsta->flags |=3D IEEE80211_STA_PREV_BSSID_SET;
> >> >>               memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALE=
N);
> >> >>               memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_=
ALEN);
> >> >>               ieee80211_sta_send_associnfo(dev, ifsta);
> >> >>       } else {
> >> >> +             netif_carrier_off(dev);
> >> >>               ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid=
);
> >> >>               ifsta->flags &=3D ~IEEE80211_STA_ASSOCIATED;
> >> >> -             netif_carrier_off(dev);
> >> >
> >> > Maybe it should then be symmetric so that callers of the function ha=
ve
> >> > to do it in both cases? Other than that, looks good.
> >>
> >> The sequence now is
> >>   configure association in the driver  -> carrier_on ..... carrier_off
> >> -> configure disassociation in the driver
> >>
> >> So this is already symmetric or I don't understand what  you mean.
> >
> > Yes, the call sequence is symmetric, but I was thinking whether it woul=
d
> > be better API-wise to have the caller of =EF=BB=BFieee80211_set_associa=
ted() do
> > both carrier_on and carrier_off, instead of requiring that it calls
> > carrier_on but calling carrier_off for it.
>=20
> I think it's actually okay to be  inside and I would rather prefer to
> split this function; there is already one function called
> ieee80211_set_disassociated. But since we have to fix dissacosiation
> anway and we need to investigate it more I would first use this little
> fix.

Sure ok, thanks for looking into this stuff.

johannes

--=-k/GZIsF2kicYEJjdD+YB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbRMIAAoJEKVg1VMiehFYxzoP/0hw9DTbYqz6d+/K//ZMlzYR
L698r2Jb4uQbFtTNGTosJHiiVeNRgk9A1Cm8kYpngNsgwdvxTqJmqQOSCAbaay4g
vfGk/mhHoC5Izqan28DIsc8sdULxJYxmdbl6FYlztRbUcMVIgHSRq1DondTE0UwM
1WES5XZgvpbYJ/aDQQDoH39Nl5YGUE1k2JJT+V7YC43IwzMoeC10cv0qztHrP8Xb
EpUiDUBnxSPwg/BFvR88U7jFtLHRhFJbyPExZEN0dTvNmXRtjeLkXGgeuDSD2ltF
mMDUhbeMkw9x4gb5psfTr2Fa7p+nKtWgPf5egSuZkrOjrPAQlkHG9/2aS1g40ybT
fY0JHWlaxIFeBvd0ItHPcTLzswhMwcyztPka98KVCLiQ9UDo6iJOT7CNpIYaaaWN
5lrin9GtkccwzNjCEDI7b0nLAstOuXWOA6zgbYmrcvdzHkiFjidp+GrTSbJErcYH
UlnDLvV4clvN120JJ4w91RlusPtWkbuUb2yhB+tP2tysH+jEqDxos/TdPepes9/f
ipOl09Y3C566ZUXn3p82ps94pCPzeNzzTAUoj93YDOesDmfPxLG4kdcExDK+q7Tg
9wWYEugtIfwuWdhBxuZYgJ68QfnRvtHvs5nqNztjN6AqS95tbriRhL+JaCiKGFra
n8GKTB01aeOQnwuzTgez
=p00P
-----END PGP SIGNATURE-----

--=-k/GZIsF2kicYEJjdD+YB--

