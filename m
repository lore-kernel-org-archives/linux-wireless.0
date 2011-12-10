Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51118 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1LJTtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 14:49:17 -0500
Received: by yenm11 with SMTP id m11so2904970yen.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 11:49:17 -0800 (PST)
Message-ID: <4EE3B7B9.5010908@lwfinger.net> (sfid-20111210_204921_181341_BEE36D90)
Date: Sat, 10 Dec 2011 13:49:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net> <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net> <4EE24615.9020003@broadcom.com> <4EE2509D.6020501@lwfinger.net> <4EE269CF.2000608@broadcom.com> <4EE29171.9060608@lwfinger.net> <CACna6rzQuw+oMvYjN6+7SsTqqW=vFFj8W1iuwDY8x+p+GgJ6jA@mail.gmail.com> <4EE33CCB.80309@broadcom.com>
In-Reply-To: <4EE33CCB.80309@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 05:04 AM, Arend van Spriel wrote:
>
> Obviously it should be a pci_read_config_dword(). I found out that I can
> reproduce the problem over here so I added the print statements:
>
> [61359.893254] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
> [61359.897801] core[2] id=0x820 addr=18002000 wrap=18102000
> [61359.897808] core[1] id=0x812 addr=18001000 wrap=18101000
> [61359.897814] core[0] id=0x800 addr=18000000 wrap=18100000
> [61359.897822] PCI_BAR0_WIN=18107000
>
> Not sure how it got programmed to this value, but it definitely is wrong.

I put pr_info() and dump_stack() at every place where PCI_BAR_WIN0 is changed. 
The one place in drivers/bcma/host_pci.c is never called - only the location in 
drivers/bcma/scan.c.

The logged data is

[  813.683905] bcma: BCMA_PCI_BAR0_WIN set to 0x18000000
[  813.683910] Pid: 8989, comm: work_for_cpu Tainted: G           O 
3.2.0-rc4-wl+ #146
[  813.683913] Call Trace:
[  813.683926]  [<ffffffffa0389af6>] 
bcma_scan_switch_core.isra.9.part.10+0x36/0x40 [bcma]
[  813.683933]  [<ffffffffa0389bde>] bcma_init_bus+0x6e/0x70 [bcma]
[  813.683940]  [<ffffffffa0389c04>] bcma_bus_scan+0x24/0x210 [bcma]
[  813.683946]  [<ffffffff81028f11>] ? __ioremap_caller+0x2b1/0x390
[  813.683951]  [<ffffffff811dded0>] ? pci_iomap+0x80/0xc0
[  813.683958]  [<ffffffffa0389209>] bcma_bus_register+0x19/0x2e0 [bcma]
[  813.683964]  [<ffffffffa038b800>] bcma_host_pci_probe+0x120/0x1c0 [bcma]
[  813.683970]  [<ffffffff810636b0>] ? cwq_activate_first_delayed+0x110/0x110
[  813.683976]  [<ffffffff811f17b2>] local_pci_probe+0x12/0x20
[  813.683980]  [<ffffffff810636c3>] do_work_for_cpu+0x13/0x30
[  813.683984]  [<ffffffff8106bb07>] kthread+0x87/0x90
[  813.683990]  [<ffffffff81384f74>] kernel_thread_helper+0x4/0x10
[  813.683995]  [<ffffffff8138269d>] ? retint_restore_args+0xe/0xe
[  813.683999]  [<ffffffff8106ba80>] ? __init_kthread_worker+0x70/0x70
[  813.684041]  [<ffffffff81384f70>] ? gs_change+0xb/0xb
[  813.684048] bcma: BCMA_PCI_BAR0_WIN set to 0x18107000

The stack trace is identical for the second entry. It is never remapped, which 
is why it is wrong in brcmsmac.

Question: Don't you need to change the R_REG macro to use bcma? It is still 
doing read{b,w,l} operations, and is not checking the mapping.

Larry

