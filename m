Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:20909 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab0JGSUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:20:20 -0400
Subject: Re: [PATCH v2 01/03] wl1271: 11n Support, Add Definitions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286388491-28752-3-git-send-email-shahar_levi@ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
	 <1286388491-28752-3-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 21:20:13 +0300
Message-ID: <1286475613.1662.41.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 20:08 +0200, ext Shahar Levi wrote:
> Two acx commands: ht_capabilities & ht_information, 11n sta capabilities macro.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Looks good! Some minor, mostly style-related, comments below.


> diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> index 779b130..777c937 100644
> --- a/drivers/net/wireless/wl12xx/wl1271.h
> +++ b/drivers/net/wireless/wl12xx/wl1271.h
> @@ -427,7 +427,7 @@ struct wl1271 {
>  	/* Our association ID */
>  	u16 aid;
>  
> -	/* currently configured rate set */
> +	/* currently configured rate set: bits0-15 BG, bits 16-23 MCS */

There a space missing after "bits" and I think you could use something a
bit clearer, for example: 

	/*
	 * currently configured rate set:
	 *	bits  0-15 - 802.11abg rates
	 *	bits 16-23 - 802.11n   MCS index mask
	*/

Maybe also a small comment saying that we support only 1 stream, thus
only 8 bits for the MCS rates (0-7)?


> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
> index ebb341d..5cf5a0d 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
> @@ -964,6 +964,96 @@ struct wl1271_acx_rssi_snr_avg_weights {
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

We don't have this style of comment elsewhere, wouldn't it be better to
use something more free format?


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

Please align the Note with the "Allow HT Control..." above to make it
clear that the note is about bit 4.


> +	* 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
> +	*	Exact policy setting for this feature is TBD.
> +	*	Note, this bit can only be set to 1 if bit 3 is set to 1.

"bit 5 -" instead of "5 -" and also align the "Exact policy..." and
"Note".


> +	/*
> +	* This the maximum a-mpdu length supported by the AP. The FW may not

Upper-case the a-mpdu to A-MPDU for consistency.

> +	* exceed this length when sending A-MPDUs
> +	*/
> +	u8  ampdu_max_length;
> +
> +	/*
> +	* This is the minimal spacing required when sending A-MPDUs to the AP
> +	*/
> +	u8 ampdu_min_spacing;
> +} __packed;
> +
> +/*  HT Capabilites Fw Bit Mask Mapping */
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION			BIT(0)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT	BIT(1)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS	BIT(2)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION		BIT(3)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_CONTROL_FIELDS		BIT(4)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_RD_INITIATION		BIT(5)

No need for the TABs after the #defines.


> +/* Name:	ACX_HT_BSS_OPERATION
> + * Desc:	Configure HT capabilities - AP rules for behavior in the BSS.
> + * Type:	Configuration
> + * Access:	Write Only
> + * Length:
> + */

Same as my previous comment.  No directly copied comments from TI's
reference driver, please.


> +struct wl1271_acx_ht_information {
> +	struct acx_header header;
> +
> +	u8 rifs_mode;	/* Values: 0 - RIFS not allowed, 1 - RIFS allowed */

Put the comments before the value, as everywhere else.


> +	u8 ht_protection;	/* Values: 0 - 3 like in spec */

Same here.


> +	/*
> +	* Values: 0 - GF protection not required, 1 - GF protection required
> +	*/
> +	u8 gf_protection;

If the comment fits in one line, don't use the extra lines with /* and
*/.


> +	/*
> +	* Values: 0 - TX Burst limit not required, 1 - TX Burst Limit required
> +	*/
> +	u8 ht_tx_burst_limit;

Same here.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
> index 60c50d1..732e9aa 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_conf.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
> @@ -91,6 +91,10 @@ enum {
>  	CONF_HW_RXTX_RATE_UNSUPPORTED = 0xff
>  };
>  
> +#define HW_RX_HIGHEST_RATE	65
> +#define HW_BG_RATES_MASK	0xffff
> +#define HW_HT_RATES_OFFSET	16

We preceed all the other macros with CONF_, please do the same for
these.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index cb18f22..bef2c24 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -2122,6 +2122,19 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>  	0                              /* CONF_HW_RXTX_RATE_1    */
>  };
>  
> +/* 11n sta capabilities */

Use STA for consistency.


> +#define WL12xx_HT_CAP { \

As we discussed separately, please use WL1271_HT_CAP.  Later, when we
rename the driver, we can change it to WL12XX_HT_CAP together with
everything else.  Let's keep everything as WL1271 for now, for
consistency.


-- 
Cheers,
Luca.

