Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbYJMWZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:25:18 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Chr <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223934261.26245.4.camel@dv> (sfid-20081013_234428_358947_F23DF3A7)
References: <48EE20FB.4060700@lwfinger.net>  <1223934261.26245.4.camel@dv>
	 (sfid-20081013_234428_358947_F23DF3A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JY/mIQHDVZCBSqzM22FF"
Date: Tue, 14 Oct 2008 00:24:40 +0200
Message-Id: <1223936680.10113.7.camel@johannes.berg> (sfid-20081014_002524_216689_E7A23574)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JY/mIQHDVZCBSqzM22FF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-13 at 17:44 -0400, Pavel Roskin wrote:
> On Thu, 2008-10-09 at 08:19 -0700, Larry Finger wrote:
> > This patch is meant for testing on big-endian hardware. Every indicatio=
n
> > is that the data in the bootrec structure is little endian. This patch =
fixes
> > a usage of the u32 data array as a string of u8's.
>=20
> I'm sorry, I didn't test your patch yet, but I could capture the output
> on the serial console.  It doesn't appear to be related to p54 specific
> data structures.  The driver is initialized correctly.  I can bring the
> interface up.  But once I try scanning, I get a sequence of the
> following messages in the kernel log:
>=20
> Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200

That _is_ the driver's fault, it's not setting the rate index correctly.

johannes

--=-JY/mIQHDVZCBSqzM22FF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI88qkAAoJEKVg1VMiehFYkQIQAJT+KSjWjpHziThX6ie56WPc
c/Lk5RKuTL7YrhRdq58SVL6RqqejNGBuI1/CUW0YKb6jukrBubUvv9FbQUFgfApR
nzQRoMZ5KWAGmeuSDaRLYR9gEogi4a97ncK2T+M1mk4/Vlvq1PMiX6B0xR8BBCx6
9kPdngkU4q1ZXI9AdOqXH9uuzAeJtrQu/k8QHj5+ULwr2onEQBSuJS1VGGn8Fz7t
VqpdTairufkabBwSLhJ2BbiE5NMIusdESyj6H7mdlnVoJbkrQ4XfMR3AUoE8DULv
2jYI6gn0+kupngqWjRHxp3lwt41fCgL6F7QJfS1IlTJyOHKMdrwpuaPwqH7jeP5Q
/Jkb0qLoGY2TEGN5Ap8zoH5vtL9yzajfNsFaWUwT+ZXoTh+iWJ+/zdvFUHHdzCw7
ahrM1dsCYAysNH1D9e4UV9vLMfDAVGGEXBJSG09+OP5Pm4TSIo6mrElIYRWrQu5G
M4TvarugKGZqERLVw/apHyUlxDkvutWYJgZ8f+i9UiAhpWWOOf9XzczUal6AXh30
hkXn1WJiTgXTFEW6v6BwNzsBfbaPA5rsmBV8J5Sza5jdIvFboK9FAZLJ+KGPMSo3
l/N6btsS68URnj2JaGseO4JxemwJrrfCzdxau10tE5OBoTZTVYjGX4jTBkYblsqd
/Ltd9bWHDPo7/MM9Ntdh
=1RxB
-----END PGP SIGNATURE-----

--=-JY/mIQHDVZCBSqzM22FF--

