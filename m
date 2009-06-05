Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbZFEGYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 02:24:10 -0400
Subject: Re: [PATCH 12/15] mac80211: make minstrel/pid RC use
 ieee80211_is_data(fc)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
In-Reply-To: <1244180502-4323-13-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
	 <1244180502-4323-13-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YJjR8Z8IlKlpX1HTVT+k"
Date: Fri, 05 Jun 2009 08:24:05 +0200
Message-Id: <1244183046.22576.92.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YJjR8Z8IlKlpX1HTVT+k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 01:41 -0400, Luis R. Rodriguez wrote:

> -	u16 fc;
> +	__le16 fc;
> =20
>  	if (txrc->rts)
>  		info->control.rates[0].count =3D
> @@ -291,8 +291,7 @@ rate_control_pid_get_rate(void *priv, struct ieee8021=
1_sta *sta,
> =20
>  	/* Send management frames and NO_ACK data using lowest rate. */
>  	fc =3D le16_to_cpu(hdr->frame_control);
> -	if (!sta || !spinfo ||
> -	    (fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
> +	if (!sta || !spinfo || !ieee80211_is_data(fc) ||

you might want to run sparse on this entire patchset.

johannes

--=-YJjR8Z8IlKlpX1HTVT+k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKLoBAAoJEODzc/N7+QmayG8P/0J6Ks5tPNEyt25fG1StdCP8
ceMF6DPbERIiAhZSLimwtPGCzynISRc4nc7Vedn0u39FQmJuBtTtrcM6VxjJp6nQ
O9yi/l7tTxr2gfwCikiGYda949OAnogHL2UVHlWjC+RaxD4OwOIMWvvmcFehuNzj
VYKCKgOk+8bSWI+duxTR6+o67FVGxef8rHVgse3pZLU+qgEtKmGvXaO7xo98m3nQ
uK6yJPGOvhCQvXEzbh7H7eWxP76UTG7kiRByXGxngVFlbcDcOsB8sVeFDoC6DpwR
qaepaGY43ymX4nUzTrv6xDBAHxTu588sjSRWUhInBEW2QKrHhvtRv1Ons+Gw2vW5
pNw7wQIG3WST5/CGKd1ebCLAQIGOAQ9wFBESIlDIqXDryFKzcLM+vCzk9awsCw03
Pu3npA8nAr2/PKXwMWJxPDpmBsIoQPIxCD98jUT4QKTtvbQL3OWZ+h0+VU1ME9Qd
522rYbeScKlPTpDj7Gut2OyGbo0qhWeQ44v1l20xy9p/wgnXYkbTBkIM1cPIzC/w
aitaKvG2CcOHhM2QH589iWfQqZy6boIYUR4YHbuntZBbAAR6ya9uFTD/Df03/fmA
YwylpcO6DsJyEd2b46CI1jRNRo1Lp/ua1bq4WjJx1MyJz0CAM4W2IidyTcLjcgsl
/GaCJwHar0lIXfurB4A6
=QmGG
-----END PGP SIGNATURE-----

--=-YJjR8Z8IlKlpX1HTVT+k--

