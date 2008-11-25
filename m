Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYKYTg0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 14:36:26 -0500
Subject: Re: [PATCH] ipw2200: increase scan timeout
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	ipw2100-devel@lists.sourceforge.net
In-Reply-To: <200811251809.55461.helmut.schaa@gmail.com>
References: <200811251809.55461.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 14:35:37 -0500
Message-Id: <1227641737.24264.5.camel@localhost.localdomain> (sfid-20081125_203630_487476_90616ADC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-25 at 18:09 +0100, Helmut Schaa wrote:
> The current scan timeout is set to 5 seconds. If the timeout is hit because
> the firmware did not respond yet, the adapter gets restarted, which results
> in a disassociation.
> 
> However, in an environment with lots of access points the scan sometimes takes
> longer than 5 seconds. This patch simply increases the timeout to 10 seconds.
> 
> Signed-off-by: helmut.schaa@googlemail.com
> ---
> 
> I was able to reproduce the issue fairly reliable with a 2915 adapter by 
> periodically triggering scans while associated.
> 
> I have no idea in which situations the scan takes longer than 5 seconds to
> complete but maybe it might even take longer than 10 seconds. Has anybody from
> Intel insight into the firmware scan code?

Probably because with 802.11a, you have so many more channels to scan.
Depending on whether they are active or passive, you may be able to do
probe-scans on them, or you may have to sit on each channel for 120ms to
listen for beacons.  It's not unusual for cards that support A channels
to take two or three times as long for a scan as cards that support only
b/g, depending on the channel list.

dan

> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index c73173a..a776da3 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -2304,7 +2304,7 @@ static void ipw_bg_adapter_restart(struct work_struct *work)
>  	mutex_unlock(&priv->mutex);
>  }
>  
> -#define IPW_SCAN_CHECK_WATCHDOG (5 * HZ)
> +#define IPW_SCAN_CHECK_WATCHDOG (10 * HZ)
>  
>  static void ipw_scan_check(void *data)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

