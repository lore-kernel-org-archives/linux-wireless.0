Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42830 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753342AbdC2IrC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:47:02 -0400
Message-ID: <1490777219.7948.11.camel@sipsolutions.net> (sfid-20170329_104732_323581_B0068807)
Subject: Re: [PATCH v3 3/4] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:46:59 +0200
In-Reply-To: <1490311578-18926-3-git-send-email-greearb@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490311578-18926-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-23 at 16:26 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This makes it easier to understand why wmediumd (or similar)
> is getting errors when sending frames to the kernel.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 55
> +++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c
> b/drivers/net/wireless/mac80211_hwsim.c
> index 234df8c..84dcddf 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -137,6 +137,12 @@ static int regtest = HWSIM_REGTEST_DISABLED;
>  module_param(regtest, int, 0444);
>  MODULE_PARM_DESC(regtest, "The type of regulatory test we want to
> run");
>  
> +DEFINE_RATELIMIT_STATE(hwsim_ratelimit_state, 5 * HZ, 10);
> +int hwsim_ratelimit(void)
> +{
> +	return __ratelimit(&hwsim_ratelimit_state);
> +}
> +
>  static const char *hwsim_alpha2s[] = {
>  	"FI",
>  	"AL",
> @@ -1649,7 +1655,7 @@ static int mac80211_hwsim_config(struct
> ieee80211_hw *hw, u32 changed)
>  
>  	if (conf->chandef.chan)
>  		wiphy_debug(hw->wiphy,
> -			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d
> smps=%s)\n",
> +			    "%s (chandef-chan freq=%d(%d - %d)/%s
> idle=%d ps=%d smps=%s)\n",
>  			    __func__,
>  			    conf->chandef.chan->center_freq,
>  			    conf->chandef.center_freq1,
> @@ -1660,7 +1666,7 @@ static int mac80211_hwsim_config(struct
> ieee80211_hw *hw, u32 changed)
>  			    smps_modes[conf->smps_mode]);
>  	else
>  		wiphy_debug(hw->wiphy,
> -			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
> +			    "%s (no-chandef-chan freq=0 idle=%d
> ps=%d smps=%s)\n",

This seems unrelated?

johannes
