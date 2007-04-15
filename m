Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33369 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751255AbXDOS44 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 14:56:56 -0400
Date: Sun, 15 Apr 2007 20:56:19 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Guido Guenther <agx@sigxcpu.org>, Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [at76_usb] kernel panic in update_wstats()
Message-ID: <20070415205619.6747d9ed@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using the at76c503a driver (0.14beta1, but it looks almost identical
to a76c503a git) on Linux 2.6.18.

I got the following kernel panic while using an AT76C503A card with
firmware version 1.101.2 #84 (fcs_len 4). This happens almost immediately
under heavy load in ad-hoc mode. It never happened when using the device on
another box which had an OHCI USB controller, and I'm currently using an
UHCI controller (but I wouldn't say this is related by any means). 

I tried to comment out the whole update_wstats() function, and the kernel
doesn't panic anymore.

BTW: is there any related development mailing list or IRC channel? I could
be interested in development, in future.

Here comes the panic message (I just copied the relevant information by
hand, as I didn't set up netconsole, but I can do that if needed):


PREEMPT
Modules linked in: orinoco_cs orinoco hermes apm at76_usb snd_pcm_oss
snd_mixer_oss xt_tcpudp ipt_MASQUERADE iptable_nat ip_nat ip_conntrack
ip_tables x_tables ohci_hcd parport_pc parport crc_ccitt pcspkr pcmcia
yenta_socket rsrc_nonstatic pcmcia_core ide_scsi scsi_mod CPU:	0
EIP	0060:[<c2ff61c3>]	Not tainted VLI
EFLAGS:	0010246	(2.6.18 #4)
EIP is at update_wstats+0x83/0xc0 [at76_usb]
Call Trace:
 rx_mgmt+0x9e/0x1180 [at76_usb]
 hcd_submit_urb+0x1c5/0x910
 rx_tasklet+0x247/0x1660 [at76_usb]
 uhci_free_urb_priv+0x6e/0xb0
 uhci_unlink_qh+0x66/0xd0
 usb_free_urb+0x1c/0x20
 uhci_giveback_urb+0xd0/0x1e0
 kfree_skbmem+0x42/0xa0
 at76c503_tx+0x404/0x590 [at76_usb]
 __qdisc_run+0x78/0x1f0
 tasklet_action+0x3e/0x70
 __do_softirq+0x42/0x90
 do_softirq+0x26/0x30
 irq_exit+0x35/0x40
 do_IRQ+0x36/0x70
 do_setitimer+0x52a/0x570
 common_interrupt+0x1a/0x20
 sys_select+0x3/0x1c0
 sys_sigreturn+0xaf/0xc8
 syscall_call+0x7/0xb
EIP: [<c2ff61c3>] update_wstats+0x83/0xc0 [at76_usb] SS:ESP 0068:c0ba9d54
  <0>Kernel panic - not syncing: Fatal exception in interrupt


-- 
Ciao
Stefano
