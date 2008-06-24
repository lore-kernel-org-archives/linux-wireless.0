Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYFXIwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 04:52:35 -0400
Subject: Re: mac80211: workqueue & RTNL lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com> (sfid-20080623_131726_345592_F39BBCE4)
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
	 <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com>
	 (sfid-20080623_131726_345592_F39BBCE4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NtJfJu5Er1QtAOhqClzU"
Date: Tue, 24 Jun 2008 10:51:55 +0200
Message-Id: <1214297515.8967.253.camel@johannes.berg> (sfid-20080624_105238_622581_64C2CB54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NtJfJu5Er1QtAOhqClzU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-23 at 13:17 +0200, Ivo Van Doorn wrote:

> Well it was caused by the recent introduction of the interface iterator.
> Question now is if we need to restrict the usage, remove the flush_workqu=
eue,
> or change the locking in the interface iterator. :S

Ouch. Any way you can use the atomic iterator there?

Or if not, can you use schedule_work and cancel_work_sync to take care
of things? I would like to keep the mac80211 workqueue rtnl-free because
otherwise locking is going to get ugly.

johannes

--=-NtJfJu5Er1QtAOhqClzU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYLWoAAoJEKVg1VMiehFYAtQP/2MljfNS3iIFB70RAdmxkslN
dflilDoi5LJIyRqw8DzDoOnlc6IRUfwOfjBm6ZvVurSdTCZ0be+XPKG2IL4B4o3d
YWWEAx2lb15Oy3Xh5j2FLy8v9hFgNeAIpI8yNjZAWvyPrZX9hTwP0HfatsA6+M9q
hrSlmFmeNr6T+52CcPIiBsPY+CAn+ulGgb1T0Yoo5mpv80iDoCIHRRAEQJSg1P6P
kzjYpVffycE1yOGW7LvyaZ1BbmOCT2WZp+5mySN/FUKgWYgOQOpa7QiMqQLg+X8u
2kkzCuJEVIfDfVqudObwQ14r6rhZ9nJKKrmKcN8xk0PUtc6wlzOgZehTUhe7JzC5
Ls2ZVZ4AuFJAnTqBtY2y079QmKg6+7P9ALwPuF/VdJE0qCGtD7RFEYhXxHJ4YKDe
TTxub1kbih62w384dvBCheoT9XZS/1P9JGyztNBebQpXfqgdy1s3bgEPAT6JcGEh
Gyr/ns8P4/kiAn27Z9BhU57rerXGWkLgHaBcR+dPl5hyCEWQpEi/uLEu0VMWj7nG
37Gyov0SsRmXnol2PJrV5QJU3CmE2EfwpvOdVLJnFZQwKbp4/NuTaRd+mCAOLNoP
B+TcnEP8HeqEd+xvM0DzwIoYe7TbGSTcPoQ3BxkNiyy7hG5F4uR6puP1eniEBblf
R2VwUKpRUbDvUrT2Wlzz
=46CZ
-----END PGP SIGNATURE-----

--=-NtJfJu5Er1QtAOhqClzU--

