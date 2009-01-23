Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZAWWLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:11:01 -0500
Subject: RE: Question on tx field of struct ieee80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: "Gordon, Charles" <Charles.Gordon@digi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B010A451E5DEF@mtk-sms-exch01.digi.com> (sfid-20090122_232702_425061_00BB0D85)
References: <8DCC153EAFE67A4B990A840E829F704B010A451E5DE9@mtk-sms-exch01.digi.com>
	 <8DCC153EAFE67A4B990A840E829F704B010A451E5DEF@mtk-sms-exch01.digi.com>
	 (sfid-20090122_232702_425061_00BB0D85)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SQtXmA43wDoZSPMTBhW3"
Date: Fri, 23 Jan 2009 23:10:56 +0100
Message-Id: <1232748656.3977.6.camel@johannes.local> (sfid-20090123_231109_458733_02C2D04C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SQtXmA43wDoZSPMTBhW3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 16:26 -0600, Gordon, Charles wrote:
> A follow up question on this is if my transmit routine does not have
> its own queue and the H/W can only transmit 1 packet at a time, should
> the transmit routine call ieee80211_stop_queue() when it starts the
> transmit procedure, and then call ieee80211_wake_queue() when the
> hardware indicates it has finished transmitting the packet.

Yes, that's exactly the right way to do it. I think adm8211.c does that
too.

johannes

--=-SQtXmA43wDoZSPMTBhW3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJekBsAAoJEKVg1VMiehFYPMcP/2q2s9dSTynOTA8lkecNsN7D
s/mprgwwcQ3+J+WV9zLdv6US9ihDti3X/CXeXsOfa0lUBNJcU+X0Iqu4ITDCK87o
D+lSbp6VroOUiMKHtlDeUv78s7zGBDSfZK/Mopc6ExgOOVYXilM7WdHaBaBYgDUa
edtF7ZwC/Dq4XW6JUOK1BEfXhWdy3MPVRDjFe5gYiTcLbjfaB1BfBpIKdVoQlAmk
j9GDIWWHBeH6SnD+6mcT6RDu+kVYwan3ZifrYYba3d1pE8EM4N7o7PuyzuYmhQmM
Wb3Nrp2NoJ07ImYGbgreevzG4bhyDnVd+Pb3x4XlxPKo0e3J7j77LiVPsgpg8gKM
vMRt+ActmZ7Bwwf/MHMOl9/io6/460iacrz1J0ZVdL4GExS8LNVyh3WamqeD917J
DO6HKPd6H8CP/x6tIZqPb5jsimH+HwdtNtxH27yefuZE0kZ798nXTo/Y1ZJLlQ/d
OsLXc/IyLQj3McOUhcq8BL5tgLyT2CFwGjArrd+/5V/Zcj8aQK34Pt9E30d2IveQ
Fq8hVTpHwBkmRZ8CWbzmVkWsH0YFHOJFnKjSFf/AR2x/TJVVj02jsVplfTlmAnlF
7Ao/M4n9337HopZobH4PnJhv9LOemOg++MF1z1MmZNg9fuF+/4gf0sjsRraE0n0x
cT9hwrtTE/B5t1+7psaL
=mNdL
-----END PGP SIGNATURE-----

--=-SQtXmA43wDoZSPMTBhW3--

