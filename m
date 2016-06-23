Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45004 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbcFWT0i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 15:26:38 -0400
Message-ID: <1466709992.11061.6.camel@sipsolutions.net> (sfid-20160623_212653_412857_2DD85E24)
Subject: Re: [PATCH v2] mac80211: mesh: Add support for HW RC implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>, linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jun 2016 21:26:32 +0200
In-Reply-To: <20160623135319.7653-1-maxim.altshul@ti.com>
References: <20160623135319.7653-1-maxim.altshul@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +void sta_get_expected_throughput(struct sta_info *sta, u32 *thr)
> +{
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct ieee80211_local *local = sdata->local;
> +	struct rate_control_ref *ref = NULL;
> +
> +	if (test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> +		ref = local->rate_ctrl;
> +
> +	/* check if the driver has a SW RC implementation */
> +	if (ref && ref->ops->get_expected_throughput)
> +		*thr = ref->ops->get_expected_throughput(sta-
> >rate_ctrl_priv);
> +	else
> +		*thr = drv_get_expected_throughput(local, &sta-
> >sta);
> +}

I don't really see a reason for the function to take a u32 *thr, rather
than return u32? Would be clearer, IMHO, to just return the value.

Then in the user, it seems that you shouldn't use "rate" as the
variable that gets this result?

johannes
