Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36058 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932263AbcIRWwc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 18:52:32 -0400
Received: by mail-wm0-f46.google.com with SMTP id w84so48141440wmg.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2016 15:52:31 -0700 (PDT)
MIME-Version: 1.0
From: Steffen Arntz <winrootkit@gmail.com>
Date: Mon, 19 Sep 2016 00:52:10 +0200
Message-ID: <CAMHqqOC5G3w6TnuJp1MWcVpvYkjt5cgpKDwGLi5sEe3-Ud5_HA@mail.gmail.com> (sfid-20160919_005303_264252_2DD2A57F)
Subject: ath10k inoperatable after suspend
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi at all,

I have an QCA988X based card in my laptop and have some "issues" with
it, that I was not experiencing with my previous ath9k based card.

The main issue is, that after suspend to RAM the card seems to be
"hung up" and only reloading ath10k_core and ath10k_pci helps to fix
the problem.

dmesg shows the following info after resuming:
>
> ACPI: Low-level resume complete
> ACPI : EC: EC started
> PM: Restoring platform NVS memory
> Enabling non-boot CPUs ...
> x86: Booting SMP configuration:
> smpboot: Booting Node 0 Processor 1 APIC 0x1
> numa_add_cpu cpu 1 node 0: mask now 0-1
>  cache: parent cpu1 should not be sleeping
> CPU1 is up
> smpboot: Booting Node 0 Processor 2 APIC 0x4
> numa_add_cpu cpu 2 node 0: mask now 0-2
>  cache: parent cpu2 should not be sleeping
> CPU2 is up
> smpboot: Booting Node 0 Processor 3 APIC 0x5
> numa_add_cpu cpu 3 node 0: mask now 0-3
>  cache: parent cpu3 should not be sleeping
> CPU3 is up
> ACPI: Waking up from system sleep state S3
> ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> PM: noirq resume of devices complete after 22.000 msecs
> PM: early resume of devices complete after 2.082 msecs
> tg3 0000:03:00.0: System wakeup disabled by ACPI
> sd 0:0:0:0: [sda] Starting disk
> rtc_cmos 00:01: System wakeup disabled by ACPI
> usb 2-1.6: reset high-speed USB device number 4 using ehci-pci
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: supports DRM functions and may not be fully accessible
> ata1.00: disabling queued TRIM support
> ata1.00: supports DRM functions and may not be fully accessible
> ata1.00: disabling queued TRIM support
> ata1.00: configured for UDMA/133
> psmouse serio4: synaptics: queried max coordinates: x [..5714], y [..5172]
> usb 1-1.5: reset full-speed USB device number 10 using ehci-pci
> usb 1-1.5: device firmware changed
> usb 1-1.4: reset full-speed USB device number 4 using ehci-pci
> usb 1-1.2: reset high-speed USB device number 3 using ehci-pci
> PM: resume of devices complete after 4693.622 msecs
> PM: Finishing wakeup.
> Restarting tasks ... done.
> video LNXVIDEO:00: Restoring backlight state
> usb 1-1.5: USB disconnect, device number 10
> usb 1-1.5: new full-speed USB device number 11 using ehci-pci
> usb 1-1.5: New USB device found, idVendor=0cf3, idProduct=3004
> usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
> IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
> IPv6: ADDRCONF(NETDEV_UP): wlp1s0: link is not ready
> usb 1-1.5: USB disconnect, device number 11
> usb 1-1.5: new full-speed USB device number 12 using ehci-pci
> usb 1-1.5: New USB device found, idVendor=0cf3, idProduct=3004
> usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> wlp1s0: authenticate with 14:cc:20:ec:xx:xx
> ath10k_pci 0000:01:00.0: failed to synchronize setup for vdev 0 restart 0: -110
> ath10k_pci 0000:01:00.0: failed to start vdev 0 addr 1c:3e:84:d3:xx:xx on freq 5180: -110
> ath10k_pci 0000:01:00.0: failed to synchronize setup for vdev 0 restart 0: -110
> ath10k_pci 0000:01:00.0: failed to start vdev 0 addr 1c:3e:84:d3:xx:xx on freq 5180: -110
> ath10k_pci 0000:01:00.0: failed to start WMI vdev 0: -11
> ath10k_pci 0000:01:00.0: failed to start vdev 0 addr 1c:3e:84:d3:xx:xx on freq 5180: -11
> ath10k_pci 0000:01:00.0: failed to start WMI vdev 0: -11
> ath10k_pci 0000:01:00.0: failed to start vdev 0 addr 1c:3e:84:d3:xx:xx on freq 5180: -11
> ath10k_pci 0000:01:00.0: failed to delete WMI vdev 0: -11
> ath10k_pci 0000:01:00.0: could not suspend target (-11)
> ath10k_pci 0000:01:00.0: device has crashed during init
> ath10k_pci 0000:01:00.0: device has crashed during init
> ath10k_pci 0000:01:00.0: failed to wait for target init: -70
> [drm:ironlake_irq_handler [i915]] *ERROR* CPU pipe A FIFO underrun
> [drm:ironlake_irq_handler [i915]] *ERROR* PCH transcoder A FIFO underrun

at this point I reload the kernel modules
>
> ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
> ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/pre-cal-pci-0000:01:00.0.bin failed with error -2
> ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/cal-pci-0000:01:00.0.bin failed with error -2
> ath10k_pci 0000:01:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043022ff sub 1a56:1420
> ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 0 tracing 0 dfs 0 testmode 0
> ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.54 api 5 features no-p2p,raw-mode,mfp crc32 9d340dd9
> ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/QCA988X/hw2.0/board-2.bin failed with error -2
> ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
> ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1


this happens on Linux hostnamehere 4.8.0-040800rc5-generic
#201609041832 SMP Sun Sep 4 22:34:01 UTC 2016 x86_64 x86_64 x86_64
GNU/Linux

And the issues where a lot worse with Kernel 4.4.
Fell free to request more detailed debug info as needed.

I wish all a nice rest of the weekend

Steffen Arntz
