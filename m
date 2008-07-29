Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886AbYG2NHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:07:52 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com> (sfid-20080729_150435_076308_D72E08C4)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 (sfid-20080729_150435_076308_D72E08C4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DAsXsh80z+twR+e1lyPu"
Date: Tue, 29 Jul 2008 15:07:49 +0200
Message-Id: <1217336870.10489.55.camel@johannes.berg> (sfid-20080729_150756_832700_B2E1C312)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DAsXsh80z+twR+e1lyPu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 16:04 +0300, Tomas Winkler wrote:

> Correct.

Ok. That means it can go away with the stuff I'm doing right now.

> Other thing is you probably not seeing the latest code as well. Yi is
> not publish new code before John is merging what we've already sent
> out. I also have something still in the drawer.

Heh ok, then instead of fixing iwlwifi I'll just fix up mac80211 and
give you the patches to look at aggregation, seeing that Ron is on
vacation for another week.

What I discussed with Ron (and Jouni) is that we should not use extra
software queues for aggregation, because
 - doing it requires requeue which is not possible with tx info intact
 - doing it breaks access semantics in the case where not just hw but
   also sw queues start filling up

johannes

--=-DAsXsh80z+twR+e1lyPu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjxYiAAoJEKVg1VMiehFYg4kP/Rq77pj/QeDFm6KwIVWVMgnc
B97IkHiem/vjF0AjB9nTCuJtwqUwPfPOF09NuLII/vRv3l4T/jvV8DIyBgIzzkvH
tjcB/5K4UldtBYgDmXz8CW9FQgz4b9A9an3fecvDh7iQEsEN66Ir/Eda/701SzTo
lwObr3ZxJVaVkgtL8hXYNGE19IjnilkIDhckJSNqWuZGzPV7/JD5fZUJYl+q37iz
TDHdruDT1w/rvXFND0iqnT2asso76lWP5zsam0LN+Vw/fZnxXH2LvnqMeU/epx1y
b+ujlYfhX9pFRLslsGhTFtXyPcNNK/iJPHKHadgHs0sLnLv1LsbjgLsfEWp4WHE9
fThtCEV4yRGcPnAT2MWxwT1C5IziGXV+Ke8F5BRHfLvQG1wdZMQd4aPafHTO/CIb
BuT9qmERFm5GagB+MlGPji8GNrXrHwLxLwLWuyTg23WfPC7+y0lVZYYTkuGt3FMR
p1JHolZb+WFhqeSyDAEZqXHtM+zwZqxnj8p0X82XBBBO2UbpRYwviBxdJGDBbZiF
hZg7cXY8w0bAxQgc12Q0iNPn3JIA+nWvbCBIOn6u9T+6jvIg3+lUa8yFLqa6WqKp
DYceIKUXJ9rlu/Pc91FhMthJR8NA/5l/5T0Covnrf/lxC8oI/Z+9bEYiy0RicMMn
uA0NnXpfx6AhTATU2PJP
=1r/t
-----END PGP SIGNATURE-----

--=-DAsXsh80z+twR+e1lyPu--

