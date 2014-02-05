Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38797 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaBEGwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 01:52:23 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so5142782wgh.5
        for <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 22:52:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJwzM1mhN7+ydLvF3tV25theZW8jcqjzrKuXFBoUO9SW43xfUA@mail.gmail.com>
References: <CAAUTuq_bgXcfKquXR+ATumO7xkyTE_WLUvUOMZ7bPYCP0_XnuQ@mail.gmail.com>
 <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
 <CAAUTuq_LnUCTBaHndBiLDk0ge+055YJJMY4Ni+bV7PrYq_KSHA@mail.gmail.com>
 <CAJwzM1kQJvfZwPi_suBSgCEquAHvYduwRWcM01==nT_TVd0d0g@mail.gmail.com>
 <CAAUTuq9oU7+=_sjcix0WuSUp5_5OVRXK1cJdtRDtR1obaJrV1Q@mail.gmail.com>
 <CAAUTuq9dcKvGk0PWhP16=yyK79mE-T-1gbGPpd5G__imimHvBQ@mail.gmail.com>
 <CAAUTuq-WBMOLQE7FYFd32TrCN=3KwfFKgALs2pZGuBpKqkSDFg@mail.gmail.com> <CAJwzM1mhN7+ydLvF3tV25theZW8jcqjzrKuXFBoUO9SW43xfUA@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Wed, 5 Feb 2014 00:52:01 -0600
Message-ID: <CAAUTuq-HfQj6KZBjnzosRy7pjEtzo5TBa1ko+fjJOO8JA8UyXw@mail.gmail.com> (sfid-20140205_075329_541693_CA1FFF65)
Subject: Re: mwifiex and SD8787: TX queue timeout in AP mode
To: Avinash Patil <avinashapatil@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash,

On Tue, Feb 4, 2014 at 9:57 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
> Hi Andrew,
>
> I think this issue not specific to any interface as such.
>
> Do you have following fix in your tree:
>
> http://www.spinics.net/lists/linux-wireless/msg112753.html

Yes.
I'm running 3.13.1, which includes that fix.

>
> Also can you please try printing adapter->int_status during AP TX data timeout?

I added a printk after the TX timeout warning and got this:

[  437.677151] ------------[ cut here ]------------
[  437.681815] WARNING: CPU: 0 PID: 423 at net/sched/sch_generic.c:264
dev_watchdog+0x2d0/0x2f0()
[  437.690485] NETDEV WATCHDOG: uap0 (mwifiex_sdio): transmit queue 1 timed out
[  437.697580] Modules linked in: iptable_raw ipt_MASQUERADE xt_nat
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle xt_policy
nf_conntrack_ipv4 xt_tcpudp nf_defrag_ipv4 bridge nf_conntrack_ipv6
nf_defrag_ipv6 stp llc xt_conntrack nf_conntrack iptable_filter
ip6table_filter ip6_tables ip_tables x_tables hid_generic
snd_usb_audio snd_usbmidi_lib mwifiex_sdio mwifiex snd_hwdep
snd_rawmidi snd_seq_device snd_pcm snd_page_alloc snd_timer cfg80211
snd usbhid soundcore hid rfkill mv_cesa usbip_host(C) usbip_core(C)
ipv6 autofs4
[  437.743904] CPU: 0 PID: 423 Comm: tmux Tainted: G         C
3.13.1-2-ARCH #1
[  437.751189] [<c000f01c>] (unwind_backtrace+0x0/0x128) from
[<c000c394>] (show_stack+0x10/0x14)
[  437.759892] [<c000c394>] (show_stack+0x10/0x14) from [<c001aa80>]
(warn_slowpath_common+0x70/0x90)
[  437.768923] [<c001aa80>] (warn_slowpath_common+0x70/0x90) from
[<c001aad0>] (warn_slowpath_fmt+0x30/0x40)
[  437.778563] [<c001aad0>] (warn_slowpath_fmt+0x30/0x40) from
[<c04c6e50>] (dev_watchdog+0x2d0/0x2f0)
[  437.787673] [<c04c6e50>] (dev_watchdog+0x2d0/0x2f0) from
[<c0025bf8>] (call_timer_fn+0x30/0x170)
[  437.796512] [<c0025bf8>] (call_timer_fn+0x30/0x170) from
[<c00261b4>] (run_timer_softirq+0x1f8/0x368)
[  437.805798] [<c00261b4>] (run_timer_softirq+0x1f8/0x368) from
[<c001ef00>] (__do_softirq+0xdc/0x304)
[  437.814997] [<c001ef00>] (__do_softirq+0xdc/0x304) from
[<c001f4a4>] (irq_exit+0xb0/0xf8)
[  437.823228] [<c001f4a4>] (irq_exit+0xb0/0xf8) from [<c0009cc0>]
(handle_IRQ+0x34/0x84)
[  437.831199] [<c0009cc0>] (handle_IRQ+0x34/0x84) from [<c054cb38>]
(__irq_usr+0x38/0xa0)
[  437.839248] ---[ end trace 14ce7b4e4b0c47cb ]---
[  437.843888] mwifiex_sdio mmc0:0001:1: 12617 : Tx timeout(#1),
bss_type-num = 1-0
[  437.851335] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  447.676774] mwifiex_sdio mmc0:0001:1: 13601 : Tx timeout(#2),
bss_type-num = 1-0
[  447.684238] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  457.676409] mwifiex_sdio mmc0:0001:1: 14601 : Tx timeout(#3),
bss_type-num = 1-0
[  457.683848] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  467.676042] mwifiex_sdio mmc0:0001:1: 15601 : Tx timeout(#4),
bss_type-num = 1-0
[  467.683501] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  477.675679] mwifiex_sdio mmc0:0001:1: 16601 : Tx timeout(#5),
bss_type-num = 1-0
[  477.683116] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  487.675308] mwifiex_sdio mmc0:0001:1: 17601 : Tx timeout(#6),
bss_type-num = 1-0
[  487.682760] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  497.674942] mwifiex_sdio mmc0:0001:1: 18601 : Tx timeout(#7),
bss_type-num = 1-0
[  497.682383] mwifiex_sdio mmc0:0001:1: adapter->int_status = 0
[  497.688188] mwifiex_sdio mmc0:0001:1: tx_timeout_cnt exceeds
threshold. Triggering card reset!
[  497.698397] mwifiex_sdio: Resetting card...

The full log is at
http://www.cs.utexas.edu/users/wiley/mwifiexlog_2.txt if you want to
take a look - I didn't trim it down this time. It has debug output for
mwifiex and mwifiex_sdio.

Thanks,
Andrew
