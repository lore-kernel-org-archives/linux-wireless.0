Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbYAKLi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:38:27 -0500
Subject: Re: [PATCH 06/12] rt2x00: Put 802.11 data on 4 byte boundary
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200801062340.27509.IvDoorn@gmail.com> (sfid-20080106_224252_417933_91E2D3B0)
References: <200801062337.35904.IvDoorn@gmail.com>
	 <200801062340.27509.IvDoorn@gmail.com>
	 (sfid-20080106_224252_417933_91E2D3B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NbZArqq6VfpoBXTexRfG"
Date: Fri, 11 Jan 2008 01:32:10 +0100
Message-Id: <1200011531.3861.118.camel@johannes.berg> (sfid-20080111_113829_928399_1CCFA127)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NbZArqq6VfpoBXTexRfG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Sorry I'm late in noticing this :\

> +		/*
> +		 * The data behind the ieee80211 header must be
> +		 * aligned on a 4 byte boundary.
> +		 */
> +		align =3D NET_IP_ALIGN + (2 * (header_size % 4 =3D=3D 0));

I don't think you should be using NET_IP_ALIGN at all, I think the code
should be just

		align =3D header_size % 4;

(which will evaluate to two or four).

See, NET_IP_ALIGN is 2 because ethernet headers are 14 bytes long, and 2
plus 14 gives 16 which is divisible by four.

I have, so far, in mac80211 forced you to align the 802.11 data payload
to a four-byte boundary *even on powerpc* which is the only platform
where NET_IP_ALIGN is not two (it is zero because DMA sucks when done to
unaligned addresses on some powerpc machines).

We are, however, not concerned with ethernet frames here at all! Hence,
NET_IP_ALIGN is pretty much useless because it's designed for the
ethernet case.

I think Broadcom hardware really represents the ideal case here: The sum
of the lengths of all headers including hardware/firmware receive
header, plcp information and 802.11 header is always a multiple of four,
if necessary the hardware/firmware header is padded (by two bytes) to
achieve this. This means we can always do "perfect" DMA right to the
beginning of the buffer and always get the right IP header alignment.

Once you deviate from that ideal case, performance suffers. Either
because you need to move around data or because you have to do unaligned
loads. The latter I have currently disallowed in mac80211 (via that
WARN_ON_ONCE) because most drivers got it wrong and hence won't function
on machines that require or force alignment.

In any case, NET_IP_ALIGN is really designed for ethernet and DMA. Since
we're not doing ethernet, it's not important. Since you're not doing DMA
here, it's even less important. If it becomes possible for you to do
DMA, you should probably do it right into the start of a buffer and
memmove() the data a bit when necessary to achieve 4-byte alignment.

Once you have done that, we can talk about possibly relaxing the
WARN_ON_ONCE() in mac80211 a bit so you don't have to memmove() the data
on machines where unaligned loads are possible. Then we can investigate
which hurts performance more, but I guess it'll be machine-dependent (I
would guess that enough cache means a memmove is fast or at least
amortized later when we load the data anyway, unaligned loads on the
other hand hurt every time the IP stack needs a field)

Now, I can see one case where you could again use NET_IP_ALIGN, but it
has a bunch of preconditions:
 - you do DMA right into the skb
 - you have a RX header that is divisible by four
 - you decide that QoS frames are going to be more common than non-QoS

Initially, these conditions mean that you'd ask the machine to do DMA
into the start of the skb + 2, because you want to have the IP data
aligned properly in the QoS case. Then, however, you should use
NET_IP_ALIGN instead of the two and not do any memmove at all. But
seeing that's only relevant for some powerpc machines and wireless
hardware isn't fast enough yet to matter, I don't think it makes a
difference.

We should, however, reach out to vendors and ask them to do the required
padding in firmware/hardware.

This leads me to an interesting question for A-MSDU packets, but I'll
write another mail about that.

johannes

--=-NbZArqq6VfpoBXTexRfG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4a5CaVg1VMiehFYAQLJPxAAgJKlYJrfE22Ne/5rwAnqXniMWBgP6Apg
FZ2n/LdPB+Yk/T60v16vo4kwZg0aQywQ6FEn385U2mJNnsugJvYH+mNQqrKYl3vo
1+UbRmo0jPvx+sXktuyj8wx/2jaKJEertJJhrWOz1V42oMpLURIfbhxj1zk+z200
/ykbYkOf/FBxHiYw/X8kk1MgrCfP7V7ct1C1IeJ5TcAx3tccW2Zu0xKhmXWD7Avx
8Q2QWnvEHU96MbILhSiU8lHMlUP1fk5iVacQEsVPqw5E1h9uAyze2W2p6VxNqwZY
X5FoWwTsjwVLKtp17mNJxzxoV0rqeGL03hAdwSFD4g8ViZKD+p/r9eYuNVrWVDFy
FLlOlSBCEaVPdwbxprORfwYyEy2y1zKblyQjWyJFqlvdFPQprg3rkvknjhOIfGTE
eundpQk2FZxEe493DqGDpHD16G20P5CDKTUW3Q47c7aA4TdLmpErK28P23b06MDG
rHa5o0c399bvBjBDJ/K/lRdj3pfluGvzjeCovYDclzZtIfMSSqN7Q9JzcFpIyEtE
77SL420l1xzG4YyQP+0lzJgBX06O7g4oD5mKpCHYnitxq9aRiLL8JNDIkd0lkG8w
/gJTasyTpmGSr+D9jI50NnJHgIes0UM8fqpFmj4tcEbemL1z6FE+ktMp/4RSYQtE
HCfWg4Zpo9o=
=MWNb
-----END PGP SIGNATURE-----

--=-NbZArqq6VfpoBXTexRfG--

