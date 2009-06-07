Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbZFGRQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:16:12 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: alan-jenkins@tuffmail.co.uk, Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090607125715.GC3340@khazad-dum.debian.net>
References: <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <20090607125715.GC3340@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jfpNmz+z3jiLJt+0X8KZ"
Date: Sun, 07 Jun 2009 19:16:03 +0200
Message-Id: <1244394963.12956.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jfpNmz+z3jiLJt+0X8KZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 09:57 -0300, Henrique de Moraes Holschuh wrote:

> >  1) remove rfkill_set_global_sw_state()
> >  2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
> > registration, setting a flag.
> >  3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
> > events, tho it may as well be set in all events)
> >  4) rfkill-input preserves existing behaviour - *if enabled* - by
> > initializing the global state from individual devices which have NVS.
> > (As before, each _type_ of rfkill device has its own global state).
> >  5) rfkill devices with NVS will have their current state preserved,
> > so long as the global state has not yet been set (by userspace or by
> > rfkill-input).  Of course userspace can change the state in response
> > to the device being added.

> Let's do it :-)


Alan, you're right in that we currently overwrite devices with the
global state upon registration. My suggestion would be to not do that
when set_sw_state() has been called on the device before it was
registered, by simply keeping track of that. Anyone want to propose a
patch?

johannes

--=-jfpNmz+z3jiLJt+0X8KZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK/XNAAoJEODzc/N7+QmaNj8QAKPrDuBh5OhVs11mJaOZsIxj
Wu6hxoh2/GbFZKu+27LBapCw4mKyT2IAQryWWiNGhcpTcZPTwFiG64Pgv+kc+haV
0d4PVcgKyXM+0T1ops20xEuMU2nBqdlaKGLmEN5dIOUXfP9c103PmQboZ3K0U9Du
ChJ4PVPCUH5uDVq7ariYBIYIs+8ev+kPvymBX2FQYtXq8tW+1N41ins6RxMYrbrZ
+hiy8TFhF/l/XeF9EAamxnDNa3d1i6FfmQ9Jb8ZsGRbsQRX6BMb2LKJ/EQNHMs96
Y7hsBoAhTRHR2C2cGu0xGEEQoz8KDVLnzIJjuUjJ9i/5Br82Q9qp3tjUCVYltJsT
JIlZGMO7Yzt43rq7MKxkmHkt5vFXidF4DRWdApQgWhOlgIeRKupbzx67AbDX12Wt
Dh5ACZmofs3vcWuTnH+e6hD2RBd2CCr8cMSji/i4cTLsJrZqdAjNJZgMkEHvrwSn
X9IUg2ZKE9e3tJhVoU6vts7RZQnrHWoVC5DAOFHUVAoaNzNlhmDQOXwqJf/XkL3W
xaRj0h8J12c0mnMBdQGWIBv+fhTScIe0vDUr2MK4V9MSiKLBHJbqxmAKiWdg1+y3
9bHaSqL8NFuSGeBfEnxRuuNlam8MpEKbSRHnMFd2skyWV6J581vkhmmYL1e5BORx
uj50VAyP3SZFrOtfXz+x
=EF3L
-----END PGP SIGNATURE-----

--=-jfpNmz+z3jiLJt+0X8KZ--

