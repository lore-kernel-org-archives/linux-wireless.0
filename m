Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbXH0LBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 07:01:48 -0400
Subject: Re: [PATCH 08/15] cfg80211: clean up key add/remove interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46CF298B.7040001@lwfinger.net>
References: <20070824122705.549190000@sipsolutions.net>
	 <20070824122907.784517000@sipsolutions.net> <46CF298B.7040001@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wrLnLTo6tuVRwnrtEBG1"
Date: Mon, 27 Aug 2007 13:02:56 +0200
Message-Id: <1188212576.7837.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wrLnLTo6tuVRwnrtEBG1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 13:55 -0500, Larry Finger wrote:
> Johannes Berg wrote:
>=20
> I found a compile problem when all the patches were installed in that 'op=
s' was not defined in=20
> wireless/core.c. This patch should be
>=20
> +       WARN_ON(!drv->ops->add_key && drv->ops->del_key);
> +       WARN_ON(drv->ops->add_key && !drv->ops->del_key);
>=20
> and not WARN_ON(!ops->add_key etc.

I'm pretty sure this is correct since the wiphy_new prototype is

| struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv)

and this is added to wiphy_new. Did the code somehow end up in the wrong
place for you?

johannes

--=-wrLnLTo6tuVRwnrtEBG1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0q9g/ETPhpq3jKURAt50AKCnAzyTGQAQx/mW8In59T+GwGRUxwCgnyY7
fg9hCn44p0Jhtv1F6WsdEFw=
=4djv
-----END PGP SIGNATURE-----

--=-wrLnLTo6tuVRwnrtEBG1--

