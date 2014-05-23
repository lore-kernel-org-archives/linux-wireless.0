Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44672 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaEWJKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:10:11 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so505855wiv.9
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 02:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400835067.4358.5.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-2-git-send-email-michal.kazior@tieto.com>
	<1400769938.4174.29.camel@jlt4.sipsolutions.net>
	<CA+BoTQmVHFCMcx02RN2+J7zcGZbWyypDcNQgGiBSXxyuc_iDYQ@mail.gmail.com>
	<1400835067.4358.5.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 11:10:10 +0200
Message-ID: <CA+BoTQmBSjFQXUeCFu9_8-99xXfJaCRGAFmNDxf6GqVfh3Kqaw@mail.gmail.com> (sfid-20140523_111117_464146_55173003)
Subject: Re: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 10:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-05-23 at 08:09 +0200, Michal Kazior wrote:
>
>> >> +#define IEEE80211_MAX_NUM_SWITCH_VIFS 8
>> >
>> > :-)
>> >
>> > That seems artificial though - why not dynamically allocate?
>>
>> I tend to avoid dynamic allocations whenever I can. I can make it
>> dynamic if you want.
>
> I'm just thinking that Ben Greear will invariably complain about this
> limit ;-)

I see your point now.. :D


>> I think I've had the same problem when I was trying to make a
>> single-call multi-vif csa tracing. Is using dynamic_array for this
>> really doable? I haven't found any code in the kernel using
>> __dynamic_array for anything but simple scalars and buffers.
>
> You could either use multiple arrays, or I guess you could even pack a
> struct into the array, no?

Packing is not a problem - reading/using is. How do you print an array
of structs in a trace? I think I've played around this a little but
gave up for some reason I don't remember anymore.


Michał
