Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJFI5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:57:55 -0400
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Holt <holt@sgi.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20081006064509.GK8534@sgi.com>
References: <20081004103144.GI8534@sgi.com>
	 <1223165956.24551.76.camel@johannes.berg> <20081005023143.GJ8534@sgi.com>
	 <1223195921.24551.79.camel@johannes.berg>  <20081006064509.GK8534@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6phA9tf2LnY3of94Zmvy"
Date: Mon, 06 Oct 2008 10:57:50 +0200
Message-Id: <1223283470.24551.86.camel@johannes.berg> (sfid-20081006_105759_700492_57A471A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6phA9tf2LnY3of94Zmvy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 01:45 -0500, Robin Holt wrote:
> On Sun, Oct 05, 2008 at 10:38:41AM +0200, Johannes Berg wrote:
> > On Sat, 2008-10-04 at 21:31 -0500, Robin Holt wrote:
> > >=20
> > > Will try it.  To reproduce, suspend, wait 5 or so minutes, resume,
> > > repeat until your keyboard leds stop flashing (usually within 3 or so
> > > cycles).  I think this will kick us out of the loop.
>=20
> It worked fine.  It makes sense why it works, but it feels like we are
> working around another bug instead of fixing it.  I certainly do not
> have any idea what I am talking about here, so feel free to tell me to
> shut up ;)

"shut up" ;)
There are reasons that debugfs addition can fail, while most of them are
error conditions that seems no reason to lock up here.

> CONFIG_MAC80211_RC_PID=3Dy
> CONFIG_MAC80211_RC_DEFAULT_PID=3Dy
> CONFIG_MAC80211_RC_DEFAULT=3D"pid"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=3Dy
> CONFIG_MAC80211_DEBUGFS=3Dy

Your config doesn't seem anything out of the ordinary, would you add a
few printks to ieee80211_sta_debugfs_add to see where it drops out?
Either way though, we should handle errors from debugfs_create_dir()
which this patch boils down to.

johannes

--=-6phA9tf2LnY3of94Zmvy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6dMKAAoJEKVg1VMiehFYZ30QALFK2RnfoJhDrgU69Lq/VpkL
zQLqjGxmmialKnDhRrsB2+Kc6UjdvueUwQ9FHHKUNmyM++VPJ8TfkgW7wVN52d3U
n7Nmn5H+58DrW/Om1+Sg1DFrd4cnwDj6PdUSCj+byxpgYeK04WNQMlpuNa6NiCAl
M8hSGlidrWeK0h9oFmq+ulB9eUEcMgG1j7Jy6Qrkumc50/cgEmQydtjCyzCJ7/MT
s8FNRd5IvmJjhBmAfAc/k61WN5ysxxODsCVOEGHas/4XcHc0B1ax3XxsTDqZbS+o
pGIHALSxMFA9xbGwdyMHdhxjg1muwG4ZPgUct1qjz55WFQ1+rfG3QBtkpzgTUGhh
GlvCByUdrt8QREQ2iQwDE+Q4LL5nYQAEXeM/Ae+nH1Ue4c7sIbFiUMfwdPITjAj2
1pCqwfR2AfzY76hoqilCJAuoecMDy98W849UFSIdO0WjQCvGhX6sD8FDB+LdqW1Z
ySNZRSiuYX/4JiqZALRKALBBpUhzV91vaIB97zp0i5NqN6M2mIu53aTWe3vAOeP1
wJbQN0n2q5l4q0v0SRw4FwR9UfMxsMXeEqY3+Vu1R00zPh6M58P4q/EL2TyXKRzH
N/L6Rd6jIgi5hg+RiyBccxfmmeYI92XsAOgAYbdm6Tq9mcWGjk6MVZh4jx9Ocmyq
ZvxRAtJ6riDspUA/PlKz
=z+FT
-----END PGP SIGNATURE-----

--=-6phA9tf2LnY3of94Zmvy--

