Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZBRU0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 15:26:14 -0500
Subject: Re: [RFC] nl80211: Authentication and association events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090218200210.GA13955@jm.kir.nu>
References: <20090218200210.GA13955@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A/rQHVULGqjOTUXwSw14"
Date: Wed, 18 Feb 2009 21:25:40 +0100
Message-Id: <1234988740.4023.51.camel@johannes.local> (sfid-20090218_212616_765939_71E612EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A/rQHVULGqjOTUXwSw14
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * @NL80211_CMD_RX_AUTH: authentication notification (on the "mlme" mult=
icast
> + *	group). This event reports reception of an Authentication frame in
> + *	station and IBSS modes similarly to MLME-AUTHENTICATE.confirm primiti=
ve
> + *	in the MLME SAP interface (kernel providing MLME, userspace SME). In
> + *	addition, this event is used as MLME-RESOURCE_REQUEST.confirm primiti=
ve
> + *	which is also reporting a reception of an Authentication frame. The
> + *	included NL80211_ATTR_FRAME attribute contains the management frame
> + *	(including both the header and frame body, but not FCS).
> + * @NL80211_CMD_RX_ASSOC: association notification (on the "mlme" multic=
ast
> + *	group). This event reports reception of an Association Response or
> + *	Reassociation Response frame in station and IBSS modes similarly to
> + *	MLME-ASSOCIATE.confirm or MLME-REASSOCIATE.confirm primitive in the
> + *	MLME SAP interface (kernel providing MLME, userspace SME). The includ=
ed
> + *	NL80211_ATTR_FRAME contains the management frame (including both the
> + *	header and frame body, but not FCS).

Shouldn't this specify that we send only frames that actually matter to
us?

> +void cfg80211_send_rx_auth(struct wiphy *wiphy, struct net_device *dev,
> +			   struct sk_buff *skb);
> +void cfg80211_send_rx_assoc(struct wiphy *wiphy, struct net_device *dev,
> +			    struct sk_buff *skb);

The wiphy parameter is somewhat useless, you can get it from
dev->ieee80211_ptr->wiphy. I'd also prefer to not pass the skb but
rather data/len separately since (a) that is all we use, and (b) in case
some fullmac driver later doesn't actually have this in skb form it can
still "build" a frame and then pass it.

> @@ -1592,12 +1593,15 @@ static void ieee80211_sta_rx_queued_mgmt
>  		break;
>  	case IEEE80211_STYPE_AUTH:
>  		ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
> +		cfg80211_send_rx_auth(local->hw.wiphy, sdata->dev, skb);
>  		break;
>  	case IEEE80211_STYPE_ASSOC_RESP:
>  		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 0);
> +		cfg80211_send_rx_assoc(local->hw.wiphy, sdata->dev, skb);
>  		break;
>  	case IEEE80211_STYPE_REASSOC_RESP:
>  		ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, 1);
> +		cfg80211_send_rx_assoc(local->hw.wiphy, sdata->dev, skb);

This seems somewhat wrong... imho we shouldn't be sending these events
to userspace if we didn't act on the frames.

johannes

--=-A/rQHVULGqjOTUXwSw14
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnG7CAAoJEKVg1VMiehFYKAgP/RD36X/X2kyj2+e2GrzA3Rrg
D9VWSerLhdffCvSCV2srwBB6mAYS/OIr56QDIlyCFsF7B7qaTFrKY8NV9TO/lXtT
o72MJr74X6JoNG6uTH/sGsOEPqyYdeqlXiNDQBemEEAJqk1fvKmEQ4KwEvHhyZvb
rjbtgfhlb3LgtZEwkCk8CXLzU28spAVPbvkdpTfOu+RXMEX0oI1ZVd+pmfl/9jkF
obxtoh/IFn3CUPcRSKpCcZbfY5OPDoSgAwvPesT+MHajxHbkdYHUVC5aRgMyDjEx
M4U/zvPh6edzdjeLe8/ekJZJj4yp95v09sLDzJsS1IIW7Rmf2wUwfKu81KiNyQ+g
kp54A6CoH2DAWmhCnyrQ3cpDHjrXDxpP5rvtcHutVhqWhGCa6sYFs/g6rVMPUOas
lV5o6fZ5Zr5JFpnJsfhCuq7ZV81jTq6mA5e5yPAVOOMJjAlRg9zH1tJI+VBcvMSV
In+/5cHGkaAudMADPliZR0NAaoOIHm1jQijT8QFNXKSJJfUQqaB3lBR5c54nKo1a
KTofubfJalupFGf3zj/rTN8oU09iLJz2FON875jYZU3IlVoR79saID2UOkYi889g
dzHz0nthpV3FJJFaDsqsfVKUIVXqx3vb9+YvnoMTKGozq2sgH+TYbPt455Nqb/xa
dHvAc/FMBU37MndsYvEr
=06Cp
-----END PGP SIGNATURE-----

--=-A/rQHVULGqjOTUXwSw14--

