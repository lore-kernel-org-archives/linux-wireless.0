Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:54880 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760315Ab2IGLWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 07:22:01 -0400
Date: Fri, 7 Sep 2012 13:21:41 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mac80211: export ieee80211_send_deauth_disassoc
 for usage outside of mlme.c
Message-ID: <20120907112141.GB14616@ritirata.org> (sfid-20120907_132207_916748_F110B429)
References: <1346951275-32081-1-git-send-email-ordex@autistici.org>
 <1347006332.4256.9.camel@jlt4.sipsolutions.net>
 <5049C35A.1050601@lri.fr>
 <1347016689.4256.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
In-Reply-To: <1347016689.4256.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2012 at 01:18:09 +0200, Johannes Berg wrote:
> On Fri, 2012-09-07 at 11:50 +0200, Nicolas Cavallari wrote:
> > On 07/09/2012 10:25, Johannes Berg wrote:
> > > On Thu, 2012-09-06 at 19:07 +0200, Antonio Quartulli wrote:
> > >=20
> > >> -		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
> > >> -			IEEE80211_SKB_CB(skb)->flags |=3D
> > >> -				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> > >=20
> > >=20
> > >> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&
> > >> +		    !(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
> > >> +			IEEE80211_SKB_CB(skb)->flags |=3D
> > >> +				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> > >=20
> > > It would seem that this should be=20
> > >=20
> > > 	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION ||
> > > 	    !(flags & MFP_ENABLED))
> > >=20
> > > ?
> >=20
> > Or just never set TX_INTFL_DONT_ENCRYPT at all and rely on
> > ieee80211_tx_h_select_key() to do the right thing ?
>=20
> I don't think it can do the right thing, it doesn't check whether MFP is
> enabled or not... unless you want to test all those cases I'd rather not
> change it :)

Ok, then I will send v3 with the modified if-condition.

Thank you all,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBJ2MUACgkQpGgxIkP9cwc71ACfUA2tbPSJ5qKHQQlhcnW45gfS
4D8An2IqgjyY0p6vsR7Uo+W6oDSo+S3M
=IPDs
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
