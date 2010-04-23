Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab0DWGBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 02:01:37 -0400
Received: by vws14 with SMTP id 14so440959vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 23:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272002241.3737.1.camel@jlt3.sipsolutions.net>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
	<g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
	<1271954537.8469.15.camel@mj> <x2l43e72e891004221333he942ee92u3ef4c6994d769694@mail.gmail.com>
	<u2j6ed0b2681004221347z78c15832z3e0ff3ea51b4a5a8@mail.gmail.com>
	<1272002241.3737.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 22 Apr 2010 23:01:16 -0700
Message-ID: <u2g43e72e891004222301z766f9332rfcb484c153e6d2fa@mail.gmail.com>
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 22, 2010 at 10:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-04-22 at 23:47 +0300, Grazvydas Ignotas wrote:
>> On Thu, Apr 22, 2010 at 11:33 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Thu, Apr 22, 2010 at 9:42 AM, Pavel Roskin <proski@gnu.org> wrote:
>> >> On Thu, 2010-04-22 at 09:33 -0700, Luis R. Rodriguez wrote:
>> >>
>> >>> How was this compiling for older kernels before then?
>> >>
>> >> Compiling was fine, but loading the firmware was failing sometimes.  I'm
>> >> glad somebody figured it out.  Thank you, Grazvydas!
>> >
>> > OK Applied. I'm still puzzled, if it compiled, then that means
>> > dev_set_uevent_suppress() was being defined somehow for older kernels.
>>
>> there was already ifdef, old code:
>>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>>        dev_set_uevent_suppress(f_dev, 1);
>>  #endif
>>
>> new code:
>>  #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
>>        dev_set_uevent_suppress(f_dev, 1);
>> #else
>>        f_dev->uevent_suppress = 1;
>>  #endif
>
> And the argument is that the new code should be
>
>        dev_set_uevent_suppress(f_dev, 1);
>
> and some header file should provide
>
> static inline void dev_set_uevent_suppress(...)
> {
>        f_dev->uevent_suppress = 1;
> }
>
> which makes perfect sense. Although Luis merged it, a fix would be
> useful.
>
> Luis, a patch changing firmware_class.c just entered the tree :P I made
> it.

Damn you, had to be you :)

  Luis
