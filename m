Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60303 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965287AbeCAA2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 19:28:17 -0500
Date: Thu, 1 Mar 2018 00:28:13 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180301002813.GQ14069@wotan.suse.de> (sfid-20180301_012823_518664_0C70A33D)
References: <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
 <20180225175425.GL14069@wotan.suse.de>
 <20180226182859.03184215@cakuba.netronome.com>
 <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
 <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
 <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com>
 <20180228184820.GL14069@wotan.suse.de>
 <ba4c6079-ca45-2048-1e7d-3cb4e1a80cdb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ba4c6079-ca45-2048-1e7d-3cb4e1a80cdb@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2018 at 11:18:59PM +0200, cantabile wrote:
> On 28/02/18 20:48, Luis R. Rodriguez wrote:
> > On Wed, Feb 28, 2018 at 08:02:59PM +0200, cantabile wrote:
> > > On 27/02/18 22:42, Luis R. Rodriguez wrote:
> > OK so we know that the optimization is optional, not a requirement.
> > That may be worth extending in documentation on the driver.
> 
> I may have spoken too soon. mt7601u kind of exploded after resuming from
> suspend to RAM. Maybe it has nothing to do with this change, but well. The
> system froze after the KDE lock screen appeared, and a few minutes later the
> Caps Lock LED turned on. I attached journalctl output in case it's
> interesting.

Oh well, the optimization is not optional then :P

> Feb 28 22:46:04 home kernel: PM: suspend entry (deep)
> Feb 28 22:46:04 home plasmashell[576]: QXcbClipboard: SelectionRequest too old
> Feb 28 22:46:04 home ksmserver[552]: CreateNotify: 60817442
> Feb 28 22:46:05 home kernel: PM: Syncing filesystems ... done.
> Feb 28 22:46:05 home kernel: firmware_class: device_cache_fw_images
> Feb 28 22:46:05 home kernel: firmware_class: cache_firmware: iwlwifi-3945-2.ucode
> Feb 28 22:46:05 home kernel: firmware_class: __allocate_fw_priv: fw-iwlwifi-3945-2.ucode fw_priv=00000000eb639dd2
> Feb 28 22:46:05 home kernel: firmware_class: cache_firmware: mt7601u.bin
> Feb 28 22:46:05 home kernel: firmware_class: __allocate_fw_priv: fw-mt7601u.bin fw_priv=000000004f840abe
> Feb 28 22:46:05 home kernel: (NULL device *): loading /lib/firmware/updates/4.16.0-rc3-g4edf7856bed8/iwlwifi-3945-2.ucode failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): loading /lib/firmware/updates/iwlwifi-3945-2.ucode failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): loading /lib/firmware/updates/4.16.0-rc3-g4edf7856bed8/mt7601u.bin failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): loading /lib/firmware/4.16.0-rc3-g4edf7856bed8/iwlwifi-3945-2.ucode failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): loading /lib/firmware/updates/mt7601u.bin failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): loading /lib/firmware/4.16.0-rc3-g4edf7856bed8/mt7601u.bin failed with error -2
> Feb 28 22:46:19 home kernel: (NULL device *): direct-loading mt7601u.bin
> Feb 28 22:46:19 home kernel: firmware_class: fw_set_page_data: fw-mt7601u.bin fw_priv=000000004f840abe data=00000000991ae8e7 size=45412
> Feb 28 22:46:19 home kernel: firmware_class: cache_firmware: mt7601u.bin ret=0
> Feb 28 22:46:19 home kernel: (NULL device *): direct-loading iwlwifi-3945-2.ucode
> Feb 28 22:46:19 home kernel: firmware_class: fw_set_page_data: fw-iwlwifi-3945-2.ucode fw_priv=00000000eb639dd2 data=000000009d96fe1e size=150100
> Feb 28 22:46:19 home kernel: firmware_class: cache_firmware: iwlwifi-3945-2.ucode ret=0
> Feb 28 22:46:19 home kernel: Freezing user space processes ... (elapsed 0.002 seconds) done.
> Feb 28 22:46:19 home kernel: OOM killer disabled.
> Feb 28 22:46:19 home kernel: Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> Feb 28 22:46:19 home kernel: Suspending console(s) (use no_console_suspend to debug)
> Feb 28 22:46:19 home kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> Feb 28 22:46:19 home kernel: sd 0:0:0:0: [sda] Stopping disk
> Feb 28 22:46:19 home kernel: e1000e: EEE TX LPI TIMER: 00000000
> Feb 28 22:46:19 home kernel: ACPI: EC: interrupt blocked
> Feb 28 22:46:19 home kernel: ACPI: Preparing to enter system sleep state S3
> Feb 28 22:46:19 home kernel: ACPI: EC: event blocked
> Feb 28 22:46:19 home kernel: ACPI: EC: EC stopped
> Feb 28 22:46:19 home kernel: PM: Saving platform NVS memory
> Feb 28 22:46:19 home kernel: Disabling non-boot CPUs ...
> Feb 28 22:46:19 home kernel: smpboot: CPU 1 is now offline
> Feb 28 22:46:19 home kernel: ACPI: Low-level resume complete
> Feb 28 22:46:19 home kernel: ACPI: EC: EC started

Ok so suspend..


> Feb 28 22:46:19 home kernel: PM: Restoring platform NVS memory
> Feb 28 22:46:19 home kernel: Enabling non-boot CPUs ...
> Feb 28 22:46:19 home kernel: x86: Booting SMP configuration:
> Feb 28 22:46:19 home kernel: smpboot: Booting Node 0 Processor 1 APIC 0x1
> Feb 28 22:46:19 home kernel:  cache: parent cpu1 should not be sleeping
> Feb 28 22:46:19 home kernel: microcode: sig=0x6fd, pf=0x80, revision=0xa3
> Feb 28 22:46:19 home kernel: microcode: updated to revision 0xa4, date = 2010-10-02
> Feb 28 22:46:19 home kernel: CPU1 is up
> Feb 28 22:46:19 home kernel: ACPI: Waking up from system sleep state S3
> Feb 28 22:46:19 home kernel: ACPI: EC: interrupt unblocked
> Feb 28 22:46:19 home kernel: ACPI: EC: event unblocked
> Feb 28 22:46:19 home kernel: ACPI: button: The lid device is not compliant to SW_LID.
> Feb 28 22:46:19 home kernel: usb usb3: root hub lost power or was reset
> Feb 28 22:46:19 home kernel: usb usb4: root hub lost power or was reset
> Feb 28 22:46:19 home kernel: usb usb5: root hub lost power or was reset
> Feb 28 22:46:19 home kernel: usb usb6: root hub lost power or was reset
> Feb 28 22:46:19 home kernel: sd 0:0:0:0: [sda] Starting disk
> Feb 28 22:46:19 home kernel: Firmware already loaded but going to reload

I take it that was a debug print from you?

> Feb 28 22:46:19 home kernel: firmware_class: batched request - sharing the same struct fw_priv and lookup for multiple requests
> Feb 28 22:46:19 home kernel: firmware_class: fw_set_page_data: fw-mt7601u.bin fw_priv=000000004f840abe data=00000000991ae8e7 size=45412

This is interesting. Batched requests are requests we get when we detect there
are multiple request for the same firmware. But come to think of it, that
should also pop up whenever we use firmware caching, given firmware caching
does a fake request, so we cache the firmware locally for a while. So that's
probably why we see that message. In other words I can probably remove the
print for batched requests if the firmware was cached, I believe.

> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Firmware Version: 0.1.00 Build: 7640 Build time: 201302052146____
> Feb 28 22:46:19 home kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd c6/00:01:00:00:00:a0 (SET MULTIPLE MODE) succeeded
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: supports DRM functions and may not be fully accessible
> Feb 28 22:46:19 home kernel: ata1.00: disabling queued TRIM support
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd c6/00:01:00:00:00:a0 (SET MULTIPLE MODE) succeeded
> Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> Feb 28 22:46:19 home kernel: ata1.00: supports DRM functions and may not be fully accessible
> Feb 28 22:46:19 home kernel: ata1.00: disabling queued TRIM support
> Feb 28 22:46:19 home kernel: ata1.00: configured for UDMA/133
> Feb 28 22:46:19 home kernel: usb 4-2: reset full-speed USB device number 2 using uhci_hcd
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Error: MCU response pre-completed!

An issue immediately. So it should mean the firmware load didn't likely work
correctly.

> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Error: MCU resp evt:0 seq:7-6!
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Warning: mt7601u_mcu_wait_resp retrying
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Warning: mt7601u_mcu_wait_resp retrying
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Warning: mt7601u_mcu_wait_resp retrying
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Warning: mt7601u_mcu_wait_resp retrying
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Error: mt7601u_mcu_wait_resp timed out
> Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: resume error -110

It may be good to figure out where that happened on the driver, likely
after calling mt7601u_mcu_wait_resp() :)  and the return value of -110
should help more.

> Feb 28 22:46:19 home kernel: acpi LNXPOWER:01: Turning OFF
> Feb 28 22:46:19 home kernel: acpi LNXPOWER:00: Turning OFF
> Feb 28 22:46:19 home kernel: OOM killer enabled.
> Feb 28 22:46:19 home kernel: Restarting tasks ... 
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: pci 0000:00:1e.0: PCI bridge to [bus 02]
> Feb 28 22:46:19 home kernel: acpi PNP0501:00: Still not present
> Feb 28 22:46:19 home kernel: done.
> Feb 28 22:46:19 home kernel: usb 3-1: USB disconnect, device number 2
> Feb 28 22:46:19 home kernel: video LNXVIDEO:00: Restoring backlight state
> Feb 28 22:46:19 home kernel: PM: suspend exit
> Feb 28 22:46:19 home kernel: usb 3-1: new full-speed USB device number 3 using uhci_hcd
> Feb 28 22:46:19 home kernel: e1000e: enp0s25 NIC Link is Down
> Feb 28 22:46:19 home kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
> Feb 28 22:46:19 home plasmashell[576]: Time engine Clock skew signaled
> Feb 28 22:46:19 home systemd-sleep[14720]: System resumed.
> Feb 28 22:46:19 home bluetoothd[348]: LEAdvertisingManager skipped, LE unavailable
> Feb 28 22:46:19 home krunner[574]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home org_kde_powerdevil[593]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home kdeinit5[532]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home plasmashell[576]: QXcbClipboard: SelectionRequest too old
> Feb 28 22:46:19 home plasmashell[576]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home plasmashell[576]: QXcbClipboard: SelectionRequest too old
> Feb 28 22:46:19 home systemd[1]: Starting Load/Save RF Kill Switch Status...
> Feb 28 22:46:19 home upowerd[460]: unhandled action 'unbind' on /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1
> Feb 28 22:46:19 home systemd[1]: Started Suspend.

Oh another suspend? Or is this just noise from systemd?

> Feb 28 22:46:19 home systemd[1]: sleep.target: Unit not needed anymore. Stopping.
> Feb 28 22:46:19 home systemd[1]: Stopped target Sleep.
> Feb 28 22:46:19 home systemd[1]: Reached target Suspend.
> Feb 28 22:46:19 home systemd[1]: suspend.target: Unit not needed anymore. Stopping.
> Feb 28 22:46:19 home systemd[1]: Stopped target Suspend.
> Feb 28 22:46:19 home systemd-logind[371]: Operation 'sleep' finished.
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
> Feb 28 22:46:19 home NetworkManager[363]: <info>  [1519850779.7757] manager: sleep: wake requested (sleeping: yes  enabled: yes)
> Feb 28 22:46:19 home NetworkManager[363]: <info>  [1519850779.7759] device (enp0s25): state change: unavailable -> unmanaged (reason 'sleeping', sys-iface-state: 'managed')
> Feb 28 22:46:19 home systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
> Feb 28 22:46:19 home systemd[1]: Stopped target Bluetooth.
> Feb 28 22:46:19 home org_kde_powerdevil[593]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home kdeinit5[532]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home krunner[574]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home kdeinit5[532]: bluedevil: About to resume
> Feb 28 22:46:19 home krunner[574]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home upowerd[460]: unhandled action 'unbind' on /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0
> Feb 28 22:46:19 home kdeinit5[532]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home plasmashell[576]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home upowerd[460]: unhandled action 'unbind' on /sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1
> Feb 28 22:46:19 home systemd-rfkill[14810]: Failed to open device rfkill0: No such device
> Feb 28 22:46:19 home systemd[1]: Started Load/Save RF Kill Switch Status.
> Feb 28 22:46:19 home plasmashell[576]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home org_kde_powerdevil[593]: UdevQt: unhandled device action "unbind"
> Feb 28 22:46:19 home NetworkManager[363]: <info>  [1519850779.8835] device (enp0s25): state change: unmanaged -> unavailable (reason 'managed', sys-iface-state: 'managed')
> Feb 28 22:46:20 home NetworkManager[363]: <info>  [1519850780.1136] device (wlp16s0): state change: unmanaged -> unavailable (reason 'managed', sys-iface-state: 'managed')
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp16s0: link is not ready
> Feb 28 22:46:20 home org_kde_powerdevil[593]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home plasmashell[576]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home krunner[574]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home kdeinit5[532]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home systemd[1]: Reached target Bluetooth.
> Feb 28 22:46:20 home org_kde_powerdevil[593]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home krunner[574]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home plasmashell[576]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home kdeinit5[532]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home krunner[574]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home plasmashell[576]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home org_kde_powerdevil[593]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp16s0: link is not ready
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u3: link is not ready
> Feb 28 22:46:20 home kdeinit5[532]: UdevQt: unhandled device action "bind"
> Feb 28 22:46:20 home NetworkManager[363]: <info>  [1519850780.2619] device (wlp0s29f7u3): state change: unmanaged -> unavailable (reason 'managed', sys-iface-state: 'managed')

Hrm. Its not clear to me if this was from resume or an action
brought on by a new suspend.

> Feb 28 22:46:20 home kernel: mt7601u 2-3:1.0: Error: MCU response pre-completed!

Either way the 802.11 device is barfing.

> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]

And if its a race between suspend/resume it may be a driver issue.
Try to reproduce without the changes which disable the optimization.

If you can reproduce that's an upstream issue.

If not, it can be a race with opting out of the optimiziation, but still, to
create a crash seems bad and I would expect this crash to be a driver issue.
If the device misbehaves for whatever reason it should not crash the system.

And since no debug info is available we ca't do much more to look at this
issue. You can recompile with debugging symbols enabled (look online), and
it may help further.

  Luis

> Feb 28 22:46:20 home kernel: mt7601u 2-3:1.0: Error: MCU resp evt:0 seq:8-0!
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07600787570 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: ffff9fc553053520 RCX: 000000000000000a
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1e79700 R11: 0000000000000000 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x1a/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2b9 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07600787570 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: ffff9fc553053520 RCX: 0000000000000020
> Feb 28 22:46:20 home kernel: RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1e79700 R11: 0000000000000000 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x2e/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2ba ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:67 mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07600787540 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 0000000000000080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1e79700 R11: 0000000000000000 R12: 0000000000000000
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053520 R14: 0000000000000080 R15: 0000000000000004
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_rf_rmw+0x2a/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x45/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 49 39 d5 75 ab 48 c1 e9 0e 83 e1 0f 49 39 ce 75 9f 0f b6 c0 66 66 66 66 90 4c 89 ff 89 44 24 04 e8 25 aa e3 c9 8b 44 24 04 eb ad <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2bb ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07600787550 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: 0000000000000018 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000018 RSI: 0000000000000004 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 0000000000000000 R09: ffff9fc5ae1e4218
> Feb 28 22:46:20 home kernel: R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
> Feb 28 22:46:20 home kernel: R13: 0000000000000000 R14: ffff9fc553053520 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_rmc+0x20/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_set_bw+0x32/0xf0 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2eb/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2bc ]---
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0000:ffffb07600787568 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: 0000000000000020 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000020 RSI: 0000000000000004 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000004 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1240980 R11: 0000000000000000 R12: 0000000000000000
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053520 R14: ffff9fc59ec67eb8 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_rmw+0x22/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x334/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2bd ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 363 at drivers/net/wireless/mediatek//mt7601u/phy.c:132 mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 363 Comm: NetworkManager Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0000:ffffb07600787590 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 00000000000000ff RSI: 00000000000000b2 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1240980 R11: 0000000000000000 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: ffff9fc59ec67eb8 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  00007fba0753d880(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb1ed708 CR3: 000000007477e000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x346/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_do_open+0x545/0x830 [mac80211]
> Feb 28 22:46:20 home kernel:  ? ieee80211_check_concurrent_iface+0x166/0x1d0 [mac80211]
> Feb 28 22:46:20 home kernel:  __dev_open+0xd5/0x170
> Feb 28 22:46:20 home kernel:  __dev_change_flags+0x173/0x1c0
> Feb 28 22:46:20 home kernel:  dev_change_flags+0x23/0x60
> Feb 28 22:46:20 home kernel:  do_setlink+0x2be/0xe50
> Feb 28 22:46:20 home kernel:  ? __nla_reserve+0x38/0x50
> Feb 28 22:46:20 home kernel:  ? __nla_put+0xc/0x20
> Feb 28 22:46:20 home kernel:  ? __local_bh_enable_ip+0x5b/0x60
> Feb 28 22:46:20 home kernel:  ? inet6_fill_ifla6_attrs+0x466/0x480
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  rtnl_newlink+0x5f3/0x940
> Feb 28 22:46:20 home kernel:  ? sock_def_readable+0xe/0x80
> Feb 28 22:46:20 home kernel:  ? __netlink_sendskb+0x3d/0x50
> Feb 28 22:46:20 home kernel:  ? print_prefix+0x150/0x190
> Feb 28 22:46:20 home kernel:  ? vt_console_print+0x247/0x420
> Feb 28 22:46:20 home kernel:  ? cap_inode_getsecurity+0x230/0x230
> Feb 28 22:46:20 home kernel:  ? security_capable+0x47/0x60
> Feb 28 22:46:20 home kernel:  rtnetlink_rcv_msg+0x136/0x330
> Feb 28 22:46:20 home kernel:  ? rtnl_calcit.isra.28+0x120/0x120
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? addrconf_sysctl_forward+0x113/0x250
> Feb 28 22:46:20 home kernel:  ? dev_forward_change+0x130/0x130
> Feb 28 22:46:20 home kernel:  ? sysctl_head_finish.part.22+0x31/0x40
> Feb 28 22:46:20 home kernel:  ? proc_sys_call_handler+0x8b/0xf0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fba04d4cb04
> Feb 28 22:46:20 home kernel: RSP: 002b:00007fffe0c48050 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 00007fffe0c480a0 RCX: 00007fba04d4cb04
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007fffe0c480a0 RDI: 0000000000000007
> Feb 28 22:46:20 home kernel: RBP: 00005578ac2e0750 R08: 0000000000000000 R09: 00007fba04abab20
> Feb 28 22:46:20 home kernel: R10: 00005578ac08b010 R11: 0000000000000293 R12: 00005578ac0bf500
> Feb 28 22:46:20 home kernel: R13: 00007fffe0c480a0 R14: 00007fffe0c48224 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: Code: 66 66 66 66 90 5b 4c 89 ff 5d 41 5c 41 5d 41 5e 41 5f e9 2e a4 e3 c9 48 8b 7b 08 89 ea 48 c7 c6 98 9e 86 c0 e8 1c 5d c4 c9 eb da <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 65 8b 05 56 c7 7a 3f 89 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2be ]---
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u3: link is not ready
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp16s0: link is not ready
> Feb 28 22:46:20 home kernel: IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u3: link is not ready
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 395 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 395 Comm: wpa_supplicant Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb076007efa08 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000008 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: ffff9fc5530530c0 RSI: 0000000000000042 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc5424f6200 R08: ffff9fc5530548c0 R09: ffff9fc5424f6200
> Feb 28 22:46:20 home kernel: R10: 0000000000000600 R11: 0000000000000040 R12: ffff9fc5530548c0
> Feb 28 22:46:20 home kernel: R13: ffff9fc553055160 R14: ffff9fc5530530c0 R15: ffff9fc5424f6200
> Feb 28 22:46:20 home kernel: FS:  00007fa6a2726f80(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5eb9d074c0 CR3: 00000000733e6000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? enqueue_entity+0x106/0x650
> Feb 28 22:46:20 home kernel:  mt7601u_agc_save+0x13/0x20 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_sw_scan+0x12/0x20 [mt7601u]
> Feb 28 22:46:20 home kernel:  __ieee80211_start_scan+0x42f/0x750 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_request_scan+0x2b/0x50 [mac80211]
> Feb 28 22:46:20 home kernel:  nl80211_trigger_scan+0x61c/0x7b0 [cfg80211]
> Feb 28 22:46:20 home kernel:  genl_family_rcv_msg+0x1e4/0x390
> Feb 28 22:46:20 home kernel:  ? ___slab_alloc+0xf3/0x4a0
> Feb 28 22:46:20 home kernel:  genl_rcv_msg+0x47/0x90
> Feb 28 22:46:20 home kernel:  ? __kmalloc_node_track_caller+0x31/0x2d0
> Feb 28 22:46:20 home kernel:  ? genl_family_rcv_msg+0x390/0x390
> Feb 28 22:46:20 home kernel:  netlink_rcv_skb+0x4d/0x130
> Feb 28 22:46:20 home kernel:  genl_rcv+0x24/0x40
> Feb 28 22:46:20 home kernel:  netlink_unicast+0x196/0x230
> Feb 28 22:46:20 home kernel:  netlink_sendmsg+0x2a9/0x3a0
> Feb 28 22:46:20 home kernel:  ? netlink_unicast+0x230/0x230
> Feb 28 22:46:20 home kernel:  ___sys_sendmsg+0x2bf/0x320
> Feb 28 22:46:20 home kernel:  ? __set_current_blocked+0x3d/0x60
> Feb 28 22:46:20 home kernel:  ? signal_setup_done+0x67/0xb0
> Feb 28 22:46:20 home kernel:  ? do_signal+0x194/0x610
> Feb 28 22:46:20 home kernel:  ? __fpu__restore_sig+0x7b/0x4d0
> Feb 28 22:46:20 home kernel:  ? __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  __sys_sendmsg+0x51/0x90
> Feb 28 22:46:20 home kernel:  do_syscall_64+0x67/0x120
> Feb 28 22:46:20 home kernel:  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Feb 28 22:46:20 home kernel: RIP: 0033:0x7fa6a131a097
> Feb 28 22:46:20 home kernel: RSP: 002b:00007ffff747e338 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> Feb 28 22:46:20 home kernel: RAX: ffffffffffffffda RBX: 000055b78ebf0260 RCX: 00007fa6a131a097
> Feb 28 22:46:20 home kernel: RDX: 0000000000000000 RSI: 00007ffff747e370 RDI: 0000000000000005
> Feb 28 22:46:20 home kernel: RBP: 000055b78ec1f910 R08: 0000000000000000 R09: 00007fa6a15d4ff0
> Feb 28 22:46:20 home kernel: R10: 000055b78ebe7010 R11: 0000000000000246 R12: 000055b78ebf0170
> Feb 28 22:46:20 home kernel: R13: 00007ffff747e370 R14: 0000000000000000 R15: 000055b78ec0f098
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2bf ]---
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: WARNING: CPU: 1 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 1 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0000:ffffb07601777cc0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 000000000000000a
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1add200 R11: 0000000000000000 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5beb00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 000055c5e5cf0810 CR3: 0000000062eb4000 CR4: 00000000000006e0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x1a/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c0 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 1 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 1 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0000:ffffb07601777cc0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000020
> Feb 28 22:46:20 home kernel: RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1add200 R11: 0000000000000000 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5beb00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 000055c5e5cf0810 CR3: 0000000062eb4000 CR4: 00000000000006e0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x2e/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c1 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 1 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:67 mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 1 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0000:ffffb07601777c90 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 0000000000000080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1add200 R11: 0000000000000000 R12: 0000000000000000
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053520 R14: 0000000000000080 R15: 0000000000000004
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5beb00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 000055c5e5cf0810 CR3: 0000000062eb4000 CR4: 00000000000006e0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_rf_rmw+0x2a/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x45/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 49 39 d5 75 ab 48 c1 e9 0e 83 e1 0f 49 39 ce 75 9f 0f b6 c0 66 66 66 66 90 4c 89 ff 89 44 24 04 e8 25 aa e3 c9 8b 44 24 04 eb ad <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c2 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777ca0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: 0000000000000018 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000018 RSI: 0000000000000004 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 00000a5e637b2400 R09: ffff9fc5bb89c458
> Feb 28 22:46:20 home kernel: R10: 0000000000000000 R11: 0000000000000513 R12: 0000000000000004
> Feb 28 22:46:20 home kernel: R13: 0000000000000000 R14: ffff9fc553053520 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb0b3d08 CR3: 0000000033cb6000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_rmc+0x20/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_set_bw+0x32/0xf0 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2eb/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c3 ]---
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777cb8 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: 0000000000000020 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000020 RSI: 0000000000000004 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000004 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc0093d80 R11: 0000000000000513 R12: 0000000000000000
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053520 R14: ffff9fc59ec67eb8 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb0b3d08 CR3: 0000000033cb6000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_rmw+0x22/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x334/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c4 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:132 mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777ce0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 00000000000000ff RSI: 00000000000000b2 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc0093d80 R11: 0000000000000513 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: ffff9fc59ec67eb8 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb0b3d08 CR3: 0000000033cb6000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x346/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 66 66 66 66 90 5b 4c 89 ff 5d 41 5c 41 5d 41 5e 41 5f e9 2e a4 e3 c9 48 8b 7b 08 89 ea 48 c7 c6 98 9e 86 c0 e8 1c 5d c4 c9 eb da <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 65 8b 05 56 c7 7a 3f 89 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c5 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:132 mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_wr+0xb6/0x130 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777ce0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000034 RSI: 0000000000000042 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000024040 R09: ffffffffc00bcbfe
> Feb 28 22:46:20 home kernel: R10: fffffb9dc1e84600 R11: 00000000000001e4 R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: ffff9fc59ec67eb8 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5ebb0b3d08 CR3: 0000000033cb6000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x502/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 66 66 66 66 90 5b 4c 89 ff 5d 41 5c 41 5d 41 5e 41 5f e9 2e a4 e3 c9 48 8b 7b 08 89 ea 48 c7 c6 98 9e 86 c0 e8 1c 5d c4 c9 eb da <0f> 0b 5b 5d 41 5c 41 5d 41 5e 41 5f c3 65 8b 05 56 c7 7a 3f 89 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c6 ]---
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: mt7601u 2-3:1.0: Error: TX urb submit failed:-1
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777cc0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 000000000000000a
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc0093d80 R11: 000000000000005c R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5eb9d06e60 CR3: 000000001800a000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x1a/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c7 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:31 mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_wr+0x10f/0x1b0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777cc0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000020
> Feb 28 22:46:20 home kernel: RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: ffff9fc553052778 R08: 0000000000026080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc0093d80 R11: 000000000000005c R12: ffff9fc59ec67eb8
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053b70 R14: 0000000000000000 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5eb9d06e60 CR3: 000000001800a000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  ? mt7601u_write_reg_pairs+0xcf/0x110 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x2e/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 89 e9 44 89 ea 41 b8 92 ff ff ff 48 c7 c6 10 9e 86 c0 e8 15 65 c4 c9 48 83 c4 10 b8 92 ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 83 c4 10 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c8 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:67 mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_rf_rr+0x141/0x1d0 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777c90 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: ffff9fc553053520 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 0000000000000080 R09: ffffffffc085d34a
> Feb 28 22:46:20 home kernel: R10: fffffb9dc0093d80 R11: 000000000000005c R12: 0000000000000000
> Feb 28 22:46:20 home kernel: R13: ffff9fc553053520 R14: 0000000000000080 R15: 0000000000000004
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5eb9d06e60 CR3: 000000001800a000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_rf_rmw+0x2a/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_vco_cal+0x45/0x50 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2df/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 49 39 d5 75 ab 48 c1 e9 0e 83 e1 0f 49 39 ce 75 9f 0f b6 c0 66 66 66 66 90 4c 89 ff 89 44 24 04 e8 25 aa e3 c9 8b 44 24 04 eb ad <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e 41 5f 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2c9 ]---
> Feb 28 22:46:20 home kernel: WARNING: CPU: 0 PID: 14772 at drivers/net/wireless/mediatek//mt7601u/phy.c:157 mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: Modules linked in: hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_pcm snd_timer snd_rawmidi snd_seq_device usbhid snd hid soundcore ccm rfcomm bnep cpufreq_conservative msr i915 arc4 mousedev iTCO_wdt iTCO_vendor_support hp_wmi wmi_bmof sparse_keymap mt7601u(O) iwl3945 iwlegacy btusb btrtl btbcm mac80211 btintel ext4 mbcache jbd2 coretemp fscrypto bluetooth i2c_algo_bit psmouse evdev input_leds led_class ecdh_generic drm_kms_helper crc16 cfg80211 e1000e drm lpc_ich rfkill shpchp ptp pps_core syscopyarea sysfillrect sysimgblt fb_sys_fops intel_agp intel_gtt agpgart wmi battery fan thermal acpi_cpufreq video ac button sch_fq_codel sg crypto_user ip_tables x_tables xfs libcrc32c crc32c_generic sd_mod serio_raw atkbd libps2 uhci_hcd ahci libahci libata ehci_pci ehci_hcd scsi_mod
> Feb 28 22:46:20 home kernel:  usbcore usb_common i8042 serio
> Feb 28 22:46:20 home kernel: CPU: 0 PID: 14772 Comm: kworker/u4:52 Tainted: G        W  O     4.16.0-rc3-g4edf7856bed8 #10
> Feb 28 22:46:20 home kernel: Hardware name: Hewlett-Packard HP Compaq 6720s/30D8, BIOS 68MDU Ver. F.0B 06/20/2008
> Feb 28 22:46:20 home kernel: Workqueue: phy3 ieee80211_scan_work [mac80211]
> Feb 28 22:46:20 home kernel: RIP: 0010:mt7601u_bbp_rr+0xf7/0x170 [mt7601u]
> Feb 28 22:46:20 home kernel: RSP: 0018:ffffb07601777ca0 EFLAGS: 00010246
> Feb 28 22:46:20 home kernel: RAX: 0000000000000018 RBX: 0000000000000018 RCX: 0000000000000000
> Feb 28 22:46:20 home kernel: RDX: 0000000000000018 RSI: 0000000000000004 RDI: ffff9fc553053520
> Feb 28 22:46:20 home kernel: RBP: 0000000000000000 R08: 00000a5e680d0400 R09: 0000000000000000
> Feb 28 22:46:20 home kernel: R10: 0000000000000000 R11: 00000000000004d7 R12: 0000000000000004
> Feb 28 22:46:20 home kernel: R13: 0000000000000000 R14: ffff9fc553053520 R15: 0000000000000000
> Feb 28 22:46:20 home kernel: FS:  0000000000000000(0000) GS:ffff9fc5bea00000(0000) knlGS:0000000000000000
> Feb 28 22:46:20 home kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Feb 28 22:46:20 home kernel: CR2: 00007f5eb9d06e60 CR3: 000000001800a000 CR4: 00000000000006f0
> Feb 28 22:46:20 home kernel: Call Trace:
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_rmc+0x20/0x60 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_bbp_set_bw+0x32/0xf0 [mt7601u]
> Feb 28 22:46:20 home kernel:  mt7601u_phy_set_channel+0x2eb/0x560 [mt7601u]
> Feb 28 22:46:20 home kernel:  ? __ieee80211_stop_queue+0x10b/0x190 [mac80211]
> Feb 28 22:46:20 home kernel:  mt7601u_config+0x54/0x70 [mt7601u]
> Feb 28 22:46:20 home kernel:  ieee80211_hw_config+0x1ca/0x3a0 [mac80211]
> Feb 28 22:46:20 home kernel:  ieee80211_scan_work+0x211/0x4d0 [mac80211]
> Feb 28 22:46:20 home kernel:  process_one_work+0x1d4/0x3f0
> Feb 28 22:46:20 home kernel:  worker_thread+0x2b/0x3d0
> Feb 28 22:46:20 home kernel:  ? process_one_work+0x3f0/0x3f0
> Feb 28 22:46:20 home kernel:  kthread+0x113/0x130
> Feb 28 22:46:20 home kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Feb 28 22:46:20 home kernel:  ret_from_fork+0x35/0x40
> Feb 28 22:46:20 home kernel: Code: 00 48 89 ef e8 eb 8b ff ff 0f b6 d4 49 39 d4 75 84 0f b6 c0 66 66 66 66 90 4c 89 ef 89 44 24 04 e8 4f a5 e3 c9 8b 44 24 04 eb 8e <0f> 0b 48 83 c4 08 b8 ea ff ff ff 5b 5d 41 5c 41 5d c3 65 8b 15 
> Feb 28 22:46:20 home kernel: ---[ end trace f868add800e4d2ca ]---
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:20 home kernel: Kernel BUG at 00000000dfb7a174 [verbose debug info unavailable]
> Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> Feb 28 22:46:21 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> -- Reboot --


-- 
Luis Rodriguez, SUSE LINUX GmbH
Maxfeldstrasse 5; D-90409 Nuernberg
