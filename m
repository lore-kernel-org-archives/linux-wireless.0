Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbXKPUz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 15:55:56 -0500
Subject: Re: [PATCH] mac80211: hardware scan rework
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Ben Cahill <ben.m.cahill@intel.com>
In-Reply-To: <1195204494710-git-send-email-yi.zhu@intel.com>
References: <1195204494710-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yNmoptM7jelij7cDLCV7"
Date: Fri, 16 Nov 2007 16:40:46 +0100
Message-Id: <1195227646.8147.138.camel@johannes.berg> (sfid-20071116_205610_096662_5DF70129)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yNmoptM7jelij7cDLCV7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Looks ok, although I'm wondering whether the two new flags
sta_{sw,hw}_scanning should be subsumed into scan_flags instead. This
might have bad locking properties though since the ioctl code changes
them.

If not I think they should be defined as 'bool' and treated as such like
here:

> -		if (local->sta_scanning)
> +		if (local->sta_sw_scanning)

Rather than being tested against zero explicitly like here:

> +	if (unlikely(local->sta_hw_scanning !=3D 0))

> +	if (unlikely(local->sta_sw_scanning !=3D 0)) {

> +	if (unlikely(tx->local->sta_sw_scanning !=3D 0) &&

Also, you don't avoid doing the hw reconfig while hw scanning in the
ioctl code:

@@ -315,7 +315,7 @@ int ieee80211_set_channel(struct ieee80211_local *local=
, int channel, int freq)
        }
=20
        if (set) {
-               if (local->sta_scanning)
+               if (local->sta_sw_scanning)
                        ret =3D 0;
                else
                        ret =3D ieee80211_hw_config(local);

Since we're doing a hw scan, shouldn't we be able to avoid calling
ieee80211_hw_config() due to scanning? Then, ieee80211_scan_completed()
should reconfigure filters and hw_config only when a software scan
completed and in the hw scan case not touch the sta timers, netif
queues, not send nullfunc frames etc.

Right now this is pretty asymmetrical, we're treating a hw scan
specially when it starts but we're still trying to reset everything when
the hw scan finishes which seems weird to me. Do you think you can fix
these design mistakes of the hw scan code now?

johannes

--=-yNmoptM7jelij7cDLCV7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz25/aVg1VMiehFYAQK+Yg/9HYK9wKe+XVtuLeJvBVigKeLLH+5SvRQ+
a0bzqSBSA4upj2ZOLfWdTRIiTfksfJUG+l7xlSvlOEBZfHh9LZGQvFVop4Gj1gV5
jThZu5wPR23ucpUMBPnbw4sqafAipsGKTbqhC1kxQ62tnDwUmAkysfzqOzDfODus
LZTPx+HTL3QJTYGndzGXfl6RtNX4KvAhqBFawh9ilZE2ufcOE3BlU66fus1ke3E7
kw8h16zRjcCkQP7yv0ACAyhQj3lmUlwSoMO3bNwdQlxE7neEZ8pYC2oIiQXR+iPv
HWNiCWQh7S35qj+TfAefVP1AzHooOdEfsdwWeOlACjlZRhqAoRqKJBqQX84Tq1WY
i7lyGveNcDP3LljQ2j1ogdkji9BAEO7zjCPn6/WhdJ3EskvqiqUCmPYzhM5zQfR7
pTQx39m9qHa7yteTeWd45L3bKStJmH7sGeivjwXlym3q+RZ3WvYqjrvPBTXLY1hl
2taOnFuxeeq4Kr70718dPC8VIGITV+4wTP/Bww6oWQUS5tRw4O7n6J0EojXWXP1L
56RECKui3N4/kEu2UMkESrTHbxGlI+3HpeBlrE7XI9GHp4YgB1z1vmeoDiJhg6G6
m0cDV/MsRxSBYb64JBmGRdSqgZJrYGBZ3wLY+LprMdCkd3hVVMDqoMmle5TUtR+0
ZxuyfNiCxsk=
=xTg0
-----END PGP SIGNATURE-----

--=-yNmoptM7jelij7cDLCV7--

