Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728565AbeHMLWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 07:22:42 -0400
Date: Mon, 13 Aug 2018 10:41:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: Cpu stall caused by hostapd running two interfaces
Message-ID: <20180813084123.GA18180@redhat.com> (sfid-20180813_104320_000494_96598250)
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(cc Haim and Johannes)

On Sun, Aug 12, 2018 at 09:54:00PM +0200, Grzegorz Duszyński wrote:
> Hello,
> 
> I'm running into problems while trying to start AP's on 2 interfaces.
> Devices are:
> - Compex WLE900VX (QCA9880)
> - Killer 1535 (QCA6174)
> 
> The 1535 is a new addition to the system.
> Compex by itself runs fine, Killer also can run alone.
> 
> But when running them together all hell breaks lose.
> System is unusable, cannot even reboot.
> 
> I'm running Arch Linux.
> My system was updated before testing & posting.
> 
> Attachments:
> dmesg - https://pastebin.com/wf3Fq8gh
> 
> Please let me know if additional info is required.

This is oops in ieee80211_regulatory_limit_wmm_params().
Looks like new regulatory code do not like ath10k.
I have another bug report with reg.c WARNING also on ath10k:
https://bugzilla.redhat.com/show_bug.cgi?id=1612537

Regards
Stanislaw

[  631.040507] BUG: unable to handle kernel NULL pointer dereference at 0000000000000266
[  631.046313] PGD 0 P4D 0 
[  631.052020] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  631.057782] Modules linked in: veth tun xt_nat xfrm_user xfrm_algo br_netfilter bridge stp llc overlay xt_recent ipt_REJECT nf_reject_ipv4 xt_multiport xt_conntrack xt_hashlimit xt_addrtype xt_mark iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_tcpudp xt_CT iptable_raw xt_NFLOG nfnetlink_log nf_log_ipv4 nf_log_common xt_LOG nf_conntrack_sane nf_conntrack_netlink nfnetlink nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp ts_kmp nf_conntrack_amanda iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c
[  631.096648]  iptable_filter ccm arc4 nls_iso8859_1 nls_cp437 vfat fat snd_hda_codec_hdmi snd_hda_codec_realtek intel_rapl snd_hda_codec_generic intel_telemetry_pltdrv intel_punit_ipc intel_telemetry_core intel_pmc_ipc ofpart cmdlinepart x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel intel_spi_platform intel_spi spi_nor snd_soc_skl mtd ath10k_pci kvm snd_soc_skl_ipc snd_hda_ext_core snd_soc_sst_dsp irqbypass ath10k_core crct10dif_pclmul crc32_pclmul snd_soc_sst_ipc ghash_clmulni_intel ath snd_soc_acpi i915 pcbc btusb snd_soc_core btrtl btbcm btintel mac80211 bluetooth snd_compress ac97_bus aesni_intel snd_pcm_dmaengine aes_x86_64 crypto_simd cryptd glue_helper intel_cstate intel_rapl_perf snd_hda_intel wdat_wdt pcspkr i2c_algo_bit snd_hda_codec drm_kms_helper cfg80211 joydev snd_hda_core
[  631.140625]  huawei_cdc_ncm drm ecdh_generic cdc_wdm snd_hwdep input_leds cdc_ncm option snd_pcm usbnet led_class usb_wwan usbserial r8169 i2c_i801 intel_gtt lpc_ich snd_timer agpgart mei_me mii syscopyarea rfkill snd sysfillrect sysimgblt mei tpm_crb fb_sys_fops soundcore shpchp evdev tpm_tis rtc_cmos mac_hid tpm_tis_core tpm rng_core pcc_cpufreq ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 fscrypto raid1 md_mod hid_generic sd_mod usbhid hid ahci xhci_pci libahci crc32c_intel xhci_hcd libata usbcore usb_common scsi_mod
[  631.173368] CPU: 2 PID: 1659 Comm: hostapd Not tainted 4.17.14-arch1-1-ARCH #1
[  631.181686] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./J4205-ITX, BIOS P1.40 07/14/2017
[  631.190151] RIP: 0010:ieee80211_regulatory_limit_wmm_params.part.8+0x6e/0xd0 [mac80211]
[  631.198537] RSP: 0018:ffffa670c06b7a10 EFLAGS: 00010246
[  631.206951] RAX: 0000000000000246 RBX: ffffa670c06b7a36 RCX: 0000000000256a20
[  631.215397] RDX: 0000000000000266 RSI: 0000000000259130 RDI: ffff93f2ea999420
[  631.223789] RBP: 0000000000000000 R08: ffffffffc0872d40 R09: ffffa670c06b7aa0
[  631.232170] R10: ffff93f2e20c9940 R11: 000000000000002c R12: ffff93f2e735a8c0
[  631.240515] R13: ffff93f2e735a8c0 R14: ffff93f2e6940760 R15: ffff93f2e735a8d0
[  631.248931] FS:  00007f91c0890ec0(0000) GS:ffff93f2e2b00000(0000) knlGS:0000000000000000
[  631.257350] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  631.265741] CR2: 0000000000000266 CR3: 000000006669c000 CR4: 00000000003406e0
[  631.274206] Call Trace:
[  631.282665]  ieee80211_set_txq_params+0x93/0x140 [mac80211]
[  631.291141]  nl80211_set_wiphy+0x271/0x9c0 [cfg80211]
[  631.299551]  genl_family_rcv_msg+0x1c4/0x3a0
[  631.307888]  genl_rcv_msg+0x47/0x90
[  631.316201]  ? __kmalloc_node_track_caller+0x210/0x2b0
[  631.324462]  ? genl_family_rcv_msg+0x3a0/0x3a0
[  631.332669]  netlink_rcv_skb+0x4c/0x120
[  631.340889]  genl_rcv+0x24/0x40
[  631.349135]  netlink_unicast+0x196/0x240
[  631.357389]  netlink_sendmsg+0x1fd/0x3c0
[  631.365640]  sock_sendmsg+0x33/0x40
[  631.373796]  ___sys_sendmsg+0x295/0x2f0
[  631.381881]  ? netlink_sendmsg+0x20a/0x3c0
[  631.389811]  ? sock_sendmsg+0x33/0x40
[  631.397587]  ? __sys_sendto+0xee/0x160
[  631.405264]  __sys_sendmsg+0x57/0xa0
[  631.412818]  do_syscall_64+0x5b/0x170
[  631.420318]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  631.427735] RIP: 0033:0x7f91c09b4cd8
[  631.435071] RSP: 002b:00007ffdfe18c308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  631.442503] RAX: ffffffffffffffda RBX: 000055630086ef70 RCX: 00007f91c09b4cd8
[  631.449867] RDX: 0000000000000000 RSI: 00007ffdfe18c340 RDI: 0000000000000005
[  631.457106] RBP: 000055630087a1c0 R08: 0000000000000000 R09: 00007f91c0a77010
[  631.464229] R10: 000055630086b010 R11: 0000000000000246 R12: 000055630086ee80
[  631.471243] R13: 00007ffdfe18c340 R14: 0000000000000000 R15: 0000556300881650
[  631.478094] Code: 10 e8 77 18 c3 ff 48 85 c0 74 e2 48 3d 00 f0 ff ff 77 da 48 8b 40 18 48 85 c0 74 d1 41 83 bc 24 d0 0a 00 00 03 48 8d 14 e8 74 58 <0f> b7 02 66 39 43 02 66 0f 43 43 02 66 89 43 02 0f b7 42 02 66 
[  631.492289] RIP: ieee80211_regulatory_limit_wmm_params.part.8+0x6e/0xd0 [mac80211] RSP: ffffa670c06b7a10
[  631.499551] CR2: 0000000000000266
[  631.506799] ---[ end trace 5ef2ee76a2e2185c ]---
