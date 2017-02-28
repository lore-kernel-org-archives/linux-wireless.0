Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:37414 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751332AbdB1JFx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 04:05:53 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 2113E5E289
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 06:33:09 +0000 (UTC)
Message-ID: <1488263468.25838.23.camel@perches.com> (sfid-20170228_100836_896349_02977780)
Subject: Re: [PATCH v2 3/4] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 27 Feb 2017 22:31:08 -0800
In-Reply-To: <1488232593-2552-3-git-send-email-greearb@candelatech.com>
References: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
         <1488232593-2552-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-27 at 13:56 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This makes it easier to understand why wmediumd (or similar)
> is getting errors when sending frames to the kernel.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2:  Add and use hwsim_ratelimit() instead of net_ratelimit.
>      Squash two patches into this one.
> 
>  drivers/net/wireless/mac80211_hwsim.c | 55 +++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
[]
> @@ -137,6 +137,12 @@ static int regtest = HWSIM_REGTEST_DISABLED;
>  module_param(regtest, int, 0444);
>  MODULE_PARM_DESC(regtest, "The type of regulatory test we want to run");
>  
> +DEFINE_RATELIMIT_STATE(hwsim_ratelimit_state, 5 * HZ, 10);
> +int hwsim_ratelimit(void)
> +{
> +	return __ratelimit(&hwsim_ratelimit_state);
> +}

Maybe it'd be better to add a function like

__printf(1, 2)
static void hwsim_dbg_ratelimited(const char *fmt, ...)
{
	struct va_format vaf;
	va_list args;

	if (!__ratelimit(&hwsim_ratelimit_state))
		return;

	va_start(args, fmt);

	vaf.fmt = fmt;
	vaf.va = &args;

	printk(KERN_DEBUG "hwsim rx-nl: %pV", &vaf);

	va_end(args);	
}

[]
> @@ -3018,8 +3024,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
>  	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
>  	    !info->attrs[HWSIM_ATTR_FRAME] ||
>  	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
> -	    !info->attrs[HWSIM_ATTR_SIGNAL])
> +	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
> +		if (hwsim_ratelimit())
> +			printk(KERN_DEBUG " hwsim rx-nl: Missing required attribute\n");

so this becomes:

		hwsim_dbg_ratelimited("Missing required attribute\n");

and why are these currently indented with a space?

>  		goto out;
> +	}
>  
>  	dst = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
>  	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
> @@ -3027,29 +3036,53 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
>  
>  	/* Allocate new skb here */
>  	skb = alloc_skb(frame_data_len, GFP_KERNEL);
> -	if (skb == NULL)
> -		goto err;
> +	if (skb == NULL) {
> +		if (hwsim_ratelimit())
> +			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
> +			       frame_data_len);

		hwsim_dbg_ratelimited("skb alloc failed, len: %d\n",
				      frame_data_len);

etc...
