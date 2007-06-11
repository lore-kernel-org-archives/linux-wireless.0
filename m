Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXFKL0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 07:26:03 -0400
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and  channel
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20070611103914.577674038@warmcat.com>
References: <20070611103828.961999956@warmcat.com>
	 <20070611103914.577674038@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rlGn8IfKkuiqqdPnOrPv"
Date: Mon, 11 Jun 2007 13:26:25 +0200
Message-Id: <1181561185.29767.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rlGn8IfKkuiqqdPnOrPv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> +++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> @@ -190,8 +190,8 @@ struct bcm43xx_rxhdr_fw4 {
>  /* RX channel */
>  #define BCM43xx_RX_CHAN_GAIN		0xFC00 /* Gain */
>  #define BCM43xx_RX_CHAN_GAIN_SHIFT	10
> -#define BCM43xx_RX_CHAN_ID		0x03FC /* Channel ID */
> -#define BCM43xx_RX_CHAN_ID_SHIFT	2
> +#define BCM43xx_RX_CHAN_ID		0x03F8 /* Channel ID */
> +#define BCM43xx_RX_CHAN_ID_SHIFT	3
>  #define BCM43xx_RX_CHAN_PHYTYPE		0x0003 /* PHY type */

Damn. This is a firmware thing, the firmware later changed because they
needed more than 2 bits for the PHY type so things were shifted up by
one. That means the actual channel ID mask will be 0x7f8 now and this is
in the current specs. Can you please post which firmware you're using?
We'll want to force people to use newer firmware with this behaviour
-or- figure out at what point they made the transition...

johannes

--=-rlGn8IfKkuiqqdPnOrPv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbTFh/ETPhpq3jKURAuveAJ4+Nvlw+5yVEz8USu6Q1UteYmHmnwCdHmyI
mnA+yWr+eR3lgXEl3LXFrts=
=PrCL
-----END PGP SIGNATURE-----

--=-rlGn8IfKkuiqqdPnOrPv--

