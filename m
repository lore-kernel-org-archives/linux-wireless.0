Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap1.codethink.co.uk ([176.9.8.82]:43591 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754507AbeASAjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 19:39:02 -0500
Message-ID: <1516322336.3417.3.camel@codethink.co.uk> (sfid-20180119_013906_506674_FF76EDEC)
Subject: Re: [PATCH net-next] mac80211_hwsim: fix possible memory leak in
 hwsim_new_radio_nl()
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Fri, 19 Jan 2018 00:38:56 +0000
In-Reply-To: <1516242214-51095-1-git-send-email-weiyongjun1@huawei.com>
References: <1516242214-51095-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-18 at 02:23 +0000, Wei Yongjun wrote:
> 'hwname' is malloced in hwsim_new_radio_nl() and should be freed
> before leaving from the error handling cases, otherwise it will cause
> memory leak.
> 
> Fixes: ff4dd73dd2b4 ("mac80211_hwsim: check HWSIM_ATTR_RADIO_NAME length")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Reviewed-by: Ben Hutchings <ben.hutchings@codethink.co.uk>

Not sure how I missed this case.

Ben.

> ---
>  drivers/net/wireless/mac80211_hwsim.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index e542555..34052c1 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3155,8 +3155,10 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  	if (info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]) {
>  		u32 idx = nla_get_u32(info->attrs[HWSIM_ATTR_REG_CUSTOM_REG]);
>  
> -		if (idx >= ARRAY_SIZE(hwsim_world_regdom_custom))
> +		if (idx >= ARRAY_SIZE(hwsim_world_regdom_custom)) {
> +			kfree(hwname);
>  			return -EINVAL;
> +		}
>  		param.regd = hwsim_world_regdom_custom[idx];
>  	}
> 
> 
-- 
Ben Hutchings
Software Developer, Codethink Ltd.
