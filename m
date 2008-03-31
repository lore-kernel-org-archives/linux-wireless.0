Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbYDALsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 07:48:10 -0400
Subject: Re: [PATCH 2/8] iwlwifi: hook iwlwifi with Linux rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>
In-Reply-To: <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
	 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
	 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tqT6pm0jZ/eoPzfel/3s"
Date: Mon, 31 Mar 2008 22:23:37 +0200
Message-Id: <1206995017.5143.9.camel@johannes.berg> (sfid-20080401_124815_044445_34FC9507)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tqT6pm0jZ/eoPzfel/3s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +ifeq ($(CONFIG_IWLCORE_RFKILL),y)
> +	iwlcore-objs +=3D iwl-rfkill.o
> +endif

Btw, you should be able to rewrite that as

iwlcore-objs-$(CONFIG_IWLCORE_RFKILL) +=3D iwl-rfkill.o

and make the Makefile much more concise.

johannes

--=-tqT6pm0jZ/eoPzfel/3s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/FISKVg1VMiehFYAQLMOQ//Xzh/OLWmrLbyMTXb8ArL93tOmpFPN9rA
CPNbUeW/EY3otVVulLJT60IhYiTCQId3U1B+Ncm+VzbbKSDIsAbgoa4WY99cTPte
s9lSrbCfCOK8qNZCE3b8CaPbdyI0dgJ13Epca0Ob3uiHKRWv+75ienymToNC3fAo
viFIeg2Tky+BNJhc2vM+/D6u9/t1XCtc1rqbj6z2/sYR5BUe9XCxvTXTKQYfIZOr
ASc/rODh6uFTjS0AsFlhK8qNCJtFRw6JUtMbMaHEMZh4tA8XUupKaHjzXqwS1RvL
fe2f48/Jpj5yf7xl0GhgaLZWKC7hVtVbf2jaFjqIZrKXeS3dDaFcoeIt4v0X4JQ9
ykL6rKDk6zd/s/McY6IzAedBrZceuM38jF+Cr5EPa1C/x9Lv9QU24pC5bU0Rftd0
KaClVOTyh7DG1wiiqbcvkPuLI6kA3Dg8d9/WCr9A9R3rnH0nBCkDW/Imv7iVBbMg
eq9XmV+to6AXZPK7p3T4JPpAjxoGjxpzKrrR3EjfMlbtydCuf1AXQ9H373Kfwjl1
jnJ/2xapdr7Om+5yRESmtgPVmGDPynFVOg1vOH8GlXnA6vGktF1WImDtr9dFzngh
LbDsVtdaoUQmYvHRjp7Vhe7vweRNCK5ReoIaoVsmyv5PSbs7j26BoC7PCUvKTZ+D
bL5m8HdVwHg=
=YcB0
-----END PGP SIGNATURE-----

--=-tqT6pm0jZ/eoPzfel/3s--

