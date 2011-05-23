Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41743 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab1EWU77 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 16:59:59 -0400
Received: by iwn34 with SMTP id 34so5141013iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 13:59:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDAC8DC.5060803@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
 <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
 <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com>
 <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
 <4DDAC8DC.5060803@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 13:59:39 -0700
Message-ID: <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com> (sfid-20110523_230004_289735_CD6A02E4)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 1:51 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/23/2011 01:25 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, May 23, 2011 at 1:09 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> Makes it basically useless as a 5Ghz AP though, eh?
>>
>> Um yup. The card is a world roaming card... not an AP card. For AP
>> mode of functionality vendors have to go through a regulatory test
>> specific to 3 regions, and depending on which region they get
>> certification for they will have then programmed in the values
>> required for regulatory on the CTLs. The EEPROM would be configured
>> for the region the card was being tested for.
>
> Well, if you have an AP on a 5Ghz channel, and associate a station
> interface, that one channel becomes
> usable, and then you can start hostapd, as far as I can tell.
> You just can't use an un-used channel, which is of course
> a pain if you want to do some 5Ghz AP testing on a clean
> channel!

You don't even need to associate, you just need to scan, that's it. It
is a pain to test AP functionality but that is not how vendors test AP
functionality -- remember you are using a world roaming card, the fact
that you can even get away with beaconing modes of operation on some
channels is actually a feature.

The issue here comes from the fact that people think using AP mode of
functionality is a freedom they are entitled to with any 802.11 card
on any channel. Its obviously more complicated than that and figuring
out a proper way to do this is part of our own effort to enable APs
with Linux properly and in a regulatory compliant manner.

>>> Guess it's time to go find a hack to over-ride eeprom
>>> settings :(
>>
>> Good luck with support from anyone for any further questions ;) [1].
>
> I can certainly disable the module parameter and have it bug for bug
> compatible with upstream code.  I'm not going to
> write to the eeprom or anything funny like that.

I'm just letting you know, I nor a lot of developers approve of
promoting code which goes out of regulatory compliance [1]

[1] http://wireless.kernel.org/en/developers/Regulatory/statement

Understanding the regulatory considerations and actually trying to
find decent solutions is the hard part, but I do believe solutions are
possible, they just take time. The dynamic regulatory selection thing
I think will be the future we need a tight solution covering all
grounds of the calibration and CTL process at least for Atheros cards.

>> The real solution to these issues is for regulatory agencies to start
>> warming up to the idea about dynamic regulatory selection but for this
>> you will also then need to ensure each card gets properly tested for
>> each regulatory region -- or we'd have to restrict the card to work in
>
> What kinds of things could fail in one region and not
> another?

Atheros cards are optimized to output as much power in the middle area
of a spectrum, towards the ends of the spectrum regulatory agencies
sometimes require a bit tighter power constraints and cards are
required to meet certain power curve constraints. This is one of the
reasons for the EEPROM CTLs on the Atheros cards. This is one example
of such considerations.

> Are there any known regions of the world where
> the AR9380 actually fails to function in any mode?

Huh? AR9380 will work in any region so long as its tested for that
region and the CTLs get programmed as such.

  Luis
