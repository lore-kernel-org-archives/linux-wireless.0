Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbYAKLjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:39:39 -0500
Subject: handing cloned frames to netif_rx()?
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-otqGlbx99hSwJc/dvnvo"
Date: Fri, 11 Jan 2008 02:17:26 +0100
Message-Id: <1200014246.3861.148.camel@johannes.berg> (sfid-20080111_113942_538600_6D5244BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-otqGlbx99hSwJc/dvnvo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

In 802.11n, there is a case where multiple data frames are received
aggregated into a single frame (A-MSDU).

Currently, we copy each of these frames out into their own skb, but
because of the alignment with that etc. I started to think that we could
simply pass up a clone of the original skb with start/length adjusted
properly so that it windows only the contained packet.

The buffer would be shared but the data within the original window
(starting with the 802.3 header) could even be written to, it won't be
needed again by mac80211 once it's handed off to netif_rx(). The skb
will obviously have lots of head- and tailroom but that space would be
part of other packets.

Is it ok to do this? Will something freak out if we pass a cloned skb to
netif_rx()?

johannes

--=-otqGlbx99hSwJc/dvnvo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4bDpKVg1VMiehFYAQLI7g/+PrcQAuCq/4RbYeU1yfqLEzHnbCtNjpMQ
+5qBaZLcAi5AzpHqaR/7z3Ea39ciwSxhT3v3WCEPMZyPjP78efLFNKoZ5TCvVvFs
eOsgQHzq+POAvZ2fCjINXKFab35O4W2RejHMLlBDG62adh2LL8XRUnIvItQrqLc8
oXYSGahleuSIC4mBg4mGAOKPHZbJkrPmDLGQEqywAgPziMGIyv/uLkiCsOjr43yk
nFjLFzkPz1wQMrpbYcVKfu0JYaVVtVcUYS9RqPKMAKgmyTuh5mrt3j0kV7zjKZsO
MnewOAa9EX98wXvhx0Se6ofz7rtFlSI3bTLWDo55CzczhUX9EayGohLZtypatEs0
xG1j+lKRiW48n6KkSvmOLQJxZ+7bTlOBebSuqjDOBrjye3zBU0oiQ7xjL2I5Q0Nu
LB3W/+EybkSnC4DG9CGoCzW/4L+wontSmny1l75MyCPTf3Yxi151nJf4E/e/JhAa
bu86f0MFdXEDX8sTc3Lm+46MQJnUj4yKvBqoG6ob1VTWV7Ce4MJazRqymRBiZPUa
8KdCbq5XkDaphqkEiJ85/BlRr86Wa13DvP6jxJ8A3+NNGthg3acB+Nizmku+L1Hd
sEIpREIjHVwCbCX0BR1+anKZoog6ncahsUTIq92KH8A0tv1AObyhJTX2DVDuhu5v
VtAMrnTa9o8=
=9bzi
-----END PGP SIGNATURE-----

--=-otqGlbx99hSwJc/dvnvo--

