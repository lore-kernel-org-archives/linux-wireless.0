Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57056 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0JERns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 13:43:48 -0400
Received: by iwn5 with SMTP id 5so8585558iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 10:43:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CAB627F.8020804@candelatech.com>
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com>
 <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com>
 <4CAB627F.8020804@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Oct 2010 10:43:27 -0700
Message-ID: <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 10:38 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/05/2010 10:36 AM, Luis R. Rodriguez wrote:
>>
>> On Tue, Oct 5, 2010 at 10:24 AM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 10/05/2010 10:16 AM, Luis R. Rodriguez wrote:
>>>>
>>>> On Tue, Oct 5, 2010 at 10:00 AM, Ben Greear<greearb@candelatech.com>
>>>>  wrote:
>>>>>
>>>>> I started seeing this very soon after creating interfaces.
>>>>
>>>> Can you be more specific how one can reproduce?
>>>
>>> Enable SLUB debugging, DEBUG_PAGEALLOC (Debug page memory allocations),
>>> lockdep, pre-empt.
>>
>> OK I just enabled PAGE_ALLOC thingy, it wasn't enabled on my kernel.
>>
>>> Please try creating a bunch of stations on one ath9k phy,
>>
>> How many?
>
> 130 is a nice round number :)

Let me get this straight. You are creating 130 STAs with ath9k using
iw, then running 150 instances of wpa_supplicant to connect to the
same AP?

> I'll try with a smaller number and see if I can hit it.

Please do, you can use the log2n approach, should take you 7 tries,
each by a power of 2, start at the middle of course.

  Luis
