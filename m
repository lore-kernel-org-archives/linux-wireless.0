Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYBVQBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:01:48 -0500
Subject: Re: [PATCH 03/13 v2] o11s: various definitions and support
	functions for mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be772d.17bc720a.0288.ffffcbbc@mx.google.com> (sfid-20080222_071812_193400_EB1E9FF8)
References: <47be772d.17bc720a.0288.ffffcbbc@mx.google.com>
	 (sfid-20080222_071812_193400_EB1E9FF8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QwangNzYz0gWJZrGLoWu"
Date: Fri, 22 Feb 2008 17:01:23 +0100
Message-Id: <1203696083.7082.54.camel@johannes.berg> (sfid-20080222_160240_531562_3CDEA485)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QwangNzYz0gWJZrGLoWu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +#ifdef CONFIG_MAC80211_MESH
> +#include "mesh.h"
> +#endif

No need to protect includes, please don't.

> +	case IEEE80211_IF_TYPE_MESH_POINT:
> +		sta_info_flush(local, dev);
> +		/* fall through */

This is actually necessary generally, not just for mesh. If my recent
sta info stuff goes in first then that will already be there, otherwise
I'll rebase and remove this again.


Rest looks fine.

johannes

--=-QwangNzYz0gWJZrGLoWu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77x0qVg1VMiehFYAQL1Ow/+Njqf9kXb/gIWP31OpxXS4GwIyATjP3dO
8ZPHS+dLq//FRTZGHE3bbsnLgm87CMwEMk9K2l/pZaEHCW7a38eXLEDePSrH/r1/
MQIDEA8/7r+Xw/ZhM6lPf7cMCejT/iL7zboIqPdIw5n9zkKKzbXwW6KQ3EKG0PzZ
apkJ8ygfBtBTnPA4xyry4eSNnfwaTV/zmk1GHC8/rwUV3XaMjrO3HK7jBlHLtlKb
0GZhYaUFQSetSGGsAXgfSp53qODflgEAq/tZI6I0/1zVo/Q5KUo9JK6Rox/HiylY
igwReM3HHk1PyP6xwE5pCu5WZBjOazZlOG4i90JOXZ/qERKIJ47KxXRe6WQdyQ7R
cz/aLm0VD/CAL2llIsvim4W/khLKYszCBqL4JjvcZaKEgyjkwamXftmTs6HN/32J
hti3OzIZwpaN1D8ua7438ChOCJ/6GlNTcWtDrQ9Ajkh1hR3IQWgqLUxylvIvwK0l
Lz9Mor4ovQeS6bDCumKReTA8pRnOVYcJbtjmDYsTrWE2Zu6vh5stfKHwbPUPwYU0
1QcVim986If6EBGn9psY47jo+llz00sC26Yu2M24PeEEZU/1ko4cD1jsP6BuV967
xPYwlgklEStGXlpSBAzkCwU93utEfblCytWuaf1JpBXT5cRsDThwaybYmTFAxxn0
Xpqjy8ueEi0=
=EWWD
-----END PGP SIGNATURE-----

--=-QwangNzYz0gWJZrGLoWu--

