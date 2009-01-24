Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:56378 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZAXPz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 10:55:27 -0500
Subject: Re: [ANN] crda v1.0.0
From: Tony Vroon <tony@linx.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	"Diego E. 'Flameeyes'" =?ISO-8859-1?Q?Petten=F2?=
	<flameeyes@gmail.com>
In-Reply-To: <20090123235725.GC30761@tesla>
References: <20090123235725.GC30761@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dUq3hmlr0QmCqmxwYHKQ"
Date: Sat, 24 Jan 2009 15:55:57 +0000
Message-Id: <1232812557.19657.6.camel@localhost> (sfid-20090124_165529_929455_7325E019)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dUq3hmlr0QmCqmxwYHKQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 15:57 -0800, Luis R. Rodriguez wrote:
> The crda code has been intact for a while now, no main issues
> have been found or reported. As such this wraps up its 1.0.0
> release, and I doubt it will be changed for a while.

Thanks Luis.
Two questions:
1) Could you please drop that v from the tarball name. It's new, and it
means extra work for me. The old naming was perfect for automatic
handling.
2) You say the only changes were manpages, example directories and a
spec file, but it introduces a new build failure for me:
>>> Unpacking source...
>>> Unpacking crda-v1.0.0.tar.bz2
to /var/tmp/portage/net-wireless/crda-1.0.0/work
>>> Source unpacked in /var/tmp/portage/net-wireless/crda-1.0.0/work
>>> Compiling source
in /var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0 ...
make -j8 CC=3Dx86_64-pc-linux-gnu-gcc
  GEN  keys-gcrypt.c
  CC   crda.o
  CC   intersect.o
  CC   print-regdom.o
  CC   regdbdump.o
  CC   reglib.o
  LD   regdbdump
  LD   intersect
  CHK  /usr/lib/crda/regulatory.bin
  LD   crda
crda.o: In function `nl_socket_alloc':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:28:
undefined reference to `nl_handle_alloc'
crda.o: In function `nl80211_init':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:64:
undefined reference to `genl_connect'
crda.o: In function `__genl_ctrl_alloc_cache':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:38:
undefined reference to `genl_ctrl_alloc_cache'
crda.o: In function `nl80211_init':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:76:
undefined reference to `genl_ctrl_search_by_name'
crda.o: In function `main':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:252:
undefined reference to `nlmsg_alloc'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:259:
undefined reference to `genl_family_get_id'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:259:
undefined reference to `genlmsg_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:270:
undefined reference to `nla_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:320:
undefined reference to `nlmsg_free'
crda.o: In function `nl80211_cleanup':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:94:
undefined reference to `genl_family_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:95:
undefined reference to `nl_cache_free'
crda.o: In function `nl_socket_free':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:33:
undefined reference to `nl_handle_destroy'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:33:
undefined reference to `nl_handle_destroy'
crda.o: In function `main':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:272:
undefined reference to `nla_nest_start'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:280:
undefined reference to `nla_nest_start'
crda.o: In function `put_reg_rule':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:130:
undefined reference to `nla_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:131:
undefined reference to `nla_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:132:
undefined reference to `nla_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:133:
undefined reference to `nla_put'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:134:
undefined reference to `nla_put'
crda.o:/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:135=
: more undefined references to `nla_put' follow
crda.o: In function `main':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:288:
undefined reference to `nla_nest_end'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:291:
undefined reference to `nla_nest_end'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:293:
undefined reference to `nl_cb_alloc'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:297:
undefined reference to `nl_send_auto_complete'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:304:
undefined reference to `nl_cb_set'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:305:
undefined reference to `nl_cb_set'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:306:
undefined reference to `nl_cb_err'
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:318:
undefined reference to `nl_cb_put'
crda.o: In function `nl80211_init':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:86:
undefined reference to `nl_cache_free'
crda.o: In function `main':
/var/tmp/portage/net-wireless/crda-1.0.0/work/crda-v1.0.0/crda.c:309:
undefined reference to `nl_wait_for_ack'
collect2: ld returned 1 exit status
make: *** [crda] Error 1

Is it possible that you inadvertently broke the ability to build in
parallel? This is make -j8 on a dual quad-core Opteron, so there are 8
cores ready to handle jobs. I've seen it break compilations before.
I have CC'd Diego on the e-mail, just in case it's an easy fix.

Regards,
Tony V.

P.S. Resend, accidentally used wrong FROM address. Apologies.

--=-dUq3hmlr0QmCqmxwYHKQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkl7Og0ACgkQp5vW4rUFj5pBrACePi8hRU3TvjWzHwsO+CpJ/RTF
ylwAn1Y+BL5RQkzf0DLRuyvqu32TjoWo
=6RZM
-----END PGP SIGNATURE-----

--=-dUq3hmlr0QmCqmxwYHKQ--

