Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYI2KBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 06:01:24 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>
In-Reply-To: <48E0A65A.2060102@gmail.com> (sfid-20080929_115647_357579_07705D4D)
References: <48E0A65A.2060102@gmail.com>
	 (sfid-20080929_115647_357579_07705D4D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rUDlgAtIOU7PzyqbtARX"
Date: Mon, 29 Sep 2008 12:01:20 +0200
Message-Id: <1222682480.7064.16.camel@johannes.berg> (sfid-20080929_120126_509608_E8DECD50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rUDlgAtIOU7PzyqbtARX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

> I've found out, that NL80211_CMD_GET_WIPHY reply doesn't fit into a messa=
ge
> socket buffer now. Used driver is ath5k.

Ok, humm, I have no idea what to do. I guess we'll somehow have to make
it possible to split it up on band or channel boundaries. But since
those are nested it seems somewhat weird to me. Any ideas?

> There is also a bug in hostapd which waits for ACK forever when this erro=
r occur
> in i802_get_hw_feature_data().

I should replace all the code there with the current code from iw, it's
much better and actually handles all the corner cases.

johannes

--=-rUDlgAtIOU7PzyqbtARX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4KdsAAoJEKVg1VMiehFYU0oQAJXb+gReSqhWjuSpW26ZvB+A
EHTBIlz/iNlSr9816ajK+ETk1IDnGnFs7S4+/gD/cl5/HJ6eFZMRtFqyOMvNzE5g
Td6ZdUfiyG+qE0XTAJYRrVc0BxVBSk4phSIYRqAXIdawlWYiUf5qayNPvoIimaXh
JweVvCHsxRnQv4nneUFymtwu3ImY4axUA3eT6/z7Ls11ivBWX9Yr6gK5ymqTUAXi
ZoZUrAdTwucdPEosJgFZZiuTjoVDgOidGemSYfxj2Zed24XpHxCJxdeYGFdYAs49
LzEgbj8pdewW+3SGI7TA/jwPmId6UGcOUkTonu9ybLZUxVFLIXlaUCc2kuPhwiLv
UIkulMEuKyI7cYgqZK9n8Yzur5Q/H2VcRZgaOdCfKXb7VtnlF7AVfZdZjBOAY0jH
vC/vvxwbUq9dY42OCzM/qOyTS4TKf7rr5RpdyMx46FPds3fcVozmWYictOuMHi17
UTVQ002tyKyY6Nl11ZtawtCvO5Sgv89VPcDxkRNo3QelHpClySKz0uhjWXIvFqqa
LNrMCOWyKNCmw2xYFK5WXvouBnlXwyLubw360kcqhdtDHvCH/1FU7+6wmTvCqn0/
LT8mcwEeaKmckUEbLPImopcPhKV5yuqLc/hlOZSzd3vCegSQGm4dDTQC3MJy89D5
FZftgzrZXhtHrE5MAcw1
=UmQ+
-----END PGP SIGNATURE-----

--=-rUDlgAtIOU7PzyqbtARX--

