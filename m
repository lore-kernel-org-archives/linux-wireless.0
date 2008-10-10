Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981AbYJJN1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 09:27:46 -0400
Subject: Re: iwlwifi: bug in iwl_tx_skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810100520h7d51624fr468aad2c6def62e2@mail.gmail.com> (sfid-20081010_142059_568711_8035BAAE)
References: <1223543081.22490.2.camel@johannes.berg>
	 <1ba2fa240810100520h7d51624fr468aad2c6def62e2@mail.gmail.com>
	 (sfid-20081010_142059_568711_8035BAAE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1iIOKGI7J3bc4Si0rGJ4"
Date: Fri, 10 Oct 2008 15:27:31 +0200
Message-Id: <1223645251.3748.0.camel@johannes.berg> (sfid-20081010_152751_465759_00382AE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1iIOKGI7J3bc4Si0rGJ4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 14:20 +0200, Tomas Winkler wrote:
> On Thu, Oct 9, 2008 at 11:04 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > When iwl_txq_update_write_ptr fails, you have a huge problem: the skb i=
s
> > linked on the queue, the write_ptr has been incremented, but you preten=
d
> > you can just free it.
>=20
> It's not freed it's should be picket in the next round. We should
> really return success to mac80211 in case

No, it _is_ freed, by the caller, because you always return success to
mac80211 anyway and kfree the skb before. And if you didn't return
success it'd be just as wrong.

johannes

--=-1iIOKGI7J3bc4Si0rGJ4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI71g/AAoJEKVg1VMiehFYTwEP/0goF/lDAqErFN91CNvLldOf
P/zyTjndyKwSLzjUbD5bD5YZlfwVtXKmepqgWhvgm0KxJf4EQ7cFgitOImqn97HW
yEtDSaupC7jDPqx/a6ePc8qiswaWXgOS9vQD3rddrh/N/giJXvKqCiaESor9tLQI
T1us5MWxkwQcIZC3OlL4qZ+9lCBVJ/+pZY17kHNWzKgXSQiDn8jGeIf5wsau+raY
aaAAtxk490woWobKrIk02o8cLdigbyhRXk0CF9hYbpYs3HKHFHfe19il/b3sJBVb
HlNTEt7lmsaB75xjxqVbYSMHGlZUvPWuZKDxg8PDxd54EpUuX7dxbAnNvzUdxg1/
wlifvNY5zpwzoPfZUoxLm1bR11btYo/QaIteifNw92wXeLX2Yf24m8rYoy2UJmEE
M51BjZXoxMMkfTlNkJ7k+jsCGvt2h2UvdpaIhwsVvpUH/1PCTU6xgGtUatoVIUKt
lB2FsenPclR+dMszMOfSbIUXVnp3zO2xXsl6LUgZ29OtFsZBRvRsIcsIRuW9MLlq
DX3IAT0+amtGoKFXROIdyRJQf3RlCBOjaLFJ5dVYhIkEUK8DxFeA30SxQ3ggwths
nkNmOORANDe0Znr+5OcBYRe2FlFxIMwTX3+c0PSjt+8SVvgfzjneThjch2CpNISZ
ftUM0EucQWWw8KwRk8Q/
=RK6F
-----END PGP SIGNATURE-----

--=-1iIOKGI7J3bc4Si0rGJ4--

