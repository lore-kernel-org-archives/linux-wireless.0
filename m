Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZELXUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 19:20:42 -0400
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242170080.5146.32.camel@maxim-laptop>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
	 <1242169934.14227.16.camel@johannes.local>
	 <1242170080.5146.32.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/UuSIco/gnX7WLoq7yxa"
Date: Wed, 13 May 2009 01:20:03 +0200
Message-Id: <1242170403.14227.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/UuSIco/gnX7WLoq7yxa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 02:14 +0300, Maxim Levitsky wrote:

> > So it's a bug in iwlwifi, it neither rejects nor executes a scan when i=
n
> > rfkill.
> But I use disable_hw_scan=3D1 !

Load the driver with debug=3D1 and see what it shows then. I don't think
there's a way for mac80211 to get stuck.

Also you could stick some printks into
net/mac80211/scan.c:ieee80211_scan_work() at strategic places and see...
but if they never happen you haven't turned off hw scan.

johannes

--=-/UuSIco/gnX7WLoq7yxa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCgQcAAoJEODzc/N7+Qmabv0P/jyPPlArsLCUqVSgCEH/o28J
+cmGliNRJjGdTCzg2DIA6WjUJUzFtXwccA+oVPvAygp5dzRYJjUdV28U2HS4PVOG
zq2J1nvyYShT68NWNnCbxcKKBse2f8m5GlKKMSVpyWvBBB2njW5BJ/e6Y2rLFPqv
vSgNU1Uj9ucbu3vqlHf5+oPtUfng19OOh4lqoTtg5EirjcTe8Ht8FzcxzplX1kEX
c4f5WwSSKTRO98fNlRMaaOrfbL96rMjUr7q1sGKrl+b5ks/WsDF1XVizjdC+Nlzq
r0X7VbmM9XMS/4cw6c6EHOtGUpFaJjLJo1shr8Tof7bO4OLdlpYCrhgo8QG4wVC4
EsMembKQlzIzevs2dQbJ+FuBrkhSEay5+dReNukkCmxWILUk8l2dfdo6gKGQNDDV
mjGUv1yoKuudoyImbPvodlALpYg/oqAEgTpnXiHp0GZ5g+GV3A0XKF06iCxpa2xS
0lWaKFfp+nVz9QFe8YtNmMSKfm5qYqQ4mPfU90Mq/NyuAxS+5eXlszI9ddRx86Ze
9B84Tzb09CKVfoyQxNH3dMJfW7cSoJsBuIjdqWPc2tZwfc5EMh7dj/T+4+bf00LH
Y8xwUW3GR/ku4/f/bI+t4msaOpo7NdVk3PmCAEEr+JheXRsegeKExwTaFxmDcN5R
flt5GKB8b1UXXGGKbNXh
=XPrm
-----END PGP SIGNATURE-----

--=-/UuSIco/gnX7WLoq7yxa--

