Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238AbXBWWMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 17:12:05 -0500
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <45DF60F9.9090806@linux.intel.com>
References: <45DF518B.5060809@linux.intel.com>
	 <1172263955.3870.85.camel@johannes.berg> <45DF60F9.9090806@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9XnRkE5YajS4xWFyphNf"
Date: Fri, 23 Feb 2007 23:11:48 +0100
Message-Id: <1172268708.3870.98.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9XnRkE5YajS4xWFyphNf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


I guess this'll never end...

> -cfg80211-y +=3D core.o sysfs.o nl80211.o
> +cfg80211-y +=3D core.o sysfs.o
> +cfg80211-$(CONFIG_NL80211) +=3D nl80211.o

That won't work correctly. To build nl80211 as an extra module you'll
need obj-m +=3D nl80211.o, but to build it into cfg80211 when it's
NL80211=3Dy you need cfg80211-y +=3D nl80211.o

Could you live with it not being a module itself so we can just make it
a boolean and use the current way it's done in the Makefile?

johannes

--=-9XnRkE5YajS4xWFyphNf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF32aj/ETPhpq3jKURAutdAJ9LvWWKxDjJeXfU4PxUcWH+1F6IoQCeORzc
XWEq87R5++apURjkR0tvdu0=
=px0K
-----END PGP SIGNATURE-----

--=-9XnRkE5YajS4xWFyphNf--

