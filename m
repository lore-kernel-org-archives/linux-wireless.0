Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934083AbXCVKEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:52 -0400
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx  and tx
From: Johannes Berg <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070320103955.600509703@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-akv+yztskle1Cn4XZ2zU"
Date: Wed, 21 Mar 2007 19:46:49 +0100
Message-Id: <1174502809.3944.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-akv+yztskle1Cn4XZ2zU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Here are some more issues using monitor interfaces for management that
will need to be addressed before I'm convinced that doing injection on
monitor interfaces is viable.

If the driver does not support radiotap, ieee80211_rx_monitor needs to
expand the head for each packet. Currently, this is also true, but since
currently no non-management frames are sent down the management
interface, this is not an issue. If each data packet needs to be first
reallocated though, it quickly becomes a problem for low-power embedded
access points running hostapd.

Additionally, the overhead of tacking on radiotap headers to each
received frame is also rather high if you're only interested in
receiving the information for management frames.

johannes

--=-akv+yztskle1Cn4XZ2zU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGAX2Z/ETPhpq3jKURAjplAJoD6r6ht0o7AsRggFLnOSQ68g2JKQCeKrKg
U+AiwFHvX6Ri142PMIawhuM=
=ZCH2
-----END PGP SIGNATURE-----

--=-akv+yztskle1Cn4XZ2zU--

