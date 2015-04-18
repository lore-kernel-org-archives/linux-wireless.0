Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52527 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbbDRKZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2015 06:25:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YjPvr-000884-GH
	for linux-wireless@vger.kernel.org; Sat, 18 Apr 2015 12:25:03 +0200
Received: from c-73-174-173-102.hsd1.pa.comcast.net ([73.174.173.102])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2015 12:25:03 +0200
Received: from jason.khanlar by c-73-174-173-102.hsd1.pa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 18 Apr 2015 12:25:03 +0200
To: linux-wireless@vger.kernel.org
From: Jason Khanlar <jason.khanlar@gmail.com>
Subject: 0cf3:3004 Atheros Communications, Inc. AR3012 Bluetooth 4.0
Date: Sat, 18 Apr 2015 10:23:38 +0000 (UTC)
Message-ID: <loom.20150418T115726-438@post.gmane.org> (sfid-20150418_122521_155314_F7B18A54)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have purchased a Sager Clevo NP9752-S laptop computer.

http://www.sagernotebook.com/Gaming-Notebook-NP9752-S.html

One of the internal USB components is an Atheros Bluetooth device.

Upon a fresh installation of the latest release of Archlinux, upon first
boot I noticed an error message appear immediately after the user login
prompt appeared:

	Arch Linux 3.19.3-3-ARCH (tty1)

	clevo login: [    2.590209] Bluetooth: Patch file not found
ar3k/AthrBT_0x00000200.dfu
	[    2.950240] Bluetooth: Loading patch file failed

Discussing and investigating about it with assistance from #archlinux on
Freenode IRC network, it was eventually suggested I file a bug report.

The following are details pertaining to my system in which I am unable to
properly prepare the device to function:


((Relevant packages installed include: linux-firmware-20150206.17657c3-1))

((Note: I can reproduce the error to appear by executing `rmmod ath3k &&
modprobe ath3k`))
# rmmod ath3k && modprobe ath3k
Bluetooth: Patch file not found ar3k/AthrBT_0x00000200.dfu
Bluetooth: Loading patch file failed


# ls -al /usr/lib/firmware/ar3k/
total 292
drwxr-xr-x  7 root root  4096 May 17 22:08 .
drwxr-xr-x 60 root root 12288 May 17 19:45 ..
drwxr-xr-x  2 root root  4096 May 17 19:45 1020200
drwxr-xr-x  2 root root  4096 May 17 19:45 1020201
drwxr-xr-x  2 root root  4096 May 17 19:45 30000
drwxr-xr-x  2 root root  4096 May 17 19:45 30101
drwxr-xr-x  2 root root  4096 May 17 19:45 30101coex
-rw-r--r--  1 root root 55244 Feb  8 13:37 AthrBT_0x01020001.dfu
-rw-r--r--  1 root root 40724 Feb  8 13:37 AthrBT_0x01020200.dfu
-rw-r--r--  1 root root 19164 Feb  8 13:37 AthrBT_0x01020201.dfu
-rw-r--r--  1 root root 36828 Feb  8 13:37 AthrBT_0x11020000.dfu
-rw-r--r--  1 root root 40652 Feb  8 13:37 AthrBT_0x31010000.dfu
-rw-r--r--  1 root root 31500 Feb  8 13:37 AthrBT_0x41020000.dfu
-rw-r--r--  1 root root     0 May 17 22:08 d
-rw-r--r--  1 root root  1224 Feb  8 13:37 ramps_0x01020001_26.dfu
-rw-r--r--  1 root root  1274 Feb  8 13:37 ramps_0x01020200_26.dfu
-rw-r--r--  1 root root  1204 Feb  8 13:37 ramps_0x01020200_40.dfu
-rw-r--r--  1 root root   264 Feb  8 13:37 ramps_0x01020201_26.dfu
-rw-r--r--  1 root root   264 Feb  8 13:37 ramps_0x01020201_40.dfu
-rw-r--r--  1 root root  1796 Feb  8 13:37 ramps_0x11020000_40.dfu
-rw-r--r--  1 root root  1926 Feb  8 13:37 ramps_0x31010000_40.dfu
-rw-r--r--  1 root root  1820 Feb  8 13:37 ramps_0x41020000_40.dfu


# lsusb|grep -i bluetooth
Bus 003 Device 004: ID 0cf3:3004 Atheros Communications, Inc. AR3012
Bluetooth 4.0


# lsusb -v -d 0cf3:3004
Bus 003 Device 004: ID 0cf3:3004 Atheros Communications, Inc. AR3012
Bluetooth 4.0
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0cf3 Atheros Communications, Inc.
  idProduct          0x3004 AR3012 Bluetooth 4.0
  bcdDevice            0.01
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          177
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequenccan't get debug descriptor:
Resource temporarily unavailable
y
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
Device Status:     0x0001
  Self Powered


# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.3-3-ARCH (builduser@tobias) (gcc version
4.9.2 20150304 (prerelease) (GCC) ) #1 SMP PREEMPT Wed Apr 8 14:10:00 CEST 2015
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux
root=UUID=ba72310a-77df-468d-bb95-3e71d3c16e4c rw quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dbd44fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dbd45000-0x00000000dbe4cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dbe4d000-0x00000000dc1effff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc1f0000-0x00000000dc1fcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc1fd000-0x00000000dc333fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc334000-0x00000000dc337fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc338000-0x00000000dc33efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc33f000-0x00000000dc33ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc340000-0x00000000dc340fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc341000-0x00000000dc341fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc342000-0x00000000dc343fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc344000-0x00000000dc458fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc459000-0x00000000dc46afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc46b000-0x00000000dc473fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc474000-0x00000000dc5cefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc5cf000-0x00000000dc5cffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc5d0000-0x00000000dc7cffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc7d0000-0x00000000dc7d1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dc7d2000-0x00000000dc943fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dc944000-0x00000000dc94afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dc94b000-0x00000000dd14ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd150000-0x00000000dd3f1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dd3f2000-0x00000000de90efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de90f000-0x00000000de913fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de914000-0x00000000de916fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de917000-0x00000000de919fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000de91a000-0x00000000de942fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de943000-0x00000000de945fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000de946000-0x00000000de94cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de94d000-0x00000000de94ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de950000-0x00000000de951fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000de952000-0x00000000de955fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de956000-0x00000000de964fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de965000-0x00000000de97cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de97d000-0x00000000dec01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dec02000-0x00000000dec1cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dec1d000-0x00000000dec20fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dec21000-0x00000000dec27fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dec28000-0x00000000dec48fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dec49000-0x00000000dec4afff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dec4b000-0x00000000ded3bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ded3c000-0x00000000ded48fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ded49000-0x00000000ded5cfff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000ded5d000-0x00000000ded63fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ded64000-0x00000000ded66fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ded67000-0x00000000ded76fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ded77000-0x00000000ded78fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000ded79000-0x00000000deda5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000deda6000-0x00000000dedc6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dedc7000-0x00000000dedc7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dedc8000-0x00000000dedc8fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dedc9000-0x00000000dedcdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dedce000-0x00000000dedcefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dedcf000-0x00000000dedcffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dedd0000-0x00000000dedd1fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dedd2000-0x00000000dedd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dedd6000-0x00000000dedfbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dedfc000-0x00000000dedfdfff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dedfe000-0x00000000dedfefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dedff000-0x00000000dee2dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dee2e000-0x00000000dee2efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dee2f000-0x00000000dee33fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dee34000-0x00000000dee5dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dee5e000-0x00000000dee9dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dee9e000-0x00000000def0efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000def0f000-0x00000000def0ffff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000def10000-0x00000000def11fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000def12000-0x00000000def18fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000def19000-0x00000000def19fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000def1a000-0x00000000def1dfff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000def1e000-0x00000000def24fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000def25000-0x00000000def35fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000def36000-0x00000000def36fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000def37000-0x00000000defcefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000defcf000-0x00000000deffefff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000defff000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0xdeda6000  ACPI=0xdeda6000  SMBIOS=0xdefcd518 
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000058000) (0MB)
[    0.000000] efi: mem01: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000000058000-0x0000000000059000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000000059000-0x000000000009e000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Loader Data        |   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000000100000-0x0000000000f3e000) (14MB)
[    0.000000] efi: mem05: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000000f3e000-0x000000003792c000) (873MB)
[    0.000000] efi: mem06: [Loader Data        |   |  |  |  |  
|WB|WT|WC|UC] range=[0x000000003792c000-0x0000000037c8e000) (3MB)
[    0.000000] efi: mem07: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000037c8e000-0x00000000a257b000) (1704MB)
[    0.000000] efi: mem08: [Loader Data        |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000a257b000-0x00000000d9510000) (879MB)
[    0.000000] efi: mem09: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000d9510000-0x00000000dbbf1000) (38MB)
[    0.000000] efi: mem10: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dbbf1000-0x00000000dbc95000) (0MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dbc95000-0x00000000dbcc9000) (0MB)
[    0.000000] efi: mem12: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dbcc9000-0x00000000dbd45000) (0MB)
[    0.000000] efi: mem13: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dbd45000-0x00000000dbe4d000) (1MB)
[    0.000000] efi: mem14: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dbe4d000-0x00000000dc0fc000) (2MB)
[    0.000000] efi: mem15: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc0fc000-0x00000000dc113000) (0MB)
[    0.000000] efi: mem16: [Loader Code        |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc113000-0x00000000dc130000) (0MB)
[    0.000000] efi: mem17: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc130000-0x00000000dc13b000) (0MB)
[    0.000000] efi: mem18: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc13b000-0x00000000dc1c3000) (0MB)
[    0.000000] efi: mem19: [Loader Data        |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1c3000-0x00000000dc1cf000) (0MB)
[    0.000000] efi: mem20: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1cf000-0x00000000dc1ea000) (0MB)
[    0.000000] efi: mem21: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1ea000-0x00000000dc1f0000) (0MB)
[    0.000000] efi: mem22: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1f0000-0x00000000dc1f4000) (0MB)
[    0.000000] efi: mem23: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1f4000-0x00000000dc1fd000) (0MB)
[    0.000000] efi: mem24: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc1fd000-0x00000000dc222000) (0MB)
[    0.000000] efi: mem25: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc222000-0x00000000dc239000) (0MB)
[    0.000000] efi: mem26: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc239000-0x00000000dc23c000) (0MB)
[    0.000000] efi: mem27: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc23c000-0x00000000dc23d000) (0MB)
[    0.000000] efi: mem28: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc23d000-0x00000000dc243000) (0MB)
[    0.000000] efi: mem29: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc243000-0x00000000dc248000) (0MB)
[    0.000000] efi: mem30: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc248000-0x00000000dc24d000) (0MB)
[    0.000000] efi: mem31: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc24d000-0x00000000dc252000) (0MB)
[    0.000000] efi: mem32: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc252000-0x00000000dc334000) (0MB)
[    0.000000] efi: mem33: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc334000-0x00000000dc338000) (0MB)
[    0.000000] efi: mem34: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc338000-0x00000000dc33f000) (0MB)
[    0.000000] efi: mem35: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc33f000-0x00000000dc340000) (0MB)
[    0.000000] efi: mem36: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc340000-0x00000000dc341000) (0MB)
[    0.000000] efi: mem37: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc341000-0x00000000dc342000) (0MB)
[    0.000000] efi: mem38: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc342000-0x00000000dc344000) (0MB)
[    0.000000] efi: mem39: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc344000-0x00000000dc459000) (1MB)
[    0.000000] efi: mem40: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc459000-0x00000000dc46b000) (0MB)
[    0.000000] efi: mem41: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc46b000-0x00000000dc474000) (0MB)
[    0.000000] efi: mem42: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc474000-0x00000000dc4c9000) (0MB)
[    0.000000] efi: mem43: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc4c9000-0x00000000dc4ed000) (0MB)
[    0.000000] efi: mem44: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc4ed000-0x00000000dc5cf000) (0MB)
[    0.000000] efi: mem45: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc5cf000-0x00000000dc5d0000) (0MB)
[    0.000000] efi: mem46: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc5d0000-0x00000000dc7cf000) (1MB)
[    0.000000] efi: mem47: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc7cf000-0x00000000dc7d0000) (0MB)
[    0.000000] efi: mem48: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc7d0000-0x00000000dc7d2000) (0MB)
[    0.000000] efi: mem49: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc7d2000-0x00000000dc7d3000) (0MB)
[    0.000000] efi: mem50: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc7d3000-0x00000000dc944000) (1MB)
[    0.000000] efi: mem51: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc944000-0x00000000dc94b000) (0MB)
[    0.000000] efi: mem52: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dc94b000-0x00000000dcaa2000) (1MB)
[    0.000000] efi: mem53: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dcaa2000-0x00000000dd10a000) (6MB)
[    0.000000] efi: mem54: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd10a000-0x00000000dd114000) (0MB)
[    0.000000] efi: mem55: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd114000-0x00000000dd11e000) (0MB)
[    0.000000] efi: mem56: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd11e000-0x00000000dd133000) (0MB)
[    0.000000] efi: mem57: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd133000-0x00000000dd145000) (0MB)
[    0.000000] efi: mem58: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd145000-0x00000000dd150000) (0MB)
[    0.000000] efi: mem59: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd150000-0x00000000dd3f2000) (2MB)
[    0.000000] efi: mem60: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dd3f2000-0x00000000de90f000) (21MB)
[    0.000000] efi: mem61: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de90f000-0x00000000de914000) (0MB)
[    0.000000] efi: mem62: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de914000-0x00000000de917000) (0MB)
[    0.000000] efi: mem63: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de917000-0x00000000de91a000) (0MB)
[    0.000000] efi: mem64: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de91a000-0x00000000de943000) (0MB)
[    0.000000] efi: mem65: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de943000-0x00000000de946000) (0MB)
[    0.000000] efi: mem66: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de946000-0x00000000de94d000) (0MB)
[    0.000000] efi: mem67: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de94d000-0x00000000de950000) (0MB)
[    0.000000] efi: mem68: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de950000-0x00000000de952000) (0MB)
[    0.000000] efi: mem69: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de952000-0x00000000de956000) (0MB)
[    0.000000] efi: mem70: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de956000-0x00000000de965000) (0MB)
[    0.000000] efi: mem71: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de965000-0x00000000de97d000) (0MB)
[    0.000000] efi: mem72: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000de97d000-0x00000000dec02000) (2MB)
[    0.000000] efi: mem73: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec02000-0x00000000dec1d000) (0MB)
[    0.000000] efi: mem74: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec1d000-0x00000000dec21000) (0MB)
[    0.000000] efi: mem75: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec21000-0x00000000dec28000) (0MB)
[    0.000000] efi: mem76: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec28000-0x00000000dec49000) (0MB)
[    0.000000] efi: mem77: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec49000-0x00000000dec4b000) (0MB)
[    0.000000] efi: mem78: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dec4b000-0x00000000ded3c000) (0MB)
[    0.000000] efi: mem79: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded3c000-0x00000000ded49000) (0MB)
[    0.000000] efi: mem80: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded49000-0x00000000ded5d000) (0MB)
[    0.000000] efi: mem81: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded5d000-0x00000000ded64000) (0MB)
[    0.000000] efi: mem82: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded64000-0x00000000ded67000) (0MB)
[    0.000000] efi: mem83: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded67000-0x00000000ded77000) (0MB)
[    0.000000] efi: mem84: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded77000-0x00000000ded79000) (0MB)
[    0.000000] efi: mem85: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000ded79000-0x00000000deda6000) (0MB)
[    0.000000] efi: mem86: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000deda6000-0x00000000dedc7000) (0MB)
[    0.000000] efi: mem87: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedc7000-0x00000000dedc8000) (0MB)
[    0.000000] efi: mem88: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedc8000-0x00000000dedc9000) (0MB)
[    0.000000] efi: mem89: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedc9000-0x00000000dedce000) (0MB)
[    0.000000] efi: mem90: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedce000-0x00000000dedcf000) (0MB)
[    0.000000] efi: mem91: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedcf000-0x00000000dedd0000) (0MB)
[    0.000000] efi: mem92: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedd0000-0x00000000dedd2000) (0MB)
[    0.000000] efi: mem93: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedd2000-0x00000000dedd6000) (0MB)
[    0.000000] efi: mem94: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedd6000-0x00000000dedfc000) (0MB)
[    0.000000] efi: mem95: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedfc000-0x00000000dedfe000) (0MB)
[    0.000000] efi: mem96: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedfe000-0x00000000dedff000) (0MB)
[    0.000000] efi: mem97: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dedff000-0x00000000dee2e000) (0MB)
[    0.000000] efi: mem98: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dee2e000-0x00000000dee2f000) (0MB)
[    0.000000] efi: mem99: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dee2f000-0x00000000dee34000) (0MB)
[    0.000000] efi: mem100: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dee34000-0x00000000dee5e000) (0MB)
[    0.000000] efi: mem101: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dee5e000-0x00000000dee9e000) (0MB)
[    0.000000] efi: mem102: [Boot Code          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000dee9e000-0x00000000def0f000) (0MB)
[    0.000000] efi: mem103: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def0f000-0x00000000def10000) (0MB)
[    0.000000] efi: mem104: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def10000-0x00000000def12000) (0MB)
[    0.000000] efi: mem105: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def12000-0x00000000def19000) (0MB)
[    0.000000] efi: mem106: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def19000-0x00000000def1a000) (0MB)
[    0.000000] efi: mem107: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def1a000-0x00000000def1e000) (0MB)
[    0.000000] efi: mem108: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def1e000-0x00000000def25000) (0MB)
[    0.000000] efi: mem109: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def25000-0x00000000def36000) (0MB)
[    0.000000] efi: mem110: [ACPI Memory NVS    |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def36000-0x00000000def37000) (0MB)
[    0.000000] efi: mem111: [Reserved           |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def37000-0x00000000def38000) (0MB)
[    0.000000] efi: mem112: [Runtime Data       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000def38000-0x00000000defcf000) (0MB)
[    0.000000] efi: mem113: [Runtime Code       |RUN|  |  |  |  
|WB|WT|WC|UC] range=[0x00000000defcf000-0x00000000defff000) (0MB)
[    0.000000] efi: mem114: [Boot Data          |   |  |  |  |  
|WB|WT|WC|UC] range=[0x00000000defff000-0x00000000df000000) (0MB)
[    0.000000] efi: mem115: [Conventional Memory|   |  |  |  |  
|WB|WT|WC|UC] range=[0x0000000100000000-0x000000041f000000) (12784MB)
[    0.000000] efi: mem116: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000f8000000-0x00000000fc000000) (64MB)
[    0.000000] efi: mem117: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem118: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000fed00000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem119: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem120: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem121: [Memory Mapped I/O  |RUN|  |  |  |   |  |  | 
|UC] range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Notebook                         P750ZM                
         /P750ZM                          , BIOS 1.03.11RLS1 03/25/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7FF0000000 write-back
[    0.000000]   2 base 0410000000 mask 7FF8000000 write-back
[    0.000000]   3 base 0418000000 mask 7FFC000000 write-back
[    0.000000]   4 base 041C000000 mask 7FFE000000 write-back
[    0.000000]   5 base 041E000000 mask 7FFF000000 write-back
[    0.000000]   6 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b32000, 0x01b32fff] PGTABLE
[    0.000000] BRK [0x01b33000, 0x01b33fff] PGTABLE
[    0.000000] BRK [0x01b34000, 0x01b34fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41ee00000-0x41effffff]
[    0.000000]  [mem 0x41ee00000-0x41effffff] page 2M
[    0.000000] BRK [0x01b35000, 0x01b35fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41edfffff]
[    0.000000]  [mem 0x400000000-0x41edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3e0000000-0x3ffffffff]
[    0.000000]  [mem 0x3e0000000-0x3ffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdbd44fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xdbbfffff] page 2M
[    0.000000]  [mem 0xdbc00000-0xdbd44fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdbe4d000-0xdc1effff]
[    0.000000]  [mem 0xdbe4d000-0xdc1effff] page 4k
[    0.000000] BRK [0x01b36000, 0x01b36fff] PGTABLE
[    0.000000] BRK [0x01b37000, 0x01b37fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdc1fd000-0xdc333fff]
[    0.000000]  [mem 0xdc1fd000-0xdc333fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc338000-0xdc33efff]
[    0.000000]  [mem 0xdc338000-0xdc33efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc340000-0xdc340fff]
[    0.000000]  [mem 0xdc340000-0xdc340fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc342000-0xdc343fff]
[    0.000000]  [mem 0xdc342000-0xdc343fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc459000-0xdc46afff]
[    0.000000]  [mem 0xdc459000-0xdc46afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc474000-0xdc5cefff]
[    0.000000]  [mem 0xdc474000-0xdc5cefff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc5d0000-0xdc7cffff]
[    0.000000]  [mem 0xdc5d0000-0xdc7cffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc7d2000-0xdc943fff]
[    0.000000]  [mem 0xdc7d2000-0xdc943fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdc94b000-0xdd14ffff]
[    0.000000]  [mem 0xdc94b000-0xdc9fffff] page 4k
[    0.000000]  [mem 0xdca00000-0xdcffffff] page 2M
[    0.000000]  [mem 0xdd000000-0xdd14ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdd3f2000-0xde90efff]
[    0.000000]  [mem 0xdd3f2000-0xdd3fffff] page 4k
[    0.000000]  [mem 0xdd400000-0xde7fffff] page 2M
[    0.000000]  [mem 0xde800000-0xde90efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde914000-0xde916fff]
[    0.000000]  [mem 0xde914000-0xde916fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde91a000-0xde942fff]
[    0.000000]  [mem 0xde91a000-0xde942fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde946000-0xde94cfff]
[    0.000000]  [mem 0xde946000-0xde94cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde952000-0xde955fff]
[    0.000000]  [mem 0xde952000-0xde955fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde965000-0xde97cfff]
[    0.000000]  [mem 0xde965000-0xde97cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdec02000-0xdec1cfff]
[    0.000000]  [mem 0xdec02000-0xdec1cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdec21000-0xdec27fff]
[    0.000000]  [mem 0xdec21000-0xdec27fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdec4b000-0xded3bfff]
[    0.000000]  [mem 0xdec4b000-0xded3bfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xded5d000-0xded63fff]
[    0.000000]  [mem 0xded5d000-0xded63fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xded67000-0xded76fff]
[    0.000000]  [mem 0xded67000-0xded76fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xded79000-0xdeda5fff]
[    0.000000]  [mem 0xded79000-0xdeda5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdedc9000-0xdedcdfff]
[    0.000000]  [mem 0xdedc9000-0xdedcdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdedd0000-0xdedd1fff]
[    0.000000]  [mem 0xdedd0000-0xdedd1fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdedd6000-0xdedfbfff]
[    0.000000]  [mem 0xdedd6000-0xdedfbfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdedff000-0xdee2dfff]
[    0.000000]  [mem 0xdedff000-0xdee2dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdee34000-0xdee5dfff]
[    0.000000]  [mem 0xdee34000-0xdee5dfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdee9e000-0xdef0efff]
[    0.000000]  [mem 0xdee9e000-0xdef0efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdefff000-0xdeffffff]
[    0.000000]  [mem 0xdefff000-0xdeffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3dfffffff]
[    0.000000]  [mem 0x100000000-0x3dfffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3792c000-0x37c8dfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DEDA6000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000DEDA6090 0000A4 (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DEDB7948 00010C (v05 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DEDA61D0 011774 (v02 ALASKA A M I   
00000015 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DEF36F80 000040
[    0.000000] ACPI: APIC 0x00000000DEDB7A58 000092 (v03 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DEDB7AF0 000044 (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000DEDB7B38 00009C (v01 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: ASF! 0x00000000DEDB7BD8 0000A5 (v32 INTEL   HCG    
00000001 TFSM 000F4240)
[    0.000000] ACPI: SSDT 0x00000000DEDB7C80 00342F (v02 TrmRef PtidDevc
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DEDBB0B0 001CE1 (v01 NvdRef NvdTabl 
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DEDBCD98 000539 (v02 PmRef  Cpu0Ist 
00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DEDBD2D8 000B74 (v02 CpuRef CpuSsdt 
00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000DEDBDE50 00003C (v01 ALASKA A M I   
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DEDBDE90 000038 (v01 ALASKA A M I   
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DEDBDEC8 00036D (v01 SataRe SataTabl
00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DEDBE238 005B5D (v02 SaSsdt SaSsdt  
00003000 INTL 20120711)
[    0.000000] ACPI: UEFI 0x00000000DEDC3D98 000042 (v01 ALASKA A M I   
01072009      00000000)
[    0.000000] ACPI: DMAR 0x00000000DEDC3DE0 000080 (v01 INTEL  BDW     
00000001 INTL 00000001)
[    0.000000] ACPI: BGRT 0x00000000DEDC3E60 000038 (v00 ALASKA A M I   
01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x41eff1000-0x41eff4fff]
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD ->
[ffff88040e600000-ffff88041e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00057fff]
[    0.000000]   node   0: [mem 0x00059000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xdbd44fff]
[    0.000000]   node   0: [mem 0xdbe4d000-0xdc1effff]
[    0.000000]   node   0: [mem 0xdc1fd000-0xdc333fff]
[    0.000000]   node   0: [mem 0xdc338000-0xdc33efff]
[    0.000000]   node   0: [mem 0xdc340000-0xdc340fff]
[    0.000000]   node   0: [mem 0xdc342000-0xdc343fff]
[    0.000000]   node   0: [mem 0xdc459000-0xdc46afff]
[    0.000000]   node   0: [mem 0xdc474000-0xdc5cefff]
[    0.000000]   node   0: [mem 0xdc5d0000-0xdc7cffff]
[    0.000000]   node   0: [mem 0xdc7d2000-0xdc943fff]
[    0.000000]   node   0: [mem 0xdc94b000-0xdd14ffff]
[    0.000000]   node   0: [mem 0xdd3f2000-0xde90efff]
[    0.000000]   node   0: [mem 0xde914000-0xde916fff]
[    0.000000]   node   0: [mem 0xde91a000-0xde942fff]
[    0.000000]   node   0: [mem 0xde946000-0xde94cfff]
[    0.000000]   node   0: [mem 0xde952000-0xde955fff]
[    0.000000]   node   0: [mem 0xde965000-0xde97cfff]
[    0.000000]   node   0: [mem 0xdec02000-0xdec1cfff]
[    0.000000]   node   0: [mem 0xdec21000-0xdec27fff]
[    0.000000]   node   0: [mem 0xdec4b000-0xded3bfff]
[    0.000000]   node   0: [mem 0xded5d000-0xded63fff]
[    0.000000]   node   0: [mem 0xded67000-0xded76fff]
[    0.000000]   node   0: [mem 0xded79000-0xdeda5fff]
[    0.000000]   node   0: [mem 0xdedc9000-0xdedcdfff]
[    0.000000]   node   0: [mem 0xdedd0000-0xdedd1fff]
[    0.000000]   node   0: [mem 0xdedd6000-0xdedfbfff]
[    0.000000]   node   0: [mem 0xdedff000-0xdee2dfff]
[    0.000000]   node   0: [mem 0xdee34000-0xdee5dfff]
[    0.000000]   node   0: [mem 0xdee9e000-0xdef0efff]
[    0.000000]   node   0: [mem 0xdefff000-0xdeffffff]
[    0.000000]   node   0: [mem 0x100000000-0x41effffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x41effffff]
[    0.000000] On node 0 totalpages: 4183652
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14172 pages used for memmap
[    0.000000]   DMA32 zone: 906952 pages, LIFO batch:31
[    0.000000]   Normal zone: 51136 pages used for memmap
[    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdbd45000-0xdbe4cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc1f0000-0xdc1fcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc334000-0xdc337fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc33f000-0xdc33ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc341000-0xdc341fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc344000-0xdc458fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc46b000-0xdc473fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc5cf000-0xdc5cffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc7d0000-0xdc7d1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdc944000-0xdc94afff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd150000-0xdd3f1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde90f000-0xde913fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde917000-0xde919fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde943000-0xde945fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde94d000-0xde94ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xde950000-0xde951fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde956000-0xde964fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde97d000-0xdec01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdec1d000-0xdec20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdec28000-0xdec48fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdec49000-0xdec4afff]
[    0.000000] PM: Registered nosave memory: [mem 0xded3c000-0xded48fff]
[    0.000000] PM: Registered nosave memory: [mem 0xded49000-0xded5cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xded64000-0xded66fff]
[    0.000000] PM: Registered nosave memory: [mem 0xded77000-0xded78fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdeda6000-0xdedc6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedc7000-0xdedc7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedc8000-0xdedc8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedce000-0xdedcefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedcf000-0xdedcffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedd2000-0xdedd5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedfc000-0xdedfdfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdedfe000-0xdedfefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdee2e000-0xdee2efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdee2f000-0xdee33fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdee5e000-0xdee9dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef0f000-0xdef0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef10000-0xdef11fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef12000-0xdef18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef19000-0xdef19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef1a000-0xdef1dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef1e000-0xdef24fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef25000-0xdef35fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef36000-0xdef36fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdef37000-0xdefcefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdefcf000-0xdeffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8
nr_node_ids:1
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88041ec00000 s86336 r8192
d32448 u262144
[    0.000000] pcpu-alloc: s86336 r8192 d32448 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total
pages: 4118257
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux
root=UUID=ba72310a-77df-468d-bb95-3e71d3c16e4c rw quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard
form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16346720K/16734608K available (5534K kernel code,
917K rwdata, 1744K rodata, 1164K init, 1156K bss, 387888K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:8448 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] tsc: Detected 3990.922 MHz processor
[    0.000018] Calibrating delay loop (skipped), value calculated using
timer frequency.. 7985.42 BogoMIPS (lpj=13303073)
[    0.000019] pid_max: default: 32768 minimum: 301
[    0.000022] ACPI: Core revision 20141107
[    0.009768] ACPI: All ACPI Tables successfully acquired
[    0.020315] Security Framework initialized
[    0.020318] Yama: becoming mindful.
[    0.020860] Dentry cache hash table entries: 2097152 (order: 12, 16777216
bytes)
[    0.022698] Inode-cache hash table entries: 1048576 (order: 11, 8388608
bytes)
[    0.023467] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.023477] Mountpoint-cache hash table entries: 32768 (order: 6, 262144
bytes)
[    0.023628] Initializing cgroup subsys memory
[    0.023631] Initializing cgroup subsys devices
[    0.023632] Initializing cgroup subsys freezer
[    0.023633] Initializing cgroup subsys net_cls
[    0.023634] Initializing cgroup subsys blkio
[    0.023648] CPU: Physical Processor ID: 0
[    0.023649] CPU: Processor Core ID: 0
[    0.023651] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
               ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.024327] mce: CPU supports 9 MCE banks
[    0.024336] CPU0: Thermal monitoring enabled (TM1)
[    0.024343] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
               Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.024402] Freeing SMP alternatives memory: 20K (ffffffff81a0a000 -
ffffffff81a0f000)
[    0.024896] Ignoring BGRT: invalid status 0 (expected 1)
[    0.025556] ftrace: allocating 21171 entries in 83 pages
[    0.030756] dmar: Host address width 39
[    0.030757] dmar: DRHD base: 0x000000fed90000 flags: 0x1
[    0.030763] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap
d2008c20660462 ecap f010da
[    0.030764] dmar: RMRR base: 0x000000de956000 end: 0x000000de964fff
[    0.030828] IOAPIC id 8 under DRHD base  0xfed90000 IOMMU 0
[    0.030828] HPET id 0 under DRHD base 0xfed90000
[    0.030829] Queued invalidation will be enabled to support x2apic and
Intr-remapping.
[    0.030829] Your BIOS is broken and requested that x2apic be disabled.
               This will slightly decrease performance.
               Use 'intremap=no_x2apic_optout' to override BIOS request.
[    0.030877] Enabled IRQ remapping in xapic mode
[    0.030878] x2apic not enabled, IRQ remapping is in xapic mode
[    0.031267] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064323] smpboot: CPU0: Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz (fam:
06, model: 3c, stepping: 03)
[    0.064327] TSC deadline timer enabled
[    0.064338] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events,
full-width counters, Intel PMU driver.
[    0.064350] ... version:                3
[    0.064350] ... bit width:              48
[    0.064351] ... generic registers:      4
[    0.064351] ... value mask:             0000ffffffffffff
[    0.064352] ... max period:             0000ffffffffffff
[    0.064352] ... fixed-purpose events:   3
[    0.064353] ... event mask:             000000070000000f
[    0.087793] x86: Booting SMP configuration:
[    0.087794] .... node  #0, CPUs:      #1
[    0.101781] NMI watchdog: enabled on all CPUs, permanently consumes one
hw-PMU counter.
[    0.108472]  #2 #3 #4 #5 #6 #7
[    0.221906] x86: Booted up 1 node, 8 CPUs
[    0.221908] smpboot: Total of 8 processors activated (63880.36 BogoMIPS)
[    0.227689] devtmpfs: initialized
[    0.229333] PM: Registering ACPI NVS region [mem 0xdbd45000-0xdbe4cfff]
(1081344 bytes)
[    0.229341] PM: Registering ACPI NVS region [mem 0xdc944000-0xdc94afff]
(28672 bytes)
[    0.229342] PM: Registering ACPI NVS region [mem 0xdeda6000-0xdedc6fff]
(135168 bytes)
[    0.229344] PM: Registering ACPI NVS region [mem 0xdedcf000-0xdedcffff]
(4096 bytes)
[    0.229344] PM: Registering ACPI NVS region [mem 0xdedfe000-0xdedfefff]
(4096 bytes)
[    0.229345] PM: Registering ACPI NVS region [mem 0xdef19000-0xdef19fff]
(4096 bytes)
[    0.229346] PM: Registering ACPI NVS region [mem 0xdef1e000-0xdef24fff]
(28672 bytes)
[    0.229346] PM: Registering ACPI NVS region [mem 0xdef36000-0xdef36fff]
(4096 bytes)
[    0.229446] pinctrl core: initialized pinctrl subsystem
[    0.229475] RTC time:  2:10:25, date: 05/18/15
[    0.229539] NET: Registered protocol family 16
[    0.240940] cpuidle: using governor ladder
[    0.260988] cpuidle: using governor menu
[    0.261002] ACPI FADT declares the system doesn't support PCIe ASPM, so
disable it
[    0.261003] ACPI: bus type PCI registered
[    0.261004] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.261041] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.261043] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.261090] PCI: Using configuration type 1 for base access
[    0.274546] ACPI: Added _OSI(Module Device)
[    0.274548] ACPI: Added _OSI(Processor Device)
[    0.274548] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.274549] ACPI: Added _OSI(Processor Aggregator Device)
[    0.277288] ACPI: Executed 6 blocks of module-level executable AML code
[    0.279140] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.279437] ACPI: Dynamic OEM Table Load:
[    0.279441] ACPI: SSDT 0xFFFF88040BC33400 0003D3 (v02 PmRef  Cpu0Cst 
00003001 INTL 20051117)
[    0.279882] ACPI: Dynamic OEM Table Load:
[    0.279885] ACPI: SSDT 0xFFFF88040BC02800 0005AA (v02 PmRef  ApIst   
00003000 INTL 20051117)
[    0.280350] ACPI: Dynamic OEM Table Load:
[    0.280352] ACPI: SSDT 0xFFFF88040BC56E00 000119 (v02 PmRef  ApCst   
00003000 INTL 20051117)
[    0.281698] ACPI: Interpreter enabled
[    0.281703] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S1_] (20141107/hwxface-580)
[    0.281707] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S2_] (20141107/hwxface-580)
[    0.281720] ACPI: (supports S0 S3 S4 S5)
[    0.281721] ACPI: Using IOAPIC for interrupt routing
[    0.281738] PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[    0.281999] ACPI: Power Resource [PG00] (on)
[    0.282263] ACPI: Power Resource [PG01] (on)
[    0.282420] ACPI: Power Resource [PG02] (on)
[    0.287025] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.287028] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.287188] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER
PCIeCapability]
[    0.287437] PCI host bridge to bus 0000:00
[    0.287438] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.287439] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.287440] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.287441] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.287442] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.287443] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.287443] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.287444] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.287445] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.287446] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.287446] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.287447] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.287448] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.287449] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.287449] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.287450] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.287451] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff]
[    0.287456] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.287506] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.287529] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.287556] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.287597] pci 0000:00:14.0: [8086:8cb1] type 00 class 0x0c0330
[    0.287612] pci 0000:00:14.0: reg 0x10: [mem 0xf7100000-0xf710ffff 64bit]
[    0.287661] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.287690] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.287715] pci 0000:00:16.0: [8086:8cba] type 00 class 0x078000
[    0.287730] pci 0000:00:16.0: reg 0x10: [mem 0xf7119000-0xf711900f 64bit]
[    0.287783] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.287833] pci 0000:00:1a.0: [8086:8cad] type 00 class 0x0c0320
[    0.287850] pci 0000:00:1a.0: reg 0x10: [mem 0xf7117000-0xf71173ff]
[    0.287924] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.287953] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.287976] pci 0000:00:1b.0: [8086:8ca0] type 00 class 0x040300
[    0.287987] pci 0000:00:1b.0: reg 0x10: [mem 0xf7110000-0xf7113fff 64bit]
[    0.288036] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.288063] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.288082] pci 0000:00:1c.0: [8086:8c90] type 01 class 0x060400
[    0.288138] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.288161] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.288181] pci 0000:00:1c.2: [8086:8c94] type 01 class 0x060400
[    0.288236] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.288260] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.288279] pci 0000:00:1c.3: [8086:8c96] type 01 class 0x060400
[    0.288334] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.288358] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.288384] pci 0000:00:1d.0: [8086:8ca6] type 00 class 0x0c0320
[    0.288400] pci 0000:00:1d.0: reg 0x10: [mem 0xf7116000-0xf71163ff]
[    0.288475] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.288503] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.288526] pci 0000:00:1f.0: [8086:8cc4] type 00 class 0x060100
[    0.288650] pci 0000:00:1f.2: [8086:8c82] type 00 class 0x010601
[    0.288662] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.288667] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.288672] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.288677] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.288683] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.288688] pci 0000:00:1f.2: reg 0x24: [mem 0xf7115000-0xf71157ff]
[    0.288718] pci 0000:00:1f.2: PME# supported from D3hot
[    0.288754] pci 0000:00:1f.3: [8086:8ca2] type 00 class 0x0c0500
[    0.288765] pci 0000:00:1f.3: reg 0x10: [mem 0xf7114000-0xf71140ff 64bit]
[    0.288780] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.288854] pci 0000:01:00.0: [10de:13d8] type 00 class 0x030000
[    0.288863] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.288871] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit
pref]
[    0.288879] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit
pref]
[    0.288885] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.288890] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.288940] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.288964] pci 0000:01:00.1: [10de:0fbb] type 00 class 0x040300
[    0.288972] pci 0000:01:00.1: reg 0x10: [mem 0xf7080000-0xf7083fff]
[    0.294403] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.294404] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.294406] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.294408] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff
64bit pref]
[    0.294459] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.294527] pci 0000:03:00.0: [10ec:5250] type 00 class 0x080501
[    0.294540] pci 0000:03:00.0: reg 0x10: [mem 0xf7601000-0xf7601fff]
[    0.294547] pci 0000:03:00.0: reg 0x14: [mem 0xf7600000-0xf7600fff]
[    0.294640] pci 0000:03:00.0: supports D1 D2
[    0.294641] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.294663] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.301085] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.301088] pci 0000:00:1c.2:   bridge window [mem 0xf7600000-0xf76fffff]
[    0.301157] pci 0000:04:00.0: [1b21:1182] type 01 class 0x060400
[    0.301254] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.301276] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.307765] pci 0000:00:1c.3: PCI bridge to [bus 04-07]
[    0.307767] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.307769] pci 0000:00:1c.3:   bridge window [mem 0xf7200000-0xf74fffff]
[    0.307773] pci 0000:00:1c.3:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.307838] pci 0000:05:03.0: [1b21:1182] type 01 class 0x060400
[    0.307938] pci 0000:05:03.0: PME# supported from D0 D3hot D3cold
[    0.307986] pci 0000:05:07.0: [1b21:1182] type 01 class 0x060400
[    0.308085] pci 0000:05:07.0: PME# supported from D0 D3hot D3cold
[    0.308142] pci 0000:04:00.0: PCI bridge to [bus 05-07]
[    0.308147] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    0.308150] pci 0000:04:00.0:   bridge window [mem 0xf7200000-0xf74fffff]
[    0.308155] pci 0000:04:00.0:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.308227] pci 0000:06:00.0: [168c:003e] type 00 class 0x028000
[    0.308256] pci 0000:06:00.0: reg 0x10: [mem 0xf7200000-0xf73fffff 64bit]
[    0.308409] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.314454] pci 0000:05:03.0: PCI bridge to [bus 06]
[    0.314462] pci 0000:05:03.0:   bridge window [mem 0xf7200000-0xf73fffff]
[    0.314540] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.314565] pci 0000:07:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.314602] pci 0000:07:00.0: reg 0x18: [mem 0xf7400000-0xf7400fff 64bit]
[    0.314624] pci 0000:07:00.0: reg 0x20: [mem 0xf2100000-0xf2103fff 64bit
pref]
[    0.314752] pci 0000:07:00.0: supports D1 D2
[    0.314753] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.321137] pci 0000:05:07.0: PCI bridge to [bus 07]
[    0.321142] pci 0000:05:07.0:   bridge window [io  0xd000-0xdfff]
[    0.321145] pci 0000:05:07.0:   bridge window [mem 0xf7400000-0xf74fffff]
[    0.321151] pci 0000:05:07.0:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.321197] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is
unsupported)
[    0.321563] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321590] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321615] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321640] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321666] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321692] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321717] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321742] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15)
*0, disabled.
[    0.321898] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.321919] ACPI : EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.321967] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.321968] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.321969] vgaarb: loaded
[    0.321970] vgaarb: bridge control possible 0000:01:00.0
[    0.322072] PCI: Using ACPI for IRQ routing
[    0.323138] PCI: pci_cache_line_size set to 64 bytes
[    0.323193] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.323193] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.323194] e820: reserve RAM buffer [mem 0xdbd45000-0xdbffffff]
[    0.323195] e820: reserve RAM buffer [mem 0xdc1f0000-0xdfffffff]
[    0.323202] e820: reserve RAM buffer [mem 0xdc334000-0xdfffffff]
[    0.323210] e820: reserve RAM buffer [mem 0xdc33f000-0xdfffffff]
[    0.323218] e820: reserve RAM buffer [mem 0xdc341000-0xdfffffff]
[    0.323225] e820: reserve RAM buffer [mem 0xdc344000-0xdfffffff]
[    0.323232] e820: reserve RAM buffer [mem 0xdc46b000-0xdfffffff]
[    0.323240] e820: reserve RAM buffer [mem 0xdc5cf000-0xdfffffff]
[    0.323247] e820: reserve RAM buffer [mem 0xdc7d0000-0xdfffffff]
[    0.323254] e820: reserve RAM buffer [mem 0xdc944000-0xdfffffff]
[    0.323261] e820: reserve RAM buffer [mem 0xdd150000-0xdfffffff]
[    0.323267] e820: reserve RAM buffer [mem 0xde90f000-0xdfffffff]
[    0.323274] e820: reserve RAM buffer [mem 0xde917000-0xdfffffff]
[    0.323281] e820: reserve RAM buffer [mem 0xde943000-0xdfffffff]
[    0.323287] e820: reserve RAM buffer [mem 0xde94d000-0xdfffffff]
[    0.323293] e820: reserve RAM buffer [mem 0xde956000-0xdfffffff]
[    0.323299] e820: reserve RAM buffer [mem 0xde97d000-0xdfffffff]
[    0.323305] e820: reserve RAM buffer [mem 0xdec1d000-0xdfffffff]
[    0.323310] e820: reserve RAM buffer [mem 0xdec28000-0xdfffffff]
[    0.323316] e820: reserve RAM buffer [mem 0xded3c000-0xdfffffff]
[    0.323321] e820: reserve RAM buffer [mem 0xded64000-0xdfffffff]
[    0.323325] e820: reserve RAM buffer [mem 0xded77000-0xdfffffff]
[    0.323330] e820: reserve RAM buffer [mem 0xdeda6000-0xdfffffff]
[    0.323334] e820: reserve RAM buffer [mem 0xdedce000-0xdfffffff]
[    0.323338] e820: reserve RAM buffer [mem 0xdedd2000-0xdfffffff]
[    0.323342] e820: reserve RAM buffer [mem 0xdedfc000-0xdfffffff]
[    0.323345] e820: reserve RAM buffer [mem 0xdee2e000-0xdfffffff]
[    0.323348] e820: reserve RAM buffer [mem 0xdee5e000-0xdfffffff]
[    0.323351] e820: reserve RAM buffer [mem 0xdef0f000-0xdfffffff]
[    0.323353] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    0.323354] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
[    0.323409] NetLabel: Initializing
[    0.323410] NetLabel:  domain hash size = 128
[    0.323410] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.323416] NetLabel:  unlabeled traffic allowed by default
[    0.323427] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.323430] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.325451] Switched to clocksource hpet
[    0.328279] pnp: PnP ACPI init
[    0.328338] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.328340] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.328404] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.328405] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.328419] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.328438] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.328440] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02
(active)
[    0.328454] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.328504] pnp 00:05: Plug and Play ACPI device, IDs SYN1214 PNP0f13
(active)
[    0.328528] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.328529] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.328678] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.328679] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.328680] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.328681] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.328682] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.328683] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.328684] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.328685] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.328686] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.328687] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.328688] system 00:07: [mem 0xf7fc0000-0xf7fcffff] has been reserved
[    0.328690] system 00:07: [mem 0xf7ff0000-0xf7ffffff] has been reserved
[    0.328691] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.328805] pnp: PnP ACPI: found 8 devices
[    0.334258] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus
02] add_size 1000
[    0.334260] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff
64bit pref] to [bus 02] add_size 200000
[    0.334261] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff]
to [bus 02] add_size 200000
[    0.334293] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff]
get_res_add_size add_size 200000
[    0.334294] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit
pref] get_res_add_size add_size 200000
[    0.334295] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000
[    0.334299] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf2200000-0xf23fffff]
[    0.334307] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf2400000-0xf25fffff
64bit pref]
[    0.334308] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.334309] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.334310] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.334312] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.334314] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff
64bit pref]
[    0.334316] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.334317] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.334320] pci 0000:00:1c.0:   bridge window [mem 0xf2200000-0xf23fffff]
[    0.334322] pci 0000:00:1c.0:   bridge window [mem 0xf2400000-0xf25fffff
64bit pref]
[    0.334326] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.334329] pci 0000:00:1c.2:   bridge window [mem 0xf7600000-0xf76fffff]
[    0.334334] pci 0000:05:03.0: PCI bridge to [bus 06]
[    0.334338] pci 0000:05:03.0:   bridge window [mem 0xf7200000-0xf73fffff]
[    0.334346] pci 0000:05:07.0: PCI bridge to [bus 07]
[    0.334348] pci 0000:05:07.0:   bridge window [io  0xd000-0xdfff]
[    0.334352] pci 0000:05:07.0:   bridge window [mem 0xf7400000-0xf74fffff]
[    0.334355] pci 0000:05:07.0:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.334361] pci 0000:04:00.0: PCI bridge to [bus 05-07]
[    0.334363] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    0.334367] pci 0000:04:00.0:   bridge window [mem 0xf7200000-0xf74fffff]
[    0.334370] pci 0000:04:00.0:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.334375] pci 0000:00:1c.3: PCI bridge to [bus 04-07]
[    0.334377] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.334380] pci 0000:00:1c.3:   bridge window [mem 0xf7200000-0xf74fffff]
[    0.334382] pci 0000:00:1c.3:   bridge window [mem 0xf2100000-0xf21fffff
64bit pref]
[    0.334386] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.334387] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.334388] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.334388] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.334389] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.334390] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.334391] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.334391] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.334392] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.334393] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.334394] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.334395] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.334395] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.334396] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.334397] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.334398] pci_bus 0000:00: resource 19 [mem 0xe0000000-0xfeafffff]
[    0.334398] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.334399] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.334400] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit
pref]
[    0.334401] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.334402] pci_bus 0000:02: resource 1 [mem 0xf2200000-0xf23fffff]
[    0.334402] pci_bus 0000:02: resource 2 [mem 0xf2400000-0xf25fffff 64bit
pref]
[    0.334403] pci_bus 0000:03: resource 1 [mem 0xf7600000-0xf76fffff]
[    0.334404] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.334405] pci_bus 0000:04: resource 1 [mem 0xf7200000-0xf74fffff]
[    0.334406] pci_bus 0000:04: resource 2 [mem 0xf2100000-0xf21fffff 64bit
pref]
[    0.334406] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.334407] pci_bus 0000:05: resource 1 [mem 0xf7200000-0xf74fffff]
[    0.334408] pci_bus 0000:05: resource 2 [mem 0xf2100000-0xf21fffff 64bit
pref]
[    0.334409] pci_bus 0000:06: resource 1 [mem 0xf7200000-0xf73fffff]
[    0.334409] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.334410] pci_bus 0000:07: resource 1 [mem 0xf7400000-0xf74fffff]
[    0.334411] pci_bus 0000:07: resource 2 [mem 0xf2100000-0xf21fffff 64bit
pref]
[    0.334423] NET: Registered protocol family 2
[    0.334541] TCP established hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.334660] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.334748] TCP: Hash tables configured (established 131072 bind 65536)
[    0.334757] TCP: reno registered
[    0.334767] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.334798] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.334841] NET: Registered protocol family 1
[    0.335125] pci 0000:01:00.0: Video device with shadowed ROM
[    0.335144] PCI: CLS 64 bytes, default 64
[    0.335168] Unpacking initramfs...
[    0.368003] Freeing initrd memory: 3464K (ffff88003792c000 -
ffff880037c8e000)
[    0.368017] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.368019] software IO TLB [mem 0xd7bf1000-0xdbbf1000] (64MB) mapped at
[ffff8800d7bf1000-ffff8800dbbf0fff]
[    0.368171] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32
Joules, 4 fixed counters 655360 ms ovfl timer
[    0.368228] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368232] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368236] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368241] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368245] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368249] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368253] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368257] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x1d
[    0.368282] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.368295] Scanning for low memory corruption every 60 seconds
[    0.368443] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.368456] Initialise system trusted keyring
[    0.368631] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.369292] zpool: loaded
[    0.369294] zbud: loaded
[    0.369387] VFS: Disk quotas dquot_6.5.2
[    0.369405] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.369487] Key type big_key registered
[    0.369599] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    0.369637] io scheduler noop registered
[    0.369638] io scheduler deadline registered
[    0.369652] io scheduler cfq registered (default)
[    0.370356] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.370358] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.370359] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.370360] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.370368] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.370370] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.370377] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.370378] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.370380] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.370388] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.370388] pcieport 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.370389] pcieport 0000:05:03.0: Signaling PME through PCIe PME interrupt
[    0.370390] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    0.370390] pcieport 0000:05:07.0: Signaling PME through PCIe PME interrupt
[    0.370391] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    0.370393] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.370397] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.370418] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd-
PwrCtrl- MRL- Interlock- NoCompl+ LLActRep+
[    0.370443] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    0.370445] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.370454] efifb: probing for efifb
[    0.370469] efifb: framebuffer at 0xe0000000, mapped to
0xffffc90005c00000, using 8640k, total 8640k
[    0.370470] efifb: mode is 1920x1080x32, linelength=8192, pages=1
[    0.370470] efifb: scrolling: redraw
[    0.370471] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.373331] Console: switching to colour frame buffer device 240x67
[    0.376127] fb0: EFI VGA frame buffer device
[    0.376132] intel_idle: MWAIT substates: 0x42120
[    0.376132] intel_idle: v0.4 model 0x3C
[    0.376133] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.376310] GHES: HEST is not enabled!
[    0.376350] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.376599] Linux agpgart interface v0.103
[    0.376638] rtc_cmos 00:02: RTC can wake from S4
[    0.376730] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.376751] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram,
hpet irqs
[    0.376758] Intel P-state driver initializing.
[    0.376901] ledtrig-cpu: registered to indicate activity on CPUs
[    0.377388] TCP: cubic registered
[    0.377621] NET: Registered protocol family 10
[    0.378132] NET: Registered protocol family 17
[    0.379061] Loading compiled-in X.509 certificates
[    0.379094] registered taskstats version 1
[    0.380507]   Magic number: 15:171:157
[    0.380572] acpi device:24: hash matches
[    0.380685] rtc_cmos 00:02: setting system clock to 2015-05-18 02:10:26
UTC (1431915026)
[    0.381233] PM: Hibernation image not present or could not be loaded.
[    0.381888] Freeing unused kernel memory: 1164K (ffffffff818e7000 -
ffffffff81a0a000)
[    0.381891] Write protecting the kernel read-only data: 8192k
[    0.382655] Freeing unused kernel memory: 600K (ffff88000156a000 -
ffff880001600000)
[    0.382913] Freeing unused kernel memory: 304K (ffff8800017b4000 -
ffff880001800000)
[    0.395844] random: systemd-tmpfile urandom read with 2 bits of entropy
available
[    0.403056] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:SYNM] at
0x60,0x64 irq 1,12
[    0.925886] i8042: Detected active multiplexing controller, rev 1.1
[    0.926027] SCSI subsystem initialized
[    0.928034] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.928044] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.928045] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.928045] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.928056] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.928101] ACPI: bus type USB registered
[    0.928235] usbcore: registered new interface driver usbfs
[    0.928246] usbcore: registered new interface driver hub
[    0.928274] usbcore: registered new device driver usb
[    0.928735] libata version 3.00 loaded.
[    0.928881] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.928889] sdhci: Secure Digital Host Controller Interface driver
[    0.928892] sdhci: Copyright(c) Pierre Ossman
[    0.929656] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.929660] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
number 1
[    0.929670] sdhci-pci 0000:03:00.0: SDHCI controller found [10ec:5250]
(rev 1)
[    0.929672] ehci-pci: EHCI PCI platform driver
[    0.929679] sdhci-pci 0000:03:00.0: enabling device (0000 -> 0002)
[    0.929731] mmc0: Unknown controller version (3). You may experience
problems.
[    0.929772] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.929785] sdhci-pci 0000:03:00.0: No vmmc regulator found
[    0.929786] sdhci-pci 0000:03:00.0: No vqmmc regulator found
[    0.929928] hub 1-0:1.0: USB hub found
[    0.929942] hub 1-0:1.0: 14 ports detected
[    0.930895] mmc0: SDHCI controller on PCI [0000:03:00.0] using PIO
[    0.932314] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.932316] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
number 2
[    0.932414] hub 2-0:1.0: USB hub found
[    0.932423] hub 2-0:1.0: 6 ports detected
[    0.933134] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    0.933683] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.933686] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus
number 3
[    0.933707] ehci-pci 0000:00:1a.0: debug port 2
[    0.937608] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.937616] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7117000
[    0.946502] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.946630] hub 3-0:1.0: USB hub found
[    0.946636] hub 3-0:1.0: 2 ports detected
[    0.946760] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.946763] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus
number 4
[    0.946772] ehci-pci 0000:00:1d.0: debug port 2
[    0.950661] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.950668] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7116000
[    0.959824] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.959954] hub 4-0:1.0: USB hub found
[    0.959957] hub 4-0:1.0: 2 ports detected
[    0.960026] ahci 0000:00:1f.2: version 3.0
[    0.960122] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    0.960144] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0xd
impl SATA mode
[    0.960146] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum
part ems sxs apst 
[    0.973460] scsi host0: ahci
[    0.973620] scsi host1: ahci
[    0.973751] scsi host2: ahci
[    0.973847] scsi host3: ahci
[    0.973884] ata1: SATA max UDMA/133 abar m2048@0xf7115000 port 0xf7115100
irq 33
[    0.973885] ata2: DUMMY
[    0.973887] ata3: SATA max UDMA/133 abar m2048@0xf7115000 port 0xf7115200
irq 33
[    0.973889] ata4: SATA max UDMA/133 abar m2048@0xf7115000 port 0xf7115280
irq 33
[    1.253672] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    1.267022] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.290399] usb 1-2: new full-speed USB device number 2 using xhci_hcd
[    1.293729] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.295038] ata1.00: ATA-8: HGST HTS721010A9E630, JB0OA3J0, max UDMA/133
[    1.295040] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.296492] ata1.00: configured for UDMA/133
[    1.296683] scsi 0:0:0:0: Direct-Access     ATA      HGST HTS721010A9
A3J0 PQ: 0 ANSI: 5
[    1.370513] tsc: Refined TSC clocksource calibration: 3990.758 MHz
[    1.377766] hub 3-1:1.0: USB hub found
[    1.377889] hub 3-1:1.0: 6 ports detected
[    1.391334] hub 4-1:1.0: USB hub found
[    1.391388] hub 4-1:1.0: 8 ports detected
[    1.617571] ata3: SATA link down (SStatus 0 SControl 300)
[    1.624255] usb 1-6: new high-speed USB device number 3 using xhci_hcd
[    1.938082] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.938440] ata4.00: supports DRM functions and may not be fully accessible
[    1.939127] ata4.00: disabling queued TRIM support
[    1.939130] ata4.00: ATA-10: Micron_M600_MTFDDAV512MBF, MU03, max UDMA/133
[    1.939131] ata4.00: 1000215216 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.940620] ata4.00: supports DRM functions and may not be fully accessible
[    1.941305] ata4.00: disabling queued TRIM support
[    1.942393] ata4.00: configured for UDMA/133
[    1.942573] scsi 3:0:0:0: Direct-Access     ATA      Micron_M600_MTFD
MU03 PQ: 0 ANSI: 5
[    1.943879] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00
TB/931 GiB)
[    1.943881] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.943887] ata4.00: Enabling discard_zeroes_data
[    1.943899] sd 3:0:0:0: [sdb] 1000215216 512-byte logical blocks: (512
GB/476 GiB)
[    1.943900] sd 3:0:0:0: [sdb] 4096-byte physical blocks
[    1.943958] sd 0:0:0:0: [sda] Write Protect is off
[    1.943959] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.943987] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.943988] sd 3:0:0:0: [sdb] Write Protect is off
[    1.943990] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.944011] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.944089] ata4.00: Enabling discard_zeroes_data
[    1.945098]  sdb: sdb1 sdb2
[    1.945204] ata4.00: Enabling discard_zeroes_data
[    1.945334] sd 3:0:0:0: [sdb] Attached SCSI disk
[    2.008148] usb 1-7: new full-speed USB device number 4 using xhci_hcd
[    2.210051]  sda: sda1
[    2.210607] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.372245] Switched to clocksource tsc
[    2.417342] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
Opts: (null)
[    2.680730] systemd[1]: Cannot add dependency job for unit
display-manager.service, ignoring: Unit display-manager.service failed to
load: No such file or directory.
[    2.748606] systemd-journald[181]: Received request to flush runtime
journal from PID 1
[    2.834574] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.840501] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    2.840598] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    2.840623] snd_hda_intel 0000:01:00.1: Disabling MSI
[    2.840626] snd_hda_intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    2.894806] sound hdaudioC0D0: autoconfig: line_outs=1
(0x17/0x0/0x0/0x0/0x0) type:line
[    2.894808] sound hdaudioC0D0:    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    2.894809] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    2.894810] sound hdaudioC0D0:    mono: mono_out=0x0
[    2.894811] sound hdaudioC0D0:    dig-out=0x1e/0x0
[    2.894812] sound hdaudioC0D0:    inputs:
[    2.894813] sound hdaudioC0D0:      Mic=0x18
[    2.894813] sound hdaudioC0D0:      Internal Mic=0x12
[    2.894814] sound hdaudioC0D0:      Line=0x1a
[    2.897021] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5
[    2.897025] ACPI: Power Button [PWRB]
[    2.897072] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input6
[    2.897074] ACPI: Sleep Button [SLPB]
[    2.897239] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input7
[    2.897274] ACPI: Lid Switch [LID0]
[    2.897398] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input8
[    2.897439] ACPI: AC Adapter [AC] (on-line)
[    2.897596] ACPI: Video Device [PEGP] (multi-head: yes  rom: no  post: no)
[    2.897742] ACPI: Power Button [PWRF]
[    2.897894] acpi device:01: registered as cooling_device8
[    2.897938] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/LNXVIDEO:00/input/input9
[    2.898450] wmi: Mapper loaded
[    2.900020] ACPI: Battery Slot [BAT0] (battery present)
[    2.902036] thermal LNXTHERM:00: registered as thermal_zone0
[    2.902037] ACPI: Thermal Zone [TZ0] (60 C)
[    2.904376] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/sound/card0/hdaudioC0D0/input10
[    2.904452] input: HDA Intel PCH Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    2.904468] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    2.904489] input: HDA Intel PCH Line Out as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    2.904504] input: HDA Intel PCH Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    2.905370] [drm] Initialized drm 1.1.0 20060810
[    2.905731] media: Linux media interface: v0.10
[    2.907325] input: PC Speaker as /devices/platform/pcspkr/input/input15
[    2.908155] Linux video capture interface: v2.00
[    2.908293] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.908299] r8169 0000:07:00.0: can't disable ASPM; OS doesn't have ASPM
control
[    2.911134] Bluetooth: Core ver 2.20
[    2.911144] NET: Registered protocol family 31
[    2.911145] Bluetooth: HCI device and connection manager initialized
[    2.911148] Bluetooth: HCI socket layer initialized
[    2.911150] Bluetooth: L2CAP socket layer initialized
[    2.911153] Bluetooth: SCO socket layer initialized
[    2.911951] ACPI Warning: SystemIO range
0x000000000000f000-0x000000000000f01f conflicts with OpRegion
0x000000000000f000-0x000000000000f00f (\_SB_.PCI0.SBUS.SMBI)
(20141107/utaddress-258)
[    2.911956] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    2.913781] r8169 0000:07:00.0 eth0: RTL8168g/8111g at
0xffffc900018ee000, 80:fa:5b:15:f6:1e, XID 0c000800 IRQ 36
[    2.913783] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes,
tx checksumming: ko]
[    2.923545] uvcvideo: Found UVC 1.00 device BisonCam, NB Pro (5986:066d)
[    2.925930] input: BisonCam, NB Pro as
/devices/pci0000:00/0000:00:14.0/usb1/1-6/1-6:1.0/input/input17
[    2.925954] usbcore: registered new interface driver uvcvideo
[    2.925955] USB Video Class driver (1.1.1)
[    2.943225] usbcore: registered new interface driver btusb
[    2.943605] iTCO_vendor_support: vendor-support=0
[    2.944112] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.944180] iTCO_wdt: Found a 9 Series TCO device (Version=2, TCOBASE=0x1860)
[    2.944270] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.945110] AVX2 version of gcm_enc/dec engaged.
[    2.945112] AES CTR mode by8 optimization enabled
[    2.945744] usb 1-7: Direct firmware load for ar3k/AthrBT_0x00000200.dfu
failed with error -2
[    2.945747] Bluetooth: Patch file not found ar3k/AthrBT_0x00000200.dfu
[    2.945776] Bluetooth: Loading patch file failed
[    2.945798] ath3k: probe of 1-7:1.0 failed with error -2
[    2.945820] usbcore: registered new interface driver ath3k
[    2.948659] r8169 0000:07:00.0 enp7s0: renamed from eth0
[    2.950655] nvidia: module license 'NVIDIA' taints kernel.
[    2.950657] Disabling lock debugging due to kernel taint
[    2.955287] vgaarb: device changed decodes:
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    2.955570] [drm] Initialized nvidia-drm 0.0.0 20150116 for 0000:01:00.0
on minor 0
[    2.955575] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  346.59  Tue
Mar 31 14:10:31 PDT 2015
[    2.959638] intel_rapl: Found RAPL domain package
[    2.959641] intel_rapl: Found RAPL domain core
[    2.959643] intel_rapl: Found RAPL domain dram
[    3.397425] input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input19
[    3.397519] input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input20
[    4.214260] psmouse serio2: synaptics: Touchpad model: 1, fw: 7.5, id:
0x1e0b1, caps: 0xd00033/0x240000/0xa0400, board id: 1474, fw id: 793787
[    4.251296] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio2/input/input18
[    4.252256] mousedev: PS/2 mouse device common for all mice
[    4.439007] random: nonblocking pool is initialized




-



https://wireless.wiki.kernel.org/en/users/drivers/ath3k suggests:

"You can use lsusb -v to check the device descriptor. If it's AR3011, the
iProduct value is 0. If it's AR3012 the iProduct value is 2."

On my machine, iProduct is 0, but it is supposedly not AR3011. It is AR3012,
so the iProduct should then be 2, but it's not.

I did attempt to individually symlink each of
/usr/lib/firmware/ar3k/AthrBT_*.dfu with
/usr/lib/firmware/ar3k/AthrBT_0x00000200.dfu, however, doing so, all
resulted in displaying:

# rmmod ath3k && modprobe ath3k
Bluetooth: Patch file version did not match with firmware
Bluetooth: Loading patch file failed


