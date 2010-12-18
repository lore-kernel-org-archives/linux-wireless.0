Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50607 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab0LRB3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 20:29:36 -0500
Received: by gwb20 with SMTP id 20so838063gwb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 17:29:35 -0800 (PST)
Message-ID: <4D0C0E5F.4030605@lwfinger.net>
Date: Fri, 17 Dec 2010 19:29:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [RFT] rtlwifi: use alloc_workqueue
References: <1292529589-5904-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1292529589-5904-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 01:59 PM, John W. Linville wrote:
> create_workqueue is deprecated.  The workqueue usage does not seem to
> demand any special treatment, so do not set any flags either.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> I don't have the hardware to test...
> 
>  drivers/net/wireless/rtlwifi/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
> index 9e860ff..24a7cd3 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -225,7 +225,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
>  
>  	/* <2> work queue */
>  	rtlpriv->works.hw = hw;
> -	rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);
> +	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
>  	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
>  			  (void *)rtl_watchdog_wq_callback);
>  	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,

After further testing, this patch is OK. The problem I saw had another source.

Add Tested-by: Larry Finger

Larry

