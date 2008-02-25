Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBYVYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 16:24:16 -0500
Subject: Re: [PATCH 18/18] mac80211: enable mesh in Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203973083.6929.79.camel@localhost> (sfid-20080225_205634_226995_07239062)
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142018.468705000@sipsolutions.net>
	 <1203973083.6929.79.camel@localhost> (sfid-20080225_205634_226995_07239062)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V8hRIePxtKsfwTzrxAhl"
Date: Mon, 25 Feb 2008 22:24:07 +0100
Message-Id: <1203974647.13162.174.camel@johannes.berg> (sfid-20080225_212420_862124_CD0924DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V8hRIePxtKsfwTzrxAhl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 12:58 -0800, Luis Carlos Cobo wrote:
> On Sat, 2008-02-23 at 15:17 +0100, Johannes Berg wrote:
> > Currently marked BROKEN because of endianness problems.
>=20
> Will take care of those problems.

Oh this reminds me.

You have a lot of macros like

#define PREQ_IE_ORIG_DSN(x) le32_to_cpu(*((u32 *) (x + 13)))

Would it be possible to define the preq IE as a struct? Not sure if it
is. Either way, this should be converted to a static inline instead of a
macro.

Also, you need to add a lot of get_unaligned() to the code. Please read
Daniel's excellent Documentation/unaligned-memory-access.txt

johannes

--=-V8hRIePxtKsfwTzrxAhl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Mx9qVg1VMiehFYAQITTw//axHezqquEP1ZAU68DSuckFKqp2cthASj
okKE88GMEagJKVddM62ju0wucLYaYpB3hLagJXvghcHQ+vm/rsFxwm5+W0YcpG6g
o40FrSVXIG1HKB/0U8uTmghFPHxNm4d6quNfdjsMg9NKetA+i8oTc14Q03gBuX/f
EbX6qD9kYYc/4ovDjTVmePzt/D1lpQTaiem5koZ0ZeQ+3hJ24pMHPeHnhPVJsVZF
s/HAkCGG6p3emL+Wl7s+AgdWEmj6R/F6178L+Yyuv+JDW4t/p7egT/ONJGBxr54g
Z1AUSuDlSzGGkEsr7tkrKZ3YapNImODr2mDY0NP7sZa3sWaXrWsnj770BYXgxZkX
qJhz1EGgauAIpNELdZuhEa7BJwZQgv46/56S/mF2IJnJq0cmc0IIe7ZpOSwzrMOw
6FMYhVF9Fhl96UBlCFjQAQN+BM70n9SiaQ3EN/6yQgTVTz+BxB5ZZk7T2UnBg8ac
LxiOGlhDgmrFfejITBRDAVhwmotXSM2Yf5vkTYXh05jAMVOzTxFGKQI5bLB0HXnz
tPsRL2D1G71Itp28/O42s0BBhyp8AXFZ1J/Vw2zM2jYA2A6cxqyuQ8cswU0dKqOW
ThU++ipADY9PIzn5N/jSwtjzrrfSs5DYeAU+6HH5BpMis68APUS+6b1p9XxeHdnC
MKRzSEzP49s=
=NDLR
-----END PGP SIGNATURE-----

--=-V8hRIePxtKsfwTzrxAhl--

