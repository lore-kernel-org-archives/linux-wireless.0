Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62814 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1KKFCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 00:02:15 -0500
Received: by wwe5 with SMTP id 5so774820wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2011 21:02:14 -0800 (PST)
MIME-Version: 1.0
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 10 Nov 2011 21:01:53 -0800
Message-ID: <CAG6hwVN9wR9mbRVWUA_Poa8ng+9RzHXj6PDfpLfN0djWeYAs9g@mail.gmail.com> (sfid-20111111_060225_002643_0DE5CC0B)
Subject: regression in "mac80211: support adding IV-room in the skb for CCMP keys"
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Any kernel debugging tips involving stack corruption? :)

When testing a secure mesh topology in qemu using mac80211_hwsim with
master-2011-11-09 I get a hard lockup, but no OOPS. gdb was able to
show:

0xffffffff8129df9a in delay_tsc (loops=2660152) at arch/x86/lib/delay.c:80
80			if (unlikely(cpu != smp_processor_id())) {
(gdb) bt
#0  0xffffffff8129df9a in delay_tsc (loops=2660152) at arch/x86/lib/delay.c:80
#1  0xffffffff8129df0d in __delay (loops=<optimized out>) at
arch/x86/lib/delay.c:112
#2  __const_udelay (xloops=<optimized out>) at arch/x86/lib/delay.c:126
#3  0xffffffff816eeb7e in panic (fmt=<optimized out>) at kernel/panic.c:154
#4  0xffffffff816fbe32 in oops_end (flags=582, regs=0xffff880017c03698, signr=9)
    at arch/x86/kernel/dumpstack.c:243
#5  0xffffffff816ee301 in no_context (regs=0xffff880017c03698,
error_code=<optimized out>, address=7)
    at arch/x86/mm/fault.c:680
#6  0xffffffff816ee4db in __bad_area_nosemaphore
(regs=0xffff880017c03698, error_code=0, address=7,
    si_code=196609) at arch/x86/mm/fault.c:758
#7  0xffffffff816ee50d in bad_area_nosemaphore (regs=<optimized out>,
error_code=<optimized out>,
    address=<optimized out>) at arch/x86/mm/fault.c:765
#8  0xffffffff816fe714 in do_page_fault (regs=0xffff880017c03698, error_code=0)
    at arch/x86/mm/fault.c:1111
#9  <signal handler called>
#10 0xffffffffa0005825 in ?? ()
Backtrace stopped: previous frame identical to this frame (corrupt stack?)
(gdb) file net/mac80211/mac
mac80211.ko     mac80211.mod.c  mac80211.mod.o  mac80211.o
(gdb) file net/mac80211/mac80211.ko

(gdb) bt
#0  0xffffffff8129df9a in ?? ()
#1  0xffff880017c033f8 in ?? ()
#2  0xffffffff8129df0d in ?? ()
#3  0xffff880017c03478 in ?? ()
#4  0xffffffff816eeb7e in ?? ()
#5  0xffffffff810479a3 in ?? ()
#6  0xffffffff00000008 in ?? ()
#7  0xffff880017c03488 in ?? ()
#8  0xffff880017c03428 in ?? ()
#9  0xffff880017c03698 in ?? ()
#10 0x0000000000000001 in ieee80211_napi_poll (napi=0x289738, budget=-623469717)
    at net/mac80211/main.c:1099
#11 0x0000000000000002 in ieee80211_napi_poll (napi=0x289738, budget=-623469717)
    at net/mac80211/main.c:1099
#12 0x0000000000000000 in ?? ()
(gdb)

I've narrowed this down to 077a9154898b374f20555adc3f620cccd02581d6 "
mac80211: support adding IV-room in the skb for CCMP keys". Not sure
how this will affect encryption under mac80211_hwsim, but hopefully
this is useful to someone more knowledgeable.

Thanks!
Thomas
