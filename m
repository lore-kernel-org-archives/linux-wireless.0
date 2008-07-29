Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYG2LYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:24:30 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217330604.6379.12.camel@localhost> (sfid-20080729_132329_995714_6D2C9701)
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost> (sfid-20080729_132329_995714_6D2C9701)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yw7EZwJ0krI7YEmZTAaV"
Date: Tue, 29 Jul 2008 13:24:27 +0200
Message-Id: <1217330667.10489.19.camel@johannes.berg> (sfid-20080729_132432_220148_BB868C8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yw7EZwJ0krI7YEmZTAaV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 13:23 +0200, Luis Carlos Cobo wrote:
> On Tue, 2008-07-29 at 11:32 +0200, Johannes Berg wrote:
> > This patch fixes mac80211 to not use the skb->cb over the queue step
> > from virtual interfaces to the master. The patch also, for now,
> > disables aggregation because that would still require requeuing,
> > will fix that in a separate patch. There are two other places (software
> > requeue and powersaving stations) where requeue can happen, but that is
> > not currently used by any drivers/not possible to use respectively.
>=20
> On net/mac80211/rx.c:ieee80211_data_to_8023() cb is used for mesh frames
> to save the original mesh header. Then if the frame has to be forwarded,
> the frame is queued on the virtual interface and
> net/mac80211/tx.c:ieee80211_subif_start_xmit() expects the mesh header
> to remain in the cb if the frame is not originally from the local host.
> It's a different step from the one you mention, but as I understand it
> it may suffer the same problem right?

Indeed, that cannot be done. Good point, I'd thought that case was
different.

johannes

--=-yw7EZwJ0krI7YEmZTAaV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjv3nAAoJEKVg1VMiehFYLLoP/1mVjSzmjvXjGXdFG/3hPZsv
wDWEzEwQROSSBpJvAy+L49jGbpKmAJcCfZR3SMsrAzYb8JDMZd1WZ3MTnR4FWAP5
oM9P4csvUGqoZSl3oEWViCiG06lHtOtmE4ng/rnSXKIUqywVMau0eUBQRc2ovvzW
PzBzRbmNpduZyJdNWfYYWWRU56hUn/Lv7AKlRrFKQgnMet5F+o6bK6426CKTClRz
1Yq+Vc7tPMtXkAtjNyrzGC2th1VwezKZEgzT8buMyaJU3GVGuaAiH/R3TXlc07xP
LLobJMHH7Niobps6lCPHtQjk7Hg/FsJjyHgT6yUBQuN83jg3fZhNbgw9Au6pj/T0
5TC9N3ZnRTam6HoSwPGy4sLyr8bh297WzchZdNVDlcgDClS+XwHht585tcfafrxH
q+upM2dA+yiklaRtLSb+D2WdQt+YRh/XvDgN3Hog6D9GoSOLcRJjhqbXV2UaR7IG
Kp1nVzVSuTY/9updaEuiVvDBInFEjn92p/jQuzrYY0wYsi9hxgfMYsIOSN26AF4+
422hZhGwURLp6NYlgULWpoH5UCww1k2ZU4odC+u4o/QBs3ewiVQmVGQLdloTp1cn
CyrgIa/VwJS3Gme6NrQ0QF/A1lry45NutksJzw0lAXDaZhJ0CJZjvE/fpuQrc/3F
QCzilOicCT8fBqvJBgNz
=Iz1W
-----END PGP SIGNATURE-----

--=-yw7EZwJ0krI7YEmZTAaV--

