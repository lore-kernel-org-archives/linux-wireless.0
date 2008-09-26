Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYIZLFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:05:32 -0400
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, hmh@hmh.eng.br, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com> (sfid-20080926_000546_677648_11D1E1E6)
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
	 <200809252310.21320.IvDoorn@gmail.com>
	 <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com>
	 (sfid-20080926_000546_677648_11D1E1E6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2FdDX+A0yCooCCTWP4so"
Date: Fri, 26 Sep 2008 13:01:45 +0200
Message-Id: <1222426905.10563.100.camel@johannes.berg> (sfid-20080926_130536_527433_F22401F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2FdDX+A0yCooCCTWP4so
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 01:05 +0300, Tomas Winkler wrote:

> > I am not sure if registring a notifier would be the best solution,
> > persionally I was thinking of implementing the rfkill structure into ie=
ee80211_local
> > and make it listen to events directly.

I think I like this better.

> That's definitely other option we wanted to suggest that mac80211
> would register itself to rfkill subsystem and will provide to driver
> appropriate callbacks.  The question is how  drivers vary in the rfkil
> implementation and whether it wouldn't be more complex, in that case
> the notification is quite clean solution.

How complex does it have to be?

> > That means that the only change needed in ieee80211_ioctl_siwtxpower() =
is
> > only allowing the enabling of the radio when RFKILL is not set to BLOCK=
ED.
>=20
> That's just complicates everything and moving the policy  decisions to
> the driver after all even
> form txpower off you implement it as soft rfkill.
>=20
> I would suggest just remove the support for txpower off in mac80211
> now when appropriate or sync it with soft block after all it coming
> from user space as a software event.

I think what we should do is in mac80211 simply synthesize the
"radio_enabled" state that the config callback has from both rfkill and
txpower off. Anything wrong with that?

johannes

--=-2FdDX+A0yCooCCTWP4so
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3MEWAAoJEKVg1VMiehFYTNkP/1VGZ6pNqgwcrgqWXIy+PQS3
1UYtQkb7VV4JeknIP9KCZVfbMNoCu4pjNvmduBysnPKqDDkuHUaI9LyFOdLW71Q5
2i+/yinhDGX9hgrYnvmd0JOyg0t6ZBwgtHMbWZ+tzormAZi6ND6c1csiXqzlVJ+M
AuX9JnkLxUoAX9EKRDzof16Nt91Ww2ChbvPeV+/kCytqkmN1zA2JN672sGBWyBhc
4GBRJCxQJ4/7nPZCKSzFJ3dGFirn/rM29eOy4IJ4ajvgZfP15B6hUdm6thrOn4S6
JZ68YZ65u0Dlz+Vapl5BkwGkXJ/chcTZQ9vO1kBWmoREsEOvsTRYMR7XT+JWYWGZ
/VNOXdeobdh6iHDwKLAIEyRZerTFhHdj+hN2LlFj88BU6QHDG+E+zwidlVeUUOHQ
WTOcqhFYszKuOa6K7g8HQsT/KGAnH2xLDGozyqUTYwcENZLwKAQKhXcj0rZAVsvR
M5YK1wxbIK66zg7gHQ5/1a6mcL41YG7uMIYzClaJHkdsuyjL1kbtIHIgR9UJKw1B
q6do/WF3/YT/omdRTwESCRbDiRdNzsbrkHLxTOHeFKQjykRhE/RHvznTOrYIlsxw
D3ibv7F77h/fRUPn+4wlduvBkLoGGQ6ept3DyCVdKNA+wiQljCm2BGHMoiZO47yc
guhzZpOj4mJnagggKlvF
=cOlW
-----END PGP SIGNATURE-----

--=-2FdDX+A0yCooCCTWP4so--

