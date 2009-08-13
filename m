Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63693 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZHMCNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 22:13:50 -0400
Received: by ewy10 with SMTP id 10so458288ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 19:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908121027x5211c7cja3185861bc9c02f1@mail.gmail.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com>
	 <43e72e890908121027x5211c7cja3185861bc9c02f1@mail.gmail.com>
Date: Thu, 13 Aug 2009 05:13:50 +0300
Message-ID: <40f31dec0908121913y1dc39032p26556135f22c3f48@mail.gmail.com>
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

2009/8/12 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Wed, Aug 12, 2009 at 10:21 AM, Bob Copeland<me@bobcopeland.com> wrote:
>> On Wed, Aug 12, 2009 at 12:56 PM, Luis R.
>> Rodriguez<lrodriguez@atheros.com> wrote:
>>> This adds a common structure where we can start stuffing shared items
>>> and introduces a helper for both ath5k and ath9k's use.
>>>
>>> Luis R. Rodriguez (3):
>>>  ath: add common ath_rxbuf_alloc() and make ath9k use it
>>>  ath5k: use common ath.ko ath_rxbuf_alloc()
>>>  ath5k: use bit shift operators for cache line size
>>
>> Series looks OK to me but I think we can add a 4/4 that would:
>>
>> - include ath/reg.h [don't remember if that's the name right now]
>>  in ath.h
>> - move reg structs into ath_common (although, this could be a
>>  bad call for ar9170, haven't really checked).
>>
>> Then we only have to deal with one header and one composite struct
>> (for now) as the interface between the modules.
>
> Sure, I was thinking of doing this after this. Is that acceptable?
>
>  Luis

You mean have a common reg.h for both ath5k and ath9k ? Works for me
but we have to deal with some new register ranges and some registers
have moved on ath9k + reg.h on ath9k has no descriptions, comments, it doesn't
include macros for accessing queue registers or tables, mixes eeprom offsets
with register addresses and other macros.

My plan was to start merging ath9k hw code on ath5k (not the driver part,
pcu.c, qcu.c, phy.c, eeprom.c etc + registers/eeprom offsets/descriptor formats)
and then move all that on ath and have both ath5k/ath9k use it. I
believe ath5k hw
code is much cleaner than ath9k and it's a better place to start, i've
seen most hw
code on ath9k and i'm ready to move on if it's O.K. with you.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
