Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbXHQKJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 06:09:41 -0400
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when   software WEP encryption is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46C2FCAB.6090607@lwfinger.net>
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
	 <1187136960.31200.37.camel@johannes.berg>  <46C2FCAB.6090607@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H9TxzodRPRdiPOBN421M"
Date: Fri, 17 Aug 2007 00:32:25 +0200
Message-Id: <1187303546.23489.74.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H9TxzodRPRdiPOBN421M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 08:16 -0500, Larry Finger wrote:

> > Thing is, it looks as though all frames that trigger the message are
> > dropped, and I'm fairly certain we don't actually want that.

Looks like I was right. This is really strange, and it plays into the RX
key selection that Volker also complained about.

I've tested this with my network, which is using CCMP for pairwise and
TKIP for group keys, and I started getting the same message as you had
but with "CCMP failed" instead of "TKIP failed". Adding all the
addresses to the debug output got me:

CCMP decrypt failed for RX frame from 00:15:f2:3d:63:97 to 33:33:00:00:00:0=
2

Note how it's sending to that IPv6 multicast address but trying to
decrypt with CCMP although I have TKIP GTK keys. And as expected, I see
*no* multicast traffic on wlan0.

The problem obviously is key selection:

if (rx->sta && rx->sta->key)
	use rx->sta->key

well, duh, that's obviously wrong since we have a pairwise (sta) key for
the AP, but it's sending us a multicast frame.

I've been thinking about revamping key selection, I guess this is
something to really look into now... Anyhow, this confirms that the
patch is wrong, it suppresses messages that we failed to decrypt frames
that we should be seeing, in this case multicast and broadcast frames.

johannes

--=-H9TxzodRPRdiPOBN421M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxNB5/ETPhpq3jKURApZZAJ4t1crrXUoS56vH6T0S0eFSEyohuQCfWDKX
fpATbt/8eTpcSjKQwJBzLXc=
=4ClR
-----END PGP SIGNATURE-----

--=-H9TxzodRPRdiPOBN421M--

