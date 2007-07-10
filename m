Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979AbXGKJlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:41:09 -0400
Subject: Re: repeat scanning could cause disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: mabbas <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <468EB36C.10508@linux.intel.com>
References: <468EB36C.10508@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rSh+/q+/OKoUQmtiwiS3"
Date: Wed, 11 Jul 2007 01:11:52 +0200
Message-Id: <1184109113.3738.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rSh+/q+/OKoUQmtiwiS3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> If I keep repeating scanning for like 4 times in the raw, the mac80211=20
> can disassociated because No ProbeResp.
> looking at the rx patch if we are scanning we wont pass=20
> ieee80211_rx_h_passive_scan which only will deliver
> beacon and probe request, which what we want, except that we only update=20
> last_rx in the function
> ieee80211_rx_h_sta_process which is two functions down rx handlers.
> In iwlwifi we do perform hw scan, in this command if scan takes a long=20
> time, and we are associated, it will tunes to associated channel to
> allow getting beacons for a period of time, then continue with scanning.=20
> we do receive beacons on the associated
> channel but mac80211 never update last_rx causing the disassociation.

Interesting. If the scan takes such a long time, what do you do when
there are actually data frames coming in during the time you listen on
the associated channel? I think you'd have to buffer them because they
also would be dropped by ieee80211_rx_h_passive_scan...

> I wonder if we can move ieee80211_rx_h_sta_process before=20
> ieee80211_rx_h_passive_scan or at least the rx_last
> update part.

I guess we could, the intention of the check is probably to find going
out of range or such rather than disassociating when you've missed too
much traffic :)

Michael, you gave scanning and background scanning much more thought, I
can see the problem here but not the solution. Shouldn't we be doing
this back-tuning in mac80211 too then?

johannes

--=-rSh+/q+/OKoUQmtiwiS3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlBI4/ETPhpq3jKURAo+SAKCMgj/NiilEwnLQIg1iO+TpYl8pMACfQ2YH
VJd0XaLl0/n01U2OVQVucEQ=
=HqjQ
-----END PGP SIGNATURE-----

--=-rSh+/q+/OKoUQmtiwiS3--

