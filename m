Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.media.mit.edu ([18.85.44.157]:53290 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdJPDhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 23:37:34 -0400
Date: Mon, 16 Oct 2017 14:37:27 +1100
From: James Cameron <quozl@laptop.org>
To: Mario Theodoridis <mario@schmut.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi crash with hostapd
Message-ID: <20171016033727.GB13209@us.netrek.org> (sfid-20171016_053738_291995_6D48EB7A)
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 15, 2017 at 06:21:36PM +0200, Mario Theodoridis wrote:
> Thanks for the pointers, James.
> 
> On 12.10.2017 23:24, James Cameron wrote:
> >There's a good chance this problem has been fixed already.  You
> >are using a v4.4 kernel with many patches applied by Ubuntu.  Here, we
> >are more concerned with the latest kernels, and v4.4 is quite old.
> >
> >Please test some of the later kernels, see
> >https://wiki.ubuntu.com/Kernel/MainlineBuilds
> >
> >In particular, test v4.13 or v4.14-rc4.
> 
> I'm having a hard time with that, because the virtualbox-dkms build fails
> with the 4.13 kernel, and virtualbox unfortunately is essential.

Is virtualbox essential for reproducing the problem, or essential for
your general use?

If the former, then that's interesting.

If the latter, then you might instead test the v4.13 or v14-rc4
kernels for only the problem, and then revert to an older kernel after
testing.

Either way, to use virtualbox-dkms with a later kernel you may be able
to upgrade just the virtualbox packages from a later Ubuntu release.

See https://packages.ubuntu.com/virtualbox-dkms and
https://packages.ubuntu.com/virtualbox for the later versions available.

Purpose of the test can be to help isolate the cause, not only to
solve your problem.

> >If the problem still happens, capture the same information and send it
> >again as a reply.
> >
> >If the problem doesn't happen, then you can either continue to use the
> >new kernel, or find when the problem was fixed; a long but rewarding
> >process.
> >
> >Should the problem have been fixed for v4.10, you might also switch to
> >using the Ubuntu package linux-generic-hwe-16.04.
> >https://wiki.ubuntu.com/Kernel/RollingLTSEnablementStack#hwe-16.04
> 
> The 4.10 kernel readily produced this one
> 
> ------------[ cut here ]------------
> WARNING: CPU: 4 PID: 1617 at /build/linux-hwe-IJy1zi/linux-hwe-4.10.0/drivers/net/wireless/intel/iwlwifi/mvm/tx.c:510
> iwl_mvm_tx_skb_non_sta+0x39a/0x440 [iwlmvm]
> Modules linked in: bnep ccm pci_stub vboxpci(OE) vboxnetadp(OE)
> vboxnetflt(OE) vboxdrv(OE) nf_log_ipv4 nf_log_common xt_LOG xt_tcpudp
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter
> ip_tables x_tables snd_hda_codec_hdmi arc4 iwlmvm mac80211
> snd_hda_codec_realtek snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal
> intel_powerclamp iwlwifi coretemp snd_hda_intel snd_hda_codec kvm_intel
> snd_hda_core snd_hwdep kvm input_leds irqbypass crct10dif_pclmul snd_pcm
> bridge crc32_pclmul joydev stp llc ghash_clmulni_intel snd_seq_midi pcbc
> snd_seq_midi_event snd_rawmidi aesni_intel snd_seq aes_x86_64 crypto_simd
> snd_seq_device glue_helper cfg80211 cryptd snd_timer intel_cstate snd
> intel_rapl_perf soundcore shpchp mei_me hci_uart mei btbcm btqca btintel
> bluetooth intel_lpss_acpi
>  acpi_als mac_hid intel_lpss kfifo_buf tpm_infineon industrialio acpi_pad
> parport_pc ppdev lp parport autofs4 i915 e1000e i2c_algo_bit drm_kms_helper
> syscopyarea sysfillrect sysimgblt fb_sys_fops e100 hid_generic ptp i2c_hid
> ahci mii drm pps_core pinctrl_sunrisepoint libahci usbhid e1000 hid wmi
> video pinctrl_intel fjes
> CPU: 4 PID: 1617 Comm: hostapd Tainted: G           OE 4.10.0-37-generic
> #41~16.04.1-Ubuntu
> Hardware name: Gigabyte Technology Co., Ltd. Z170M-D3H/Z170M-D3H-CF, BIOS
> F20 11/17/2016
> Call Trace:
>  dump_stack+0x63/0x90
>  __warn+0xcb/0xf0
>  warn_slowpath_null+0x1d/0x20
>  iwl_mvm_tx_skb_non_sta+0x39a/0x440 [iwlmvm]
>  iwl_mvm_mac_tx+0x11e/0x1d0 [iwlmvm]
>  ieee80211_tx_frags+0x14b/0x220 [mac80211]
>  __ieee80211_tx+0x81/0x180 [mac80211]
>  ieee80211_tx+0x10f/0x150 [mac80211]
>  ieee80211_xmit+0x9b/0xf0 [mac80211]
>  __ieee80211_tx_skb_tid_band+0x5c/0x70 [mac80211]
>  ieee80211_mgmt_tx+0x42c/0x4a0 [mac80211]
>  cfg80211_mlme_mgmt_tx+0xdc/0x310 [cfg80211]
>  nl80211_tx_mgmt+0x212/0x360 [cfg80211]
>  genl_family_rcv_msg+0x1db/0x3b0
>  ? skb_queue_tail+0x43/0x50
>  genl_rcv_msg+0x59/0xa0
>  ? genl_notify+0x80/0x80
>  netlink_rcv_skb+0xa4/0xc0
>  genl_rcv+0x28/0x40
>  netlink_unicast+0x18c/0x240
>  netlink_sendmsg+0x2fb/0x3a0
>  ? aa_sock_msg_perm+0x61/0x150
>  sock_sendmsg+0x38/0x50
>  ___sys_sendmsg+0x2c2/0x2d0
>  ? sock_sendmsg+0x38/0x50
>  ? SYSC_sendto+0x101/0x190
>  ? __check_object_size+0x108/0x1e3
>  ? _copy_to_user+0x55/0x60
>  __sys_sendmsg+0x54/0x90
>  SyS_sendmsg+0x12/0x20
>  entry_SYSCALL_64_fastpath+0x1e/0xad
> RIP: 0033:0x7fcc38cfe450
> RSP: 002b:00007fffdefc9b18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000563e91285590 RCX: 00007fcc38cfe450
> RDX: 0000000000000000 RSI: 00007fffdefc9ba0 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000563e91283a70
> R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000009 R14: 0000000000000000 R15: 0000000000000000
> 
> ---[ end trace 4d9a544d3976536e ]---

You might also try with later firmware package.
See https://packages.ubuntu.com/linux-firmware

You might also test with booting installation media in live-mode,
ignoring the internal disk.

-- 
James Cameron
http://quozl.netrek.org/
