Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbYBUJYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 04:24:16 -0500
Subject: Re: [PATCH 00/13] o11s: mesh interface support for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1203455604.31736.23.camel@localhost> (sfid-20080219_211155_468318_170E0D1C)
References: <47a78212.15588c0a.27b2.61d2@mx.google.com>
	 (sfid-20080204_212233_169667_739F231D)  <1202343188.9965.41.camel@johannes.berg>
	 <1203455604.31736.23.camel@localhost>
	 (sfid-20080219_211155_468318_170E0D1C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4JImivoEWWk/Tsm/7CEV"
Date: Thu, 21 Feb 2008 00:42:46 +0100
Message-Id: <1203550966.17534.115.camel@johannes.berg> (sfid-20080221_092525_634385_5B9A419C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4JImivoEWWk/Tsm/7CEV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Currently, bss are sorted by ssid, bssid and frequency. In mesh beacons
> and (not yet implemented) mesh probes, the bssid is left zeroed and
> there is no ssid (actually there is a 0 length ssid IE), so all mesh
> networks in a single channel would collapse to one scan entry. I can add
> the mesh IE, but I also need a substitute for those.

Ok. I think you'll have to rework the scanning code to not just use
SSID, BSSID and frequency to distinguish between networks but also the
mesh information (mesh ID/mesh IE).

> One option would be to use mesh id as bssid and source address as bssid
> (with this we would get a different entry for every mesh peer in rage,
> not sure if that's what we want), maybe set the mode to IW_MODE_ADHOC
> and add the extra mesh IE. This way we would not need changes in the
> wireless extesions layer.

Dan said:

> Yes.  Ideally the driver will report mesh networks too, perhaps with
> IW_MODE_MESH or whatever nl80211 would use.

As unfortunate as it may be, we can't add it to wext cleanly because
iwlist would probably simply segfault if we added a new type since it
doesn't verify any input it gets from the kernel and just uses it for an
array lookup (thank you Jean!). Or we add a new type and just let all
userspace segfault until it's fixed. It's not a kernel bug, after all...

We can always include the mesh information in the GENIE element and
interested parties have to parse it... however, we can't set the type to
anything useful. If we set it to ad-hoc, then tools like network manager
might try to use that network for ad-hoc which won't work. It would
probably be best to leave out the SIOCGIWMODE info completely and hope
that tools that aren't prepared to handle it just ignore that...

Ultimately, I guess we're at a point where wext reached the end of its
usefulness and we seriously need to look at getting a replacement done.

> I am also curious about the interfaces life cycle. Looks like interfaces
> report any available network (infra or adhoc), regardless their type.

Indeed.

> Then a network-manager-like interface would have to bring up an
> interface to be able to scan, and the if the user chooses a different
> kind of network (if the interface where the scan is performed is infra
> but the user chooses an ad-hoc network), change the type of the
> interface and the proceed to connect. Am I right?

Yeah, it'll even have to set the interface down to be able to change the
type.

johannes

--=-4JImivoEWWk/Tsm/7CEV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7y69aVg1VMiehFYAQI8chAAtBShHRJQwYTWuZFnLURWFgdCcIwOBYKR
vH6vJHh3SH0pHLSMJjo+LOuQhTUNTagEFZzZ3heh51lOefLzIPbrHEhauMTWmlQg
GBnnAWnlV5REOVpcdROe7NSMngBoZbP4dIjiJbMifjoM5VNcTzbYrJGeDhxWfffe
+t2Cvl0N+olUIXseXOhIwVyFWiYJseGbrBYpVvv/1GbXne05XcjqZV5c1BkuyPse
GeOmIn44MXQH4qT53whfP8p6nvE159WTaeqWS5g6o9mJZxzbWyfolYOqUzEC8utu
XasmvAr1j02qD8sBeHwL+3ASNktSL2Aw7rpdOKwJZ5nB4YtRX7YPxjCo8f5Pnl6C
O+LPUDbqEiCTWOYe5w7JmgsSnbUWGv5qdO+m25FIcLFPVVEfGOGgiZ6cup2XtZLm
dbslocuLvwqg3no0w7Ojo4z9zfXcd7EJOdtA5KSQGSO3tBt54xCjxOBm2A5K6LgU
4EwKAxyDO6HR3mo64DhDrfyMIwZmDy3dffz1Em99h18Jlq/UxJzBuOSac/2Zx4Y6
mEd8V2IWqq8YGu2eA3nsJYfBElD4F0m5ulajxYKwT4Ce6NEE4roFLZ5Wu+3A48HR
vijp9sIyFVYgkFpT/knaVdn+ZwQ7k0E+OyKMqWaI/vHbiE0TrfYTQq7tLV3MxOsT
p5UHCPOiZ3E=
=xLFt
-----END PGP SIGNATURE-----

--=-4JImivoEWWk/Tsm/7CEV--

