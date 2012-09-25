Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1854 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2IYNZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 09:25:47 -0400
Message-ID: <5061B0D1.9070704@broadcom.com> (sfid-20120925_152550_486850_302CB0CD)
Date: Tue, 25 Sep 2012 15:25:37 +0200
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rmmod bcma trigger a crash
References: <20120918114830.GA3704@redhat.com>
In-Reply-To: <20120918114830.GA3704@redhat.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2012 01:48 PM, Stanislaw Gruszka wrote:
> Hi
>
> I have following crash when doing rmmod bcma (or
> modprobe -r brcmsmac). It happen on 3.5 and latest
> wireless-testing tree.
>
> <4>Pid: 28372, comm: modprobe Not tainted 2.6.32.sgruszka_03 #7 Hewlett-Packard HP xw8600 Workstation/0A98h
> <4>RIP: 0010:[<ffffffffa02f03eb>]  [<ffffffffa02f03eb>] bcma_bus_unregister+0x3b/0x60 [bcma]
> <4>RSP: 0018:ffff8800181a9d78  EFLAGS: 00010296
> <4>RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b678b RCX: 0000000000000001
> <4>RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000282
> <4>RBP: ffff8800181a9d88 R08: 0000000000000000 R09: 0000000000000000
> <4>R10: 0000000000000000 R11: 0000000000000001 R12: ffff880123af28b8
> <4>R13: ffff880123af2888 R14: ffffffffa02f5588 R15: 000000000040f5b0
> <4>FS:  00007f4db9f33700(0000) GS:ffff88002c000000(0000) knlGS:0000000000000000
> <4>CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>CR2: 00007f4db9f4a000 CR3: 0000000129a46000 CR4: 00000000000406f0
> <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <4>Process modprobe (pid: 28372, threadinfo ffff8800181a8000, task ffff880106f4d780)
> <4>Stack:
> <4>  ffff88012c8dd000 ffff88012c8dd090 ffff8800181a9db8 ffffffffa02f3c4a
> <4><d>  ffffffffa02f5520 ffff88012c8dd090 ffff88012c8dd000 ffff88012c8dd0f0
> <4><d>  ffff8800181a9dd8 ffffffff812bdf57 ffff88012c8dd090 ffffffffa02f5520
> <4>Call Trace:
> <4>  [<ffffffffa02f3c4a>] bcma_host_pci_remove+0x2f/0x65 [bcma]
> <4>  [<ffffffff812bdf57>] pci_device_remove+0x37/0x70
> <4>  [<ffffffff8137d7b5>] __device_release_driver+0x75/0xe0
> <4>  [<ffffffff8137d8f0>] driver_detach+0xd0/0xe0
> <4>  [<ffffffff8137c598>] bus_remove_driver+0x98/0x110
> <4>  [<ffffffff8137e0f2>] driver_unregister+0x62/0xa0
> <4>  [<ffffffff812be274>] pci_unregister_driver+0x44/0xa0
> <4>  [<ffffffffa02f3631>] bcma_host_pci_exit+0x15/0x17 [bcma]
> <4>  [<ffffffffa02f360e>] bcma_modexit+0xe/0x1c [bcma]
> <4>  [<ffffffff810bf826>] sys_delete_module+0x196/0x260
> <4>  [<ffffffff8100b0ea>] ? sysret_check+0x2e/0x69
> <4>  [<ffffffff815382b2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> <4>  [<ffffffff8100b0b2>] system_call_fastpath+0x16/0x1b
> <4>Code: 4c 8d 67 30 49 39 c4 48 8d 98 20 fc ff ff 75 1b eb 2e 66 0f 1f 44 00 00 48 8b 83 e0 03 00 00 49 39 c4 48 8d 98 20 fc ff ff 74 15<80>  bb b4 03 00 00 00 74 e4 48 8d 7b 10 e8 43 9f 08 e1 eb d9 90
> <1>RIP  [<ffffffffa02f03eb>] bcma_bus_unregister+0x3b/0x60 [bcma]
> <4>  RSP<ffff8800181a9d78>
>
> On source file crash happen at line 137:
>
> (gdb) l *(bcma_bus_unregister+0x3b)
> 0x41b is in bcma_bus_unregister (drivers/bcma/main.c:137).
> 132	static void bcma_unregister_cores(struct bcma_bus *bus)
> 133	{
> 134		struct bcma_device *core;
> 135	
> 136		list_for_each_entry(core,&bus->cores, list) {
> 137			if (core->dev_registered)
> 138				device_unregister(&core->dev);
> 139		}
> 140	}
>
> I'm attaching my .config file.
>
> Thanks
> Stanislaw
>
Hi,
I get the same thing on v3.6-rc5.
It happens even if there wasn't any driver loaded that uses bcma.
I was able to reproduce it only on x64

Kind regards
Piotr

