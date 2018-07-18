Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:41308 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbeGRI1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 04:27:47 -0400
To: Ben Greear <greearb@candelatech.com>,
        James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
 <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
 <ebc28805-53ae-071b-8c95-6f8caea40676@candelatech.com>
 <2e189a50-e8f0-0628-4819-27b07b04dd45@green-communications.fr>
 <4038c2b7-314e-d87b-ebb6-48a03c1edcb3@candelatech.com>
From: Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>
Subject: Re: IBSS timeouts
Message-ID: <62d013ad-72dc-70bf-46cd-a426146a47c6@green-communications.fr> (sfid-20180718_095114_124056_71BFBCB5)
Date: Wed, 18 Jul 2018 09:50:57 +0200
MIME-Version: 1.0
In-Reply-To: <4038c2b7-314e-d87b-ebb6-48a03c1edcb3@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/07/2018 01:53, Ben Greear wrote:
> On 07/17/2018 10:44 AM, Nicolas Cavallari wrote:
>> On 17/07/2018 17:02, Ben Greear wrote:
>>> On 07/17/2018 12:57 AM, Nicolas Cavallari wrote:
>>>> In IBSS mode, all stations are required to send beacons. The protocol
>>>> is a bit
>>>> complex to arrange that, every 102.4ms, a station is chosen to emit
>>>> the beacon.
>>>
>>> I'm not sure this part is correct.  In practice, it seems to often
>>> happen this way,
>>> but last time I read the spec on this it seems like it is supposed to
>>> sort of negotiate
>>> and not have all ibss stations beaconning.
>>
>> Well, in 802.11-2016, section 11.1.3.5 is clear: "All members of the
>> IBSS participate in beacon generation."
>>
>> On each TBTT, each station must wait for a random delay before
>> transmitting, and the first one to transmit wins.
>>
>> In theory...
>>
> 
> See 11.1.3.5, section d and e.  I think this means that if it receives a beacon while
> waiting to transmit one, then it cancels its intent to transmit the beacon.  So
> while they 'participate', they may not actually generate beacons?
> 
> I could be wrong about my interpretation of this however, and I am not sure how it
> is actually implemented.

The a to g sections are done at each TBTT. If another station sent a beacon,
then by section d) we lost and we don't transmit.  Since the random number in b)
is generated at each TBTT and uses a uniform distribution, all station have a
chance to win.

Considering a BI of 102.4ms, a timeout of 60s and a 100% idle network, a station
must lose 585 times to start risking being deleted.  The probability of that
happening for a given station in a IBSS with N station is (1-1/n)**585.  Even
with 50 stations, it's only twice as much as the probability to be struck by
lightning.  And it does not account for losses, which will cause more beacon to
be transmitted.
