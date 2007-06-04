Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXFDLoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 07:44:13 -0400
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial  rate in rc80211_simple
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YThe+QWS2EB/3f6dpOFj"
Date: Mon, 04 Jun 2007 13:44:32 +0200
Message-Id: <1180957473.11026.70.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YThe+QWS2EB/3f6dpOFj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-02 at 13:51 -0500, Larry Finger wrote:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. This is too fast for the bcm43xx-mac80211
> driver. To correct this situation without affecting any other driver,
> an initial_rate parameter is added to the rc80211_simple module. This
> parameter is set to 10 times the desired initial rate. If the parameter
> is zero or not set, the original behavior is kept. If the parameter
> does not match a valid rate, the first rate in the table will be set.

I think I'd like to see your "start at 1M" patch merged rather than this
new API. If rc80211_simple migrates quickly enough then it'll migrate to
54M quickly without causing much performance loss, if not we need a
better rate control algorithm anyway.

johannes

--=-YThe+QWS2EB/3f6dpOFj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGY/sg/ETPhpq3jKURAktFAKCGhdgJfqhpo4cYTneBFhL/SGn8JwCggXNJ
CWddd7YwTWI7ao/b6rIB0xg=
=LTNa
-----END PGP SIGNATURE-----

--=-YThe+QWS2EB/3f6dpOFj--

