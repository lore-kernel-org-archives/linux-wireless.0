Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52272 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbbBFQOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 11:14:07 -0500
Message-ID: <54D4E89A.7040602@candelatech.com> (sfid-20150206_171411_201886_C425BEE6)
Date: Fri, 06 Feb 2015 08:15:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, malaakso@elisanet.fi
Subject: Re: [RFT] ath10k: restart fw on tx-credit timeout
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2015 04:05 AM, Michal Kazior wrote:
> It makes little sense to continue and let
> firmware-host state become inconsistent if a WMI
> command can't be submitted to firmware.
>
> This effectively prevents after-affects of
> tx-credit starvation bug which include spurious
> sta kickout events and inability to associate new
> stations after some time when acting as AP.
>
> This should also speed up recovery/teardown in
> some cases when firmware stops responding for some
> reason.

I have not seen a WMI timeout since I added keep-alive
and CE polling in my firmware, but the patch looks OK
to me.

You might add something about 'WMI' in that warning
message to make it more clear what is not being
responsive.  At least in my tests, I could continue
to receive network traffic while WMI was blocked.

Thanks,
Ben

>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>   drivers/net/wireless/ath/ath10k/wmi.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index aeea1c7..776b257 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1045,9 +1045,15 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
>   		(ret != -EAGAIN);
>   	}), 3*HZ);
>
> -	if (ret)
> +	if (ret) {
>   		dev_kfree_skb_any(skb);
>
> +		if (ret == -EAGAIN) {
> +			ath10k_warn(ar, "firmware unresponsive, restarting..\n");
> +			queue_work(ar->workqueue, &ar->restart_work);
> +		}
> +	}
> +
>   	return ret;
>   }
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

