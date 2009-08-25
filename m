Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34238 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbZHYSad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 14:30:33 -0400
Received: by fxm17 with SMTP id 17so2376027fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 11:30:34 -0700 (PDT)
Subject: net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220
 [cfg80211]
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Date: Tue, 25 Aug 2009 11:21:13 -0700
Message-Id: <1251224473.21096.70.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this seems to get worse with each kernel?
8 traces per hour, one week ago it used to be 2 per hour.

Kernel: 2.6.31-rc7-33384-g4f9ed9c wireless testing
H/W:    Thinkpad T43 1875DLU
Wifi:   klogd: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0

the trace always starts with:
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220 [cfg80211]()

but for bottom lines of the trace I get some variety.

Best regards,
Felix

ath9k: Set HW Key
ath9k: Set HW RX filter: 0x10
ath9k: Set channel: 2412 MHz
ath9k: tx chmask: 3, rx chmask: 3
ath9k: (2462 MHz) -> (2412 MHz), chanwidth: 0
ath9k: Set channel: 2462 MHz
ath9k: tx chmask: 3, rx chmask: 3
ath9k: (2412 MHz) -> (2462 MHz), chanwidth: 0
ath9k: Set HW RX filter: 0x10
wlan0: deauthenticating by local choice (reason=3)
ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
ath9k: BSS Changed PREAMBLE 0
ath9k: BSS Changed CTS PROT 0
ath9k: BSS Changed ASSOC 0
ath9k: Bss Info DISASSOC
ath9k: Set HW Key
wlan0: deauthenticating by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220 [cfg80211]()
Hardware name: 1875DLU
deauth failed: -67
Modules linked in: ath9k mac80211 ath cfg80211 xt_time xt_connlimit xt_realm iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK aes_i586 xt_connmark aes_generic xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables i915 drm i2c_algo_bit af_packet bridge stp llc bnep sco ipv6 rfcomm l2cap bluetooth binfmt_misc loop fuse cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table arc4 snd_intel8x0 ecb snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq joydev nsc_ircc thinkpad_acpi snd_seq_device snd_pcm_oss evdev sg rfkill snd_pcm sr_mod irda snd_timer snd_mixer_oss snd soundcore pcspkr ac tg3 rtc_cmos libphy video output thermal button led_class processor crc_ccitt intel_agp agpgart snd_page_alloc battery yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support nvram i2c_i801 i2c_core ehci_hcd uhci_hcd usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: cfg80211]
Pid: 935, comm: ip Tainted: G        W  2.6.31-rc7-wl-mnbStrip-33384-g4f9ed9c #69
Call Trace:
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c55c>] warn_slowpath_common+0x6c/0xc0
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c5f6>] warn_slowpath_fmt+0x26/0x30
 [<f9db31cc>] __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f9daff21>] ? nl80211_send_deauth+0x21/0x30 [cfg80211]
 [<f9db1164>] __cfg80211_send_deauth+0x224/0x270 [cfg80211]
 [<f9db11eb>] cfg80211_send_deauth+0x3b/0x70 [cfg80211]
 [<f9e96039>] ieee80211_send_deauth_disassoc+0x119/0x140 [mac80211]
 [<f9e9752f>] ieee80211_mgd_deauth+0xdf/0x100 [mac80211]
 [<f9e9cbe6>] ieee80211_deauth+0x16/0x20 [mac80211]
 [<f9db0346>] __cfg80211_mlme_deauth+0xd6/0x110 [cfg80211]
 [<c010256a>] ? __switch_to+0xba/0x1a0
 [<f9db386a>] __cfg80211_disconnect+0x15a/0x1b0 [cfg80211]
 [<f9da2216>] cfg80211_netdev_notifier_call+0xd6/0x370 [cfg80211]
 [<f7eb39c8>] ? packet_notifier+0x18/0x1a0 [af_packet]
 [<c03ae33d>] notifier_call_chain+0x2d/0x70
 [<c01580aa>] raw_notifier_call_chain+0x1a/0x20
 [<c03318f9>] dev_close+0x49/0xb0
 [<c03ac09e>] ? _spin_unlock_bh+0xe/0x10
 [<c032fa4a>] ? dev_set_rx_mode+0x2a/0x40
 [<c03311d1>] dev_change_flags+0x81/0x1a0
 [<c01611c3>] ? tick_dev_program_event+0x33/0xc0
 [<c033a659>] do_setlink+0x1e9/0x360
 [<c0157061>] ? hrtimer_interrupt+0xd1/0x220
 [<c033babe>] rtnl_newlink+0x3fe/0x4c0
 [<c01191d7>] ? smp_apic_timer_interrupt+0x57/0x90
 [<c0328429>] ? __alloc_skb+0x29/0x120
 [<c0324934>] ? sock_rmalloc+0x34/0x90
 [<c033b6c0>] ? rtnl_newlink+0x0/0x4c0
 [<c033b525>] rtnetlink_rcv_msg+0x165/0x200
 [<c033b3c0>] ? rtnetlink_rcv_msg+0x0/0x200
 [<c0349746>] netlink_rcv_skb+0x76/0xa0
 [<c033b3ac>] rtnetlink_rcv+0x1c/0x30
 [<c034948c>] netlink_unicast+0x23c/0x250
 [<c0349f2b>] netlink_sendmsg+0x1db/0x2d0
 [<c0322bea>] sock_sendmsg+0xea/0x110
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c0127c43>] ? kmap_atomic_prot+0x43/0xe0
 [<c026ed95>] ? copy_from_user+0x35/0x130
 [<c032ad40>] ? verify_iovec+0x30/0xb0
 [<c0322d21>] sys_sendmsg+0x111/0x230
 [<c01a26fe>] ? filemap_fault+0x9e/0x3e0
 [<c01a0f11>] ? unlock_page+0x41/0x50
 [<c01b84f8>] ? __do_fault+0x348/0x410
 [<c01b8d7f>] ? handle_mm_fault+0xff/0x6e0
 [<c03234ba>] sys_socketcall+0xca/0x2a0
 [<c03ae147>] ? do_page_fault+0x1d7/0x3a0
 [<c0103ad4>] sysenter_do_call+0x12/0x28
---[ end trace f75e88764968eac0 ]---
wlan0: deauthenticating by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220 [cfg80211]()
Hardware name: 1875DLU
deauth failed: -67
Modules linked in: ath9k mac80211 ath cfg80211 xt_time xt_connlimit xt_realm iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK aes_i586 xt_connmark aes_generic xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables x_tables i915 drm i2c_algo_bit af_packet bridge stp llc bnep sco ipv6 rfcomm l2cap bluetooth binfmt_misc loop fuse cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table arc4 snd_intel8x0 ecb snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq joydev nsc_ircc thinkpad_acpi snd_seq_device snd_pcm_oss evdev sg rfkill snd_pcm sr_mod irda snd_timer snd_mixer_oss snd soundcore pcspkr ac tg3 rtc_cmos libphy video output thermal button led_class processor crc_ccitt intel_agp agpgart snd_page_alloc battery yenta_socket rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support nvram i2c_i801 i2c_core ehci_hcd uhci_hcd usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod crc_t10dif ext3 jbd [last unloaded: cfg80211]
Pid: 935, comm: ip Tainted: G        W  2.6.31-rc7-wl-mnbStrip-33384-g4f9ed9c #69
Call Trace:
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c55c>] warn_slowpath_common+0x6c/0xc0
 [<f9db31cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c5f6>] warn_slowpath_fmt+0x26/0x30
 [<f9db31cc>] __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f9daff21>] ? nl80211_send_deauth+0x21/0x30 [cfg80211]
 [<f9db1164>] __cfg80211_send_deauth+0x224/0x270 [cfg80211]
 [<f9db11eb>] cfg80211_send_deauth+0x3b/0x70 [cfg80211]
 [<f9e96039>] ieee80211_send_deauth_disassoc+0x119/0x140 [mac80211]
 [<f9e9752f>] ieee80211_mgd_deauth+0xdf/0x100 [mac80211]
 [<f9e9cbe6>] ieee80211_deauth+0x16/0x20 [mac80211]
 [<f9db0346>] __cfg80211_mlme_deauth+0xd6/0x110 [cfg80211]
 [<c010256a>] ? __switch_to+0xba/0x1a0
 [<f9db386a>] __cfg80211_disconnect+0x15a/0x1b0 [cfg80211]
 [<f9da2216>] cfg80211_netdev_notifier_call+0xd6/0x370 [cfg80211]
 [<f7eb39c8>] ? packet_notifier+0x18/0x1a0 [af_packet]
 [<c03ae33d>] notifier_call_chain+0x2d/0x70
 [<c01580aa>] raw_notifier_call_chain+0x1a/0x20
 [<c03318f9>] dev_close+0x49/0xb0
 [<c03ac09e>] ? _spin_unlock_bh+0xe/0x10
 [<c032fa4a>] ? dev_set_rx_mode+0x2a/0x40
 [<c03311d1>] dev_change_flags+0x81/0x1a0
 [<c01611c3>] ? tick_dev_program_event+0x33/0xc0
 [<c033a659>] do_setlink+0x1e9/0x360
 [<c0157061>] ? hrtimer_interrupt+0xd1/0x220
 [<c033babe>] rtnl_newlink+0x3fe/0x4c0
 [<c01191d7>] ? smp_apic_timer_interrupt+0x57/0x90
 [<c0328429>] ? __alloc_skb+0x29/0x120
 [<c0324934>] ? sock_rmalloc+0x34/0x90
 [<c033b6c0>] ? rtnl_newlink+0x0/0x4c0
 [<c033b525>] rtnetlink_rcv_msg+0x165/0x200
 [<c033b3c0>] ? rtnetlink_rcv_msg+0x0/0x200
 [<c0349746>] netlink_rcv_skb+0x76/0xa0
 [<c033b3ac>] rtnetlink_rcv+0x1c/0x30
 [<c034948c>] netlink_unicast+0x23c/0x250
 [<c0349f2b>] netlink_sendmsg+0x1db/0x2d0
 [<c0322bea>] sock_sendmsg+0xea/0x110
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c0127c43>] ? kmap_atomic_prot+0x43/0xe0
 [<c026ed95>] ? copy_from_user+0x35/0x130
 [<c032ad40>] ? verify_iovec+0x30/0xb0
 [<c0322d21>] sys_sendmsg+0x111/0x230
 [<c01a26fe>] ? filemap_fault+0x9e/0x3e0
 [<c01a0f11>] ? unlock_page+0x41/0x50
 [<c01b84f8>] ? __do_fault+0x348/0x410
 [<c01b8d7f>] ? handle_mm_fault+0xff/0x6e0
 [<c03234ba>] sys_socketcall+0xca/0x2a0
 [<c03ae147>] ? do_page_fault+0x1d7/0x3a0
 [<c0103ad4>] sysenter_do_call+0x12/0x28
---[ end trace f75e88764968eac1 ]---
wlan0: deauthenticating by local choice (reason=3)
wlan0: deauthenticating by local choice (reason=3)
ath9k: Set HW RX filter: 0x10
ath9k: Set HW RX filter: 0x0
ath9k: Set HW Key
ath9k: Detach Interface
ath9k: Driver halt
ath9k: Starting driver with initial channel: 2462 MHz
ath9k: Attach a VIF of type: 2
ath9k: BSS Changed PREAMBLE 0
ath9k: BSS Changed CTS PROT 0
ath9k: Set channel: 2462 MHz
ath9k: tx chmask: 1, rx chmask: 1
ath9k: (2462 MHz) -> (2462 MHz), chanwidth: 0
ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
ath9k: Set HW RX filter: 0x0
ath9k: Set HW RX filter: 0x0
wlan0: direct probe to AP 00:0b:85:6f:20:8c (try 1)
ath9k: Set HW RX filter: 0x0
wlan0 direct probe responded
wlan0: authenticate with AP 00:0b:85:6f:20:8c (try 1)
cfg80211: Calling CRDA for country: US


