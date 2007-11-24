Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXKXVgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 16:36:22 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711231423.23910.hs4233@mail.mn-solutions.de>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <1195821998.4149.113.camel@johannes.berg>
	 <200711231423.23910.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VF1Y1qju6N4WJSdtYSgP"
Date: Sat, 24 Nov 2007 22:36:17 +0100
Message-Id: <1195940177.4149.203.camel@johannes.berg> (sfid-20071124_213626_820122_9C643063)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VF1Y1qju6N4WJSdtYSgP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Is my second sequence "which I dug out" also not a problem?

I have to admit I missed that.


> I hope that is a bug that is more difficult to talk away. :-)

Heh. I'll give my best ;)

> $ pccardctl insert
> $ iwconfig eth1 key s:11111
> $ iwconfig eth1 essid MUMBLEFUTZ
> $ ifconfig eth1 up
>=20
> This sequence is basically what Debian executes at "ifup eth1"=20
> time when no wpa_supplicant is used. And it doesn't lead to an=20
> association, not even to a scanning (according to iwevent) when=20
> used with mac80211/b43.

Yeah, I've been bitten by that too. It's pretty tough actually but
*should* be doable though I would much prefer to set it only after the
interface is up I can see... Thing is that before the iface is up the
interface mode isn't set in stone. So things like

iwconfig eth1 blabla
iwconfig eth1 mode monitor
iwconfig eth1 mode managed
ip link set eth1 up

can probably never work properly. In any case, we ought to fix this
though right now I don't know what the best way would be.

johannes

--=-VF1Y1qju6N4WJSdtYSgP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0iZUKVg1VMiehFYAQLPURAAkeDWqSwqnWwlrQVQqO5goZ3TDEtF/yQz
1m/26CCbnGLGgFpvlLHOe8Wv0hkJ1QAD58rta65R8ZZo0heBnFW6dWKJTZ5o+nDC
9Uf9yE50h8VnO6Yx4gqNJH4frXhv+pS6xGjnk6bpIdfuNkrDZrwLMrQNW3Qw3kz9
DDuUUq5eF/zwb0WF7PFpaXQAgkzQgPdGZFj7vrvitfxtzgk1tHyfflOvHP0PLrhB
XxZzDN3crPOLnLLfA3g8dH6ezqRttg0Q7jqQqxji8SUqKFn+Qou6XJFPB8RZsEod
C2j3aFbGU3mvTwTZDO+dwNgl7oRXprpPGNqA8ZD3J98pmQoX7QPy14hpPv0iHili
a1t9KDPz4fjlkwKQGJKyvVinr6vt1jnRZRBxdKnxx+pD+SHlxN9bgrS/SgPGm3Cy
euD8LldsPsWV+MUv/fIflSzw9SAHPgwdQiPKgK7DuRNexxCPBKFEB36FJMpCRowf
BIt53aOx4eFv6vgLeziANomUcEoaTOUijbsx066Pj5qU8BHsJ/z8+9ZjivKfiw8u
+vYY7iGSWTCuHWSLXuOD4qeHWwhn0VjRcqUjx1tybmbMW7tsniR0GoGMyRTF0ctj
2hdDU6FKBOqS9ZurBaY+EpJQjV/xxxZAP9CVW/fIW040gt6SEmPmNozJaY+syGXL
7bfzfssF8Uc=
=KfDf
-----END PGP SIGNATURE-----

--=-VF1Y1qju6N4WJSdtYSgP--

