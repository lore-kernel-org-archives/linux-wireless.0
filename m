Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:38596 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750863AbeD0G2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 02:28:46 -0400
Subject: Re: [PATCH] mac80211_hwsim: fix a possible memory leak in
 hwsim_new_radio_nl()
To: <johannes@sipsolutions.net>
References: <20180424030835.21776-1-yuehaibing@huawei.com>
CC: <netdev@vger.kernel.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <ben.hutchings@codethink.co.uk>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <b67cacdd-0dd6-0c24-e90e-4a2725862e87@huawei.com> (sfid-20180427_082853_616891_6AB22E24)
Date: Fri, 27 Apr 2018 14:28:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180424030835.21776-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


cc  Ben Hutchings <ben.hutchings@codethink.co.uk>

On 2018/4/24 11:08, YueHaibing wrote:
> 'hwname' should be freed before leaving from the error handling cases,
> otherwise it will cause mem leak
> 
> Fixes: cb1a5bae5684 ("mac80211_hwsim: add permanent mac address option for new radios")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 96d26cf..4a017a0 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -3236,6 +3236,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
>  			GENL_SET_ERR_MSG(info,"MAC is no valid source addr");
>  			NL_SET_BAD_ATTR(info->extack,
>  					info->attrs[HWSIM_ATTR_PERM_ADDR]);
> +			kfree(hwname);
>  			return -EINVAL;
>  		}
>  
> 
