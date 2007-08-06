Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbXHGJlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:41:01 -0400
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with  assoc work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708031250.51161.mb@bu3sch.de>
References: <200708011253.06569.mb@bu3sch.de>
	 <1186092127.4647.10.camel@johannes.berg>  <200708031250.51161.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HD5s5Vr62i/cfJCN0z1S"
Date: Mon, 06 Aug 2007 16:23:50 +0200
Message-Id: <1186410230.28655.75.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HD5s5Vr62i/cfJCN0z1S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 12:50 +0200, Michael Buesch wrote:

> Ah, Ok. I didn't see that rtnl is locked there, too.
> cancel_delayed_work_sync could probably work. Care to test that?

It's harder than thought, runs into the next use of flush_scheduled_work
under rtnl. I think the only solution is to go with your patch and then
add an own single-threaded workqueue to softmac again and use that
everywhere instead of the global one; at least that way the rtnl doesn't
get into the way.

johannes

--=-HD5s5Vr62i/cfJCN0z1S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGty72/ETPhpq3jKURAkI+AJoCMDp0/g8193DGMTk3UgikzdayDgCfQO5U
sADxQ/UTI6CcLBRGycRYl9M=
=Ibvr
-----END PGP SIGNATURE-----

--=-HD5s5Vr62i/cfJCN0z1S--

