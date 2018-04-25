Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44022 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbeDYHRB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 03:17:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: fix nested rtnl locking on BG_SCAN_STOPPED
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
Date: Wed, 25 Apr 2018 10:16:56 +0300
In-Reply-To: <1524633572-5588-1-git-send-email-gbhat@marvell.com> (Ganapathi
        Bhat's message of "Wed, 25 Apr 2018 10:49:31 +0530")
Message-ID: <87in8fbvrr.fsf@purkki.adurom.net> (sfid-20180425_091707_433458_4846159B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Whenever sched_scan(BG_SCAN) is in progress and driver downloads
> any command, firmware will send an event BG_SCAN_STOPPED. On
> recieving this, driver calls cfg80211_sched_scan_stopped. This
> function in turn will try to acquire rtnl_lock. But if the
> rtnl_lock was already held(while sending the command above), this
> will result in nested rtnl locking. To fix this driver must call
> rtnl version of the API if rtnl_is_locked().
>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Which one is the author? If Cathy is the author, you should add a From
header to indicate that.

> --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> @@ -848,7 +848,10 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
>  
>  	case EVENT_BG_SCAN_STOPPED:
>  		dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
> -		cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
> +		if (rtnl_is_locked())
> +			cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
> +		else
> +			cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);

IMHO checking if a lock is taking is rather ugly and an indication
there's a problem with the locking. Instead making an ugly workaround
like this I would rather investigate who is holding the rtnl and solve
that.

-- 
Kalle Valo
