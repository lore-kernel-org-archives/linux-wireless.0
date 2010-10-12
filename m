Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:22370 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab0JLNqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 09:46:14 -0400
Subject: Re: [PATCH v3 02/03] wl1271: 11n Support, ACX Commands
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286812038-19013-3-git-send-email-shahar_levi@ti.com>
References: <1286812038-19013-1-git-send-email-shahar_levi@ti.com>
	 <1286812038-19013-3-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 16:46:09 +0300
Message-ID: <1286891169.12528.43.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 17:47 +0200, ext Shahar Levi wrote:
> Added ACX command to the FW for 11n support.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

More minors.


> diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
> index 6189934..cd89482 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_acx.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
> @@ -1226,6 +1226,91 @@ out:
>  	return ret;
>  }
>  
> +int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
> +				    struct ieee80211_sta_ht_cap *ht_cap,
> +				    bool allow_ht_operation)
> +{
> +	struct wl1271_acx_ht_capabilities *acx;
> +	u8 mac_address[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};

As I said in my comment to 01/03, it's better to have the comment about
this here and not in the header.


> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
> +	if (!acx) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Allow HT Operation ? */
> +	if (allow_ht_operation) {
> +		acx->ht_capabilites =
> +		  WL1271_ACX_FW_CAP_BIT_MASK_HT_OPERATION;
> +		acx->ht_capabilites |=
> +		  ((ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD) ?
> +		   WL1271_ACX_FW_CAP_BIT_MASK_GREENFIELD_FRAME_FORMAT : 0);
> +		acx->ht_capabilites |=
> +		  ((ht_cap->cap & IEEE80211_HT_CAP_SGI_20) ?
> +		   WL1271_ACX_FW_CAP_BIT_MASK_SHORT_GI_FOR_20MHZ_PACKETS : 0);
> +		acx->ht_capabilites |=
> +		  ((ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT) ?
> +		   WL1271_ACX_FW_CAP_BIT_MASK_LSIG_TXOP_PROTECTION : 0);

We use one full TAB for indentation on the next line after an = sign.
Some of this won't fit in 80 chars width, but that's because they're too
long anyway.

So two things to change: first, you can remove the _BIT_MASK part of all
this macros, so they're shorter; second, add a full TAB in the
indentation, like this:

		acx->ht_capabilites =
			WL1271_ACX_FW_CAP_HT_OPERATION;

> +
> +		/* get data from A-MPDU parameters field */
> +		acx->ampdu_max_length = ht_cap->ampdu_factor;
> +		acx->ampdu_min_spacing = ht_cap->ampdu_density;
> +
> +		memcpy(acx->mac_address, mac_address, ETH_ALEN);
> +	}
> +	/* HT operations are not allowed */
> +	else {
> +		acx->ht_capabilites = 0;
> +	}

	} else {
		acx->ht_capabilities = 0;
	}

If you still want to add the "HT operations are not allowed" comment,
add it in the same line where "} else {" is.


-- 
Cheers,
Luca.

