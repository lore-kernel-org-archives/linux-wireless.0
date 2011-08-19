Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47162 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1HSQFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 12:05:03 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so5043872pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 09:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADPsn1ba2y3ofBkE11jkF=sQF+6rcZY=VV9Zgdmo3kjOxs+pdQ@mail.gmail.com>
References: <CADPsn1ba2y3ofBkE11jkF=sQF+6rcZY=VV9Zgdmo3kjOxs+pdQ@mail.gmail.com>
Date: Fri, 19 Aug 2011 17:05:03 +0100
Message-ID: <CADPsn1a03ZrjEJubkxACBqxwQFdbXLN-cA2K8jAb1Oy-tuFe7Q@mail.gmail.com> (sfid-20110819_180517_071341_01511C56)
Subject: Re: Question about failure of scanning with ath6kl.ko
From: Sangwook Lee <sangwook.lee@linaro.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reason about failure of scanning is that Kernel bug with scan
complete function as like:

===================================================================
in_atomic(): 1, irqs_disabled(): 0, pid: 4704, name: ksdioirqd/mmc1
[<c003d484>] (unwind_backtrace+0x0/0xf8) from [<c00c8648>]
(__kmalloc+0x104/0x184)
[<c00c8648>] (__kmalloc+0x104/0x184) from [<c033cb58>]
(cfg80211_inform_bss_frame+0x64/0x1f4)
[<c033cb58>] (cfg80211_inform_bss_frame+0x64/0x1f4) from [<bf05c908>]
(ar6k_cfg80211_scan_node+0xcc/0x138 [ath6kl])
[<bf05c908>] (ar6k_cfg80211_scan_node+0xcc/0x138 [ath6kl]) from
[<bf072e58>] (wlan_iterate_nodes+0x5c/0x94 [ath6kl])
[<bf072e58>] (wlan_iterate_nodes+0x5c/0x94 [ath6kl]) from [<bf05d0e8>]
(ar6k_cfg80211_scanComplete_event+0x5c/0x104 [ath6kl])
[<bf05d0e8>] (ar6k_cfg80211_scanComplete_event+0x5c/0x104 [ath6kl])
from [<bf0627b8>] (ar6000_scanComplete_event+0x14/0xa8 [ath6kl])
[<bf0627b8>] (ar6000_scanComplete_event+0x14/0xa8 [ath6kl]) from
[<bf06f564>] (wmi_control_rx+0xdf4/0x22d8 [ath6kl])
[<bf06f564>] (wmi_control_rx+0xdf4/0x22d8 [ath6kl]) from [<bf0615d0>]
(ar6000_rx+0x300/0x604 [ath6kl])
[<bf0615d0>] (ar6000_rx+0x300/0x604 [ath6kl]) from [<bf0542f8>]
(DoRecvCompletion+0xc4/0x104 [ath6kl])
[<bf0542f8>] (DoRecvCompletion+0xc4/0x104 [ath6kl]) from [<bf055cf8>]
(HTCRecvMessagePendingHandler+0xca8/0x1370 [ath6kl])
[<bf055cf8>] (HTCRecvMessagePendingHandler+0xca8/0x1370 [ath6kl]) from
[<bf051d34>] (DevDsrHandler+0x198/0x72c [ath6kl])
[<bf051d34>] (DevDsrHandler+0x198/0x72c [ath6kl]) from [<bf073750>]
(hifIRQHandler+0x50/0xdc [ath6kl])
[<bf073750>] (hifIRQHandler+0x50/0xdc [ath6kl]) from [<c0263dd8>]
(sdio_irq_thread+0xac/0x2a0)

======================================================================
If anyone give me any advice, that would be great!!

Thanks
Sangwook




On 17 August 2011 16:51, Sangwook Lee <sangwook.lee@linaro.org> wrote:
> Hello
>
> I am using customised board using AR6003 WLAN.
> After running insmod ath6kl.ko, ifconfig up and then iwconfig scan as
> like the following,
> It seems not to work.
>
> ath6kl driver :
>       from 3.0 staging directory.
> Firmware images :
>      from http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ath6k.tar.gz
> Log message:
> -------------------------Start of Log
> ---------------------------------------------
> root@linaro-alip:~# insmod ath6kl.ko
> ath6kl: module is from the staging directory, the quality is unknown,
> you have been warned.
> BUG: spinlock bad magic on CPU#1, insmod/4686
>  lock: bf08683c, .magic: 00000000, .owner: insmod/4686, .owner_cpu: 1
> [<c003d484>] (unwind_backtrace+0x0/0xf8) from [<c0191a8c>]
> (do_raw_spin_unlock+0x84/0xc4)
> [<c0191a8c>] (do_raw_spin_unlock+0x84/0xc4) from [<c035b9fc>]
> (_raw_spin_unlock+0x8/0x30)
> [<c035b9fc>] (_raw_spin_unlock+0x8/0x30) from [<bf0950e0>]
> (ar6000_init_module+0xe0/0x1a0 [ath6kl)
> [<bf0950e0>] (ar6000_init_module+0xe0/0x1a0 [ath6kl]) from
> [<c003167c>] (do_one_initcall+0x34/0x1)
> [<c003167c>] (do_one_initcall+0x34/0x174) from [<c008bee8>]
> (sys_init_module+0xf0/0x19c0)
> [<c008bee8>] (sys_init_module+0xf0/0x19c0) from [<c0037040>]
> (ret_fast_syscall+0x0/0x30)
> root@linaro-alip:~# mmc1: queuing unknown CIS tuple 0x01 (3 bytes)
> mmc1: queuing unknown CIS tuple 0x1a (5 bytes)
> mmc1: queuing unknown CIS tuple 0x1b (8 bytes)
> mmc1: queuing unknown CIS tuple 0x14 (0 bytes)
> mmc1: queuing unknown CIS tuple 0x80 (1 bytes)
> mmc1: queuing unknown CIS tuple 0x81 (1 bytes)
> mmc1: queuing unknown CIS tuple 0x82 (1 bytes)
> mmc1: new high speed SDIO card at address 0001
> AR6000: Unsupported configuration opcode: 3
> AR6000: Unsupported configuration opcode: 3
> HIF Interrupt processing is SYNC ONLY
> AR6000: Unsupported configuration opcode: 7
> AR6000: Unsupported configuration opcode: 5
> In aggr_init..
> going out of aggr_init..status OK
> AR6K: Temporary WAR to avoid SDIO CRC error
> ar6000_init() Got WMI @ 0xed2b1c00.
>  Target Ready: credits: 11 credit size: 1664
> HIF-SCATTER Enabled: max scatter req : 4 entries: 16
> AR6K: HIF layer supports scatter requests (max scatter items:16: maxlen:32768)
> AR6K: max recv: 32768 max send: 12288
> ar6000_init() WMI is ready
> wmi_control_rx() : Unknown id 0x101e
> AR6000 Reg Code = 0x61
> ar6000: Multicast filter not supported
> ar6000: Multicast filter not supported
> ar6000: Multicast filter not supported
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> root@linaro-alip:~# ifconfig wlan0 up
> ar6000: Multicast filter not supported
> root@linaro-alip:~# iwlist wlan0 scan
> wlan0     Interface doesn't support scanning : Device or resource busy
>
> ------------------------------End of log --------------------------------------
>
> One more, my board is using 26Mhz for WLAN. which source code or
> configuration file do I put this
> information into ?
>
> Thanks
> Sangwook
>
