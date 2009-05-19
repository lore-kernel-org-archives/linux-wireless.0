Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:33987 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZESSSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 14:18:11 -0400
Message-ID: <4A12F7E0.90501@wpkg.org>
Date: Tue, 19 May 2009 20:18:08 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ipw2100: Oops, Data bus error
References: <4A12E0F3.2040209@wpkg.org> <20090519173309.GC2691@tuxdriver.com>
In-Reply-To: <20090519173309.GC2691@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville schrieb:
> On Tue, May 19, 2009 at 06:40:19PM +0200, Tomasz Chmielewski wrote:
>> I'm not sure if it's interesting or not.
>>
>> On ASUS WL-500gP (MIPS platform, with OpenWRT patches), running 2.6.29.3 
>> kernel, I'm getting an Oops (see below) when I remove the ipw2100 module 
>> and modprobe it again.
>> Let me know if I should decode the Oops etc., or if has perhaps something to do with the board
>> not fully supported by the upstream kernel, and just leave it.
> 
> Please decode the oops... :-)

Umm...


# cat oops.txt | ksymoops

ksymoops 2.4.11 on mips 2.6.29.3.  Options used
      -V (default)
      -k /proc/ksyms (default)
      -l /proc/modules (default)
      -o /lib/modules/2.6.29.3/ (default)
      -m /boot/System.map-2.6.29.3 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Data bus error, epc == c02b8d54, ra == c02b8d48
Cpu 0
$ 0   : 00000000 1000d800 c02c8000 00000000
$ 4   : c02c0000 00000000 00000001 000000dc
$ 8   : 00000000 00000000 00000002 80340000
$12   : 80330000 00000030 00000008 00000000
$16   : 800372e8 81d4db28 00000000 c02bc374
$20   : 81d4d000 81ccb400 c02c8000 004fe008
$24   : 028f5beb 80180eb4
$28   : 80c36000 80c37cd8 7fa2db88 c02b8d48
Hi    : 00000083
Lo    : e42b2000
epc   : c02b8d54 0xc02b8d54
Using defaults from ksymoops -t elf32-tradlittlemips -a mips:3000
Status: 1000d803    KERNEL EXL IE
Cause : 0080001c
         00000000 00000000 00000000 00000000 00000000 00000080 4a12df14 
2f222ee2
         c02c09e0 81ccb400 00000000 c02c0a10 c02c4000 00000000 00000000 
80166874
         81ccb458 c02c0a10 c02c4000 801850d8 c02c09e0 81ccb400 c02c0d5c 
00000000
         81ccb458 81ccb458 c02c0a10 80185304 81c34a08 8014d614 000031f1 
1000d800
Call Trace:[<c02c4000>] 0xc02c4000
[<80166874>] 0x80166874
[<c02c4000>] 0xc02c4000
[<801850d8>] 0x801850d8
[<80185304>] 0x80185304
[<8014d614>] 0x8014d614
[<8018549c>] 0x8018549c
[<8018213c>] 0x8018213c
[<8014d398>] 0x8014d398
[<8018542c>] 0x8018542c
[<80184540>] 0x80184540
[<c02c4000>] 0xc02c4000
[<8014dba4>] 0x8014dba4
[<80184bd0>] 0x80184bd0
[<80184ba8>] 0x80184ba8
[<c02c4000>] 0xc02c4000
[<80185730>] 0x80185730
[<c02c4000>] 0xc02c4000
[<80166b30>] 0x80166b30
[<80081c38>] 0x80081c38
[<c02c4068>] 0xc02c4068
[<8017e7f4>] 0x8017e7f4
[<8000c664>] 0x8000c664
[<8007d528>] 0x8007d528
[<8007d4ec>] 0x8007d4ec
[<8004a1a4>] 0x8004a1a4
[<80059288>] 0x80059288
[<80059238>] 0x80059238
[<800031d0>] 0x800031d0
[<800031d0>] 0x800031d0
Code: 8e820024  10400300  3c04c02c <8c430090> 3c02d555  344255d5 
146202fc  3c028003  26a20058


 >>$12; 80330000 <invalid_pte_table+0/1000>
 >>$16; 800372e8 <init_timer+0/14>
 >>$25; 80180eb4 <mem_serial_out+0/20>

 >>PC;  c02b8d54 <END_OF_CODE+3ff74bc4/????>   <=====

Trace; c02c4000 <END_OF_CODE+3ff7fe70/????>
Trace; 80166874 <pci_device_probe+68/a4>
Trace; c02c4000 <END_OF_CODE+3ff7fe70/????>
Trace; 801850d8 <driver_sysfs_add+50/84>
Trace; 80185304 <driver_probe_device+16c/294>
Trace; 8014d614 <kobject_get+20/34>
Trace; 8018549c <__driver_attach+70/a8>
Trace; 8018213c <next_device+10/2c>
Trace; 8014d398 <kobject_init+58/9c>
Trace; 8018542c <__driver_attach+0/a8>
Trace; 80184540 <bus_for_each_dev+5c/a8>
Trace; c02c4000 <END_OF_CODE+3ff7fe70/????>
Trace; 8014dba4 <kobject_init_and_add+40/58>
Trace; 80184bd0 <bus_add_driver+cc/260>
Trace; 80184ba8 <bus_add_driver+a4/260>
Trace; c02c4000 <END_OF_CODE+3ff7fe70/????>
Trace; 80185730 <driver_register+b4/15c>
Trace; c02c4000 <END_OF_CODE+3ff7fe70/????>
Trace; 80166b30 <__pci_register_driver+4c/a0>
Trace; 80081c38 <remove_vm_area+30/7c>
Trace; c02c4068 <END_OF_CODE+3ff7fed8/????>
Trace; 8017e7f4 <serial8250_console_putchar+0/44>
Trace; 8000c664 <do_one_initcall+64/1dc>
Trace; 8007d528 <mmap_region+350/5d8>
Trace; 8007d4ec <mmap_region+314/5d8>
Trace; 8004a1a4 <blocking_notifier_call_chain+14/20>
Trace; 80059288 <sys_init_module+a8/1c0>
Trace; 80059238 <sys_init_module+58/1c0>
Trace; 800031d0 <stack_done+20/3c>
Trace; 800031d0 <stack_done+20/3c>

Code;  c02b8d48 <END_OF_CODE+3ff74bb8/????>
00000000 <_PC>:
Code;  c02b8d48 <END_OF_CODE+3ff74bb8/????>
    0:   8e820024  lw      v0,36(s4)
Code;  c02b8d4c <END_OF_CODE+3ff74bbc/????>
    4:   10400300  beqz    v0,c08 <_PC+0xc08>
Code;  c02b8d50 <END_OF_CODE+3ff74bc0/????>
    8:   3c04c02c  lui     a0,0xc02c
Code;  c02b8d54 <END_OF_CODE+3ff74bc4/????>   <=====
    c:   8c430090  lw      v1,144(v0)   <=====
Code;  c02b8d58 <END_OF_CODE+3ff74bc8/????>
   10:   3c02d555  lui     v0,0xd555
Code;  c02b8d5c <END_OF_CODE+3ff74bcc/????>
   14:   344255d5  ori     v0,v0,0x55d5
Code;  c02b8d60 <END_OF_CODE+3ff74bd0/????>
   18:   146202fc  bne     v1,v0,c0c <_PC+0xc0c>
Code;  c02b8d64 <END_OF_CODE+3ff74bd4/????>
   1c:   3c028003  lui     v0,0x8003
Code;  c02b8d68 <END_OF_CODE+3ff74bd8/????>
   20:   26a20058  addiu   v0,s5,88


1 warning and 1 error issued.  Results may not be reliable.


-- 
Tomasz Chmielewski
http://wpkg.org

