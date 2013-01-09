Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45525 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3AIQor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 11:44:47 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1136837pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 08:44:47 -0800 (PST)
Message-ID: <50ED9E7B.8050702@lwfinger.net> (sfid-20130109_174451_955244_814E2EF8)
Date: Wed, 09 Jan 2013 10:44:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix memory leak
References: <1357727868-3892-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1357727868-3892-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2013 04:37 AM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> SKBs that are allocated in the HTC layer do not have callbacks
> registered and hence ended up not being freed, Fix this by freeing
> them properly in the TX completion routine.
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/htc_hst.c | 2 ++
>   1 file changed, 2 insertions(+)

Yes, your fix handles the normal case, and you can add a
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

I still have one remaining question. It is possible for the timeout code in 
htc_config_pipe_credits() to be executed, as shown below:

         time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
         if (!time_left) {
                 dev_err(target->dev, "HTC credit config timeout\n");
                 return -ETIMEDOUT;
         }

When this timeout happens, is the skb leaked?

Larry

