Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755994AbZENR2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:28:13 -0400
From: elektra <onelektra@gmx.net>
To: " linux-wireless" <linux-wireless@vger.kernel.org>
Subject: ath5k from compat-wireless-2009-05-14 fails to perform IBSS merge
Date: Thu, 14 May 2009 19:28:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200905141928.11794.onelektra@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Call trace made with vanilla 2.6.29.3 and compat-wireless-2009-05-14 on EEEPC 
901. 

Cheers,
elektra

WiFi NIC: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express 
Adapter (rev 01)
        Subsystem: Atheros Communications Inc. AR5006EX 802.11abg NIC 
(2.4/5.0GHz, PCI Express)
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at f7ff0000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
        Capabilities: [60] Express Legacy Endpoint, MSI 00
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [140] Virtual Channel <?>



May 14 18:35:46 901 kernel: ------------[ cut here ]------------
May 14 18:35:46 901 kernel: WARNING: 
at /usr/src/compat-wireless-2009-05-14/drivers/net/wireless/ath/ath5k/base.c:2165 
ath5k_beacon_update_timers+0x30b/0x360 [ath5k]()
May 14 18:35:46 901 kernel: Hardware name: 901
May 14 18:35:46 901 kernel: Modules linked in: acpi_cpufreq snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss ipv6 ppdev lp parport_pc parport btusb bluetooth fuse 
usb_storage snd_hda_codec_realtek snd_hda_intel ath5k snd_hda_codec mac80211 
snd_hwdep led_class snd_pcm ath psmouse snd_timer i2c_i801 uhci_hcd video 
thermal i2c_core snd rtc_cmos serio_raw sg evdev cfg80211 intel_agp rtc_core 
output soundcore ehci_hcd eeepc_laptop ac atl1e rtc_lib processor battery 
agpgart snd_page_alloc thermal_sys hwmon rfkill button

May 14 18:35:46 901 kernel: Pid: 2083, comm: phy0 Not tainted 2.6.29.3-smp #1
May 14 18:35:46 901 kernel: Call Trace:
May 14 18:35:46 901 kernel:  [<c012c716>] warn_slowpath+0x86/0xa0
May 14 18:35:46 901 kernel:  [<f85baa2b>] 
ath5k_beacon_update_timers+0x30b/0x360 [ath5k]
May 14 18:35:46 901 kernel:  [<c0143208>] ? down_trylock+0x28/0x40
May 14 18:35:46 901 kernel:  [<c012cc9d>] ? try_acquire_console_sem+0xd/0x50
May 14 18:35:46 901 kernel:  [<f85baaa9>] ath5k_reset_tsf+0x29/0x30 [ath5k]
May 14 18:35:46 901 kernel:  [<f85385c1>] __ieee80211_sta_join_ibss+0x31/0x3e0 
[mac80211]
May 14 18:35:46 901 kernel:  [<c02981de>] ? extract_entropy+0x4e/0x90
May 14 18:35:46 901 kernel:  [<c040f54d>] ? _spin_unlock_bh+0xd/0x10
May 14 18:35:46 901 kernel:  [<c012d49b>] ? printk+0x1b/0x20
May 14 18:35:46 901 kernel:  [<f8538cc1>] ieee80211_sta_find_ibss+0x351/0x430 
[mac80211]
May 14 18:35:46 901 kernel:  [<c038a757>] ? skb_release_data+0x57/0x80
May 14 18:35:46 901 kernel:  [<f85392e0>] ? ieee80211_ibss_work+0x0/0x490 
[mac80211]
May 14 18:35:46 901 kernel:  [<f8539700>] ieee80211_ibss_work+0x420/0x490 
[mac80211]
May 14 18:35:46 901 kernel:  [<c0120ca1>] ? __dequeue_entity+0x21/0x40
May 14 18:35:46 901 kernel:  [<c0120d70>] ? set_next_entity+0xb0/0xd0
May 14 18:35:46 901 kernel:  [<c040d8e8>] ? schedule+0x418/0xa20
May 14 18:35:46 901 kernel:  [<f85392e0>] ? ieee80211_ibss_work+0x0/0x490 
[mac80211]
May 14 18:35:46 901 kernel:  [<c013bced>] run_workqueue+0xad/0x140
May 14 18:35:46 901 kernel:  [<c013c698>] worker_thread+0x88/0xe0
May 14 18:35:46 901 kernel:  [<c013f560>] ? autoremove_wake_function+0x0/0x40
May 14 18:35:46 901 kernel:  [<c013c610>] ? worker_thread+0x0/0xe0
May 14 18:35:46 901 kernel:  [<c013f262>] kthread+0x42/0x70
May 14 18:35:46 901 kernel:  [<c013f220>] ? kthread+0x0/0x70
May 14 18:35:46 901 kernel:  [<c0103a5b>] kernel_thread_helper+0x7/0x1c
May 14 18:35:46 901 kernel: ---[ end trace 98b1d2d4a196ef83 ]---
May 14 18:35:46 901 kernel: ath5k phy0: bf=f63e9680 bf_skb=(null)
