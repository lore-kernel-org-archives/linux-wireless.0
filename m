Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43436 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2CEQ7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 11:59:09 -0500
Message-ID: <4F54F0D8.705@qca.qualcomm.com> (sfid-20120305_175914_449161_1E653FEC)
Date: Mon, 5 Mar 2012 18:59:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 1/1] ath6kl: Check wow state before sending control
 and data pkt
References: <1328779916-7732-1-git-send-email-rmani@qca.qualcomm.com> <4F4B95A7.2060809@qca.qualcomm.com> <4F4C6A78.3070704@qca.qualcomm.com>
In-Reply-To: <4F4C6A78.3070704@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2012 07:47 AM, Raja Mani wrote:
> On Monday 27 February 2012 08:09 PM, Kalle Valo wrote:
>> On 02/09/2012 11:31 AM, rmani@qca.qualcomm.com wrote:
>>
>>> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
>>> @@ -901,8 +901,12 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
>>>
>>>   	case ATH6KL_STATE_WOW:
>>>   		break;
>>> +
>>>   	case ATH6KL_STATE_SCHED_SCAN:
>>>   		break;
>>> +
>>> +	default:
>>> +		break;
>>>   	}
>>
>> Don't add the default case, instead add all states explicitly. That way
>> it's easier to track state changes.
> 
> I don't see any value addition having CASE statement for each state
> here. We are not doing any specific operation other than the state
> ATH6KL_STATE_OFF and ATH6KL_STATE_CUTPOWER.
> 
> IMHO, cases can be added later if we want to do anything specific to the 
> state in future.
> 
> To fix sparse errors, i added default case here.

The idea is to force the person adding a new state to think if something
special needs to handled for the state. If we have a default case it's
easy to miss it as compiler doesn't warn anything.

>>> @@ -359,6 +362,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>>>   		return 0;
>>>   	}
>>>
>>> +	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON)) {
>>> +		set_bit(NETQ_STOPPED,&vif->flags);
>>> +		netif_stop_queue(dev);
>>> +		dev_kfree_skb(skb);
>>> +		return 0;
>>> +	}
>>
>> Don't stop the queue here, dropping the packet is enough.
> 
> As per your comments in V1, i added this change.
> Do you want me to change it again ?
> 
> This is what i received from you.
> 
> "Don't think about dropping packets, instead try to make sure that the
> packet flow is _stopped_. Dropping packets should be the last resort,
> instead we need to go to the source of the packets. For data packets
> this means that we need to stop netdev queues. For control packets we
> need to make sure that cfg80211 ops in cfg80211.c don't issue any new
> wmi commands. And maybe we should also consider debugfs and wmi events
> as they can also issue new wmi commands."

Sorry for writing in a confusing way, but I didn't mean this. I meant
stopping the queue from suspend path, not in the data path. The
WARN_ON_ONCE() should not happen so dropping packets should be safe.
It's better to stop and stop the queue from one place (ie suspend/resume
handlers) than doing it also here. It doesn't gain anything.

Kalle
