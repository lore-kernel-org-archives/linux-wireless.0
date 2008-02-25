Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYBYJ6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 04:58:37 -0500
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com> (sfid-20080224_162953_401206_88A34DC6)
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 (sfid-20080224_162953_401206_88A34DC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WdTHGSf7jpfjrz287W7F"
Date: Mon, 25 Feb 2008 10:51:36 +0100
Message-Id: <1203933096.13162.54.camel@johannes.berg> (sfid-20080225_095857_189232_809D21F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WdTHGSf7jpfjrz287W7F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  With iwlwifi, however, there is a possibility that it invokes
> >  ieee80211_tx_status() on one CPU while mac80211's tasklet is processin=
g
> >  another TX status that was submitted with ieee80211_tx_status_irqsafe(=
).
> >  Tomas, I think you mentioned that the TX status processing can't
> >  actually ever call the non-irqsafe version, can we remove that call to
> >  be sure? :)
>=20
> Actually alike athk also iwlwifi driver calls tx_status from a tasklet
> therfore the irqsafe can be removed. I've tested that it worked so far

Ok, fine too. Just the mixing is actually bad because of locking.

> However we added start_tx_ba_cb(_irqsafe) callback to get around AMPDU
> queues reordering
> In this case we have to use both handlers so I wonder where we have
> problem here as the same mechanism as tx_status is used.

I think the AMPDU stuff has its own spinlock around the fields it
accesses in those things. The thing with the tx status etc. is that it
uses no locking to update a few sta_info fields. If we added locking
around those accesses, mixing the two irqsafe/non-irqsafe versions would
be acceptable, but I don't see much point in that.

> In general I'm missing some asynchronous mechanism that driver can
> notify mac80211 about it's state.
> Except BA states there  is  for example  netif_carrier_off/on
> functionality in the driver level. It would be very useful for early
> notification of disconnection.  A disconnection can happen due to
> device resume or internal recoverable error. In this cases I would
> expect mac to try associate again upon such trigger.

I guess that's just missing. You can stop the queues but you can't tell
mac80211 that you reset the hw.

johannes

--=-WdTHGSf7jpfjrz287W7F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8KPpqVg1VMiehFYAQLLpRAAuy7AGxtWOC34Qn3u69w7FrazTL/KPnrM
81axD2rHssriZUeiBRt0vYndTpp1oH4kbtNLnh1/WO19+lCLPRTbpf5un6it4EZw
9fo6AG0N2lXsGyR2/gxDyVHW2i9xEwiITFXVHzIybaGrlx6LvAoqLRyYAN9u4+LZ
lVDQ+7VwglrCLthTetXJkex9lCR6D55efbB5AGQ0fIbT9kqUZb6dEzla0B2lTIm7
6T/vdeT9Z+ohCE27U1MJWZNrJ0mKy2F67jbPaT5rHIWWoKjrtLvAofqNOATPteQJ
g1zyURHM6UWV6+nN6JZsDcIuRN48OFoGiqP2vPz6gjKQszEMGrdlI2HnhsK16P5U
4iwB6bHi3aOzkY0lUmdSE0oxTDjV3NEyugvbMOlT54h1jbxz9+pg8k+pAS6P2UFv
CnZxfbnc/o8VhqHUkNgU1S8SNAnvPfirOUdQdZiUl3NVKS9Bx32Vvs2qeQ42EC8M
DS8QHyWqL+luWPn6XGCSkTHt2Auc5Z7W1v0wDCNMBPrMklJNPO0bYftXx5Sn5Bl0
cyIWCU1L2TqSaw5MAstu7wfqooA8ElI8Vy6nLRWBgAf31BIyqzwcpeXuVWOVMvk4
XZR97sPcO9WDEnvk0U7en0xCVvd6uAnPJdkx4Ww7tbpvcxE5uZB4VWDY8M+71f5I
SbL1GKLkNww=
=JWy5
-----END PGP SIGNATURE-----

--=-WdTHGSf7jpfjrz287W7F--

