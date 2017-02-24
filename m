Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46964 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdBXPT4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 10:19:56 -0500
Subject: Re: [PATCH 162/306] mac80211-hwsim: add length checks before
 allocating skb.
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
 <1487896109-23851-7-git-send-email-greearb@candelatech.com>
 <CAOq732+L3KDLP-5E4XnKE0-+TKV6KG_V5AVqeBjQRdyQ5Nr74g@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <35e7b2e5-595e-9d8e-2b29-6a251b9ae0e3@candelatech.com> (sfid-20170224_161959_886175_F5706EB1)
Date: Fri, 24 Feb 2017 07:19:54 -0800
MIME-Version: 1.0
In-Reply-To: <CAOq732+L3KDLP-5E4XnKE0-+TKV6KG_V5AVqeBjQRdyQ5Nr74g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2017 12:45 AM, Andrew Zaborowski wrote:
> On 24 February 2017 at 01:28,  <greearb@candelatech.com> wrote:
>> Modify the receive-from-user-space logic to do length
>> and 'is-down' checks before trying to allocate an skb.
>>
>> And, if we are going to ignore the pkt due to radio idle,
>> then do not return an error code to user-space.  User-space
>> cannot reliably know exactly when a radio is idle or not.
>
> You probably want to return some error code anyway because 0, if you
> compare to the kernel medium, currently maps to the ack returned bit
> and is possibly the only way for userspace to set the
> HWSIM_TX_STAT_ACK flag in a meaningful way.

Maybe there is a way to return a specific error code so that
the user-space doesn't get concerned when radio is idle.  I
didn't want to spam logs in user-space app...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
