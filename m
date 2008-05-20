Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYETMl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 08:41:28 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com> (sfid-20080520_141946_747540_E2F0A327)
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 (sfid-20080520_141946_747540_E2F0A327)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KQ1KNOux0b7iWt8W1ZYp"
Date: Tue, 20 May 2008 14:38:31 +0200
Message-Id: <1211287111.6252.84.camel@johannes.berg> (sfid-20080520_144134_949257_12C96319)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KQ1KNOux0b7iWt8W1ZYp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  	/* drop all data frame if we are not associated */
>  	if ((!iwl3945_is_associated(priv) ||
>  	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id))=
 &&
> -	    ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
> +	    ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) && priv->=
vif) {
>  		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
>  		goto drop_unlock;
>  	}

That code is completely bogus anyway IMO, it should just be removed.

>  	/* Find (or create) index into station table for destination station */
>  	sta_id =3D iwl3945_get_sta_id(priv, hdr);
>  	if (sta_id =3D=3D IWL_INVALID_STATION) {
>  		DECLARE_MAC_BUF(mac);
>=20
> -		IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
> -			       print_mac(mac, hdr->addr1));
> -		goto drop;
> +		if (priv->vif) {
> +			IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
> +				       print_mac(mac, hdr->addr1));
> +			goto drop;
> +		}
> +		sta_id =3D priv->hw_setting.bcast_sta_id;
>  	}

Same here, why drop a frame if there's no station for it, that just
means you can't do hw encryption which, well, cannot happen anyway since
mac80211 would tell you about the station for hw crypto.

> -	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> +	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR && 0) {
>  		IWL_DEBUG_MAC80211("leave - monitor\n");
>  		return -1;
>  	}

That's the code I was complaining about. Just kill it if it works then.

>  	/* drop all data frame if we are not associated */
>  	if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
> -	   (!iwl_is_associated(priv) ||
> +	   priv->vif && (!iwl_is_associated(priv) ||
>  	    ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id) |=
|
>  	    !priv->assoc_station_added)) {
>  		IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
>  		goto drop_unlock;
>  	}

Same code, other driver. What are you doing poking with the 802.11
frames you're supposed to transmit anyway?

I wish you guys at Intel would trust mac80211 and not try to work around
it all the time.

johannes

--=-KQ1KNOux0b7iWt8W1ZYp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLGRqVg1VMiehFYAQInNBAAomaQfGw1zs3P8eUQ3ZxsMVigJD3DJZ/W
wtVQw3GChTpFBAJ8eGrXP8rclgYKuM33kbejRF83q9Pe+PhXpY2ZceyeRs0jMK1+
GPGW6akxgX/RHVfb+TgvYSdwkl+bcp7zRhhlo7MtsbW/DBL8b8AP+3ZiejUYYJ1r
NVa39UWKZcRW1gnjkCulxG3X9kObJzMPbArf4Myz/UqxHeOzE/OIsTd92SHqBFdi
QQ29ic/I84b8/mEdvVnRwiFAx61xkxAvSaQKaDwVwtg7wS2a+bLgzKY52gCtc/ov
KT9NQuCifgnUR8iXP8dfdgrB4AxImAh39FVlKPzPeX/gyEXFf9/bM3A5McC1n6Ma
Isztz5fzrlyeh7GIGSK1+1b6RTapVDbwRFQGGRpDDqtpsRjSObztO53aoFe1bRpz
X9rzGMwuHPqRMtZoL7cYYFkxIlyo5tj+ezYgmRnnS2JWDdX2gDCUzoP1cYcClfE3
a/FA2AeYyFEMFtGl+hgT1t30yHvTzWEN1yFl+3ZMNeBWiOn1LjEri1QrQ7Uy6noc
JnmI9ro98YyxXcPaBZitwbeWLz43AbnAKySgz6pHOvbkbdzNS3bie/+oDitietac
dxq3OviangMFGJ7Gbmd1mshGD5da+KCRYozeiTWC2aObyLmQ/E5YPp9WG1hakSxX
TKbVP7Wgqr4=
=QMuP
-----END PGP SIGNATURE-----

--=-KQ1KNOux0b7iWt8W1ZYp--

