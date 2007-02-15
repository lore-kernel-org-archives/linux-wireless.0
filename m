Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966033AbXBOQmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 11:42:13 -0500
Subject: Re: [PATCH v2] d80211: Add software sequence support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702141423.27823.IvDoorn@gmail.com>
References: <200702141423.27823.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QKs18HUvesyFeZDoU+dS"
Date: Thu, 15 Feb 2007 17:42:04 +0100
Message-Id: <1171557724.5220.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QKs18HUvesyFeZDoU+dS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-14 at 14:23 +0100, Ivo van Doorn wrote:
> Most hardware can keep track of sequence numbers themselves,
> unfortunately *most* doesn't cover all devices. ;)
> This patch will keep track of the (per-bss) sequence number
> if the flag IEEE80211_HW_SOFTWARE_SEQUENCE has been set.

Can this be a library function instead? Our TX path is already cluttered
enough...
=20
> +static void ieee80211_include_sequence(struct net_device *dev,
> +				       struct ieee80211_hdr *hdr)
> +{
> +	struct ieee80211_sta_bss *bss;
> +	u8 *bssid =3D ieee80211_get_bssid(hdr, sizeof(*hdr));
> +
> +	bss =3D ieee80211_rx_bss_get(dev, bssid);
> +	if (!bss)
> +		return;
> +
> +       /*
> +        * Set the sequence number for this frame.
> +        */
> +	hdr->seq_ctrl =3D cpu_to_le16(bss->sequence & IEEE80211_SCTL_SEQ);
> +
> +       /*
> +        * Increase the sequence number.
> +        */
> +	bss->sequence =3D (bss->sequence + 0x10) & IEEE80211_SCTL_SEQ;
> +
> +	ieee80211_rx_bss_put(dev, bss);
> +}

This could be exported getting an skb instead of the ieee80211_hdr.

Then the driver can just call it whenever it needs the sequence number
for a frame. It'll need to be a bit smart about fragmentation but I
think that's ok.

I may be radical, but I think that a lot of things hardware can do
belong into library functions the driver can use instead of cluttering
the stack with it.

johannes

--=-QKs18HUvesyFeZDoU+dS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBF1I1c/ETPhpq3jKURArfzAJdiQIsfLHJ/UrhvEiD3gw50nsOmAJ9R40Dv
VcWTiDrZCZ/2S0Klf4YTkQ==
=hBrZ
-----END PGP SIGNATURE-----

--=-QKs18HUvesyFeZDoU+dS--

