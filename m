Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:51798 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751936AbdJ3UhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 16:37:16 -0400
Date: Mon, 30 Oct 2017 21:37:10 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [run_timer_softirq] BUG: unable to handle kernel paging request
 at 0000000000010007
Message-ID: <20171030203710.mk2t7hqgjjabu6wy@wfg-t540p.sh.intel.com> (sfid-20171030_213922_389410_7A9EBE69)
References: <CA+55aFxSJGeN=2X-uX-on1Uq2Nb8+v1aiMDz5H1+tKW_N5Q+6g@mail.gmail.com>
 <20171029225155.qcum5i75awrt5tzm@wfg-t540p.sh.intel.com>
 <20171029234820.nzwavupqlv2iqo3m@wfg-t540p.sh.intel.com>
 <CA+55aFxA=+iO1cysMnLZz1iNd4W+gEf4Ys9FGoWM+zmuST2KOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <CA+55aFxA=+iO1cysMnLZz1iNd4W+gEf4Ys9FGoWM+zmuST2KOQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 30, 2017 at 12:29:47PM -0700, Linus Torvalds wrote:
>On Sun, Oct 29, 2017 at 4:48 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>
>> Here are 3 dmesgs related to wireless and 1 from ethernet.
>
>Fengguang, these would be lovelier still _if_ you have DEBUG_INFO
>enabled on the kernel, and your script were to find things like
>"symbol+0xhex/0xhex", and run "./scripts/faddr2line" on them.
>
>So
>
>> [  235.425464] BUG: unable to handle kernel paging request at 0000000000010007
>> [  235.425470] IP: run_timer_softirq+0x13a/0x470
>
>would also then have
>
>   run_timer_softirq at timer.c:XYZ
>
>which would make it easier to see exactly _what_ it is that faults. As
>it is, I think there's a fair number of inlining that makes it hard to
>see the cause, but that faddrtoline would make very obvious.

Good idea and tips! It'll definitely help debug the issues where
bisect cannot help.

>Finding that "symbol+xyz/abc" pattern should be fairly easy to
>automate, and should fit the 0day model fairly well. No?

Sure. We'll add DEBUG_INFO and automate faddr2line.

Regards,
Fengguang
