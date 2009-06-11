Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:30681 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZFKVLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 17:11:10 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1187519ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 14:11:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906112305.33675.mb@bu3sch.de>
References: <4A30CE70.4050605@web.de> <43e72e890906111148w1c242bd1qf97cb668a98f883e@mail.gmail.com>
	<200906112305.33675.mb@bu3sch.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 14:10:52 -0700
Message-ID: <43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com>
Subject: Re: compat-wireless: ridiculous build speed
To: Michael Buesch <mb@bu3sch.de>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 2:05 PM, Michael Buesch<mb@bu3sch.de> wrote:
> On Thursday 11 June 2009 20:48:13 Luis R. Rodriguez wrote:
>> On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka@web.de> wrote:
>> > Hi,
>> >
>> > while watching compat-wireless-2009-06-11 doing baby-steps building all
>> > its modules, I wonder what slows this down so horribly. No other
>> > external module build package I know is that slow (I would say *at
>> > least* one order of magnitude slower than normal). Is this really required?
>> >
>> > [ Hurray, it's finished! ]
>>
>> I think the many depmod -ae are the culprit. This is in place to
>> account for all the crap of madwifi which may be present or older
>> drivers which have been renamed.
>>
>> This could be improved. Patches are welcomed.
>>
>> Ps. Try building with make -j 2, etc.
>
> -j does not help. It will hardly build in parallel then.

It works swell for me. The only thing that does not build in parellel
is the autoconf stuff but after its done with that step everything
builds as expected with -j 2.

> There's something
> that serializes most of it (implicitly).

You certain its just not the first part? I had written some patches to
make the first autoconf step into another step to then allow make -j
foo to work without a warning but that would involve another step. The
-j option does work for me though.

  Luis
