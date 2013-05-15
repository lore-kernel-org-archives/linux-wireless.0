Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47559 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3EOUWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 16:22:25 -0400
Date: Wed, 15 May 2013 22:22:16 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Leffler <sleffler@google.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2 03/18] mac80211: fix various components for the new 5
 and 10 MHz widths
Message-ID: <20130515202216.GA23922@pandem0nium> (sfid-20130515_222231_562877_6F631BB7)
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1368627549-22518-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CA+yqC4a6W6i9TUoEc1Boxe6a5eun_TSjLB0F+w3F2L_Hn+v_gA@mail.gmail.com>
 <1368641562.20897.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
In-Reply-To: <1368641562.20897.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2013 at 08:12:42PM +0200, Johannes Berg wrote:
> On Wed, 2013-05-15 at 10:16 -0700, Sam Leffler wrote:
> > On Wed, May 15, 2013 at 7:18 AM, Simon Wunderlich
> > <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> >         This is a collection of minor fixes:
> >          * don't allow HT IEs in IBSS for 5/10 MHz
> >          * don't allow HT IEs in Mesh for 5/10 MHz
> >          * consider 5 and 10 MHz channels when downgrading
> >          * don't try HT rates for 5 and 10 MHz channels when selecting
> >         rates
> >=20
> >=20
> > Perhaps I missed a standards discussion but unilaterally disallowing
> > HT rates on 5/10 channels breaks existing functionality (e.g. I use
> > them on openwrt).  NOHT should be a regulatory constraint just like it
> > is for 20 channels.
>=20
> I don't see how this would break anything, since we wouldn't advertise
> HT capabilities (for now). My point was that that the standard doesn't
> (currently) define this, so I think it should be a separate second step
> for 5/10 MHz channels to see how to do it in a way that wouldn't break
> when/if the standard is changed to allow it, etc.

I generally think that we could add HT rates too, but this patchset does not
include that yet. Felix also told me that HT rates work on current hardware,
and freebsd seems to have support as well. But I'd like to postpone this st=
ep
for now and fix this in a later patchset, where we can address concerns too.

Thanks,
	Simon

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGT7ngACgkQrzg/fFk7axb+ggCfX1/TiF83fkuH4ZMf0fakEg4U
Qs8AoMaKc4wXNkcUyQg6evsLA1RVOxRe
=cfKJ
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
