Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62776 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbaEJRFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2014 13:05:34 -0400
Received: by mail-oa0-f47.google.com with SMTP id i7so6407679oag.34
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2014 10:05:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140510183645.04c801f2@wiggum>
References: <1399733088-26607-1-git-send-email-zajec5@gmail.com>
	<20140510171721.54b21a63@wiggum>
	<CACna6rwdXiGwLW=vuo2MMaQHYAWjDwc_W2zufmVbkmpBsMMp-Q@mail.gmail.com>
	<20140510183645.04c801f2@wiggum>
Date: Sat, 10 May 2014 19:05:33 +0200
Message-ID: <CACna6rzS8_VCtJhktiX1B+MoM714_j_LRzHK0SzcGNnr1JzBNg@mail.gmail.com> (sfid-20140510_190537_385904_FF0205FF)
Subject: Re: [RFC][PATCH] b43: drop SSB dependency
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 May 2014 18:36, Michael Büsch <m@bues.ch> wrote:
> On Sat, 10 May 2014 18:12:15 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> On 10 May 2014 17:17, Michael Büsch <m@bues.ch> wrote:
>> > On Sat, 10 May 2014 16:44:48 +0200
>> > Rafał Miłecki <zajec5@gmail.com> wrote:
>> >> +config B43_BUSES_BCMA_AND_SSB
>> >> +     bool "BCMA and SSB"
>> >> +     depends on BCMA_POSSIBLE && SSB_POSSIBLE
>> >
>> > I think this needs to be:
>> >
>> >         depends on (BCMA_POSSIBLE && (BCMA = y || BCMA = B43)) && (SSB_POSSIBLE && (SSB = y || SSB = B43))
>> >
>> > to avoid the case where b43 is y and ssb or bcma is m.
>> > Or did I miss something and this is caught elsewhere?
>>
>> Oh, wait, I think I meant B43_BUSES_BCMA_AND_SSB to select BCMA and
>> SSB (so user doesn't have to enable BCMA and SSB on his own). It it
>> the way it's handled without my patch (B43 select-s SSB).
>>
>> I'd like to add
>> select BCMA
>> select SSB
>> , but this won't guarantee BCMA (or SSB) being "y" after choosing B43
>> to "y". Or will it?
>
> I'm currently unsure.
> You probably want to add select SSB to config B43_SSB and the same for B43_BCMA.

I've just tried this, however this will force SSB to be "y" (even if
B43 is "m"). We have to select BCMA/SSB from non-bool configs.
This lead me to the idea of select-ing SSB and BCMA in "B43" depending
on the B43_BCMA and B43_SSB. That should make the trick. I'll test it
and submit V2.
