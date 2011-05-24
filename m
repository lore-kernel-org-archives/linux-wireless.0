Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58375 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1EXLde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 07:33:34 -0400
Received: by iwn34 with SMTP id 34so5674093iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 04:33:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DDB38AE.1060600@candelatech.com>
References: <4DD6E9B5.3020905@candelatech.com> <BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>
 <4DDA913B.1060002@candelatech.com> <4DDAA9ED.1050606@candelatech.com>
 <4DDAACF3.3050705@candelatech.com> <BANLkTimizNePq-GFsOYxNtfDNLc8kqjJFw@mail.gmail.com>
 <4DDABEE9.9090608@candelatech.com> <BANLkTineDDcWvmr8M5hp-=b0LDRamZyovQ@mail.gmail.com>
 <4DDAC8DC.5060803@candelatech.com> <BANLkTimSUvfSzAHXQJppZ=7T2TKMuP37fQ@mail.gmail.com>
 <4DDACF56.9070403@candelatech.com> <BANLkTikSb-6Uh5jnEUD4wrGCKUNmrF3Zow@mail.gmail.com>
 <4DDAD3D5.1070001@candelatech.com> <BANLkTinrM1oBfKUoCzs9_DOw+EmpW=ikig@mail.gmail.com>
 <BANLkTimDXqa+67=UFY4KS5zwOBrinH_k8g@mail.gmail.com> <4DDAD8B9.8090802@candelatech.com>
 <BANLkTimxFnWezBE7WCBHyQjJcrZ3WuTwuQ@mail.gmail.com> <4DDB38AE.1060600@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 24 May 2011 04:33:13 -0700
Message-ID: <BANLkTimFti-eC8yr4xKRtMv8=QE8wUsb-A@mail.gmail.com> (sfid-20110524_133337_875011_E1040C61)
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
To: Ben Greear <greearb@candelatech.com>
Cc: David Quan <David.Quan@atheros.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 23, 2011 at 9:48 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/23/2011 03:15 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, May 23, 2011 at 2:59 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 05/23/2011 02:46 PM, Luis R. Rodriguez wrote:
>>>>
>>>> On Mon, May 23, 2011 at 2:42 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>>  wrote:
>>>>
>>>>> No. You can only do this by trying to take the card out of compliance
>>>>> purposely or unknowingly in software.
>>>>
>>>> Oh and my point was that "regulatory hacks" fit this description.
>>>
>>> Ok.  I believe you are right in general, but I can't see how enabling
>>> a device to work on a non-scanned channel can break something,
>>
>> If a card is world roaming, how else on earth without seeing a beacon
>> will you know if you can initiate radiation on that channel?
>
> I have a strong personal sense of location, and I'm 100% sure that
> I'm in the US.  So, the the computer could listen to it's human
> and just trust that I know WTF I am asking for!
>
> It may currently be impossible for vendors to explicitly support
> this due to regulatory domains that assume users are evil and/or
> stupid and not to be trusted to know their current location,
> but please don't pretend that receiving a beacon is rock solid
> evidence of a channel's availability:  It only means that someone
> else that set up the AP thinks it's available for use.

I agree completely but as you noted the issues are not with us, its
with regulatory agencies who have explicitly mentioned user's
intervention in location information and wanting the user out of the
equation [1]. The more tangible solution then is to work on automatic
locationing mechanisms which we can rely on and prove to regulatory
agencies are solid. Slowly that's the path I believe we should take.
One step at a time.

[1] http://wireless.kernel.org/en/developers/Regulatory/CRDA#Helping_compliance_by_allowing_to_change_regulatory_domains

>>> if it is perfectly legal and appropriate for there to be an AP on that
>>> scanned channel.
>>
>> Agreed! In fact I'd go so far as to say that if you have multiple
>> 802.11 cards they should be able to share the same beacon hints, and
>> in fact -- this is what cfg80211 does ;)
>>
>>> In other words, if I change my Netgear to be on channel
>>> 48, scanned it, and then created a VAP on that channel, that is OK with
>>> un-hacked regdomain stuff, but if instead I change regdomain to 0x0
>>> and use channel 48 without re-configuring my Netgear, somehow that
>>> suddenly causes issues?
>>
>> For Atheros EEPROM 0x0 is designed for usage for the US:
>
> Good..that's all I really wanted:  My NIC to support my
> location w/out undue complaint or limitations.

Enjoy :)

  Luis
