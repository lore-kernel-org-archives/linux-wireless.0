Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932100AbdJJIUi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:20:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] rtlwifi: silence underflow warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170929075234.dgyuiwbowu3jq6r4@mwanda>
References: <20170929075234.dgyuiwbowu3jq6r4@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20171010082038.41B46609A1@smtp.codeaurora.org> (sfid-20171010_102046_347077_70544F8F)
Date: Tue, 10 Oct 2017 08:20:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> My static checker complains that we have an upper bound but no lower
> bound.  I suspect neither are really required but it doesn't hurt to add
> a check for negatives.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index c53cbf3d52bd..294a6b43d1bc 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -453,7 +453,8 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
>  	for (i = 0; i < wow->n_patterns; i++) {
>  		memset(&rtl_pattern, 0, sizeof(struct rtl_wow_pattern));
>  		memset(mask, 0, MAX_WOL_BIT_MASK_SIZE);
> -		if (patterns[i].pattern_len > MAX_WOL_PATTERN_SIZE) {
> +		if (patterns[i].pattern_len < 0 ||
> +		    patterns[i].pattern_len > MAX_WOL_PATTERN_SIZE) {
>  			RT_TRACE(rtlpriv, COMP_POWER, DBG_WARNING,
>  				 "Pattern[%d] is too long\n", i);
>  			continue;

Patch applied to wireless-drivers-next.git, thanks.

64e79426c204 rtlwifi: silence underflow warning

-- 
https://patchwork.kernel.org/patch/9977201/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
