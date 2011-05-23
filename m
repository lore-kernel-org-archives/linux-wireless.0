Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37629 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179Ab1EWWPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 18:15:52 -0400
Received: by iwn34 with SMTP id 34so5205850iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 15:15:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDAD8B9.8090802@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
 <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
 <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com>
 <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
 <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com>
 <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com>
 <4DDAD3D5.1070001@candelatech.com> <BANLkTinrM1oBfKUoCzs9_DOw+EmpW=ikig@mail.gmail.com>
 <BANLkTimDXqa+67=UFY4KS5zwOBrinH_k8g@mail.gmail.com> <4DDAD8B9.8090802@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 May 2011 15:15:32 -0700
Message-ID: <BANLkTimxFnWezBE7WCBHyQjJcrZ3WuTwuQ@mail.gmail.com> (sfid-20110524_001555_913226_F0FB0C5E)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
To: Ben Greear <greearb@candelatech.com>,
	David Quan <David.Quan@atheros.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 2:59 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/23/2011 02:46 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, May 23, 2011 at 2:42 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>  wrote:
>>
>>> No. You can only do this by trying to take the card out of compliance
>>> purposely or unknowingly in software.
>>
>> Oh and my point was that "regulatory hacks" fit this description.
>
> Ok.  I believe you are right in general, but I can't see how enabling
> a device to work on a non-scanned channel can break something,

If a card is world roaming, how else on earth without seeing a beacon
will you know if you can initiate radiation on that channel?

> if it is perfectly legal and appropriate for there to be an AP on that
> scanned channel.

Agreed! In fact I'd go so far as to say that if you have multiple
802.11 cards they should be able to share the same beacon hints, and
in fact -- this is what cfg80211 does ;)

> In other words, if I change my Netgear to be on channel
> 48, scanned it, and then created a VAP on that channel, that is OK with
> un-hacked regdomain stuff, but if instead I change regdomain to 0x0
> and use channel 48 without re-configuring my Netgear, somehow that
> suddenly causes issues?

For Atheros EEPROM 0x0 is designed for usage for the US:

http://wireless.kernel.org/en/users/Drivers/ath#The_0x0_regulatory_domain

This is not a world regulatory domain. Some users / customers have
believed that programming the regulatory domain to 0x0 lets people
pick their own regulatory domain in software. This is not the intent
behind this regulatory domain, if a vendor is selling 802.11 cards
they simply need to go through regulatory testing for a card and then
program both the EEPROM / CTLs for the cards, if they do something
else let them sort that out through Atheros and their own support team
but as far as end users are concerned and upstream code the 0x0
regulatory domain will always simply map the the US regulatory domain.

> At any rate, all I really wanted to do was tie-break an off the
> shelf AP that appeared to cause ath9k clients to silently be
> unable to ARP after a while.  I have something that appears functional
> now, so back to real work.

:) Cool good luck!

  Luis
