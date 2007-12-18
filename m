Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363AbXLRP0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 10:26:25 -0500
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197991433172-git-send-email-ron.rindjunsky@intel.com>
References: <1197991433172-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MtK+kQ6TrxG0SALHscDD"
Date: Tue, 18 Dec 2007 16:26:20 +0100
Message-Id: <1197991580.4885.171.camel@johannes.berg> (sfid-20071218_152643_680046_2D117CAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MtK+kQ6TrxG0SALHscDD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-18 at 17:23 +0200, Ron Rindjunsky wrote:
> This patch fixes should_drop_frame function to pass in ps poll control
> frames required for power save functioanlity. Interface types that do not
> have interest for PS POLL frames now drop it in handler.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Looks good to me.
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/rx.c   |   11 +++++++++--
>  net/mac80211/util.c |    7 ++++++-
>  2 files changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 50f99e7..e94cf30 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -61,8 +61,10 @@ static inline int should_drop_frame(struct ieee80211_r=
x_status *status,
>  		return 1;
>  	if (unlikely(skb->len < 16 + present_fcs_len + radiotap_len))
>  		return 1;
> -	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) =3D=3D
> -			cpu_to_le16(IEEE80211_FTYPE_CTL))
> +	if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) =3D=3D
> +			cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
> +	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=3D
> +			cpu_to_le16(IEEE80211_STYPE_PSPOLL)))
>  		return 1;
>  	return 0;
>  }
> @@ -880,6 +882,7 @@ ieee80211_rx_h_defragment(struct ieee80211_txrx_data =
*rx)
>  static ieee80211_txrx_result
>  ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *rx)
>  {
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(rx->dev=
);
>  	struct sk_buff *skb;
>  	int no_pending_pkts;
>  	DECLARE_MAC_BUF(mac);
> @@ -890,6 +893,10 @@ ieee80211_rx_h_ps_poll(struct ieee80211_txrx_data *r=
x)
>  		   !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH)))
>  		return TXRX_CONTINUE;
> =20
> +	if ((sdata->type !=3D IEEE80211_IF_TYPE_AP) &&
> +	    (sdata->type !=3D IEEE80211_IF_TYPE_VLAN))
> +		return TXRX_DROP;
> +
>  	skb =3D skb_dequeue(&rx->sta->tx_filtered);
>  	if (!skb) {
>  		skb =3D skb_dequeue(&rx->sta->ps_tx_buf);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 7b278e9..fb7fd89 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -135,13 +135,16 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, =
size_t len)
>  {
>  	u16 fc;
> =20
> -	if (len < 24)
> +	 /* drop ACK/CTS frames and incorrect hdr len (ctrl) */
> +	if (len < 16)
>  		return NULL;
> =20
>  	fc =3D le16_to_cpu(hdr->frame_control);
> =20
>  	switch (fc & IEEE80211_FCTL_FTYPE) {
>  	case IEEE80211_FTYPE_DATA:
> +		if (len < 24) /* drop incorrect hdr len (data) */
> +			return NULL;
>  		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
>  		case IEEE80211_FCTL_TODS:
>  			return hdr->addr1;
> @@ -154,6 +157,8 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, si=
ze_t len)
>  		}
>  		break;
>  	case IEEE80211_FTYPE_MGMT:
> +		if (len < 24) /* drop incorrect hdr len (mgmt) */
> +			return NULL;
>  		return hdr->addr3;
>  	case IEEE80211_FTYPE_CTL:
>  		if ((fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PSPOLL)

--=-MtK+kQ6TrxG0SALHscDD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fmm6Vg1VMiehFYAQK4Qw//SoxLRjfOmFxKeLnahficoiMAtYwx6Zxm
hs0bTYmAaRMNDDW65MAUKvbz/taGLUGyzn2fCktcQTgU7hCBDLAVqIUj7fq84Zb2
vxWCIBwHVca6S1BeDCO+5TPRpSnkovrPm42o+N6CSgizhHthmz2ApM3NtWGwLd7d
VIpntcDox3bZ8g0ZxvjvKpTntAGvH6HaZXR5shOFxuFE+NOA3OSCJWv1Jt74V3gk
0hqqd/LeHjFzr8wTOqzA1PIDg6D6yQLfzaREPsU0qU6plbBi6X2mSFzcQugHEy4/
UUk5oX97zP7/xiyuJuIMbqgkJv7/UOW6t6g2qxkydz68R6xyK7kJw2JHTHMvjrJo
lgiXBsQgXGmDXPpy88C4Te8BTtbBJjlJU71P2o8umsKlf6BF5ZnR8nI4C/M4xJya
r08WtQyUy/pD85FhMpQxKBBjYU1G5AKTR1QO97F8srbNBDdDB/DOphKmziGgMd1t
RUt/rSzyV5REf9pHP1r/QLsy5cCPpRUjQpbXaGM0y+TwL3jsS91/VThyUdmsUZF1
2rMz3omxv62KAVh12aQRIaGqLsoCeSzusEmOX5rDOJpwnLP92F2srfw9QlfZcH5b
F62u4RI2ePoriy79oYwKStnIEBCm6j16UhWT3FCjbm36iuvCzQudaXPrpWKKAMdh
Petm8HIyGE8=
=TcA9
-----END PGP SIGNATURE-----

--=-MtK+kQ6TrxG0SALHscDD--

