Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423003AbXCBKQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 05:16:49 -0500
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E7DF58.6080608@warmcat.com>
References: <1172774065.3381.3.camel@johannes.berg>
	 <45E72174.9060104@warmcat.com>  <1172775866.3381.7.camel@johannes.berg>
	 <1172776049.3381.10.camel@johannes.berg>  <45E7DF58.6080608@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X+6nC/yfSdqk9UW5tVF9"
Date: Fri, 02 Mar 2007 11:16:22 +0100
Message-Id: <1172830582.3482.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X+6nC/yfSdqk9UW5tVF9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-02 at 08:24 +0000, Andy Green wrote:

> I guess I'll stick with sysfs for now since the code is written already:=20
> if I will find add_iface and so on down there then I guess it will all=20
> work out with minor edits.

Just make sure you're running the very latest kernel with
CONFIG_SYSFS_DEPRECATED disabled (I think that's necessary, not entirely
sure). You'll notice when anything but the current CVS version of HAL no
longer displays network devices :/

> Can I ask how stable this byzantine path I am currently following to get=20
> a "Management interface" for tx injection is going to be?  Not even=20
> standard wireless ioctl but Private IOCTL SIOCIWFIRSTPRIV+0 opens out=20
> into a secret garden of "PRISM2" special features... is this already in=20
> a little black refactoring book somewhere?=20

Yup, it is. But there's still debate on whether it should be done
through netlink (nl80211) or some new special injection format for the
monitor interfaces like the management interface currently has.

[you can rip code from wpa_supplicant to inject frames]

Btw, here's another argument against the monitor interfaces: having them
up takes the card out of powersave mode which they should only be while
not associated, even with a userspace MLME.

johannes

--=-X+6nC/yfSdqk9UW5tVF9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5/l2/ETPhpq3jKURAkFwAKCXgBlwioMajx8Q04abiKnjd1Z4WACfXNLV
LCuETdkKJl7jgLpuaTorPCk=
=56ip
-----END PGP SIGNATURE-----

--=-X+6nC/yfSdqk9UW5tVF9--

