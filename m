Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57165 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab2BBIXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 03:23:09 -0500
Received: by lahc1 with SMTP id c1so1177446lah.20
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 00:23:07 -0800 (PST)
Subject: Re: [PATCH v2 5/7] wl12xx: add RX data filter ACX commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>, eyal@wizery.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328021048-8944-6-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-6-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 10:23:03 +0200
Message-ID: <1328170983.3626.265.camel@cumari> (sfid-20120202_092314_956221_E177C89D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> (based on Pontus' patch)
> 
> Added commands for setting a specific filter
> and controlling the behaviour RX data filters
> implemented by the FW.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Why is Ido's sign-off here? (just curious)


> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index bc96db0..668d337 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1740,3 +1740,108 @@ out:
>  	return ret;
>  
>  }
> +
> +int wl1271_acx_toggle_rx_data_filter(struct wl1271 *wl, bool enable,
> +				     u8 default_action)

Instead of "toggle" we usually have "enable" in the function name.  This
is not very important, obviously, but if we get a v3 of this patch, you
could change it for a little more consistency. ;)


> {
> +	struct acx_rx_data_filter_state *acx;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_ACX, "acx toggle rx data filter en: %d act: %d",
> +		     enable, default_action);
> +
> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
> +	if (!acx) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	acx->enable = enable ? 1 : 0;

Do we really need this? We usually trust that enable will be either true
(1) or false (0).


> +int wl1271_acx_set_rx_data_filter(struct wl1271 *wl, u8 index, bool enable,
> +				  struct wl12xx_rx_data_filter *filter)
> +{
> +	struct acx_rx_data_filter_cfg *acx;
> +	int fields_size = 0;
> +	int acx_size;
> +	int ret;
> +
> +	if (enable && !filter) {
> +		wl1271_warning("acx_set_rx_data_filter: enable but no filter");
> +		return -EINVAL;
> +	}
> +
> +	if (index >= WL1271_MAX_RX_DATA_FILTERS) {
> +		wl1271_warning("acx_set_rx_data_filter: invalid filter idx(%d)",
> +			       index);
> +		return -EINVAL;
> +	}

Should we use BUG_ON instead? This is only used internally in the
driver, so if it get here, it's a bug.  And if the filters come from
userspace, we should validate them before continuing anyway.


> +	if (filter) {
> +		if (filter->action < FILTER_DROP ||
> +		    filter->action > FILTER_FW_HANDLE) {
> +			wl1271_warning("invalid filter action (%d)",
> +				       filter->action);
> +			return -EINVAL;
> +		}
> +
> +		if (filter->num_fields != 1 &&
> +		    filter->num_fields != 2) {
> +			wl1271_warning("invalid filter num_fields (%d)",
> +				       filter->num_fields);
> +			return -EINVAL;
> +		}

Same for these two.



> +	acx_size = roundup(sizeof(*acx) + fields_size, 4);

ALIGN()?


> +	acx = kzalloc(acx_size, GFP_KERNEL);
> +
> +	if (!acx)
> +		return -ENOMEM;
> +
> +	acx->enable = enable ? 1 : 0;

Same as above.


> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index 1463341..c18ad0a 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -277,6 +277,39 @@ struct wl1271_link {
>  	u8 ba_bitmap;
>  };
>  
> +#define WL1271_MAX_RX_DATA_FILTERS 4
> +#define WL1271_RX_DATA_FILTER_MAX_FIELD_PATTERNS 8

This is too long for a macro?


> +/* FW MAX FILTER SIZE is 98 bytes. The MAX_PATTERN_SIZE is imposed
> + * after taking into account the mask bytes and other structs members
> + */

This is slightly off according to the coding-style. ;)

Also s/structs/struct/


> +#define WL1271_RX_DATA_FILTER_MAX_PATTERN_SIZE 43
> +#define WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE 14
> +
> +#define WL1271_RX_DATA_FILTER_FLAG_MASK                BIT(0)
> +#define WL1271_RX_DATA_FILTER_FLAG_IP_HEADER           0
> +#define WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER     BIT(1)

It would also be nice to find some smaller names for these.


> +struct wl12xx_rx_data_filter_field {
> +	__le16 offset;
> +	u8 len;
> +	u8 flags;
> +	u8 pattern[0];
> +} __packed;
> +
> +struct wl12xx_rx_data_filter {
> +	u8 action;
> +	int num_fields;
> +	int fields_size;
> +	struct wl12xx_rx_data_filter_field fields[0];
> +} __packed;

No need for __packed here.  These are internal structs and not part of
the FW API.


-- 
Cheers,
Luca.

