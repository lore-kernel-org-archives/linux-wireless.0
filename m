Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZFKL0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 07:26:39 -0400
Subject: Re: [PATCH] mac80211: Do not try to associate with an empty SSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090611105411.GA13825@jm.kir.nu>
References: <20090611105411.GA13825@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s6Vx/keDTt7blpSCwGQA"
Date: Thu, 11 Jun 2009 13:27:18 +0200
Message-Id: <1244719638.4706.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s6Vx/keDTt7blpSCwGQA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 13:54 +0300, Jouni Malinen wrote:
> It looks like some programs (e.g., NM) are setting an empty SSID with
> SIOCSIWESSID in some cases. This seems to trigger mac80211 to try to
> associate with an invalid configuration (wildcard SSID) which will
> result in failing associations (or odd issues, potentially including
> kernel panic with some drivers) if the AP were to actually accept this
> anyway).
>=20
> Only start association process if the SSID is actually set. This
> speeds up connection with NM in number of cases and avoids sending out
> broken association request frames.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>=20
> ---
>  net/mac80211/mlme.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> It is unclear when this was broken, but I think we need to get this into
> 2.6.31. The kernel panic (hopefully due to cleanup changes after 2.6.30)
> can be worked around in the driver, I would assume, but it would be
> better if we do not get into this odd state with associations since it
> is not clear what various drivers will do with this kind of
> configuration.
>=20
>=20
> --- wireless-testing.orig/net/mac80211/mlme.c	2009-06-11 13:38:01.0000000=
00 +0300
> +++ wireless-testing/net/mac80211/mlme.c	2009-06-11 13:45:44.000000000 +0=
300
> @@ -2436,6 +2436,14 @@ void ieee80211_sta_req_auth(struct ieee8
>  	if (WARN_ON(sdata->vif.type !=3D NL80211_IFTYPE_STATION))
>  		return;
> =20
> +	if (ifmgd->ssid_len =3D=3D 0) {
> +		/*
> +		 * Only allow association to be started if a valid SSID is
> +		 * configured.
> +		 */
> +		return;
> +	}
> +
>  	if ((ifmgd->flags & (IEEE80211_STA_BSSID_SET |
>  			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
>  	    (ifmgd->flags & (IEEE80211_STA_SSID_SET |


This whole code is a little odd.. Shouldn't we disassoc if ssid_len =3D=3D
0? But then why don't we disassoc when the flags change etc? Looks like
this needs a good rewrite...

johannes

--=-s6Vx/keDTt7blpSCwGQA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMOoSAAoJEODzc/N7+Qma7GgQALpylT/H0di53uO9wPPBpNlk
HQS/JaL2oorROOA20M/Z5nnp+U5wWHIEtQZ/ksUpdxCbRIZ6JgMbD8gmaGQM1Vxt
7EgCsqe+8qw+/V6HHmjgOZ8vo4cteH9NnLd1zJ+XErDYWadrypLwaKx7vAxXjqzE
LUj+CtVjG9WKWiO3r5R4H4qEiwwsD4WW6meGEEV77jPRBLX2Tg90Ro4AqLlbUDXM
gN1Uolyjya7SZAGqjqOEio4OD9NoG9DVLtPxbEE5JLQDX6abF17j8s0oVwULQ+TY
XEEvgbc3lXTle2X8zzyOmXToLUTFPR7iFRnimHB56MPvAiMax/YcTUSQ/LkLPyIj
+8BEBJQ31WudZ/iQKnzxwDY45fSc+05vD9wO0tw00qxJd7mIEsjz7Hkck5VPVuhz
U0CkTpPXkslEp4BHaALrXZQ+kfF+SAVidDDXleDpu5QUxiebOmxYED0x6BQ8elJ6
khK+UCg6IVmOSCNR0UR7wdWk80EYqaZZ0tjKhhqC7p217fl/yqzi61hfog7i46t3
fFAMs5/ITeROKahiNo9AZwLL4CnqPA2aEz4BCSjqFwixbgJYoE9o5bD97zCgeSNb
WAEGmTcSpPOU3D+rVagv/TbjYQwBZk193pJd37OD+8xVeyXBajUnr5RxaatSWASN
uQKjyayfWtTCVQoeZ363
=JE3Y
-----END PGP SIGNATURE-----

--=-s6Vx/keDTt7blpSCwGQA--

