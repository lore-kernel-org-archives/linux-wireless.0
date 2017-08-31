Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:32877 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbdHaUVv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 16:21:51 -0400
Received: by mail-pg0-f51.google.com with SMTP id t3so2114804pgt.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Aug 2017 13:21:51 -0700 (PDT)
Date: Thu, 31 Aug 2017 13:21:47 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: check for mfg_mode in add_virtual_intf
Message-ID: <20170831202146.GA27509@google.com> (sfid-20170831_222158_192791_1FCC01AA)
References: <1504118818-1749-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504118818-1749-1-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 31, 2017 at 12:16:58AM +0530, Ganapathi Bhat wrote:
> If driver is loaded with 'mfg_mode' enabled, then the sending
> commands are not allowed. So, when mwifiex_send_cmd fails in
> mwifiex_add_virtual_intf, driver must check for 'mfg_mode' before
> returning error.
> 
> Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index ffada17..1856205 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -2967,11 +2967,11 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
>  
>  	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
>  			       HostCmd_ACT_GEN_SET, 0, NULL, true);
> -	if (ret)
> +	if (ret && !adapter->mfg_mode)

It doesn't feel like ignoring errors is the best approach here,
especially when it's only a single command that we could easily just
skip.

So, why don't you just skip it, like this?

	if (!adapter->mfg_mode) {
		ret = mwifiex_send_cmd(...);
		if (ret)
			goto err_set_bss_mode;
	}

>  		goto err_set_bss_mode;
>  
>  	ret = mwifiex_sta_init_cmd(priv, false, false);
> -	if (ret)
> +	if (ret && !adapter->mfg_mode)
>  		goto err_sta_init;

Same here; I think it's safe to just completely skip
mwifiex_sta_init_cmd(), no?

Brian

>  
>  	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
> -- 
> 1.9.1
> 
