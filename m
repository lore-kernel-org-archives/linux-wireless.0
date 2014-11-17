Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbaKQOnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 09:43:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: Advertise support for AP mode channel width changes
References: <1415366205-11672-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1415366205-11672-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 17 Nov 2014 16:43:36 +0200
In-Reply-To: <1415366205-11672-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 7 Nov 2014 18:46:45 +0530")
Message-ID: <8761edq44n.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_154349_487456_2A3EBC2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This will enable AP mode to change channel width dynamically
> based on 20/40 intolerance report sent by associated client.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4916,6 +4916,7 @@ int ath10k_mac_register(struct ath10k *ar)
>  	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
>  
>  	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
> +	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
>  	/*
>  	 * on LL hardware queues are managed entirely by the FW
>  	 * so we only advertise to mac we can do the queues thing

I added newline to here as well:

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4928,6 +4928,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
        ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
        ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
+
        /*
         * on LL hardware queues are managed entirely by the FW
         * so we only advertise to mac we can do the queues thing

-- 
Kalle Valo
