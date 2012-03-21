Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:35464 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759743Ab2CUSGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 14:06:49 -0400
Date: Wed, 21 Mar 2012 18:58:00 +0100
From: David Madore <david+ml@madore.org>
To: linux-wireless@vger.kernel.org
Subject: ath9k_htc fails with "Target is unresponsive"
Message-ID: <20120321175800.GA28516@aldebaran.gro-tsen.net> (sfid-20120321_190653_801696_4C6EE95B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(I'm aware that the following might be more of a USB problem than a
Wireless problem, but I guess I need someone wiser than me to
translate the problem in terms that can be submitted to wherever Linux
USB problems should be submitted.)

I have an Atheros AR9271-based, TP-LINK model TL-WN422G USB wireless
dongle (USB id 0cf3:1006; full output of lsusb -v is copied at
bottom), which I'm trying to use with ath9k_htc from kernel version
3.2.12.  For what it's worth, the host system is an ARM-based Marvell
DreamPlug (the USB host adapter is orion-ehci; incidentally, the whole
point of using this dongle was that the Marvell SD8787 is unsupported
in master mode).

Initially, the dongle works.  But after a system reset, ath9k_htc
fails to load the firmware with a "Target is unresponsive" error, and
it becomes impossible to do anything unless I physically unplug and
replug the dongle.  (Unfortunately for me, this operation is not
acceptable, and having to do this makes the whole darn thing
completely useless.)

Here's what ath_9k says when it fails to initialize the dongle:

[  156.507543] usb 1-1.3: new high-speed USB device number 6 using orion-ehci
[  161.947765] usb 1-1.3: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[  162.947189] ath9k_htc 1-1.3:1.0: ath9k_htc: Target is unresponsive
[  162.953411] Failed to initialize the device
[  162.959828] ath9k_htc: probe of 1-1.3:1.0 failed with error -22

And here's what it says when it suceeds:

[  204.006037] usb 1-1.3: new high-speed USB device number 7 using orion-ehci
[  204.456763] usb 1-1.3: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[  204.691885] ath9k_htc 1-1.3:1.0: ath9k_htc: HTC initialized with 33 credits
[  204.889776] ath9k_htc 1-1.3:1.0: ath9k_htc: FW Version: 1.3
[  204.895387] ath: EEPROM regdomain: 0x809c
<snip many lines concerning regulatory domains>
[  204.913054] ieee80211 phy2: Atheros AR9271 Rev:1
[  204.920392] usb 1-1.3: ath9k_htc: USB layer initialized

I also tried resetting the device with the usbreset program found at
<URL:
http://cpansearch.perl.org/src/DPAVLIN/Biblio-RFID-0.03/examples/usbreset.c
 >, but it does not suffice (in fact, using it produced the "failed"
log reproduced above).  Any suggestions on performing a deeper USB
reset (one that would be equivalent to unplugging and replugging the
dongle) would be welcome: the comments in the program mentioned above
suggest writing to /sys/bus/usb/devices/${id}/power/state but this no
longer exists and I was unable to find a replacement.

Any suggestions on debugging the problem, or finding a way to make the
thing not completely useless, would be very welcome.

Other than that, if someone can suggest a USB wireless dongle model
which is fully supported under Linux (including master mode) and does
not have this kind of problem, I'd be very grateful.

Lastly here is the output of "lsusb -v" for the device:

Bus 001 Device 007: ID 0cf3:1006 Atheros Communications, Inc. TP-Link TL-WN322G v3 / TL-WN422G v2 802.11g [Atheros AR9271]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  idVendor           0x0cf3 Atheros Communications, Inc.
  idProduct          0x1006 TP-Link TL-WN322G v3 / TL-WN422G v2 802.11g [Atheros AR9271]
  bcdDevice            1.08
  iManufacturer          16 ATHEROS
  iProduct               32 USB2.0 WLAN
  iSerial                48 12345
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           60
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
      bNumEndpoints           6
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x05  EP 5 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x06  EP 6 OUT
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
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass       255 Vendor Specific Subclass
  bDeviceProtocol       255 Vendor Specific Protocol
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
