Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:33419 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZCKIPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 04:15:07 -0400
Received: by bwz26 with SMTP id 26so1826083bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 01:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236728344.26432.26.camel@maxim-laptop>
References: <1236728344.26432.26.camel@maxim-laptop>
Date: Wed, 11 Mar 2009 09:15:03 +0100
Message-ID: <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com> (sfid-20090311_091521_818884_EA213322)
Subject: Re: Thanks for TX power patch
From: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 12:39 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> If I unload/reload the ath5k, it seems to work. but at next suspend t=
o
> disk, once =A0system hung, other time it showed many panic, in someth=
ing
> related to page allocator (one even was in page_alloc_pages or so)

I'm getting some Kernel oopses after unloading ath5k with Nick patches.
But I'm still debugging it to find where is the problem.

Here is the log:

Mar 10 19:51:52 joutaro kernel: [ 2299.030740] ath5k 0000:06:00.0: PCI
INT A disabled
Mar 10 19:51:52 joutaro ifdown: Network interface is managed from Netwo=
rkManager
Mar 10 19:51:52 joutaro ifdown: NetworkManager cannot be advised to
take down an interface.
Mar 10 19:51:52 joutaro ifdown: Set up another interface instead.
Mar 10 19:51:52 joutaro ifdown:     wmaster0
Mar 10 19:51:52 joutaro ifdown: Interface not available and no
configuration found.
Mar 10 19:51:52 joutaro kernel: [ 2299.266536] BUG: unable to handle
kernel paging request at 7774d524
Mar 10 19:51:52 joutaro kernel: [ 2299.266543] IP: [<f81cd0bb>]
ext3_htree_store_dirent+0x7b/0xe4 [ext3]
Mar 10 19:51:52 joutaro kernel: [ 2299.266563] *pdpt =3D
0000000028c13001 *pde =3D 0000000000000000
Mar 10 19:51:52 joutaro kernel: [ 2299.266568] Oops: 0000 [#1] SMP
Mar 10 19:51:52 joutaro kernel: [ 2299.266573] last sysfs file:
/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device
:03/PNP0C0A:00/power_supply/BAT0/charge_full
Mar 10 19:51:52 joutaro kernel: [ 2299.266578] Modules linked in:
af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt
_limit i915 drm i2c_algo_bit snd_pcm_oss snd_mixer_oss coretemp
binfmt_misc snd_seq snd_seq_device ip6t_REJECT nf_co
nntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw
iptable_filter ip6table_mangle nf_conntrack_net
bios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
ip6table_filter ip6_tables x_tables ipv6 fuse loop d
m_mod arc4 ecb snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep mac80211 snd_pcm snd_timer led_class vide
o snd i2c_i801 rtc_cmos soundcore iTCO_wdt cfg80211 output pcspkr
intel_agp rtc_core iTCO_vendor_support sr_mod wmi
i2c_core button agpgart sg battery rtc_lib ac cdrom tg3 libphy
snd_page_alloc usbhid hid sd_mod crc_t10dif uhci_hcd
ehci_hcd usbcore edd ext3 mbcache jbd fan ide_pci_generic piix
ide_core ata_generic ata_piix ahci libata scsi_mod th
ermal processor thermal_sys hwmon [last unloaded: ath5k]
Mar 10 19:51:52 joutaro kernel: [ 2299.266660]
Mar 10 19:51:52 joutaro kernel: [ 2299.266664] Pid: 10482, comm:
modprobe Not tainted (2.6.29-rc7-wl-pae-tuliom #8)
eMachines E510
Mar 10 19:51:52 joutaro kernel: [ 2299.266667] EIP: 0060:[<f81cd0bb>]
EFLAGS: 00010202 CPU: 0
Mar 10 19:51:52 joutaro kernel: [ 2299.266681] EIP is at
ext3_htree_store_dirent+0x7b/0xe4 [ext3]
Mar 10 19:51:52 joutaro kernel: [ 2299.266684] EAX: 33bd1312 EBX:
e843620c ECX: 7774d52c EDX: e8436208
Mar 10 19:51:52 joutaro kernel: [ 2299.266686] ESI: e8436200 EDI:
e8436210 EBP: e8cbfe5c ESP: e8cbfe4c
Mar 10 19:51:52 joutaro kernel: [ 2299.266689]  DS: 007b ES: 007b FS:
00d8 GS: 0033 SS: 0068
Mar 10 19:51:52 joutaro kernel: [ 2299.266692] Process modprobe (pid:
10482, ti=3De8cbe000 task=3De9028670 task.ti=3De8cbe
000)
Mar 10 19:51:52 joutaro kernel: [ 2299.266694] Stack:
Mar 10 19:51:52 joutaro kernel: [ 2299.266696]  e91a2a80 f52a50ec
f5925c88 0000000d e8cbfe88 f81d4b7c f52a50ec 00000
000
Mar 10 19:51:52 joutaro kernel: [ 2299.266703]  f585f698 f4d95d40
f52a5ff8 00000000 f4d95d40 f4d95d40 f585f698 e8cbf
ee8
Mar 10 19:51:52 joutaro kernel: [ 2299.266710]  f81d4c15 e8cbfec4
00000000 00000000 00000000 00000000 f4d95d40 f5c25
ec0
Mar 10 19:51:52 joutaro kernel: [ 2299.266717] Call Trace:
Mar 10 19:51:52 joutaro kernel: [ 2299.266725]  [<f81d4b7c>] ?
htree_dirblock_to_tree+0xd6/0x118 [ext3]
Mar 10 19:51:52 joutaro kernel: [ 2299.266744]  [<f81d4c15>] ?
ext3_htree_fill_tree+0x57/0x19e [ext3]
Mar 10 19:51:52 joutaro kernel: [ 2299.266759]  [<c01a1e5d>] ?
nameidata_to_filp+0x2c/0x43
Mar 10 19:51:52 joutaro kernel: [ 2299.266773]  [<f81ccbff>] ?
ext3_readdir+0x17a/0x5bb [ext3]
Mar 10 19:51:52 joutaro kernel: [ 2299.266786]  [<c01ae7f0>] ?
filldir64+0x0/0xcd
Mar 10 19:51:52 joutaro kernel: [ 2299.266792]  [<c01a64d0>] ?
sys_fstat64+0x22/0x28
Mar 10 19:51:52 joutaro kernel: [ 2299.266803]  [<c01aea8f>] ?
vfs_readdir+0x63/0x8f
Mar 10 19:51:52 joutaro kernel: [ 2299.266807]  [<c01ae7f0>] ?
filldir64+0x0/0xcd
Mar 10 19:51:52 joutaro kernel: [ 2299.266810]  [<c01aeb1e>] ?
sys_getdents64+0x63/0xa0
Mar 10 19:51:52 joutaro kernel: [ 2299.266814]  [<c010405b>] ?
sysenter_do_call+0x12/0x2f
Mar 10 19:51:52 joutaro kernel: [ 2299.266819]  [<c013007b>] ?
do_syslog+0x2fc/0x358
Mar 10 19:51:52 joutaro kernel: [ 2299.266824] Code: 1c 8a 42 07 88 43
1d 0f b6 42 06 89 c1 c1 e9 02 f3 a5 89 c1 83
e1 03 74 02 f3 a4 0f b6 42 06 31 d2 8b 7d f0 c6 44 03 1e 00 eb 3c <8b>
41 f8 8d 71 f8 39 03 75 13 8b 43 04 3b 46 04
75 19 8b 46 14
Mar 10 19:51:52 joutaro kernel: [ 2299.266865] EIP: [<f81cd0bb>]
ext3_htree_store_dirent+0x7b/0xe4 [ext3] SS:ESP 006
8:e8cbfe4c
Mar 10 19:51:52 joutaro kernel: [ 2299.266883] ---[ end trace
19566f297b710799 ]---

After this the system hang.

This isn't happening with wireless-testing tree in here.

Best regards,

--=20
Tulio Magno
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
