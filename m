Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:2145 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbXIIQys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2007 12:54:48 -0400
Date: Sun, 9 Sep 2007 18:54:47 +0200
From: maximilian attems <max@stro.at>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: iwlwifi testing
Message-ID: <20070909165447.GA2574@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tried out the v6 patch on an x61s
unencrypted network on 2.6.23-rc4-amd64

* no printk on missing firmware
* oops on rmmod (didn't take down an interface before)

i'll try if i can reproduce with patch on 2.6.23-rc5

-- 
maks

-- lspci -v snipp
03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
        Subsystem: Intel Corporation Unknown device 1111
        Flags: bus master, fast devsel, latency 0, IRQ 1275
        Memory at f7f00000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
        Capabilities: [e0] Express Endpoint IRQ 0
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number fb-59-70-ff-ff-e8-13-00

-- ooops
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<0000000000000000>] _stext+0x7fdf7000/0x1a
PGD 2340a067 PUD 1e1b067 PMD 0 
Oops: 0010 [1] SMP 
CPU 0 
Modules linked in: arc4 ecb iwl4965 battery ac thermal fan button e1000 snd_rtctimer usb_storage option ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc nls_iso8859_1 isofs rfcomm l2cap bluetooth uinput ppdev parport_pc lp parport ipv6 acpi_cpufreq cpufreq_ondemand cpufreq_conservative cpufreq_powersave cpufreq_stats freq_table cpufreq_userspace sha256 aes cbc blkcipher sg sr_mod cdrom dm_crypt firewire_sbp2 loop usbserial snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy piix snd_seq_oss generic ide_core snd_seq_midi sdhci mmc_core pcmcia snd_rawmidi snd_seq_midi_event snd_seq firewire_ohci firewire_core i2c_i801 yenta_socket rsrc_nonstatic pcmcia_core snd_timer snd_seq_device snd evdev video firmware_class crc_itu_t i2c_core ata_generic serio_raw soundcore output mac80211 intel_agp snd_page_alloc joydev ehci_hcd uhci_hcd cfg80211 psmouse tsdev pcspkr thinkpad_acpi nvram ext3 jbd mbcache dm_mirror dm_snapshot dm_mod sd_mod processor ahci libata scsi_mod
Pid: 2310, comm: rmmod Not tainted 2.6.23-rc4-amd64 #1
RIP: 0010:[<0000000000000000>]  [<0000000000000000>] _stext+0x7fdf7000/0x1a
RSP: 0018:ffff810023bd5d80  EFLAGS: 00010296
RAX: ffffffff8824eac0 RBX: ffff81003b4c17f0 RCX: ffffffff80424393
RDX: 0000000000000000 RSI: ffffffff8815f488 RDI: ffff81001ad59aa0
RBP: ffffffff8815f488 R08: ffff810001106a68 R09: ffff81003b4f75c0
R10: 0000000000000020 R11: ffff81001ad58cd0 R12: ffff81003b4c17e0
R13: ffff81001ad58cc0 R14: ffff8100012ca000 R15: ffff81001ad58cc0
FS:  00002b5d87b2a6e0(0000) GS:ffffffff804fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000003c1cb000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 2310, threadinfo ffff810023bd4000, task ffff810004de9140)
Stack:  ffffffff8815f4a1 0000000000000286 ffff81003b4c17f0 0000000000000000
 ffffffff802fef47 ffff81001ad58cd0 0000000000000000 ffff81001ad582e0
 ffffffff88152c00 ffff81001ad58cc0 0000000000000004 ffff81001c4fd780
Call Trace:
 [<ffffffff8815f4a1>] :mac80211:rate_control_release+0x19/0x2e
 [<ffffffff802fef47>] kref_put+0x5d/0x68
 [<ffffffff88152c00>] :mac80211:ieee80211_unregister_hw+0x181/0x217
 [<ffffffff8823b325>] :iwl4965:iwl_pci_remove+0xff/0x1b1
 [<ffffffff8030c775>] pci_device_remove+0x24/0x48
 [<ffffffff80368c3e>] __device_release_driver+0x8e/0xb0
 [<ffffffff803690d8>] driver_detach+0x98/0xd8
 [<ffffffff80368751>] bus_remove_driver+0x6d/0x90
 [<ffffffff8030c9cc>] pci_unregister_driver+0x12/0x6c
 [<ffffffff8025286f>] sys_delete_module+0x1b1/0x1e0
 [<ffffffff8020be6e>] system_call+0x7e/0x83


Code:  Bad RIP value.
RIP  [<0000000000000000>] _stext+0x7fdf7000/0x1a
 RSP <ffff810023bd5d80>
CR2: 0000000000000000
