Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36869 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZHMOlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 10:41:16 -0400
Received: by ewy10 with SMTP id 10so825860ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 07:41:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908122007r766506e7i52aab859b01283d1@mail.gmail.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com>
	 <43e72e890908121027x5211c7cja3185861bc9c02f1@mail.gmail.com>
	 <40f31dec0908121913y1dc39032p26556135f22c3f48@mail.gmail.com>
	 <43e72e890908122007r766506e7i52aab859b01283d1@mail.gmail.com>
Date: Thu, 13 Aug 2009 17:41:16 +0300
Message-ID: <40f31dec0908130741i777458fm250c02659e05d54e@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 0/3] ath: advance ath.ko with one more
	helper
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/13 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Wed, Aug 12, 2009 at 7:13 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:
>> 2009/8/12 Luis R. Rodriguez <lrodriguez@atheros.com>:
>>> On Wed, Aug 12, 2009 at 10:21 AM, Bob Copeland<me@bobcopeland.com> wrote:
>>>> On Wed, Aug 12, 2009 at 12:56 PM, Luis R.
>>>> Rodriguez<lrodriguez@atheros.com> wrote:
>>>>> This adds a common structure where we can start stuffing shared items
>>>>> and introduces a helper for both ath5k and ath9k's use.
>>>>>
>>>>> Luis R. Rodriguez (3):
>>>>>  ath: add common ath_rxbuf_alloc() and make ath9k use it
>>>>>  ath5k: use common ath.ko ath_rxbuf_alloc()
>>>>>  ath5k: use bit shift operators for cache line size
>>>>
>>>> Series looks OK to me but I think we can add a 4/4 that would:
>>>>
>>>> - include ath/reg.h [don't remember if that's the name right now]
>>>>  in ath.h
>>>> - move reg structs into ath_common (although, this could be a
>>>>  bad call for ar9170, haven't really checked).
>>>>
>>>> Then we only have to deal with one header and one composite struct
>>>> (for now) as the interface between the modules.
>>>
>>> Sure, I was thinking of doing this after this. Is that acceptable?
>>>
>>>  Luis
>>
>> You mean have a common reg.h for both ath5k and ath9k ? Works for me
>> but we have to deal with some new register ranges and some registers
>> have moved on ath9k + reg.h on ath9k has no descriptions, comments, it doesn't
>> include macros for accessing queue registers or tables, mixes eeprom offsets
>> with register addresses and other macros.
>
> Sorry no I meant ath/reg.h as in regulatory, as that is already party of ath.ko.
>
>> My plan was to start merging ath9k hw code on ath5k (not the driver part,
>> pcu.c, qcu.c, phy.c, eeprom.c etc + registers/eeprom offsets/descriptor formats)
>> and then move all that on ath and have both ath5k/ath9k use it. I
>> believe ath5k hw
>> code is much cleaner than ath9k and it's a better place to start, i've
>> seen most hw
>> code on ath9k and i'm ready to move on if it's O.K. with you.
>
> When we update ath9k for new hw support it is easiest if that code
> matches what we have internally at Atheros. Granted we diverge from
> that every now and then but I believe those changes can be brought
> back in that we do and yet keep the internal code working. I believe
> the changes so far bring clarity and readability. Unfortunately we
> haven't yet gotten any the changes we've made on ath9k hw access stuff
> or regulatory merged back in so we keep diverging more and more from
> our internal codebase.
>
> Because of this for now I would not welcome bringing ath9k code to
> ath5k in any way whatsoever. What I think is reasonable though is to
> start merging into ath.ko common code which doesn't change much or
> would mean diverging a lot from ath9k's current style for the hw
> related stuff. Don't get me wrong, changes are welcomed but the less
> intrusive the better. "start merging ath9k hw code on ath5k" sounds
> very intrusive by all means.
>
> Lets do this slowly and take it on, on a patch by patch basis.
>
>  Luis
>

ACK ;-)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
