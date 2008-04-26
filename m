Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbYDZUwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 16:52:14 -0400
Subject: Re: [PATCH 2/2] mac80211: make rx radiotap header more flexible
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080407042549.9026.81997.stgit@localhost>
References: <20080407042541.9026.59360.stgit@localhost>
	 <20080407042549.9026.81997.stgit@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5z6RYwrVTh9DEuI6a38Q"
Date: Sat, 26 Apr 2008 22:51:50 +0200
Message-Id: <1209243111.10943.61.camel@johannes.berg> (sfid-20080426_225230_588235_70DA1400)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5z6RYwrVTh9DEuI6a38Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static void
> +ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
> +				 struct sk_buff *skb,
> +				 struct ieee80211_rx_status *status,
> +				 struct ieee80211_rate *rate,
> +				 int rtap_len)
> +{
> +	struct ieee80211_radiotap_header *rthdr;
> +	unsigned char *pos;
> +
> +	rthdr =3D (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
> +	memset(rthdr, 0, rtap_len);
> +
> +	/* radiotap header, set always present flags */
> +	rthdr->it_present =3D
> +		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
> +			    (1 << IEEE80211_RADIOTAP_RATE) |
> +			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
> +			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
> +			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));

Is all this alignment-safe now? Not sure it was before but it'd be nice
if we could fix it up.

Radiotap explicitly allows you to have a longer length than you need so
maybe we should just make sure to align things?

johannes

--=-5z6RYwrVTh9DEuI6a38Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBOV5aVg1VMiehFYAQJkcg/9GUEG6iIvuZW6tpBcpCYWqdUaZAGoVI7A
KQ7u1r7bSODuggB5rPSvpdtk9c1516paOH7qCwDiGPHU76mlv+E89LR1lga/30hU
LErrt8bP5xkpfXxhNOWNPEaC+92udjfvAo/bChn51Bn2GGcXgQukyestroQuVKwF
fVEbOgQtrhw6LiQhOravGnHtmiCMzuPVy0AS4f0f+/fdHsd9T5lVPi4ErK93Rk3z
mrDjpMQpy4nNeiFPwT3GzYVJKma5P271Ew8fXOSnUWXfRt4xc+nhuWIWfJXjCWGF
RXdQQC/jhM0TlusP1SMG2P2o5UkapgsuiSJ3w5ZRF6ghKV2Oynxak0D0tQRIbQIy
stGAdzPwfbJ/QrJVd/M1eVHMsK7BRMe6wjWDUtUzBu3EN1I49Tg/T2sHVeeI43C2
SZvMclZz3xcaCYRhmDDQwhLi42f8LPZtKJi+cSU52oaVRpz7eBhzjHXMWDBo2aGs
WubX2bKKdm03RW7T5oRUoV/5IoewJplV/Ma9KO7TXwCvWgx3ablH6qnH1y//bpSe
2Gh3L2ceHEDi1kIsY+tqyHKXurXyGtikHGpQYQBEKjvx/Ffsrm4G2brYeSiJtjvJ
UOT5UTKpRUpYxAdUQwT5OCAM5FAstcicnUexsa28mPpkdKLCdez87rI8G52evZOL
ByhJNimpRLY=
=eP4W
-----END PGP SIGNATURE-----

--=-5z6RYwrVTh9DEuI6a38Q--

