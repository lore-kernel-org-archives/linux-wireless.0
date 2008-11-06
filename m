Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKFOhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:37:37 -0500
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20081106134950.GB14184@tuxdriver.com> (sfid-20081106_153132_117397_0A76B85E)
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 (sfid-20081106_153132_117397_0A76B85E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KVF+3xntWqdsOlTLVrgD"
Date: Thu, 06 Nov 2008 15:37:33 +0100
Message-Id: <1225982253.3619.233.camel@johannes.berg> (sfid-20081106_153741_829069_B924979C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KVF+3xntWqdsOlTLVrgD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 08:49 -0500, John W. Linville wrote:
> On Wed, Nov 05, 2008 at 11:17:22PM +0100, Marcel Holtmann wrote:
>=20
> >> This patch is related to bug 11870 at bugzilla.kernel.org. With
> >> correct regulatory information the number of channels to scan
> >> will be correct and not zero as seen in that bug.
> >>
> >> This patch eliminates the need for wireless to be compiled with
> >> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
> >> iwlwifi.
> >
> > so this is still for 2.6.28, but for 2.6.29 and wireless-testing the AP=
I=20
> > changed and we need a separate or different patch.
> >
> > John, Dave what is your take on pushing this to Linus this late in the =
=20
> > merge window? I personally think we should do that. And if not, then =20
> > change the Intel wireless Kconfig to select =20
> > CONFIG_WIRELESS_OLD_REGULATORY by default at least.
>=20
> CONFIG_WIRELESS_OLD_REGULATORY is already 'default y' now.  I don't
> really see why iwlwifi should _require_ that if someone decides to
> choose a non-default configuration.

I agree, also, I thought the problem was that iwlwifi misbehaved if
there were no active channels in the 5 GHz band and there was a patch to
fix that? This can happen _regardless_ of the setting of old regulatory,
it just happens that without the setting, the default is no 5 GHz
channels, while with it the default has 5 GHz channels.

johannes

--=-KVF+3xntWqdsOlTLVrgD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEwEqAAoJEKVg1VMiehFYukUP/323y+cC7MX0cOxJAM9wqRMI
drqHHdRd+b4YzAFYlqmYsbi5lVFJm1Zu1dzJH/XX4dQJc5z6y7C5QACOwhepd+np
dY5249qPB+XVfkyJfbIRrBFKlB5c4bvCb9yptBiTbQHq/AcZfiK0KEVuhFJ5XHG7
xACdcyBDyZDg/tNf+bSO8DWoxKXVj0AXLqFtpaVPVEygrcKsYbqAKecW2UJwv2TB
vZwMepxiF291zdpDtHVPVFSVPDJQawFL7IWxIyi0a8LCvntjVIDyS3ALPfR+afQO
FWB1k5N9jGnq0A/xMHJKrSTc83rfaFcy8NagXFAJl41ldyWf/MyedkfsbwiumvmW
qN2KRPlpiWdBelSLtl6Z6b9n2LBGop3r/1oo1of21D8OyoirszuaCNzb3i3neXkE
pI6yLde9l/h4RZinHv8YizKVqbhI+MLjvCY4AYMYTKkHuWAwARWWD7oUvO8sFPfD
ncsu91yaPFvoEiWD+FP62pNxuYWaj1tJafK7C4cXJWNOuiciHAXRH7dm7f7nTQSA
YjJMKnGf7n31x99nHTE/1nRGRV60FqKCH9XNNS2z6Wzubpl+cMCs3NSDlARXestK
yI3cxIIDCq1O3hZNqezaZctld5pd3ZYPEntlmTy3haYUAyEu+3HZfU6k9JfJrImK
3I4Cpt+dX50VgcaGzPtJ
=8WJ6
-----END PGP SIGNATURE-----

--=-KVF+3xntWqdsOlTLVrgD--

