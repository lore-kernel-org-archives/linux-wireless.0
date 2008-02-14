Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYBNOMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 09:12:17 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <200802141519.38971.bruno@thinktube.com>
References: <1202209693.4395.29.camel@johannes.berg>
	 <200802121225.02045.bruno@thinktube.com>
	 <1202809819.11481.87.camel@johannes.berg>
	 <200802141519.38971.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vI52Ho4eBU/YVn4LfiWP"
Date: Thu, 14 Feb 2008 15:12:04 +0100
Message-Id: <1202998325.8931.114.camel@johannes.berg> (sfid-20080214_141220_527550_B857FFAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vI52Ho4eBU/YVn4LfiWP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> hmm, it seems we don't have a strict definition of mactime... the kerneld=
oc of=20
> struct ieee80211_rx_status says:
>  * @mactime: MAC timestamp as defined by 802.11

Heh.

> radiotap on the other hand defines it as the first bit of the data (MPDU)=
:
>  * IEEE80211_RADIOTAP_TSFT              u_int64_t       microseconds
>  *
>  *      Value in microseconds of the MAC's 64-bit 802.11 Time
>  *      Synchronization Function timer when the first bit of the
>  *      MPDU arrived at the MAC. For received frames, only.

Yeah I think that makes most sense and is how it is usually implemented
anyway.

> so i guess right now it depends on the hardware what we actually get as=20
> mactime...

> do we have that information for other hardware? is mactime
>  *) the TSF at the reception of the first phy symbol?
>  *) the TSF at the reception of the first data (MPDU) symbol
>  *) the TSF at the reception of the byte 24 (where the timestamp field of
>     beacon and probe response frames is)?

I very much doubt there is hardware that does the last option because
there may be frames that are shorted than 24 bytes :)

The difference between the first two options is a simple constant
(depending on the PHY mode) so the driver for hardware that supports
either one of those two options can easily translate them. Hence, I
think we should declare it like radiotap does.

johannes

--=-vI52Ho4eBU/YVn4LfiWP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7RMM6Vg1VMiehFYAQIVIRAAhFFDVTDimjxhyraJzmNqkCBQHL8k8fP8
BTMp5XzyVw+LAnBVhYACI4hjaaM4Kr3cLD7xI7ytT7s32vZlCfLVugTF6cmVJK5y
di44w3FNBSZddTGcQ0T19Rbfs705vnXvJnZAWMHvpX7LFviLkghVoZNVJ5KmmE9t
0tHoVMepSzE+J29U1NiJWI1V6bWwYDME60lAeT3Ke1/Ucfq2yVSiJI1ZKjh+IPAi
0iYMMq9KgqK2V4LL+7Fh39CGqfxu1cUbehRuNUo67U1wFJDu/0W6F93x6DGpMG1B
z7Y0+WhtyqROw/2L0N7GAYhpxfmAECKvB1qBYf/9sk1scIm7zLAKBVU0W7elxmCS
X6yRVVbdjVrH6Yuv9ybrNCCFf/0vzvIb/RExRuDs0MECQU2NdY4ICWzVxjlnaS4X
bWVNMaGSv9CqQI9PGa0iyk76IqEr6ezzcn93L4L6tBRwLPBCznZP3utzattHQci/
LaU4oGt8/RhMsiwGCGJwdFr6w+KKT/H1B/RXR9lbD+g8LAlQTNvKfFlN7YmW8lPM
ZbosJ+CCdMs/sFB70SKIis+WLTZROg8zQPaVauQK6foT3A/vvLpnC0W7dx4W2sSM
Q/kHBt1CmcTSqoufPR8UCZLBV9cYncz4iQ8/N/nFpa2joxfxoqYRf9wLS4k3oMzM
htR5UAVcQe4=
=7Y/u
-----END PGP SIGNATURE-----

--=-vI52Ho4eBU/YVn4LfiWP--

