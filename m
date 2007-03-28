Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934252AbXC1LML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 07:12:11 -0400
Subject: Re: rx racing against removing interfaces?
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200703281259.55764.mb@bu3sch.de>
References: <1174950322.25887.59.camel@johannes.berg>
	 <200703281252.23834.mb@bu3sch.de>  <200703281259.55764.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZkTnLS+WzetCk0LS2tp0"
Date: Wed, 28 Mar 2007 13:07:34 +0200
Message-Id: <1175080054.5151.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZkTnLS+WzetCk0LS2tp0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 12:59 +0200, Michael Buesch wrote:

> Oh, you mean virtual interfaces.. yeah, there's probably a race. I don't
> know the locking there.

Yes, I mean virtual interfaces, when the thing is in progress while we
iterate through.

> But my comment about the non-irqsafe-variants-should-be-hidden still appl=
ies :)

I'll reread it ;)

But I'm not sure I fully agree. If the driver calls __ieee80211_rx in
softirq context that should be good without requiring to reschedule in
mac80211.

johannes

--=-ZkTnLS+WzetCk0LS2tp0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCkx2/ETPhpq3jKURAnDGAKCMOFzsNtnt8dl8Z9bqta2kI46HNgCgpaOl
uOtDmPZcrlHFd+UKyhbw6jQ=
=VHao
-----END PGP SIGNATURE-----

--=-ZkTnLS+WzetCk0LS2tp0--

