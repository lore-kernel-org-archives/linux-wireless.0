Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZBMVT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:19:56 -0500
Subject: Re: [PATCH] mac80211: split IBSS/managed code
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090213203641.199830@gmx.net> (sfid-20090213_213711_951136_CAB188EF)
References: <1234396421.16004.67.camel@johannes.local>
	 <20090213203641.199830@gmx.net> (sfid-20090213_213711_951136_CAB188EF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s5hhuOcqHFb04xQX6JiM"
Date: Fri, 13 Feb 2009 22:19:50 +0100
Message-Id: <1234559990.4219.27.camel@johannes.local> (sfid-20090213_222001_688705_45BE8CCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s5hhuOcqHFb04xQX6JiM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:36 +0100, Alina Friedrichsen wrote:
> Hello,
>=20
> this patch is broken.
>=20
> * In IBSS beaconing doesn't work.

Odd, I'm sure that worked for me. What hw are you using?

> * If you create a new IBSS network it
>   scans for other networks to often
>   3 times a second.
>=20
> [  844.752425] wlan0: sta_find_ibss (active_ibss=3D0)
> [  844.752435]    did not try to join ibss
> [  844.752449] wlan0: No active IBSS STAs - trying to scan for other IBSS=
 networks with same SSID (merge)
> [  846.032344] wlan0: sta_find_ibss (active_ibss=3D0)
> [  846.032356]    did not try to join ibss
> [  846.051622] wlan0: No active IBSS STAs - trying to scan for other IBSS=
 networks with same SSID (merge)
> [  847.214000] wlan0: sta_find_ibss (active_ibss=3D0)
> [  847.214009]    did not try to join ibss
> [  847.214025] wlan0: No active IBSS STAs - trying to scan for other IBSS=
 networks with same SSID (merge)

That might've happened here too, but given that I never used ibss
usually I didn't realise it was wrong ;)

> * If you join an existent IBSS it does
>   the following strange things:
>=20
> [ 5238.150840] wlan5: expiring inactive STA ffff8800bb800340
> [ 5238.150847] phy0: Removed STA ffff8800bb800340
> [ 5238.161306] phy0: Destroyed STA ffff8800bb800340
> [ 5238.161316] wlan5: No active IBSS STAs - trying to scan for other IBSS=
 networks with same SSID (merge)
> [ 5238.223183] phy0: Adding new IBSS station ffff8800bb81a04a (dev=3Dwlan=
5)
> [ 5238.223205] phy0: Allocated STA ffff8800bb800340
> [ 5238.223213] phy0: Inserted STA ffff8800bb800340
> [ 5238.855114] wlan5: sta_find_ibss (active_ibss=3D0)
> [ 5238.855147]    sta_find_ibss: selected ffff88009942f040 current ffff88=
00bc0219f0
> [ 5238.855150]    did not try to join ibss
> [ 5238.867113] wlan5: expiring inactive STA ffff8800bb800340
> [ 5238.867122] phy0: Removed STA ffff8800bb800340
> [ 5238.880673] phy0: Destroyed STA ffff8800bb800340
> [ 5238.880684] wlan5: No active IBSS STAs - trying to scan for other IBSS=
 networks with same SSID (merge)
> [ 5238.943194] phy0: Adding new IBSS station ffff8800bb83a04a (dev=3Dwlan=
5)
> [ 5238.943218] phy0: Allocated STA ffff8800bb800340
> [ 5238.943226] phy0: Inserted STA ffff8800bb800340
> [ 5239.572256] wlan5: sta_find_ibss (active_ibss=3D0)
> [ 5239.572282]    sta_find_ibss: selected ffff880099539640 current ffff88=
00bc0219f0
> [ 5239.572285]    did not try to join ibss

That does look a little strange, even if you disregard the fact that
you're using compat without %pM :)

I'll take a look at it and fix it up.

johannes

--=-s5hhuOcqHFb04xQX6JiM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlePzAAoJEKVg1VMiehFYzM8P/RAuxByTfP0YolRjf9RjQ6d7
YClteV7pJ4wcAuPmAXGO+AgU1xizqPNBFWInsdCaZ5JxyVmvgcnLQZRXe/Ss/XFu
fvyrp4pljUGHVWS6RWFLEkUTVhpRBOj0YJYngNOnXPGb/b2/ieMIPeFKYDS37++7
y/Z2wgryRagnOPpaYNkxpnNCPblRYoJ7yRF1MPjiWWCmvI0l1N4hvuiCMj5j4NIh
DRuISexOQ5xixcYjOsCPoM/FK6+BRvgsD7hM11NxD9FjXUWI+ROO8w1jLUH66Wby
vJPfsVZ0Va9Grc2ZkVqAW1UzbGswqy11OZXu07Kgqe1bqFq7W7GM1N9cA68iz7Uv
E/IUaLScJ6VV5q4q9H+OpdQPaWff6XqDw17oYD47KVAIBw58wcuNBlj+tpdFfLhg
tUP+rw093C4pL/WlCMu0XWBvzuww3b8wAcTTefeBNgYoyJei+33CqNU2HN8lRBp+
cdjFIbxvAIx3oj5WoOlJGpejeNN78iYWYvFnXIwtLkGmhsi8dl1VFaf6jBwyNiEW
E4LV2oTbTHg/217NPcI51n/N6kVJ6faQzio7KI6ThgWUTA5Jv0oNPSDTgvAbRNy7
RFodmYDa51KF+3bzCmGaIlWA+ESfA5UZ6hZjGrYZUtjoUt+WqBDJmelOIc4qlkO6
H57oZXVCn2tbkvA+BG1A
=FH05
-----END PGP SIGNATURE-----

--=-s5hhuOcqHFb04xQX6JiM--

