Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0059.outbound.protection.outlook.com ([104.47.37.59]:9498
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750859AbdHNSpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 14:45:05 -0400
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        sergey.matyukevich.os@quantenna.com
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <efee59e0-dd5b-41a0-64c7-66edb2c439dc@quantenna.com> (sfid-20170814_204508_898762_730E9F52)
Date: Mon, 14 Aug 2017 11:44:55 -0700
MIME-Version: 1.0
In-Reply-To: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2017 06:49 AM, Emmanuel Grumbach wrote:
> 
> User space can now allow the kernel to associate to an AP
> that requires MFP or that doesn't have MFP enabled in the
> same NL80211_CMD_CONNECT command.
> The driver / firmware will decide whether to use it or not.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---

No issues from quantenna driver.

Acked-by Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

[...]

> @@ -4086,10 +4090,12 @@ enum nl80211_key_type {
>    * enum nl80211_mfp - Management frame protection state
>    * @NL80211_MFP_NO: Management frame protection not used
>    * @NL80211_MFP_REQUIRED: Management frame protection required
> + * @NL80211_MFP_OPTIONAL: Management frame is optional

Probably meant to be "Management frame _protection_ is optional"

>    */
>   enum nl80211_mfp {
>          NL80211_MFP_NO,
>          NL80211_MFP_REQUIRED,
> +       NL80211_MFP_OPTIONAL,
>   };
> 
>   enum nl80211_wpa_versions {
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 8f035d9868d1..829867132326 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -9115,6 +9115,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>          if (info->attrs[NL80211_ATTR_USE_MFP]) {
>                  connect.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
>                  if (connect.mfp != NL80211_MFP_REQUIRED &&
> +                   connect.mfp != NL80211_MFP_OPTIONAL &&
>                      connect.mfp != NL80211_MFP_NO)
>                          return -EINVAL;
>          } else {
> --
> 2.9.3
> 
