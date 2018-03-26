Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:39056 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeCZF4s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:56:48 -0400
Date: Mon, 26 Mar 2018 07:56:43 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] Mainline support for B43_PHY_AC wifi cards
Message-ID: <20180326055643.GD5942@localhost.localdomain> (sfid-20180326_075705_854962_4A5C5CD7)
References: <20180323094740.GA5942@localhost.localdomain>
 <CACna6rx-QNQhVNkwFSabwAY9vM1qV_gTcWywsHFuP5B4NH4NXA@mail.gmail.com>
 <20180323140919.GB5942@localhost.localdomain>
 <CACna6rwk04dn2oVYsQMhmzvRTmuDv8_AKPK7+kBwbjB_CLRALg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwk04dn2oVYsQMhmzvRTmuDv8_AKPK7+kBwbjB_CLRALg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/03/18 00:01, Rafał Miłecki wrote:
> On 23 March 2018 at 15:09, Juri Lelli <juri.lelli@gmail.com> wrote:
> > On 23/03/18 14:43, Rafał Miłecki wrote:
> >> Hi,
> >>
> >> On 23 March 2018 at 10:47, Juri Lelli <juri.lelli@gmail.com> wrote:
> >> > I've got a Dell XPS 13 9343/0TM99H (BIOS A15 01/23/2018) mounting a
> >> > BCM4352 802.11ac (rev 03) wireless card and so far I've been using it on
> >> > Fedora with broadcom-wl package (which I believe installs Broadcom's STA
> >> > driver?). It works good apart from occasional hiccups after suspend.
> >> >
> >> > I'd like to get rid of that dependency (you can understand that it's
> >> > particularly annoying when testing mainline kernels), but I found out
> >> > that support for my card is BROKEN in mainline [1]. Just to see what
> >> > happens, I forcibly enabled it witnessing that it indeed crashes like
> >> > below as Kconfig warns. :)
> >> >
> >> >  bcma: bus0: Found chip with id 0x4352, rev 0x03 and package 0x00
> >> >  bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2B, class 0x0)
> >> >  bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2A, class 0x0)
> >> >  bcma: bus0: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x02, class 0x0)
> >> >  bcma: bus0: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x01, class 0x0)
> >> >  bcma: bus0: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x11, class 0x0)
> >> >  bcma: Unsupported SPROM revision: 11
> >> >  bcma: bus0: Invalid SPROM read from the PCIe card, trying to use fallback SPROM
> >> >  bcma: bus0: Using fallback SPROM failed (err -2)
> >> >  bcma: bus0: No SPROM available
> >> >  bcma: bus0: Bus registered
> >> >  b43-phy0: Broadcom 4352 WLAN found (core revision 42)
> >> >  b43-phy0: Found PHY: Analog 12, Type 11 (AC), Revision 1
> >> >  b43-phy0: Found Radio: Manuf 0x17F, ID 0x2069, Revision 4, Version 0
> >> >  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> >>
> >> This isn't really useful without a full backtrace.
> >
> > Sure. I cut it here because I didn't expect people to debug what is
> > already known to be broken (but still it seemed to carry useful
> > information about the hw). :)
> 
> Please paste the remaining part if you still got it.

Sure, please find it below.

Thanks!

- Juri

--->8---

[   60.732180] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   60.733048] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   60.733303] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   60.733305] cfg80211: failed to load regulatory.db
[   61.047277] bcma: bus0: Found chip with id 0x4352, rev 0x03 and package 0x00
[   61.047302] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2B, class 0x0)
[   61.047316] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2A, class 0x0)
[   61.047340] bcma: bus0: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x02, class 0x0)
[   61.047366] bcma: bus0: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x01, class 0x0)
[   61.047380] bcma: bus0: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x11, class 0x0)
[   61.107321] bcma: Unsupported SPROM revision: 11
[   61.107325] bcma: bus0: Invalid SPROM read from the PCIe card, trying to use fallback SPROM
[   61.107326] bcma: bus0: Using fallback SPROM failed (err -2)
[   61.107327] bcma: bus0: No SPROM available
[   61.109830] bcma: bus0: Bus registered
[   61.242068] b43-phy0: Broadcom 4352 WLAN found (core revision 42)
[   61.242481] b43-phy0: Found PHY: Analog 12, Type 11 (AC), Revision 1
[   61.242487] b43-phy0: Found Radio: Manuf 0x17F, ID 0x2069, Revision 4, Version 0
[   61.242909] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   61.242916] IP:           (null)
[   61.242919] PGD 0 P4D 0 
[   61.242924] Oops: 0010 [#1] PREEMPT SMP PTI
[   61.242926] Modules linked in: b43(+) bcma mac80211 cfg80211 ssb mmc_core rfcomm fuse nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables cmac bnep sunrpc intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel btusb snd_hda_codec uvcvideo btrtl btbcm btintel snd_hda_core bluetooth snd_hwdep videobuf2_vmalloc snd_seq
[   61.242989]  videobuf2_memops videobuf2_v4l2 iTCO_wdt snd_seq_device snd_pcm videobuf2_common iTCO_vendor_support dell_laptop dell_wmi irqbypass videodev wmi_bmof sparse_keymap dell_smbios intel_cstate dell_wmi_descriptor intel_uncore dcdbas ecdh_generic snd_timer intel_rapl_perf snd rfkill mei_me media pcspkr mei i2c_i801 shpchp joydev tpm_crb soundcore intel_pch_thermal processor_thermal_device lpc_ich tpm_tis intel_soc_dts_iosf wmi tpm_tis_core tpm int3403_thermal dw_dmac int3402_thermal int3400_thermal int340x_thermal_zone acpi_pad acpi_thermal_rel dm_crypt i915 i2c_algo_bit drm_kms_helper drm hid_multitouch crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw video i2c_hid
[   61.243044] CPU: 1 PID: 2410 Comm: modprobe Not tainted 4.16.0-rc6+ #2
[   61.243046] Hardware name: Dell Inc. XPS 13 9343/0TM99H, BIOS A15 01/23/2018
[   61.243049] RIP: 0010:          (null)
[   61.243051] RSP: 0018:ffffaaa6c2afbaf0 EFLAGS: 00010282
[   61.243054] RAX: 0000000000000000 RBX: ffff908d0b3c4800 RCX: ffff908d0b3c2800
[   61.243057] RDX: ffff908d0b3c2800 RSI: 0000000000000001 RDI: ffff908d0b3c4800
[   61.243059] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[   61.243061] R10: 0000000000000000 R11: 000000000000008b R12: 0000000000000001
[   61.243064] R13: ffff908d082b9f00 R14: ffff908d0b3c4800 R15: 0000000000000004
[   61.243067] FS:  00007feb59ec30c0(0000) GS:ffff908d1f480000(0000) knlGS:0000000000000000
[   61.243069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   61.243071] CR2: 0000000000000000 CR3: 000000020caaa002 CR4: 00000000003606e0
[   61.243074] Call Trace:
[   61.243089]  ? b43_wireless_core_reset+0x38/0x230 [b43]
[   61.243099]  ? b43_one_core_attach+0x368/0xd00 [b43]
[   61.243109]  ? b43_bcma_probe+0x54/0xf0 [b43]
[   61.243115]  ? bcma_device_probe+0x31/0x60 [bcma]
[   61.243120]  ? preempt_count_sub+0x9b/0xd0
[   61.243125]  ? driver_probe_device+0x30b/0x480
[   61.243129]  ? __driver_attach+0xb8/0xe0
[   61.243133]  ? driver_probe_device+0x480/0x480
[   61.243136]  ? driver_probe_device+0x480/0x480
[   61.243140]  ? bus_for_each_dev+0x76/0xc0
[   61.243144]  ? bus_add_driver+0x161/0x260
[   61.243147]  ? 0xffffffffc0ab5000
[   61.243151]  ? driver_register+0x57/0xc0
[   61.243154]  ? 0xffffffffc0ab5000
[   61.243163]  ? b43_init+0x24/0x1000 [b43]
[   61.243167]  ? do_one_initcall+0x4e/0x192
[   61.243172]  ? kmem_cache_alloc_trace+0xa1/0x1c0
[   61.243177]  ? do_init_module+0x5b/0x20b
[   61.243180]  ? load_module+0x257b/0x2bb0
[   61.243185]  ? vfs_read+0x113/0x130
[   61.243191]  ? SYSC_finit_module+0xe9/0x110
[   61.243194]  ? SYSC_finit_module+0xe9/0x110
[   61.243200]  ? do_syscall_64+0x79/0x190
[   61.243205]  ? entry_SYSCALL_64_after_hwframe+0x42/0xb7
[   61.243209] Code:  Bad RIP value.
[   61.243217] RIP:           (null) RSP: ffffaaa6c2afbaf0
[   61.243218] CR2: 0000000000000000
[   61.243222] ---[ end trace 3e3c52c383af1049 ]---
