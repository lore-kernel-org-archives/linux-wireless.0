Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFXRat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:30:49 -0400
Subject: Re: [PATCH] mac80211: Add RTNL warning for workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214328526.8967.292.camel@johannes.berg> (sfid-20080624_192929_801113_8F555602)
References: <200806241923.36230.IvDoorn@gmail.com>
	 (sfid-20080624_192311_350711_BF3DEAAB)  <1214328526.8967.292.camel@johannes.berg>
	 (sfid-20080624_192929_801113_8F555602)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gwzoOMH8aT+wsncpkbus"
Date: Tue, 24 Jun 2008 19:30:09 +0200
Message-Id: <1214328609.8967.294.camel@johannes.berg> (sfid-20080624_193052_701759_47D6137C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gwzoOMH8aT+wsncpkbus
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 19:28 +0200, Johannes Berg wrote:
> On Tue, 2008-06-24 at 19:23 +0200, Ivo van Doorn wrote:
> > The workqueue provided by mac80211 should not be used for
> > scheduled tasks that acquire the RTNL lock. This could be done
> > when the driver uses the function ieee80211_iterate_active_interfaces()
> > within the scheduled work. Such behavior will end in locking
> > dependencies problems when an interface is being removed.
> >=20
> > This patch will add a notification about the RTNL locking and
> > the mac80211 workqueue to prevent driver developers from
> > blindly using it.
> >=20
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Johannes Berg <johannes@sipsolutions.net>

> Interesting point. Should it be there or rather be moved down a bit so
> that it is actually only flushed when _all_ interfaces are stopped, i.e.
> before ->stop is invoked?

Either way though, the patch is obviously correct and a follow-up patch
can change the behaviour if we want that, so for this one:

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-gwzoOMH8aT+wsncpkbus
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYS8eAAoJEKVg1VMiehFYc8EQALVV8KUCuJOkdNUMyiH3L+PL
uFbiB/EFaljJvp6vBzPg1tUrTcXCGX1DNVmuwrcEfn4YazzVPtCPqi6ZABweUEMZ
mc9ollIzl7q2lQjK7fGGLs0GpIBTDRWmlte7t45iqitkutBaOyRpI8GjvS8owo1N
3droDj77Ar4Ac6gjumYuBTnho32TzfSorbUZjRwJWRft185g8wk57sLL2O03Z+6d
K4Cb6GexaThlh9EMh6145th0XKji6F3kzh22PhdMix7zWnbFSOPPAqYc8tkxyJ3x
CBbawjBvDfi4MWpsS9vrmeIhCY+kpdNeoVKnpFwD504sOcjBjSCzZE0aozZJ+087
xIDgGGdDhOgOJGpHLAJlZ0tB1sUAeqAcJ5EkZY5Zg6ZX8VXYulZ9/8ptlxGKAOAb
s+y+rGz1H5q/bYLUNX0DqwJ/d4qME6Ow4l5mlJfgsutcdJAv/26vasGSef2GkYNF
CdtZxLYKFKtog934H70onOAVpQsCyWE6JtDc/MlPbuUj8bDDcdHj4Nvaj1leLkOz
1vNpEZ5YzSKVIEgqR8OK5PWcaaxHhEpEBrm4kXzciLbDqh4oaGzHwu/CIt4JBX03
JJLBaqslK8Pz9A8xNSWRtUv25lcNoQrsgHtIXZVIgbmupQV4iTSgCfzotY50+I9U
eE7DTAsuNuBwEX4wUopN
=/Sjx
-----END PGP SIGNATURE-----

--=-gwzoOMH8aT+wsncpkbus--

