Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbeG3PaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 11:30:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
        <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
Date: Mon, 30 Jul 2018 16:55:01 +0300
In-Reply-To: <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Thu, 31 May 2018 12:10:59 +0300")
Message-ID: <87lg9ssua2.fsf@qca.qualcomm.com> (sfid-20180730_155510_688838_06B95B23)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> From: Sergei Maksimenko <smaksimenko@quantenna.com>
>
> Implement set_power_mgmt() callback that forwards power saving
> settings to the device firmware.
>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>

[...]

> @@ -922,6 +939,9 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
>  	if (bus->hw_info.hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
>  		qtn_cfg80211_ops.start_radar_detection = NULL;
>  
> +	if (!(bus->hw_info.hw_capab & QLINK_HW_CAPAB_PWR_MGMT))
> +		qtn_cfg80211_ops.set_power_mgmt	= NULL;

Igor already commented about this but AFAICS this breaks if there are
more than one device on the host. Upstream drivers should not have any
limit for the number of devices they support.

-- 
Kalle Valo
