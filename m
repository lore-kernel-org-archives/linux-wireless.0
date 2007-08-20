Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbXHUKHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:07:06 -0400
Subject: Re: [PATCH 28/30] rt2x00: Always check if mac80211 requested TX  status update
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200708192036.37330.IvDoorn@gmail.com>
References: <200708192018.30624.IvDoorn@gmail.com>
	 <200708192036.37330.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CnMVity03LNLaXj1gyal"
Date: Mon, 20 Aug 2007 19:21:35 +0200
Message-Id: <1187630496.6923.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CnMVity03LNLaXj1gyal
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-19 at 20:36 +0200, Ivo van Doorn wrote:

> During txdone always check for the IEEE80211_TXCTL_REQ_TX_STATUS flag
> to determine if ieee80211_tx_status_irqsafe should be called or not.
> When the flag is not set, just cleanup the skb and don't bother
> mac80211 with it.

Never mind that I'd love to remove the REQ_TX_STATUS flag, this is not
really the best thing to do since rate control will basically ignore
this frame if you don't hand it back to mac80211.

johannes

--=-CnMVity03LNLaXj1gyal
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyc2f/ETPhpq3jKURAsa/AJ49/zkacFf+SpoHewNCArSoRl+utQCZAcqX
Wk8ejhvrTHm+C3p9WGcy2us=
=Fqh9
-----END PGP SIGNATURE-----

--=-CnMVity03LNLaXj1gyal--

