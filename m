Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39224 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729759AbeGRA2K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 20:28:10 -0400
Subject: Re: IBSS timeouts
To: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
        James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
 <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
 <ebc28805-53ae-071b-8c95-6f8caea40676@candelatech.com>
 <2e189a50-e8f0-0628-4819-27b07b04dd45@green-communications.fr>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4038c2b7-314e-d87b-ebb6-48a03c1edcb3@candelatech.com> (sfid-20180718_015312_614799_CF314E9F)
Date: Tue, 17 Jul 2018 16:53:07 -0700
MIME-Version: 1.0
In-Reply-To: <2e189a50-e8f0-0628-4819-27b07b04dd45@green-communications.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2018 10:44 AM, Nicolas Cavallari wrote:
> On 17/07/2018 17:02, Ben Greear wrote:
>> On 07/17/2018 12:57 AM, Nicolas Cavallari wrote:
>>> In IBSS mode, all stations are required to send beacons. The protocol
>>> is a bit
>>> complex to arrange that, every 102.4ms, a station is chosen to emit
>>> the beacon.
>>
>> I'm not sure this part is correct.  In practice, it seems to often
>> happen this way,
>> but last time I read the spec on this it seems like it is supposed to
>> sort of negotiate
>> and not have all ibss stations beaconning.
>
> Well, in 802.11-2016, section 11.1.3.5 is clear: "All members of the
> IBSS participate in beacon generation."
>
> On each TBTT, each station must wait for a random delay before
> transmitting, and the first one to transmit wins.
>
> In theory...
>

See 11.1.3.5, section d and e.  I think this means that if it receives a beacon while
waiting to transmit one, then it cancels its intent to transmit the beacon.  So
while they 'participate', they may not actually generate beacons?

I could be wrong about my interpretation of this however, and I am not sure how it
is actually implemented.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
