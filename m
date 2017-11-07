Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:48240 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933684AbdKGKHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2017 05:07:00 -0500
MIME-Version: 1.0
In-Reply-To: <20171107085327.GA11380@redhat.com>
References: <1509983829.10974.2.camel@gmail.com> <20171107085327.GA11380@redhat.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 7 Nov 2017 11:06:39 +0100
Message-ID: <CACQ1gAi6XtjCHPji3BP71jDG7srg+BshesviasXiSqnw2zs9_Q@mail.gmail.com> (sfid-20171107_110823_320712_8ECF77AB)
Subject: Re: Soft lockup in rt2x00usb_work_rxdone()
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-11-07 9:53 GMT+01:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> Hi
Hi !
>
> On Mon, Nov 06, 2017 at 04:57:09PM +0100, Richard Genoud wrote:
>> I get a soft lock-up while unbinding the USB driver on a TP-Link TL-WN727Nv3 (chipset 5370):
>>
>> # echo 1-2.2 > /sys/bus/usb/drivers/usb/unbind
>> watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u2:3:308]
> ...
>> I can trigger this each time.
>
> I can not reproduce this on my system (I'm using 4.14.0-rc6, but I don't
> think it's an issue). I think the problem may be caused by usb
> host controler driver, which can be different on your system.
>
> Does ftrace work on your platform ? If so could you use ftrace
> to provide rt2x00 functions trace when the  probllem happen ?
>
> 3 short articles how to configure and use ftrace are here:
> https://lwn.net/Articles/365835/
> https://lwn.net/Articles/366796/
> https://lwn.net/Articles/370423/
>
I tried with ftrace, but I don't think there's a way to dump the trace
when there's a soft lock-up
(I can't do anything after the unbind, even the heartbeat led stopped blinking).
I saw the /proc/sys/kernel/ftrace_dump_on_oops file, but there's no
/proc/sys/kernel/ftrace_dump_on_soft_lock-up file :)

Or I missed something in ftrace ?

Thanks !
Richard.

> Thanks
> Stanislaw
