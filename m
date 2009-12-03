Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbZLCJUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 04:20:45 -0500
Subject: Re: [PATCH] lib80211: make crypt modules configurable by user
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1259793506.2107.57.camel@MacRitz2>
References: <1259711174.13720.17.camel@MacRitz2>
	 <1259711943.32171.134.camel@johannes.local>
	 <1259793506.2107.57.camel@MacRitz2>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uheliAjZ3SeS4eUs7DdR"
Date: Thu, 03 Dec 2009 10:20:13 +0100
Message-ID: <1259832013.12843.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uheliAjZ3SeS4eUs7DdR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,


Please do me a favour and explain _why_ you want to change anything
before you do. I'm not really interested in pointless chit-chat about
lib80211 kconfig.

> ok. but looking at it again, there are some minor problems that have
> nothing to do with out-of-tree-drivers:
> - it's possible for the user to compile-in lib80211, but not the crypt
>   modules

Yes, the correct solution to that inconsistency is to remove the
lib80211 config symbol from the user's view... then it'll always be the
same the driver is ...

> - the crypt modules depend on crypto API and modules, but it's the WLAN
>   drivers that select them. duplicated selects for each driver.

Yes, well ...

> so how about the following?

The following patch (snipped) was clearly not tested at all. I'll leave
it to you to figure out why it's completely and utterly broken, but I'll
give you a hint: it has something to do with "select".

Please come back when only you have a problem to solve.

johannes

--=-uheliAjZ3SeS4eUs7DdR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLF4LJAAoJEODzc/N7+Qma9KUQAL/5jIWaf0hpXSRBxhIrqO8x
UaXg9b/s7ljBObML/qwSWofoQ3locYdrp+phiRFtZYOcZ+ntRTvm9mY0dMKCaJD0
5aEmjy4n3CrLV27iEDWIhKISkP/JNOFTvW0M64a5qCCf/EeY+pVqsnAuE2CZ8Kby
zMHhj0nG4QYi06dRoxawJ22JX2mZC4KQKWBK2nmk+GXN539pkAfXmklxQuzNv8Yk
fqf+8YcAkCfOOQcprEzu8qoWMucGB2qwyfPSeEA/YB0NDKpUbyJt4eRUU1/CZqFb
RWYH7n+wE5qCzRdsjwsKaLfTrHGVuSYZFZ+cAaA32U3ANCMgJDphuXnh6F1AeFF+
hWx2hHzHXfP0lXf8UtTVtjVFLeYC/LAvLQ6lzISLnMgumzecOoVWJePmFfbsCMK+
EruXxw6xBiO/qfMkmnPprra2mhJRtkAQRcIInDIWL6fcMKnoz8i8nsysvzGcQX/N
t5+8vzZCNosrKxeHZ51rK/z/fbAXmmohtMtaK63zYMRzRwzXUw6r17a5xYrnJR3c
4+xuVdTs0jlrccSyGviyGqsmO8XULM/7TIgQtUYQdwWUTA6E1tFxIl+nK/UrihAf
gnabDQ/2R8wWFm1BwYBpT+R10ClnzU80oh1DEF5Mwn54d30TXm5zPv7uxI3GZxrA
xYmkDvVCu9xVjRLEmjz2
=3UZU
-----END PGP SIGNATURE-----

--=-uheliAjZ3SeS4eUs7DdR--

