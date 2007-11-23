Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXKWMqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:46:44 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711221719.40412.hs4233@mail.mn-solutions.de>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-K3cOSwUuWKbkB2vsvJU5"
Date: Fri, 23 Nov 2007 13:46:38 +0100
Message-Id: <1195821998.4149.113.camel@johannes.berg> (sfid-20071123_124651_341651_0C87BA28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K3cOSwUuWKbkB2vsvJU5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> So, things brings me to a weird conclusion:
>=20
> a) earlier you said that in WEXT, the only command that is=20
> defined to get you an association is the "iwconfig XXX ap YYY"=20
> command.

Yes, but you're assuming "YYY" is a MAC address while in fact it can
have two special meanings, "any" and "off", see the iwconfig man page.

> If I accept both sentences as valid, I must conclude that=20
> mac80211 is faulty. It happens that mac80211 triggers an=20
> association to an access-point also by the "iwconfig XXX essid=20
> YYYY" command. This is not defined. Hey, wait a minute. mac80211=20
> is not allowed to do ANYTHING that is undefined, because tools=20
> can only rely on defined things. So mac80211 is faulty. Crap,=20
> ditch it.

Nope, this isn't what I said either. You've (I guess intentionally or by
just being too set into your line of thinking and not accepting any of
my arguments) managed to misunderstand me *COMPLETELY*.

You said, paraphrasing: I have a mac80211 _bug_, it's crap because it
doesn't support this use case I dug out and that happens to work with
some other drivers.

I said: It's not a bug.

You understood: Johannes hates me, he thinks mac80211 is buggy, and he
also thinks mac80211 should only do what he thinks wext defines.

See?

I wouldn't even object to making mac80211 try to associate when a key is
set, if you can make a clean enough patch (which I doubt). I do object
to calling this a bug because it's not, it's in line with what wext
users can rightfully expect.

johannes

--=-K3cOSwUuWKbkB2vsvJU5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0bLraVg1VMiehFYAQKjhBAArIYwTR3dO/pPdi3kqLak6lENtUr93T/W
wM4clnecFu4sltIKSWtwD1V6wjt6+gzMZEwDt+WUhpgjAO4wNx26aEf7O+EFpXNk
KHHR9w30SYd+icqxw8lwmYe+QjhW7AkbafkwFy4EcmP5QgmmjXiZL24FkJoCGssT
8umFDmmb2D75bn1Cz8SUHQ2uKzfUJ5KdXHhgKcQCKoopqiCVYKe+DvYgpVZiQ1Vo
7BEIaZ6XOm0yZ0rpks5lEg6/wW53Jd2DJaJmC/isjBi5zCGhY+bIr5jbrfJEC8qL
oXhBzsAUE3hNJcpR2Ra0mtFf9PS03ZScd5mRqm7NF4c3GPfLE9w8NC5p+3EhaSgz
Df8HS5evLBoSYpcmhMOp9yX3jwac+hlv0T4c6p0NhkgNb4Trd4VkUEzSYbFORZ9D
4DE+VmWqoD2VKsB1N6/a7BR+jkJEa6IHk/6vTx9otxjwpZM5Z6j34ceolvLMELTL
ohTuu/1Omgg4Bnukq38nj5ILyrNM3Rooa7C4STtWybH2dls0JoHo8Yf0wbYtiikG
DwKinVgjDWsahm4qxuKeElGbExrlk6/PW/5c6gREdm4vm3w3mvc4YRQVqwnSVnrJ
d5SVxMwgl5Nq2L8B03k4j+MBsynN6A79q0HarlP5e3nh4gj0L936cbo7UYa2BaET
onc6B+j6EhM=
=ewg1
-----END PGP SIGNATURE-----

--=-K3cOSwUuWKbkB2vsvJU5--

