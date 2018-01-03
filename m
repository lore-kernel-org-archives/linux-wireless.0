Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:23396 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbeACRaR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 12:30:17 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <neeo@xl.wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 3 Jan 2018 18:30:15 +0100
Date: Wed, 03 Jan 2018 18:30:15 +0100
From: "Dawid Stawiarski" <neeo@xl.wp.pl>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: iwlwifi: mvm: rx ops with kernel >= 4.14
Message-ID: <5a4d1327681fb1.97988235@wp.pl> (sfid-20180103_183036_134388_BAB930FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

after updating to kernel >= 4.14 (from 4.13.X) my wifi stops working every couple hours with the following stacktrace (I've already updated firmware to latest version):

jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: loaded firmware version 17.608620.0 op_mode iwlmvm
jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: base HW address: d8:fc:93:14:cc:15
jan 03 13:28:17 tmi kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[...]
jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0), index 0 is out of range [0-256] 70 70.
jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: HCMD_ACTIVE already clear for command LQ_CMD
jan 03 16:14:05 tmi kernel: frame on invalid queue - is on 0 and indicates 1
jan 03 16:14:05 tmi kernel: ------------[ cut here ]------------
jan 03 16:14:05 tmi kernel: WARNING: CPU: 5 PID: 219 at drivers/net/wireless/intel/iwlwifi/pcie/rx.c:1133 iwl_pcie_rx_handle+0x4cc/0x780 [iwlwifi]                                                                                                                                        
jan 03 16:14:05 tmi kernel: Modules linked in: nf_log_ipv4 nf_log_common xt_LOG xt_length nf_conntrack_ipv4 nf_defrag_ipv4 xt_owner xt_multiport xt_conntrack nf_conntrack iptable_mangle iwlmvm snd_hda_codec_realtek snd_hda_codec_generic rtsx_pci_sdmmc mac80211 x86_pkg_temp_thermal asus_nb_wmi mmc_core asus_wmi crc32c_intel snd_hda_intel snd_hda_codec iwlwifi aesni_intel snd_hwdep snd_hda_core aes_x86_64 snd_pcm crypto_simd cfg80211 cryptd glue_helper snd_timer ehci_pci xhci_pci xhci_hcd rfkill 
rtsx_pci snd lpc_ich ehci_hcd mfd_core tpm_tis tpm_tis_core tpm wmi efivarfs                                                                                                                                  
jan 03 16:14:05 tmi kernel: CPU: 5 PID: 219 Comm: irq/30-iwlwifi Not tainted 4.14.11 #1                                                      
jan 03 16:14:05 tmi kernel: Hardware name: ASUSTeK COMPUTER INC. N501JW/N501JW, BIOS N501JW.211 10/28/2015                                   
jan 03 16:14:05 tmi kernel: task: ffff897d6e209a80 task.stack: ffffb18e00718000                                                              
jan 03 16:14:05 tmi kernel: RIP: 0010:iwl_pcie_rx_handle+0x4cc/0x780 [iwlwifi]                                                               
jan 03 16:14:05 tmi kernel: RSP: 0018:ffffb18e0071bdd8 EFLAGS: 00010296                                                                      
jan 03 16:14:05 tmi kernel: RAX: 0000000000000030 RBX: 0000000000000040 RCX: 0000000000000006                                                
jan 03 16:14:05 tmi kernel: RDX: 0000000000000007 RSI: 0000000000000096 RDI: ffff897d7ef52370                                                
jan 03 16:14:05 tmi kernel: RBP: ffff897d28019040 R08: 0000000000000001 R09: 0000000000000999                                                
jan 03 16:14:05 tmi kernel: R10: ffff897d28019000 R11: 0000000000000000 R12: 0000000000000040                                                
jan 03 16:14:05 tmi kernel: R13: ffff897d6e290018 R14: ffff897d6e0b4000 R15: ffff897d72c2c000                                                
jan 03 16:14:05 tmi kernel: FS:  0000000000000000(0000) GS:ffff897d7ef40000(0000) knlGS:0000000000000000                                     
jan 03 16:14:05 tmi kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                
jan 03 16:14:05 tmi kernel: CR2: 00007f73478ec000 CR3: 000000004ca0a006 CR4: 00000000001606e0                                                
jan 03 16:14:05 tmi kernel: Call Trace:                                                                                                      
jan 03 16:14:05 tmi kernel:  iwl_pcie_irq_handler+0x182/0x6b0 [iwlwifi]                                                                      
jan 03 16:14:05 tmi kernel:  ? irq_forced_thread_fn+0x60/0x60                                                                                
jan 03 16:14:05 tmi kernel:  ? irq_thread_dtor+0x90/0x90                                                                                     
jan 03 16:14:05 tmi kernel:  irq_thread_fn+0x16/0x40
jan 03 16:14:05 tmi kernel:  ? irq_thread_dtor+0x90/0x90
jan 03 16:14:05 tmi kernel:  irq_thread+0x11a/0x170
jan 03 16:14:05 tmi kernel:  ? wake_threads_waitq+0x30/0x30
jan 03 16:14:05 tmi kernel:  kthread+0x10e/0x130
jan 03 16:14:05 tmi kernel:  ? kthread_create_on_node+0x40/0x40
jan 03 16:14:05 tmi kernel:  ret_from_fork+0x1f/0x30
jan 03 16:14:05 tmi kernel: Code: 28 01 00 00 48 c7 80 28 01 00 00 00 00 00 00 48 89 0c 24 e9 23 fc ff ff 31 c0 e9 e8 fd ff ff 48 c7 c7 f8 e4 4e c0 e8 0d 04 bb f6 <0f> ff e9 93 fd ff ff 48 8b 05 0e 38 94 f7 e9 5c fc ff ff 80 7c 
jan 03 16:14:05 tmi kernel: ---[ end trace 8adc3b47ce265658 ]---
jan 03 16:14:05 tmi kernel: frame on invalid queue - is on 0 and indicates 6

kudos,
Dawid
