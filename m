Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378AbcDENrN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:47:13 -0400
Subject: =?UTF-8?Q?Re:_[PATCH]_mac80211:_fix_=22warning:_=e2=80=98target=5fm?=
 =?UTF-8?Q?etric=e2=80=99_may_be_used_uninitialized=22?=
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <5702AF3B.1070507@suse.com>
 <1459849388.18188.28.camel@sipsolutions.net> <5703BEA7.3040406@suse.com>
 <1459863619.18188.50.camel@sipsolutions.net>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5703C1D9.2000800@suse.com> (sfid-20160405_154725_580741_147F9FD0)
Date: Tue, 5 Apr 2016 09:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <1459863619.18188.50.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HQa31QLTh5HulFpWi2VUbs5ESbjTeStIJ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HQa31QLTh5HulFpWi2VUbs5ESbjTeStIJ
Content-Type: multipart/mixed; boundary="mxMApkrHEVFeB5UTPTUPuGhDbeK50DKpe"
From: Jeff Mahoney <jeffm@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Message-ID: <5703C1D9.2000800@suse.com>
Subject: =?UTF-8?Q?Re:_[PATCH]_mac80211:_fix_=22warning:_=e2=80=98target=5fm?=
 =?UTF-8?Q?etric=e2=80=99_may_be_used_uninitialized=22?=
References: <5702AF3B.1070507@suse.com>
 <1459849388.18188.28.camel@sipsolutions.net> <5703BEA7.3040406@suse.com>
 <1459863619.18188.50.camel@sipsolutions.net>
In-Reply-To: <1459863619.18188.50.camel@sipsolutions.net>

--mxMApkrHEVFeB5UTPTUPuGhDbeK50DKpe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 4/5/16 9:40 AM, Johannes Berg wrote:
> On Tue, 2016-04-05 at 09:33 -0400, Jeff Mahoney wrote:
>> On 4/5/16 5:43 AM, Johannes Berg wrote:
>>>
>>> On Mon, 2016-04-04 at 14:15 -0400, Jeff Mahoney wrote:
>>>>
>>>> This fixes:
>>>>
>>>> net/mac80211/mesh_hwmp.c:603:26: warning: =E2=80=98target_metric=E2=80=
=99 may be
>>>> used
>>>> uninitialized in this function
>>>>
>>>> target_metric is only consumed when reply =3D true so no bug exists
>>>> here,
>>>> but gcc doesn't notice that.  Initializing to 0 clears the
>>>> warning.
>>>>
>>> What gcc version are you using? Mine doesn't seem to have a problem
>>> following the logic here.
>> gcc version 4.8.5 (SUSE Linux)
>=20
> Ok, mine's significantly newer:
>=20
> gcc (Debian 5.3.1-10) 5.3.1 20160224
>=20
> I do wonder though if we really should do this? It might hide errors
> later on?

AFAICT, the only way errors would be introduced is if someone added a
new case in which reply was true *and* needed a different target_metric
value (there are 3 cases it's used, 2 of which use 0).  Or if there was
a new case where the target_metric was used and reply wasn't true -- in
which case this code would have been broken anyway.

Also, using uninitalized_var would have a higher probability of hiding
an error later on.  Setting it to 0 seems the safest course.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--mxMApkrHEVFeB5UTPTUPuGhDbeK50DKpe--

--HQa31QLTh5HulFpWi2VUbs5ESbjTeStIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXA8HZAAoJEB57S2MheeWyhIEP/ijQN4q2IRZ0dxlREwLOLr4q
bl5a246opHTifskxUTIOFeRRs5QIixWnxfepjcgKng74BruQ4dki29ufWFBr9OqJ
bk10ixIQub+SuP3PavAdGW5L7pfNpqO4JapGAeZUYdF3f97VAlaB8mg+Y57nNLjT
LVVMR/XUd4DQXzzFn1T045xs18j05cXpIButrqGEv9YbNQtR9+o4Yg5nTPEwi1k/
mrfNk+kwCzm0QBqNWnm2w60pwh4NrWD+dJDFbq+Yergr0WnFhsfhiv1iMISv2uz3
ZFcBdl7fVNvQqpT97b2vgfUiF0aZcMmZ7D54zuX3+6uGJsm23XxB7tWBfzD5OgOf
MqjT8qbT0dlLB0+cgYnm4WACG3LBGZ8HNgps5DZ1uIRYvTEf5RvKjmdt/H4j/tvB
+BIkvhAy8zGztsceEDHmGqKZFYB/K+9Q8JMVxX6vx7FWOgeUHXXYUQ8Npim7dB3G
znjfV1QSQlADhifOVBwTOO1KZps7MXqMXH3nAEPwMx4XLZbyqx/3PKJAXWSIcqJf
9ezOCXQb48IxdRGyaRrmHES6eVQCCZ4NrC5UGHXloDMmEU/ChFZRq93b42R5Fxl+
ml3zjZFYQj+fNDqj9zMepnXDRA409Yhigx6j5UX982L8IPvrFL4O0Sg3HKLj92ht
XhtokLnOfUfKJLD57Zov
=llYV
-----END PGP SIGNATURE-----

--HQa31QLTh5HulFpWi2VUbs5ESbjTeStIJ--
