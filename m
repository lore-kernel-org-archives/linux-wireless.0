Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXBESdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 13:33:23 -0500
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070205192958.0fef1a88@griffin.suse.cz>
References: <20070131013717.GA28076@tuxdriver.com>
	 <200702051245.35452.flamingice@sourmilk.net>
	 <1170697795.3572.32.camel@johannes.berg>
	 <200702051314.21627.flamingice@sourmilk.net>
	 <1170699268.3572.39.camel@johannes.berg>
	 <20070205192958.0fef1a88@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l04yzG9LThEHcvIRhQOR"
Date: Mon, 05 Feb 2007 19:29:49 +0100
Message-Id: <1170700190.3572.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l04yzG9LThEHcvIRhQOR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-05 at 19:29 +0100, Jiri Benc wrote:

> No. It's the other way around, when they're reported immediately, they
> will be out of order. ieee80211_tx_status is called from the interrupt
> handler as the result of the frame being actually sent. Before that, a
> frame can sit for an arbitrary long time in the hw queue or not sent at
> all. Reporting only frames confirmed by ieee80211_tx_status as
> successfully sent at the time the function is called reflects better
> what is on the air (it's still not perfect as things like
> retransmissions are not caught).

Yeah, you're right. Then again, it doesn't matter all that much since if
you want exact timing you need a card that never transmits in monitor
mode anyway.

johannes

--=-l04yzG9LThEHcvIRhQOR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFx3ed/ETPhpq3jKURAnewAJ41aXBAEIcfaJaFLyMns1ITOrarCwCgkZtE
mqFfxZ5yJqanb4xWZEiOEMM=
=WH3/
-----END PGP SIGNATURE-----

--=-l04yzG9LThEHcvIRhQOR--

