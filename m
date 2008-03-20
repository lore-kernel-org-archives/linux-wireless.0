Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939917AbYCTANn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 20:13:43 -0400
Subject: Re: [PATCH] iwlwifi: prevent tuning during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_234534_228497_EC4DD4E8)
References: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080319_234534_228497_EC4DD4E8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4rRIIQbXyO2JRD4DskME"
Date: Thu, 20 Mar 2008 01:13:27 +0100
Message-Id: <1205972007.16475.90.camel@johannes.berg> (sfid-20080320_001348_402965_30C198B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4rRIIQbXyO2JRD4DskME
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +		if (ieee80211_hw_config(local))
> +			printk(KERN_DEBUG "%s: failed to restore operational "
> +			       "channel after scan\n", dev->name);

Also, the message is wrong, it's correct for the sw scan case where we
in software leave the 'operational channel', but in hw scan case this
can really only ever make a difference when the channel was changed by
the user during a scan.

Maybe a better solution would be to make the ioctls wait for the scan to
finish?

johannes

--=-4rRIIQbXyO2JRD4DskME
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+GsJqVg1VMiehFYAQLrvA/+M8K8LQbvPqZTdmw9YqahvhTeXe9F/gBX
vWOMJzRDVnK4amAuYKNPn6lVzrZWh+SF8Clvwee5zbInmhYddAOoiCco1+BP68on
N8zMs3f5wrhHgR/TZLif0AXfchPYMXg9c9+/wyPD61Y9MTDodYyv9H35JmIeKJNp
9FkXvzOk8jgFjVkmsVanluR4BBElg7IcwrJZiVwjOUNm64nyB+AVbntRLsw+JxgM
iM83wMnMj5T6Uyy/dRFuvib7IGteJtGubp3e0gUbr775YEkGeXmRbabMbNtOvgyp
Ml89roP2Y+45ZXKaSI+TPAgzW8qmVvn7AvGDcVgzu0VexG0jlMUnJuHpRTZAUc17
P9Tq/DPTQnWxGPBbDvGZcoNPITft4h2JmYN9hdUiF+qkoLd6/zPG2NA/25crzc8B
nz0jjFkZCWjbbX+goMvhX9E0Az9zivzqH5p3hAXOnMnr9g3pW/VG6f+e3aOcs+ih
iu3tQCC9zopfRUQT/bbHw/pBYcsYCH61akli0P/rpemHURQ68XAmKicQx802Gmkm
X6dIPN334HtDjBsckP5dEGD7v6jHhioSVgfegKrPrPWtpsezpr7RHJU0PsdTXbcI
g5ZLVqav3uCeqb6dBiamcAZ9M8PXFEvymRK9zfxF8wSTXaf4WjfYGYZDgWeWcS7R
Ei0kQiBeDac=
=rsUJ
-----END PGP SIGNATURE-----

--=-4rRIIQbXyO2JRD4DskME--

