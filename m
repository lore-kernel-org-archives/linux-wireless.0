Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZDNSZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 14:25:44 -0400
Subject: Re: [PATCH] rtl8187: Disable TX retries if IEEE80211_TX_CTL_NO_ACK
 is set
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
In-Reply-To: <1239733412.24771.13.camel@johannes.local> (sfid-20090414_202422_927560_7873E35C)
References: <69e28c910904141109n4aa5cf20k39d1e75e33907977@mail.gmail.com>
	 (sfid-20090414_201034_301771_08F469F4)  <1239733412.24771.13.camel@johannes.local>
	 (sfid-20090414_202422_927560_7873E35C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s9CqLOj9/e77OeaTpKL+"
Date: Tue, 14 Apr 2009 20:25:07 +0200
Message-Id: <1239733507.24771.14.camel@johannes.local> (sfid-20090414_202546_508982_78CC561A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s9CqLOj9/e77OeaTpKL+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-14 at 20:23 +0200, Johannes Berg wrote:
> On Tue, 2009-04-14 at 20:09 +0200, G=C3=A1bor Stefanik wrote:
>=20
> > +		if (!info->flags & IEEE80211_TX_CTL_NO_ACK))
> > +			hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8)=
;
> > +		else
> > +			hdr->retry =3D 0;
>=20
> Umm. You obviously didn't even _COMPILE_ that patch. Let alone test it
> properly.

Besides, it seems it would be a mac80211 bug to give the driver retry
information for a no-ack frame.

johannes

--=-s9CqLOj9/e77OeaTpKL+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5NUBAAoJEKVg1VMiehFYa9cQAJZF6+DCrmmGMZquR7NMEPev
LPraN0BFgZFLot+ok8gjDJPVPW1A7srYRuO6X3hFobHopBh2VQrQT/N0DLp7LkXm
m+Kv/AFppH/Xi7NAs565zxEo4vZVzFs+Iurkjcx3OcREwl7s6wt79apvO2xshZ/m
vwwRJNBXvytJT44F8n/PbuwclmCMRZdnnuYCoZTUfZGVcd/HJQGldKWUmmmZMI6v
x9eV3RjS3SDqomIglU3CzG1S12wrUIqZw8KM1YZej/eBFGnV1Ow8YelKEuohoc8o
hbmPtED1G2X9Ypi1cPYya9JtaXFKFaCu/56EfwxP1Mk4aE4kRi+nvfbfbGkq+N7o
AwYqCzHPDxr9qRRiXIlEY+fcG33HdI0USRBKY8bEM9zBlw52N9W8Hb3uRx32Yk9C
mFjSgOLViUQ/pFx74p9lVXkLys8ImXScDF9nC3AVBWWi+S0jbpyYejWTsoQzILjw
oZxM1/BWruZoud3si9oaWqjQG3HQ+168qKcbiJz/AS0cK8Y66NANDDuLEnLA1eRq
1XgABC3ObgxpSvfXnnstg9+wUoiC399EeDkSkcUy2EuP+f73lEBbkxkOaW+yyXYK
RuFkGhuJGq6cAR/+elmzJhFkOeK0P8yCsJfGk/kqRQC3l9tw1KsNDehPZmlqNeIC
Df5+Pk6l45UW5l1cISUi
=P9bD
-----END PGP SIGNATURE-----

--=-s9CqLOj9/e77OeaTpKL+--

