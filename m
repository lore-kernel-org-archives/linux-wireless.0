Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:56350 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZG1QYv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:24:51 -0400
Received: from [172.16.24.147] (ndn243.bob.fi [81.209.19.243])
	by mbox2.netikka.net (Postfix) with ESMTP id 1F35040800D
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 19:24:46 +0300 (EEST)
Message-ID: <4A6F264E.70501@mandriva.org>
Date: Tue, 28 Jul 2009 19:24:46 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at net/mac80211/agg-tx.c:145 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Is this known?

I got this today on a Intel 4965 with a 2.6.31-rc4 based kernel 
configured with PREEMPT.

Arch is x86_64 and firmware 228.61.2.24

iwlagn 0000:04:00.0: Stopping AGG while state not IWL_AGG_ON
iwlagn 0000:04:00.0: queue number out of range: 0, must be 7 to 14
------------[ cut here ]------------
WARNING: at net/mac80211/agg-tx.c:145 
___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac80211]()
Hardware name: TravelMate 5720
Modules linked in: cryptd aes_x86_64 aes_generic af_packet ipv6 btusb 
bluetooth firewire_ohci firewire_core arc4 ecb crc_itu_t tg3 serio_raw 
sdhci_pci sdhci ohci1394 libphy ieee1394 iwlagn snd_hda_codec_realtek 
sr_mod iwlcore sg snd_hda_intel snd_hda_codec acer_wmi iTCO_wdt 
iTCO_vendor_support mac80211 snd_hwdep snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss led_class snd_pcm 
snd_timer snd_mixer_oss snd cfg80211 soundcore i2c_i801 rfkill 
snd_page_alloc binfmt_misc fuse ext3 jbd jfs pcmcia yenta_socket 
rsrc_nonstatic pcmcia_core cpufreq_ondemand cpufreq_conservative 
cpufreq_powersave acpi_cpufreq freq_table tifm_sd mmc_block mmc_core 
tifm_7xx1 tifm_core nvram radeon uvcvideo nsc_ircc videodev v4l1_compat 
ttm v4l2_compat_ioctl32 drm irda crc_ccitt i2c_algo_bit uhci_hcd 
i2c_core ehci_hcd joydev evdev container battery usbcore video output 
thermal processor button ac pcspkr rtc_cmos wmi ata_piix ahci libata 
sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
Pid: 0, comm: swapper Not tainted 2.6.31-tmb-desktop-0.rc4.3mdv #1
Call Trace:
  <IRQ>  [<ffffffff81043818>] warn_slowpath_common+0x78/0xb0
  [<ffffffff8104385f>] warn_slowpath_null+0xf/0x20
  [<ffffffffa0445121>] ___ieee80211_stop_tx_ba_session+0x91/0xa0 [mac80211]
  [<ffffffffa0445326>] sta_addba_resp_timer_expired+0x56/0x90 [mac80211]
  [<ffffffffa04452d0>] ? sta_addba_resp_timer_expired+0x0/0x90 [mac80211]
  [<ffffffff8104e1ae>] run_timer_softirq+0x13e/0x210
  [<ffffffff8104912f>] __do_softirq+0xaf/0x140
  [<ffffffff8100fa2a>] ? timer_interrupt+0x1a/0x30
  [<ffffffff8100d06c>] call_softirq+0x1c/0x30
  [<ffffffff8100f075>] do_softirq+0x45/0x80
  [<ffffffff81049575>] irq_exit+0x95/0xa0
  [<ffffffff8100e600>] do_IRQ+0x70/0xe0
  [<ffffffff8100c8d3>] ret_from_intr+0x0/0xa
  <EOI>  [<ffffffffa00fa57a>] ? acpi_idle_enter_bm+0x26c/0x297 [processor]
  [<ffffffffa00fa570>] ? acpi_idle_enter_bm+0x262/0x297 [processor]
  [<ffffffff81240efb>] ? cpuidle_idle_call+0x9b/0xf0
  [<ffffffff8100aa32>] ? cpu_idle+0x62/0xd0
  [<ffffffff812daa81>] ? rest_init+0x81/0x90
  [<ffffffff814b6acf>] ? start_kernel+0x356/0x361
  [<ffffffff814b6128>] ? x86_64_start_reservations+0x125/0x129
  [<ffffffff814b620d>] ? x86_64_start_kernel+0xe1/0xe8
---[ end trace 60c73ee4e29d40fe ]---



About 1 hour before this I had this in dmesg:

iwlagn 0000:04:00.0: iwl_tx_agg_start on ra = 00:19:5b:51:dc:27 tid = 0
iwlagn 0000:04:00.0: Microcode HW error detected.  Restarting.



--
Thomas
