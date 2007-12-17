Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbXLQSZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 13:25:27 -0500
Subject: Re: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11979070783125-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070783125-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PEjr1QPqEchh502sFRnD"
Date: Mon, 17 Dec 2007 19:24:44 +0100
Message-Id: <1197915884.4885.93.camel@johannes.berg> (sfid-20071217_182530_368131_D7B3AEB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PEjr1QPqEchh502sFRnD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
> +u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
> +			unsigned int type);

Please use the proper enum.

> @@ -1530,6 +1533,48 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx=
)
>  }
> =20
>  static ieee80211_txrx_result
> +ieee80211_rx_h_ctrl(struct ieee80211_txrx_data *rx)
> +{
> +	struct ieee80211_local *local =3D rx->local;
> +	struct ieee80211_hw *hw =3D &local->hw;
> +	struct sk_buff *skb =3D rx->skb;
> +	struct ieee80211_bar *bar =3D (struct ieee80211_bar *) skb->data;
> +	struct tid_ampdu_rx *tid_agg_rx;
> +	u16 start_seq_num;
> +	u16 tid;
> +
> +	if (likely((rx->fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_CTL))
> +		return TXRX_CONTINUE;
> +
> +	if ((rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_BACK_REQ) {
> +		if (!rx->sta)
> +			return TXRX_CONTINUE;
> +		tid =3D le16_to_cpu(bar->control) >> 12;
> +		tid_agg_rx =3D &(rx->sta->ampdu_mlme.tid_rx[tid]);
> +		if (tid_agg_rx->state !=3D HT_AGG_STATE_OPERATIONAL)
> +			return TXRX_CONTINUE;
> +
> +		start_seq_num =3D le16_to_cpu(bar->start_seq_num) >> 4;
> +
> +		/* reset session timer */
> +		if (tid_agg_rx->timeout) {
> +			unsigned long expires =3D
> +				jiffies + (tid_agg_rx->timeout / 1000) * HZ;
> +			mod_timer(&tid_agg_rx->session_timer, expires);
> +		}
> +
> +		/* manage reordering buffer according to requested */
> +		/* sequence number */
> +		ieee80211_sta_manage_reorder_buf(hw, rx, tid_agg_rx,
> +						NULL, start_seq_num, 1);
> +
> +		return TXRX_DROP;
> +	}
> +
> +	return TXRX_CONTINUE;
> +}
> +
> +static ieee80211_txrx_result
>  ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
>  {
>  	struct ieee80211_sub_if_data *sdata;
> @@ -1680,6 +1725,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =3D
>  	ieee80211_rx_h_remove_qos_control,
>  	ieee80211_rx_h_amsdu,
>  	ieee80211_rx_h_data,
> +	ieee80211_rx_h_ctrl,
>  	ieee80211_rx_h_mgmt,

Maybe we should have a single rx_h_frame function that passes it to
three control/data/mgmt functions depending on the frame type? Not sure
though since data comes first and that's the hot path.


> @@ -163,6 +164,15 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, s=
ize_t len)
>  	case IEEE80211_FTYPE_CTL:
>  		if ((fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PSPOLL)
>  			return hdr->addr1;
> +		else if ((fc & IEEE80211_FCTL_STYPE) =3D=3D
> +						IEEE80211_STYPE_BACK_REQ) {
> +			switch (type) {
> +			case IEEE80211_IF_TYPE_STA:
> +				return hdr->addr2;
> +			case IEEE80211_IF_TYPE_AP:
> +				return hdr->addr1;
> +			}

Doesn't that result in a compiler warning? And what does happen if we
receive a BACK_REQ when we're an IBSS/MESH?

johannes

--=-PEjr1QPqEchh502sFRnD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2a+66Vg1VMiehFYAQLf4hAAgxzPPmHlXpafmb44KMtYavgXsc2a7KMK
zTj8iYsGF/IFMqnKrxI6d2atsz5aplcgraC9/JJidI080cuZJmLj/cs0PEck7+oJ
lAQrsIR+IdmYzJurgsoHt1cny2ZSQPeZaoLK84JN3crrLbeWE6z71gv6a1WZbI/D
Zz4S/qHnb1S5zQzBD9cF/gp0pcr/5X81KxoafwR9nrY1NuYTSXc6XwW2wngfFW1f
ngpJcUzhnIHQrwalDY7ncjX3D6pQ8OCfxv8xEIV5hM7brZGmWbtXQAtpiEFojlpc
Q5gGXCPEm0/T9yLP/Yf9S0iuTi+wbnbv3I6FE7m2I5ngoNYzusvrWo9N+ShT3Uf9
rU/sJ3EECmryIboD0PpAHH6p2810OAJKa9t5aiyF49rsQRZcW7ZhwwuaUE1pcHDX
XXAwcMc8JHm8XeyL5/IWFYInG4ZFCbAU/1aOyk+OCNiq4/jgAKV/GaX2Wg6zgngi
uLw4tzryMiQJm83noPp2aGoc+XOdjg6wjlirfzSj8jRWHnn3x/QL2fZ1auAFSQ3i
nPnK7PxLTY31+UbZRpV2WuaqHleubmi9QTo1wqydMDkhzd5Xgm2GFR/2JzUvHy5n
kCp7WA+pZ6K7Leb8ir5WNUfsc19XwGfI0qsuXuPtL5AEuVhrPkbbNPKzD3JNRvsm
dyh+8rmylRM=
=trFd
-----END PGP SIGNATURE-----

--=-PEjr1QPqEchh502sFRnD--

