Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S944388AbXHMLQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 07:16:49 -0400
Subject: Re: [PATCH] hostapd: work with monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <46C0231F.5040605@warmcat.com>
References: <1186992004.27916.53.camel@johannes.berg>
	 <46C0231F.5040605@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FXcuVD8yWsMKTBX4tgtm"
Date: Mon, 13 Aug 2007 13:19:09 +0200
Message-Id: <1187003949.27916.86.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FXcuVD8yWsMKTBX4tgtm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 10:23 +0100, Andy Green wrote:

> Wow impressive amount of ioctl calls going into the bit bucket there...

I think there's only a single ioctl being killed, but all the stuff from
ieee80211_common.h which is good too. Less crappy userspace interface :)

> I will try to use your direct BPF programming and also dispense with
> libpcap tonight, thanks for that.

There's one gotcha with BPF: the program counter is always increasing so
you can't have loops, and if you say "jump by 1 instruction" then
another one is added too. But if you just copy the post-processing code
you won't have to deal with that :)

If you need any help writing a filter for the MAC address you use as the
special one or something let me know. I'd probably use a 4-byte and a
2-byte word load and compare to constants; just remember that multi-byte
word loads do network/host byte order swapping so you'll have to use the
LE32/LE16 macros for the constants.

This was, incidentally, the reason I didn't use pcap, I couldn't figure
out if it could handle little-endian loads like my first few
instructions do.

johannes

--=-FXcuVD8yWsMKTBX4tgtm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwD4t/ETPhpq3jKURAvJoAJ9aKIm1lqAOADlwCj0k22EpZ7AKtwCbBjY6
HlkgCSCLy9uUXSwBWGF6j2s=
=LW/Z
-----END PGP SIGNATURE-----

--=-FXcuVD8yWsMKTBX4tgtm--

