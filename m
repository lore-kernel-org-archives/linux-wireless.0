Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:50744 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbYEUPUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:20:30 -0400
Date: Wed, 21 May 2008 17:20:29 +0200 (CEST)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Dan Williams <dcbw@redhat.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: mrv8k: now gets scan results
In-Reply-To: <1211379614.25344.7.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0805211711450.3750@bugs.comnets.uni-bremen.de> (sfid-20080521_172035_680438_CB90EA16)
References: <1211312013.10737.10.camel@localhost.localdomain>
 <Pine.LNX.4.64.0805210900160.3750@bugs.comnets.uni-bremen.de>
 <1211379614.25344.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 21 May 2008, Dan Williams wrote:

> On Wed, 2008-05-21 at 09:08 +0200, Markus Becker wrote:
>> Hi Dan,
>>
>> I just tested it and my Option Fusion+ HSDPA card does not scan:
>>
>> May 21 08:52:17 shelbyville kernel: Command timeout
>> May 21 08:52:17 shelbyville kernel: Could not set channel
>> May 21 08:52:17 shelbyville kernel: ~Failed to set channel
>> May 21 08:52:17 shelbyville kernel: wlan1: failed to set freq to 2417 MHz for scan
>
> Interesting; it does take the firmware upload though, right?  What
> firmware version gets reported by the driver when it loads?  I'll have
> to try again with my Netgear PCI card which was a lot more unhappy with
> the driver than my 3Com CardBus one.

The firmware loads fine for me, see below:
May 21 08:50:40 shelbyville kernel: 0000:16:00.0 (mrv8k): successfully uploaded firmware
May 21 08:50:40 shelbyville kernel: 0000:16:00.0 (mrv8k): MAC address 00:0c:e3:xx:xx:xx
May 21 08:50:40 shelbyville kernel: 0000:16:00.0 (mrv8k): HW ver. 3, FW ver. 0x3020007, 2 antennas, regulatory domain EU

>
> I spent some time checking through marvell.git from Linville's repo on
> kernel.org too, and it looks like we may be able to pull a lot of
> constants and commands from that.  The RX and TX descriptors are
> somewhat different, but I've generally found that Marvell's drivers and
> firmware share a lot of API/ABI (would be stupid to break stuff all the
> time anyway, even in closed source).  We may be able to use mrv8k for
> the TopDog 802.11n PCI and USB parts as well since they are so similar
> from a programming perspective.
>
> Dan
>
>> May 21 08:52:19 shelbyville kernel: Command timeout
>> May 21 08:52:19 shelbyville kernel: Could not set channel
>> May 21 08:52:19 shelbyville kernel: ~Failed to set channel
>> May 21 08:52:19 shelbyville kernel: wlan1: failed to set freq to 2422 MHz for scan
>> [...]
>>
>> I also got some lockups, however I have no infrastructure setup to debug
>> those.
>>
>> Thanks for all your efforts,
>> Markus
>>
>> On Tue, 20 May 2008, Dan Williams wrote:
>>
>>> Hi,
>>>
>>> I've gotten mrv8k to the point where I can get scan results with it on
>>> my 3COM 3CRGPC10075 CardBus card.  Data RX still doesn't work for some
>>> reason and WEP associations still fail with a mac80211 timeout.  Enough
>>> for today though.  All changes pushed to mrv8k.git on infradead.
>>>
>>> Dan
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
