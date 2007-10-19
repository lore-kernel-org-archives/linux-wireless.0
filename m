Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbXJSNtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 09:49:21 -0400
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1192726084.15285.31.camel@johannes.berg> (sfid-20071018_190135_069914_4249F969)
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
	 <1192726084.15285.31.camel@johannes.berg>
	 (sfid-20071018_190135_069914_4249F969)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fzZJUWKmsPwHNyhCozBf"
Date: Fri, 19 Oct 2007 14:20:08 +0200
Message-Id: <1192796408.4167.3.camel@johannes.berg> (sfid-20071019_144927_252559_3867C2FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fzZJUWKmsPwHNyhCozBf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-18 at 18:48 +0200, Johannes Berg wrote:

> Hmm. And here's a thought: don't we need all this information within
> mac80211 as well? Would it maybe make sense to embed it into the sta
> sdata structure and have the 'changed_map' not be in the structure but
> as a second parameter to the callback function? Then we could always use
> a pointer to the embedded structure that keeps track of this information
> and build the changed value dynamically. This saves having to initialise
> the structure all the time when calling the function and makes sure that
> even the unchanged parameters are always valid should the driver need
> them. [also see at the very end of this mail]

Re-reading my own mail :)

Don't we need an if_id parameter to the callback so if the driver
supports multiple virtual STA interfaces it can make an effort to
support the settings of both BSSes? I'd be tempted to do it in mac80211
but I guess that different MAC designs have different levels of
configurability when multiple addresses are programmed so it seems the
only sane place to do it would be the driver since mac80211 cannot know
which settings are only supported once and where different settings can
be supported by the MAC.

johannes

--=-fzZJUWKmsPwHNyhCozBf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxig96Vg1VMiehFYAQK3Yg//Uu3w72WiuiI++vaDKqi9sX5DJO42UphJ
YbQ5Scb0ZuJb5Lza5EbObWGYwBE2rq9IQIMUOoL4SCbOJ5XzPU/jupm6qUc4MCma
QubUc4HSAodu56MBgtIttxqQIFhJg3HpBYykjOMU+1dCLiHIyU4yBLlC9G8giaod
7LhEAoH5p2nMM6mk5HSloUzyD9RrLobJ4i0KMTfVmYuI0KCHrtD+UrT5Esl+xQey
HwYZvD0GeS1r2UgJwT5qfVW+W3zDBwUGPzEMBlf65uT+dcMkKa1VBzbbYOvE+wQh
KWNJX2gWiFLBkCUJ5AZabWNC7faEw6lPsLXox1hzi4PRLVKZQsq4Pw8k0uOOQa2x
R6Ys7fuTcvyetFHxhKkTidt09Gww2vMp7N7k3iyhe1v8T8uhGj6dShX6xACLWM6q
pzqi3kqO81wYgADZC/WGMlbAIaZqJDhW4h7vZQGw8oYxmviHgaSocHOF6VEkcMHf
Frn+yCu9BDoU4EyEdHHjvvyiagMaSLbL9dtPiUqMtuV0j/uP9ZXRniuMm3Ozwizg
AthAoirOlh+CrhiVt8oVUTgpDeSUWLWpxnVGlq//yHBtZEFFe6JnDNCGll5Qt+cy
KgpXcfB+31QI3c57qgg6FPSihWF99iLx9spfTP/4/SXsuj0nfvjYF+xCXJDR0MVN
AUA/Oe6dLHQ=
=zceR
-----END PGP SIGNATURE-----

--=-fzZJUWKmsPwHNyhCozBf--

