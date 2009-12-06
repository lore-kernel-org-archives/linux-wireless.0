Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647AbZLFK5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 05:57:14 -0500
Subject: Re: WMM classification guideline for applications?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
In-Reply-To: <87d42u6dnd.fsf@purkki.valot.fi>
References: <87d42u6dnd.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tWjO+ww43LtD0ZaTZqD5"
Date: Sun, 06 Dec 2009 11:57:17 +0100
Message-ID: <1260097037.3461.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tWjO+ww43LtD0ZaTZqD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-04 at 16:02 +0200, Kalle Valo wrote:

> Method 3 (IPv4 DSCP field) feels most portable to us, at least most,
> if not all, wifi drivers should use it. And, in theory, the receiver
> should also benefit from the classification, unless ISPs modify it of
> course. But the standardisation for IPv4 QoS bits is a mess and I
> don't really understand where the use of DSCP bits (as used in WMM
> implementations) is specified.=20

http://tools.ietf.org/rfc/rfc2474.txt ?

> Also I was told that root privileges
> are needed to set this and that's somewhat cumbersome from application
> developer's point of view.

I don't see that IP_TOS, which will end up setting IP TOS/DSCP, requires
any elevated privileges:

        case IP_TOS:    /* This sets both TOS and Precedence */
                if (sk->sk_type =3D=3D SOCK_STREAM) {
                        val &=3D ~3;
                        val |=3D inet->tos & 3;=20
                }
                if (inet->tos !=3D val) {
                        inet->tos =3D val;
                        sk->sk_priority =3D rt_tos2priority(val);
                        sk_dst_reset(sk);
                }
                break;

whereas, for instance:

        case IP_IPSEC_POLICY:
        case IP_XFRM_POLICY:
                err =3D -EPERM;
                if (!capable(CAP_NET_ADMIN))
                        break;

In any case, I think this topic would benefit of cross-posting to
netdev :)

johannes

--=-tWjO+ww43LtD0ZaTZqD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG44KAAoJEODzc/N7+Qmar00P/0X0hylY7eKmhQ4A9MUHj0Gb
XljxLjk2XAJ0AirrzaAjxWtXA+IAyKKnvA4jRK6+6+ricdUYOxzzm5yBvwnEZaWo
SVLRQ3AHmBrMvEdKxPINPsUOyx2K0dahtEMeDGeT6VyJK4DOf5mudvI97nArTeao
OZz5/VH5jY1bxNUzhFFhEzwoFzaf+N0TryvKaltFu4RGwy2zSo5d9/CN2+KhNGVO
cr8j56Y+Sk8YqI1WqKbzsMl4VcJuh1IRS/Mg7bscMyZqwVCvfrflr/si/VW7w35f
ceCyIc2eBjgOC7V4qiE3QfEUXGOBXDS3Zns47byX0b+5gKauTS686M6YNtHVUlDF
2GBwHoTfI8hWY5X6xtthPsHMVajXW6Msxbya+2EiG+FYBmAfZOvqSnc86DppWpgj
IcWzOAYmjUWNXBOhY6bPgsFNNR/xsQE9fvFADX/sQx0yVlTYB2CbcsiFxD4tyd5x
VCXjmmTPDpSYJ7IewOeC16Vc7b8B6FZvXoWsJ0BgmDr6tWghrUFVgN9B0AjuvibF
OJAgXxXabaAyKTNMztamdDD+ONf5DNLLMgzRaGJWYU2EQZtP50Twe57HQHFVkaMo
2T+IOKo3uZVvbgDY2Njl+2ZLr2IvjHgH1RJ3C/b535hnvxsZLODrLceZsPbwpZRU
gh1uXXeRsK7gcOGLl5Yv
=1q23
-----END PGP SIGNATURE-----

--=-tWjO+ww43LtD0ZaTZqD5--

