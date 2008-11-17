Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYKQSAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 13:00:38 -0500
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com> (sfid-20081117_183407_351560_69CFD700)
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 <1226942887.3902.30.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 (sfid-20081117_183407_351560_69CFD700)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B/n87sGdBrV4yuPhRbjH"
Date: Mon, 17 Nov 2008 18:59:59 +0100
Message-Id: <1226944799.3902.52.camel@johannes.berg> (sfid-20081117_190041_931182_EF281943)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B/n87sGdBrV4yuPhRbjH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 19:34 +0200, Tomas Winkler wrote:

> There actually complains about slow reconnection,=20

Ok I guess then I haven't seen them for some reason.

Either way, here's a quick summary:
 * locking issues with the callback are fixed by removing it
 * callback is incorrect when you're only suspended for a very short
   time
 * callback is incorrect when you're in non-STA modes
 * suspend/resume cannot be implemented well through this callback, at
   least not the way it is written now and needs to do a whole lot more
 * there's no "slow" issue when you actually resume in a different
   location where the AP is not around any more
 * there should be no "slow" issue when the AP properly deauthenticates
   when receiving data frames

This was an RFC. I'm convinced it should go in, but I don't make those
decisions anyway. I've outlined my reasons for it.

> Second we used the
> same mechanism to
> recover from rfkill which wasn't submitted. rfkill needs also mac80211
> treatment.

Sure does, and I've even described how I'd do it in some email. Seems
nobody actually cares enough though to invest the day or two it would
take to write it. And I don't care about killswitches at all,
fortunately, so I don't need to touch that mess.

johannes

--=-B/n87sGdBrV4yuPhRbjH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIbEcAAoJEKVg1VMiehFYGQAP/31vwYIY7+K4kb/UCxMKrWif
CmtmMuMzNg1ccGwmEbjsk261zsjACGzY0Sd4fIc7XdWBfFcjCoWCfSxJwu6f78/L
S2V5KFmNXtqjjpu+T/EW2AHvJ2RRQ0BMpC1yqp7VppauERqLvmcG5ukykhebJwnp
WNyY1X2nJHEOUQPJ9o2pYNmDez3gQ8ayaC9iog8Jyki45uFlhR2D8WKAqOZewuVl
X+r/uKUmVd0vZcNw9MCE7d4XARlqRCWlCY8XylS4pGmOzufG+URNNPr+oxF6qds9
Fapy/I0rUxtmHKksezdkwvKRs7GhWGUDKPZ4F8QzommI9LGT3K6T9+sPqHuFlCXx
9W72DWP6d+8PqlWJWSE8+vgCdkrLbm+cEnTyaqI9XZvY3nQjAVOnbs12Kc2Q0DvY
mKXN37LNxUF6eBnvC1hQz6kR7qg3FJ4FsSVAlq/UsAdQJK6BsuNSxppz5sR/cnG3
gmKhf7kiMl81Alm8u6y6HXgsn+BiWu0qETP8NUVkmnBZBgxnezv7bSAmAMH+wf+G
/3nxgFiFhzxzB8gSP33Ut1sXGVQZcEOvRqMPCRCYunfZR13KzOyEyXjN8ELT6V/r
2Mz52xZ8po1uh4A0y2en9XbsbL0HfKnJa/RH/JqzsS7zIqLSMT3UHCrhyqhVZ81u
vU96eVXt/BvdETlEmPmI
=wvu6
-----END PGP SIGNATURE-----

--=-B/n87sGdBrV4yuPhRbjH--

