Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47630 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbeHMVPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 17:15:01 -0400
Subject: Re: [PATCH] mac80211: Run TXQ teardown code before de-registering
 interfaces
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
References: <20180813121625.18367-1-toke@toke.dk>
 <5B71CD33.7020700@broadcom.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <1a188d2e-800e-cd72-9977-f70256a1c5e9@candelatech.com> (sfid-20180813_203259_205787_B791984A)
Date: Mon, 13 Aug 2018 11:31:34 -0700
MIME-Version: 1.0
In-Reply-To: <5B71CD33.7020700@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2018 11:25 AM, Arend van Spriel wrote:
> On 8/13/2018 2:16 PM, Toke Høiland-Jørgensen wrote:
>> The TXQ teardown code can reference the vif data structures that are
>> stored in the netdev private memory area if there are still packets on
>> the queue when it is being freed. Since the TXQ teardown code is run
>> after the netdevs are freed, this can lead to a use-after-free. Fix this
>> by moving the TXQ teardown code to earlier in ieee80211_unregister_hw().
>
> Just off the bat, but from reading the above I am wondering whether the use-after-free could also happen upon removing an interface?

At least in practice, it does not seem to happen.  Some of our test cases bring up and down
netdevs very often, and those doe not seem to trigger this bug.

But, could be luck, of course.

Crashing ath10k firmware under tx load, and unloading modules under tx load
seems to be the main trigger.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
