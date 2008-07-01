Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYGALbp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:31:45 -0400
Subject: Re: [PATCH 1/2 V2] mac80211: add bar capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1214910963-8104-1-git-send-email-tomas.winkler@intel.com>
References: <1214910963-8104-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h6fOgC7aXrTJS7srLc4l"
Date: Tue, 01 Jul 2008 13:31:02 +0200
Message-Id: <1214911862.29181.5.camel@johannes.berg> (sfid-20080701_133147_925077_2C550ABA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h6fOgC7aXrTJS7srLc4l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-01 at 14:16 +0300, Tomas Winkler wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>=20
> This patch adds block ack request capability
>=20
> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Ack if you change the subject s/bar/block-ack request/

> ---
> This version removes useless skb->priority setting=20
>=20
>  include/linux/ieee80211.h  |    4 ++++
>  include/net/mac80211.h     |    3 +++
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/main.c        |   21 +++++++++++++++++++--
>  net/mac80211/mlme.c        |   29 +++++++++++++++++++++++++++++
>  5 files changed, 56 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index cffd6d0..aa603c3 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -658,6 +658,10 @@ struct ieee80211_bar {
>  	__le16 start_seq_num;
>  } __attribute__((packed));
> =20
> +/* 802.11 BAR control masks */
> +#define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL     0x0000
> +#define IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA  0x0004
> +
>  /**
>   * struct ieee80211_ht_cap - HT capabilities
>   *
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 3a204ac..0a5de3e 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -235,6 +235,8 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
>   * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
>   * 	is for the whole aggregation.
> + * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
> + * 	so consider using block ack request (BAR).
>   */
>  enum mac80211_tx_control_flags {
>  	IEEE80211_TX_CTL_REQ_TX_STATUS		=3D BIT(0),
> @@ -260,6 +262,7 @@ enum mac80211_tx_control_flags {
>  	IEEE80211_TX_STAT_TX_FILTERED		=3D BIT(20),
>  	IEEE80211_TX_STAT_ACK			=3D BIT(21),
>  	IEEE80211_TX_STAT_AMPDU			=3D BIT(22),
> +	IEEE80211_TX_STAT_AMPDU_NO_BACK		=3D BIT(23),
>  };
> =20
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index fcdbf09..775d5e8 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -903,6 +903,7 @@ void ieee80211_send_addba_request(struct net_device *=
dev, const u8 *da,
>  				  u16 agg_size, u16 timeout);
>  void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
>  				u16 initiator, u16 reason_code);
> +void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn=
);
> =20
>  void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
>  				u16 tid, u16 initiator, u16 reason);
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index f18cfd7..074f71a 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1404,14 +1404,15 @@ void ieee80211_tx_status(struct ieee80211_hw *hw,=
 struct sk_buff *skb)
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
>  	u16 frag, type;
> +	__le16 fc;
>  	struct ieee80211_tx_status_rtap_hdr *rthdr;
>  	struct ieee80211_sub_if_data *sdata;
>  	struct net_device *prev_dev =3D NULL;
> +	struct sta_info *sta;
> =20
>  	rcu_read_lock();
> =20
>  	if (info->status.excessive_retries) {
> -		struct sta_info *sta;
>  		sta =3D sta_info_get(local, hdr->addr1);
>  		if (sta) {
>  			if (test_sta_flags(sta, WLAN_STA_PS)) {
> @@ -1426,8 +1427,24 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, =
struct sk_buff *skb)
>  		}
>  	}
> =20
> +	fc =3D hdr->frame_control;
> +
> +	if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
> +	    (ieee80211_is_data_qos(fc))) {
> +		u16 tid, ssn;
> +		u8 *qc;
> +		sta =3D sta_info_get(local, hdr->addr1);
> +		if (sta) {
> +			qc =3D ieee80211_get_qos_ctl(hdr);
> +			tid =3D qc[0] & 0xf;
> +			ssn =3D ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
> +						& IEEE80211_SCTL_SEQ);
> +			ieee80211_send_bar(sta->sdata->dev, hdr->addr1,
> +					   tid, ssn);
> +		}
> +	}
> +
>  	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
> -		struct sta_info *sta;
>  		sta =3D sta_info_get(local, hdr->addr1);
>  		if (sta) {
>  			ieee80211_handle_filtered_frame(local, sta, skb);
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 0d50d52..c9e8b5c 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1538,6 +1538,35 @@ void ieee80211_send_delba(struct net_device *dev, =
const u8 *da, u16 tid,
>  	ieee80211_sta_tx(dev, skb, 0);
>  }
> =20
> +void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn=
)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sk_buff *skb;
> +	struct ieee80211_bar *bar;
> +	u16 bar_control =3D 0;
> +
> +	skb =3D dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
> +	if (!skb) {
> +		printk(KERN_ERR "%s: failed to allocate buffer for "
> +			"bar frame\n", dev->name);
> +		return;
> +	}
> +	skb_reserve(skb, local->hw.extra_tx_headroom);
> +	bar =3D (struct ieee80211_bar *)skb_put(skb, sizeof(*bar));
> +	memset(bar, 0, sizeof(*bar));
> +	bar->frame_control =3D IEEE80211_FC(IEEE80211_FTYPE_CTL,
> +					IEEE80211_STYPE_BACK_REQ);
> +	memcpy(bar->ra, ra, ETH_ALEN);
> +	memcpy(bar->ta, dev->dev_addr, ETH_ALEN);
> +	bar_control |=3D (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
> +	bar_control |=3D (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
> +	bar_control |=3D (u16)(tid << 12);
> +	bar->control =3D cpu_to_le16(bar_control);
> +	bar->start_seq_num =3D cpu_to_le16(ssn);
> +
> +	ieee80211_sta_tx(dev, skb, 0);
> +}
> +
>  void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u1=
6 tid,
>  					u16 initiator, u16 reason)
>  {

--=-h6fOgC7aXrTJS7srLc4l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIahVuAAoJEKVg1VMiehFYnXMP/A7MA8JfUworvhb5h/4nZ0q1
gLMCovr6SMu8OkvYVHEPJVuHXXHyCqzdeftPCl1kdXuWA8Z2IaJiYt3qkK5j3siZ
zqnX/ykRtnVHRm+JCpLQR/k9gN5EJ86CO5WDca3sKyz3zG4hHbv0QIaY2Vpj/ixS
0LMVDibA1QZf1xqpWP9Mn++visUxd65BZY+nEd1jz1gTqwz8Yfg4oOc9svMKVIrb
jvRyuscBXwtdOBOsVuwL+w4Fg5MMFsL2Os1hXtlS1EMp+kg6N5Qe5KSUxSznC73G
HQRx58J/0xoq4oJS38vhLD8yhJ+QeP8KokT7sS30bXUGvbSvurEqHo6+YtvqY1br
wUZfBeAATq1SQORCqqSNNUumbMxBzuB+K5TTkCGhX7/XCN2V0QoW0vWQ0v8kPbuW
9BIYZjNIXM6kIJGjU3W/Xt97oGzbDjPrHd7XHhWBotQO8tor+puUAs3BLe5fUt01
zC5nUBPwArf1YLxrVqzF1LzLtkslh9nR4N+PCEbe6P2CmMQfnUQYhkb6jBuXAWaO
nvR8MP5wtw8fxTjmpqdACuo5SZWHZK69bTx639wL/SGIVfLqsB8jxyrdSUPKTKJb
y3vYvVK9yMcK4GwDDBWyrK6GO7MgsyzENvvf4kLMDdZmJ4JrifCi/TuE8fN+2FQx
TL7j2Ulck/9AZDnFpzbR
=Xn3t
-----END PGP SIGNATURE-----

--=-h6fOgC7aXrTJS7srLc4l--

