Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXKZQcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:32:06 -0500
Subject: Re: [PATCH 05/15] mac80211: adding 802.11n essential A-MPDU addBA
	capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1196086491335-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <1196086491335-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XBC7qi33g1DWC/RUtTJW"
Date: Mon, 26 Nov 2007 17:31:58 +0100
Message-Id: <1196094718.4149.299.camel@johannes.berg> (sfid-20071126_163209_138763_2C0280AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XBC7qi33g1DWC/RUtTJW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> This patch adds the capability to identify and answer an add block ACK
> request.
> As this series of patches only adds HT handling with no aggregations,
> (A-MPDU aggregations acceptance is not obligatory according to 802.11n
> draft) we are currently sending back a refusal upon this request.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Do you have a plan already on how to fill in that TODO? Just curious.

> ---
>  net/mac80211/ieee80211_sta.c |  124 ++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 124 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 2e23137..0f133e3 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -57,6 +57,13 @@
> =20
>  #define ERP_INFO_USE_PROTECTION BIT(1)
> =20
> +/* mgmt header + 1 byte action code */
> +#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
> +
> +#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
> +#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
> +#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
> +
>  static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
>  				     u8 *ssid, size_t ssid_len);
>  static struct ieee80211_sta_bss *
> @@ -991,6 +998,91 @@ static void ieee80211_auth_challenge(struct net_devi=
ce *dev,
>  			    elems.challenge_len + 2, 1);
>  }
> =20
> +static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u1=
6 tid,
> +					u8 dialog_token, u16 status, u16 policy,
> +					u16 buf_size, u16 timeout)
> +{
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +	u16 capab;
> +
> +	skb =3D dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
> +	if (!skb) {
> +		printk(KERN_DEBUG "%s: failed to allocate buffer "
> +		       "for addba resp frame\n", dev->name);
> +		return;
> +	}
> +
> +	skb_reserve(skb, local->hw.extra_tx_headroom);
> +	mgmt =3D (struct ieee80211_mgmt *) skb_put(skb, 24);
> +	memset(mgmt, 0, 24);
> +	memcpy(mgmt->da, da, ETH_ALEN);
> +	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_AP)
> +		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
> +	else
> +		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> +	mgmt->frame_control =3D IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> +					   IEEE80211_STYPE_ACTION);
> +
> +	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
> +	mgmt->u.action.category =3D WLAN_CATEGORY_BACK;
> +	mgmt->u.action.u.addba_resp.action_code =3D WLAN_ACTION_ADDBA_RESP;
> +	mgmt->u.action.u.addba_resp.dialog_token =3D dialog_token;
> +
> +	capab =3D (u16)(policy << 1);	/* bit 1 aggregation policy */
> +	capab |=3D (u16)(tid << 2); 	/* bit 5:2 TID number */
> +	capab |=3D (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
> +
> +	mgmt->u.action.u.addba_resp.capab =3D cpu_to_le16(capab);
> +	mgmt->u.action.u.addba_resp.timeout =3D cpu_to_le16(timeout);
> +	mgmt->u.action.u.addba_resp.status =3D cpu_to_le16(status);
> +
> +	ieee80211_sta_tx(dev, skb, 0);
> +
> +	return;
> +}
> +
> +static void ieee80211_sta_process_addba_request(struct net_device *dev,
> +						struct ieee80211_mgmt *mgmt,
> +						size_t len)
> +{
> +	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sta_info *sta;
> +	u16 capab, tid, timeout, ba_policy, buf_size, status;
> +	u8 dialog_token;
> +
> +	sta =3D sta_info_get(local, mgmt->sa);
> +	if (!sta)
> +		return;
> +
> +	/* extract session parameters from addba request frame */
> +	dialog_token =3D mgmt->u.action.u.addba_req.dialog_token;
> +	timeout =3D le16_to_cpu(mgmt->u.action.u.addba_req.timeout);
> +
> +	capab =3D le16_to_cpu(mgmt->u.action.u.addba_req.capab);
> +	ba_policy =3D (capab & IEEE80211_ADDBA_PARAM_POLICY_MASK) >> 1;
> +	tid =3D (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
> +	buf_size =3D (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
> +
> +	/* TODO - currently aggregation is declined (A-MPDU add BA request
> +	* acceptance is not obligatory by 802.11n draft), but here is
> +	* the entry point for dealing with it */
> +#ifdef MAC80211_HT_DEBUG
> +	if (net_ratelimit())
> +		printk(KERN_DEBUG "Add Block Ack request arrived,"
> +				   " currently denying it\n");
> +#endif /* MAC80211_HT_DEBUG */
> +
> +	status =3D WLAN_STATUS_REQUEST_DECLINED;
> +
> +	ieee80211_send_addba_resp(sta->dev, sta->addr, tid, dialog_token,
> +				status, 1, buf_size, timeout);
> +	sta_info_put(sta);
> +}
> =20
>  static void ieee80211_rx_mgmt_auth(struct net_device *dev,
>  				   struct ieee80211_if_sta *ifsta,
> @@ -1864,6 +1956,34 @@ static void ieee80211_rx_mgmt_probe_req(struct net=
_device *dev,
>  	ieee80211_sta_tx(dev, skb, 0);
>  }
> =20
> +void ieee80211_rx_mgmt_action(struct net_device *dev,
> +			     struct ieee80211_if_sta *ifsta,
> +			     struct ieee80211_mgmt *mgmt,
> +			     size_t len)
> +{
> +	if (len < IEEE80211_MIN_ACTION_SIZE)
> +		return;
> +
> +	switch (mgmt->u.action.category) {
> +	case WLAN_CATEGORY_BACK:
> +		switch (mgmt->u.action.u.addba_req.action_code) {
> +		case WLAN_ACTION_ADDBA_REQ:
> +			if (len < (IEEE80211_MIN_ACTION_SIZE +
> +				   sizeof(mgmt->u.action.u.addba_req)))
> +				break;
> +			ieee80211_sta_process_addba_request(dev, mgmt, len);
> +			break;
> +		default:
> +			if (net_ratelimit())
> +			   printk(KERN_DEBUG "%s: received unsupported BACK\n",
> +					dev->name);
> +			break;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +}
> =20
>  void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
>  			   struct ieee80211_rx_status *rx_status)
> @@ -1893,6 +2013,7 @@ void ieee80211_sta_rx_mgmt(struct net_device *dev, =
struct sk_buff *skb,
>  	case IEEE80211_STYPE_REASSOC_RESP:
>  	case IEEE80211_STYPE_DEAUTH:
>  	case IEEE80211_STYPE_DISASSOC:
> +	case IEEE80211_STYPE_ACTION:
>  		skb_queue_tail(&ifsta->skb_queue, skb);
>  		queue_work(local->hw.workqueue, &ifsta->work);
>  		return;
> @@ -1950,6 +2071,9 @@ static void ieee80211_sta_rx_queued_mgmt(struct net=
_device *dev,
>  	case IEEE80211_STYPE_DISASSOC:
>  		ieee80211_rx_mgmt_disassoc(dev, ifsta, mgmt, skb->len);
>  		break;
> +	case IEEE80211_STYPE_ACTION:
> +		ieee80211_rx_mgmt_action(dev, ifsta, mgmt, skb->len);
> +		break;
>  	}
> =20
>  	kfree_skb(skb);

--=-XBC7qi33g1DWC/RUtTJW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r0/aVg1VMiehFYAQKwtBAAk/5qddyLQex6Z66hDoDsEOoRdfHoYHYQ
Oj/zrjCu4Xt8Ctl/jyX5Zy7XQUXGF8QM5iAWcyZ8wNCSJEBknb6/Qg/5I8fxG7Dd
mB1E1z3T9TGhI5RJMhOl/4QJJ6EtKxYGUZgoqiEVKzaagMQ81ePADiN7SafgHUOg
fb2/ZCJIFyWcXEfMRfHnznDEJlkA2BIxNhy2xHbRsFR00YBQfkFJsw07eT48N8nu
GPRpvjEkJJDttkJKwk1T+mr00t+y60/SRQc7P6pDpQD28D4/i7mDPbn5gHlESj7P
Kk+xbu4NCisEooRoSLKiaijqtQ05ZDsDN81+ahOYPXi/taI+nqbGoymoAm/IetD/
FYAcHZ1BJkGhsBjOF9tXJ5f3wQDKQcTu5sXpGZHUcmzYBvLdgu3oxm3wpnJsBWdF
DHujfigCmQTCaqQaVbdnJfNryp63LHCmtzii7IuR8vTXkFI9waqfNNTnuuQar5+A
4Wm29ky37mRxejUlRAXmThzpz/xwJdCTNg/9KU1GjgA5CXEQb9W8iAXWlLvqD/+b
4STciPrSkTfxNb7CJEvAr39XC7Kf5IawI9fAEbfDp2doPfzdM2E/3CZAdnnrTXO+
WEtcGxcSqgtWSpr6uvIi3QlRdhkEDSW4ti+Et2/TxsvqvY31dtKHBPGq43myi4h8
FPyuqwYtc2o=
=SDUG
-----END PGP SIGNATURE-----

--=-XBC7qi33g1DWC/RUtTJW--

