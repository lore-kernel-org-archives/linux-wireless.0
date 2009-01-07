Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAGKX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 05:23:56 -0500
Subject: Re: [PATCH 04/11] ath9k: introduce bus specific cleanup routine
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Imre Kaloz <kaloz@openwrt.org>
In-Reply-To: <1231322972-24094-5-git-send-email-juhosg@openwrt.org> (sfid-20090107_111132_955895_E4ACE8AD)
References: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
	 <1231322972-24094-5-git-send-email-juhosg@openwrt.org>
	 (sfid-20090107_111132_955895_E4ACE8AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GJrHh4b8CXRyrp5d2uzc"
Date: Wed, 07 Jan 2009 11:24:12 +0100
Message-Id: <1231323852.3545.22.camel@johannes> (sfid-20090107_112400_258719_21AE45B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GJrHh4b8CXRyrp5d2uzc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 11:09 +0100, Gabor Juhos wrote:

>  			/* Deinitialize the device */
> -			ath_detach(sc);
> -			if (to_pci_dev(sc->dev)->irq)
> -				free_irq(to_pci_dev(sc->dev)->irq, sc);
> -			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
> -			pci_release_region(to_pci_dev(sc->dev), 0);
> -			pci_disable_device(to_pci_dev(sc->dev));
> -			ieee80211_free_hw(sc->hw);
> +			ath_bus_cleanup(sc);

And how is ath_detach() or ieee80211_free_hw() bus specific? That should
not be in the bus specific function.

johannes

--=-GJrHh4b8CXRyrp5d2uzc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZILJAAoJEKVg1VMiehFY/6UQAMII6M6UW03tDbH0CGXlHm9O
GKXy89Doe2pKtrdsYWXVDFE1K6UD7BzpFogvuPPLM+MRx4GkqooqxOcTZlgb4QG1
Zc+co3Jb7Vfr4RYHeior1fRLBd4Kz3iNkuRvu4/853JxxZDEDkAVpjHwN9oXzwMK
QqynLxr14n/fP7aEV0DkSzWMr7KMek0ZXycC8UAKyW4V221TRTGacdJSIzoBvUzc
HgKdYtc9ueTl/vXmKvrQ/Ye1f+2TAf1I4qnoL+fE6ylvFxNGmKN07cBk3knJ47T0
yoPN2iM7x2V2MwOUDvz3CfSKF/+p8NrHd+fKqSaf0zVkIK/TO+CliUXCqs+SEsC7
DlKyGjQybQ3RL6YhN8rZMujPhw2aqHPHz93xxQSPzC/vXe3HGVURIPdM+m4JfNIO
V9PJQbPgY/fN8qRUn+Zm/121RiYr+oAJ/Qhq48hnzpCpYEMgOCV7xkmpWt0iryQ5
dwwwWwwq0M7j49X2W7yxsOIekzAEkBG/9VE0955vJrlCnuGqMNUnelkX8wooW589
ASbeyOb0VJe+FkPqj/EwLqSNgEEd62l87Mr4AfmHYsO7MxgSVLhxNeK5Y9TMrUnW
/s4PJ39vEHuFgpzTYVehiYOwrGNLAECKk8U265PnFlMyQ4HkNb93+NsFHqD19VGZ
cVec/TxCeYxcuo2k9CmP
=Acun
-----END PGP SIGNATURE-----

--=-GJrHh4b8CXRyrp5d2uzc--

