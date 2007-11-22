Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbXKVM4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:56:46 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3HDkNl3TYqvIIyKGYrWV"
Date: Thu, 22 Nov 2007 12:48:27 +0100
Message-Id: <1195732107.6323.84.camel@johannes.berg> (sfid-20071122_125659_536839_473065E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3HDkNl3TYqvIIyKGYrWV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

Sorry this will most likely in email crossing because I'm writing this
as I haven't been able to check mail since yesterday afternoon.

Looking into the eapol handling in more detail, I found another bug with
your patch. Namely, in the RX path, you have:

> -	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
> +	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb, hdrlen) &&

at which point the frame is already reframed to 802.3.

However,

> -int ieee80211_is_eapol(const struct sk_buff *skb)
> +int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen)
>  {

>  	if (unlikely(skb->len >=3D hdrlen + sizeof(eapol_header) &&
>  		     memcmp(skb->data + hdrlen, eapol_header,
>  			    sizeof(eapol_header)) =3D=3D 0))

here checks the full 802.2 LLC header which was removed by the
reframing, thus this check will always be false.

I think we should, instead, have the ieee80211_data_to_8023 function set
skb->protocol correctly, and leave the skb's data pointer pointing to
the payload rather than the ethernet header, like eth_type_trans() would
do. In fact, I think we can just call it after we've reframed the frame.
Then, we can check skb->protocol for EAPOL which is a much cheaper check
too.

The thing I'm not entirely sure about is what happens with
eth_type_trans() and the pulling of the ethernet header. Wouldn't that
cause us problems with the skb->data[] accesses in
ieee80211_subif_start_xmit() once the frame arrives back there?

johannes

--=-3HDkNl3TYqvIIyKGYrWV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0VsiqVg1VMiehFYAQJ2qw//Zk7nMRWClVtQ802x6/BWSGjh0K/avCF8
LbnXXqAICVFEleN8opI+swPOJPxp60RnPX0FgYrk5EBH7joE3GQBqXk3WTaaKJCx
TZnrOpz3xQQhqWewyNxYRcBt0QoWp/V/EkCuqyXk0or7K//2v5xwYkGDQBDJEA0v
0KAnx3tjuEeTTLnrm0mVdUBj+vkSnMAQVBcHyqjSwuC0S+GqpURoLfHekC0ay/JO
oG7RFP60ZbnzIwizKyVms4+UK7yFcYg32nwDI2FFhiFMlzxPrc5Brm8/7pMDRhMe
zZZGepzE9ah3xpURboNNP3IqFTFKeGJWb0CihJjVVKTWyHH0RUur6JD0Fxb+Yrd6
QuGzA7UFRNBYPOchxwUWm+CgESsp3MVKnBSxHvOQLeRupsX86DqDTXlX77RLTjzu
ukNUy5LgfeIeOH240amvMAMinTrP8MPJkjCGhhaA+95vWgxi0NBrf/FAGpXcFhka
KxwFFi2Es72OAqVotCryMdZ9xV3h+c1a2tlEdPhVcd5QDAo3rKQF9b++vysDG6Na
aRWSw64jTKLb+vqSX24RcXQN6U8rmzUrlqUzJQFhKGOsQ7POzzqT2fhTytcb19wR
Q0tTEoeJ2NsNwbS6hKgbf+N/7Zer68S2YOr8q+90WBK5KmIjkYGuXhPokm8S3afw
WCBX3m30mgw=
=hWGF
-----END PGP SIGNATURE-----

--=-3HDkNl3TYqvIIyKGYrWV--

