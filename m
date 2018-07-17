Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:45169 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbeGQSXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 14:23:35 -0400
Subject: Re: IBSS timeouts
To: Ben Greear <greearb@candelatech.com>,
        James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
 <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
 <ebc28805-53ae-071b-8c95-6f8caea40676@candelatech.com>
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Message-ID: <2e189a50-e8f0-0628-4819-27b07b04dd45@green-communications.fr> (sfid-20180717_194953_697064_4B8AB900)
Date: Tue, 17 Jul 2018 19:44:34 +0200
MIME-Version: 1.0
In-Reply-To: <ebc28805-53ae-071b-8c95-6f8caea40676@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/2018 17:02, Ben Greear wrote:
> On 07/17/2018 12:57 AM, Nicolas Cavallari wrote:
>> In IBSS mode, all stations are required to send beacons. The protocol
>> is a bit
>> complex to arrange that, every 102.4ms, a station is chosen to emit
>> the beacon.
> 
> I'm not sure this part is correct.  In practice, it seems to often
> happen this way,
> but last time I read the spec on this it seems like it is supposed to
> sort of negotiate
> and not have all ibss stations beaconning.

Well, in 802.11-2016, section 11.1.3.5 is clear: "All members of the
IBSS participate in beacon generation."

On each TBTT, each station must wait for a random delay before
transmitting, and the first one to transmit wins.

In theory...
