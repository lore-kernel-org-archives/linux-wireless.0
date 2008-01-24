Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYAXOww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:52:52 -0500
Subject: Re: [PATCH 06/12] mac80211: A-MPDU Tx adding qdisc support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163392546-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115437_990483_56CB312C)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392546-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115437_990483_56CB312C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4TM8++2SKrXfetvxqHUj"
Date: Thu, 24 Jan 2008 10:42:58 +0100
Message-Id: <1201167778.3454.75.camel@johannes.berg> (sfid-20080124_145307_592898_28722F67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4TM8++2SKrXfetvxqHUj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#define IEEE80211_TXCTL_AMPDU		(1<<13) /* this frame should be sent
> +						 * as part of an A-MPDU */

Broadcom hardware will want to know
 (a) is this part of an A-MPDU
 (b) if so, is it
     (i) the first mpdu
     (ii) an intermediate mpdu
     (iii) the last mpdu

Can we provide that easily and avoid the driver having to keep track?

>  struct ieee80211_sched_data
>  {
> +	unsigned long qdisc_pool;

If we ever have hw with many more queues we may want to increase
NUM_TX_DATA_QUEUES_AMPDU, so if I understand the code correctly should
be an array sized something like BITS_TO_LONGS(NUM_TX_...)

johannes

--=-4TM8++2SKrXfetvxqHUj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hdoaVg1VMiehFYAQIoeBAAsfvYLERJozJy0CDJgtt2t6EnDD/rQagL
QZu9Tsx1mKzxx+EmqQpZ8jQjSJ38a4WNNgJgdmBGXPwC0n8F9ik6d9JtOBmbSt6V
cXfX5PsgoQGJLxNFLB8wr15XZA/hf9rDen2EStUK6Gh7+eoVeN1LjzT1yWjtjjkk
cDaJoc5hMqP9ApdXKMsCmc7nTbQ7EU8RQT/NA3aVdN8kmyne7FSUHFApcNBAMjze
juKXqHbAWgEgh29kgN4cenBEesKXbKwOCUkdx822JrJZptddqvKhFQGtoHCnfnX3
/tyKIdr36S4FfGAlbZr2xyetNTNCQ5fc8t/39BzSdWdOH/Ej+5Ts5tAvkK9WHb6z
C8LhmHYgLktnGysIaxTdcV2zLbtgBqG6v1lpabwRdGvIzWVDP5hVkGyT4XBdrfzh
RP/A7IvkWHrsHUtyP6PjmzC+63iJeJEJjqK4YtIEZochkMmOiq7N9hcxzo5XEzAy
gk/B43jlwjhZVjhUhnxyc3Dt5SBRvbbiXkIepNvpSGbo5rKLh8do1OF7gvB8+ju6
aRqZ69OzwEUjp5oZEZII21KqdklXaA+kLXhx+sJicPOzPcmIolTHDf2vvXqcFYMB
aZk4KHrCeoWYRJV8q1EDz0NcDqGT9geWTg9RODE2NznCKkbG++AgTzdr+a86PeS2
snetLZK9Jwo=
=LdJ2
-----END PGP SIGNATURE-----

--=-4TM8++2SKrXfetvxqHUj--

