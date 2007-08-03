Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbXHCJzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:55:35 -0400
Subject: Re: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for  injection
From: Johannes Berg <johannes@sipsolutions.net>
To: warmcat <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070802223857.19090.70108.stgit@localhost>
References: <20070802223857.19090.70108.stgit@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ENMDZu1/9+/t1aBygY8D"
Date: Fri, 03 Aug 2007 11:57:09 +0200
Message-Id: <1186135029.4647.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ENMDZu1/9+/t1aBygY8D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 23:38 +0100, warmcat wrote:
> Block of code at the end of ieee80211_tx_status() seems to exist in order
> to echo tx packets down Monitor mode interfaces with a synthesized
> radiotap preamble describing the outcome of the transmission.
>=20
> The effect it has with injected packets is that two copies of each
> injected packet appears on the soft Monitor mode interface it was injecte=
d
> down, one with a correct radiotap header reflecting what was injected,
> and one with a bogus 0x0b length radiotap header.  This behaviour
> was seen on iwl3945 and rt73usb.
>=20
> This patch adds a new attribute to ieee80211_tx_control's flags field,
> IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO, which is set for injected
> packets.  The code to add a new radiotap header and echo the packet
> down monitor mode interfaces is now conditional on this attribute not
> being set.

Ah. Now I see why this is happening. It's because any packet you send
into the monitor interface from userspace is already redirected back to
userspace by upper levels... Hmm. It *seems* this patch is correct, but
it changes the semantics slightly: previously, you would see transmitted
packets with their transmit indication (whether it was acked etc) and
now you do not get that for injected packets. Could we instead somehow
get the upper layers to not redirect that and fix the radiotap header?


johannes

--=-ENMDZu1/9+/t1aBygY8D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsvv1/ETPhpq3jKURAo5AAKCREkkjFwHJyhjR6Wq518IGRBqx+wCcCDZk
jwbq15wi4LFC/cN9t2CVbtk=
=2n0M
-----END PGP SIGNATURE-----

--=-ENMDZu1/9+/t1aBygY8D--

