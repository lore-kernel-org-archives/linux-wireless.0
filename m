Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43990 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbeHRBzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 21:55:03 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 008B040A30A
        for <linux-wireless@vger.kernel.org>; Fri, 17 Aug 2018 15:49:45 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Crash in stock Fedora 4.17 kernel in ieee80211_set_wmm_default
Message-ID: <e47ddecd-1346-4581-5e47-5ff2432d34ad@candelatech.com> (sfid-20180818_004954_097509_510FFA02)
Date: Fri, 17 Aug 2018 15:49:45 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been running some tests on un-modified Fedora 27, with a stock QCA firmware-2.bin.

[root@lf0350-0a0e ~]# uname -a
Linux lf0350-0a0e 4.17.14-102.fc27.x86_64 #1 SMP Wed Aug 15 12:26:40 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

[root@lf0350-0a0e network-scripts]# ethtool -i wlp5s0
driver: ath10k_pci
version: 4.17.14-102.fc27.x86_64
firmware-version: 10.1.467.3-1
expansion-rom-version:
bus-info: 0000:05:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

[root@lf0350-0a0e network-scripts]# cat /root/run_sup.sh
#!/bin/bash

WLAN=wlp5s0
CONF=/root/bagel.conf

wpa_supplicant -g /var/run/wpa_supplicant_if_wiphy1 -B -P /tmp/wpa_supplicant-wiphy1.pid -t -f /tmp/wpa_supplicant_log_wiphy1.txt -dd -K -Dnl80211 -i $WLAN -c $CONF


# cat /root/bagel.conf
ctrl_interface=/var/run/wpa_supplicant
fast_reauth=1
p2p_disabled=1
bss_max_count=2000

network={
     ssid="HOME-C9EC-2.4"

     proto=RSN
     key_mgmt=WPA-PSK WPA-PSK-SHA256
     psk="XXXXXXXXXXXXXXXXXXX"
     #psk=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     pairwise=TKIP CCMP
     group=TKIP CCMP
     proactive_key_caching=0

}



The kernel reliably crashes when I start up supplicant with the script above.

Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: authenticate with ec:aa:a0:f6:e3:98
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: send auth to ec:aa:a0:f6:e3:98 (try 1/3)
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: authenticated
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: associate with ec:aa:a0:f6:e3:98 (try 1/3)
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: RX AssocResp from ec:aa:a0:f6:e3:98 (capab=0x431 status=0 aid=1)
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: associated
Aug 17 15:37:28 lf0350-0a0e wpa_supplicant[974]: wlp5s0: No network configuration found for the current AP
Aug 17 15:37:28 lf0350-0a0e kernel: wlp5s0: deauthenticating from ec:aa:a0:f6:e3:98 by local choice (Reason: 3=DEAUTH_LEAVING)
Aug 17 15:37:28 lf0350-0a0e kernel: general protection fault: 0000 [#1] SMP NOPTI
Aug 17 15:37:28 lf0350-0a0e kernel: Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge 
stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables arc4 sunrpc ath10k_pci 
ath10k_core mac80211 amd64_edac_mod edac_mce_amd kvm_amd kvm ath irqbypass crct10dif_pclmul crc32_pclmul sdhci_pci cfg80211 leds_apu ghash_clmulni_intel cqhci 
sdhci igb fam15h_power sp5100_tco mmc_core i2c_piix4 k10temp rfkill i2c_algo_bit dca ccp shpchp pcc_cpufreq acpi_cpufreq crc32c_intel
Aug 17 15:37:28 lf0350-0a0e kernel: CPU: 3 PID: 974 Comm: wpa_supplicant Not tainted 4.17.14-102.fc27.x86_64 #1
Aug 17 15:37:28 lf0350-0a0e kernel: Hardware name: PC Engines APU2/APU2, BIOS 4.0.7 02/28/2017
Aug 17 15:37:28 lf0350-0a0e kernel: RIP: 0010:ieee80211_regulatory_limit_wmm_params.part.19+0x63/0xe0 [mac80211]
Aug 17 15:37:28 lf0350-0a0e kernel: RSP: 0018:ffff9d7fc1177940 EFLAGS: 00010297
Aug 17 15:37:28 lf0350-0a0e kernel: RAX: 2c5ff8c7f2828f00 RBX: ffff8bf9983ee8c0 RCX: 2c5ff8c7f2828f00
Aug 17 15:37:28 lf0350-0a0e kernel: RDX: 000000000025b840 RSI: 0000000000259130 RDI: ffff8bf997fa5020
Aug 17 15:37:28 lf0350-0a0e kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
Aug 17 15:37:28 lf0350-0a0e kernel: R10: 000000000000001f R11: 00000000000003ff R12: ffff9d7fc117797e
Aug 17 15:37:28 lf0350-0a0e kernel: R13: ffff8bf9983ee8c0 R14: 0000000000000000 R15: ffff8bf996a50760
Aug 17 15:37:28 lf0350-0a0e kernel: FS:  00007f8bc46f8300(0000) GS:ffff8bf99ed80000(0000) knlGS:0000000000000000
Aug 17 15:37:28 lf0350-0a0e kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 17 15:37:28 lf0350-0a0e kernel: CR2: 000055efb3ce6728 CR3: 0000000102666000 CR4: 00000000000406e0
Aug 17 15:37:28 lf0350-0a0e kernel: Call Trace:
Aug 17 15:37:28 lf0350-0a0e kernel:  ieee80211_set_wmm_default+0x2f7/0x3a0 [mac80211]
Aug 17 15:37:28 lf0350-0a0e kernel:  ieee80211_set_disassoc+0x21b/0x5b0 [mac80211]
Aug 17 15:37:28 lf0350-0a0e kernel:  ? avtab_search_node+0xb1/0x100
Aug 17 15:37:28 lf0350-0a0e kernel:  ieee80211_mgd_deauth+0x113/0x230 [mac80211]
Aug 17 15:37:28 lf0350-0a0e kernel:  cfg80211_mlme_deauth+0xaf/0x1c0 [cfg80211]
Aug 17 15:37:28 lf0350-0a0e kernel:  ? startup_64+0x3/0x30
Aug 17 15:37:28 lf0350-0a0e kernel:  nl80211_deauthenticate+0x11f/0x160 [cfg80211]
Aug 17 15:37:28 lf0350-0a0e kernel:  genl_family_rcv_msg+0x1e4/0x390
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to+0x16f/0x4c0
Aug 17 15:37:28 lf0350-0a0e kernel:  genl_rcv_msg+0x47/0x90
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __kmalloc_node_track_caller+0x1f9/0x2a0
Aug 17 15:37:28 lf0350-0a0e kernel:  ? genl_family_rcv_msg+0x390/0x390
Aug 17 15:37:28 lf0350-0a0e kernel:  netlink_rcv_skb+0x4d/0x130
Aug 17 15:37:28 lf0350-0a0e kernel:  genl_rcv+0x24/0x40
Aug 17 15:37:28 lf0350-0a0e kernel:  netlink_unicast+0x1a3/0x250
Aug 17 15:37:28 lf0350-0a0e kernel:  netlink_sendmsg+0x2c1/0x3c0
Aug 17 15:37:28 lf0350-0a0e kernel:  sock_sendmsg+0x36/0x40
Aug 17 15:37:28 lf0350-0a0e kernel:  ___sys_sendmsg+0x2a0/0x2f0
Aug 17 15:37:28 lf0350-0a0e kernel:  ? unix_dgram_sendmsg+0x35e/0x6f0
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x34/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to+0x16f/0x4c0
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __switch_to_asm+0x40/0x70
Aug 17 15:37:28 lf0350-0a0e kernel:  ? __sys_sendmsg+0x5e/0xa0
Aug 17 15:37:28 lf0350-0a0e kernel:  __sys_sendmsg+0x5e/0xa0
Aug 17 15:37:28 lf0350-0a0e kernel:  do_syscall_64+0x5b/0x160
Aug 17 15:37:28 lf0350-0a0e kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Aug 17 15:37:28 lf0350-0a0e kernel: RIP: 0033:0x7f8bc2e40387
Aug 17 15:37:28 lf0350-0a0e kernel: RSP: 002b:00007ffe48b99778 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
Aug 17 15:37:28 lf0350-0a0e kernel: RAX: ffffffffffffffda RBX: 0000555c886749a0 RCX: 00007f8bc2e40387
Aug 17 15:37:28 lf0350-0a0e kernel: RDX: 0000000000000000 RSI: 00007ffe48b997b0 RDI: 0000000000000007
Aug 17 15:37:28 lf0350-0a0e kernel: RBP: 0000555c886cdc20 R08: 0000000000000000 R09: 000000000000000d
Aug 17 15:37:28 lf0350-0a0e kernel: R10: 0000555c8866a010 R11: 0000000000000246 R12: 0000555c886748b0
Aug 17 15:37:28 lf0350-0a0e kernel: R13: 00007ffe48b997b0 R14: 0000000000000000 R15: 00007ffe48b99b80
Aug 17 15:37:28 lf0350-0a0e kernel: Code: 2d ce ff 48 85 c0 74 7a 48 3d 00 f0 ff ff 77 72 48 8b 40 18 48 85 c0 74 69 83 bb d0 0a 00 00 03 48 8d 0c e8 75 05 48 
8d 4c e8 20 <0f> b7 01 41 0f b7 7c 24 02 41 0f b7 14 24 66 39 c7 0f 47 c7 41
Aug 17 15:37:28 lf0350-0a0e kernel: RIP: ieee80211_regulatory_limit_wmm_params.part.19+0x63/0xe0 [mac80211] RSP: ffff9d7fc1177940
Aug 17 15:37:28 lf0350-0a0e kernel: ---[ end trace 28cadc83f715e641 ]---

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
