Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZAFRnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:43:15 -0500
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
In-Reply-To: <20090106172758.M47578@bobcopeland.com>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com>
	 <1229336057.4471.9.camel@johannes.berg>
	 <1229354532.12163.24.camel@localhost.localdomain>
	 <20081217174244.M36761@bobcopeland.com>
	 <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet>
	 <1230102989.16960.14.camel@californication>
	 <1231260306.14565.21.camel@localhost.localdomain>
	 <20090106165434.M2397@bobcopeland.com> <1231262082.3654.5.camel@johannes>
	 <20090106172758.M47578@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+tkzQChf+RrS9k3Wnreq"
Date: Tue, 06 Jan 2009 18:43:22 +0100
Message-Id: <1231263802.3654.8.camel@johannes> (sfid-20090106_184325_418085_FF72468C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+tkzQChf+RrS9k3Wnreq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 12:35 -0500, Bob Copeland wrote:

> No, I mean that with dbus telling NM to go to sleep (as part of pm-utils)
> NM then takes down the interfaces -- userspace is still running, this is
> before the kernel actually suspends.
>=20
> Consequently, all the interfaces look down to mac80211 when suspend() is
> actually called so the suspend/resume in mac80211 doesn't wind up doing
> anything with interfaces.  No race condition, but a re-association must=20
> happen from userspace on the resume side (NM will do this, though).

Ok, but that's fine, that means the mac80211 resume code will also not
do anything. Hence, we can put this code in, but it won't be used on
such systems initially.

We should probably take the rtnl anyway though to be prepared for when
userspace is not suspended.. Need to think about that more though, and
possibly add a new "suspended" flag that makes it block all
configuration attempts.

johannes

--=-+tkzQChf+RrS9k3Wnreq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY5g3AAoJEKVg1VMiehFYG2sQALvW+lGZiA/MVX1hu7EGuRE9
qeWb0zw1xcSt9VhaHHxmN7c5WVmkrfjjn0CTA+KLws/U0DtlGiUFKhL7qq0BeR2K
NtJAH6QdZVdhEwWVOaZJqdnhFCbTCtsaeyEdiX9ZYY8iCajkP8U2oNUvuP0LnUil
Ln308GQNrCKsh8WhWbn5jzFaKHttcpEMMBU5mBlSQpQQxAYIOiTH3qUzzBetAZlf
B4nEH5zV2zUhn10Yizw5cCb6qzxQ7y4Y4VmhMfKQEFrTMgb9oh46mU8FYuYK2kar
ilKAYFwOufRLV9bBRO2ECzeuP+lFBu20XH8P5B/7au4tR0N3b/MsYY8nHEDVJ6go
hDIGYiCSvylGUP02Al0PTA8VsRMuGy7PB+RkT6pT1mEZnCAluVHT5jmmm1kmXXp1
eZYyv/yPXDZpGt/dJjHOmTziP67T9f5RXAMdQVEhFPMwfMyo+eICBbgbM6u4+h+s
SP9TCTVkQwi2Es50N0ZRQa7l6uctldn3XQMcrTYrefkzwXLdHPVwgb5heRZ4/UuZ
rEALVdD50GHfAbyqueW4hP70mPAH/RtEadjOEAI+jOjv2V5i+OOlEboTo2ogeVfY
HhmLD8UpncAz106R0zueVnhB42eww4BwbpUEjT+WahB4TrT8Tmrm4gd9o2aKFjdK
H//URUG+B4zkLXoNCuX1
=uyg/
-----END PGP SIGNATURE-----

--=-+tkzQChf+RrS9k3Wnreq--

