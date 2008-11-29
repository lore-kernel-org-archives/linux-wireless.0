Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYK2Jl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 04:41:56 -0500
Subject: Re: [PATCH 1/3] mac80211: add power state transition callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200811282345.48379.chunkeey@web.de>
References: <200811282345.48379.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HWvImUd/NJZ7RwBfnIny"
Date: Sat, 29 Nov 2008 10:41:49 +0100
Message-Id: <1227951709.3542.1.camel@johannes.berg> (sfid-20081129_104201_088320_7934C4ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HWvImUd/NJZ7RwBfnIny
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 23:45 +0100, Christian Lamparter wrote:

>  /**
>   * enum sta_notify_cmd - sta notify command
>   *
> - * Used with the sta_notify() callback in &struct ieee80211_ops, this
> - * indicates addition and removal of a station to station table.
> + * Used with the sta_notify() callback in &struct ieee80211_ops.
> + * this command indicates addition and removal of a station to
> + * station table, or if a station made a power state transition.
>   *
>   * @STA_NOTIFY_ADD: a station was added to the station table
>   * @STA_NOTIFY_REMOVE: a station being removed from the station table
> + * @STA_NOTIFY_SLEEP: a station is now sleeping
> + * @STA_NOTIFY_AWAKE: a sleeping station woke up
>   */
>  enum sta_notify_cmd {
> -	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
> +	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
> +	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
>  };

You know, I'm sorry, but I've come to realise that adding it to
sta_notify isn't a good idea after all. The one thing I forgot is that
this new callback has to be atomic because it's called from the rx path,
and sta_notify doesn't have to be.

Unless we want to defer RX packet processing to a workqueue rather than
a tasklet?

johannes

--=-HWvImUd/NJZ7RwBfnIny
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJMQ5UAAoJEKVg1VMiehFYfuMP/08IrdvugLDnxCVYhFHDQH+O
DeBwDdLajYKzTFOUGLTkCKoqbKTWLWGn6VRvHgexvlNz3wfCPRnWraocw+O87jKu
5HwjVIZ8joiGc+QvRHdC1/L8NCkCiAa6wYs0n0zDUkxI2CkvigmU8jlIdezYrE6e
GiuIVqhIVQUAixehRXtMV2dbb85+R0wnBTDDol0bd6mNINg++bXHranyC6vrcSoO
n/T/r1k+NR2wx3rI2PSV2R6il5ogHI/I+SFPNOxfDv2x+KvqPum5rlLhFmfy3WM3
ThQHcwcig7lDDGMl9iLNJ7+FDrZ7VkCfiFfv/4XBKqqSWenLPn0lxYgkTEBO9nif
01e5mtLnz3+AtJS0NIz/BRgYpOPco5vWfWidz4Mt/F/ephAHAdCZODR4T5eFvAGM
wJ/q4TIKTUbon6KaNEhiW/9SkoHE9hyE/9fufWhOFTGa3GdZrrLibIz08OXcAkK/
JYV5DYve/w6iNoSjHmler36gA8RjzIlUkU9FMOcJbNZKBoVQULVSWNQ8rYl6LelF
MT6d1Umquj6yqEH6zzye2Z7CDHhe2RijIcd9DpQtVNQS2NXAbK1Bspl+CM9gnF6P
NPIrMpdSvW7SpN7LDXcJ7JiJkuBiu02+IRezkbWMRUP1UQ0d1f6C892LVHmzs507
6hFKUlpiA6qGP7GvUsNR
=rGZ8
-----END PGP SIGNATURE-----

--=-HWvImUd/NJZ7RwBfnIny--

