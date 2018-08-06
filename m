Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55156 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733074AbeHFSVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 14:21:11 -0400
Subject: Re: ath10k SWBA overrun / tx credit starvation
To: Martin Willi <martin@strongswan.org>
References: <6f044fff274867c90038e673c9291279ae1a1121.camel@strongswan.org>
 <8b65a418-04ba-620d-8139-ac62d6715b24@candelatech.com>
 <1c41320da3c241aed1281576eace6021ccb3adb0.camel@strongswan.org>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <9ce7eaed-d842-45e7-4a2a-ae2bc0f72fe5@candelatech.com> (sfid-20180806_181128_077874_98AB3F47)
Date: Mon, 6 Aug 2018 09:11:22 -0700
MIME-Version: 1.0
In-Reply-To: <1c41320da3c241aed1281576eace6021ccb3adb0.camel@strongswan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2018 05:15 AM, Martin Willi wrote:
> Hi Ben,
>
> Thanks for your help.
>
>> If you use the -ct firmware and the -ct driver, you can configure
>> more than 2 tx-credits.
>
> Unfortunately, this didn't help, either. I hit these issues even sooner
> with any 10.1-based firmware (including CT), which implies that at
> least some of them have been addressed with 10.2/10.2.4.

Out of curiosity, how soon could you hit it with -ct firmware?  We often
see these around once per day in some of our test cases, rarely more often
than that.

>> I am not sure it resolves everything and a buggy firmware would still
>> cause issues no matter.
>
> As a work-around, I'm experimenting with handling timeout conditions in
> ath10k_wmi_cmd_send() caused by missing credits. Given that we can't do
> any TX-flush or warm-restart over WMI under these conditions, I just
> issue a hardware restart (patch below).
>
> Some initial tests show that this in fact recovers the module from its
> bad state with just a small connectivity gap; certainly much better
> than that unpredictable behavior we've seen previously.

Yes, I have been using a similar patch for years with good results.

Thanks,
Ben

>
> I'll do some more testing with this approach before considering to
> upstream it.
>
> Regards
> Martin
>
> ---
>
> From fd9e90d0294450c093d243ee4f1eb1e07b1cd73a Mon Sep 17 00:00:00 2001
> From: Martin Willi <martin@strongswan.org>
> Date: Fri, 3 Aug 2018 14:23:30 +0200
> Subject: [PATCH] ath10k: Schedule hardware restart if WMI command times out
>
> If the TX queue gets stuck for some reason, we run out of tx credits and
> are unable to send any commands over WMI. To recover from this situation,
> issue a hard hardware restart. This implies a connectivity outage of about
> 1.4s in AP mode, but brings back the interface to a usable state.
>
> Signed-off-by: Martin Willi <martin@strongswan.org>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 38a97086708b..d39a983f4a1f 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1852,6 +1852,12 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
>  	if (ret)
>  		dev_kfree_skb_any(skb);
>
> +	if (ret == -EAGAIN) {
> +		ath10k_warn(ar, "wmi command %d timeout, restarting hardware\n",
> +			    cmd_id);
> +		queue_work(ar->workqueue, &ar->restart_work);
> +	}
> +
>  	return ret;
>  }
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
