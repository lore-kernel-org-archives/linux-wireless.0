Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYDBJjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:39:16 -0400
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200804012145.18294.chunkeey@web.de> (sfid-20080401_204526_683133_262D4EC3)
References: <200804012145.18294.chunkeey@web.de>
	 (sfid-20080401_204526_683133_262D4EC3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qfyE3fsooMMbtTJe08Qk"
Date: Wed, 02 Apr 2008 11:34:17 +0200
Message-Id: <1207128858.10910.19.camel@johannes.berg> (sfid-20080402_103920_089229_BEF0EDCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qfyE3fsooMMbtTJe08Qk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
> This patch is necessary for the upcoming Accesspoint patch for p54.

Hm. I don't like increasing the tx control structure size but I guess
you really need that :)

> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Please CC the appropriate maintainers (i.e. at least me for mac80211) on
code changes.


> =EF=BB=BFdiff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 48428a6..b428472 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -287,6 +287,7 @@ struct ieee80211_tx_control {
>         u8 iv_len;              /* length of the IV field in octets */
>         u8 queue;               /* hardware queue to use for this frame;
>                                  * 0 =3D highest, hw->queues-1 =3D lowest=
 */
> +       u16 aid;                /* Station AID */
>         int type;       /* internal */
>  };
> =20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 80f4343..ea3fa0f 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -741,6 +741,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
>         }
> =20
>         if (tx->sta) {
> +               control->aid =3D tx->sta->aid;
>                 tx->sta->tx_packets++;
>                 tx->sta->tx_fragments++;
>                 tx->sta->tx_bytes +=3D tx->skb->len;

--=-qfyE3fsooMMbtTJe08Qk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/NTGaVg1VMiehFYAQLe+g/+LF8XMBIHamn5gC14bCYH9XsGZ5b89qQp
8ikU67QxNFS+oga98dSDcg2wvr2LTf9+EzMV9e8r/W71qnKRHdJ1CwewaEVAwU/V
1NeQguQp8UvcflSq7O1ztDkNTNkzKPSKREnCo/SV7hKKB5B+48jy954HhhaLOH2n
0muiGnH6x9q5yR6qqUW2Ep5BcIDgyL7ISC5RiEGAgijfLwI01g5vCgdfiaSd/GYD
pxqEYR2JS4y0PaygmqKGvI6+5vv7IEu/aS4vIFpz7G17DotlVIVAkpvBxlbbIAFH
x5rNPHlX9v/ZkeGHqTwXSJHstJhPW+rohedZXYLoKZK8CWyu41+T/objmlfeDgFk
6/MMEA3qG75/WTnBMceT6ePFT/4KAXp66fPPZGTbfggkHwL0+tfA0skb3HNqL9G+
QV695PL7uSGaENCmV5ck+uOd0IXy1b89WInszViMIwNRxyYbE+XjMBv5V8+3UZO8
wEI+w1x382khDSehFnqUcbzdqokjiE8A1qwKsC7uNW5ywthTaMJMUi5Y3whA7N/D
RTwW0Jc6I0gEqbnZ3cOOFTlkiXwsH8RtPb47Mjpxj6YfhrTbgYfVzmjeHSI0rC3D
jlJeRynjiwnLpCfEL4oXmCszGCX7qHt1SCm85nzNZNofhV/FEZ7pzm8iuvCY4bTq
o/GgaL14K34=
=qC/p
-----END PGP SIGNATURE-----

--=-qfyE3fsooMMbtTJe08Qk--

