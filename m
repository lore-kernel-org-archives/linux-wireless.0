Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYI3KTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 06:19:06 -0400
Subject: Re: [PATCH RFC] mac80211: change rate control API to allow
	multi-rate retry
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48E1EDE5.1070409@openwrt.org>
References: <48E17E75.50201@openwrt.org>
	 (sfid-20080930_033823_737779_1604EF6A) <1222759069.7064.52.camel@johannes.berg>
	 <48E1EDE5.1070409@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fVEox+mufFMh0HxdTEgS"
Date: Tue, 30 Sep 2008 12:18:54 +0200
Message-Id: <1222769934.7064.54.camel@johannes.berg> (sfid-20080930_121910_658615_368F728E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fVEox+mufFMh0HxdTEgS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 11:14 +0200, Felix Fietkau wrote:
> Johannes Berg wrote:
> > If I'm counting correctly, that struct is now 2 bytes too large, you ca=
n
> > cut out retry_limit I'd think by updating drivers to use
> > retries[0].limit though. And iv/icv length can both be removed and adde=
d
> > into the key_conf I think.

> I'm still using retry_limit as maximum number of retries for the primary =
rate.

Ah, ok, sure. I guess I thought we were moving to having it all in the
array.

> The retries[] array only specifies the settings for the alternate rates.
> If it's only two bytes, then I'll just move over icv_len and iv_len.

I think it's only two bytes, but you can just build a 64-bit config and
check that you don't get a build_bug_on :)

johannes

--=-fVEox+mufFMh0HxdTEgS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4f0KAAoJEKVg1VMiehFYV7oP/0K6S6nhmswxsaGp8ndAKA4T
Tub6Q56kXT7WeXbvBVTBGtzyVXsciUZebaXYwAX8EkX81Da45fzLh60LBzFXRpUB
zQ58u5UTWNsXjilIgMoW45YtmMp/jaeTEiBhXSAqUUgLHNOcaoLSnIhlyvajQ1J4
liDNhFkyRPhtd7bIbps5DRF/jJ5g0AM17Ngggunle5lFfAFqekIHc29i2bkjWnt2
fLT2LZDmkKrL4Apj5/8qviTpEholQQSpcxfVSNNVwz5YhVK5XPXtzlr54YZYBSPo
jDVrDD3HnAhZxhLF/mZTHm7mDV4/LI1AtCldACZ2C9gH/D8owSJRoa3MIYvB5WHD
fCl+W4vDTYGZIOp8N62Vpg5JluKpu6Dx4danBB9kSkq6DzG4rvWOkTN7IzZ2XYVN
XdIJWifab5KL5NrYRi4rgNKTQt9N3wOyhV3SLbJr8FXFVdMcXW231xjQ2G2STtyO
2+DlM8cRvc+laI2YVhk+/wmm9nUIBAwr9C/lXV7AG7nseF58Y0Klz52ZubFnDZkP
HsR7tYvqh78CrHqrjfEl9C6e12gIl58/1HUTDqh1ftK1IioW0dNIiddaTMki183k
lxt43eMUIOjY75IDuoPsAU+vr7SnPztZzQRAhfLplbjA+4aX14VAhoGorsXleEVA
4Y3ZNEWEsP8x+FXN35Vx
=jJbN
-----END PGP SIGNATURE-----

--=-fVEox+mufFMh0HxdTEgS--

