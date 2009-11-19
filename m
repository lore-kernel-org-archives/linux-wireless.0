Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZKSWdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:33:09 -0500
Subject: Re: [PATCH] mac80211: request TX status where needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gertjan@vanwingerde.net>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B05C70D.1030703@vanwingerde.net>
References: <1258589310.30511.91.camel@johannes.local>
	 <4B05C234.3000908@gmail.com>  <4B05C70D.1030703@vanwingerde.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MqrCG1Vds5tJzIPksiff"
Date: Thu, 19 Nov 2009 23:33:08 +0100
Message-ID: <1258669988.7094.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MqrCG1Vds5tJzIPksiff
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 23:30 +0100, Gertjan van Wingerde wrote:

> >> -	if (tx_info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
> >> +	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
> >>  		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
> >>  	else
> >>  		dev_kfree_skb_irq(entry->skb);
> >=20
> > I'm slightly confused here. Shouldn't both the tx_info->flags and skbde=
sc_flags be checked here?
> > Now we run in the situation where tx_status is report even if mac80211 =
didn't ask for it.
> >=20
>=20
> Never mind. I missed the change from "requested" to "required" for the
> IEEE80211_TX_CTL_REQ_TX_STATUS flag.

In fact, it wouldn't matter if you gave it a TX status for the RTS or
CTS frame either, but it might be somewhat confusing :)

The "required" is also not really correct. The frame could always be
dropped elsewhere due to memory pressure or whatever... I'll need to
reword that and explain much more.

johannes

--=-MqrCG1Vds5tJzIPksiff
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBcehAAoJEODzc/N7+Qmawn4P/i7x8uJUwF3xku2oIrnh+450
aQhLL4kOkSIq7RZWJT2tyy1JsQ9a0jtS2LkxJsQAQa2B5hSMpRu3IGZ6c8FcC9OR
TfD0In9gJ+kAERo1QR4yD/ZpNR5sgMB6kJFfYp2x9TB+S1zC6YkJjopNezjozNIC
VizTe/okbU3pt4NhFzOOAMoiZf6XoQCgJLuTRJchHtbr4ugi5Vpx3a1I0HW6epZu
Nisi+OXRpotCLCopnOTkb8gWA/hiXD9yOupLgmmPN3vb6DoH5OQcX53MaAIC6D6+
tdsqWnOaG105SGiKkOXJwrlRp3PaxareJ3S6hKqnJNkYWVWhOLKLB01cbxaH5Ins
awN/kOdRW9Bc9o+lg6YgEB1l9AaYBXXwd4mcvoJnTqAACBHKYLxi9T0XMD4V8oMp
bOntgK00vlSuYduG+exBfcJrrulVAIa9HiS4wnEoM8ycEb0QWLDr3eZ9FuRjDU7e
hKaxfU24kWgGebuZHNVBVL9oyyvFob5/RtAbkEqxk6pTFf5RuCMRroOkEyX8Nzvk
8k7xCVipkx8PWz8BgPL3HxnYBO5bzujJocNmarfoLkJhaKjHWH/KUawmGwF40a6s
8spafFk1osnpI/x7CnNmaJRN82Aya6g/PMY04QPKB/FBpPQf7cUUfWf7ze8MKD4p
X/abONnUAdNdppDlYrBa
=VL8b
-----END PGP SIGNATURE-----

--=-MqrCG1Vds5tJzIPksiff--

