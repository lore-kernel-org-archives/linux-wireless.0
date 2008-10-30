Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYJ3PPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:15:16 -0400
Subject: Re: [RFC] mac80211_hwsim: Add support for client PS mode testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081030150455.GA3923@jm.kir.nu>
References: <20081030150455.GA3923@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qEJuMsKbw5eN3YU0U88o"
Date: Thu, 30 Oct 2008 16:15:15 +0100
Message-Id: <1225379715.3690.66.camel@johannes.berg> (sfid-20081030_161522_891353_37653B97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qEJuMsKbw5eN3YU0U88o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 17:04 +0200, Jouni Malinen wrote:


> This introduces a debugfs file (mac80211_hwsim/phy#/ps) that can be
> used

Why not use the cfg80211-provided debugfs dir /ieee80211/phy#/ and maybe
put it below hwsim/ in there because mac80211 has things in there too?
That way you save all the code setting up the directory etc.

> Mode 2 (automatic PS-Poll) does not yet parse Beacon frames, but
> eventually, it should take a look at TIM IE and send PS-Poll if a
> traffic bit is set for our AID.

Out of curiosity, is there any hw that implements this? b43 surely would
need such code too, and then it could be in mac80211? I can see setting
the PM bit be a decision of the driver, but if more than one driver ends
up needing ps-poll, maybe mac80211 should be handling it?

johannes

--=-qEJuMsKbw5eN3YU0U88o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCc+AAAoJEKVg1VMiehFY3BIP/iTQlX1z5QWL4KMYxlqVWg8A
T1LHM1A3AZnaIiPCJLxfXP5fHDPHEWnfv8oLjIzt+jDGQfjweTyoyFzEXAMUft7F
bd9WgwpLrK3YPH7cuMz9YEzRIPwhBu82kTOyLGhwZngK2wzhk6DHCDZUhkhLx+ws
dRGkAa99zo444zFWCh6JdTE1Aa3pS14kxZFaL0/2aZkdc9r8wu0CT4fZse1yfCv/
DxXLy6ndfr0PGReccXJ4qUzS/BDvOJDURKMEEl4uOQD0mLag2kKJQmh6GKQK9rAW
cF4q3RvzMvmoClR0fXIree+vlcCvtl7QiQj9iNlfzcj7IrXM8VW9y3idnBXcrT1/
+mBTKn5I9W/6Ytz/PNV/Qo6T316ISItoX58kgxg6d2yKihnWIwSKAVeBn3R/iG+l
J7xmvflEwQHOaDeY1zz/IbJ9k/UeV4h/5ki1rcsuqmmsS2kNm/dLLua72mfsul2T
e9RhBLdZS8vFtTI90DZoCa0NAO2NQ0db1748qT/3aVUfqUhzpWuQWw6Ih6ZULDqT
vn8XaS/jxpzzM64a7TT2SqgzQr4BFFpdtCPoJnl10I0bQ2DwAu5RtFMkUXyzqsQl
51GvmVmJQTkgOa3dbvIq2z/QgOE+v8tIMeXX6eMyJsO2TP6w/wV0xqmqlewMDzBd
0JOGSNFSLjyJ1+SGrm+g
=1T69
-----END PGP SIGNATURE-----

--=-qEJuMsKbw5eN3YU0U88o--

