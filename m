Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbXC1JMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:36 -0400
Subject: Re: d80211: How does TX flow control work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jiri Benc <jbenc@suse.cz>, Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <45A2A728.1070404@web.de>
References: <459A5945.80909@web.de>
	 <20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>
	 <20070103191853.4f440b8b@griffin.suse.cz> <459BFB05.9040608@web.de>
	 <45A03825.9080807@web.de>  <45A2A728.1070404@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QoR66N9xK0NewvgLHwK3"
Date: Tue, 27 Mar 2007 22:58:50 +0200
Message-Id: <1175029130.5151.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QoR66N9xK0NewvgLHwK3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The actual problem was meanwhile identified: shorewall happened to
> overwrite the queueing discipline of wmaster0 with pfifo_fast. I found
> the magic knob to tell shorewall to no longer do this (at least until I
> want to manage traffic control that way...), but I still wonder if it is
> an acceptable situation. Currently, the user can intentionally or
> accidentally screw up the stack this way.

I don't seem to be able to do that:

# tc qdisc change dev wmaster0 pfifo
RTNETLINK answers: Invalid argument

# tc qdisc replace dev wmaster0 pfifo
RTNETLINK answers: Invalid argument

what exactly does shorewall do?

johannes

--=-QoR66N9xK0NewvgLHwK3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCYWK/ETPhpq3jKURAjrKAJ4/e3T4bHJwmKCfsZ9kxq6z5OvydACfYAH5
s8ETGrMdJRWYLJfNOFHC29s=
=J/q1
-----END PGP SIGNATURE-----

--=-QoR66N9xK0NewvgLHwK3--

