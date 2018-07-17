Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57224 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731669AbeGQPgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 11:36:03 -0400
Subject: Re: IBSS timeouts
To: Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
 <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ebc28805-53ae-071b-8c95-6f8caea40676@candelatech.com> (sfid-20180717_170302_566489_B525F8C4)
Date: Tue, 17 Jul 2018 08:02:51 -0700
MIME-Version: 1.0
In-Reply-To: <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/17/2018 12:57 AM, Nicolas Cavallari wrote:
> On 16/07/2018 21:31, James Prestwood wrote:
>> Hello,
>>
>> I am a developer for IWD and trying to implement IBSS networks. The
>> initial IBSS_JOIN, 4-way, and setting the keys all works and I am able
>> to connect two stations. The problem is that I am hitting a timeout in
>> the kernel once the connection has succeeded and there are no more
>> frames flowing between stations. I dug around in the kernel and saw
>> there is a 60 second inactivity timeout which is precicely what is
>> happening. After setting the keys 60 seconds go by and I recieve a
>> DEL_STATION (log attached).
>>
>> My question is: is this timeout expected after the station has been
>> added and the keys are set? If so how does one reset this timeout so
>> the connection can remain alive even if no data is being sent?
>> heartbeat of some kind?
>
> This is not normal, but it isn't your fault. It's more a problem with your card
> firmware/driver. What card/driver do you have ?
>
> In IBSS mode, all stations are required to send beacons. The protocol is a bit
> complex to arrange that, every 102.4ms, a station is chosen to emit the beacon.

I'm not sure this part is correct.  In practice, it seems to often happen this way,
but last time I read the spec on this it seems like it is supposed to sort of negotiate
and not have all ibss stations beaconning.

Thanks,
Ben

>
> Receiving beacons from a station is enough to reset its timer, so with a
> properly functioning station, this timer does not expire.
>
> Unfortunately, in the wild, nobody test that IBSS beacons are generated, because
> without them, an open IBSS still appear to work...
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
