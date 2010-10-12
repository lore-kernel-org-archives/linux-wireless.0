Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:25634 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab0JLNeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 09:34:14 -0400
Subject: Re: [PATCH v3 01/03] wl1271: 11n Support, Add Definitions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286812038-19013-2-git-send-email-shahar_levi@ti.com>
References: <1286812038-19013-1-git-send-email-shahar_levi@ti.com>
	 <1286812038-19013-2-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 16:34:09 +0300
Message-ID: <1286890449.12528.31.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 17:47 +0200, ext Shahar Levi wrote:
> Two acx commands: ht_capabilities & ht_information, 11n sta capabilities macro.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

A few more minor comments.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
> index ebb341d..90082c5 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.h
> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.h

[...]

> +	/*
> +	* Indicates to which peer these capabilities are relevant.
> +	* Note, currently this value will be set to FFFFFFFFFFFF to indicate it
> +	* is relevant for all peers since we only support HT in infrastructure
> +	* mode. Later on this field will be relevant to IBSS/DLS operation
> +	*/
> +	u8  mac_address[ETH_ALEN];

Okay, I was not very clear, but in my comment to patch 02/03, I said:
"[...]you could actually remove the Note from the wl1271_acx.h file and
leave it here[...]".  The reasoning to leave it in the C file is that it
is there that you actually set the mac_address to FFFFFFFFFFFF.  So,
remove from the wl1271_acx.h file and put it back on the wl1271_acx.c
file.


> +
> +	/*
> +	* This the maximum A-MPDU length supported by the AP. The FW may not
> +	* exceed this length when sending A-MPDUs
> +	*/
> +	u8  ampdu_max_length;
> +
> +	/*
> +	* This is the minimal spacing required when sending A-MPDUs to the AP
> +	*/

No need to have this comment in multiple lines.  You could write just
"Minimal spacing..." and then it will fit nicely in one line ;)


> +/* HT Capabilites Fw Bit Mask Mapping */
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION                 BIT(0)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT      BIT(1)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS	BIT(2)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION         BIT(3)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_HT_CONTROL_FIELDS            BIT(4)
> +#define	WL1271_ACX_FW_CAP_BIT_MASK_RD_INITIATION                BIT(5)

Repeating: No need for the TABs after the #defines.


> +/*
> + * ACX_HT_BSS_OPERATION
> + * Configure HT capabilities - AP rules for behavior in the BSS.
> + */
> +struct wl1271_acx_ht_information {
> +	struct acx_header header;
> +
> +	/* Values: 0 - RIFS not allowed, 1 - RIFS allowed */
> +	u8 rifs_mode;
> +
> +	/* Values: 0 - 3 like in spec */
> +	u8 ht_protection;
> +
> +	/* Values: 0 - GF protection not required, 1 - GF protection required */
> +	u8 gf_protection;
> +
> +	/*Values: 0 - TX Burst limit not required, 1 - TX Burst Limit required*/
> +	u8 ht_tx_burst_limit;
> +
> +	/*
> +	 * Values: 0 - Dual CTS protection not required,
> +	 *		   1 Dual CTS Protection required

Alignment.


-- 
Cheers,
Luca.

