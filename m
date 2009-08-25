Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:27773 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbZHYW6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 18:58:14 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1809888qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 15:58:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 15:58:14 -0700
Message-ID: <8f3763990908251558h10c16a90h1d4b8f1aa6ff8d7a@mail.gmail.com>
Subject: some improvement over yesterday net/wireless/sme.c:617
	__cfg80211_disconnected+0x20c/0x220 [cfg80211]
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.31-rc7-33384-g4f9ed9c
master-2009-08-25

Much better than yesterday: only one double trace every 30 minutes.
Also: connection at higher rate, more stable. Thanks Johannes, Jouni.

Best regards, Felix

ath9k: Set HW Key
ath9k: Set HW Key
wlan0: deauthenticated from 00:0b:85:6f:12:a3 (Reason: 4)
ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max:
15, txop: 94
ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max:
1023, txop: 0
ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max:
1023, txop: 0
ath9k: BSS Changed PREAMBLE 0
ath9k: BSS Changed CTS PROT 0
ath9k: BSS Changed ASSOC 0
ath9k: Bss Info DISASSOC
ath9k: Set HW Key
wlan0: deauthenticating by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220
[cfg80211]()
Hardware name: 1875DLU
deauth failed: -67
Modules linked in: aes_i586 aes_generic xt_time xt_connlimit xt_realm
iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP
ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss
xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length
xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack
xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle
nfnetlink iptable_filter ip_tables x_tables af_packet bridge stp llc
bnep sco snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq arc4 snd_seq_device snd_pcm_oss
ecb ath9k snd_pcm snd_timer snd_mixer_oss mac80211 snd soundcore tg3
sg libphy snd_page_alloc i2c_i801 iTCO_wdt iTCO_vendor_support sr_mod
ath cfg80211 pcspkr rfcomm l2cap bluetooth ipv6 i915 drm i2c_algo_bit
i2c_core binfmt_misc yenta_socket rsrc_nonstatic pcmcia_core fuse
cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
freq_table ehci_hcd uhci_hcd usbcore joydev evdev processor intel_agp
video output thinkpad_acpi rfkill led_class nvram nsc_ircc irda button
ac battery rtc_cmos crc_ccitt agpgart thermal ata_generic
ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata
sd_mod scsi_mod crc_t10dif ext3 jbd
Pid: 2332, comm: phy0 Tainted: G        W
2.6.31-rc7-wl-mnbStrip-33384-g4f9ed9c #69
Call Trace:
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c55c>] warn_slowpath_common+0x6c/0xc0
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c5f6>] warn_slowpath_fmt+0x26/0x30
 [<f7f261cc>] __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f7f22f21>] ? nl80211_send_deauth+0x21/0x30 [cfg80211]
 [<f7f24164>] __cfg80211_send_deauth+0x224/0x270 [cfg80211]
 [<f85e0270>] ? ieee80211_set_disassoc+0x180/0x1e0 [mac80211]
 [<f7f2420e>] cfg80211_send_deauth+0x5e/0x70 [cfg80211]
 [<f85e1f9b>] ieee80211_sta_work+0xa0b/0x1850 [mac80211]
 [<c01412f8>] ? tasklet_action+0x58/0xc0
 [<c017d9a8>] ? handle_IRQ_event+0x58/0x140
 [<c011bf7e>] ? ack_apic_level+0x7e/0x270
 [<c01300c0>] ? rq_online_rt+0x0/0x70
 [<c0138795>] ? dequeue_task_fair+0x295/0x2a0
 [<c010256a>] ? __switch_to+0xba/0x1a0
 [<c01332e6>] ? finish_task_switch+0x56/0xc0
 [<c03a9bf4>] ? schedule+0x4a4/0xa50
 [<c015379a>] ? prepare_to_wait+0x3a/0x70
 [<c014edf1>] worker_thread+0x141/0x210
 [<f85e1590>] ? ieee80211_sta_work+0x0/0x1850 [mac80211]
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c014ecb0>] ? worker_thread+0x0/0x210
 [<c01531fc>] kthread+0x7c/0x90
 [<c0153180>] ? kthread+0x0/0x90
 [<c0104657>] kernel_thread_helper+0x7/0x10
---[ end trace 31f58961567d44d1 ]---
wlan0: deauthenticating by local choice (reason=3)
------------[ cut here ]------------
WARNING: at net/wireless/sme.c:617 __cfg80211_disconnected+0x20c/0x220
[cfg80211]()
Hardware name: 1875DLU
deauth failed: -67
Modules linked in: aes_i586 aes_generic xt_time xt_connlimit xt_realm
iptable_raw xt_comment ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP
ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss
xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length
xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack
xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle
nfnetlink iptable_filter ip_tables x_tables af_packet bridge stp llc
bnep sco snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq arc4 snd_seq_device snd_pcm_oss
ecb ath9k snd_pcm snd_timer snd_mixer_oss mac80211 snd soundcore tg3
sg libphy snd_page_alloc i2c_i801 iTCO_wdt iTCO_vendor_support sr_mod
ath cfg80211 pcspkr rfcomm l2cap bluetooth ipv6 i915 drm i2c_algo_bit
i2c_core binfmt_misc yenta_socket rsrc_nonstatic pcmcia_core fuse
cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
freq_table ehci_hcd uhci_hcd usbcore joydev evdev processor intel_agp
video output thinkpad_acpi rfkill led_class nvram nsc_ircc irda button
ac battery rtc_cmos crc_ccitt agpgart thermal ata_generic
ide_pci_generic ide_gd_mod ide_core pata_acpi ata_piix ahci libata
sd_mod scsi_mod crc_t10dif ext3 jbd
Pid: 2332, comm: phy0 Tainted: G        W
2.6.31-rc7-wl-mnbStrip-33384-g4f9ed9c #69
Call Trace:
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c55c>] warn_slowpath_common+0x6c/0xc0
 [<f7f261cc>] ? __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<c013c5f6>] warn_slowpath_fmt+0x26/0x30
 [<f7f261cc>] __cfg80211_disconnected+0x20c/0x220 [cfg80211]
 [<f7f22f21>] ? nl80211_send_deauth+0x21/0x30 [cfg80211]
 [<f7f24164>] __cfg80211_send_deauth+0x224/0x270 [cfg80211]
 [<f85e0270>] ? ieee80211_set_disassoc+0x180/0x1e0 [mac80211]
 [<f7f2420e>] cfg80211_send_deauth+0x5e/0x70 [cfg80211]
 [<f85e1f9b>] ieee80211_sta_work+0xa0b/0x1850 [mac80211]
 [<c01412f8>] ? tasklet_action+0x58/0xc0
 [<c017d9a8>] ? handle_IRQ_event+0x58/0x140
 [<c011bf7e>] ? ack_apic_level+0x7e/0x270
 [<c01300c0>] ? rq_online_rt+0x0/0x70
 [<c0138795>] ? dequeue_task_fair+0x295/0x2a0
 [<c010256a>] ? __switch_to+0xba/0x1a0
 [<c01332e6>] ? finish_task_switch+0x56/0xc0
 [<c03a9bf4>] ? schedule+0x4a4/0xa50
 [<c015379a>] ? prepare_to_wait+0x3a/0x70
 [<c014edf1>] worker_thread+0x141/0x210
 [<f85e1590>] ? ieee80211_sta_work+0x0/0x1850 [mac80211]
 [<c0153550>] ? autoremove_wake_function+0x0/0x50
 [<c014ecb0>] ? worker_thread+0x0/0x210
 [<c01531fc>] kthread+0x7c/0x90
 [<c0153180>] ? kthread+0x0/0x90
 [<c0104657>] kernel_thread_helper+0x7/0x10
---[ end trace 31f58961567d44d2 ]---
ath9k: Set HW Key
ath9k: Set HW RX filter: 0x10
ath9k: Set channel: 2412 MHz
ath9k: tx chmask: 3, rx chmask: 3
ath9k: (5745 MHz) -> (2412 MHz), chanwidth: 0
ath9k: Set channel: 2417 MHz
ath9k: tx chmask: 3, rx chmask: 3
