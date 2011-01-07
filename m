Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58853 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1AGPUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 10:20:10 -0500
Message-ID: <4D272EFB.2010207@candelatech.com>
Date: Fri, 07 Jan 2011 07:19:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Peter Stuge <peter@stuge.se>
CC: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 2/3] ath9k: Re-start xmit logic in xmit
 watchdog timer.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-2-git-send-email-greearb@candelatech.com> <20110107065101.GB13800@vasanth-laptop> <20110107151148.7315.qmail@stuge.se>
In-Reply-To: <20110107151148.7315.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 07:11 AM, Peter Stuge wrote:
> Vasanthakumar Thiagarajan wrote:
>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>> @@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
>>>   				} else {
>>>   					txq->axq_tx_inprogress = true;
>>>   				}
>>> +			} else {
> ..
>>> +				if (!list_empty(&txq->axq_acq)) {
> ..
>>> +					ath_txq_schedule(sc, txq);
>>
>> NAK. This complete work monitors the hw q periodically and does a
>> reset if a hang is detected.
>
> Could you please point to that hang check?

It's right there in the method.  Basically, first call of this poll_work might
set the txq to axq_tx_inprogress, and if it's still in progress on next call,
it resets the hardware.

Now that you mention it, however...the channel change logic restarts this worker
for immediate execution.  That means that two channel changes very close together
could easily cause this reset to hit when it really shouldn't.  Probably we need
to store the time at which tx-in-progress was set and only reset the NIC if the
timer has expired (not just if it was detected twice in a row)??

Thanks,
Ben

>
>
> //Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
