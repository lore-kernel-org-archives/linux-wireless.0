Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53305 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0IOTQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:16:06 -0400
Subject: Re: [PATCH 01/04] wl1271: 11n Support, Add Definitions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284575472-19888-2-git-send-email-shahar_levi@ti.com>
References: <1284575472-19888-1-git-send-email-shahar_levi@ti.com>
	 <1284575472-19888-2-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 22:15:53 +0300
Message-ID: <1284578153.1569.24.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 20:31 +0200, ext Shahar Levi wrote:
> Added all definitions needed for 11n support.

This could be a bit more descriptive...


> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---



> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
> index 4235bc5..2a8fc43 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
> @@ -993,6 +993,97 @@ struct wl1271_acx_rssi_snr_avg_weights {
>  	u8 snr_data;
>  };
>  
> +/* 11n command to the FW */
> +/*	Name:	ACX_PEER_HT_CAP
> +*	Desc:	Configure HT capabilities - declare the capabilities of the peer
> +*		we are connected to.
> +* Type:	Configuration
> +* Access:	Write Only
> +* Length:
> +*/
> +struct wl1271_acx_ht_capabilities {
> +	struct acx_header header;
> +
> +	/*
> +	* bit 0 - Allow HT Operation
> +	* bit 1 - Allow Greenfield format in TX
> +	* bit 2 - Allow Short GI in TX
> +	* bit 3 - Allow L-SIG TXOP Protection in TX
> +	* bit 4 - Allow HT Control fields in TX.
> +	*	Note, driver will still leave space for HT control in packets
> +	*	regardless of the value of this field. FW will be responsible to
> +	*	drop the HT field from any frame when this Bit is set to 0.
> +	* 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
> +	*	Exact policy setting for this feature is TBD.
> +	*	Note, this bit can only be set to 1 if bit 3 is set to 1.
> +	*/
> +	u32 ht_capabilites;

This should be __le32 instead.


> +/*  HT Capabilites Fw Bit Mask Mapping */
> +enum acx_ht_capabilites_fw {
> +	WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION               =  BIT(0),
> +	WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT    =  BIT(1),
> +	WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS =  BIT(2),
> +	WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION       =  BIT(3),
> +	WL1271_ACX_FW_CAP_BIT_MASK_HT_CONTROL_FIELDS          =  BIT(4),
> +	WL1271_ACX_FW_CAP_BIT_MASK_RD_INITIATION              =  BIT(5)
> +};

I have a slight preference to use #defines for this kind of definition,
but we use it in both ways currently, so no need to change.

It is common practice to add a , after the last value in the
enumeration, so that if any new lines are added in the future, the
previous one doesn't need to be changed.  So please change to this:

+	WL1271_ACX_FW_CAP_BIT_MASK_RD_INITIATION              =  BIT(5),


> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index af26150..ae69397 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -2041,6 +2041,19 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>  	0                              /* CONF_HW_RXTX_RATE_1    */
>  };
>  
> +/* 11n sta capabilities */
> +#define WL12xx_HT_CAP { \
> +	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20, \
> +	.ht_supported = true, \
> +	.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K, \
> +	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_8, \
> +	.mcs = { \
> +		.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, }, \
> +		.rx_highest = cpu_to_le16(65), \
> +		.tx_params = IEEE80211_HT_MCS_TX_DEFINED, \
> +		}, \
> +}

I don't like this macro.  I'd rather have this explicitly defined
(despite twice) in wl1271_band_2ghz and wl1271_band_5ghz.

Also, it would be nice to avoid using magic numbers (ie. 65).  Is it
possible to define a descriptive macro for instead?

-- 
Cheers,
Luca.

