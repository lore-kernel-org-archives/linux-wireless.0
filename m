Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38768 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447Ab2BBJ2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 04:28:43 -0500
Received: by lahd3 with SMTP id d3so1268374lah.26
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 01:28:40 -0800 (PST)
Subject: Re: [PATCH v3 7/7] wl12xx: support wowlan wakeup patterns
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>, eyal@wizery.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328024820-18864-1-git-send-email-eliad@wizery.com>
References: <1328024820-18864-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 11:28:36 +0200
Message-ID: <1328174916.3626.296.camel@cumari> (sfid-20120202_102850_000008_BE751803)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 17:47 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> (based on Pontus' patch)
> 
> Use FW RX data filters to support cfg80211 wowlan wakeup patterns.
> This enables to wake up the host from suspend following detection
> of certain configurable patters within an incoming packet.

patterns


> Up to 4 patterns are supported. Once the host is resumed
> any configured RX data filter is cleared.
> A single pattern can match several bytes sequences with different
> offsets within a packet.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v3: fix sparse warnings

Thanks. :)

But sorry, this is a NACK, for the various reasons mentioned below.


> +static int
> +wl1271_build_rx_filter_field(struct wl12xx_rx_data_filter_field *field,
> +			     u8 *pattern, u8 len, u8 offset,
> +			     u8 *bitmask, u8 flags)
> +{
> +	u8 *mask;
> +	int i;
> +
> +	field->flags = flags | WL1271_RX_DATA_FILTER_FLAG_MASK;

I think it would be nicer to just use "field->flags |=
WL1271_RX_DATA_FILTER_FLAG_MASK" here and add the other flags outside
this function (before or after calling it).


> +
> +	/* Not using the capability to set offset within an RX filter field.
> +	 * The offset param is used to access pattern and bitmask.
> +	 */

Style.


> +	field->offset = 0;
> +	field->len = len;
> +	memcpy(field->pattern, &pattern[offset], len);
> +
> +	/* Translate the WowLAN bitmask (in bits) to the FW RX filter field
> +	   mask which is in bytes */

Style.

> +	mask = field->pattern + len;
> +
> +	for (i = offset; i < (offset+len); i++) {

Style, (offset + len).


> +		if (test_bit(i, (unsigned long *)bitmask))
> +			*mask = 0xFF;
> +
> +		mask++;
> +	}
> +
> +	return sizeof(*field) + len + (bitmask ? len : 0);
> +}

This function is quite ugly. :(


> +/* Allocates an RX filter returned through f
> +   which needs to be freed using kfree() */

Style.

> +static int wl1271_convert_wowlan_pattern_to_rx_filter(
> +	struct cfg80211_wowlan_trig_pkt_pattern *p,
> +	struct wl12xx_rx_data_filter **f)
> +{
> +	int filter_size, num_fields, fields_size;
> +	int first_field_size;
> +	int ret = 0;
> +	struct wl12xx_rx_data_filter_field *field;
> +	struct wl12xx_rx_data_filter *filter;
> +
> +	/* If pattern is longer then the ETHERNET header we split it into
> +	 * 2 fields in the rx filter as you can't have a single
> +	 * field across ETH header boundary. The first field will filter
> +	 * anything in the ETH header and the 2nd one from the IP header.
> +	 * Each field will contain pattern bytes and mask bytes
> +	 */

Style.


> +	if (p->pattern_len > WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE)
> +		num_fields = 2;
> +	else
> +		num_fields = 1;

Wouldn't it be nicer to have a boolean has_ip or something?


> +	fields_size = (sizeof(*field) * num_fields) + (2 * p->pattern_len);
> +	filter_size = sizeof(*filter) + fields_size;
> +
> +	filter = kzalloc(filter_size, GFP_KERNEL);
> +	if (!filter) {
> +		wl1271_warning("Failed to alloc rx filter");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	field = &filter->fields[0];
> +	first_field_size = wl1271_build_rx_filter_field(field,
> +			p->pattern,
> +			min(p->pattern_len,
> +			    WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE),
> +			0,
> +			p->mask,
> +			WL1271_RX_DATA_FILTER_FLAG_ETHERNET_HEADER);
> +
> +	field = (struct wl12xx_rx_data_filter_field *)
> +		  (((u8 *)filter->fields) + first_field_size);
> +
> +	if (num_fields > 1) {
> +		wl1271_build_rx_filter_field(field,
> +		     p->pattern,
> +		     p->pattern_len - WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE,
> +		     WL1271_RX_DATA_FILTER_ETH_HEADER_SIZE,
> +		     p->mask,
> +		     WL1271_RX_DATA_FILTER_FLAG_IP_HEADER);
> +	}
> +
> +	filter->action = FILTER_SIGNAL;
> +	filter->num_fields = num_fields;
> +	filter->fields_size = fields_size;
> +
> +	*f = filter;
> +	return 0;
> +
> +err:
> +	kfree(filter);
> +	*f = NULL;
> +
> +	return ret;
> +}

This function, together with the previous one, is totally spaghetti.  I
don't like it, there's no clear split between what each one does and
there's lots of forth-and-back happening.  Needs to be rewritten.


> +static int wl1271_configure_wowlan(struct wl1271 *wl,
> +				   struct cfg80211_wowlan *wow)
> +{
> +	int i, ret;
> +
> +	if (!wow) {
> +		wl1271_rx_data_filtering_enable(wl, 0, FILTER_SIGNAL);
> +		return 0;
> +	}
> +
> +	WARN_ON(wow->n_patterns > WL1271_MAX_RX_DATA_FILTERS);

Should this really be a WARN? Doesn't this come from userspace via
cfg80211?


> +	if (wow->any || !wow->n_patterns)
> +		return 0;
> +
> +	wl1271_rx_data_filters_clear_all(wl);

Should you clear the filters inside the if?


> +	/* Translate WoWLAN patterns into filters */
> +	for (i = 0; i < wow->n_patterns; i++) {
> +		struct cfg80211_wowlan_trig_pkt_pattern *p;
> +		struct wl12xx_rx_data_filter *filter = NULL;
> +
> +		p = &wow->patterns[i];
> +
> +		ret = wl1271_validate_wowlan_pattern(p);
> +		if (ret) {
> +			wl1271_warning("validate_wowlan_pattern "
> +				       "failed (%d)", ret);
> +			goto out;
> +		}

This would generate double-warnings, we don't need it.



> +
> +		ret = wl1271_convert_wowlan_pattern_to_rx_filter(p, &filter);
> +		if (ret) {
> +			wl1271_warning("convert_wowlan_pattern_to_rx_filter "
> +				       "failed (%d)", ret);
> +			goto out;
> +		}

Double-warning again.


> +		ret = wl1271_rx_data_filter_enable(wl, i, 1, filter);
> +
> +		kfree(filter);

More spaghetti with the allocation and deallocation of filter here.
This kfree should be at the end of the function, with out_free.  But
still, this is ugly.  Please balance this alloc/dealloc.


> +		if (ret) {
> +			wl1271_warning("rx_data_filter_enable "
> +				       " failed (%d)", ret);
> +			goto out;
> +		}
> +	}
> +
> +	ret = wl1271_rx_data_filtering_enable(wl, 1, FILTER_DROP);
> +	if (ret) {
> +		wl1271_warning("rx_data_filtering_enable failed (%d)", ret);
> +		goto out;
> +	}

Double-warning.


> @@ -1578,6 +1752,10 @@ static int wl1271_configure_suspend_sta(struct wl1271 *wl,
>  	if (ret < 0)
>  		goto out_unlock;
>  
> +	ret = wl1271_configure_wowlan(wl, wow);
> +	if (ret < 0)
> +		wl1271_error("suspend: Could not configure WoWLAN: %d", ret);
> +

Triple-warning! :(


-- 
Cheers,
Luca.

