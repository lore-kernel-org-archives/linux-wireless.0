Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:56734 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbZJZNSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:18:13 -0400
Received: by iwn10 with SMTP id 10so5937279iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 06:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE35A9E.8000507@wpkg.org>
References: <4AE35A9E.8000507@wpkg.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Oct 2009 06:17:58 -0700
Message-ID: <43e72e890910260617n6efbd260gcafbf5d1d2c84e23@mail.gmail.com>
Subject: Re: "Reserved instruction in kernel code" on ath9k insertion
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 24, 2009 at 12:50 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> When I do "modprobe ath9k" on ASUS-WL-500gP (MIPS) with _ath5k_ card (so, no
> ath9k hardware), it says "Reserved instruction in kernel code" - is it
> expected?

No.

> The kernel is 2.6.31.1.
>
>
> # modprobe ath9k
> [  165.440000] Reserved instruction in kernel code[#1]:
> [  165.440000] Cpu 0
> [  165.440000] $ 0   : 00000000 1000dc00 00000000 00000000
> [  165.440000] $ 4   : c1135b20 00000001 c044e69c ffffffff
> [  165.440000] $ 8   : 0000000a 8101f6d8 ffffffe0 0000002b
> [  165.440000] $12   : 00000e44 00000006 80333ae8 5f657361
> [  165.440000] $16   : 00000001 c1135ca4 80370000 81418000
> [  165.440000] $20   : 00000000 00000000 00000000 004fe008
> [  165.440000] $24   : 00000010 c1115118
> [  165.440000] $28   : 81da6000 81da7ea8 7febead8 81418014
> [  165.440000] Hi    : 00000000
> [  165.440000] Lo    : 00000000
> [  165.440000] epc   : c044e694 0xc044e694
> [  165.440000]     Not tainted

This says not tainted.

> [  165.440000] ra    : 81418014 ath9k_init+0x14/0xa4 [ath9k]

So ath9k_init() should run whether you have the hardware or not since
you modprobed' ath9k. For ath9k this consists of running:

ath_rate_control_register()
ath9k_debug_create_root()
ath_pci_init()
ath_ahb_init()

debugfs stuff should be a no-op unless you have enabled
CONFIG_ATH9k_DEBUG. So even ath_pci_init() should succeed even if you
do not have any of the claimed PCI devices, the only way that fails is
if pci_register_driver() fails.

More below.

> [  165.440000] Status: 1000dc03    KERNEL EXL IE
> [  165.440000] Cause : 80800028
> [  165.440000] PrId  : 00029006 (Broadcom BCM3302)
> [  165.440000] Modules linked in: ath9k(+) aes_generic tun sch_sfq cls_fw
> sch_htb ipt_MASQUERADE iptable_nat nf_nat xt_MARK iptable_mangle ipt_ULOG
> xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp
> iptable_filter ip_tables x_tables arc4 ecb ath5k mac80211 ath ohci_hcd
> cfg80211 uhci_hcd
> [  165.440000] Process modprobe (pid: 1285, threadinfo=81da6000,
> task=81dc0048, tls=2aad96f0)
> [  165.440000] Stack : 00000000 00000000 c1049988 000002a0 00000001 8000cda4
> 80330000 c1135ca4
> [  165.440000]         0041ee08 2ac50000 005021a8 00000000 8004d59c 0029e597
> 0041ee08 2ac50000
> [  165.440000]         00000001 c1135ca4 0041ee08 2ac50000 005021a8 8005fc84
> 0029f000 00000002
> [  165.440000]         00408228 00400de0 004f1400 2aad8f08 00408228 00400de0
> 004f1400 2aad8f08
> [  165.440000]         800035f0 800035f0 005021a8 004ff648 004fe008 00000000
> 00401090 00000000
> [  165.440000]         ...
> [  165.440000] Call Trace:
> [  165.440000] [<8000cda4>] do_one_initcall+0x6c/0x204
> [  165.440000] [<8004d59c>] blocking_notifier_call_chain+0x14/0x20
> [  165.440000] [<8005fc84>] sys_init_module+0xe8/0x214
> [  165.440000] [<800035f0>] stack_done+0x20/0x3c
> [  165.440000] [<800035f0>] stack_done+0x20/0x3c
> [  165.440000]
> [  165.440000]
> [  165.440000] Code: 00000000  00000000  00000000 <00003009> 005196a8
>  005196a8  00000002  00000000  005166b0
> [  165.440000] Disabling lock debugging due to kernel taint

But this says kernel taint.

> Segmentation fault
> #

So I'm not 100% sure but I believe "Reserved instruction in kernel
code" means some instruction is trying to be run on your mips board
for which your actual CPU has no support for, which could happen if
you cross compiled code to your target with an incorrect toolchain. At
least that is how someone interpreted this on some old madwifi ticket
when someone ran into this [1]. The failure actually comes from the
mips do_ri() call [2] but cannot confirm whether or not the
interpretation is correct. To confirm you may want to check with the
linux-mips list.

[1] http://madwifi-project.org/ticket/994
[2] http://lxr.linux.no/#linux+v2.6.31/arch/mips/kernel/traps.c#L806

  Luis
