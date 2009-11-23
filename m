Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbZKWKlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:41:42 -0500
Subject: Re: [PATCH 6/6] mac80211: Allow extra TX headroom to be consumed
 by drivers.
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1258960565-26736-7-git-send-email-gwingerde@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-5-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-6-git-send-email-gwingerde@gmail.com>
	 <1258960565-26736-7-git-send-email-gwingerde@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aOpQLKY0NLu5NvKueA6s"
Date: Mon, 23 Nov 2009 11:41:44 +0100
Message-ID: <1258972904.7094.150.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aOpQLKY0NLu5NvKueA6s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 08:16 +0100, Gertjan van Wingerde wrote:
> Allow drivers to consume the extra TX headroom they are requesting instea=
d
> of assuming they will give it back. This specifically is the case for
> the rt2x00 driver, as a large part of the requested extra TX headroom is
> used to properly align the frame for DMA usage, and the frame is never
> moved back to the original location.
> Fix this by reserving TX headroom accounting for both the driver requeste=
d
> amount and the special monitor interface header that needs to be added,
> instead of just the maximum of the two.
>=20
> See http://marc.info/?l=3Dlinux-kernel&m=3D125892467801662&w=3D2 for deta=
ils.

> -	local->tx_headroom =3D max_t(unsigned int , local->hw.extra_tx_headroom=
,
> -				   sizeof(struct ieee80211_tx_status_rtap_hdr));
> +	local->tx_headroom =3D local->hw.extra_tx_headroom +
> +				   sizeof(struct ieee80211_tx_status_rtap_hdr);

Even though the radiotap header currently is only 13 bytes long, I don't
really like this, you're not consuming all of extra_tx_headroom! I'd
rather have a definition somewhere

#define MAC80211_TX_STATUS_HEADROOM		13

(with a BUILD_BUG_ON(sizeof(rtap_hdr) =3D=3D MAC80211_TX_STATUS_HEADROOM))
so that you can make the driver set
	extra_tx_headroom =3D max_t(MAC80211_TX_STATUS_HEADROOM, txi) + align;

johannes

--=-aOpQLKY0NLu5NvKueA6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCmbkAAoJEODzc/N7+Qma69QP/AxmyNVEjIe/rjsihRTkXrOj
AOwnWGR9v8WYWAnAJxWbW0DZu6SXYz1LBHIhET1pv9hda4hShA24Jv3kAOs1DvdZ
dHkmHHisSa5df/aJUWZraigu2ajp5Ab6alNkCMvIk6L1CoRoczmZyQ3H1NSt7wKi
coxxtQpXaSn3mItpsl8ccV7yg0/vn6yBD/Mm3ORD/ZoYamp06E5d8dNVKh2clnGF
jWj1Gh5JR7vafOsrb6Hnv8Mt1Y1B9Dz48mDB3TxVPfrDDhzdKFv9V5NNVYHW9nst
362oN54zSMMnWFOuyweFQXAnNYWECWAT0HCviVmty7Cus/1Ja5gPh9uwNuqfhVXI
cnhHr0D7LsyGqWuoBhliuTi1vaUg+g9JH7SUajg6x2ve/REkejUsMynT7A4iG8pk
fwsBeIwNmWHbJpZeFB31GC1dYEv4c3On8cSda8EkURYB9Mjlkk6ULbkq/GBA/eFg
8rakjzz/ilVpEZXf9ncoyHDj4SxnIFCidrixkfs11HVlaYRxFaStgWOk7t/xv7UB
q+lIo3VNZBt9hYafZdu42+uHNh9GLAn/GPxJRyq2BrBSpHn4cBKqwuyI+j3+RXMH
uXQqRZ7/PubVyFxT3DBMY5ocgN7R4Bv109Nfe4nh8jN/HH/pxzSE5BZTmgoz4Yqr
B3g+9kwH6FwRs//4L1Je
=S/1Y
-----END PGP SIGNATURE-----

--=-aOpQLKY0NLu5NvKueA6s--

