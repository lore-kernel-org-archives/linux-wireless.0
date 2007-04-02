Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965624AbXDBSQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 14:16:25 -0400
Subject: Re: cfg80211 wext compat w/o wext code changes, rtnl locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <1175536859.25048.6.camel@dv>
References: <1175122815.8807.21.camel@johannes.berg>
	 <200703301211.05261.mb@bu3sch.de>  <1175251051.19085.2.camel@johannes.berg>
	 <1175536859.25048.6.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u3E/pCkdl5wIape0UZK7"
Date: Mon, 02 Apr 2007 20:15:41 +0200
Message-Id: <1175537741.16379.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u3E/pCkdl5wIape0UZK7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 14:00 -0400, Pavel Roskin wrote:

> Just for your information, rtnl_lock() is actually a mutex. Neither
> rtnl_lock() nor any mutex operation are annotated to give sparse any
> idea of what they are doing.

Oh. And I guess rtnl_lock/unlock would need to be annotated and not just
the mutex operations (or are they inlines? I forgot)

> If sparse learns about mutexes, expect it to give a warning.  Please
> consider if the code between rtnl_lock() and rtnl_unlock() could be
> moved to a separate function so that locking and unlocking would happen
> in the same basic block.

Yeah. The patch is probably not complete anyway. I just floated it to
get some comments...

johannes

--=-u3E/pCkdl5wIape0UZK7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGEUhN/ETPhpq3jKURAqIvAKCgbcZEUxItTjqnCadmsiG5fiYulwCgj5PM
ydVBHz0bcfkiQm0iNpVleMc=
=XFYb
-----END PGP SIGNATURE-----

--=-u3E/pCkdl5wIape0UZK7--

