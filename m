Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51647 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZGDKlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 06:41:45 -0400
Subject: Re: BUG REPORT: libertas causing kernel lockups
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Barinov <alex.barinov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090704130346.01b2e869@dream>
References: <20090704130346.01b2e869@dream>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F1059qAlDR9Wn9LopSgZ"
Date: Sat, 04 Jul 2009 12:41:42 +0200
Message-Id: <1246704102.16770.71.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F1059qAlDR9Wn9LopSgZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-04 at 13:03 +0400, Alexander Barinov wrote:
> Hi,
>=20
> I have Eking I1 UMPC that features Marvell 8686 SDIO wireless card. I
> am currently using vanilla kernel 2.6.30, but the bug is there on
> Debian 2.26 and 2.29 as well as vanilla 2.29 kernels I tried previously
>=20
> The initial symptom of the bug was system lockup when executing 'ifdown
> eth0' with 'BUG: scheduling while atomic'. Trying to understand the
> cause of the bug and find a workaround I was able to find an easier way
> to reproduce it. By executing 'cat /proc/net/wireless' I get the same
> bug:
>=20
> BUG: scheduling while atomic: cat/1885/0x00000002=20
> Pid: 1885, comm: cat Not tainted 2.6.30.090704 #2=20
> Call Trace:=20
> [<c042eb7f>] ? __schedule+0x37f/0x8c0=20
> [<c01237cd>] ? try_to_wake_up+0x8d/0x1e0=20
> [<c011ee0e>] ? __wake_up+0x3e/0x60=20
> [<c02e882c>] ? __lbs_cmd_async+0x11c/0x280=20
> [<c018ddbe>] ? d_rehash+0x2e/0x50=20
> [<c042f0d0>] ? schedule+0x10/0x30=20
> [<c02e8be4>] ? __lbs_cmd+0xa4/0x1a0=20
> [<c02ea3f0>] ? lbs_cmd_copyback+0x0/0x40=20
> [<c013c460>] ? autoremove_wake_function+0x0/0x50=20
> [<c02e67d5>] ? lbs_get_wireless_stats+0xf5/0x3c0=20
> [<c02ea3f0>] ? lbs_cmd_copyback+0x0/0x40=20
> [<c03fb1e7>] ? wireless_seq_show+0x47/0x180=20
> [<c03965bf>] ? dev_seq_start+0x1f/0xb0=20
> [<c0196c6d>] ? seq_read+0x1fd/0x360=20
> [<c0196a70>] ? seq_read+0x0/0x360=20
> [<c01b4774>] ? proc_reg_read+0x64/0xa0=20
> [<c01b4710>] ? proc_reg_read+0x0/0xa0=20
> [<c017f9ab>] ? vfs_read+0x9b/0x120=20
> [<c017fb01>] ? sys_read+0x41/0x80=20
> [<c0102f21>] ? syscall_call+0x7/0xb
>=20
> Please let me know if I should provide any additional details regarding
> the bug.

This should have been fixed by 87057825824973f29cf2f37cff1e549170b2d7e6.
For some reason everybody seems to have assumed that get_wireless_stats
can sleep, which before that commit it could _not_.

johannes

--=-F1059qAlDR9Wn9LopSgZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTzHjAAoJEODzc/N7+QmaLmoP/0gCh/1FSUGhtMj7pACCiOlZ
+s7lOeJ4CCRef+F/J0lyKetJ6NYQm0UsqmJip3ANuksGA77w+iDozsQbZ3ICE19E
MW6+XPYbekfkpIy8FTJNocT5sKi6KtPCw1wQWdzj19ypwyOi5LUGkK8JUSWXVT7H
7mbM5cjfUdyE3jX5UN1t7QUiMUDefMkA7AcbkfL/b1DTVEjeXRaG5qdNDkjPfZpm
ZyIy9utUZlO3fKjU7lrheXW5yWB+vJwKn187c8lLxVL1V9EIjzeZQlWEe+7cIbHe
oy/duwLlQp7AJNtoL2nRZaAfYiXx2xUIqNv3ClxBrUeFbFJtB7clMBBPJ51hhPfO
nrIg8smwgrEqg6t9cPL5NIwFTfxtPY18XD4qKYow02noD3Es/m8dP3b7y86iWUXF
SoNG2zIYELvAaEfLERBuM2KGxEDJ/lzS/BMyFUtr0JM7NUxsI20F1GFU31fTyhV3
om1HmQdIvEztW4LKVwAoC47zcFdypoBWVwqjOmqm4UDU7y7aO7Nt7V4oI6u71oXW
W5YVmiRMtdilhHfcB+hY5c7acbNcjlyE9b9qs5vV2oY2+5MCXrKsjt+CLdgPc+9/
WiHDio+AtpBlPTj0ZHef7rGXb7hSJfK23ZRG3vjYGwJc7+VYCPuOHGd8v9s1p4Vs
j9um/dqXOvoupuRqPjVY
=BE91
-----END PGP SIGNATURE-----

--=-F1059qAlDR9Wn9LopSgZ--

