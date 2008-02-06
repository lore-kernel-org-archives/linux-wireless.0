Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYBFOPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 09:15:40 -0500
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <12022263282085-git-send-email-tomas.winkler@intel.com>
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6l6t3c2VrB0LRviQTVOC"
Date: Wed, 06 Feb 2008 15:15:31 +0100
Message-Id: <1202307331.4395.41.camel@johannes.berg> (sfid-20080206_141543_627612_5184101E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6l6t3c2VrB0LRviQTVOC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * @flags: Tx information (e.g. antenna selectd, guard interval,
> etc.)

typo: selected, also where are the flags defined?

>  struct ieee80211_tx_status {
>  	struct ieee80211_tx_control control;
> @@ -364,6 +382,8 @@ struct ieee80211_tx_status {
>  	int ack_signal;
>  	int queue_length;
>  	int queue_number;
> +	size_t rate_ctrl_num;
> +	struct ieee80211_tx_rate_ctrl rate_ctrl[0];

I think this is going to blow up if any driver sets rate_ctrl_num > 0
and uses the irq-safe tx status interface because we there copy the
stuff into another buffer and you haven't changed that buffer to be
resized accordingly.

johannes

--=-6l6t3c2VrB0LRviQTVOC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6nBAqVg1VMiehFYAQIQVg//WkQrcOgcygthkJ78jOq2sOzmOp8LFDCa
tLriUDK8gUZ2Q1JfARIWSLNItjUWioe3aVap0vnQe0ck+C6DNzo2JbzTUWTyvHz7
wRxr2EsayZpVWezOg9c27K39L+/uUbgihbH15OebCjyPP805E7eDxjImheGtmeOT
AstBYDS7UvGckVVH32JFKV/OaMySMBYZ9ojTYykOU2QbTxzw4ue9+xfkMSDqu+kt
YMq0UJNd+4nVnSWQvHT0/3fGG3B+atRA85Mrq0lB4cb9oFjGxgaoJeEa3iXb1cvi
C2KjsdOkErIZzjKwq6C5seyfZiAncZrxL6Mmt2jX4O89oRKHCSwxrFfM26ZW343A
wZTgh65K4ynZUp5CJnr1FjZg6RX15G56Jr6UZ1+3uPcB/9ZeZDo3wVJn/Ssgac22
k8wHAIgtq3bYi4/AwLq7jPDO71K3Y5g1WMBLWfw9fgvGRrlcZAFWmHsrtgPWi1ki
AZJ/OiomVGxCG3OCic47vpPgAd1RhaNSD4YlC3FFXcMcNfa58Ty3SZjRnAu+vW/0
JeTcJDbM1zG5fkPKkTy4S2pyDfO4WWCkIlj3Ain7RbzbR1agJ67LN7XGn4rzim0r
tiqA5uasV1aTeV+mSrj8Jv8BKWn4a/mYai+ijiYWOr5WZFp2sJmJrd2P3Mbs23Qt
yxxkOVxo5Zg=
=AH0L
-----END PGP SIGNATURE-----

--=-6l6t3c2VrB0LRviQTVOC--

