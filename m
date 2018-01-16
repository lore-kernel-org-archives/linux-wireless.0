Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57184 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeAPPmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 10:42:21 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>, Johannes Berg <johannes@sipsolutions.net>
Cc: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 03/10] rtlwifi: Add sta_statistics of mac80211's op, and set filled=0 by default
References: <20180111070932.9929-1-pkshih@realtek.com>
        <20180111070932.9929-4-pkshih@realtek.com>
Date: Tue, 16 Jan 2018 17:42:16 +0200
In-Reply-To: <20180111070932.9929-4-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Thu, 11 Jan 2018 15:09:25 +0800")
Message-ID: <87608124kn.fsf@purkki.adurom.net> (sfid-20180116_164225_544239_6E6D1A17)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> When using iwconfig to check wifi status, wext uses 'static struct' of
> sinfo to get station info so sinfo->filled will be persistent. Since the
> commit 2b9a7e1bac24 ("mac80211: allow drivers to provide most station
> statistics") assumes driver initializes sinfo->filled to declare supported
> fields, without initialization it will report wrong info. This commit
> simply set 'filled' to be zero simply, and left sinfo to be filled by
> mac80211.
>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index a78b828f531a..ec639fa8095e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -992,6 +992,15 @@ static int _rtl_get_hal_qnum(u16 queue)
>  	return qnum;
>  }
>  
> +static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif *vif,
> +				  struct ieee80211_sta *sta,
> +				  struct station_info *sinfo)
> +{
> +	/* nothing filled by driver, so mac80211 will update all info */
> +	sinfo->filled = 0;
> +}
> +
>  /*
>   *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
>   *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
> @@ -1878,6 +1887,7 @@ const struct ieee80211_ops rtl_ops = {
>  	.config = rtl_op_config,
>  	.configure_filter = rtl_op_configure_filter,
>  	.set_key = rtl_op_set_key,
> +	.sta_statistics = rtl_op_sta_statistics,

Adding an empty op like that feels pointless, IMHO (but without checking
mac80211 sources) not having the op should be the same as filled = 0. To
me this smells like a bug in mac80211.

Johannes, what do you think?

-- 
Kalle Valo
