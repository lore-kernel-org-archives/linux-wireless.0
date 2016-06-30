Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58940 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbcF3PEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 11:04:46 -0400
Message-ID: <1467299025.14836.0.camel@sipsolutions.net> (sfid-20160630_170527_261148_26655A6E)
Subject: Re: [PATCH v2] wlcore: Add support for get_expected_throughput
 opcode
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Altshul <maxim.altshul@ti.com>, linux-kernel@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>, Yaniv Machani <yanivma@ti.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 30 Jun 2016 17:03:45 +0200
In-Reply-To: <20160630145534.26052-1-maxim.altshul@ti.com> (sfid-20160630_165356_857494_C1EF09DF)
References: <20160630145534.26052-1-maxim.altshul@ti.com>
	 (sfid-20160630_165356_857494_C1EF09DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-06-30 at 17:49 +0300, Maxim Altshul wrote:
> Adding this opcode, allows the TI wireless driver,
> to report throughput directly from FW to mac80211.
> 
> This is used mainly for mesh metric calculation.
> 
> Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
> ---
> Changed the units of returned value.
> drv_get_expected_throughput returns units of Kbps 
> by definition, and thus we must comply as well.
> Mbps * 1000 = Kbps.
> 
>  drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index 39dec7d..cb1103b 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5851,6 +5851,20 @@ out:
>  	mutex_unlock(&wl->mutex);
>  }
>  
> +static u32 wlcore_op_get_expected_throughput(struct ieee80211_sta
> *sta)
> +{
> +	struct wl1271_station *wl_sta = (struct wl1271_station
> *)sta->drv_priv;
> +	struct wl1271 *wl = wl_sta->wl;
> +	u8 hlid = wl_sta->hlid;
> +	u32 ret = 0;
> +
> +	/* return in units of Kbps */
> +	if (wl)
> +		ret = (wl->links[hlid].fw_rate_mbps * 1000);
> +
I don't see how wl can ever be NULL?

Also, you can certainly remove the 'ret' variable.

johannes
