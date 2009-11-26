Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364AbZKZKGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 05:06:15 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xlIDSvcWDc0k0uWZmzDA"
Date: Thu, 26 Nov 2009 11:05:43 +0100
Message-ID: <1259229943.32372.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xlIDSvcWDc0k0uWZmzDA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 14:03 +0800, Zhu Yi wrote:

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1593,6 +1593,18 @@ int ieee80211_data_from_8023(struct sk_buff *skb, =
u8 *addr,
>  			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
> =20
>  /**
> + * ieee80211_asmdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
> + *
> + * @skb: The input IEEE 802.11n A-MSDU frame.
> + * @list: The output list of 802.3 frames. It must be allocated and
> + *      initialized by by the caller.
> + * @addr: The device MAC address.
> + * @iftype: The device interface type.
> + */
> +int ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *l=
ist,
> +                             u8 *addr, enum nl80211_iftype iftype);

Oh one more thing, can you make addr const?

Also -- you lost the extra TX headroom which I think mac80211 as an AP
requires since it could forward these frames? Or does that not happen?
Not sure right now why that was there to start with.

johannes

--=-xlIDSvcWDc0k0uWZmzDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDlLyAAoJEODzc/N7+QmaKc0P/Ag3BqOQhVicbx+G/nqyoAxo
pxKy36D5mMf6u/JQnQnjE7hDo8sDhCQuauZtO94nTbSqHCHbgwgOS6gNbpbcVxS1
vsUbLGLwScA6Xgpj+c8phCpnIhdkGqiuP+f0m67tJl4nkWjDwngAiyvSWlbeIIJ3
f10nGekQrmXTwsCEbpMYj4/9o5Ic73stnxZUeZJ6brNB/UFcPKMOn/3zMkHwoONJ
C3BScUDmQ0CKPqPSd4+iorIIvQ4mn7/+WUetkYaL0CjupbdLeqVah9n1OSu2EcIj
K7wH12ZEYyh1pi8qe+JmwnhTf76a9L99n97XfMVyYxmhHxgN3lT8I00HKy7adm13
+L+ofMqWaoLfZKOexFjGwNyaaUx2jCgjQmwn4FgFDkUwHbta3eYvsmhvdCdmRWGP
2zbORO0S/DONpW1VoEwNA6H7Oti1IzlJeKWHLDDZTQ1NJMYOCP5GnIaNpf4eXYq0
9fza5rxP5ylNLXDlTIuqacz9jDjC+nhkxVr2sB6ZvUz9NydNaxkP3YboAvfOO9KA
D8cjbdaw6OOWTx1kOHlTn0er5o4pb3kEoD7KC8wLl1YBUC/JKWmye/u8Cjpe3VEJ
1aXa1PISarie9sCOSwQZ7ad/3L8d7HlmisrT55RFf/WcBeIJixzI6Ifpj+l4mynn
ZXhjfh+pxQ+WvqmYtE6E
=UwAG
-----END PGP SIGNATURE-----

--=-xlIDSvcWDc0k0uWZmzDA--

