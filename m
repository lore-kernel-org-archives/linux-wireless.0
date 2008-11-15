Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:26345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYKOC5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 21:57:32 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1653035rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 18:57:31 -0800 (PST)
Message-ID: <449c10960811141857u2b0c4153h3735545dbec7ef8b@mail.gmail.com> (sfid-20081115_035752_064267_DBF03783)
Date: Fri, 14 Nov 2008 20:57:31 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith <m.sujith@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20081115022913.GC10702@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
	 <43e72e890811141037j5328f71fx7badb6f2b0e0831d@mail.gmail.com>
	 <449c10960811141133o6d34c53fke3894a32cc1e5b8b@mail.gmail.com>
	 <b6c5339f0811141233g38086cc0ybb69eebdbab7ae60@mail.gmail.com>
	 <43e72e890811141241k7ae83fc3qe90e2e42d61b8df6@mail.gmail.com>
	 <43e72e890811141313t33b6a3edo86488bea9a7b3371@mail.gmail.com>
	 <449c10960811141625o171d1e31v974d2f921f5a825@mail.gmail.com>
	 <20081115003608.GK27642@tesla>
	 <449c10960811141805w428df33ak2f98651abb7403e6@mail.gmail.com>
	 <20081115022913.GC10702@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 8:29 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Nov 14, 2008 at 08:05:09PM -0600, Dan McGee wrote:
>> On Fri, Nov 14, 2008 at 6:36 PM, Luis R. Rodriguez
>> Of course, now that I have a kernel with full debug symbols, I can't
>> get it to oops. Figures. I'll keep you updated if I see this error
>> again.
>
> Grasping at straws, is there any chance your kernel didn't match up
> with the compiled modules from compat-wireless?  For example, you
> reconfigured the kernel without rebuilding it, then compat-wireless
> picked up your .config?  I suppose that could lead to structures being
> defined with wrong offsets...

I doubt it; I'm compiling the whole enchilada in one go so it should
definitely match up. I just reproduced it with a brand new build after
going back to a no-symbols kernel. Here is a transcribed OOPS dump
since this one leaves the machine in a state where it doesn't even
finish booting up. I can *only* get this if I compile without
debugging symbols, and looking at the call trace, you can see the
apic_timer_interrupt call which leads me to believe it is some sort of
timing/race issue that a debug kernel doesn't run into.

-Dan

BUG: unable to handle kernel NULL pointer dereference at 00000082
IP: [<7818ca71>] sysfs_find_dirent+0x9/0x23
Oops: 0000 [#1] PREEMPT
Modules linked in: ath5k(+) mac80211

Pid: 818 comm: modprobe Not tainted (2.6.27.6eee #1)
EIP: 0060:[<7818ca71>] EFLAGS: 00010206 CPU: 0
EIP is at sysfs_find_dirent+0x9/0x23
EAX: 00000001 EBX: 00000072 ECX: 00000001 EDX: b730b4f0
ESI: b730b4f0 EDI: fffffff4 EBP: b7311490 ESP: b73ffd34
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Stack: <<<i'm too lazy>>>>
Call Trace:
 [<7818cb39>]: __sysfs_add_one+0x10/0x69
 [<7818cba2>]: sysfs_add_one+0x9/0x2f
 [<7818d0bc>]: create_dir+0x3c/0x62
 sysfs_create_dir+0x29/0x3b
 kobject_get
 kobject_add_internal
 kobject_add
 device_add+0x75/0x456
 apic_timer_interrupt+0x28/0x30
 strlcpy+0x11/0x3e
 register_netdevice+0x1f1/0x31a
 ieee80211_register_hw+0x1eb/0x2d0 [mac80211]
 ath5k_pci_probe+0xc27/0x1150 [ath5k]
 find_inode
 pci_device_probe
 driver_probe_device
 .......
 init_ath5k_pci [ath5k]
 .......
 ==============
Code: dd 85 c0 53 89 c3 74 16 83 38 00 75 0f ba 82 00 00 00 b8 f7 75
3c 78 e8 70 da f8 ff ff 03 89 d8 5b c3 56 89 d6 53 8b 58 18 eb 11 <8b>
43 10 89 f2 e8 34 cc 04 00 85 c0 74 07 8b 5b 0c 85 db 75 eb

$ AFLAGS=--32 scripts/decodecode < /tmp/oops.txt
Code: dd 85 c0 53 89 c3 74 16 83 38 00 75 0f ba 82 00 00 00 b8 f7 75
3c 78 e8 70 da f8 ff ff 03 89 d8 5b c3 56 89 d6 53 8b 58 18 eb 11 <8b>
43 10 89 f2 e8 34 cc 04 00 85 c0 74 07 8b 5b 0c 85 db 75 eb

/tmp/tmp.xJNdgiQwSL.o:     file format elf32-i386

Disassembly of section .text:

00000000 <.text>:
   0:	dd 85 c0 53 89 c3    	fldl   -0x3c76ac40(%ebp)
   6:	74 16                	je     0x1e
   8:	83 38 00             	cmpl   $0x0,(%eax)
   b:	75 0f                	jne    0x1c
   d:	ba 82 00 00 00       	mov    $0x82,%edx
  12:	b8 f7 75 3c 78       	mov    $0x783c75f7,%eax
  17:	e8 70 da f8 ff       	call   0xfff8da8c
  1c:	ff 03                	incl   (%ebx)
  1e:	89 d8                	mov    %ebx,%eax
  20:	5b                   	pop    %ebx
  21:	c3                   	ret
  22:	56                   	push   %esi
  23:	89 d6                	mov    %edx,%esi
  25:	53                   	push   %ebx
  26:	8b 58 18             	mov    0x18(%eax),%ebx
  29:	eb 11                	jmp    0x3c

/tmp/tmp.xJNdgiQwSL.o:     file format elf32-i386

Disassembly of section .text:

00000000 <.text>:
   0:	8b 43 10             	mov    0x10(%ebx),%eax
   3:	89 f2                	mov    %esi,%edx
   5:	e8 34 cc 04 00       	call   0x4cc3e
   a:	85 c0                	test   %eax,%eax
   c:	74 07                	je     0x15
   e:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  11:	85 db                	test   %ebx,%ebx
  13:	75 eb                	jne    0x0


And the objdump output from that function, but my novice eyes can't
pick out where the above code corresponds to:
0000027d <__sysfs_add_one>:
 27d:   56                      push   %esi
 27e:   89 c6                   mov    %eax,%esi
 280:   53                      push   %ebx
 281:   89 d3                   mov    %edx,%ebx
 283:   8b 00                   mov    (%eax),%eax
 285:   8b 52 10                mov    0x10(%edx),%edx
 288:   e8 fc ff ff ff          call   289 <__sysfs_add_one+0xc>
 28d:   ba ef ff ff ff          mov    $0xffffffef,%edx
 292:   85 c0                   test   %eax,%eax
 294:   75 4b                   jne    2e1 <__sysfs_add_one+0x64>
 296:   8b 06                   mov    (%esi),%eax
 298:   e8 fe fe ff ff          call   19b <sysfs_get>
 29d:   80 7b 1c 01             cmpb   $0x1,0x1c(%ebx)
 2a1:   89 43 08                mov    %eax,0x8(%ebx)
 2a4:   75 0a                   jne    2b0 <__sysfs_add_one+0x33>
 2a6:   8b 46 04                mov    0x4(%esi),%eax
 2a9:   85 c0                   test   %eax,%eax
 2ab:   74 03                   je     2b0 <__sysfs_add_one+0x33>
 2ad:   ff 40 28                incl   0x28(%eax)
 2b0:   ff 46 0c                incl   0xc(%esi)
 2b3:   83 7b 0c 00             cmpl   $0x0,0xc(%ebx)
 2b7:   8b 43 08                mov    0x8(%ebx),%eax
 2ba:   74 04                   je     2c0 <__sysfs_add_one+0x43>
 2bc:   0f 0b                   ud2a
 2be:   eb fe                   jmp    2be <__sysfs_add_one+0x41>
 2c0:   8d 48 18                lea    0x18(%eax),%ecx
 2c3:   8b 50 18                mov    0x18(%eax),%edx
 2c6:   eb 0e                   jmp    2d6 <__sysfs_add_one+0x59>
 2c8:   8b 43 20                mov    0x20(%ebx),%eax
 2cb:   3b 42 20                cmp    0x20(%edx),%eax
 2ce:   72 0a                   jb     2da <__sysfs_add_one+0x5d>
 2d0:   8d 4a 0c                lea    0xc(%edx),%ecx
 2d3:   8b 52 0c                mov    0xc(%edx),%edx
 2d6:   85 d2                   test   %edx,%edx
 2d8:   75 ee                   jne    2c8 <__sysfs_add_one+0x4b>
 2da:   89 53 0c                mov    %edx,0xc(%ebx)
 2dd:   31 d2                   xor    %edx,%edx
 2df:   89 19                   mov    %ebx,(%ecx)
 2e1:   5b                      pop    %ebx
 2e2:   89 d0                   mov    %edx,%eax
 2e4:   5e                      pop    %esi
 2e5:   c3                      ret
