Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60471 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXF0OVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 10:21:20 -0400
Subject: Re: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1182953184.4769.24.camel@johannes.berg>
References: <1182848382.3830.5.camel@johannes.berg>
	 <200706261617.45713.mb@bu3sch.de> <1182937106.4769.10.camel@johannes.berg>
	 <200706271448.58087.mb@bu3sch.de>  <1182953184.4769.24.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9VrCKV9xhhQW2TyhrLOw"
Date: Wed, 27 Jun 2007 16:21:30 +0200
Message-Id: <1182954090.4769.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9VrCKV9xhhQW2TyhrLOw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 16:06 +0200, Johannes Berg wrote:

> I'm not convinced this is the same thing, the deadlock here is simply
> that something running on the workqueue is trying to rtnl_lock() while
> flushing the workqueue is done under rtnl.

Looking again, Michael agrees that this is not the same deadlock he's
talking about, so back to the drawing board.

I shall be trying to add lockdep support for this sort of thing, but
until then how can we fix this? What exactly does the rtnl protect in
ieee80211_sta_config_auth?

johannes

--=-9VrCKV9xhhQW2TyhrLOw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgnJq/ETPhpq3jKURAv7EAJ4u9ywb5UfL1PLzdCQ+4oMbkLRzPACfRJjg
wfvjZizViS6YDZz5YDnf5x0=
=mel6
-----END PGP SIGNATURE-----

--=-9VrCKV9xhhQW2TyhrLOw--

