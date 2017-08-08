Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57090 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdHHV6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 17:58:38 -0400
Subject: Re: wireless drivers fail to report link speed?
To: Dan Williams <dcbw@redhat.com>, james@nurealm.net,
        linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com> (sfid-20170808_235842_265559_B8655100)
Date: Tue, 8 Aug 2017 14:58:37 -0700
MIME-Version: 1.0
In-Reply-To: <1502228547.24881.5.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2017 02:42 PM, Dan Williams wrote:
> On Tue, 2017-08-08 at 13:07 -0600, James Feeney wrote:
>> Hello All
>>
>> Would you please look at kernel bug report "Since 4.12 - bonding
>> module not
>> working with wireless drivers", and tell me if you know why the
>> kernel ethtool
>> does not receive a speed report from the wireless drivers?
>>
>>  https://bugzilla.kernel.org/show_bug.cgi?id=196547
>>
>> It seems that Mahesh Bandewar became annoyed that some network
>> drivers do not
>> report speed and duplex to the bonding module properly, so that it
>> becomes
>> impossible to make "best connection" decisions.  A patch was applied
>> to the
>> bonding module in linux 4.12 which now disables any network interface
>> that does
>> not successfully report its speed and duplex.  In practice, this
>> seems to
>> include every wireless network driver I've tried, the ath5k, ath9k,
>> the
>> rtl8192ce and RTL8188CUS.  Of course, this new behavior breaks
>> wireless bonding!
>>
>> Do you know if there is some general reason why the wireless drivers
>> do not work
>> with the kernel ethtool?  Is this something that can be fixed?  Can
>> you tell if
>> this reporting failure would be the fault of the kernel ethtool?  Or
>> the
>> wireless driver?  Or the bonding module?
>
> Because the "speed" (whatever that means) can and sometimes does change
> with every packet.  The driver dynamically adjusts the link rate based
> on all kinds of things.  But mainly the current radio environment; how
> many other APs are around, how much interference there is, how many
> other clients are trying to talk, that kind of thing.
>
> So one second the wifi might be the "best" link and then when somebody
> turns on a microwave oven or a baby monitor, it may be the "worst"
> until the microwave's duty cycle completes a few seconds later then
> it'll become the "best" again for a couple seconds then "worst" again,
> repeat until your Easy Mac is nice and warm and creamy.
>
> Furthermore, for some drivers IIRC when there isn't any traffic, they
> might drop the link rate very low because there's no reason keep
> powering blocks when you're not transmitting/receiving any data.  IIRC
> the Intel drivers used to do that a couple years ago.
>
> Also, "duplex" doesn't mean anything in wireless land.  So no clue what
> bonding is expecting them to say here.  I would say the modifications
> to the bonding core made assumptions that simply aren't applicable to
> mediums other than wired ones.

Well, wifi acts half-duplex in that only one side can transmit
at once.

But, no argument with the rest!

Thanks,
Ben

>
> Dan
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
