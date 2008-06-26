Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:41693 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYFZOXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 10:23:24 -0400
Date: Fri, 27 Jun 2008 00:23:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	akpm <akpm@linux-foundation.org>, linville@tuxdriver.com
Subject: Re: [PATCH -next] iwlwifi: fix build for CONFIG_INPUT=n
Message-Id: <20080627002315.5938c262.sfr@canb.auug.org.au> (sfid-20080626_162328_551647_745602C0)
In-Reply-To: <1214446410.14590.287.camel@debian.sh.intel.com>
References: <20080624210246.0fe18e2c.randy.dunlap@oracle.com>
	<1214446410.14590.287.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Jun_2008_00_23_15_+1000_330VVWa3JtOg7rbS"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Fri__27_Jun_2008_00_23_15_+1000_330VVWa3JtOg7rbS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jun 2008 10:13:30 +0800 Zhu Yi <yi.zhu@intel.com> wrote:
>
> On Tue, 2008-06-24 at 21:02 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >=20
> > Fix iwlwifi so that it builds cleanly with CONFIG_INPUT=3Dn.
> > Also free the input device on exit.
> >=20
> > drivers/built-in.o: In function `iwl_rfkill_unregister':
> > (.text+0xbf430): undefined reference to `input_unregister_device'
> > drivers/built-in.o: In function `iwl_rfkill_init':
> > (.text+0xbf51c): undefined reference to `input_allocate_device'
> > drivers/built-in.o: In function `iwl_rfkill_init':
> > (.text+0xbf5bf): undefined reference to `input_register_device'
> > drivers/built-in.o: In function `iwl_rfkill_init':
> > (.text+0xbf5e9): undefined reference to `input_free_device'
> > net/built-in.o: In function `rfkill_disconnect':
> > rfkill-input.c:(.text+0xe71e1): undefined reference to
> > `input_close_device'
> > rfkill-input.c:(.text+0xe71e9): undefined reference to
> > `input_unregister_handle'
> > net/built-in.o: In function `rfkill_connect':
> > rfkill-input.c:(.text+0xe723e): undefined reference to
> > `input_register_handle'
> > rfkill-input.c:(.text+0xe724d): undefined reference to
> > `input_open_device'
> > rfkill-input.c:(.text+0xe725c): undefined reference to
> > `input_unregister_handle'
> > net/built-in.o: In function `rfkill_handler_init':
> > rfkill-input.c:(.init.text+0x36ec): undefined reference to
> > `input_register_handler'
> > net/built-in.o: In function `rfkill_handler_exit':
> > rfkill-input.c:(.exit.text+0x112c): undefined reference to
> > `input_unregister_handler'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> >=20
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> ACK.

I have added this to today's linux-next tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Jun_2008_00_23_15_+1000_330VVWa3JtOg7rbS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhjplMACgkQTgG2atn1QN9TjQCcDuVuxzNgXrpo2xkdvYLJbO6+
E1cAnihhvXtvPHpuv2sAWAL8pRMX9wPX
=CRzw
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jun_2008_00_23_15_+1000_330VVWa3JtOg7rbS--
