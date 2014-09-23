Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25699 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaIWNNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 09:13:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k:  make firmware text debug messages more verbose.
References: <1411419245-25799-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 16:13:28 +0300
In-Reply-To: <1411419245-25799-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 22 Sep 2014 13:54:04
	-0700")
Message-ID: <87zjdqcwef.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_151349_728559_17B5C460)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> There are not many of these messages producted by the
> firmware, but they are generally fairly useful, so print
> them at info level.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index cd60940..6be62ac 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2050,7 +2050,7 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
>  	/* the last byte is always reserved for the null character */
>  	buf[i] = '\0';
>  
> -	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
> +	ath10k_info(ar, "wmi event debug print '%s'\n", buf);

This does not bring any extra value to normal users, it's only useful to
firmware engineers. That's why it needs to stay as a debug message.
Maybe we should add a new debug level just for these events, would that
help?

-- 
Kalle Valo
