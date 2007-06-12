Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXFLJTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 05:19:14 -0400
Subject: Re: [RFC] {cfg,nl}80211 API
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070611230434.GA13221@charon.n2.diac24.net>
References: <20070611230434.GA13221@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jFfve0Qc9pARRrr2lR1h"
Date: Tue, 12 Jun 2007 11:15:07 +0200
Message-Id: <1181639707.29767.57.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jFfve0Qc9pARRrr2lR1h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi David,

Great stuff!

>   - getting virtual interfaces works via ifindex, which needs to be known=
..
>     - no dumping (would have locking issues with userspace MLME)
>     - use list of vifs from GET_WIPHY
>     - only thing it currently should return is vif type. essid & stuff
>       should be retrievable via GET_ASSOCIATION, which won't be valid for
>       monitor interfaces

Hmm, in fact, if we go that route then we can do dumping for vifs (by
wiphy I guess) since all this information is available in the kernel,
only GET_ASSOCIATION should need a callout. vif type can be dumped just
fine.

> So, what's left?
> - more PHY config stuff?
>   - TX power? Should be able to configure a lower value...

Yeah, but as we said, this really needs to tie in with any regulatory
stuff.

>   - antenna selection?

Sounds reasonable, needs automatic/... but for .11n it might need some
more things. Not sure.

johannes

--=-jFfve0Qc9pARRrr2lR1h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbmQb/ETPhpq3jKURAhWhAKCrjZw/LzEss5eLlsnuXqGR+lyS3ACfRFWF
pLXnFRbm11OxTdmH7R9PPbY=
=MjLo
-----END PGP SIGNATURE-----

--=-jFfve0Qc9pARRrr2lR1h--

