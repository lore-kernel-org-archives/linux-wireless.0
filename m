Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15021 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2B1Fro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 00:47:44 -0500
Message-ID: <4F4C6A78.3070704@qca.qualcomm.com> (sfid-20120228_064748_114319_82A1B51A)
Date: Tue, 28 Feb 2012 11:17:36 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 1/1] ath6kl: Check wow state before sending control
 and data pkt
References: <1328779916-7732-1-git-send-email-rmani@qca.qualcomm.com> <4F4B95A7.2060809@qca.qualcomm.com>
In-Reply-To: <4F4B95A7.2060809@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 27 February 2012 08:09 PM, Kalle Valo wrote:
> On 02/09/2012 11:31 AM, rmani@qca.qualcomm.com wrote:
>> From: Raja Mani<rmani@qca.qualcomm.com>
>>
>> Below two scenarios are taken care in this patch which helped
>> to fix the firmware crash during wow suspend/resume.
>>
>> * TX operation (ctrl tx and data tx) has to be controlled based
>>    on suspend state. i.e, with respect to WOW mode, control packets
>>    are allowed to send from the host until the suspend state goes
>>    ATH6KL_STATE_WOW and the data packets are allowed until WOW
>>    suspend operation starts.
>>
>> * Similarly, wow resume is NOT allowed if WOW suspend is in progress.
>>
>> Signed-off-by: Raja Mani<rmani@qca.qualcomm.com>
>> ---
>> V2 changes:
>>
>> * Separate wow sub state introduced in V1 is removed and common
>>    states (ATH6KL_STATE_SUSPENDING and ATH6KL_STATE_RESUMING)
>>    are added in enum ath6kl_state.
>>
>> * netdev queue is stopped while dropping skb in ath6kl_data_tx()
>>    and resumed back in ath6kl_wow_resume().
>
> [...]
>
>> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
>> index 4febee7..402087e 100644
>> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
>> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
>> @@ -901,8 +901,12 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
>>
>>   	case ATH6KL_STATE_WOW:
>>   		break;
>> +
>>   	case ATH6KL_STATE_SCHED_SCAN:
>>   		break;
>> +
>> +	default:
>> +		break;
>>   	}
>
> Don't add the default case, instead add all states explicitly. That way
> it's easier to track state changes.

I don't see any value addition having CASE statement for each state
here. We are not doing any specific operation other than the state
ATH6KL_STATE_OFF and ATH6KL_STATE_CUTPOWER.

IMHO, cases can be added later if we want to do anything specific to the 
state in future.

To fix sparse errors, i added default case here.
>
>> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
>> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
>> @@ -284,6 +284,9 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
>>   	int status = 0;
>>   	struct ath6kl_cookie *cookie = NULL;
>>
>> +	if (ar->state == ATH6KL_STATE_WOW)
>> +		return -EACCES;
>
> Should this have WARN_ON_ONCE()?

I'll correct this in V3.

>
>> @@ -359,6 +362,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>>   		return 0;
>>   	}
>>
>> +	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON)) {
>> +		set_bit(NETQ_STOPPED,&vif->flags);
>> +		netif_stop_queue(dev);
>> +		dev_kfree_skb(skb);
>> +		return 0;
>> +	}
>
> Don't stop the queue here, dropping the packet is enough.

As per your comments in V1, i added this change.
Do you want me to change it again ?

This is what i received from you.

"Don't think about dropping packets, instead try to make sure that the
packet flow is _stopped_. Dropping packets should be the last resort,
instead we need to go to the source of the packets. For data packets
this means that we need to stop netdev queues. For control packets we
need to make sure that cfg80211 ops in cfg80211.c don't issue any new
wmi commands. And maybe we should also consider debugfs and wmi events
as they can also issue new wmi commands."

>
> Kalle
