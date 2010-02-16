Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0BPJ6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 04:58:43 -0500
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 been decrypted
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O54bClQb/LaOseSfGCU/"
Date: Tue, 16 Feb 2010 10:58:41 +0100
Message-ID: <1266314321.4543.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O54bClQb/LaOseSfGCU/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:37 +0100, Benoit Papillault wrote:
> Fix for the following issue : a STA connected to a WPA2 AP was showing
> frames from others STA in tcpdump on wlan0 (promiscuous mode). In
> fact,
> those frames are not decrypted and appears as 802.3 junk. This patch
> just drops any protected data frames that have not been decrypted.

Those frames are only passed up when you set IFF_PROMISC on the
interface, so that's not really a bug, in a sense you wanted to see
them. Now, they may not actually be useful to you, and I'd argue that
checking IFF_PROMISC has no place in mac80211, but it's not really a
bug.

johannes

--=-O54bClQb/LaOseSfGCU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLemxLAAoJEODzc/N7+QmaftYP/19gQF4ZLBaHlz5BBH/SgfGf
TisAXTpcQiiNfkFZA+t0uFYN8sUM61sQwtMfa2/I91YcVPODSIGPLsEE6KOEZZda
b4YwE4s4LGVJBHC5MoClUFToWc1oZe68oWjeKxkk+pDKtuqU+uC/EIQZF99vXO8J
VGJ4Gi+HqdUvhVRUjZj3OO903KVtPqQ77MXU1pB+t1CKD5a+6z/aqN+LKelnyu2t
+4nVw/vpklQ/mzopi1H/iZzSk93RPbWn6hyT7t2wChyYEx0OnqMveBW2OFLYFV2F
x7Umc4zqpSOhb/vdDoWzEXAGeAvn2zF+L7GYyu1nIBMhyGvnv2QqIwYAjEClUs2q
mpe3jJzLHwU9rT4+/QDaxBMIOpReVvetxl1qoJTJyDTJPS1LpYBstsDJu9Ezjosg
1WMn0hyVRbirl4R1oDaUW8ejOCW/W7nKBz6pTf6Io8iM2RGtW2f6AbLPRJniYrYw
jP2bE4cq17GAcAAek+6qjGPjk/gvKyoCFgPFK3QsABzNlCDW4AbVFnLfKxvKKLdU
HJBnvDnraeZylOL1jyie5/7qThd746Pac41C5TWadGT1ZXhSBX55W/MeD/KzjyFR
G7rXLu1XzRR+aFn6mWd9ElyNeA8D5RHBMpmVo/oMPz2liueRtCBAzZ0deIwUAvPB
G5NPc6vvqGqipicLDLyt
=fAFx
-----END PGP SIGNATURE-----

--=-O54bClQb/LaOseSfGCU/--

