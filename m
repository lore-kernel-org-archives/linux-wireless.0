Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbXHCJxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:53:21 -0400
Subject: Re: mac80211 driver interface semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <46B2E06F.4090706@warmcat.com>
References: <46B27729.5030406@gentoo.org>
	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BdSOP4foVMSzc7YYd6Vw"
Date: Fri, 03 Aug 2007 11:54:54 +0200
Message-Id: <1186134894.4647.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BdSOP4foVMSzc7YYd6Vw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 08:59 +0100, Andy Green wrote:

> There seems to be some agreement that in the future the number of
> virtual interfaces that happen to be lying around shouldn't determine
> the functionality of Monitor mode like that.

I think that only happens if you don't have monitor_during_oper set;
otherwise it's a bug.

I am, however, not entirely sure we should be forwarding packets with
failed CRC on hard monitor interfaces. Because if you have both a hard
monitor and a regular interface (monitor_during_oper allowed) then we
will never check the CRC on frames that enter the networking path and
can get corrupted TCP packets in etc.

johannes

--=-BdSOP4foVMSzc7YYd6Vw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsvtu/ETPhpq3jKURAidnAJ9L5vUSMLA9Zniob04rail9/TZOywCfXUXw
AP9RABal/FCJ4c1c3unSVCU=
=rF8s
-----END PGP SIGNATURE-----

--=-BdSOP4foVMSzc7YYd6Vw--

