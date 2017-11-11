Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:37963 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbdKKPfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 10:35:09 -0500
Date: Sat, 11 Nov 2017 23:35:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [run_timer_softirq] BUG: unable to handle kernel paging request
 at 0000000000010007
Message-ID: <20171111153507.pwzgyrejlq6aeizi@wfg-t540p.sh.intel.com> (sfid-20171111_163523_743285_C015B75D)
References: <CA+55aFxSJGeN=2X-uX-on1Uq2Nb8+v1aiMDz5H1+tKW_N5Q+6g@mail.gmail.com>
 <20171029225155.qcum5i75awrt5tzm@wfg-t540p.sh.intel.com>
 <20171029234820.nzwavupqlv2iqo3m@wfg-t540p.sh.intel.com>
 <CA+55aFxA=+iO1cysMnLZz1iNd4W+gEf4Ys9FGoWM+zmuST2KOQ@mail.gmail.com>
 <20171109051905.pdlsyrbzrwlsjbrs@wfg-t540p.sh.intel.com>
 <CA+55aFxz=_g38OsVXhLBMGXnQyZ3CvFk971e19z9eu+9Pu=4dA@mail.gmail.com>
 <alpine.DEB.2.20.1711102228030.2288@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <alpine.DEB.2.20.1711102228030.2288@nanos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 10, 2017 at 10:29:59PM +0100, Thomas Gleixner wrote:
>On Fri, 10 Nov 2017, Linus Torvalds wrote:
>
>> On Wed, Nov 8, 2017 at 9:19 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> >
>> > Yes it's accessing the list. Here is the faddr2line output.
>>
>> Ok, so it's a corrupted timer list. Which is not a big surprise.
>>
>> It's
>>
>>                 next->pprev = pprev;
>>
>> in __hlist_del(), and the trapping instruction decodes as
>>
>>         mov    %rdx,0x8(%rax)
>>
>> with %rax having the value dead000000000200,
>>
>> Which is just LIST_POISON2.
>>
>> So we've deleted that entry twice - LIST_POISON2 is what hlist_del()
>> sets pprev to after already deleting it once.
>>
>> Although in this case it might not be hlist_del(), because
>> detach_timer() also sets entry->next to LIST_POISON2.
>>
>> Which is pretty bogus, we are supposed to use LIST_POISON1 for the
>> "next" pointer. Oh well. Nobody cares, except for the list entry
>> debugging code, which isn't run on the hlist cases.
>>
>> Adding Thomas Gleixner to the cc. It should not be possible to delete
>> the same timer twice.
>
>Right, it shouldn't.
>
>Fengguang, can you please enable:
>
>CONFIG_DEBUG_OBJECTS
>CONFIG_DEBUG_OBJECTS_TIMERS
>
>and try to reproduce? Debugobject should catch that hopefully.

Sure. However I've not got any results until now -- it's rather hard
to reproduce. I'll check possible results tomorrow.

Regards,
Fengguang
