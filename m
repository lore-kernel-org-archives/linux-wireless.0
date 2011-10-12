Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1JLINs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 04:13:48 -0400
Subject: Re: [RFC 01/07] wireless-next: WAPI support for
 hardware-accelerated drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
In-Reply-To: <op.v27rufm9ya27un@edmitar> (sfid-20111012_030239_221122_93C5737F)
References: <op.v27rufm9ya27un@edmitar>
	 (sfid-20111012_030239_221122_93C5737F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 10:13:44 +0200
Message-ID: <1318407224.3933.10.camel@jlt3.sipsolutions.net> (sfid-20111012_101351_819705_9E0CEB8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Thanks for sending these patches.

Process things first: Your patches are line-wrapped in a few places.
You'll have to fix that later (but it's not very important for the first
round of review)

> This commit implements WAPI support for hardware-accelerated devices.

Note that there's at least one device that supports WAPI already, it has
HW crypto for SMS4. So it is already possible to implement. I'm not
saying this patch is bad though, it may be good to make things gradually
more generic.

> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -586,6 +586,7 @@
>   #define IW_AUTH_WPA_VERSION_DISABLED	0x00000001
>   #define IW_AUTH_WPA_VERSION_WPA		0x00000002
>   #define IW_AUTH_WPA_VERSION_WPA2	0x00000004
> +#define IW_AUTH_WPA_VERSION_WAPI	0x00000008

I don't think we should be extending wireless extensions any more, so
please remove all the wireless extensions bits from your patch(es).


> --- a/net/mac80211/Makefile

This patch is changing both mac80211 and cfg80211. I'd prefer to have
clearly separated patches so it is easier to tell which part is mac80211
specific and which will apply to other drivers that don't use mac80211.


> +++ b/net/mac80211/ieee80211_i.h
> @@ -42,7 +42,7 @@ struct ieee80211_local;
>   #define TOTAL_MAX_TX_BUFFER 512
> 
>   /* Required encryption head and tailroom */
> -#define IEEE80211_ENCRYPT_HEADROOM 8
> +#define IEEE80211_ENCRYPT_HEADROOM 20

Hmm. This is pretty wasteful. Is this really the only way you can do
this?

> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -716,6 +716,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>   		WLAN_CIPHER_SUITE_WEP104,
>   		WLAN_CIPHER_SUITE_TKIP,
>   		WLAN_CIPHER_SUITE_CCMP,
> +		WLAN_CIPHER_SUITE_SMS4,

This is quite clearly not true -- you don't support SMS4 unless the
hardware has support for it. As a result, you can't put this here -- you
need to make your low-level driver override the cipher list. See wl12xx
for example.

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -31,6 +31,7 @@
>   #include "mesh.h"
>   #include "wep.h"
>   #include "wpa.h"
> +#include "wapi.h"
>   #include "wme.h"
>   #include "rate.h"
> 
> @@ -592,6 +593,11 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data  
> *tx)
>   			if (!ieee80211_is_mgmt(hdr->frame_control))
>   				tx->key = NULL;
>   			break;
> +
> +		case WLAN_CIPHER_SUITE_SMS4:
> +			if (tx->ethertype == ETH_P_WAPI)
> +				tx->key = NULL;
> +			break;

This is wrong -- and already covered by
ieee80211_tx_h_check_control_port_protocol() if you set that up
correctly from nl80211. Another reason to get rid of wireless extensions
support for this.

> +static int ieee80211_wapi_decrypt(struct ieee80211_local *local,
> +				  struct sk_buff *skb,
> +				  struct ieee80211_key *key)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> +	int data_len;
> +
> +	if (!(status->flag & RX_FLAG_DECRYPTED)) {
> +		/* TODO - SMS4 decryption for firmware without
> +		 * SMS4 support */
> +		return RX_DROP_UNUSABLE;
> +	}
> +
> +
> +	data_len = skb->len - hdrlen - WAPI_IV_LEN - WAPI_ICV_LEN;
> +	if (data_len < 0)
> +		return RX_DROP_UNUSABLE;
> +
> +	/* Trim ICV */
> +	skb_trim(skb, skb->len - WAPI_ICV_LEN);
> +
> +	/* Remove IV */
> +	memmove(skb->data + WAPI_IV_LEN, skb->data, hdrlen);
> +	skb_pull(skb, WAPI_IV_LEN);
> +
> +	return RX_CONTINUE;

This is wrong -- if the device didn't strip the IV it likely also didn't
*check* the IV, so it should be checked here. If it *did* check the IV
then we expect drivers to strip it as well.

> +}
> +
> +ieee80211_rx_result
> +ieee80211_crypto_wapi_decrypt(struct ieee80211_rx_data *rx)
> +{
> +	struct sk_buff *skb = rx->skb;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +
> +	if (!ieee80211_is_data(hdr->frame_control))
> +		return RX_CONTINUE;

This probably needs to check data_present, not is_data. But again, I
think if you just strip the IV you can simplify this and move it into
the driver, like wl12xx, unless you need to verify the IV.


> +++ b/net/mac80211/wapi.h

This header file is unnecessary.

> +#ifndef ETH_P_WAPI
> +#define ETH_P_WAPI     0x88B4
> +#endif

This you don't actually need any more given my comments above.

> +ieee80211_rx_result
> +ieee80211_crypto_wapi_decrypt(struct ieee80211_rx_data *rx);

We can stick that into wpa.h. It also needs to be renamed -- it's not
doing decryption. I think you should get rid of it unless you need it to
check IVs.

> @@ -4167,7 +4167,8 @@ static bool nl80211_valid_auth_type(enum  
> nl80211_auth_type auth_type)
>   static bool nl80211_valid_wpa_versions(u32 wpa_versions)
>   {
>   	return !(wpa_versions & ~(NL80211_WPA_VERSION_1 |
> -				  NL80211_WPA_VERSION_2));
> +				  NL80211_WPA_VERSION_2 |
> +				  NL80211_WAPI_VERSION_1));
>   }

If your device is a mac80211 device then this isn't really needed.

johannes

