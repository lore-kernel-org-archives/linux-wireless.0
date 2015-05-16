Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33009 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbbEPO5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 10:57:16 -0400
Received: by oica37 with SMTP id a37so102331076oic.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 07:57:15 -0700 (PDT)
Message-ID: <55575AC8.2060301@lwfinger.net> (sfid-20150516_165720_997704_77B48DD3)
Date: Sat, 16 May 2015 09:57:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Haggai Eran <haggai.eran@gmail.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: kernel page fault in r8712u
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
In-Reply-To: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2015 07:17 AM, Haggai Eran wrote:
> Hi,
>
> I've encountered the oops below running the r8712u driver. It occurred
> on Raspberry Pi (OpenELEC 5.95 beta, running kernel version 4.0.3),
> with the following device:
>> 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter
>
> I'd be happy to dig in and see what the problem is, but I wanted to
> make sure this is the right driver to look at. linuxwireless.org says
> that this driver is going to be replaced by rtl8192su [1].
>
> Have you seen this issue?
>
> Thanks,
> Haggai
>
> [1] http://linuxwireless.org/en/users/Drivers/rtl819x/
>
> [  834.537661] Unable to handle kernel paging request at virtual
> address a9d797d7
> [  834.544900] pgd = 96b14000
> [  834.547604] [a9d797d7] *pgd=00000000
> [  834.551186] Internal error: Oops: 5 [#1] ARM
> [  834.555449] Modules linked in: cfg80211 bluetooth r8712u(C)
> bcm2708_rng [last unloaded: btusb]
> [  834.564092] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G         C
>    4.0.1 #1
> [  834.571303] Hardware name: BCM2708
> [  834.574702] task: 9703a700 ti: 97056000 task.ti: 97056000
> [  834.580125] PC is at put_compound_page+0x64/0x1d0
> [  834.584833] LR is at put_page+0x48/0x4c
> [  834.588670] pc : [<80076354>]    lr : [<80076508>]    psr: 00000113
> [  834.588670] sp : 97057d70  ip : 97057d88  fp : 97057d84
> [  834.600129] r10: 97335c00  r9 : 0000003c  r8 : 00000c21
> [  834.605345] r7 : 9723cf00  r6 : 972a6900  r5 : 972a6900  r4 : 5d270b9a
> [  834.611862] r3 : d7a0d795  r2 : d7a0d795  r1 : 00000001  r0 : a9d797d7
> [  834.618390] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
> Segment kernel
> [  834.625690] Control: 00c5387d  Table: 16b14008  DAC: 00000015
> [  834.631429] Process ksoftirqd/0 (pid: 3, stack limit = 0x97056188)
> [  834.637601] Stack: (0x97057d70 to 0x97058000)
> [  834.641957] 7d60:                                     00000000

--snip--

> [  834.813594] Backtrace:
> [  834.816072] [<800762f0>] (put_compound_page) from [<80076508>]
> (put_page+0x48/0x4c)
> [  834.823722]  r5:972a6900 r4:00000000
> [  834.827331] [<800764c0>] (put_page) from [<803d86c0>]
> (skb_release_data+0x6c/0xcc)
> [  834.834904] [<803d8654>] (skb_release_data) from [<803d8748>]
> (skb_release_all+0x28/0x2c)
> [  834.843071]  r7:89868bd0 r6:89868420 r5:89868bd0 r4:9723cf00
> [  834.848759] [<803d8720>] (skb_release_all) from [<803d8844>]
> (consume_skb+0x28/0x5c)
> [  834.856490]  r4:9723cf00 r3:00000001
> [  834.860088] [<803d881c>] (consume_skb) from [<803e4b94>]
> (__dev_kfree_skb_any+0x44/0x48)
> [  834.868167]  r4:898c2d18 r3:40000113
> [  834.871974] [<803e4b50>] (__dev_kfree_skb_any) from [<7f01a714>]
> (r8712_free_recvframe+0x2c/0x9c [r8712u])
> [  834.881891] [<7f01a6e8>] (r8712_free_recvframe [r8712u]) from
> [<7f01b094>] (recv_func+0x8c/0x6e8 [r8712u])

Yes, this driver will likely be replaced, but I have no idea how soon that will be.

No, I am not aware of this problem, but see below.

The problem appears to be from r8712u. From the stack dump, the problem happens 
when r8712_free_recvframe() calls __dev_kfree_skb_any(). A complication is that 
my copy of the kernel source does not show such a call. :(

Please use gdb to help with the debugging. From the main directory of your 
source, enter the command 'gdb drivers/staging/rtl8712/r8712u.ko'. Once it 
prompts you, enter 'l *r8712_free_recvframe+0x2c'. The first character is ell, 
not one. That will show the actual line of code. Please post that info.

This driver has been used for a long time with x86 architecture, but not much 
with ARM, which has different alignment issues. That may be the source of the 
problem.

Larry

