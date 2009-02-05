Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZBEL4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 06:56:01 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090205111058.GA16422@jm.kir.nu>
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 <1233790539.7390.23.camel@johannes.local>
	 <20090205084407.GA11126@jm.kir.nu>  <20090205111058.GA16422@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lypXJHwx+aJSe3DM5C86"
Date: Thu, 05 Feb 2009 12:55:07 +0100
Message-Id: <1233834907.3931.4.camel@johannes.local> (sfid-20090205_125606_718302_3215F695)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lypXJHwx+aJSe3DM5C86
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 13:10 +0200, Jouni Malinen wrote:
> On Thu, Feb 05, 2009 at 10:44:07AM +0200, Jouni Malinen wrote:
> > As far as a possible workaround in kernel code is concerned,
> > length=3D65535 could be considered a special case. Since it is clear th=
at
> > userspace cannot provide a larger buffer, there is not much point in
> > returning -E2BIG. Instead, the results could be truncated after the las=
t
> > BSS that fit into the buffer and that would be returned to userspace.
> > This is likely going to be much more useful than not being able to
> > receive any result.
>=20
> And here's an example patch on doing that for mac80211 (drivers that do
> not use mac80211 would need to do something similar if they want to
> support this mechanism). Would this change be acceptable for mac80211?

Seems ok to me, since wext limits us to this anyway... But can we rely
on userspace to (a) use the exactly largest buffer size and (b) be able
to interpret that?

johannes

> ---
>  net/mac80211/scan.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> --- wireless-testing.orig/net/mac80211/scan.c	2009-02-05 11:33:37.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/scan.c	2009-02-05 13:07:41.000000000 +0=
200
> @@ -934,6 +934,19 @@ int ieee80211_scan_results(struct ieee80
>  	list_for_each_entry(bss, &local->bss_list, list) {
>  		if (buf + len - current_ev <=3D IW_EV_ADDR_LEN) {
>  			spin_unlock_bh(&local->bss_lock);
> +			if (len =3D=3D 65535) {
> +				/*
> +				 * WEXT uses 16-bit field for the length which
> +				 * means that the largest buffer size that can
> +				 * be used here is 65535 bytes. There is not
> +				 * much help in returning -E2BIG if the user
> +				 * space program cannot use a larger buffer. As
> +				 * a workaround, return as many BSSes as
> +				 * possible instead of making it impossible for
> +				 * the application to get any results.
> +				 */
> +				return current_ev - buf;
> +			}
>  			return -E2BIG;
>  		}
>  		current_ev =3D ieee80211_scan_result(local, info, bss,
> =20

--=-lypXJHwx+aJSe3DM5C86
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJitOYAAoJEKVg1VMiehFYoUYP/AvNMDGQ8ognV1fT6CQMVwbN
1eVhP9ni6wle0XP0UQ3aGP96HaGYKLMH6VK5wazJF6htL+9Pztj39EpFv3xxq/91
UIj7ySEtjh8EFpnsHUf1UAfi9Ez+9sFCZgV6pbRifwP7V2DfoULhksjrmjJW3M/F
0akvaFY1mNZgNq13gcEoql8wD9Hljn95bUeSDI/hc4Kn41d7ijekhph3+eTx0Dk1
L3m7jjW1gDhqcraRNpsZPv+TdkY4rPgbzyVLDR+Kh+/R9MUBtw/NmJA5DBrsvom+
xu6ami4hXcRyZbA10Y1f5DLlJOOQ5ZfnrEMjmsE85/9G1EfTv3GHHPfaeX2Aa506
xF/Yb5dRGHjZXpOMAuzPcJh/nZ8NB9ZYLkZEi9Kxpcwky+j+yCipRbMSR7PGUdHJ
AsToqzLfWFkgLH5M6DJwsZlMd2XlcYxYfF/h/TWcFRb7xuENwC++94/9qPDBfTw0
J0Q/YCLPf1yuwkq9yoNIary/i3W+zpVdNpcQVOpItT8PGPe9gEZkbdAIZMbloHOf
Fr90N+ouqGjzqY97cAWC64YVMxglfgY8M8EDbjW3H4wj2nt+SB/zEWi4tstEQEXw
/q8clGPxB9YspAz0NoErWZnE3UakN3OvtU8ub+lPKP++hVLJ19Se6pnPwTwukyek
f7+ARHeQ1oCyYTprY8mm
=oE/w
-----END PGP SIGNATURE-----

--=-lypXJHwx+aJSe3DM5C86--

