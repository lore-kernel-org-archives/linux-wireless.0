Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45452 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933053AbeFTRmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 13:42:45 -0400
Subject: Re: [PATCH] ath10k: Don't allow tx logic when state is not ON.
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
References: <1529506583-20204-1-git-send-email-greearb@candelatech.com>
 <9ba64928-a73b-0fe6-9586-65929ca87013@codeaurora.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3dc5dce6-a8ef-93f6-318f-6ca2e62f8853@candelatech.com> (sfid-20180620_194338_040140_7D29CE83)
Date: Wed, 20 Jun 2018 10:42:42 -0700
MIME-Version: 1.0
In-Reply-To: <9ba64928-a73b-0fe6-9586-65929ca87013@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/20/2018 10:37 AM, Manikanta Pubbisetty wrote:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This is against the 4.16 kernel, likely applies to later kernels
>> as well.  Firmware is beta ath10k-ct firmware for 9984 NIC.  The
>> patch is not firmware or chipset specific.
>>
>> When firmware crashes, packets can still be sent from the
>> mac80211 stack, and that can cause crashes in the ath10k
>> tx path.
>
> Yes, this is what I had observed and explained in the RFC patch which I have sent some time back. In my case the device never comes up and the entire system
> crashes; I hope you have observed the same behavior.
>
>> After adding this patch, I saw cases where the tx path was
>> called in state ATH10K_STATE_RESTARTED.
>>
>> I have not tested the tx_64 path, but assume it has similar
>> issues, so same patch was added to it.
>
> This case should not be dealt in ath10k, rather we should make sure packets does not reach the driver during hardware restart after the firmware crash.
> Can you please try the RFC patch and see if it fixes the issue? I am working on the patch and probably send it out after doing some testing and cleanup.
>
> https://patchwork.kernel.org/patch/10411967/

I did see your patch, but I was not sure it would make it upstream.

I think either way my patch might be useful in case bugs creep back in.

And yes, I did see full system crash in this case.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
