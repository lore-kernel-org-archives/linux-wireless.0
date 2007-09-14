Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbXINMGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 08:06:16 -0400
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter  configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
In-Reply-To: <200709132350.38488.flamingice@sourmilk.net>
References: <20070905234209.108005000@sipsolutions.net>
	 <20070905234622.671760000@sipsolutions.net>
	 <200709132350.38488.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6atJI+leP/0WY5cW6V3q"
Date: Fri, 14 Sep 2007 14:06:58 +0200
Message-Id: <1189771618.3974.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6atJI+leP/0WY5cW6V3q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 23:50 -0400, Michael Wu wrote:

> > +	void (*configure_filter)(struct ieee80211_hw *hw,
> > +				 struct dev_mc_list *(get_mc_item)(void *data),
> Yuck. Preventing drivers from calling get_mc_item outside configure_filte=
r or=20
> when the filter hasn't changed isn't worth doing this to enforce it. ;)

Well, it gets rid of a needless export that takes up memory all the time
and makes it much clearer that locking is correct during the invocation
of the call. But I can live with either way.

johannes

--=-6atJI+leP/0WY5cW6V3q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6nli/ETPhpq3jKURAiHxAJwIw4ubkzqPGwXHaDOK05jLZ5IsUwCgg6j4
aax9sKdlQE8T/JIoJ9fzBck=
=Wdn5
-----END PGP SIGNATURE-----

--=-6atJI+leP/0WY5cW6V3q--

