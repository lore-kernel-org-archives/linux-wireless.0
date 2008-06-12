Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbYFLMto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 08:49:44 -0400
Subject: Re: [PATCH 1/1] mac80211: do not fragment while aggregation is in
	use
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1213274549-16132-1-git-send-email-ron.rindjunsky@intel.com>
References: <1213274549-16132-1-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LLhdVPIlvkIIrNoW+zAa"
Date: Thu, 12 Jun 2008 14:48:51 +0200
Message-Id: <1213274931.3936.4.camel@johannes.berg> (sfid-20080612_144946_928387_F410CC55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LLhdVPIlvkIIrNoW+zAa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-12 at 15:42 +0300, Ron Rindjunsky wrote:
> This patch denies the use of framentation while ampdu is used.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/tx.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 1ad9e66..195cb6d 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -660,9 +660,8 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
> =20
>  	/*
>  	 * Warn when submitting a fragmented A-MPDU frame and drop it.
> -	 * This is an error and needs to be fixed elsewhere, but when
> -	 * done needs to take care of monitor interfaces (injection)
> -	 * etc.
> +	 * This scenario is handled in __ieee80211_tx_prepare but extra
> +	 * caution taken here as fragmented ampdu may cause Tx stop.
>  	 */
>  	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
>  		    skb_get_queue_mapping(tx->skb) >=3D
> @@ -981,7 +980,8 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
>  	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
>  		if ((tx->flags & IEEE80211_TX_UNICAST) &&
>  		    skb->len + FCS_LEN > local->fragmentation_threshold &&
> -		    !local->ops->set_frag_threshold)
> +		    !local->ops->set_frag_threshold &&
> +		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
>  			tx->flags |=3D IEEE80211_TX_FRAGMENTED;
>  		else
>  			tx->flags &=3D ~IEEE80211_TX_FRAGMENTED;

--=-LLhdVPIlvkIIrNoW+zAa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIURsvAAoJEKVg1VMiehFYzqQQAI2XgH2aPKZQ+xZ7EkaD37dJ
JIZh21/GUg5guB2v7aYQ0YOu0TSkQAs8LTndx6cM6F8GW1UTTe0BjDMvAffsMTmH
ZFSaIOn0wqbKH2GwQ1m/4tcDJkUe/AhhzN91yQ1YCDyB/PioPshzCIbJbLp6n5Dd
TRGJBQmQKIXCM+XrVXRFl5r9lA8VkGtwX9NxwrPmOZF6gSCyupO/GIQK+UPPBiyT
0rpLpSGyKXAuew6E7nsgNbYcwxfyOmN6w4Wm2Owf8Cklcy6nFK+EgapE5MZVHYxl
zJpi6BUsBOefCtbeaVpoi8NEMLcZxDhncA1fGcUyRwSy4ENx1mQIQaoOWty8Fi/O
SPw60ctncXUjzIoRghYh80d/0AlfsyTNUBVdHZ7AFV1V6k1xK4UVF2cXyNs9Av/Z
ccLi3oKbdvJphEbRhJWOU3oUMippaw0y7Wg1zJSpADpNluM3DO8k469X//Wr82G4
bCc1G193NFlpYcatf1vCveBnyDYnbZ1/CD/8V67Zc9/REkdGNGLxVjS0RTnBjP8d
ipgm8d7812Nlxy/K82FX8pFiWLOwXycgt+HwgLcrywTldSlfPpsSU/ur5OAKkysW
3WAY7090twqqsBFutN4lbDHppHekYxujG6Brc73TqEMNkVS2PqVLwEPaNheLkCyl
voN5gKn9liXBdRIGwAJG
=ZLsP
-----END PGP SIGNATURE-----

--=-LLhdVPIlvkIIrNoW+zAa--

