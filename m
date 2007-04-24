Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993143AbXDZJit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 05:38:49 -0400
Subject: Re: [PATCH 07/13] mac80211: fix configuration concurrency issues  in ieee80211_sta.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20070423184813.7029.81396.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <20070423184813.7029.81396.stgit@magic.sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zaJEThq2UbOhDtnvXgfD"
Date: Tue, 24 Apr 2007 18:19:57 +0200
Message-Id: <1177431597.3528.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zaJEThq2UbOhDtnvXgfD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This prevents userspace and the in-kernel MLME from configuring
> channel/BSSID/SSID at the same time when the in-kernel MLME is in the mid=
st
> of automatic AP selection. This is done by holding the RTNL lock.

Once cfg80211 drops the rtnl we'll have to find a better way of doing
this, for now I agree. Maybe in cfg80211 we'll have to allow drivers to
access the per-cfg80211-instance mutex allocated for them.

johannes

--=-zaJEThq2UbOhDtnvXgfD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGLi4s/ETPhpq3jKURAqeNAJ4ll8ATaKrxLAlDq+r5eV+TwxMyiQCgnoWU
XFO+NR07yhnLqdijdwmj9/A=
=oUic
-----END PGP SIGNATURE-----

--=-zaJEThq2UbOhDtnvXgfD--

