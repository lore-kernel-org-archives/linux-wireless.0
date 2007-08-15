Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXHOKoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:44:08 -0400
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when   software WEP encryption is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/tWSvrygMkGIeQtLUy8Y"
Date: Wed, 15 Aug 2007 02:16:00 +0200
Message-Id: <1187136960.31200.37.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/tWSvrygMkGIeQtLUy8Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 17:13 -0500, Larry Finger wrote:
> For drivers that do no hardware encryption/decryption, WEP encryption
> works as long as IEEE80211_HW_INCLUDE_IV is not set in the flags variable=
..
> With WPA encryption and IEEE80211_HW_INCLUDE_IV not set, the logs are ful=
l
> of TKIP decrypt failure messages. Despite the messages, RX is working.
> This patch turns off the message for this case.

This is a bit strange. What's your actual key configuration? Are you
using TKIP at all? I suspect you're using TKIP for multicast and
CCMP/AES for unicast and something else is actually wrong with TKIP
leading to this.

Thing is, it looks as though all frames that trigger the message are
dropped, and I'm fairly certain we don't actually want that.

Or something in your network is actually sending bogus frames. Could you
capture some packets with wireshark on a secondary monitor interface or
a second device and send me a packet dump?

johannes

--=-/tWSvrygMkGIeQtLUy8Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwkXA/ETPhpq3jKURAi6NAJwMxREY9MVODFQiiKINJajKaJ4lpwCgnYvu
0E9JOXuMsR+8iOmNChqAopo=
=bjw5
-----END PGP SIGNATURE-----

--=-/tWSvrygMkGIeQtLUy8Y--

