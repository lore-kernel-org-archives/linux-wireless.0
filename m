Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18303 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaBNGNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 01:13:32 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] wmi:  Handle failure to start scan.
References: <1392318594-32540-1-git-send-email-greearb@candelatech.com>
Date: Fri, 14 Feb 2014 08:13:25 +0200
In-Reply-To: <1392318594-32540-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 13 Feb 2014 11:09:54
	-0800")
Message-ID: <877g8y6x2y.fsf@kamboji.qca.qualcomm.com> (sfid-20140214_071339_131826_3BF2C9B6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Properly clean up driver state in case firmware fails
> to start scan for some reason.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Why just RFC?

And "ath10k:" prefix missing.

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -770,7 +770,25 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
>  		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_PREEMPTED\n");
>  		break;
>  	case WMI_SCAN_EVENT_START_FAILED:
> -		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_START_FAILED\n");
> +		ath10k_warn("WMI_SCAN_EVENT_START_FAILED, reason: %i\n", reason);

"scan failed to start: %i\n"

> +		ar->scan_channel = NULL;
> +		if (!ar->scan.in_progress) {
> +			ath10k_warn("scan-start-failed: no scan requested, ignoring\n");

"scan failed to start but no scan requested, ignoring\n"

-- 
Kalle Valo
