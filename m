Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbXLTKh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 05:37:29 -0500
Subject: Re: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070782762-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782762-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SCcT89Un5fd9SxJLtnBn"
Date: Thu, 20 Dec 2007 11:14:27 +0100
Message-Id: <1198145667.16241.23.camel@johannes.berg> (sfid-20071220_103734_404818_4F760F34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SCcT89Un5fd9SxJLtnBn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

> This patch handles the reordering of the Rx A-MPDU.
> This issue occurs when the sequence of the internal MPDUs is not in the
> right order. such a case can be encountered for example when some MPDUs f=
rom
> previous aggregations were recieved, while others failed, so current A-MP=
DU
> will contain a mix of re-transmited MPDUs and new ones.

I thought about this a bit more, here's a counter-proposal. :)

Your current patch means that when a monitor mode interface is up, it
will receive frames twice because the A-MPDU frames have already passed
__ieee80211_rx() when they were sent up by the hardware, and that copies
the frame to the monitor first thing. Also, what you're doing means that
the frame is accounted for channel load twice (yeah, I know, the stats
there suck... but still...)

What we'd really want I think is to
 (1) put the frame to monitor regularly [indicating A-MPDU in the
     radiotap header, this will need radiotap standard work, so not now]
 (2) "keep" the frame in the ieee80211_rx_h_reorder_ampdu rx-pre-handler
 (3) "release" the frame with an appropriate status later

Hence, I think it'd be best to first reorganise the current code:
 (1) split __ieee80211_rx() right after the pre handler invocation and
     call e.g. __ieee80211_rx_handlers() which contains all the code
     from "if (sta && !(sta->flags & (WLAN_STA_WDS | WLAN_STA_ASSOC_AP"
     to "} else dev_kfree_skb(skb);"
     The function would have certain requirements like a filled
     ieee80211_txrx_data and running under rcu_read_lock().
 (2) then, you don't need status.ordered but can drop the frame right
     away or pass it to __ieee80211_rx_handlers().

That way, we guarantee that each frame only passes through the complete
RX path once and your dropping the unordered frames is equivalent to the
reorder_ampdu handler having an oracle that tells it which frames to
drop and which to keep :)

Comments?

johannes

--=-SCcT89Un5fd9SxJLtnBn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2pAgaVg1VMiehFYAQJ6uA/+JdMaBF1at5vLCxpbk82sdAyAp/rWlta+
TqfIvG7Be74INA5jDDFUrwebu34JiekHVnKZ81mf54WU+jRFgvnPKUm1b9tedKHG
SGtw/HMP3SltqYGpJW/FN7SZFdz544VFf4oUnVpLcSiSeQDTg8eLF9hNyjTyDh0Q
bda+y/DPE0z8vWCqAYMZXJwI3iNNqEFEA3OIu2Mxm53OEjFlisXlZ4e0AmmE2/7h
XfEmmpnwkFHpvjci2Z2jclw696GZv860mLPG4Hrpvo86JPG7/4ASVUfv6uZU3nE7
OfTc2qmEJK4jcm+jlIrv7ZnJLDn6AYKWnw9O/UqL/hFGyyBcEOEEBwk+bsQ7WNRo
VG8aPAK70/sKVB2r5G3g9wj+Y93KQNooVeCJ1fdFytW8Zho4vhj+UJpLiogmQwQq
ZFqDRGnJY4iZfCPI3U5FwX6fLAjkTWVT3h9kR7KcGHtBGFeqX8vbRGRM0BnGqWRp
RuQybIhRaSDIN1TwWHOvzGuGU56Hp3jJfOY0xv+/lF7HyY6PGKOnTJhRzWGd4BYA
CDEDaIZrMlTVzXNWvLbGBBTWhVuSwLyX9gI3UYrgBWkmqRuju/u/v68IScKWShTe
7YY9eq4Bbhcha6xZI4yH7PwcGpUDZ4jN075AmDq82KDhD9gQ9mxWIz/QUreR1CrU
zHsnYwxwXoI=
=p9UO
-----END PGP SIGNATURE-----

--=-SCcT89Un5fd9SxJLtnBn--

