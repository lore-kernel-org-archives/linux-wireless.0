Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYKQOpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 09:45:50 -0500
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com> (sfid-20081117_153229_848291_1314E086)
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 (sfid-20081117_153229_848291_1314E086)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZCdi/06nenN8jY+Nn3P1"
Date: Mon, 17 Nov 2008 15:45:41 +0100
Message-Id: <1226933141.3902.19.camel@johannes.berg> (sfid-20081117_154553_802205_6E627011)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZCdi/06nenN8jY+Nn3P1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 16:32 +0200, Tomas Winkler wrote:

> IMHO Not the concept but the implementation of this function is wrong.

I disagree.

> It should be no implementation difference between mac notification and
> reception of one RX frames that triggers oneof the connection step
> such as association response. If this would be handled in this context
> and there won't be any locking issue.
> If driver crashes internally and lost association info it can generate
> "local disassociation frame" and mac will try to reapply association
> in a regular flow.

The point is that the whole thing about disassociation is already the
wrong assumption. As I've outlined, it only works in STA mode, and thus
the function is generally not very useful.

> I agree that resume/suspend shell be handled properly in the mac80211
> regardless of this issue.

And it will handle the "firmware crashed" case perfectly too.

johannes

--=-ZCdi/06nenN8jY+Nn3P1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIYOPAAoJEKVg1VMiehFY+NkP/jGfNPeZrwB5KVSxZQV2JBk5
H1mlNRK6ycPh2uK8rngOnaJrbQnEi3EhDGokJxqVCItdGycbRj4iTxH7KpmOZO6j
CJwykaRY3EvNURGNg/5KCTKPKQ8O57j4l9WfRnrndR8osQvc97hA0FjRNjfuE7JY
3i/fcL++05bO59RMdMcdEKLeJ4JzqUUSYhq7Cue0EzMi7RD/Tdu6K+iT8eJs5bxQ
0hmd/tJ2Wb41gCxq+msRKnuEVMaprRMLd/sRIHKySlQTYxNV87MyTGYgLrhs7qhO
ayjQoAFPY5jfFIK9H/DMdQyIN30TD2whJ4x1y8DT9Wuh6yLl98g3+IGsp34n91OW
jsvOj5RKAkQa0ldbEISy0TcA4RoR0e3CUbg9hqqoON9D4uuQPQdbky/F7QSnnIu/
820eUFOEQ4h8oB05d3rG/kERoE6s+Vv02gOB5GRJyGyTxZ3oWZXb8aiNX4u2opKk
ITzrkWh2t/E3sfAPV35rNwEMEqArZwHT8YzJrQDkBeQgaAzYO5QJXzVpQ20NvXrD
5WP1UQh9tky591tiSNTHWtsHPWbi2vUEQOr726UIuE6IB+AK4G0yTo2YUT+asJEG
DJzrwMNLQMvQUvxZ57nzHlAmdiFpS/i6TSHds8MVXWFATxKJ224uSgDwoVs56IVo
iJ6JnIosV0rEE+XRyKD6
=2+CZ
-----END PGP SIGNATURE-----

--=-ZCdi/06nenN8jY+Nn3P1--

