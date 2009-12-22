Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZLVJKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 04:10:34 -0500
Subject: Re: Bug#562016: kernel WARNING in cfg80211 module
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joseph Nahmias <joe@nahmias.net>, linux-wireless@vger.kernel.org,
	562016@bugs.debian.org
In-Reply-To: <1261439441.25157.307.camel@localhost>
References: <20091221232801.3371.80870.reportbug@wakko.nahmias.net>
	 <1261439441.25157.307.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aA5Zh/t8V77BYnum8HdC"
Date: Tue, 22 Dec 2009 10:10:21 +0100
Message-ID: <1261473021.22748.36.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aA5Zh/t8V77BYnum8HdC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the report.

On Mon, 2009-12-21 at 23:50 +0000, Ben Hutchings wrote:

> > [   65.034652] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> > [   65.036737] ath0: direct probe responded
> > [   65.036746] ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
> > [   65.038335] ath0: authenticated
> > [   65.038367] ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
> > [   65.039861] ath0: deauthenticating from 00:11:95:77:e0:b0 by local c=
hoice (reason=3D3)
> > [   65.039924] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> > [   65.040335] ath0: RX AssocResp from 00:11:95:77:e0:b0 (capab=3D0x421=
 status=3D0 aid=3D2)
> > [   65.040342] ath0: associated
> > [   65.041219] ------------[ cut here ]------------
> > [   65.041255] WARNING: at
> /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/net/wireles
> s/mlme.c:97 cfg80211_send_rx_assoc+0x14d/0x152 [cfg80211]()
> > [   65.041263] Hardware name: 7658CTO

> > [   65.041486] Pid: 761, comm: phy0 Not tainted 2.6.32-trunk-686 #1
> > [   65.041491] Call Trace:
> > [   65.041506]  [<c1030a5d>] ? warn_slowpath_common+0x5e/0x8a
> > [   65.041515]  [<c1030a93>] ? warn_slowpath_null+0xa/0xc
> > [   65.041540]  [<f86cafc7>] ? cfg80211_send_rx_assoc+0x14d/0x152

> > [   65.042191] ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
> > [   65.057483] ath0: deauthenticating from 00:11:95:77:e0:b0 by
> local choice (reason=3D3)
> > [   75.816298] ath0: no IPv6 routers present
> > [   91.680596] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> > [   91.737568] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
> > [   91.738236] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [   91.906035] ADDRCONF(NETDEV_UP): ath0: link is not ready
> > [   91.909344] ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
> > [   91.911254] ath0: direct probe responded
> > [   91.911262] ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
> > [   91.912923] ath0: authenticated
> > [   91.912958] ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
> > [   91.915043] ath0: RX ReassocResp from 00:11:95:77:e0:b0
> (capab=3D0x421 status=3D0 aid=3D2)
> > [   91.915051] ath0: associated

This appears to be another race condition, note how the deauth request
comes between the assoc and assoc response. AFAICT it is mostly harmless
except confusing events will be sent to userspace. I'll look into fixing
it.

johannes

--=-aA5Zh/t8V77BYnum8HdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLMIz5AAoJEODzc/N7+Qmai8gQAMuZTA6NkSXx7UcFv2p0RmT2
k1kBUmrOoqjxBk173xwmnR64oUmc7VuXh77Y1mojC7NLupBymRKIXB/WMdbrtb1W
0vav9jCOq6j8ne8oJ11/599GpHIXYCBEobHS5jrib82HCDi0AVWnjpnLIdEbeU9G
POgo9XpTDhPFvuSEynbCDsewGbq8jLdROaF9TH7l6sAh3y//Uvc6+absrAf88Anl
KhJ5uW8TZJ7NkatUPTIRQ4ra3g7iwlNNdYfYwbIk6NAA/wnpkfk9udJaIYvZ7eBs
MTY/YgAYLjwsCGOZ7BOJv3ZQrfZ7ii01GDWr+1iLJp5wwPjlbKJYLDsKACA/Kfr5
qaGv0PR9l6vYR2s4dB0eeC3m15qKWZRxH6SqGufX2FzvSwpGU/VuVcmXN5C1EliR
QwKbYGcDIr3TbTT7xxd486LsKU7//YF9aVAzO+fTw+yjgVi6RNKA0nB8rzqePFG9
KQ5kOGn7lk035uNzIsvk5mflLrDDEwPOA7jAuQa6vKV+kOHhywd9f58jo8d98ivK
bI8PmPmYgFhzzdNFAt5+b6dEtIMZx2DpripTSlCGdu6TONtcuiXktXO/tLvQmj9r
aRtK/8CClShrmWqDFSevFqU2aY24/gGkEeRHmlHLNDdqeQ1AhHhxH6ETk6fLbLjR
TqEY7kYDeI5BjS+n7mmq
=+bh/
-----END PGP SIGNATURE-----

--=-aA5Zh/t8V77BYnum8HdC--

