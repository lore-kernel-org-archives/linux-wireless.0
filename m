Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYIJVhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 17:37:47 -0400
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240809101432u23bf198bqcf9bd0e9f91a2ae8@mail.gmail.com> (sfid-20080910_233253_312411_FCC1C92C)
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 <1220886337.31304.71.camel@johannes.berg>
	 <1220887018.31304.74.camel@johannes.berg>
	 <1ba2fa240809080953mfe2ab86l5417679e4cb29df1@mail.gmail.com>
	 <1220897594.31304.83.camel@johannes.berg>
	 <1ba2fa240809081524ia1860e3o3327a64c933a09a3@mail.gmail.com>
	 <1ba2fa240809101432u23bf198bqcf9bd0e9f91a2ae8@mail.gmail.com>
	 (sfid-20080910_233253_312411_FCC1C92C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y3sI06H9ioBdMmEC+FEb"
Date: Wed, 10 Sep 2008 23:37:09 +0200
Message-Id: <1221082630.3804.43.camel@johannes.berg> (sfid-20080910_233750_405651_C86222E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y3sI06H9ioBdMmEC+FEb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 00:32 +0300, Tomas Winkler wrote:

> Okay so here is the scenario. Iwlwifi reject scan that is triggered
> withing fixed period after
> association to leave time to finish EAPOL exchange.

Why is iwlwifi thinking it's associating in an IBSS?

> We never hit the problem in STA mode because of this code
>=20
>  if (sdata->vif.type !=3D IEEE80211_IF_TYPE_STA)
> 		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
>=20
> which makes it go through the work queue, just pure timing luck.

Well the remainder of the code makes it go through, but yeah.

> I will remove this delay for IBSS, there is no association and no 1X
> is going on.

Ok, makes sense.

> For BSS I suggest to enforce similar delay already mac80211, iwlwifi I
> just return empty scan completion and buffered results will be
> returned.

We might want to enforce a similar delay like that in mac80211 instead
of iwlwifi, yeah.

johannes

--=-y3sI06H9ioBdMmEC+FEb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyD4CAAoJEKVg1VMiehFYHMAQAJ83zU0YB1PRl9nWGd3ik6QK
HofR+m9ePXNbQhQLYqvsbgm5Lal2/CsVWAv6fN9RytrdcmsSXbKxiwulns8mgFOP
LwhV79IyJljNCzQhbf1cqZc01UFJloDAgMyGTYsxs44eVqSSQrOE/qYuTk0khQvO
DgwXYAsHLdvv41SoA+ayTwh3Mo2XPHzn8iswP0SbqjRCTQ3Zy2HqAHA/OfKAW+IP
AjEU8UxX0Z2tMXeC5JnY6zHBFVUIUuyUsQkeMkLNAYNezY/CoFUaSt/XYN1qJkzG
O/vVNWqLtmR3wcgqO3TuEMcpGbBusxjU+YW7YrWlTRxrEbYpzDgtBk8uvwxkSa7P
9OVl+Hcy6lqW1WyX8DXWZCHxuNxvnGh0FqtsAOiWIg/6iApjolCzr1+JkJF0qBrH
r0zgRdBqBILrnEKDkmu6fJuVZ3I9kXy3JAX1EjQVi0NudtZOjNfJxaZgs9GBpy/X
C4UyBs6D0WUYFY6nOf97k9WVMKGgFGOIgficleY+CZDQolsYW1+zbxRbb8S6MBOB
8F38nTFN4MsOtOBrJaR4uvqtVPewuwhx76dEPSMFb+PyiVuvjR/cGW+iKix/52GM
SuBx75NPD+8/LdKXXuE511tw7lv50UrJybBFcCwzEefByNQ13HcJU4qFXJ7jfCGv
UcLZlhRom6BFUC8jVxf0
=bHvy
-----END PGP SIGNATURE-----

--=-y3sI06H9ioBdMmEC+FEb--

