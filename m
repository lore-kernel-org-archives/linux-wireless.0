Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbXF0Jjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 05:39:35 -0400
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706251628.00838.mb@bu3sch.de>
References: <200706251628.00838.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AQlQjDayJKZbkHlm2YBJ"
Date: Wed, 27 Jun 2007 10:55:00 +0200
Message-Id: <1182934500.4769.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AQlQjDayJKZbkHlm2YBJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-25 at 16:28 +0200, Michael Buesch wrote:

>  	case PRISM2_PARAM_PREAMBLE:
> -		local->short_preamble =3D value;
> +		if (value)
> +			local_to_hw(local)->conf.flags |=3D IEEE80211_CONF_SHORT_PREAMBLE;
> +		else
> +			local_to_hw(local)->conf.flags &=3D ~IEEE80211_CONF_SHORT_PREAMBLE;
> +		if (ieee80211_hw_config(local))
> +			ret =3D -EINVAL;

any reason not to return the actual error code from hw_config here? Not
that it'll be any different from -EINVAL I expect...

johannes

--=-AQlQjDayJKZbkHlm2YBJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgiXj/ETPhpq3jKURAj1XAKCLIkikwiNo8A/p4ZTU2yJa4nzG6QCfUtOS
7k6MgoUJ5EgUUs5MAkj7XUE=
=UD9M
-----END PGP SIGNATURE-----

--=-AQlQjDayJKZbkHlm2YBJ--

