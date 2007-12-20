Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbXLTMlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 07:41:10 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <rindjon@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com> (sfid-20071220_123256_636036_F688CFA8)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
	 <1198145667.16241.23.camel@johannes.berg>
	 <c85cb4470712200432w3640359dje70f57c86be3497a@mail.gmail.com>
	 (sfid-20071220_123256_636036_F688CFA8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mSWI7VR4UUs8S5YSHVdD"
Date: Thu, 20 Dec 2007 13:41:03 +0100
Message-Id: <1198154463.16241.46.camel@johannes.berg> (sfid-20071220_124117_571928_9AF79977)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mSWI7VR4UUs8S5YSHVdD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Also, what you're doing means that
> > the frame is accounted for channel load twice (yeah, I know, the stats
> > there suck... but still...)
>=20
> here i am already checking the .ordered field (like i proposed for
> monitor), and ignore the in-order frames.

Ah. You'd need to ignore the out-of-order frames too since they too have
gone through __ieee80211_rx already, no? Or do you by out-of-order just
mean those that have been queued?

> so you suggest to remove ieee80211_rx_h_reorder_ampdu in favor of a
> function that will call ieee80211_sta_manage_reorder_buf?

I guess the rx_h_reorder_ampdu pre-handler can stay, but as far as I
understood the flow it will cause some frames to be "buffered". And I
think frames shouldn't go through the same path twice even if you've
annotated that path all over skipping when the frame was injected.

Basically, it seems to me that you're injecting frames down the same
__ieee80211_rx() path when they have already gone through that, and then
after the fact annotate pretty much all of that path before the actual
rx handlers (after pre-handlers) with "skip if reordered frame". That I
don't really like, it means we need to special-case everything we ever
put there.

> 2 - (pro) yet, i'll end up checking the .ordered field in 3 places -
> monitor,statistics and reordering buf, which lowers the encapsulation
> of work inside ieee80211_rx_h_reorder_ampdu
> 3 - (con) i will have to free un-needed sk_buffs in
> ieee80211_sta_stop_rx_BA_session without going back to __ieee80211_rx,
>  which may confuse othere.

I don't think it's that confusing because __ieee80211_rx would do the
same thing, it would free the frame if requested by the pre-handlers
instead of passing it to the rx handlers. What your code does would
simply be a diversion through another queue that has the same effect.
(If you keep the rx-pre-handler for that you should add a comment that
it must be last)

johannes

--=-mSWI7VR4UUs8S5YSHVdD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2pi36Vg1VMiehFYAQIn7xAAueIKxOLZ9YUGoAkKnRCB+vJDexWjJz3T
43Wetmh4sbcyMaCm94ZHoWWmGjEFrM1WMa++CGb80j944QWIKU/xI8vaLOzYKMSx
jbFJWzH0xBcoNHD6EtkxbWaF/e9tGJj2PHWqrf6E08f3amsMIkkr2gJ5ggcbrsQ8
3KwqXV31dABOI/Z1xFv/qpAcfJMpHC25zG5k05oV6O0aTD6nQuwg1XMCgxNbi/CA
VnwA4/Kmc62vJzjU2S0C8x/3rH4JKyL7gND1JGJkpxSnUDN4I4/JYxYNywfRhKWS
lriGHRfJ/zxnCEj/Ee0x6ucC7wO5X+qJqGhXydA8axzznbuCatLvUlutsDn8/9r7
6fOBYTRs8qhv72ojozxMPyg4NKYXa75HL/XofiAC7wehObYOyVKy9OXPizV9Vaw+
bKnk0y/KcPf9/SO7Qcb4GQ1ZyIikeMThQL3YEsGycaaxayPfRR4JFi2DyqHpH7hj
1xsMDgnwejXzrCmb2xx2T6GpcgyYWVATcYyzJECwZ1FKizNjtMS7J4zIoZleHoJ2
ZsRhUpgWUhefaWqyq6GS4GtTxIAMJFvIf7WbcoIcjCoCs0vz0BJPzsMgF6rKV5nu
4GHK6MH3yFsiQ/+ipw3Qyd+w7YUjfynlp092qM3NFfR1RlCsG1JrtdPe0UN6OkH7
C3g64NZpfNI=
=bxwP
-----END PGP SIGNATURE-----

--=-mSWI7VR4UUs8S5YSHVdD--

