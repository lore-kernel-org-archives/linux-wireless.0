Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server514c.exghost.com ([72.32.253.76]:2229 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756858Ab2BGWhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 17:37:23 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] rtlwifi: Handle previous allocation failures when freeing device memory
Date: Tue, 7 Feb 2012 16:37:10 -0600
Message-ID: <BC8BC73D12649F439B502B4CB6FD58B1053E2D11@BE23.exg4.exghost.com> (sfid-20120207_233728_073618_104ED303)
In-Reply-To: <4F319DCA.7080507@lwfinger.net>
References: <BC8BC73D12649F439B502B4CB6FD58B1053E2C92@BE23.exg4.exghost.com> <4F319DCA.7080507@lwfinger.net>
From: "Simon Graham" <simon.graham@virtualcomputer.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<chaoming_li@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On 02/07/2012 03:31 PM, Simon Graham wrote:
> > Handle previous allocation failures when freeing device memory
> >
> > Signed-off-by: Simon Graham<simon.graham@virtualcomputer.com>
> > ---
> >   drivers/net/wireless/rtlwifi/pci.c |   24 ++++++++++++++----------
> >   1 files changed, 14 insertions(+), 10 deletions(-)
> >
> 
> NACK. For both TX and RX rings, the memory allocation was checked
> following the
> pci_alloc_consistent() calls in routines _rtl_pci_init_tx_ring() and
> _rtl_pci_init_rx_ring(). Rechecking here is not necessary.
> 
> Larry

Understood -- however, this patch was added when we ran into the
following panic:

 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.532026] BUG: unable to handle
kernel NULL pointer dereference at (null)
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.533642] IP:
[<ffffffff81298ed0>] memset+0x20/0xc0
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.535355] PGD 3b79067 PUD
1a1aa067 PMD 0
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.537054] Oops: 0002 [#1] SMP 
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.538743] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/firmware/0000:03:00.0/
loading
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.540390] CPU 3 
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.540403] Modules linked in:
rtl8192se(+) rtlwifi mac80211 cfg80211 r8169 mii ehci_hcd iscsi_scst
scst_vdisk scst_cdrom scst cryptd aes_x86_64 aes_generic ebtable_filter
ebtables xt_mac xt_tcpudp usb_storage ipt_MASQUERADE xt_state
xt_multiport iptable_filter ipt_REDIRECT libcrc32c iptable_nat nf_nat
crc32c nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
bridge stp microcode snd_hda_codec_hdmi snd_hda_codec_realtek arc4
psmouse snd_hda_intel serio_raw snd_hda_codec intel_ips thinkpad_acpi
snd_hwdep nvram usbbk snd_pcm snd_timer tpm_tis snd soundcore
snd_page_alloc tpm tpm_bios ramzswap xvmalloc i915 drm_kms_helper drm
ahci libahci intel_agp i2c_algo_bit intel_gtt video [last unloaded:
ehci_hcd]
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.550167] 
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.551831] Pid: 21703, comm:
modprobe Tainted: G W 2.6.38-orc #1 LENOVO 0578CTO/0578CTO
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.553607] RIP:
e030:[<ffffffff81298ed0>] [<ffffffff81298ed0>] memset+0x20/0xc0
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.555412] RSP:
e02b:ffff8800057a5b50 EFLAGS: 00010206
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.557152] RAX: 0000000000000000
RBX: 0000000000000000 RCX: 0000000000000200
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.558953] RDX: 0000000000000000
RSI: 0000000000000000 RDI: 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.560715] RBP: ffff8800057a5b98
R08: 0000000000000000 R09: 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.562458] R10: 0000000000000000
R11: 0000000000000001 R12: 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.564198] R13: ffff88000453a090
R14: ffff880001e54408 R15: 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.565950] FS:
00007f58cdc15720(0000) GS:ffff880029fd1000(0000) knlGS:0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.567726] CS: e033 DS: 0000 ES:
0000 CR0: 000000008005003b
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.569517] CR2: 0000000000000000
CR3: 0000000005a0c000 CR4: 0000000000002660
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.571122] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.572653] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.574172] Process modprobe
(pid: 21703, threadinfo ffff8800057a4000, task ffff880022ea5ac0)
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.575680] Stack: 
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.577249] ffffffff81006065
0000000000000000 0000000000000000 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.578983] 0000000000000000
0000000000000000 0000000000000000 0000000000000000
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.580734] ffff88000453a090
ffff8800057a5bb8 ffffffff81331f42 0000000000000800
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.582382] Call Trace: 
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.584178] [<ffffffff81006065>]
? xen_destroy_contiguous_region+0x45/0x130
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.585921] [<ffffffff81331f42>]
xen_swiotlb_free_coherent+0x32/0x50
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.587666] [<ffffffffa02ebb86>]
_rtl_pci_free_rx_ring+0x166/0x1b0 [rtlwifi]
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.589502] [<ffffffffa02efcc9>]
rtl_pci_probe+0x1751/0x1adf [rtlwifi]
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.591257] [<ffffffff8100759d>]
? xen_force_evtchn_callback+0xd/0x10
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.593021] [<ffffffff812b390f>]
local_pci_probe+0x5f/0xd0
 Nov 4 08:38:30 THEDGE-0578 kernel: [37375.594829] [<ffffffff812b51f9>]
pci_device_probe+0x119/0x120
...

Which looks like rtl_pci_probe is calling rtl_pci_free_rx_ring which is
freeing a NULL pointer...

We have not seen this specific crash since adding the change in my
proposed patch.

Simon
