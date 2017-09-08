Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34752 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757119AbdIHTmd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 15:42:33 -0400
Received: by mail-pf0-f171.google.com with SMTP id e1so5981874pfk.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 12:42:33 -0700 (PDT)
Date: Fri, 8 Sep 2017 12:42:28 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: check for mfg_mode in add_virtual_intf
Message-ID: <20170908194227.GA65107@google.com> (sfid-20170908_214322_064064_13ED0F42)
References: <1504816363-31015-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504816363-31015-1-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Could have used a 'v2' in the subject, but hopefully that doesn't bother
Kalle too much.

On Fri, Sep 08, 2017 at 02:02:43AM +0530, Ganapathi Bhat wrote:
> If driver is loaded with 'mfg_mode' enabled, then the sending
> commands are not allowed. So, skip sending commands, to firmware
> in mwifiex_add_virtual_intf if 'mfg_mode' is enabled.
> 
> Fixes: 7311ea850079 ("mwifiex: fix AP start problem for newly added interface")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
> v2: addressed Brian's comments.
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index 32c5074..ad1ebd8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -2959,18 +2959,21 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
>  	}
>  
>  	mwifiex_init_priv_params(priv, dev);
> -	mwifiex_set_mac_address(priv, dev);
>  
>  	priv->netdev = dev;
>  
> -	ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
> -			       HostCmd_ACT_GEN_SET, 0, NULL, true);
> -	if (ret)
> -		goto err_set_bss_mode;
> +	if (!adapter->mfg_mode) {
> +		mwifiex_set_mac_address(priv, dev);
>  
> -	ret = mwifiex_sta_init_cmd(priv, false, false);
> -	if (ret)
> -		goto err_sta_init;
> +		ret = mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
> +				       HostCmd_ACT_GEN_SET, 0, NULL, true);
> +		if (ret)
> +			goto err_set_bss_mode;
> +
> +		ret = mwifiex_sta_init_cmd(priv, false, false);
> +		if (ret)
> +			goto err_sta_init;
> +	}

Seems better to me.

Reviewed-by: Brian Norris <briannorris@chromium.org>

>  
>  	mwifiex_setup_ht_caps(&wiphy->bands[NL80211_BAND_2GHZ]->ht_cap, priv);
>  	if (adapter->is_hw_11ac_capable)
> -- 
> 1.9.1
> 
