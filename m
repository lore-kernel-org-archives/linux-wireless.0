Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:59963 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZKGAJO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 19:09:14 -0500
Received: by iwn10 with SMTP id 10so1221337iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 16:09:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911061126y12c59bc2q4620af8dfd703304@mail.gmail.com>
References: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
	<b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com>
	<43e72e890911060945s3b00e056u1efe483bd88ebd30@mail.gmail.com>
	<20091106183833.GC2782@tuxdriver.com> <43e72e890911061120mc3f66cbl272adc273a39cb0c@mail.gmail.com>
	<43e72e890911061126y12c59bc2q4620af8dfd703304@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 16:08:59 -0800
Message-ID: <43e72e890911061608v22656457h1d8e668ac820e0fa@mail.gmail.com>
Subject: Re: Changing the way we handle region codes on Linux (public thread)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Jeffrey Baker <jwbaker@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 11:26 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Nov 6, 2009 at 11:20 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Nov 6, 2009 at 10:38 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>>>
>>> FWIW, I think Bob's suggestion makes a lot of sense.
>>
>> Patches welcomed then :)
>
> So this could consist probably of adding one more environment variable
> to the passed COUNTRY one that the kernel passes before calling crda,
> a group I guess, andif the group is passed the crda can read
> /path/grop-regulatory.bin where group could be ATHR for example.
>
> BTW -- the region codes are already present on db.txt

What I mean by that is a region code is mapped to an alpha2 and then
the first alpha2 for the region code is used to query CRDA and CRDA
already has these alpha2s.

Just for the record I have reviewed possible changes internally and it
seems that we're happy to allow the alpha2 that a user sets through
userspace and trust it for a device if the region code also maps to
the alpha2 the user set. But we're also happy to move more things to
userspace if that is desired.

I'm more inclined to spend a couple of hours on the checking the
alpah2 set by the user than the other solution so if I get some time
I'll eventually hack that up.

 Luis
