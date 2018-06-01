Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.131.200.82] ([12.131.200.82]:46913 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1750844AbeFABLt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 21:11:49 -0400
Subject: Re: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <0303f713-9e0d-5180-035f-ea78ffe56d67@quantenna.com> (sfid-20180601_031154_228825_C0735221)
Date: Thu, 31 May 2018 18:04:38 -0700
MIME-Version: 1.0
In-Reply-To: <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2018 02:10 AM, Sergey Matyukevich wrote:
> From: Sergei Maksimenko <smaksimenko@quantenna.com>
> 
> Implement set_power_mgmt() callback that forwards power saving
> settings to the device firmware.
> 
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> ---
>   static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
> @@ -922,6 +939,9 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
>   	if (bus->hw_info.hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
>   		qtn_cfg80211_ops.start_radar_detection = NULL;
>   
> +	if (!(bus->hw_info.hw_capab & QLINK_HW_CAPAB_PWR_MGMT))
> +		qtn_cfg80211_ops.set_power_mgmt	= NULL;
> +

I think it's better be moved somewhere out of qtnf_wiphy_allocate() as 
OPS are global for all MACs, while qtnf_wiphy_allocate() is called for 
each MAC separately.
