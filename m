Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0GQHav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 03:30:51 -0400
Received: by fxm14 with SMTP id 14so1440764fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Jul 2010 00:30:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 17 Jul 2010 10:30:49 +0300
Message-ID: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
Subject: RTL8180L is hitting WARN_ON in net/wireless/scan.c:575
From: Pauli Nieminen <suokkos@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm testing 2.6.35-rc4+, I have problem that warning is spamming dmesg
when I have my wifi on. Actual problem caused y that problem is that I
can't scan/connect to any network with 2.6.35.

When I looked the code in warning it might be related to problem that
my wifi reports all signal strength to be 175 or 178 (if I remember
correctly). I'm now using 2.6.35 so I can't check the reported values
from scan results.

lspci:
00:09.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8180L 802.11b MAC [10ec:8180] (rev 20)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL8180L 802.11b MAC [10ec:8180]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at 1000 [size=256]
	Region 1: Memory at d0004800 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: rtl8180

code line:
        if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
                    (signal < 0 || signal > 100)))
dmesg:
[  953.750722] WARNING: at net/wireless/scan.c:575
cfg80211_inform_bss_frame+0x55/0x128 [cfg80211]()
[  953.750726] Hardware name: Aspire 1350
[  953.750729] Modules linked in: powernow_k7 cpufreq_userspace
cpufreq_powersave cpufreq_conservative cpufreq_stats parport_pc ppdev
lp parport binfmt_misc fuse ext2 ext4 jbd2 crc16 radeon ttm
drm_kms_helper drm netconsole configfs i2c_algo_bit dm_crypt dm_mod
snd_via82xx snd_via82xx_modem gameport snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_mpu401_uart arc4 snd_seq_midi
ecb snd_rawmidi rtl8180 snd_seq_midi_event mac80211 i2c_viapro
eeprom_93cx6 i2c_core pcmcia snd_seq via_ircc snd_timer snd_seq_device
yenta_socket cfg80211 psmouse pcmcia_rsrc snd irda tpm_tis video
pcspkr processor evdev pcmcia_core serio_raw battery output button
container ac tpm soundcore tpm_bios shpchp rfkill pci_hotplug
snd_page_alloc crc_ccitt ext3 jbd mbcache usbhid sg hid sr_mod sd_mod
cdrom crc_t10dif ata_generic pata_via libata uhci_hcd ehci_hcd usbcore
scsi_mod firewire_ohci floppy thermal via_rhine firewire_core
thermal_sys mii crc_itu_t nls_base [last unloaded: scsi_wait_scan]
[  953.750817] Pid: 0, comm: swapper Tainted: G        W   2.6.35-rc4+ #46
[  953.750820] Call Trace:
[  953.750828]  [<c102f795>] ? warn_slowpath_common+0x6a/0x7b
[  953.750839]  [<e0e4564f>] ? cfg80211_inform_bss_frame+0x55/0x128 [cfg80211]
[  953.750846]  [<c102f7b3>] ? warn_slowpath_null+0xd/0x10
[  953.750857]  [<e0e4564f>] ? cfg80211_inform_bss_frame+0x55/0x128 [cfg80211]
[  953.750870]  [<e112c487>] ? ieee80211_bss_info_update+0x4a/0x13f [mac80211]
[  953.750883]  [<e112c683>] ? ieee80211_scan_rx+0xfa/0x130 [mac80211]
[  953.750899]  [<e1137dff>] ?
ieee80211_invoke_rx_handlers+0x67/0x166e [mac80211]
[  953.750905]  [<c10079a9>] ? sched_clock+0x9/0xd
[  953.750911]  [<c10471cf>] ? sched_clock_local+0x17/0x11e
[  953.750920]  [<c10454a7>] ? hrtimer_forward+0x10f/0x123
[  953.750934]  [<e11374c2>] ? prepare_for_handlers+0x22/0x25d [mac80211]
[  953.750948]  [<e1139b3f>] ? ieee80211_rx+0x739/0x796 [mac80211]
[  953.750960]  [<e1129444>] ? ieee80211_tasklet_handler+0x48/0xca [mac80211]
[  953.750967]  [<c10339c0>] ? tasklet_action+0x60/0xa4
[  953.750972]  [<c1034425>] ? __do_softirq+0xb1/0x156
[  953.750977]  [<c10344f8>] ? do_softirq+0x2e/0x38
[  953.750982]  [<c10345f6>] ? irq_exit+0x26/0x58
[  953.750987]  [<c10044b2>] ? do_IRQ+0x7d/0x8e
[  953.750993]  [<c10034b0>] ? common_interrupt+0x30/0x38
[  953.751001]  [<e0ecc1a9>] ? acpi_idle_enter_simple+0xef/0x129 [processor]
[  953.751007]  [<c11cce49>] ? cpuidle_idle_call+0x69/0xc0
[  953.751013]  [<c1002202>] ? cpu_idle+0x95/0xaf
[  953.751018]  [<c13bc8c2>] ? start_kernel+0x33a/0x33f
[  953.751022] ---[ end trace 931bbdec61de23bf ]---

Pauli
