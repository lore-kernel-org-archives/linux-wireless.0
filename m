Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [85.48.160.4] ([85.48.160.4]:51162 "EHLO barney.it.uc3m.es"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502AbZGGPh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 11:37:29 -0400
From: Peter Breuer <ptb@inv.it.uc3m.es>
Message-Id: <200907071526.n67FQICE002753@barney.it.uc3m.es>
Subject: dead RT2501USB ?
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Tue, 7 Jul 2009 17:26:18 +0200 (CEST)
Reply-To: ptb@cs.bham.ac.uk
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day

I'm trying to get a 2501 Ralink USB stick working. I've never had any
success with it in any kernel I've tried.

Right now I have the stick in my athlon 64 bit machine, Linux kernel:

   2.6.30.1,
   
and a fair bit of debugging compiled. I'd like to tap your
help on getting it going, or deciding what the matter is. 

Firstly: lsusb output:

  Bus 005 Device 002: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter

(I'll add the verbose output later, but I suspect you're more
interested in what the driver has to say).



Loaading the  rt73usb module produces this stack (after a fair old delay
for the modprobe to come back)

rt73usb                29288  0 
crc_itu_t               2144  1 rt73usb
rt2x00usb              11360  1 rt73usb
rt2x00lib              33760  2 rt73usb,rt2x00usb
led_class               5112  1 rt2x00lib
input_polldev           4552  1 rt2x00lib
mac80211              195720  2 rt2x00usb,rt2x00lib
cfg80211               71000  2 rt2x00lib,mac80211

Dmesg says:

  [ 2108.751153] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -110.
  [ 2108.782851] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - MAC: 26:e2:39:8d:0d:6d
  [ 2111.283108] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3000 with error -110.
  [ 2111.315495] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0000, rev: ffff8800.
  [ 2111.344071] phy0 -> rt73usb_init_eeprom: Error - Invalid RT chipset detected.
  [ 2111.365594] phy0 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
  [ 2111.394416] usbcore: registered new interface driver rt73usb

So it thinks it's not the right chipset. Perhaps I should add an
identification line somewhere in the code?

Taking the stick out and reinserting it produces better output:

  [ 3047.942955] usb 5-1: USB disconnect, address 2
  [ 3057.399019] usb 5-1: new high speed USB device using ehci_hcd and address 4
  [ 3057.691030] usb 5-1: configuration #1 chosen from 1 choice
  [ 3057.982680] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
  [ 3057.982687] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
  [ 3057.982691] phy1 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
  [ 3057.982915] phy1 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
  [ 3058.026194] phy1: Selected rate control algorithm 'minstrel'
  [ 3058.057978] Registered led device: rt73usb-phy1::radio
  [ 3058.108090] Registered led device: rt73usb-phy1::assoc
  [ 3058.153068] Registered led device: rt73usb-phy1::quality
  [ 3058.317082] phy1 -> rt2x00lib_request_firmware: Info - Loading
  firmware file 'rt73.bin'.
  [ 3058.447020] rt73usb 5-1:1.0: firmware: requesting rt73.bin
  [ 3058.614883] phy1 -> rt2x00lib_request_firmware: Error - Failed to request Firmware.
  [ 3059.709337] usbcore: registered new interface driver rt2500usb

and this time interface wlan0 comes up:

wlan0     IEEE 802.11bg  ESSID:""  
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
          Tx-Power=0 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I can set the key and mode and then essid with iwconfig, with no error,
but the device does not associate. It looks like some registers are set
but nothing physically happens:

wlan0     IEEE 802.11bg  ESSID:"Livebox-C338"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
          Tx-Power=0 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Encryption key:B0F7-22C1-FD33-4554-B083-B7C7-5C   Security mode:open
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

If I try and set the access point with iwconfig, there's again no
complaint but no change in the association status. A "commit" with
iwconfig raises a snot supported error:

% sudo iwconfig wlan0 commit
Error for wireless request "Commit changes" (8B00) :
    SET failed on device wlan0 ; Operation not supported.

Kismet also fails on a ioctl and won't talk.

 Source 0 (rt2500): Enabling monitor mode for rt2500 source interface
 wlan0 channel 6...
 Waiting for server to start before starting UI...
 FATAL: SetIFFlags: Unknown interface wlan0: No such file or directory

 [pid 28715] ioctl(3, SIOCGIFFLAGS, 0x7fffc65100b0) = 0
 [pid 28715] ioctl(3, SIOCSIFFLAGS...
 [pid 28715] <... ioctl resumed> , 0x7fffc65100b0) = -1 ENOENT (No such file or directory)


The full lsusb output is


Bus 005 Device 004: ID 148f:2573 Ralink Technology, Corp. RT2501USB
Wireless Adapter
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x148f Ralink Technology, Corp.
  idProduct          0x2573 RT2501USB Wireless Adapter
  bcdDevice            0.01
  iManufacturer           1 Ralink
  iProduct                2 802.11 bg WLAN
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              300mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0 
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)



Yes, the access point is working. I'm connected to it from an atheros
card build into my TP now.

Regards, and here's hoping somebody can offer some advice.

Peter
