Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40959 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161405AbeCATiz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 14:38:55 -0500
Received: by mail-wm0-f66.google.com with SMTP id t6so14392252wmt.5
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 11:38:54 -0800 (PST)
Subject: Re: [PATCH 1/2] cfg80211: Add support to enable or disable btcoex
To: Tamizh chelvam <tamizhr@codeaurora.org>, johannes@sipsolutions.net
References: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A9856CE.8000005@broadcom.com> (sfid-20180301_203922_215315_E50129A8)
Date: Thu, 1 Mar 2018 20:38:54 +0100
MIME-Version: 1.0
In-Reply-To: <1519927170-11920-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/1/2018 6:59 PM, Tamizh chelvam wrote:
> From: Tamizh chelvam <tamizhr@codeaurora.org>
>
> This patch introduces NL80211_CMD_SET_BTCOEX command and
> NL80211_ATTR_BTCOEX_OP attribute to enable or disable btcoex.

What kind of btcoex are we talking about here? Is it signalling between 
wlan and bt to get access to the shared RF. Why would it require 
user-space interaction? Are there no options for wlan to detect bt is in 
use, ie. bt hci is setup, and vice versa. Can it be indicated in 
platform data or device tree. Trying to understand the use-case here.

> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
> ---
>   include/net/cfg80211.h       |    4 ++++
>   include/uapi/linux/nl80211.h |   10 ++++++++++
>   net/wireless/nl80211.c       |   28 ++++++++++++++++++++++++++++
>   net/wireless/rdev-ops.h      |   11 +++++++++++
>   net/wireless/trace.h         |   15 +++++++++++++++
>   5 files changed, 68 insertions(+)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index fc40843..b0e8bf6 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2960,6 +2960,9 @@ struct cfg80211_external_auth_params {
>    *
>    * @external_auth: indicates result of offloaded authentication processing from
>    *     user space
> + *
> + * @set_btcoex: This callback used to Enable/disable btcoex

Bit strange to capitalize Enable here.

> + *
>    */
>   struct cfg80211_ops {
>   	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -3255,6 +3258,7 @@ struct cfg80211_ops {
>   			   const u8 *aa);
>   	int     (*external_auth)(struct wiphy *wiphy, struct net_device *dev,
>   				 struct cfg80211_external_auth_params *params);
> +	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled);
>   };
>
>   /*
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index c13c843..3fb45b2 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1018,6 +1018,8 @@
>    *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
>    *	address(specified in &NL80211_ATTR_MAC).
>    *
> + * @NL80211_CMD_SET_BTCOEX: Enable/Disable btcoex using %NL80211_ATTR_BTCOEX_OP.
> + *
>    * @NL80211_CMD_MAX: highest used command number
>    * @__NL80211_CMD_AFTER_LAST: internal use
>    */
> @@ -1228,6 +1230,8 @@ enum nl80211_commands {
>
>   	NL80211_CMD_STA_OPMODE_CHANGED,
>
> +	NL80211_CMD_SET_BTCOEX,
> +
>   	/* add new commands above here */
>
>   	/* used to define NL80211_CMD_MAX below */
> @@ -2196,6 +2200,10 @@ enum nl80211_commands {
>    * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
>    *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
>    *
> + * @NL80211_ATTR_BTCOEX_OP: u8 attribute for driver supporting

How is user-space supposed to know the driver is supporting btcoex. I do 
not see any advertisement in this patch. Should probably add ext_feature 
flag for this.

> + *	the btcoex feature. This will be used with %NL80211_CMD_SET_BTCOEX
> + *	to enable/disable btcoex.

What does 'OP' stand for. Why not just call it 'ENABLE'. Also no need to 
make this u8. A flag attribute type seems sufficient here.

> + *
>    * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>    * @NL80211_ATTR_MAX: highest attribute number currently defined
>    * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2628,6 +2636,8 @@ enum nl80211_attrs {
>   	NL80211_ATTR_NSS,
>   	NL80211_ATTR_ACK_SIGNAL,
>
> +	NL80211_ATTR_BTCOEX_OP,
> +
>   	/* add attributes here, update the policy in nl80211.c */
>
>   	__NL80211_ATTR_AFTER_LAST,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index a910150..ebd119b 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -422,6 +422,7 @@ enum nl80211_multicast_groups {
>   	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
>   	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
>   	[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT] = { .type = NLA_FLAG },
> +	[NL80211_ATTR_BTCOEX_OP] = { .type = NLA_U8 },

so:	[NL80211_ATTR_BTCOEX_ENABLE] = { .type = NLA_FLAG },

>   };
>
>   /* policy for the key attributes */
> @@ -12517,6 +12518,25 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
>   	return rdev_external_auth(rdev, dev, &params);
>   }
>
> +static int nl80211_set_btcoex(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	u8 val = 0;
> +
> +	if (!rdev->ops->set_btcoex)
> +		return -ENOTSUPP;

For missing callback ops we generally use -EOPNOTSUPP.

> +	if (!info->attrs[NL80211_ATTR_BTCOEX_OP])
> +		return -EINVAL;
> +
> +	val = nla_get_u8(info->attrs[NL80211_ATTR_BTCOEX_OP]);
> +
> +	if (val > 1)
> +		return -EINVAL;
> +
> +	return rdev_set_btcoex(rdev, val);

When using NLA_FLAG you can just say:

   +	return rdev_set_btcoex(rdev,
   +			       info->attrs[NL80211_ATTR_BTCOEX_ENABLE]);

and get rid of the EINVAL checks. Of course, you need to document the 
attribute needs to be added to enable and omitted to disable btcoex.

> +}
> +
>   #define NL80211_FLAG_NEED_WIPHY		0x01
>   #define NL80211_FLAG_NEED_NETDEV	0x02
>   #define NL80211_FLAG_NEED_RTNL		0x04

Regards,
Arend
