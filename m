Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58067 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYJ2VdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:33:17 -0400
Received: from [192.168.1.188] (S0106001cf062885c.vc.shawcable.net [24.82.150.230])
	by mail.holtmann.org (Postfix) with ESMTP id E3523165E42
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 22:33:15 +0100 (CET)
Message-Id: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com> (sfid-20081029_223321_972504_6471F274)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=Apple-Mail-16-48173699
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Still 4965 issues with wireless-testing
Date: Wed, 29 Oct 2008 22:33:13 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail-16-48173699
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi guys,

so besides the point that the Ubuntu 8.10 kernel has a broken driver  
for the Intel 4965 cards which will crash my X61 after less than one  
minute uptime when it connects to my access point, I have my dmesg  
full with warnings from the latest wireless-testing kernel.

I know that we have discussed this before and Johannes' patch at least  
turns it into warnings instead of killing my system completely, but I  
am still surprised why this hasn't been fixed.

Attached is one of the dmesg snippets. They occur multiple times per  
minute.

Regards

Marcel

--Apple-Mail-16-48173699
Content-Disposition: attachment;
	filename=iwlagn-dmesg.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="iwlagn-dmesg.txt"
Content-Transfer-Encoding: 7bit

WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1241 iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: tun aes_x86_64 aes_generic af_packet i915 drm binfmt_misc rfcomm sco bnep l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi iwlagn iwlcore thinkpad_acpi sdhci_pci sdhci rfkill backlight mac80211 firewire_ohci firewire_core led_class nvram mmc_core sg piix ide_core crc_itu_t cfg80211 ehci_hcd yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd usbcore e1000e evdev unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #1
Call Trace:
 <IRQ>  [<ffffffff80233f6c>] warn_slowpath+0xae/0xd5
 [<ffffffff80252c00>] ? trace_hardirqs_off_caller+0x8/0x9f
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80256110>] ? print_lock_contention_bug+0x1e/0x110
 [<ffffffff80211dc4>] ? native_sched_clock+0x76/0x88
 [<ffffffff80252ca4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff80252c19>] ? trace_hardirqs_off_caller+0x21/0x9f
 [<ffffffffa0156ab4>] iwl_tx_cmd_complete+0x50/0x1f0 [iwlcore]
 [<ffffffffa016c251>] iwl_rx_handle+0x127/0x226 [iwlagn]
 [<ffffffffa016c562>] iwl4965_irq_tasklet+0x212/0x2c9 [iwlagn]
 [<ffffffff802389b8>] tasklet_action+0x7f/0xda
 [<ffffffff8023926a>] __do_softirq+0x8d/0x163
 [<ffffffff8020c82c>] call_softirq+0x1c/0x28
 [<ffffffff8020dd65>] do_softirq+0x39/0x8a
 [<ffffffff80238dcc>] irq_exit+0x4e/0x91
 [<ffffffff8020e059>] do_IRQ+0x150/0x173
 [<ffffffff8020b9cb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff802542ed>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8038b850>] ? acpi_idle_enter_simple+0x1ae/0x21f
 [<ffffffff8038b846>] ? acpi_idle_enter_simple+0x1a4/0x21f
 [<ffffffff8038b420>] ? acpi_idle_enter_bm+0xd1/0x353
 [<ffffffff803f9779>] ? cpuidle_idle_call+0x94/0xcf
 [<ffffffff8020a5f7>] ? cpu_idle+0x54/0x9d
 [<ffffffff80469018>] ? rest_init+0x5c/0x5e
---[ end trace c15dac81b0f1f4b9 ]---

--Apple-Mail-16-48173699--
