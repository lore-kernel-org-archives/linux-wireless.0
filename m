Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbXBESR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 13:17:59 -0500
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200702051314.21627.flamingice@sourmilk.net>
References: <20070131013717.GA28076@tuxdriver.com>
	 <200702051245.35452.flamingice@sourmilk.net>
	 <1170697795.3572.32.camel@johannes.berg>
	 <200702051314.21627.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T+XKW27dF41A0unOypvg"
Date: Mon, 05 Feb 2007 19:14:28 +0100
Message-Id: <1170699268.3572.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T+XKW27dF41A0unOypvg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 13:14 -0500, Michael Wu wrote:

> Where? I don't remember getting TX frames when running ethereal on a moni=
tor=20
> interface.

Ok, maybe it's missing. I think I saw them, but not sure. They do show
up on wmaster ;)

> If we report TXed frames at the point when the driver calls=20
> ieee80211_tx_status, we know whether or not an ack was received. This=20
> information can be added to the TX frame that is reported to the monitor=20
> interface.

Oh but do we really want to report them that late? I wouldn't think so.
That would give us out-of-order issues wrt. the air...

> I'm not sure what you mean. The program can get the configuration info it=
=20
> needs from nl80211/cfg80211/WE and send/inject frames through the monitor=
=20
> interface.

Well, I guess I'm saying that wpa_supplicant shouldn't need the monitor
iface at all since it wants just management frames and we should give
those to it via netlink to avoid having to add more radiotap foo.

johannes

--=-T+XKW27dF41A0unOypvg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFx3QE/ETPhpq3jKURAr/yAJ4vHFtWb6GiZvQ64TG8dD++0Ok6owCfRjn8
7/2xxFpUmPcKoyONnO9um0o=
=7aBo
-----END PGP SIGNATURE-----

--=-T+XKW27dF41A0unOypvg--

