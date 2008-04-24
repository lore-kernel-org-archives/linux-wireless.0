Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:47089 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYDXIxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 04:53:23 -0400
Date: Thu, 24 Apr 2008 10:52:52 +0200
From: maximilian attems <max@stro.at>
To: linux-wireless@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net
Subject: iwl4965 resume oops
Message-ID: <20080424085252.GA4740@stro.at> (sfid-20080424_105358_578549_30C4DD94)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2.6.25 uname -a
Linux dual 2.6.25-trunk-amd64 #1 SMP Mon Apr 21 01:54:13 UTC 2008 x86_64 GNU/Linux

can also still reproduce with 2.6.25 the page allocation failure oops
and no no intellinuxwireless bugzilla account.
will see if latest git behaves, thanks

-- 
maks


[ 5963.772972] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[ 5963.773026] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[ 5934.578205] iwl4965: Error sending REPLY_RXON_ASSOC: time out after 500ms.
[ 5934.578236] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 5934.578242] IP: [<ffffffff8820f5c4>] :iwl4965:iwl4965_send_cmd_sync+0xf5d/0xfb8
[ 5934.578267] PGD 2d40a067 PUD 2d4e7067 PMD 0 
[ 5934.578273] Oops: 0002 [1] SMP 
[ 5934.578277] CPU 0 
[ 5934.578280] Modules linked in: uinput ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats freq_table cpufreq_userspace sha256_generic aes_x86_64 aes_generic cbc dm_crypt coretemp firewire_sbp2 loop pcmcia snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 sdhci snd_seq_oss ecb serio_raw mmc_core yenta_socket rsrc_nonstatic pcmcia_core crypto_blkcipher i2c_i801 snd_seq_midi psmouse snd_rawmidi i2c_core snd_seq_midi_event iTCO_wdt pcspkr snd_seq iwl4965 firmware_class mac80211 snd_timer snd_seq_device cfg80211 snd soundcore snd_page_alloc battery bay ac video output button intel_agp thinkpad_acpi evdev nvram joydev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod ata_generic ide_pci_generic sd_mod piix ahci firewire_ohci firewire_core ide_core crc_itu_t libata scsi_mod ehci_hcd e1000e uhci_hcd dock thermal processor fan
[ 5934.578381] Pid: 2102, comm: iwl4965 Not tainted 2.6.25-trunk-amd64 #1
[ 5934.578386] RIP: 0010:[<ffffffff8820f5c4>]  [<ffffffff8820f5c4>] :iwl4965:iwl4965_send_cmd_sync+0xf5d/0xfb8
[ 5934.578407] RSP: 0000:ffff81003c4cdc70  EFLAGS: 00010246
[ 5934.578412] RAX: 0000000000000000 RBX: 00000000ffffff92 RCX: 000000000000f997
[ 5934.578417] RDX: 0000000000000000 RSI: 0000000000010000 RDI: 0000000000000282
[ 5934.578421] RBP: ffff81003c8d0060 R08: 0000000000000000 R09: ffff81003c4cd900
[ 5934.578426] R10: 0000000000000000 R11: ffff81003bfe2e30 R12: 0000000000000000
[ 5934.578431] R13: ffff81003c4cdce0 R14: ffff81003c8d19a0 R15: 0000000000000000
[ 5934.578436] FS:  0000000000000000(0000) GS:ffffffff80520000(0000) knlGS:0000000000000000
[ 5934.578442] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 5934.578446] CR2: 0000000000000010 CR3: 000000002d4c9000 CR4: 00000000000006e0
[ 5934.578451] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5934.578456] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5934.578462] Process iwl4965 (pid: 2102, threadinfo ffff81003c4cc000, task ffff81003bfe2bc0)
[ 5934.578466] Stack:  0000000000000000 ffff81003bfe2bc0 ffffffff8024695c ffff81003c4cdc88
[ 5934.578476]  ffff81003c4cdc88 00000000ffffffff 0000000000000282 ffff81003c8d19a0
[ 5934.578484]  ffff81003c8d0060 ffff81003d445918 ffff810013555000 ffff81003d445000
[ 5934.578491] Call Trace:
[ 5934.578506]  [<ffffffff8024695c>] ? autoremove_wake_function+0x0/0x2e
[ 5934.578537]  [<ffffffff8820f785>] ? :iwl4965:iwl4965_send_rxon_assoc+0xdb/0x11c
[ 5934.578576]  [<ffffffff881e9146>] ? :mac80211:ieee80211_set_associated+0x2aa/0x310
[ 5934.578611]  [<ffffffff881e6278>] ? :mac80211:sta_info_release+0x0/0x90
[ 5934.578646]  [<ffffffff881eb487>] ? :mac80211:ieee80211_associated+0x150/0x180
[ 5934.578657]  [<ffffffff802492d5>] ? hrtimer_start+0x110/0x122
[ 5934.578692]  [<ffffffff881ed489>] ? :mac80211:ieee80211_sta_work+0x458/0x63f
[ 5934.578702]  [<ffffffff80230161>] ? hrtick_set+0x9e/0xf7
[ 5934.578716]  [<ffffffff8041dcc3>] ? thread_return+0x6b/0xac
[ 5934.578751]  [<ffffffff881ed031>] ? :mac80211:ieee80211_sta_work+0x0/0x63f
[ 5934.578764]  [<ffffffff80243850>] ? run_workqueue+0x82/0x111
[ 5934.578774]  [<ffffffff80244156>] ? worker_thread+0xd5/0xe0
[ 5934.578783]  [<ffffffff8024695c>] ? autoremove_wake_function+0x0/0x2e
[ 5934.578795]  [<ffffffff80244081>] ? worker_thread+0x0/0xe0
[ 5934.578801]  [<ffffffff80246833>] ? kthread+0x47/0x74
[ 5934.578807]  [<ffffffff802302a1>] ? schedule_tail+0x27/0x5c
[ 5934.578816]  [<ffffffff8020cdf8>] ? child_rip+0xa/0x12
[ 5934.578840]  [<ffffffff802467ec>] ? kthread+0x0/0x74
[ 5934.578847]  [<ffffffff8020cdee>] ? child_rip+0x0/0x12
[ 5934.578854] 
[ 5934.578856] 
[ 5934.578857] Code: 97 63 02 f8 f0 41 0f ba b6 28 43 00 00 00 41 f6 45 14 04 bb 92 ff ff ff 74 15 49 63 c7 48 69 c0 80 01 00 00 49 03 86 10 3f 00 00 <83> 60 10 fb 49 8b 7d 0c 48 85 ff 74 11 e8 3a 12 1a f8 49 c7 45 
[ 5934.578903] RIP  [<ffffffff8820f5c4>] :iwl4965:iwl4965_send_cmd_sync+0xf5d/0xfb8
[ 5934.578923]  RSP <ffff81003c4cdc70>
[ 5934.578926] CR2: 0000000000000010
[ 5934.578931] ---[ end trace 70b4a39adafc1f66 ]---
[ 5935.218676] sd 0:0:0:0: [sda] Starting disk
[ 5935.229689] Restarting tasks ... <6>usb 1-2: USB disconnect, address 5
[ 5935.311651] done.
[ 5935.493650] usb 1-2: new full speed USB device using uhci_hcd and address 6
[ 5935.664525] usb 1-2: configuration #1 chosen from 1 choice
[ 5935.664946] usb 1-2: New USB device found, idVendor=0483, idProduct=2016
[ 5935.664946] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5935.664946] usb 1-2: Product: Biometric Coprocessor
[ 5935.664946] usb 1-2: Manufacturer: STMicroelectronics
[ 5936.232600] wlan0: deauthenticate(reason=3)
[ 5936.232628] iwl4965: Error sending REPLY_RXON_ASSOC: Already sending a host command
[ 5936.232645] iwl4965: Error sending REPLY_RXON_ASSOC: Already sending a host command
[ 5937.275784] wlan0: Failed to config new BSSID to the low-level driver
[ 5973.831639] eth0: no IPv6 routers present
[ 5964.767990] Monitor-Mwait will be used to enter C-3 state
[ 5964.883667] CPU0 attaching NULL sched-domain.
[ 5964.883680] CPU1 attaching NULL sched-domain.
[ 5964.899071] CPU0 attaching sched-domain:
[ 5964.899079]  domain 0: span 00000003
[ 5964.899084]   groups: 00000001 00000002
[ 5964.899092]   domain 1: span 00000003
[ 5964.899099]    groups: 00000003
[ 5964.899109] CPU1 attaching sched-domain:
[ 5964.899114]  domain 0: span 00000003
[ 5964.899119]   groups: 00000002 00000001
[ 5964.899131]   domain 1: span 00000003
[ 5964.899137]    groups: 00000003
