Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33375 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0H3O3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:29:39 -0400
Date: Mon, 30 Aug 2010 10:17:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com
Subject: Re: [RFC 2/3] mac80211: allow drivers to specify sw scan wait
 constraints
Message-ID: <20100830141705.GC30864@tuxdriver.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
 <1282979590-31113-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1282979590-31113-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 28, 2010 at 03:13:09AM -0400, Luis R. Rodriguez wrote:

> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 14123dc..5025950 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -187,6 +187,22 @@ static inline void drv_sw_scan_start(struct ieee80211_local *local)
>  	trace_drv_return_void(local);
>  }
>  
> +static inline int drv_sw_scan_wait_constraints(struct ieee80211_local *local)
> +{
> +	bool wait_constraints = false;
> +
> +	might_sleep();
> +
> +	trace_drv_sw_scan_wait_constraints(local);
> +	if (local->ops->sw_scan_start)

Are we checking the right member here?

> +		wait_constraints =
> +			local->ops->sw_scan_wait_constraints(&local->hw);
> +	trace_drv_return_int(local, wait_constraints);
> +
> +	return wait_constraints;
> +}
> +
> +
>  static inline void drv_sw_scan_complete(struct ieee80211_local *local)
>  {
>  	might_sleep();

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
