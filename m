Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0KDUuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 16:50:09 -0400
Subject: Re: [RFC 06/15] mac80211: add support for HW periodic scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-7-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:45:37 -0400
Message-ID: <1288885537.3659.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:

> +	.periodic_start= ieee80211_periodic_start,
> +	.periodic_stop= ieee80211_periodic_stop,

whitespace ... also, _scan really ...


> +	trace_drv_periodic_stop(local, sdata);
> +	ret = local->ops->periodic_stop(&local->hw, &sdata->vif);
> +	trace_drv_return_int(local, ret);
> +	return ret;

why does this have a return value?


> @@ -812,6 +812,7 @@ struct ieee80211_local {
>  	struct cfg80211_ssid scan_ssid;
>  	struct cfg80211_scan_request *int_scan_req;
>  	struct cfg80211_scan_request *scan_req, *hw_scan_req;
> +	struct cfg80211_periodic_request *periodic_req;

what do you need to store this for?

johannes


