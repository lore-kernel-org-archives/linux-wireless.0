Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbYLLPty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 10:49:54 -0500
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081212123918.723191687@atheros.com>
References: <20081212123832.506588839@atheros.com>
	 <20081212123918.723191687@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jx3+fofIb6Vwv2UQ7wGK"
Date: Fri, 12 Dec 2008 16:49:48 +0100
Message-Id: <1229096988.3600.19.camel@johannes.berg> (sfid-20081212_164958_139726_AD743D2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jx3+fofIb6Vwv2UQ7wGK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 14:38 +0200, Jouni Malinen wrote:

> - *      Tx/Rx data rate
> + *      Tx/Rx data rate.  If bit 0x80 is set then it represents an
> + *      an MCS index and not an IEEE rate.

I really don't like this much because it means that old dissectors will
be confused, and the HT information is at like three different places...

We really should make an HT amendment for radiotap on the radiotap list.
Once that works again. grmbl.

For now I guess we can put this patch into -testing but I'd prefer not
letting it migrate to the official tree, so that we avoid tools starting
to rely on this totally weird information.

johannes

--=-jx3+fofIb6Vwv2UQ7wGK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQogZAAoJEKVg1VMiehFYq+MP/3P6aUNjA0E5lDquhc/DQXro
4rLPl8RvjS5qH0V7AsujMpdKrmNwe0aDFs56xqvu3EG53zhQeb25emaNBzy85Qlb
LZUEP0pK3vu7mNNBVbwvIK/kmXlcbYbiRJIgv6cb5xID1hl+orrKLzekbZPAazTI
l4t2sXM/z//Y96fsORHNasqrOxL/HgKovbB1G7FRYPZhd88eRqM5TdneDnyiSuSb
idmfjv0LZWfXAj6sXINvXOzkLNtDY3diT8uiGKGCQeBtWVF0bNcXJo7fwLBS0GYu
roVQtLDoi1VqQ+hXwTpgDUI/Ww1RZVSXaEXFLkKssqJNEWvJNGOKtlWr74pFh374
aWygimpisQf84tYPzxCFFpa2yKzMpSRmLUw/90bZorYZI3cTKIQgihc6A2uF1l9d
HLbTVFqxCjBsB/BTvHC0fs+VPWcG9cRV8O5fiB529Jrmrb4LDlq/wKhn6IlHbgru
5rZzskjNZHmQcV1z18XA/ld215RNnbUyE305UwsKSfRlCSwR4lOx2VpVcc7OvLya
4HrypRTMCIOTB31A+uFqn/Bdxq95QU0Ku9NrKKXN4EOaPkg+bxhIzVk5oL9uKUNb
EApUehdbGC84c2N95ltdp/cyG5mkhK8864AIWQr11blUEO/Iq5/2bffYlFjWlA1m
JQ2/WJa0YJ9KW8I/P/hL
=t0dp
-----END PGP SIGNATURE-----

--=-jx3+fofIb6Vwv2UQ7wGK--

