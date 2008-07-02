Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zoltar.telenet-ops.be ([195.130.132.57]:37664 "EHLO
	zoltar.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYGBUbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 16:31:16 -0400
Message-ID: <486BE592.6040006@yahoo.co.uk> (sfid-20080702_223123_664190_3200A158)
Date: Wed, 02 Jul 2008 22:31:14 +0200
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
References: <486BB5D4.4010701@yahoo.co.uk> <200807021926.29266.chunkeey@web.de>
In-Reply-To: <200807021926.29266.chunkeey@web.de>
Content-Type: multipart/mixed;
 boundary="------------080201020101000602020603"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080201020101000602020603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Chr wrote:
> On Wednesday 02 July 2008 19:07:32 Ivo Couckuyt wrote:
>   
>> sent this a while ago, but might be filtered due to attachment (removed
>> now):
>>
>> i tried the following firmwares:
>> 2.4.4.0.arm  2.4.6.0.arm
>> 2.5.11.0.arm 2.5.6.0.arm 2.5.2.0.arm 2.7.0.0.arm
>> All give the same dmesg output, (HC died; cleaning up)
>> except 2.5.8.0.arm which gives something else, probably not worth much,
>> but nevertheless see attachment
>>
>> In the very beginning I used ndiswrapper without any problem (still
>> works now), but at the moment i'm using the old islsm driver together
>> with kernel 2.6.9 and firmware 2.5.6.0 (only one that works), which
>> doesn't seem to be on the site you mentioned
>> md5sum:
>> 6ff238179cf9618aac2b5d7a34e41450  2.5.6.0.arm (is included for what it
>> is worth)
>>     
>
> No, your post didn't get lost...
>
> however I don't know what's wrong with it, as my USB device is 
> probably ?still? sitting in the custom office.. *sigh*. And even then, 
> when I'll finally get it... It probably differs alot from yours.
>
> However... the p54 code has sometimes some timing problems, 
> that islsm didn't have?! so what happends have you add some
> delays inside the the initialization/probe code?
>   
Added several delays (mdelay(200) )in the probe and/or init code didn't 
change a thing (except that it takes longer before it gets to the part 
where it errors :-) ).
I also added some prints to narrow it down (tedious work, have to 
restart everytime i make a change). dmesg log is attached (ILM: 
statements were added).

snippet of changed code where it seems to fail, it is in p54usc.c
function p54u_upload_firmware_net2280:
...
    printk(KERN_INFO "ILM: usb_interrupt...\n" );

    err = usb_interrupt_msg(priv->udev,
                usb_rcvbulkpipe(priv->udev, P54U_PIPE_INT),
                buf, sizeof(__le32), &alen, 1000);
    printk(KERN_INFO "ILM: call finished (error %i) 
(sizeof(__le32)=%i=%i)...\n", err, sizeof(__le32), alen );
    if (err || alen != sizeof(__le32))
        goto fail;

    mdelay(200);
    P54U_READ(NET2280_DEV_U32, &devreg->int_ident);
    P54U_WRITE(NET2280_DEV_U32, &devreg->int_ack, reg);

    if (!(reg & cpu_to_le32(ISL38XX_INT_IDENT_INIT)))
        err = -EINVAL;
    printk(KERN_INFO "ILM: some read/acks: error %i", err  );

    P54U_WRITE(NET2280_BRG_U32, NET2280_USBIRQENB1, 0);
    P54U_WRITE(NET2280_BRG_U32, NET2280_IRQSTAT1,
           cpu_to_le32(NET2280_PCI_INTA_INTERRUPT));

    printk(KERN_INFO "ILM: startup firmware OK\n" );
...

so the usb_interrupt thing might be related somehow (causes the HC 
failed), or it is just that the usb stick should send 'keep-alive' irq's 
but doesn't because initialization before that has actually failed ? 
(don't know
anything about kernel dev, just guessing here).

so the
P54U_READ(NET2280_DEV_U32, &devreg->int_ident);
P54U_WRITE(NET2280_DEV_U32, &devreg->int_ack, reg);
causes the actually 'goto fail'.
> (BTW: do you have a "lsusb -v" of the wlan stick somewhere?)
>   
sure, attached.


> Regards,
> 	Christian 
>
>   

--------------080201020101000602020603
Content-Type: text/plain;
 name="lsusb.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lsusb.out"

Bus 001 Device 002: ID 083a:5501 Accton Technology Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x083a Accton Technology Corp.
  idProduct          0x5501 
  bcdDevice            2.02
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           95
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints          11
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8d  EP 13 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0d  EP 13 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8e  EP 14 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x0e  EP 14 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x8f  EP 15 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled


--------------080201020101000602020603
Content-Type: text/plain;
 name="2.6.25_debug.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.25_debug.dmesg"

896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   229376
On node 0 totalpages: 229376
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.2 present.
ACPI: RSDP 000F75C0, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF30C0, 43E7 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: APIC 3FFF74C0, 006E (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227584
Kernel command line: root=/dev/hdb3
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1830.012 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 904820k/917504k available (2894k kernel code, 12196k reserved, 943k data, 196k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
    vmalloc : 0xf8800000 - 0xffff4000   ( 119 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc04c2000 - 0xc04f3000   ( 196 kB)
      .data : 0xc03d3a36 - 0xc04bf918   ( 943 kB)
      .text : 0xc0100000 - 0xc03d3a36   (2894 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 3663.11 BogoMIPS (lpj=7326232)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) XP 2500+ stepping 00
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0820)
net_namespace: 440 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb4a0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: nForce2 C1 Halt Disconnect fixup
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs *18)
ACPI: PCI Interrupt Link [APC4] (IRQs *19)
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23)
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
system 00:00: ioport range 0x4000-0x407f has been reserved
system 00:00: ioport range 0x4080-0x40ff has been reserved
system 00:00: ioport range 0x4400-0x447f has been reserved
system 00:00: ioport range 0x4480-0x44ff has been reserved
system 00:00: ioport range 0x4200-0x427f has been reserved
system 00:00: ioport range 0x4280-0x42ff has been reserved
system 00:01: ioport range 0x5000-0x503f has been reserved
system 00:01: ioport range 0x5500-0x553f has been reserved
system 00:02: iomem range 0xd1800-0xd3fff has been reserved
system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
system 00:02: iomem range 0xfc000-0xfffff could not be reserved
system 00:02: iomem range 0x3fff0000-0x3fffffff could not be reserved
system 00:02: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:02: iomem range 0x0-0x9ffff could not be reserved
system 00:02: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:02: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
PCI: Bridge: 0000:00:08.0
  IO window: 9000-9fff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: a000-afff
  MEM window: 0xe4000000-0xe5ffffff
  PREFETCH window: 0x00000000c0000000-0x00000000dfffffff
PCI: Setting latency timer of device 0000:00:08.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
type=2000 audit(1215036259.316:1): initialized
NTFS driver 2.1.29 [Flags: R/O].
io scheduler noop registered (default)
pci 0000:02:00.0: Boot video device
lp: driver loaded but no devices found
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc 00:0c: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE2: 0000:00:09.0 (rev a2) UDMA133 controller
NFORCE2: IDE controller (0x10de:0x0065 rev 0xa2) at  PCI slot 0000:00:09.0
NFORCE2: not 100% native mode: will probe irqs later
NFORCE2: BIOS didn't set cable bits correctly. Enabling workaround.
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: Maxtor 6Y080L0, ATA DISK drive
hdb: ST340016A, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: TSSTcorpCD/DVDW SH-S182D, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-52327S, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160086528 sectors (81964 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1 hda2 < hda5 >
hdb: max request size: 128KiB
hdb: 78165360 sectors (40020 MB) w/2048KiB Cache, CHS=65535/16/63
hdb: cache flushes not supported
 hdb: hdb1 hdb2 hdb3
hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
Driver 'sd' needs updating - please use bus_type methods
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUB2] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 11, io mem 0xe6000000
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 11, io mem 0xe6004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUBB] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 5, io mem 0xe6005000
hub 1-0:1.0: unable to enumerate USB device on port 4
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
Initializing USB Mass Storage driver...
usb 1-5: new high speed USB device using ehci_hcd and address 3
usb 1-5: configuration #1 chosen from 1 choice
usb 3-2: new low speed USB device using ohci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
i2c /dev entries driver
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5500
input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
scsi 0:0:0:0: Direct-Access     Maxtor 6 L200P0           0000 PQ: 0 ANSI: 0
sd 0:0:0:0: [sda] 398297088 512-byte hardware sectors (203928 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 27 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 398297088 512-byte hardware sectors (203928 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 27 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
usb-storage: device scan complete
drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
drivers/hid/usbhid/hid-core.c: timeout initializing reports
input: Logitech Inc. WingMan Extreme Digital 3D as /class/input/input4
input: USB HID v1.00 Joystick [Logitech Inc. WingMan Extreme Digital 3D] on usb-0000:00:02.1-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
Linux agpgart interface v0.103
agpgart: Detected NVIDIA nForce2 chipset
agpgart: AGP aperture is 64M @ 0xe0000000
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:04.0 to 64
forcedeth 0000:00:04.0: ifname eth0, PHY OUI 0x20 @ 1, addr 00:0c:6e:2b:95:8f
forcedeth 0000:00:04.0: timirq lnktim desc-v1
EXT3 FS on hdb3, internal journal
NTFS volume version 3.1.
eth0: no link during initialization.
Adding 500464k swap on /dev/hdb2.  Priority:-1 extents:1 across:500464k
usb 1-1: new high speed USB device using ehci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
ILM: net2280 uploading...
p54: LM86 firmware
p54: FW rev 2.5.6.0 - Softmac protocol 3.0
ILM: request_firmware + parse_firmware OK
ILM: power up bridge OK
ILM: still OK
ILM: bridge setup OK
ILM: boot device OK
ILM: upload firmware OK
ILM: ramboot OK
ILM: usb_interrupt...
ehci_hcd 0000:00:02.2: HC died; cleaning up
usb 1-1: USB disconnect, address 4
ILM: call finished (error 0) (sizeof(__le32)=4=4)...
ILM: done uploading (error -19)
usb 1-5: USB disconnect, address 3
usbcore: registered new interface driver prism54usb

--------------080201020101000602020603--
