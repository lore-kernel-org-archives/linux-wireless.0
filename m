Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:2806 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161063AbYHFVOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:14:40 -0400
Message-ID: <489A141B.8000603@wpkg.org> (sfid-20080806_231447_342105_D374E65A)
Date: Wed, 06 Aug 2008 23:14:03 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Johannes Berg <johannes@sipsolutions.net>, Chr <chunkeey@web.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org> <1218053763.23048.67.camel@johannes.berg> <489A0970.9030104@wpkg.org> <200808062234.10794.mb@bu3sch.de>
In-Reply-To: <200808062234.10794.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch schrieb:
> On Wednesday 06 August 2008 22:28:32 Tomasz Chmielewski wrote:
>> Johannes Berg schrieb:
>>>> Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c007118c>]
>>>>
>>>> Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010
>>>> Kernel panic - not syncing: Fatal exception in interrupt
>>> Please remove me from the CC list, at least until you've discovered
>>> ksymoops.
>> Sorry for that. Is this one more helpful?
> 
> No, you seem to be using the wrong System.map and/or vmlinux image.
> Read the manpage, please.

Why do you think they are wrong?

Both files (System.map and vmlinux image) come from the kernel which panicked.

It could be I compiled the kernel by adding one module (no compiled-in the kernel changes) to its .config - without flashing the kernel. Would it make a difference to System.map and/or vmlinux image and ksymoops?

If so, here is one more try, where everything should be proper.

This panic was made by simply doing the below ~50 times in a loop, and is reproducible:

rmmod prism54
modprobe prism54
ifconfig eth2 up


If it's still totally wrong, please take my apologies, but I've no idea what I may be doing wrong.


# ksymoops -K -v vmlinux-2.6.25.12 < oops2
ksymoops 2.4.11 on mips 2.6.25.12.  Options used
     -v vmlinux-2.6.25.12 (specified)
     -K (specified)
     -l /proc/modules (default)
     -o /lib/modules/2.6.25.12/ (default)
     -m /boot/System.map-2.6.25.12 (default)

No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Data bus error, epc == c0084834, ra == 8004cc30
Cpu 0
$ 0   : 00000000 10009800 00000001 00000001
$ 4   : c0054000 81df0b60 ffffffff 00000000
$ 8   : 1000d800 1000001f 802e0000 802f0000
$12   : 802e0000 00000005 802e4588 81c3d950
$16   : 81dea280 00000080 00000001 00000006
$20   : 00000000 c0054078 00000001 7fd019e8
$24   : 00000001 2abb4fb0
$28   : 80ec0000 80ec1c50 7fd0199c 8004cc30
Hi    : 00020200
Lo    : 05858000
epc   : c0084834     Not tainted
Using defaults from ksymoops -t elf32-tradlittlemips -a mips:3000
Cause : 0080401c
        00000001 8004cc30 802a1a90 00000006 81df0b60 81df0800 802a1a90 00000006
        81df0b60 81df0800 8004e0dc 00000005 802e4588 81c3d950 802e4df4 00000000
        00004000 c0054000 80001e54 00008914 00000400 00000000 0000c881 802a0000
        00000000 80002ca4 00000001 7fd019e8 80125850 80023de8 802e4df4 00000000
Call Trace:[<8018405c>][<8004cc30>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80001e54>][<80002ca4>][<80125850>][<80023de8>][<c0083c00>][<c0083c98>][<80001e54>]
Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010


>>RA;  8004cc30 <handle_IRQ_event+64/d4>
>>$12; 802e0000 <invalid_pte_table+0/1000>
>>$14; 802e4588 <per_cpu__runqueues+30/410>
>>$31; 8004cc30 <handle_IRQ_event+64/d4>

>>PC;  c0084834 <END_OF_CODE+3fd8da64/????>   <=====

Trace; 8018405c <usb_hcd_irq+68/150>
Trace; 8004cc30 <handle_IRQ_event+64/d4>
Trace; 8001d2bc <try_to_wake_up+78/c8>
Trace; 8004cc30 <handle_IRQ_event+64/d4>
Trace; 8004e0dc <handle_percpu_irq+54/ac>
Trace; 80001e54 <plat_irq_dispatch+1ac/1d8>
Trace; 80002ca4 <ret_from_irq+0/4>
Trace; 80125850 <vscnprintf+14/30>
Trace; 80023de8 <vprintk+34c/398>
Trace; c0083c00 <END_OF_CODE+3fd8ce30/????>
Trace; c0083c98 <END_OF_CODE+3fd8cec8/????>
Trace; 80001e54 <plat_irq_dispatch+1ac/1d8>

Code;  c0084828 <END_OF_CODE+3fd8da58/????>
00000000 <_PC>:
Code;  c0084828 <END_OF_CODE+3fd8da58/????>
   0:   8ca40150  lw      a0,336(a1)
Code;  c008482c <END_OF_CODE+3fd8da5c/????>
   4:   24020001  li      v0,1
Code;  c0084830 <END_OF_CODE+3fd8da60/????>
   8:   afa20010  sw      v0,16(sp)
Code;  c0084834 <END_OF_CODE+3fd8da64/????>   <=====
   c:   8c820078  lw      v0,120(a0)   <=====
Code;  c0084838 <END_OF_CODE+3fd8da68/????>
  10:   00a08021  move    s0,a1
Code;  c008483c <END_OF_CODE+3fd8da6c/????>
  14:   30420200  andi    v0,v0,0x200
Code;  c0084840 <END_OF_CODE+3fd8da70/????>
  18:   1440009f  bnez    v0,298 <_PC+0x298>
Code;  c0084844 <END_OF_CODE+3fd8da74/????>
  1c:   8cb10160  lw      s1,352(a1)
Code;  c0084848 <END_OF_CODE+3fd8da78/????>
  20:   8c820010  lw      v0,16(a0)

Kernel panic - not syncing: Fatal exception in interrupt



-- 
Tomasz Chmielewski
http://wpkg.org
