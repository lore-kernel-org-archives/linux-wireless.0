Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:2035 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422789AbYHFU2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:28:41 -0400
Message-ID: <489A0970.9030104@wpkg.org> (sfid-20080806_222901_631304_A2679717)
Date: Wed, 06 Aug 2008 22:28:32 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Chr <chunkeey@web.de>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org>	 <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com>	 <4899F540.8050409@wpkg.org> <200808062150.01765.chunkeey@web.de>	 <489A03E7.60800@wpkg.org> <1218053763.23048.67.camel@johannes.berg>
In-Reply-To: <1218053763.23048.67.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
>> Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c007118c>]
>>
>> Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010
>> Kernel panic - not syncing: Fatal exception in interrupt
> 
> Please remove me from the CC list, at least until you've discovered
> ksymoops.

Sorry for that. Is this one more helpful?


# ksymoops -v vmlinux-2.6.25.12 < oops
ksymoops 2.4.11 on mips 2.6.25.12.  Options used
     -v vmlinux-2.6.25.12 (specified)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.25.12/ (default)
     -m /boot/System.map-2.6.25.12 (default)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Data bus error, epc == c0071834, ra == 8004cc30
Cpu 0
$ 0   : 00000000 10009800 00000001 00000001
$ 4   : c0054000 80de8b60 ffffffff 00000000
$ 8   : 1000d800 1000001f 802e0000 802f0000
$12   : 802e0000 00000006 802e4588 81c3d508
$16   : 81d69880 00000080 00000001 00000006
$20   : 00000000 c0054078 00000001 7fc25828
$24   : 00000001 2abb4fb0
$28   : 80de0000 80de1c50 7fc258bc 8004cc30
Hi    : 00020200
Lo    : 05858000
epc   : c0071834     Not tainted
Using defaults from ksymoops -t elf32-tradlittlemips -a mips:3000
Cause : 0080401c
        00000001 8004cc30 802a1a90 00000006 80de8b60 80de8800 802a1a90 00000006
        80de8b60 80de8800 8004e0dc 80002ca4 81d17e00 10009801 00000000 8001c310
        00004000 c0054000 80001e54 1000d800 00000400 00000000 0000468c 802a0000
        00000000 80002ca4 00000001 7fc25828 80125850 00000006 802e4df4 00000000
Call Trace:[<8018405c>][<8001d2bc>][<8004cc30>][<8004e0dc>][<80002ca4>][<8001c310>][<80001e54>][<80002ca4>][<80125850>][<c0070c00>][<c0070c98>][<c007118c>]
Code: 8ca40150  24020001  afa20010 <8c820078> 00a08021  30420200  1440009f  8cb10160  8c820010


>>RA;  8004cc30 <handle_IRQ_event+64/d4>
>>$12; 802e0000 <invalid_pte_table+0/1000>
>>$14; 802e4588 <per_cpu__runqueues+30/410>
>>$31; 8004cc30 <handle_IRQ_event+64/d4>

>>PC;  c0071834 <END_OF_CODE+3fd7aa64/????>   <=====

Trace; 8018405c <usb_hcd_irq+68/150>
Trace; 8001d2bc <try_to_wake_up+78/c8>
Trace; 8004cc30 <handle_IRQ_event+64/d4>
Trace; 8004e0dc <handle_percpu_irq+54/ac>
Trace; 80002ca4 <ret_from_irq+0/4>
Trace; 8001c310 <__wake_up_common+54/bc>
Trace; 80001e54 <plat_irq_dispatch+1ac/1d8>
Trace; 80002ca4 <ret_from_irq+0/4>
Trace; 80125850 <vscnprintf+14/30>
Trace; c0070c00 <END_OF_CODE+3fd79e30/????>
Trace; c0070c98 <END_OF_CODE+3fd79ec8/????>
Trace; c007118c <END_OF_CODE+3fd7a3bc/????>

Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
00000000 <_PC>:
Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
   0:   8ca40150  lw      a0,336(a1)
Code;  c007182c <END_OF_CODE+3fd7aa5c/????>
   4:   24020001  li      v0,1
Code;  c0071830 <END_OF_CODE+3fd7aa60/????>
   8:   afa20010  sw      v0,16(sp)
Code;  c0071834 <END_OF_CODE+3fd7aa64/????>   <=====
   c:   8c820078  lw      v0,120(a0)   <=====
Code;  c0071838 <END_OF_CODE+3fd7aa68/????>
  10:   00a08021  move    s0,a1
Code;  c007183c <END_OF_CODE+3fd7aa6c/????>
  14:   30420200  andi    v0,v0,0x200
Code;  c0071840 <END_OF_CODE+3fd7aa70/????>
  18:   1440009f  bnez    v0,298 <_PC+0x298>
Code;  c0071844 <END_OF_CODE+3fd7aa74/????>
  1c:   8cb10160  lw      s1,352(a1)
Code;  c0071848 <END_OF_CODE+3fd7aa78/????>
  20:   8c820010  lw      v0,16(a0)

Kernel panic - not syncing: Fatal exception in interrupt

1 error issued.  Results may not be reliable.



-- 
Tomasz Chmielewski
http://wpkg.org
