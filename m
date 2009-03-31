Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZCaRVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 13:21:25 -0400
Subject: Re: [ipw3945-devel] 2.6.29-wl-36116-g6a982a0: connection loss
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Nico -telmich- Schottelius
	<nico-linux-ipw3945-devel@schottelius.org>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238519733.10366.32.camel@rc-desk> (sfid-20090331_191007_889953_E44BBA1F)
References: <20090331044946.GA10616@denkbrett.schottelius.org>
	 <1238519733.10366.32.camel@rc-desk> (sfid-20090331_191007_889953_E44BBA1F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c0xlFWdFAxbT0Chr2Soe"
Date: Tue, 31 Mar 2009 19:20:41 +0200
Message-Id: <1238520041.5970.112.camel@johannes.local> (sfid-20090331_192129_990204_7A9B1D80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c0xlFWdFAxbT0Chr2Soe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 10:15 -0700, reinette chatre wrote:
> Adding Kalle and the linux-wireless list ... if anybody responds who is
> not member of ipw3945 ml, please consider removing that ml from cc list.
> If anybody on ipw3945 are interested in this, please follow thread on
> linux-wireless.

> > [ 3009.365039] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> > [ 3009.368315] wlan0 direct probe responded
> > [ 3009.368321] wlan0: authenticate with AP 00:14:6c:67:9c:32
> > [ 3009.370298] wlan0: authenticated
> > [ 3009.370304] wlan0: associate with AP 00:14:6c:67:9c:32
> > [ 3009.568063] wlan0: associate with AP 00:14:6c:67:9c:32
> > [ 3009.575107] wlan0: RX AssocResp from 00:14:6c:67:9c:32 (capab=3D0x60=
1 status=3D0 aid=3D10)
> > [ 3009.575114] wlan0: associated

There the connection is already not entirely reliable -- needed two
assoc messages to get through, despite retries.

> > [ 3009.581276] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > [ 3020.000031] wlan0: no IPv6 routers present
> > [ 3151.295473] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 4191.742593] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 4193.740066] wlan0: no probe response from AP 00:14:6c:67:9c:32 - dis=
associating

Here you have (look at the times!) the probe request once getting an
answer, and once not.

> > [ 4321.376160] wlan0: deauthenticated (Reason: 7)
> > [ 7337.805893] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> > [ 7337.810976] wlan0 direct probe responded
> > [ 7337.810983] wlan0: authenticate with AP 00:14:6c:67:9c:32
> > [ 7338.008060] wlan0: authenticate with AP 00:14:6c:67:9c:32
> > [ 7338.010087] wlan0: authenticated
> > [ 7338.010093] wlan0: associate with AP 00:14:6c:67:9c:32
> > [ 7338.018590] wlan0: RX ReassocResp from 00:14:6c:67:9c:32 (capab=3D0x=
201 status=3D0 aid=3D13)
> > [ 7338.018597] wlan0: associated

Here auth needs two tries.

> > [ 7572.146385] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 7702.189368] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 7962.173161] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 8092.216232] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [ 8094.216137] wlan0: no probe response from AP 00:14:6c:67:9c:32 - dis=
associating

Here you have three probe requests over quite some time sometimes
getting answers and at the last time not.

> > [ 8221.952208] wlan0: deauthenticated (Reason: 7)
> > [33012.904311] wlan0: direct probe to AP 00:14:6c:67:9c:32 try 1
> > [33012.907527] wlan0 direct probe responded
> > [33012.907533] wlan0: authenticate with AP 00:14:6c:67:9c:32
> > [33013.104059] wlan0: authenticate with AP 00:14:6c:67:9c:32
> > [33013.106102] wlan0: authenticated
> > [33013.106107] wlan0: associate with AP 00:14:6c:67:9c:32
> > [33013.114796] wlan0: RX ReassocResp from 00:14:6c:67:9c:32 (capab=3D0x=
201 status=3D0 aid=3D14)
> > [33013.114802] wlan0: associated
> > [33053.635621] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request
> > [33183.267415] wlan0: beacon loss from AP 00:14:6c:67:9c:32 - sending p=
robe request

etc.

> Perhaps the new beacon filtering work [1] is changing more than it
> intended?

I think it only changed the messages here. Previously, that message
simply wouldn't have been there, instead you'd only have seen the "No
ProbeResp from current AP - assume out of range" thing.

johannes

--=-c0xlFWdFAxbT0Chr2Soe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0lDjAAoJEKVg1VMiehFYDIYP/Raoh3zqAV/j/z4/1P0zLynj
FeNS9RlXkbgdpsuP4/EZGQOMJMoxEmRQsqFx6b8nMD9Dxrawy2o1uNSzc4ApxIZ2
Myrwdu+U7UAQ4Mk4vJcTfoKWs2Fklo8uWkrFcbS0CsgF4ATSSgEoEekJtIYVE4Ny
uONIwawijPIn3gde/alOnAXvPDmZh4UJAwyK60juIzEfST3rBbHz8nWsv+spFM9d
5xzMRr1SQvLxKTYl3rDcwr9Vy680+GbZxpvTVlQZTC6hSt/dLPZUbCwYxSsIR+BM
HJfxXohl6KasJYsOPx173cpLASxT0R/xW74d8szOSzmRDzZDG7AOjkfqO/gGCYJj
Ibm1wWk5z+ku45hCZdG5GqIbJIZlMDMUlLfJNfXxgBx/iwNapDW2ACMa+QpvVOjo
5087IRx3tfLCAn+viaZnHiApO+yB+BhLkFJ/2wsQPZfY+9GjD08iguhCrME74yVv
SFYpR07TtWfqNNYv6vF8NFVzFEB0c6gQhkheWtL4XjWZsv5H3hD2/OJM+OqKr6Yg
3YzHfqCKV/rTgO/eUi0qdunGqSDMFxihMz3kE9W4wc93i6WScFOya7HrMjGRUReD
kA0kihpjoThDBiAwhfQ/VtoH6sf/sLHMpy6s4IKjJkoUeg5e3d56O95dBnz/lZJi
ZXPXiQClGRoYppKV+rBX
=nTbc
-----END PGP SIGNATURE-----

--=-c0xlFWdFAxbT0Chr2Soe--

