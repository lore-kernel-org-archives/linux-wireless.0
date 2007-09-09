Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:4060 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688AbXIIRHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 13:07:01 -0400
Date: Sun, 9 Sep 2007 19:06:23 +0200
From: maximilian attems <max@stro.at>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwlwifi testing
Message-ID: <20070909170623.GA4857@stro.at>
References: <20070909165447.GA2574@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070909165447.GA2574@stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 09 Sep 2007, maximilian attems wrote:

> i'll try if i can reproduce with patch on 2.6.23-rc5

yo, same story without even connecting to an ap.

-- 
maks
 

dmesg | grep iwl
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 0.1.14ks
iwl4965: Copyright(c) 2003-2007 Intel Corporation
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:d3:3e:31:5c
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
wmaster0: Selected rate control algorithm 'iwl-4965-rs'


Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<0000000000000000>] _stext+0x7fdf7000/0x1a
PGD 3be74067 PUD 3be81067 PMD 0 
Oops: 0010 [1] SMP 
CPU 0 
Modules linked in: i915 drm rfcomm l2cap bluetooth uinput ppdev parport_pc lp parport ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats freq_table cpufreq_userspace sha256 aes cbc dm_crypt firewire_sbp2 loop pcmcia snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss arc4 snd_seq_dummy ecb blkcipher snd_seq_oss snd_seq_midi snd_rawmidi firewire_ohci firewire_core snd_seq_midi_event sdhci mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t battery snd_seq ac piix snd_timer snd_seq_device video output button snd iwl4965 firmware_class generic ide_core evdev serio_raw soundcore i2c_i801 i2c_core mac80211 intel_agp cfg80211 snd_page_alloc ata_generic e1000 psmouse joydev ehci_hcd uhci_hcd tsdev pcspkr thinkpad_acpi nvram ext3 jbd mbcache dm_mirror dm_snapshot dm_mod sd_mod thermal processor fan ahci libata scsi_mod
Pid: 4767, comm: rmmod Not tainted 2.6.23-rc5-amd64 #1
RIP: 0010:[<0000000000000000>]  [<0000000000000000>] _stext+0x7fdf7000/0x1a
RSP: 0018:ffff81002a2cbd80  EFLAGS: 00010296
RAX: ffffffff881daac0 RBX: ffff81003b06dbf0 RCX: ffffffff80424393
RDX: 0000000000000000 RSI: ffffffff88165488 RDI: ffff81003bd71aa0
RBP: ffffffff88165488 R08: ffff810001106a68 R09: ffff81003a083dc0
R10: 0000000000000020 R11: ffff81003bd70cd0 R12: ffff81003b06dbe0
R13: ffff81003bd70cc0 R14: ffff81000119f000 R15: ffff81003bd70cc0
FS:  00002abdfac186e0(0000) GS:ffffffff804f9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000003c0c1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 4767, threadinfo ffff81002a2ca000, task ffff81002c95b040)
Stack:  ffffffff881654a1 0000000000000286 ffff81003b06dbf0 0000000000000000
 ffffffff802fefeb ffff81003bd70cd0 0000000000000000 ffff81003bd702e0
 ffffffff88158c00 ffff81003bd70cc0 0000000000000004 ffff81003b03f780
Call Trace:
 [<ffffffff881654a1>] :mac80211:rate_control_release+0x19/0x2e
 [<ffffffff802fefeb>] kref_put+0x5d/0x68
 [<ffffffff88158c00>] :mac80211:ieee80211_unregister_hw+0x181/0x217
 [<ffffffff881c7325>] :iwl4965:iwl_pci_remove+0xff/0x1b1
 [<ffffffff8030c815>] pci_device_remove+0x24/0x48
 [<ffffffff80368c76>] __device_release_driver+0x8e/0xb0
 [<ffffffff80369110>] driver_detach+0x98/0xd8
 [<ffffffff80368789>] bus_remove_driver+0x6d/0x90
 [<ffffffff8030ca6c>] pci_unregister_driver+0x12/0x6c
 [<ffffffff802528d3>] sys_delete_module+0x1b1/0x1e0
 [<ffffffff8020be6e>] system_call+0x7e/0x83


Code:  Bad RIP value.
RIP  [<0000000000000000>] _stext+0x7fdf7000/0x1a
 RSP <ffff81002a2cbd80>
CR2: 0000000000000000
