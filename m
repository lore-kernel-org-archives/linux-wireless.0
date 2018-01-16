Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeAPPpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 10:45:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
References: <20180111070932.9929-1-pkshih@realtek.com>
        <20180111070932.9929-6-pkshih@realtek.com>
Date: Tue, 16 Jan 2018 17:45:27 +0200
In-Reply-To: <20180111070932.9929-6-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Thu, 11 Jan 2018 15:09:27 +0800")
Message-ID: <871sip24fc.fsf@purkki.adurom.net> (sfid-20180116_164534_708207_7B4E88BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> To enable the mac80211 fast-tx feature, the hw/driver needs to support
> dynamic power saving and fragmentation. Since our driver does not
> need to fragment packet into smaller pieces, we just hook an empty
> callback of set_frag_threshold to avoid fragmentation in mac80211.
>
> After this, the mac80211 will not fragment the packets and can transmit
> them faster by cache the header information.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -1001,6 +1001,11 @@ static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
>  	sinfo->filled = 0;
>  }
>  
> +static int rtl_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  /*
>   *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
>   *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
> @@ -1906,6 +1911,7 @@ const struct ieee80211_ops rtl_ops = {
>  	.configure_filter = rtl_op_configure_filter,
>  	.set_key = rtl_op_set_key,
>  	.sta_statistics = rtl_op_sta_statistics,
> +	.set_frag_threshold = rtl_op_set_frag_threshold,

This also looks fishy, I guess there's a good reason why mac80211
requires set_frag_threshold()? To me this is just a workaround for a
mac80211 test.

-- 
Kalle Valo
