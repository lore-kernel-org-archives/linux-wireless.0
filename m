Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbXKPLwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:52:44 -0500
Subject: Re: Suspend/Resume support
From: Johannes Berg <johannes@sipsolutions.net>
To: Li YanBo <dreamfly281@gmail.com>
Cc: Ben Gamari <ben@mw0.ath.cx>, linux-wireless@vger.kernel.org,
	Jose Ignacio Naranjo Hernandez
	<joseignacio.naranjo@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com> (sfid-20071115_033727_558011_30954D13)
References: <1195087905.3814.11.camel@mercury>
	 <1197ff4c0711141937gc7bb1f8w499cd9d8634fa232@mail.gmail.com>
	 (sfid-20071115_033727_558011_30954D13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HUR58b7hY0xRqv1ig/oE"
Date: Fri, 16 Nov 2007 01:11:09 +0100
Message-Id: <1195171869.8147.79.camel@johannes.berg> (sfid-20071116_115247_716310_EDB2272D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HUR58b7hY0xRqv1ig/oE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[reordering quotes]

> Hope below link is helpful:
> http://kernelnewbies.org/KernelProjects/Mac80211Suspend

Indeed, and somebody already "took" the project on
http://kernelnewbies.org/KernelProjects/.

> > Some time ago there was discussion on this list regarding suspend/resum=
e
> > support in mac80211 (See 05 Aug 2007, "suspend/resume support in
> > mac80211"). The conclusion of this thread was that mac80211 had no
> > suspend/resume support and that functionality to stop the stack needed
> > to be added to fully support suspend. Has anyone started working on
> > implementing this functionality?

Jose told me he has started with reviewing the code.

> > Might this be a project that someone not presently
> > familiar with the mac80211 codebase could tackle with some guidance?

Yes, I think this is doable, although recent work wrt. 802.11n might
require more thinking.

> > If not, precisely what needs to be done to add robust suspend/resume
> > support to mac80211?

Well, that's really a can of worms. For one, you want to have as
seamless operation as possible if you're like me and just quickly
suspend the laptop to swap the battery because the one you're using is
running out of power. So that would usually be quick enough to make you
not lose your association. Obviously, hardware still loses state so
keys, BSSIDs and all other configuration needs to be programmed into the
hardware again. The driver shouldn't have to handle that except notify
mac80211 that the hardware was resumed and needs to be reprogrammed
which would cause mac80211 to call the appropriate callbacks.

On the other hand, if you've suspended for a longer period of time, your
AP will have kicked you off for not responding. This means you need to
associate again (not even reassociate [1]) if the AP you were associated
to is even still around. If kernel roaming is enabled then you would
want to try to associate to another AP in the same ESS, but I think the
state machine would do that automatically once it determined that the
connection was lost. Unless of course it gets stuck in the "can't do
anything" state Stefano was complaining about.

Now, consider the wpa_supplicant case. wpa_supplicant typically will
disable kernel roaming and choose an AP on its own. This is another case
we need to handle well, in the first case (just a short suspend) it's
not really necessary to do all the crypto handshake again etc. This
needs some thinking. Also, the integrated userspace MLME will have to
handle all this as well so we need to be able to notify it about a
suspend event in some way [2].

I guess the way to handle it would be to send a probe request to the AP
we're associated with first to see if it's still in range. If it is, we
need to determine whether we were suspended long enough for it to kick
us off. It might be possible to do this by sending a null function frame
to the AP and see if it replies with a deauth notification, I think it
should if we're not associated [3]. But then again I'm not sure whether
we should rely on this. Another option would be to send it a reassociate
request, it should simply respond with an OK, otherwise it sends a
disassociate so we automatically restart the state machine and send
appropriate notifications to userspace.

Whatever implementation you come up with will have to be duplicated into
wpa_supplicant's userspace MLME as well.

As you can see, it requires some creative thinking and probably fairly
good knowledge of the standard but less so knowledge of mac80211. Sure,
you need to know how to reconfigure the hardware at resume time, but
that shouldn't be too hard. Beware of locking problems when drivers call
a function that calls back into the driver :)

johannes

[1] the IEEE 802.11 specs define "reassociation" but that requires the
AP keeping state about you which typically they won't do long

[2] and no, system suspend doesn't cut it because we may be selectively
suspending just the wireless device or USB or ...

[3] not sure. reviewing the 802.11 spec didn't find anything useful.

--=-HUR58b7hY0xRqv1ig/oE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzzgHKVg1VMiehFYAQKS8g//QN6N20kKZtnWHB9g4UeCCgMXl0ctkRa6
dsH5sMbAdcnFdZjQybqyD5zNs7ZMIOXLGU2odXpuimcBYVH/E2QLM17S0ijlLpZK
xTrPU+7X6ZD6eaq5Cx2ORlCN1zl1P8NhU+X6o2HOGYaFhIQHYQGfab0NpuhYZHMU
Cia+ozWEewfHdzCExhChp+hPgawFtZb4CDnSl3bOe/X913FMct6sIklBfEanDb7f
BJ8AhQWgwAHXyg+snVBqAGZWIkRWu7M2IyBsns8fDkr3vKOECWSAzk53HwLAOlQX
bM3/PH3mmDB+iBOVRjqExikUnhlOTT/InrMjKtw6+dK+vyBaMpEXXYtlMMX2Jnlw
ZeCzHh9rtcVRyKtKOXwoaZeS6d5gNomUIT8h2yuwe2rhwypgTUFGxgZaAu2jv+gi
+FKhqkghb/AF3+AqDPIS8Xh8QKVqWU2bsB0cOmuoS6wC319EiE7jNXvU5lcP4dt0
yxAjeoM8kRU0cNysl9AwYLkfiKZ+lJTbepNqECOhey5Qg7LTl/jgGAp78+J2Kl8Z
RYG9r3H9kNve3MFq5bHGnZ4Pl0/TfJqunlCp/QHNFoZKfXeh84b8a4MOHe33BZl2
Gcu1+hUrFm+yEYZTYjCnO6GzkIlvyKtgu/ZUEwSPTRnGluPPpoqq2Jq5TDYrxyCO
wDZOl9FtFaI=
=DLXC
-----END PGP SIGNATURE-----

--=-HUR58b7hY0xRqv1ig/oE--

