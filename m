Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:35282 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbHYAow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 20:44:52 -0400
Received: by ykbi184 with SMTP id i184so140219319ykb.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2015 17:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440462512.2670.83.camel@perches.com>
References: <1440432084-20928-1-git-send-email-jprvita@endlessm.com> <1440462512.2670.83.camel@perches.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Mon, 24 Aug 2015 20:44:12 -0400
Message-ID: <CA+A7VXVSKB7-4=km0EoGfPAtx8UOHFCAwAd8Vbk-=f6u1KVFzA@mail.gmail.com> (sfid-20150825_024456_133279_5BEAE439)
Subject: Re: [PATCH] rfkill: Copy "all" global state to other types
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Joe, thanks for your review.

On 24 August 2015 at 20:28, Joe Perches <joe@perches.com> wrote:
> On Mon, 2015-08-24 at 12:01 -0400, João Paulo Rechi Vita wrote:
>> When switching the state of all RFKill switches of type all we need to
>> replicate the RFKILL_TYPE_ALL global state to all the other types global
>> state, so it is used to initialize persistent RFKill switches on
>> register.
> []
>> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> []
>> @@ -341,7 +341,14 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
>>  {
>>       struct rfkill *rfkill;
>>
>> -     rfkill_global_states[type].cur = blocked;
>> +     if (type == RFKILL_TYPE_ALL) {
>> +             enum rfkill_type i;
>
> Does it really make sense to use an enum here?
>
>> +             for (i = 0; i < NUM_RFKILL_TYPES; i++)
>> +                     rfkill_global_states[i].cur = blocked;
>
> increment it and then use it as an index?
>
> Most every other loop use of NUM_RFKILL_TYPES is int
>

I don't have a preference whether to the iterator here is an integer
or an enum, I've simply followed what is done in rfkill_fop_write(). I
can send an updated version.

--
João Paulo Rechi Vita
http://about.me/jprvita
