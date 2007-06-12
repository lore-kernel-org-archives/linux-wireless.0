Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbXFLJfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 05:35:55 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1181635570.4758.22.camel@debian.sh.intel.com>
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
	 <1181635570.4758.22.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sd6L+1cwd+RI857bURdQ"
Date: Tue, 12 Jun 2007 11:35:49 +0200
Message-Id: <1181640950.29767.62.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sd6L+1cwd+RI857bURdQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-06-12 at 16:06 +0800, Zhu Yi wrote:

> You are right. I once had the debugfs file on the DLS request response
> side to to indicate accept or deny all DLS requests. But after a second
> thought, maybe a MAC list is better? But this is just for testing not a
> real API.

Alright.

> Right. For the real API, I'd prefer the kernel to send an event to
> userspace (daemon) via netlink (nl80211) and let user space to make the
> decision. This way mac80211 doesn't need to manage the user prefered DLS
> list itself. Another benefit is the DLS connection could be established
> interactively. For example when a user is VIing in Xwindows, a pop up
> window from NetworkManager asks "MAC address XX:XX:.. wants to setup a
> DLS connection with you, do you accept?"

Yeah, I disagree with bothering the user with it, but the idea sounds
sane in that a userspace daemon is allowed to make the decision.

And putting it into the kernel now is actually a good thing, it forces
us to think about the use cases. When we stick it all into the userspace
MLME are we sure that the userspace MLME is the right place to make the
decision? I don't think it is, so we need the MLME API anyway.

johannes

--=-sd6L+1cwd+RI857bURdQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbmj1/ETPhpq3jKURAv6mAJ4oc6oksUDg/KFzXahBJQiARggLqQCgkICe
N8QWxZ3bgeLTLu7rFulVCr0=
=kHxP
-----END PGP SIGNATURE-----

--=-sd6L+1cwd+RI857bURdQ--

