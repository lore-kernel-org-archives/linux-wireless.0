Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34042 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbcDHIcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2016 04:32:06 -0400
Received: by mail-ob0-f173.google.com with SMTP id bg3so68705470obb.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2016 01:32:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460099746.30678.3.camel@sipsolutions.net>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
 <1456222441.2041.10.camel@sipsolutions.net> <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
 <1456257946.9910.23.camel@sipsolutions.net> <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
 <1459928436.17504.11.camel@sipsolutions.net> <CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com>
 <1460098614.30678.1.camel@sipsolutions.net> <1460098909.30678.2.camel@sipsolutions.net>
 <1460099746.30678.3.camel@sipsolutions.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Fri, 8 Apr 2016 04:31:45 -0400
Message-ID: <CAHqTa-1SO+asqf7Fn2d+J_w8vvJ1CnnMG8AGB2O1CBjeaaL8hA@mail.gmail.com> (sfid-20160408_103234_753050_837EEF34)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 8, 2016 at 3:15 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-04-08 at 09:01 +0200, Johannes Berg wrote:
>> On Fri, 2016-04-08 at 08:56 +0200, Johannes Berg wrote:
>> > On Thu, 2016-04-07 at 21:32 -0400, Avery Pennarun wrote:
>> > > Yes.  Here it is:
>> > > http://apenwarr.ca/tmp/mac80211-agg-status-crash.ko
>> > >
>> > Unfortunately there are no debug symbols in this file, so it
>> > doesn't
>> > help me much. I can't even seem to get objdump to disassemble it
>> > correctly: looks like the file is in thumb, going from things
>> > like R_ARM_THM_CALL relocations, but even -Mforce-thumb doesn't
>> > seem
>> > to DRT; sta_agg_status_read+0xeb isn't even a valid instruction
>> > offset in regular ARM mode.
>> >
>> It *seems* that it most likely crashes on the first access to tid_tx,
>> which is consistent with the story of disabling TX aggregation
>> timeouts
>> reducing the chances.
>>
>> So I guess we have to look for some TX aggregation teardown RCU
>> pointer problem?
>
> Can't find anything. The only other thing I saw now is that the TID
> appears to be 7 (in r7), might be worth looking for whether that's a
> common thing or not?

Just to be clear, this crash is only from *reading* the agg_status
files.  I don't know if the crashiness reduces when disabling the
aggregation timeouts, since that's a separate bug (in which the queue
gets stuck and the 'pending' column of this file just keeps
increasing).

I'll try twiddling some options again tomorrow and see if I can get
one with proper debug symbols.  For what it's worth, this platform is
"ARMv7 Processor rev 1 (v7l)" and the gcc build is made for Cortex A9.
You can find an x86 build of our toolchain in the git repo at
https://gfiber.googlesource.com/toolchains/mindspeed.

Thanks for looking into it :)

Avery
