Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbeHLUxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 16:53:07 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
Date: Sun, 12 Aug 2018 21:14:12 +0300
In-Reply-To: <20180812145207.11395-1-kristian.evensen@gmail.com> (Kristian
        Evensen's message of "Sun, 12 Aug 2018 16:52:07 +0200")
Message-ID: <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> (sfid-20180812_201431_835786_F0E440EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kristian Evensen <kristian.evensen@gmail.com> writes:

> Enable the use of CQM with mt76-devices.
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
> index 029d54bc..3eb328ff 100644
> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
> @@ -305,6 +305,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
>  
>  	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
>  
> +	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);

So have you tested this and with what devices? For example, does it work
with recently added USB devices?

-- 
Kalle Valo
