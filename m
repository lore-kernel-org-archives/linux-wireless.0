Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYDCK2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:28:05 -0400
Subject: Re: mac80211: possible circular locking dependency detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB0892004194DDE@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB0892004194DDE@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fjS4rVQ9jJbkgnIKIFV7"
Date: Thu, 03 Apr 2008 12:28:02 +0200
Message-Id: <1207218482.3636.19.camel@johannes.berg> (sfid-20080403_112812_982366_CC856F98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fjS4rVQ9jJbkgnIKIFV7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> [ INFO: possible circular locking dependency detected ]
> 2.6.25-rc8-wl #23
> -------------------------------------------------------
> rmmod/5589 is trying to acquire lock:
>  ((name)){--..}, at: [<c012deec>] flush_workqueue+0x0/0x80
>=20
> but task is already holding lock:
>  (rtnl_mutex){--..}, at: [<c02507ee>] rtnl_lock+0xf/0x11
>=20
> which lock already depends on the new lock.

Huh, yes, but why didn't this show up before? The bug has been there
*forever* and my workqueue lockdep debugging has been in the kernel for
a long time as well. Odd.

I think the solution is to use cancel_work_sync() but I'll have to look
into it.

johannes

--=-fjS4rVQ9jJbkgnIKIFV7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/SxMaVg1VMiehFYAQJ2+RAAvKwmHAJa4c28epm9NY/Ot/DmqfYgnHQU
a9oIqIowcWbBrYP4rW/lQtHGUp56TOZdRCUpLAt1APnEL9nn6a0w50QfkvRDv6+P
Ctk79velQdyOFu10Y6akn+N8WrL3wqL18PCqc6a93OUmwM5NytkL1zkeK7yCNJwR
j2AwleuPsLTJmUStx0oHyMq/bCRFR3lEwBxBLCU/d/d9hnfE8IQulHpNGt0F+TWk
ipHWLH4pJD5zshv96J4FcJtIQXJTPqILNzLdOV5u7yrSSnPeAkrqSTFJa9LPw3Nw
Ii4syBebOAn8oEIZKBU4Fib7U/0Jngl6OL43Jco0a7IgIlbEzc5mX/2UGlGkBDFD
2/ExJjuuOyeC/bhEIUpZNODvYxVpub4W/+eBANpJx+XuMhQ6tcdFu/FDDqAdhTZ5
zfm7AUxnzXKVnkpWK3MKtBBOnbTtq6Mja3AxmSPpk0F6MUZMjCyy25kiFpwMWtk+
rV2kTgesXoBJjEusICQiAvSHhaXETQH3G05UIYmEHU9KJdhWZ/4xiECqddjWuc0X
rUCBetuyA8VUIdMDc/x2o2zlAPPD8H7JUXX4oYIZR6qzOKFo4AyyMt1chh+nkr6w
8AzZORrUxf8GuhmW/HMZn3LxCx6Utp5/O3lw66kDsYcqseLZVi/ENYRzy3y1nxw1
KjiJGTvdKL4=
=NX/v
-----END PGP SIGNATURE-----

--=-fjS4rVQ9jJbkgnIKIFV7--

