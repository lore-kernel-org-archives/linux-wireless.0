Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45059 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZEOAby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 20:31:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 17:31:56 -0700
Date: Thu, 14 May 2009 17:32:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
Message-ID: <20090515003202.GA17816@tesla>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com> <1242033904-25694-4-git-send-email-lrodriguez@atheros.com> <1242036115.3284.15.camel@johannes.local> <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com> <1242068010.3873.46.camel@johannes.local> <20090511190922.GD18696@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090511190922.GD18696@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 12:09:22PM -0700, Luis Rodriguez wrote:
> On Mon, May 11, 2009 at 11:53:30AM -0700, Johannes Berg wrote:
> > On Mon, 2009-05-11 at 11:34 -0700, Luis R. Rodriguez wrote:
> >
> > > > Also, __ieee80211_queues_stopped_by_reason is misnamed since it checks
> > > > only a single queue. I also think that we can do this much better by
> > > > keeping track of the suspend state in a new variable rather than looking
> > > > at all the queues; even just checking queue 0 would be sufficient, but I
> > > > think a new variable is warranted.
> > >
> > > A global variable for going to suspend? Hm, do we have a system wide
> > > thing for this instead?
> >
> > No, and even then we couldn't use it I think since you can have
> > per-device suspend. I was just thinking of a local->variable.
> 
> OK thanks will add this.

So I've added the WARN_ON() here as we agreed to investigate on irc. Turns out
we hit it several times as expected. We hit it while going to suspend
once, and then on resume 3 times.

[ 3170.261817] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
[ 3171.554210] PM: Syncing filesystems ... done.
[ 3171.559911] PM: Preparing system for mem sleep
[ 3171.559923] Freezing user space processes ... (elapsed 0.00 seconds) done.
[ 3171.560454] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[ 3171.560510] PM: Entering mem sleep
[ 3171.560522] Suspending console(s) (use no_console_suspend to debug)
[ 3171.595622] ath9k 0000:16:00.0: PCI INT A disabled
[ 3171.608155] pci 0000:00:02.0: power state changed by ACPI to D3
[ 3171.888073] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3171.888237] sd 0:0:0:0: [sda] Stopping disk
[ 3173.348906] serial 00:0a: disabled
[ 3173.349469] ata_piix 0000:00:1f.2: PCI INT B disabled
[ 3173.364098] ehci_hcd 0000:00:1d.7: PCI INT D disabled
[ 3173.364184] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3173.382790] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D3
[ 3173.382810] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[ 3173.382882] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[ 3173.382950] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[ 3173.383002] pciehp 0000:00:1c.3:pcie04: pciehp_suspend ENTRY
[ 3173.396326] HDA Intel 0000:00:1b.0: PCI INT B disabled
[ 3173.412104] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[ 3173.412187] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3173.430396] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D3
[ 3173.430415] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[ 3173.430486] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[ 3173.433137] e1000e 0000:00:19.0: PCI INT A disabled
[ 3173.433145] e1000e 0000:00:19.0: PME# enabled
[ 3173.433151] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[ 3173.448119] ACPI handle has no context!
[ 3173.464117] PM: suspend devices took 1.908 seconds
[ 3173.524081] ------------[ cut here ]------------
[ 3173.524085] WARNING: at net/mac80211/iface.c:935 warn_slowpath_null+0x1c/0x20()
[ 3173.524087] Hardware name: 7660A14
[ 3173.524088] Modules linked in: nls_cp437 ntfs vfat msdos fat ext2 aes_generic ath9k rfkill af_packet i915 drm sco bridge stp llc rfcomm bnep l2cap bluetooth ipv6 acpi_cpufreq cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative sbs container pci_slot sbshc snd_hda_codec_analog arc4 ecb snd_hda_intel snd_hda_codec snd_pcm snd_seq mac80211 snd_timer snd_seq_device led_class joydev ath usbhid snd serio_raw hid ac soundcore intel_agp battery cfg80211 video wmi snd_page_alloc pcspkr button processor psmouse evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom crc_t10dif ata_piix ata_generic pata_acpi ehci_hcd uhci_hcd libata scsi_mod usbcore thermal fan fuse e1000e [last unloaded: ath5k]
[ 3173.524146] Pid: 5567, comm: phy1 Not tainted 2.6.30-rc5-wl #89
[ 3173.524148] Call Trace:
[ 3173.524154]  [<c04edd84>] ? printk+0x18/0x1c
[ 3173.524157]  [<c02315eb>] warn_slowpath_fmt+0x7b/0xd0
[ 3173.524161]  [<c022d00f>] ? update_curr+0x21f/0x230
[ 3173.524164]  [<c022d116>] ? dequeue_entity+0x16/0x2c0
[ 3173.524167]  [<c022d428>] ? dequeue_task_fair+0x68/0x70
[ 3173.524171]  [<c021f00a>] ? dequeue_task+0x10a/0x160
[ 3173.524174]  [<c023165c>] warn_slowpath_null+0x1c/0x20
[ 3173.524191]  [<f85cb06b>] __ieee80211_recalc_idle+0x14b/0x160 [mac80211]
[ 3173.524205]  [<f85cb0a7>] ieee80211_recalc_idle+0x27/0x50 [mac80211]
[ 3173.524219]  [<f85caa8f>] ieee80211_sta_work+0xdf/0x570 [mac80211]
[ 3173.524223]  [<c023b571>] ? add_timer+0x11/0x20
[ 3173.524226]  [<c0242d5b>] ? queue_delayed_work_on+0x9b/0xd0
[ 3173.524236]  [<c02423c3>] worker_thread+0x143/0x210
[ 3173.524239]  [<c021fa28>] ? __wake_up_common+0x48/0x70
[ 3173.524255]  [<f85ca9b0>] ? ieee80211_sta_work+0x0/0x570 [mac80211]
[ 3173.524259]  [<c0246230>] ? autoremove_wake_function+0x0/0x50
[ 3173.524266]  [<c0242280>] ? worker_thread+0x0/0x210
[ 3173.524270]  [<c0245ec6>] kthread+0x46/0x80
[ 3173.524272]  [<c0245e80>] ? kthread+0x0/0x80
[ 3173.524276]  [<c0203a8f>] kernel_thread_helper+0x7/0x18
[ 3173.524278] ---[ end trace 0c9ec377fc490a14 ]---
[ 3173.608088] ACPI: Preparing to enter system sleep state S3
[ 3174.200263] Disabling non-boot CPUs ...
[ 3174.304021] CPU 1 is now offline
[ 3174.304025] SMP alternatives: switching to UP code
[ 3174.309720] CPU0 attaching NULL sched-domain.
[ 3174.309723] CPU1 attaching NULL sched-domain.
[ 3174.309729] CPU0 attaching NULL sched-domain.
[ 3174.309871] CPU1 is down
[ 3174.309927] Extended CMOS year: 2000
[ 3174.309927] Back to C!
[ 3174.309927] Extended CMOS year: 2000
[ 3174.309927] Enabling non-boot CPUs ...
[ 3174.309927] SMP alternatives: switching to SMP code
[ 3174.315029] Booting processor 1 APIC 0x1 ip 0x6000
[ 3174.309581] Initializing CPU#1
[ 3174.309581] Calibrating delay using timer specific routine.. 3591.00 BogoMIPS (lpj=7182017)
[ 3174.309581] CPU: L1 I cache: 32K, L1 D cache: 32K
[ 3174.309581] CPU: L2 cache: 2048K
[ 3174.309581] CPU: Physical Processor ID: 0
[ 3174.309581] CPU: Processor Core ID: 1
[ 3174.404425] CPU1: Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz stepping 0d
[ 3174.404499] CPU0 attaching NULL sched-domain.
[ 3174.405022] Switched to high resolution mode on CPU 1
[ 3174.420023] CPU0 attaching sched-domain:
[ 3174.420026]  domain 0: span 0-1 level MC
[ 3174.420028]   groups: 0 1
[ 3174.420032] CPU1 attaching sched-domain:
[ 3174.420034]  domain 0: span 0-1 level MC
[ 3174.420037]   groups: 1 0
[ 3174.421029] CPU1 is up
[ 3174.421032] ACPI: Waking up from system sleep state S3
[ 3175.524029] ------------[ cut here ]------------
[ 3175.524032] WARNING: at net/mac80211/iface.c:935 warn_slowpath_null+0x1c/0x20()
[ 3175.524034] Hardware name: 7660A14
[ 3175.524036] Modules linked in: nls_cp437 ntfs vfat msdos fat ext2 aes_generic ath9k rfkill af_packet i915 drm sco bridge stp llc rfcomm bnep l2cap bluetooth ipv6 acpi_cpufreq cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative sbs container pci_slot sbshc snd_hda_codec_analog arc4 ecb snd_hda_intel snd_hda_codec snd_pcm snd_seq mac80211 snd_timer snd_seq_device led_class joydev ath usbhid snd serio_raw hid ac soundcore intel_agp battery cfg80211 video wmi snd_page_alloc pcspkr button processor psmouse evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom crc_t10dif ata_piix ata_generic pata_acpi ehci_hcd uhci_hcd libata scsi_mod usbcore thermal fan fuse e1000e [last unloaded: ath5k]
[ 3175.524092] Pid: 5567, comm: phy1 Tainted: G        W  2.6.30-rc5-wl #89
[ 3175.524094] Call Trace:
[ 3175.524100]  [<c04edd84>] ? printk+0x18/0x1c
[ 3175.524103]  [<c02315eb>] warn_slowpath_fmt+0x7b/0xd0
[ 3175.524107]  [<c022d00f>] ? update_curr+0x21f/0x230
[ 3175.524110]  [<c022d116>] ? dequeue_entity+0x16/0x2c0
[ 3175.524114]  [<c022d428>] ? dequeue_task_fair+0x68/0x70
[ 3175.524117]  [<c021f00a>] ? dequeue_task+0x10a/0x160
[ 3175.524121]  [<c023165c>] warn_slowpath_null+0x1c/0x20
[ 3175.524138]  [<f85cb06b>] __ieee80211_recalc_idle+0x14b/0x160 [mac80211]
[ 3175.524152]  [<f85cb0a7>] ieee80211_recalc_idle+0x27/0x50 [mac80211]
[ 3175.524165]  [<f85caa8f>] ieee80211_sta_work+0xdf/0x570 [mac80211]
[ 3175.524169]  [<c023b571>] ? add_timer+0x11/0x20
[ 3175.524172]  [<c0242d5b>] ? queue_delayed_work_on+0x9b/0xd0
[ 3175.524182]  [<c02423c3>] worker_thread+0x143/0x210
[ 3175.524185]  [<c021fa28>] ? __wake_up_common+0x48/0x70
[ 3175.524200]  [<f85ca9b0>] ? ieee80211_sta_work+0x0/0x570 [mac80211]
[ 3175.524204]  [<c0246230>] ? autoremove_wake_function+0x0/0x50
[ 3175.524211]  [<c0242280>] ? worker_thread+0x0/0x210
[ 3175.524214]  [<c0245ec6>] kthread+0x46/0x80
[ 3175.524217]  [<c0245e80>] ? kthread+0x0/0x80
[ 3175.524221]  [<c0203a8f>] kernel_thread_helper+0x7/0x18
[ 3175.524224] ---[ end trace 0c9ec377fc490a15 ]---
[ 3175.524228] wlan2: beacon loss from AP 00:0b:85:5b:8d:6c - sending probe request
[ 3175.700200] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900403)
[ 3175.700230] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
[ 3175.700243] pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[ 3175.700257] pci 0000:00:03.0: restoring config space at offset 0x1 (was 0x180006, writing 0x100006)
[ 3175.700272] pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
[ 3175.700286] pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00004, writing 0xb00001)
[ 3175.700301] serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20b)
[ 3175.700459] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[ 3175.900092] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[ 3175.900143] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[ 3175.900212] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[ 3175.900308] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100106, writing 0x100102)
[ 3175.900402] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
[ 3175.900422] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[ 3175.900570] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[ 3175.900704] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0x20004040, writing 0x4040)
[ 3175.900733] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[ 3175.900864] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20005050, writing 0x5050)
[ 3175.900891] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[ 3175.901016] pcieport-driver 0000:00:1c.4: restoring config space at offset 0x7 (was 0x20006060, writing 0x6060)
[ 3175.901036] pcieport-driver 0000:00:1c.4: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[ 3175.932093] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[ 3175.932143] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[ 3175.932201] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[ 3175.964093] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[ 3175.964143] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[ 3175.964222] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[ 3175.964307] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100005, writing 0x100007)
[ 3175.964473] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00005, writing 0x2b80005)
[ 3175.964611] pci 0000:03:00.0: restoring config space at offset 0x1 (was 0x100107, writing 0x100103)
[ 3175.964868] ath9k 0000:16:00.0: restoring config space at offset 0xf (was 0xffffffff, writing 0x110)
[ 3175.964878] ath9k 0000:16:00.0: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
[ 3175.964889] ath9k 0000:16:00.0: restoring config space at offset 0xd (was 0xffffffff, writing 0x40)
[ 3175.964899] ath9k 0000:16:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
[ 3175.964908] ath9k 0000:16:00.0: restoring config space at offset 0xb (was 0xffffffff, writing 0x1072168c)
[ 3175.964918] ath9k 0000:16:00.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
[ 3175.964928] ath9k 0000:16:00.0: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
[ 3175.964937] ath9k 0000:16:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
[ 3175.964947] ath9k 0000:16:00.0: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
[ 3175.964957] ath9k 0000:16:00.0: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
[ 3175.964966] ath9k 0000:16:00.0: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
[ 3175.964974] ath9k 0000:16:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0x40000000)
[ 3175.964985] ath9k 0000:16:00.0: restoring config space at offset 0x3 (was 0xffffffff, writing 0xa810)
[ 3175.964995] ath9k 0000:16:00.0: restoring config space at offset 0x2 (was 0xffffffff, writing 0x2800001)
[ 3175.965002] ath9k 0000:16:00.0: restoring config space at offset 0x1 (was 0xffffffff, writing 0x2b00006)
[ 3175.965011] ath9k 0000:16:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x23168c)
[ 3176.938085] pci 0000:00:02.0: PME# disabled
[ 3176.938091] pci 0000:00:02.1: PME# disabled
[ 3176.938095] pci 0000:00:03.0: PME# disabled
[ 3176.938098] pci 0000:00:03.2: PME# disabled
[ 3176.938236] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 3176.938238] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[ 3176.938248] e1000e 0000:00:19.0: setting latency timer to 64
[ 3176.938255] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 3176.938260] e1000e 0000:00:19.0: PME# disabled
[ 3176.938262] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[ 3176.938268] e1000e 0000:00:19.0: PME# disabled
[ 3176.938356] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[ 3177.218415] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[ 3177.218427] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3177.218460] usb usb1: root hub lost power or was reset
[ 3177.218541] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[ 3177.218549] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[ 3177.218581] usb usb2: root hub lost power or was reset
[ 3177.218673] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3177.218678] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[ 3177.218689] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[ 3177.218702] ehci_hcd 0000:00:1a.7: PME# disabled
[ 3177.218812] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 3177.218823] HDA Intel 0000:00:1b.0: setting latency timer to 64
[ 3177.218851] pciehp 0000:00:1c.3:pcie04: pciehp_resume ENTRY
[ 3177.218911] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3177.218922] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3177.218954] usb usb3: root hub lost power or was reset
[ 3177.219020] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 3177.219033] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[ 3177.219059] usb usb5: root hub lost power or was reset
[ 3177.219134] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[ 3177.219142] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[ 3177.219171] usb usb7: root hub lost power or was reset
[ 3177.219274] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3177.219280] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[ 3177.219291] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[ 3177.219302] ehci_hcd 0000:00:1d.7: PME# disabled
[ 3177.219319] pci 0000:00:1e.0: setting latency timer to 64
[ 3177.219379] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00005, writing 0x2b80005)
[ 3177.219403] ata_piix 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[ 3177.219413] ata_piix 0000:00:1f.2: setting latency timer to 64
[ 3177.221121] pci 0000:03:00.0: PME# disabled
[ 3177.385008] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[ 3177.385011] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 3177.385284] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[ 3177.385561] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[ 3177.401186] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[ 3177.401189] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[ 3177.401192] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[ 3177.401195] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 3177.401575] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[ 3177.401577] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[ 3177.408783] ata2.00: configured for UDMA/33
[ 3177.424691] ata1.00: configured for UDMA/133
[ 3177.448684] ata1.00: configured for UDMA/133
[ 3177.448686] ata1: EH complete
[ 3177.524079] ------------[ cut here ]------------
[ 3177.524082] WARNING: at net/mac80211/iface.c:935 warn_slowpath_null+0x1c/0x20()
[ 3177.524083] Hardware name: 7660A14
[ 3177.524085] Modules linked in: nls_cp437 ntfs vfat msdos fat ext2 aes_generic ath9k rfkill af_packet i915 drm sco bridge stp llc rfcomm bnep l2cap bluetooth ipv6 acpi_cpufreq cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative sbs container pci_slot sbshc snd_hda_codec_analog arc4 ecb snd_hda_intel snd_hda_codec snd_pcm snd_seq mac80211 snd_timer snd_seq_device led_class joydev ath usbhid snd serio_raw hid ac soundcore intel_agp battery cfg80211 video wmi snd_page_alloc pcspkr button processor psmouse evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom crc_t10dif ata_piix ata_generic pata_acpi ehci_hcd uhci_hcd libata scsi_mod usbcore thermal fan fuse e1000e [last unloaded: ath5k]
[ 3177.524144] Pid: 5567, comm: phy1 Tainted: G        W  2.6.30-rc5-wl #89
[ 3177.524145] Call Trace:
[ 3177.524151]  [<c04edd84>] ? printk+0x18/0x1c
[ 3177.524154]  [<c02315eb>] warn_slowpath_fmt+0x7b/0xd0
[ 3177.524157]  [<c022d00f>] ? update_curr+0x21f/0x230
[ 3177.524160]  [<c022d116>] ? dequeue_entity+0x16/0x2c0
[ 3177.524164]  [<c02219a7>] ? set_next_entity+0xa7/0x190
[ 3177.524167]  [<c023165c>] warn_slowpath_null+0x1c/0x20
[ 3177.524183]  [<f85cb06b>] __ieee80211_recalc_idle+0x14b/0x160 [mac80211]
[ 3177.524196]  [<f85cb0a7>] ieee80211_recalc_idle+0x27/0x50 [mac80211]
[ 3177.524208]  [<f85caa8f>] ieee80211_sta_work+0xdf/0x570 [mac80211]
[ 3177.524211]  [<c023b571>] ? add_timer+0x11/0x20
[ 3177.524214]  [<c0242d5b>] ? queue_delayed_work_on+0x9b/0xd0
[ 3177.524223]  [<c02423c3>] worker_thread+0x143/0x210
[ 3177.524226]  [<c021fa28>] ? __wake_up_common+0x48/0x70
[ 3177.524239]  [<f85ca9b0>] ? ieee80211_sta_work+0x0/0x570 [mac80211]
[ 3177.524243]  [<c0246230>] ? autoremove_wake_function+0x0/0x50
[ 3177.524250]  [<c0242280>] ? worker_thread+0x0/0x210
[ 3177.524252]  [<c0245ec6>] kthread+0x46/0x80
[ 3177.524255]  [<c0245e80>] ? kthread+0x0/0x80
[ 3177.524258]  [<c0203a8f>] kernel_thread_helper+0x7/0x18
[ 3177.524260] ---[ end trace 0c9ec377fc490a16 ]---
[ 3177.524264] wlan2: no probe response from AP 00:0b:85:5b:8d:6c - disassociating
[ 3177.524327] ------------[ cut here ]------------
[ 3177.524329] WARNING: at net/mac80211/iface.c:935 warn_slowpath_null+0x1c/0x20()
[ 3177.524330] Hardware name: 7660A14
[ 3177.524331] Modules linked in: nls_cp437 ntfs vfat msdos fat ext2 aes_generic ath9k rfkill af_packet i915 drm sco bridge stp llc rfcomm bnep l2cap bluetooth ipv6 acpi_cpufreq cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative sbs container pci_slot sbshc snd_hda_codec_analog arc4 ecb snd_hda_intel snd_hda_codec snd_pcm snd_seq mac80211 snd_timer snd_seq_device led_class joydev ath usbhid snd serio_raw hid ac soundcore intel_agp battery cfg80211 video wmi snd_page_alloc pcspkr button processor psmouse evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom crc_t10dif ata_piix ata_generic pata_acpi ehci_hcd uhci_hcd libata scsi_mod usbcore thermal fan fuse e1000e [last unloaded: ath5k]
[ 3177.524373] Pid: 5567, comm: phy1 Tainted: G        W  2.6.30-rc5-wl #89
[ 3177.524375] Call Trace:
[ 3177.524377]  [<c04edd84>] ? printk+0x18/0x1c
[ 3177.524380]  [<c02315eb>] warn_slowpath_fmt+0x7b/0xd0
[ 3177.524390]  [<f81808fa>] ? ath_txq_update+0xba/0xf0 [ath9k]
[ 3177.524394]  [<c04670bc>] ? skb_dequeue+0x4c/0x70
[ 3177.524403]  [<f8178d35>] ? ath9k_conf_tx+0x105/0x160 [ath9k]
[ 3177.524406]  [<c023165c>] warn_slowpath_null+0x1c/0x20
[ 3177.524420]  [<f85cb06b>] __ieee80211_recalc_idle+0x14b/0x160 [mac80211]
[ 3177.524432]  [<f85cb0a7>] ieee80211_recalc_idle+0x27/0x50 [mac80211]
[ 3177.524445]  [<f85c79e1>] ieee80211_set_disassoc+0x181/0x2a0 [mac80211]
[ 3177.524457]  [<f85c874c>] ieee80211_associated+0x13c/0x180 [mac80211]
[ 3177.524469]  [<f85cacf4>] ieee80211_sta_work+0x344/0x570 [mac80211]
[ 3177.524472]  [<c023b571>] ? add_timer+0x11/0x20
[ 3177.524474]  [<c0242d5b>] ? queue_delayed_work_on+0x9b/0xd0
[ 3177.524482]  [<c02423c3>] worker_thread+0x143/0x210
[ 3177.524485]  [<c021fa28>] ? __wake_up_common+0x48/0x70
[ 3177.524499]  [<f85ca9b0>] ? ieee80211_sta_work+0x0/0x570 [mac80211]
[ 3177.524502]  [<c0246230>] ? autoremove_wake_function+0x0/0x50
[ 3177.524509]  [<c0242280>] ? worker_thread+0x0/0x210
[ 3177.524511]  [<c0245ec6>] kthread+0x46/0x80
[ 3177.524514]  [<c0245e80>] ? kthread+0x0/0x80
[ 3177.524517]  [<c0203a8f>] kernel_thread_helper+0x7/0x18
[ 3177.524519] ---[ end trace 0c9ec377fc490a17 ]---
[ 3177.524524] phy1: Removed STA 00:0b:85:5b:8d:6c
[ 3177.536245] phy1: Destroyed STA 00:0b:85:5b:8d:6c
[ 3177.932085] pci 0000:15:00.1: PME# disabled
[ 3177.932837] serial 00:0a: activated
[ 3178.460099] sd 0:0:0:0: [sda] Starting disk
[ 3178.692063] usb 1-2: reset full speed USB device using uhci_hcd and address 2
[ 3178.992999] pci 0000:00:02.0: setting latency timer to 64
[ 3178.993982] ath9k 0000:16:00.0: enabling device (0000 -> 0002)
[ 3178.993990] ath9k 0000:16:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3178.994012] ath9k 0000:16:00.0: restoring config space at offset 0xf (was 0x100, writing 0x110)
[ 3178.994046] ath9k 0000:16:00.0: restoring config space at offset 0x4 (was 0x0, writing 0x40000000)
[ 3178.994052] ath9k 0000:16:00.0: restoring config space at offset 0x3 (was 0x0, writing 0xa810)
[ 3178.994063] ath9k 0000:16:00.0: restoring config space at offset 0x1 (was 0x2b00002, writing 0x2b00006)
[ 3179.028361] PM: resume devices took 3.064 seconds
[ 3179.028505] PM: Finishing wakeup.
[ 3179.028507] Restarting tasks ... done.
[ 3181.108801] phy1: device now idle
[ 3181.108814] phy1: device no longer idle - scanning
[ 3183.081870] wlan2: direct probe to AP 00:0b:85:5b:8d:63 try 1
[ 3183.082906] wlan2 direct probe responded
[ 3183.082912] wlan2: authenticate with AP 00:0b:85:5b:8d:63
[ 3183.084726] wlan2: authenticated
[ 3183.084731] wlan2: associate with AP 00:0b:85:5b:8d:63
[ 3183.089011] wlan2: RX ReassocResp from 00:0b:85:5b:8d:63 (capab=0x11 status=0 aid=194)
[ 3183.089024] wlan2: associated
[ 3183.089044] phy1: Allocated STA 00:0b:85:5b:8d:63
[ 3183.089061] phy1: Inserted STA 00:0b:85:5b:8d:63
