Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34389 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1JRHOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:14:54 -0400
Message-ID: <20111018100717.94287ia4tuafwk8w@www.81.fi> (sfid-20111018_091509_003919_277F7BD2)
Date: Tue, 18 Oct 2011 10:07:17 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rndis_wlan: add range check in del_key()
References: <20111018064729.GQ27732@elgon.mountain>
In-Reply-To: <20111018064729.GQ27732@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <dan.carpenter@oracle.com>:

> Wifi drivers can have up to 6 keys but the rndis_wlan only has 4 so
> it needs to have its own checks to make sure we don't go out of
> bounds.  The add_key() function already checks but I added some
> checks to del_key() and set_default_key().

Looks ok, thanks.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/rndis_wlan.c  
> b/drivers/net/wireless/rndis_wlan.c
> index 0c13840..da78369 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -414,6 +414,7 @@ struct ndis_80211_pmkid {
>  #define RNDIS_WLAN_ALG_TKIP	(1<<1)
>  #define RNDIS_WLAN_ALG_CCMP	(1<<2)
>
> +#define RNDIS_WLAN_NUM_KEYS		4
>  #define RNDIS_WLAN_KEY_MGMT_NONE	0
>  #define RNDIS_WLAN_KEY_MGMT_802_1X	(1<<0)
>  #define RNDIS_WLAN_KEY_MGMT_PSK		(1<<1)
> @@ -516,7 +517,7 @@ struct rndis_wlan_private {
>
>  	/* encryption stuff */
>  	int  encr_tx_key_index;
> -	struct rndis_wlan_encr_key encr_keys[4];
> +	struct rndis_wlan_encr_key encr_keys[RNDIS_WLAN_NUM_KEYS];
>  	int  wpa_version;
>
>  	u8 command_buffer[COMMAND_BUFFER_SIZE];
> @@ -1535,6 +1536,9 @@ static int remove_key(struct usbnet *usbdev,  
> int index, const u8 *bssid)
>  	bool is_wpa;
>  	int ret;
>
> +	if (index >= RNDIS_WLAN_NUM_KEYS)
> +		return -ENOENT;
> +
>  	if (priv->encr_keys[index].len == 0)
>  		return 0;
>
> @@ -2451,6 +2455,9 @@ static int rndis_set_default_key(struct wiphy  
> *wiphy, struct net_device *netdev,
>
>  	netdev_dbg(usbdev->net, "%s(%i)\n", __func__, key_index);
>
> +	if (key_index >= RNDIS_WLAN_NUM_KEYS)
> +		return -ENOENT;
> +
>  	priv->encr_tx_key_index = key_index;
>
>  	if (is_wpa_key(priv, key_index))
>
>



