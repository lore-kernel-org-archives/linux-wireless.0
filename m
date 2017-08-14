Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdHNROR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 13:14:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
Date: Mon, 14 Aug 2017 20:14:12 +0300
In-Reply-To: <20170814134911.20869-1-emmanuel.grumbach@intel.com> (Emmanuel
        Grumbach's message of "Mon, 14 Aug 2017 16:49:11 +0300")
Message-ID: <87lgmmt6l7.fsf@purkki.adurom.net> (sfid-20170814_191421_386159_F31F190B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> User space can now allow the kernel to associate to an AP
> that requires MFP or that doesn't have MFP enabled in the
> same NL80211_CMD_CONNECT command.
> The driver / firmware will decide whether to use it or not.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[...]

> @@ -4086,10 +4090,12 @@ enum nl80211_key_type {
>   * enum nl80211_mfp - Management frame protection state
>   * @NL80211_MFP_NO: Management frame protection not used
>   * @NL80211_MFP_REQUIRED: Management frame protection required
> + * @NL80211_MFP_OPTIONAL: Management frame is optional
>   */
>  enum nl80211_mfp {
>  	NL80211_MFP_NO,
>  	NL80211_MFP_REQUIRED,
> +	NL80211_MFP_OPTIONAL,
>  };
>  
>  enum nl80211_wpa_versions {
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 8f035d9868d1..829867132326 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -9115,6 +9115,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>  	if (info->attrs[NL80211_ATTR_USE_MFP]) {
>  		connect.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
>  		if (connect.mfp != NL80211_MFP_REQUIRED &&
> +		    connect.mfp != NL80211_MFP_OPTIONAL &&
>  		    connect.mfp != NL80211_MFP_NO)
>  			return -EINVAL;
>  	} else {

I guess I'm missing something, but how is backwards compatibility
supposed to work from user space point of view? If user space uses
NL80211_MFP_OPTIONAL with an old kernel, the kernel will reject the
command with -EINVAL and user space will try again without
NL80211_MFP_OPTIONAL?

-- 
Kalle Valo
