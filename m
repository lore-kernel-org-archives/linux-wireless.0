Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXI2NL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 09:11:58 -0400
Subject: Re: iwlwifi scan question
From: Johannes Berg <johannes@sipsolutions.net>
To: Ian Schram <ischram@telenet.be>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46FE4E50.2010300@telenet.be>
References: <1190815228.4204.9.camel@johannes.berg>
	 <46FE4E50.2010300@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QqaDmZb6DqbzNo5kkr7e"
Date: Sat, 29 Sep 2007 15:13:16 +0200
Message-Id: <1191071596.22960.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QqaDmZb6DqbzNo5kkr7e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-29 at 15:08 +0200, Ian Schram wrote:

> I couldn't follow all the rest of this thread but i think the patch below
> is what you were initially after.

Not in this thread really, I was just curious here because I was
thinking of disentangling the scan and sta state machines.

> I'll also send this patch to ipw3945-devel mailinglist, so it can take th=
e
> same route as my other patches.

If it works you only need to fix the whitespace issue:

+       memcpy(priv->mac_addr,conf->mac_addr, ETH_ALEN);
                              ^ missing space

and sign it off and that might address one of the points I pointed out.
However, when the interface is removed again you should also clear the
MAC address in the hardware or set the hardware to monitor mode so it no
longer acknowledges packets when in pure monitor mode.

Also, a full filter flags implementation would be good.

johannes

--=-QqaDmZb6DqbzNo5kkr7e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv5Pa6Vg1VMiehFYAQIJkQ//XlzhLc9tWRj98h02Z61jHgjIkd4B6OT1
vyhotsVZ7N73rI+IIPbYJDWohIQcjkj8bNknbXBbeU5wPj3cvpCkB8xEGrT5l4A/
P9s2Oyl3Of71E5eqXxonK56yq79a2HPPRcCueu0QQywCqPSU/WpY/BAM4kn4jNZd
yw9cpUM2e/djjNxgwmr4hds5UIDO7k+VyJ/+9/u5e1PuBi/7HvKYFYnXaom40+Xp
KMoEDtDD58V7YCGapS7jrV5KmcEcf/g9dFl3IE2Bv+fMcVpoO5KSs8kP+fqrEJMr
Q9BkVqe92XkxuobxNRBgobSoTO1wzZEJiX78xHbLRvQqnPFFIwVAH19E6VyAIJvE
NgkfQ2x5QTGn/PojYg+vwLp14DTF7S+WCzdDazmAMUSVChctz3MBRvUjUWCN/21V
ewJ+BF+TWRqhcmiW3N+V7LObVh/e5AdrfktphdEoH2B6t7DXIbrriuHNQmvlZPEE
nK7QmdvlJD5uwAzHh+2AlNi38VQjrW40+fefGDKBk3HhaW0EJX4u/LECnshhi4N0
xtGSpfvp7/l6i52BhQZ+1AMKZE/HvDxssMphrGmDOEdlrRGlYkVSQfB2702C1OP8
QpSAwW9jcEeMehWk1zdMB5BPZHmiZ3XojMpExdHhDmzzaFAC5Jab63XDipTFZPAK
lZYfqzgGw9k=
=tnKu
-----END PGP SIGNATURE-----

--=-QqaDmZb6DqbzNo5kkr7e--

