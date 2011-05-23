Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45437 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab1EWVTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 17:19:22 -0400
Message-ID: <4DDACF56.9070403@candelatech.com> (sfid-20110523_231925_517176_BD896830)
Date: Mon, 23 May 2011 14:19:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com> <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com> <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com> <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com> <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com>
In-Reply-To: <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 01:59 PM, Luis R. Rodriguez wrote:
> On Mon, May 23, 2011 at 1:51 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 05/23/2011 01:25 PM, Luis R. Rodriguez wrote:
>>>
>>> On Mon, May 23, 2011 at 1:09 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> Makes it basically useless as a 5Ghz AP though, eh?
>>>
>>> Um yup. The card is a world roaming card... not an AP card. For AP
>>> mode of functionality vendors have to go through a regulatory test
>>> specific to 3 regions, and depending on which region they get
>>> certification for they will have then programmed in the values
>>> required for regulatory on the CTLs. The EEPROM would be configured
>>> for the region the card was being tested for.
>>
>> Well, if you have an AP on a 5Ghz channel, and associate a station
>> interface, that one channel becomes
>> usable, and then you can start hostapd, as far as I can tell.
>> You just can't use an un-used channel, which is of course
>> a pain if you want to do some 5Ghz AP testing on a clean
>> channel!
>
> You don't even need to associate, you just need to scan, that's it. It
> is a pain to test AP functionality but that is not how vendors test AP
> functionality -- remember you are using a world roaming card, the fact
> that you can even get away with beaconing modes of operation on some
> channels is actually a feature.
>
> The issue here comes from the fact that people think using AP mode of
> functionality is a freedom they are entitled to with any 802.11 card
> on any channel. Its obviously more complicated than that and figuring
> out a proper way to do this is part of our own effort to enable APs
> with Linux properly and in a regulatory compliant manner.

Do you know of any 3x3 AR9380 NICs that can be used
as 5Ghz APs w/out regdomain hacks?  Sparklan was the only NIC I found, and
I didn't notice any way to order a specific regdomain
on the NIC.

>>> The real solution to these issues is for regulatory agencies to start
>>> warming up to the idea about dynamic regulatory selection but for this
>>> you will also then need to ensure each card gets properly tested for
>>> each regulatory region -- or we'd have to restrict the card to work in
>>
>> What kinds of things could fail in one region and not
>> another?
>
> Atheros cards are optimized to output as much power in the middle area
> of a spectrum, towards the ends of the spectrum regulatory agencies
> sometimes require a bit tighter power constraints and cards are
> required to meet certain power curve constraints. This is one of the
> reasons for the EEPROM CTLs on the Atheros cards. This is one example
> of such considerations.
>
>>   Are there any known regions of the world where
>> the AR9380 actually fails to function in any mode?
>
> Huh? AR9380 will work in any region so long as its tested for that
> region and the CTLs get programmed as such.

Testing doesn't make something work, it just makes sure that it
does work.  Now, programming the CTLs sounds like something important.
Is there any way to tell if a NIC is properly programmed for a particular
region, or is each brand/revision programmed independently?

Since it *is* possible to start an AP on a channel with existing AP,
I assume that the NIC must be able to handle this properly..or is
that ability to start on a scanned channel just a bug?  (Please
don't fix it, if it is :P)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

