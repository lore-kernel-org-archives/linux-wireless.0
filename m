Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932953AbeFTVQV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 17:16:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 20 Jun 2018 14:16:20 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: Don't allow tx logic when state is not ON.
In-Reply-To: <a624d36c-409a-c2d5-d1d9-8cb857eab2fb@candelatech.com>
References: <1529506583-20204-1-git-send-email-greearb@candelatech.com>
 <9ba64928-a73b-0fe6-9586-65929ca87013@codeaurora.org>
 <3dc5dce6-a8ef-93f6-318f-6ca2e62f8853@candelatech.com>
 <a6bbeef21bb377e1480ca99f4d2c1013@codeaurora.org>
 <a624d36c-409a-c2d5-d1d9-8cb857eab2fb@candelatech.com>
Message-ID: <14a066cc39a22b204c206440faab9b26@codeaurora.org> (sfid-20180620_231624_685683_75927D3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-20 11:51, Ben Greear wrote:
> On 06/20/2018 11:48 AM, Rajkumar Manoharan wrote:
>> On 2018-06-20 10:42, Ben Greear wrote:
>>> On 06/20/2018 10:37 AM, Manikanta Pubbisetty wrote:
>>>> 
>> [...]
>>>> This case should not be dealt in ath10k, rather we should make sure 
>>>> packets does not reach the driver during hardware restart after the 
>>>> firmware crash.
>>>> Can you please try the RFC patch and see if it fixes the issue? I am 
>>>> working on the patch and probably send it out after doing some 
>>>> testing and cleanup.
>>>> 
>>>> https://patchwork.kernel.org/patch/10411967/
>>> 
>>> I did see your patch, but I was not sure it would make it upstream.
>>> 
>>> I think either way my patch might be useful in case bugs creep back 
>>> in.
>>> 
>> 
>> ar->state check can not be in hot path as it is protected by mutex 
>> lock.
> 
> If the tx logic is ever called while state is changing, that would seem
> to be a bug as well?
> 
Thats true. The assumption is that packets should not be given to driver
after ieee80211_stop_queues is called. Isn't it? Manikanta is trying to 
fix
some cases where packets are still continued to sent even after queue 
stop.
Worth trying that.

-Rajkumar
