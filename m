Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44263 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbYKYScD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 13:32:03 -0500
Subject: Re: [PATCH] ipw2200: increase scan timeout
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>
In-Reply-To: <200811251809.55461.helmut.schaa@gmail.com>
References: <200811251809.55461.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 10:32:51 -0800
Message-Id: <1227637971.13619.262.camel@rc-desk> (sfid-20081125_193208_111496_C1532231)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-25 at 09:09 -0800, Helmut Schaa wrote:
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
> 
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

I do not have insight into the scan code ... but I can try to find out
if there is something specific you need to know.

This change seems harmless and if it helps you it may help somebody else
too.

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you

Reinette

