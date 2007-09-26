Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbXIZHij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 03:38:39 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
	 <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v7xkLOiP0weNu+tYwQRE"
Date: Wed, 26 Sep 2007 09:39:54 +0200
Message-Id: <1190792394.18521.354.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v7xkLOiP0weNu+tYwQRE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-26 at 01:24 +0200, Tomas Winkler wrote:

> EAPOL frames should not be filtered out. Everything else should be filter=
ed out
> except EAPOL frames till the port is open.

Right now though, when we're an AP, we're sending EAPOL frames to the
mgmt interface instead of the regular 802.3 interface. This quite sucks
wrt. deagg. But it's also very weird, look at ieee80211_rx_h_802_1x_pae.
It sends
 * eapol frames for non-STA interfaces that are for us -> mgmt iface
 * non-eapol frames from unauthorized STAs -> bitbucket
 * everything else -> the regular 802.3 interface

Right afterwards, unencrypted non-EAPOL frames are dropped.

So any STA can actually send EAPOL frames with an arbitrary destination
MAC address except our own into our 802.3 interface. Hence, it looks
like the first case above is only for having eapol on mgmt iface.

The only problem I see with not doing this is that hostapd will have to
listen for EAPOL frames on all VLAN interfaces but I suppose that is
doable.

> The problem is the order of the handlers.  First you need to
> deaggregated the frame then filtered out non EAPLOL frames if the port
> is not open.

Yeah, I know, I had a plan a while back, will see if I can implement it.

johannes

--=-v7xkLOiP0weNu+tYwQRE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+gzK/ETPhpq3jKURAlpaAJ4jW+WGxD8X+3CXB25dLZOksuYbbACfZy3X
Urqinl9qT77xqHK605iG1CM=
=6XlR
-----END PGP SIGNATURE-----

--=-v7xkLOiP0weNu+tYwQRE--

