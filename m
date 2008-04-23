Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYDWLNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 07:13:21 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589> (sfid-20080423_114948_059414_17607EB2)
References: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589>
	 (sfid-20080423_114948_059414_17607EB2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VJ0GCoRMcUVaAaNO6b/u"
Date: Wed, 23 Apr 2008 13:12:42 +0200
Message-Id: <1208949162.31429.74.camel@johannes.berg> (sfid-20080423_131408_595316_4F446F1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VJ0GCoRMcUVaAaNO6b/u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The below patch makes sure that we drop the BSSID when we disassociate.

> --- a/ieee80211_sta.c	Wed Apr 23 10:14:30 2008
> +++ b/ieee80211_sta.c	Wed Apr 23 08:41:23 2008
> @@ -479,6 +479,9 @@ static void ieee80211_set_associated(str
>  		netif_carrier_off(dev);
>  		ieee80211_reset_erp_info(dev);
>  		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
> +
> +		// make sure no association start before we got a new BSSID
> +		ifsta->flags &=3D ~IEEE80211_STA_BSSID_SET;

I don't think that patch makes sense, after all, userspace could request
to disassociate and afterwards re-request to associate by setting the
SSID and not setting the BSSID again, which would lose the fixed BSSID
without userspace interaction.

However, I'm not sure how to fix this.

johannes

--=-VJ0GCoRMcUVaAaNO6b/u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASA8ZqaVg1VMiehFYAQJIWg/+MVge1tKZqBrFlxzk5ycmpIVjMwcB2SVH
c/hPV2brlyr0/tiPb0u2x1z/mMcnvpZeOAXIvuVtcqD6hs8UxZiBkA1XHoPw6rLA
bRGHbPi/n55HZKnBr8RvGaGMEPAxLR3aML+jBZXWzHG+jjponL+YgjH0NIEcJVDo
cUvv1lCUYkApM1GGLZtiIremfjLAWX/BCRTrBrs5Lo5F6/VLNxkWfubKFhNqyE0n
Rf3QjNAEeM7rosRnwD0rfYBUzzlzT9hFXHjLQJXs52YshSA93lSdAWaUKTGHV132
4cbYKd4sEhZ/jczHtsaWDJJqTldUXMgtaHNuGxu6GsQWH5FsRgEsVqG3e2wwbzcu
81YyqfKL3KRKT8s9LuoUS0M/LBZx7Sif+hLRxkV871g3ay1HcTRmTQUZ0gMDmH8f
9cqJqFm8NVPR3DAxUC1n3PG8ZzDB81Q9fT1kN3Fyn3+NH/kdy4T8HzDF6e5B7zUz
/Rfit+U3a8ITqeDec9Pam/jRJ6KcWpmJH3deIoMLxnyr+3n1Ysl7fVRN1IRc/FYG
/K0tJN+7p/Tf/OQbVntIYULh4fzFTopgsEnnot0/LAgoV4CvcmDa787KIdnbYbWr
8E4GvNyNdLr2/v51jtl1gBJ/XtfHDNO4+Snf6qAVgD/OWRNIxZ4Z/0HEBwhlrOWk
MOSOawwowKw=
=g4G+
-----END PGP SIGNATURE-----

--=-VJ0GCoRMcUVaAaNO6b/u--

