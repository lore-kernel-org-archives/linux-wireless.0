Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f201.google.com ([209.85.210.201]:60603 "EHLO
	mail-yx0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbZFKVoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 17:44:15 -0400
Received: by yxe39 with SMTP id 39so62207yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 14:44:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com>
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de>
	<43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com>
	<200906112314.29464.mb@bu3sch.de> <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 14:43:55 -0700
Message-ID: <43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com>
Subject: Re: compat-wireless: ridiculous build speed
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Jan Kiszka <jan.kiszka@web.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/11 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Thu, Jun 11, 2009 at 11:14 PM, Michael Buesch<mb@bu3sch.de> wrote:
>> On Thursday 11 June 2009 23:10:52 Luis R. Rodriguez wrote:
>>> On Thu, Jun 11, 2009 at 2:05 PM, Michael Buesch<mb@bu3sch.de> wrote:
>>> > On Thursday 11 June 2009 20:48:13 Luis R. Rodriguez wrote:
>>> >> On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka@web.de> wrote:
>>> >> > Hi,
>>> >> >
>>> >> > while watching compat-wireless-2009-06-11 doing baby-steps building all
>>> >> > its modules, I wonder what slows this down so horribly. No other
>>> >> > external module build package I know is that slow (I would say *at
>>> >> > least* one order of magnitude slower than normal). Is this really required?
>>> >> >
>>> >> > [ Hurray, it's finished! ]
>>> >>
>>> >> I think the many depmod -ae are the culprit. This is in place to
>>> >> account for all the crap of madwifi which may be present or older
>>> >> drivers which have been renamed.
>>> >>
>>> >> This could be improved. Patches are welcomed.
>>> >>
>>> >> Ps. Try building with make -j 2, etc.
>>> >
>>> > -j does not help. It will hardly build in parallel then.
>>>
>>> It works swell for me. The only thing that does not build in parellel
>>> is the autoconf stuff but after its done with that step everything
>>> builds as expected with -j 2.
>>>
>>> > There's something
>>> > that serializes most of it (implicitly).
>>>
>>> You certain its just not the first part? I had written some patches to
>>> make the first autoconf step into another step to then allow make -j
>>> foo to work without a warning but that would involve another step. The
>>> -j option does work for me though.
>>
>> Well, I never measured it, but I don't see any advantage when using -jX. Maybe
>> that is because forever equals forever+1.
>>
>> What I do see, though, is that the per-cpu load is much higher when building the
>> kernel itself with the same -j parameter.
>
> Actually, most of the slowness comes from stage 2 of the module build.
> For me, stage 1 runs through rather fast (and -jX accelerates it quite
> well), but stage 2 is serialized, and there is a long wait between
> individual files. This wait is about a second on 2.6.28 for me in
> vmware, but over 5 seconds (!!!) on 2.6.29. I've tried multiple
> distros, and the time difference is consistent. (BTW stage 2 is
> serialized in a full kernel build as well, though there is no reason
> why it should be so; but no "wait" between steps is observed - in
> fact, the second stage of a full 2.6.29 kernel build completes faster
> for me than the second stage of compat-wireless on 2.6.29!)

Heh yeah we need to fix this, patches are welcomed, I'll treat a beer sometime.

  Luis
