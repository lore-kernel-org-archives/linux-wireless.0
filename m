Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbYCDKAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 05:00:40 -0500
Subject: Re: hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jouni Malinen <jkmaline@cc.hut.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1204596228.3087.113.camel@debian.sh.intel.com>
References: <1204190255.3090.165.camel@debian.sh.intel.com>
	 <1204210453.6309.49.camel@johannes.berg>
	 <1204266154.3090.182.camel@debian.sh.intel.com>
	 <1204302356.3938.36.camel@johannes.berg>
	 <1204528099.3087.15.camel@debian.sh.intel.com>
	 (sfid-20080303_070851_717668_24B899FC)  <1204537945.3917.38.camel@johannes.berg>
	 <1204596228.3087.113.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UzzwMKhPoQ6SMgzAY+1s"
Date: Tue, 04 Mar 2008 11:00:22 +0100
Message-Id: <1204624822.3917.85.camel@johannes.berg> (sfid-20080304_100053_912373_DD2E52F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UzzwMKhPoQ6SMgzAY+1s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, it (HOSTAPD_CHAN_W_SCAN) was removed somewhere after
> driver_nl80211.c set it. I think it's a hostapd bug. Please take a look
> at the hostapd_get_hw_features() function:
>=20
>=20
> if ((feature->mode =3D=3D HOSTAPD_MODE_IEEE80211G ||
>      feature->mode =3D=3D HOSTAPD_MODE_IEEE80211B) &&
>     feature->channels[j].chan >=3D 1 &&
>     feature->channels[j].chan <=3D 11) {
>         power_level =3D 20;
>         feature->channels[j].flag |=3D
>                 HOSTAPD_CHAN_W_SCAN;
> } else
>         feature->channels[j].flag &=3D
>               ~HOSTAPD_CHAN_W_SCAN;
>=20
>=20
> Apparently, A channels all have this flag removed. What does this flag
> stand for? I assume it stands for passive scan, right?

Ah, you're on 5 GHz then? Sorry, I'm not too familiar with hostapd
internals yet. I don't think the flag stands for passive scan, I think
it pretty much used to stand for "channel is usable at all" in the
dscape stack.

johannes

--=-UzzwMKhPoQ6SMgzAY+1s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR80dtKVg1VMiehFYAQI/QA/8CrMIqreE/TpBdHvhKT6tq1yc9KJkpZCI
1RKvpHh1IpgJz4KJyg0xKTpg5Bs+jsvGAQnJx5C8Htf7XpDx4tStUCYNDHOQAnXM
3kjdJ3sRtwZK7OZzUXaYWRAhoAdps6DZj+KGrYTMERaWYE5zuPGW/5RPk/qs1jot
inSzVJR8ZL/RSOtMgv3KXSve9Lk6IbJE1SspZWCB8YY6qrtFobrEcIt/rwHkY3QZ
lPmaymVPBLvhGDP+DakpLxmK2nGVgKUOoUIc2Jeth75YdYVyfKLRTUtINfYi78Pu
W0QT5cHcQcFJJ/OnavH4oksw7u1q/gIeE5Ht9xOwcWuvaoXH0cgleJ8KhGQ/ME6d
QIOZ2/2jbpcjgiz5Mx+dYgfYuRGFbeo9iNnmGZNgLYZnjlkdeZ47MxYaj3GC4KDb
0MwVydX68JcFPaGSss+s/iuBnVSPIMurt3UFhTNKF/adxETGsdfjFc/afUhPD5pM
HxwppFaJrLgh5sbHosa09AZSCtgF6lOjkOy4RLw61eiPXD+dmkdwGidoILUDa4wV
cpHiCaa7D2woYmgDiNDK/CJMrg3Y5RHvCF2XoGUatWXZw+lQyJFKHxNwHXfq3dEF
576QeMusbwmaquBjiGMfe+32evvpqrTw70it6kbu5Sx+NMlsKG4OOvPoMu35C2Ou
dN049Q2UIuw=
=PS07
-----END PGP SIGNATURE-----

--=-UzzwMKhPoQ6SMgzAY+1s--

