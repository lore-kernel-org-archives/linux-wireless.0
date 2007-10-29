Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbXJ2RHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 13:07:54 -0400
Subject: Re: iwl3945 lists supported rates backwards
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: dragoran <drago01@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1193677095.11181.2.camel@dv>
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com>  <1193644281.27622.12.camel@dv>
	 (sfid-20071029_075130_793419_DFA19205)  <1193667153.5197.48.camel@johannes.berg>
	 <1193677095.11181.2.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cVa+Q1Cpf6vTp+1ACmIU"
Date: Mon, 29 Oct 2007 18:09:08 +0100
Message-Id: <1193677748.5197.77.camel@johannes.berg> (sfid-20071029_170823_027968_8166B2E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cVa+Q1Cpf6vTp+1ACmIU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -5414,10 +5414,10 @@ static int iwl_init_geos(struct iwl_priv *priv)
>  	 * is supported by a mode -- and the first match is taken
>  	 */
> =20
> -	if (modes[G].num_channels)
> -		ieee80211_register_hwmode(priv->hw, &modes[G]);
>  	if (modes[B].num_channels)
>  		ieee80211_register_hwmode(priv->hw, &modes[B]);
> +	if (modes[G].num_channels)
> +		ieee80211_register_hwmode(priv->hw, &modes[G]);
>  	if (modes[A].num_channels)
>  		ieee80211_register_hwmode(priv->hw, &modes[A]);

Huh no, you misunderstood my mail.

This makes mac80211 always select 802.11B mode which is not what you
want. You want to change the order of rates within the G mode.

johannes

--=-cVa+Q1Cpf6vTp+1ACmIU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyYTs6Vg1VMiehFYAQKtqBAAmFaGSMNc/rezm5TdeQ0TdUjcRGMQk43Z
5Ylgd5WxVIVNlOwOyrfLcpZEgDzXnlw8edsIQ1G2DqgtqJQY1npbCfXvHoJ22X4q
b/xvRLeuU6vLjzj46W4ieZjm79ReoJ3Q36Qwye0V261MAczTYGVr3zs+iS5oJCcv
CVXgW4ia+ege1fNiFAql7FQafk4WgC5UYmmJFA+FLp6MFN1C80BVrJsdS+OuNxCT
XKWmC6Wz6qdKHZ1Ftzla1qmJ3kp8aDrArPShwEs66PX5ENSCrr+6XnTD+jfdlxkA
AaDNZiSsXujY6yMvgGzLY1fAF2JPIrHNYtCrK8ZIMvhNATO57L0WYNcluOXbkKSI
lBaIdfP7KM22oOYJzpeN44w9NgJIjzMnV0dt1YPkdl7xMASB53IOPhAWgHfRbU42
AV3aLdwCbdNkvV5v1phYr97hk91qVkxRvvjUO7R7uUUcscyBGJnogN1j4FVnJvt6
CcQ7MOQziLtSRaAEC6KaBgPEI6RK4UGUpi/TKblmCOuW2LszTRbVr5wQ01Pbsl+4
OoH0KZNEqElZI0MkkD+YrwCqolqHlsTRM0Fxk424BlOzbOuYfo4XvJ7vkYD3Jt0a
nGLWEbXOukICFnxxgvBu3wVDPtcc7PcTdUT44hPxnWvPv0Z2tlNY75+1glUU4lZK
Yb5wC3wcdNM=
=UAr0
-----END PGP SIGNATURE-----

--=-cVa+Q1Cpf6vTp+1ACmIU--

