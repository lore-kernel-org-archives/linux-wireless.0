Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:34861 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbeGQSjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 14:39:22 -0400
Subject: Re: IBSS timeouts
To: James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <11bae1aa8b935a170b97650ae61ce236243c1c90.camel@linux.intel.com>
 <9efa23eb-96e8-12e0-990e-5ee0da62742f@green-communications.fr>
 <1531844370.3250.12.camel@linux.intel.com>
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Message-ID: <705e163a-5a1a-ea63-473b-90e6bc5c0152@green-communications.fr> (sfid-20180717_200537_927560_7BAE67C7)
Date: Tue, 17 Jul 2018 20:05:24 +0200
MIME-Version: 1.0
In-Reply-To: <1531844370.3250.12.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/2018 18:19, James Prestwood wrote:
> On Tue, 2018-07-17 at 09:57 +0200, Nicolas Cavallari wrote:
>> This is not normal, but it isn't your fault. It's more a problem with
>> your card
>> firmware/driver. What card/driver do you have ?
> 
> One side has an Intel 7260 and the other has an Atheros 9462. It seems
> to only be the 7260 that is getting the DEL_STATION events after the
> timeout. I haven't seen the Ath 9k behave like this.

It's not clear who is seeing the DEL_STATION for which station.
Your trace hints at 6C:71:D9:0D:6E:4B not sending beacons.  A wireless
capture should confirm this.

>> In IBSS mode, all stations are required to send beacons. The protocol
>> is a bit
>> complex to arrange that, every 102.4ms, a station is chosen to emit
>> the beacon.
>>
>> Receiving beacons from a station is enough to reset its timer, so
>> with a
>> properly functioning station, this timer does not expire.
>>
>> Unfortunately, in the wild, nobody test that IBSS beacons are
>> generated, because
>> without them, an open IBSS still appear to work...
> Hmm, so how does one mitigate this? Manually sending beacons? That
> would get messy if some cards do it automatically and some don't.

Sending null frames could do the trick, i'm not sure userspace is
allowed to send them with cmd_frame in IBSS mode through.

That, or asking the manufacturer to fix their driver :)

> Something else I forgot to mention/ask in my original email was about
> deauthentication. If one station does a LEAVE_IBSS, the other side
> doesn't recieve a DEL_STATION until that 60 second inactivity timeout.
> If we explicitly leave should the kernel send a deauth automatically? I
> know wpa_supplicant explicitly sends a deauth, but I wasn't sure if
> this was working around a bug or if it was the intended to be that way.

wpa_supplicant sends a deauth when leaving an ibss ? I haven't seen any
code doing that. I don't know why it does that.
