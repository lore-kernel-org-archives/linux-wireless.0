Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYJUGoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:44:37 -0400
Subject: Re: [PATCH] mac80211: fix a few typos in mac80211 kernel doc
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <20081021012027.GA25144@hash.localnet>
References: <20081021012027.GA25144@hash.localnet>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DNdEUAYgoU26hTtZ9lpp"
Date: Tue, 21 Oct 2008 08:44:31 +0200
Message-Id: <1224571471.27899.69.camel@johannes.berg> (sfid-20081021_084440_243489_A5AD3EF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DNdEUAYgoU26hTtZ9lpp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 21:20 -0400, Bob Copeland wrote:
> Correct a handful of errors found while reading the mac80211 book.
>=20
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks Bob, John, can you take this patch?

Out of curiosity, what would you want from the book?

> ---
>=20
> Hi Johannes, I just noticed these while reading the comments.
>=20
>  include/net/mac80211.h |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index f5f5b1f..e5bc62c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -87,7 +87,7 @@ enum ieee80211_notification_types {
>   * This structure describes most essential parameters needed
>   * to describe 802.11n HT characteristics in a BSS.
>   *
> - * @primary_channel: channel number of primery channel
> + * @primary_channel: channel number of primary channel
>   * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
>   * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
>   */
> @@ -115,7 +115,7 @@ enum ieee80211_max_queues {
>   * The information provided in this structure is required for QoS
>   * transmit queue configuration. Cf. IEEE 802.11 7.3.2.29.
>   *
> - * @aifs: arbitration interface space [0..255]
> + * @aifs: arbitration interframe space [0..255]
>   * @cw_min: minimum contention window [a value of the form
>   *	2^n-1 in the range 1..32767]
>   * @cw_max: maximum contention window [like @cw_min]
> @@ -460,7 +460,7 @@ enum ieee80211_conf_flags {
>   * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
>   *	1/2: antenna 0/1
>   * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
> - * @ht_conf: describes current self configuration of 802.11n HT capabili=
es
> + * @ht_conf: describes current self configuration of 802.11n HT capabili=
ties
>   * @ht_bss_conf: describes current BSS configuration of 802.11n HT param=
eters
>   * @channel: the channel to tune to
>   */
> @@ -860,7 +860,7 @@ static inline void SET_IEEE80211_DEV(struct ieee80211=
_hw *hw, struct device *dev
>  }
> =20
>  /**
> - * SET_IEEE80211_PERM_ADDR - set the permanenet MAC address for 802.11 h=
ardware
> + * SET_IEEE80211_PERM_ADDR - set the permanent MAC address for 802.11 ha=
rdware
>   *
>   * @hw: the &struct ieee80211_hw to set the MAC address for
>   * @addr: the address to set
> @@ -953,7 +953,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_h=
w *hw,
>   * This happens everytime the iv16 wraps around (every 65536 packets). T=
he
>   * set_key() call will happen only once for each key (unless the AP did
>   * rekeying), it will not include a valid phase 1 key. The valid phase 1=
 key is
> - * provided by udpate_tkip_key only. The trigger that makes mac80211 cal=
l this
> + * provided by update_tkip_key only. The trigger that makes mac80211 cal=
l this
>   * handler is software decryption with wrap around of iv16.
>   */
> =20
> @@ -1087,7 +1087,7 @@ enum ieee80211_ampdu_mlme_action {
>   *	Must be implemented.
>   *
>   * @add_interface: Called when a netdevice attached to the hardware is
> - *	enabled. Because it is not called for monitor mode devices, @open
> + *	enabled. Because it is not called for monitor mode devices, @start
>   *	and @stop must be implemented.
>   *	The driver should perform any initialization it needs before
>   *	the device can be enabled. The initial configuration for the
> @@ -1156,7 +1156,7 @@ enum ieee80211_ampdu_mlme_action {
>   * @set_retry_limit: Configuration of retry limits (if device needs it)
>   *
>   * @sta_notify: Notifies low level driver about addition or removal
> - *	of assocaited station or AP.
> + *	of associated station or AP.
>   *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
>   *	bursting) for a hardware TX queue.
> @@ -1459,7 +1459,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_h=
w *hw,
>   * the next beacon frame from the 802.11 code. The low-level is responsi=
ble
>   * for calling this function before beacon data is needed (e.g., based o=
n
>   * hardware interrupt). Returned skb is used only once and low-level dri=
ver
> - * is responsible of freeing it.
> + * is responsible for freeing it.
>   */
>  struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
>  				     struct ieee80211_vif *vif);
> --=20
> 1.5.4.2.182.gb3092
>=20

--=-DNdEUAYgoU26hTtZ9lpp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/XpLAAoJEKVg1VMiehFYUDYP/1YabxBUYS7Yr6RxL2NgQn44
3M3Jjafm52uPnBW5JyzRzgJcgL9YpklUSKed0GimBxTcQ9IRhJg1Xiwa5aj7HOz1
PWsfulfwXcR6CGvIddGN5Tw2j+nNkIDCokxyz5OEHMqOlo4QWDUOiFSNrkOhupru
wRcC7OS1WRNZ0ePLsq3h1ljdHk7vHvPKlYVKnwThMiiy7MmMngfv5sF56hGnuCyi
0qdtwUlQMsNIgF6yUGnmwZCFJ+WADNVN5h8smPEe8hxqyYUOvMMjbCKaw+G+7dPU
XXd76F8o/lat3/YmoqtufGIeNmmkXnIvjl02vvKHQay1sKut6CEhQOvFXEtlonu5
LJsPNVz1zExLoU4WA3nTvgmKWJYqOsBotfJyxkG6ZdOyPyvprvipX/PxfB7YMvV8
rh+wiyvBXIuE9MCD7kOKBHo/rehd3699eN8RJ2R9CEbXfQ+u6pDe4J01xenQsLNW
fR4QnhLOwO3Eu77tG9m2M3/W+pm6Ke6S6PrNxQomMFr2EEXO2AZqRWFuFtno2Tv0
uiLnGJwAI0XarT9qH3GlF51VRFMBV8DycMGicrJbtmaqDDzyJ76FHxreWPTsMdVU
WOWCQQS6vS7AE8ILY+m6BaXEfEeSccVocqD2HF9aUICVYujVwiQeNAbtJ7xbqfBC
dk2ILuUlZiIVaAfgOltm
=cuBi
-----END PGP SIGNATURE-----

--=-DNdEUAYgoU26hTtZ9lpp--

