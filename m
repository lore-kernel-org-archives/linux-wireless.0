Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:58112 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbcGFHoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 03:44:30 -0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "linux@rempel-privat.de" <linux@rempel-privat.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"anders.darander@gmail.com" <anders.darander@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"fixed-term.Oleksij.Rempel@de.bosch.com"
	<fixed-term.Oleksij.Rempel@de.bosch.com>,
	"linux-snps-arc@lists.infradead.org"
	<linux-snps-arc@lists.infradead.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: ath9k-htc on OHCI -> bogus usb xfer
Date: Wed, 6 Jul 2016 07:44:19 +0000
Message-ID: <1467790987.3086.15.camel@synopsys.com> (sfid-20160706_094436_025464_8DC22F3B)
References: <1467721137.3144.81.camel@synopsys.com>
	 <577BED2D.7070209@rempel-privat.de> <1467739821.3086.13.camel@synopsys.com>
	 <577C041C.7080905@rempel-privat.de>
In-Reply-To: <577C041C.7080905@rempel-privat.de>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi+AKA-Oleksij,

On Tue, 2016-07-05 at 21:01 +-0200, Oleksij Rempel wrote:
+AD4- Am 05.07.2016 um 19:31 schrieb Alexey Brodkin:
+AD4- +AD4- 
+AD4- +AD4- Hi Oleksij,
+AD4- +AD4- 
+AD4- +AD4- On Tue, 2016-07-05 at 19:23 +-0200, Oleksij Rempel wrote:
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Hi,
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Am 05.07.2016 um 14:20 schrieb Alexey Brodkin:
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Hello,
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Looks like this is another manifestation of already seen problem with ath9k-htc
+AD4- +AD4- +AD4- +AD4- and OHCI controller.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- I'm trying to get USB Wi-Fi dongle based on Atheros AR9271 to work with our
+AD4- +AD4- +AD4- +AD4- development board (this is Synopsys AXS103) and seeing a picture very similar to
+AD4- +AD4- +AD4- +AD4- what was discussed here http://thread.gmane.org/gmane.linux.usb.general/110847
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Below is what I see on insertion of the dongle.
+AD4- +AD4- +AD4- +AD4- Note I have the most recent ath9k-htc firmware (see +ACI-ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw+ACI-
+AD4- +AD4- +AD4- +AD4- in the log below) and Linux kernel is 4.6.3 (latest stable as of today) but the same
+AD4- +AD4- +AD4- +AD4- happens even on 4.4.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Interesting enough if I simply remove or disable the warning like that
+AD4- +AD4- +AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- +AD4- +AD4- diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
+AD4- +AD4- +AD4- +AD4- index 3d27477..a317e1e 100644
+AD4- +AD4- +AD4- +AD4- --- a/drivers/usb/core/urb.c
+AD4- +AD4- +AD4- +AD4- +-+-+- b/drivers/usb/core/urb.c
+AD4- +AD4- +AD4- +AD4- +AEAAQA- -443,11 +-443,6 +AEAAQA- int usb+AF8-submit+AF8-urb(struct urb +ACo-urb, gfp+AF8-t mem+AF8-flags)
+AD4- +AD4- +AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgACo- cause problems in HCDs if they get it wrong.
+AD4- +AD4- +AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgACo-/
+AD4- +AD4- +AD4- +AD4- +AKA-
+AD4- +AD4- +AD4- +AD4- -+AKAAoACgAKAAoACgAKA-/+ACo- Check that the pipe's type matches the endpoint's type +ACo-/
+AD4- +AD4- +AD4- +AD4- -+AKAAoACgAKAAoACgAKA-if (usb+AF8-pipetype(urb-+AD4-pipe) +ACEAPQ- pipetypes+AFs-xfertype+AF0-)
+AD4- +AD4- +AD4- +AD4- -+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-dev+AF8-WARN(+ACY-dev-+AD4-dev, +ACI-BOGUS urb xfer, pipe +ACU-x +ACEAPQ- type +ACU-x+AFw-n+ACI-,
+AD4- +AD4- +AD4- +AD4- -+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-usb+AF8-pipetype(urb-+AD4-pipe), pipetypes+AFs-xfertype+AF0-)+ADs-
+AD4- +AD4- +AD4- +AD4- -
+AD4- +AD4- +AD4- +AD4- +AKAAoACgAKAAoACgAKAAoA-/+ACo- Check against a simple/standard policy +ACo-/
+AD4- +AD4- +AD4- +AD4- +AKAAoACgAKAAoACgAKAAoA-allowed +AD0- (URB+AF8-NO+AF8-TRANSFER+AF8-DMA+AF8-MAP +AHw- URB+AF8-NO+AF8-INTERRUPT +AHw- URB+AF8-DIR+AF8-MASK +AHw-
+AD4- +AD4- +AD4- +AD4- +AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-URB+AF8-FREE+AF8-BUFFER)+ADs-
+AD4- +AD4- +AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- +AD4- +AD4- everything seem to work quite nice.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Any thoughts are much appreciated.
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- That's the log itself:
+AD4- +AD4- +AD4- +AD4- ------------------------+AD4-8---------------------------
+AD4- +AD4- +AD4- +AD4- usb 1-1: new full-speed USB device number 2 using ohci-platform
+AD4- +AD4- +AD4- +AD4- usb 1-1: ath9k+AF8-htc: Firmware ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw requested
+AD4- +AD4- +AD4- +AD4- usb 1-1: ath9k+AF8-htc: Transferred FW: ath9k+AF8-htc/htc+AF8-9271-1.4.0.fw, size: 51008
+AD4- +AD4- +AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- +AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- +AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- +AD4- +AD4- Modules linked in:
+AD4- +AD4- +AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.6.3 +ACM-10
+AD4- +AD4- +AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Stack Trace:
+AD4- +AD4- +AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- +AD4- +AD4- ---+AFs- end trace 2249b79eac9991d1 +AF0----
+AD4- +AD4- +AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- +AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- +AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- +AD4- +AD4- Modules linked in:
+AD4- +AD4- +AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
+AD4- +AD4- +AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Stack Trace:
+AD4- +AD4- +AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- +AD4- +AD4- ---+AFs- end trace 2249b79eac9991d2 +AF0----
+AD4- +AD4- +AD4- +AD4- ------------+AFs- cut here +AF0-------------
+AD4- +AD4- +AD4- +AD4- WARNING: CPU: 0 PID: 4 at drivers/usb/core/urb.c:450 usb+AF8-submit+AF8-urb+-0x162/0x404
+AD4- +AD4- +AD4- +AD4- usb 1-1: BOGUS urb xfer, pipe 1 +ACEAPQ- type 3
+AD4- +AD4- +AD4- +AD4- Modules linked in:
+AD4- +AD4- +AD4- +AD4- CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G+AKAAoACgAKAAoACgAKAAoA-W+AKAAoACgAKAAoACgAKA-4.6.3 +ACM-10
+AD4- +AD4- +AD4- +AD4- Workqueue: events request+AF8-firmware+AF8-work+AF8-func
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- Stack Trace:
+AD4- +AD4- +AD4- +AD4- +AKA- arc+AF8-unwind+AF8-core.constprop.1+-0x94/0x10c
+AD4- +AD4- +AD4- +AD4- ---+AFs- end trace 2249b79eac9991d3 +AF0----
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- please send content of hif+AF8-usb+AF8-send+AF8-regout() from your source code.
+AD4- +AD4- +AD4- It is located in drivers/net/wireless/ath/ath9k/hif+AF8-usb.c
+AD4- +AD4- I use vanilla 4.6.3 tree so that's what I have is the same as
+AD4- +AD4- http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/net/wireless/ath/ath9k/hif+AF8-usb.c?h+AD0-
+AD4- +AD4- linu
+AD4- +AD4- x-4.6.y+ACM-n99
+AD4-
+AD4- Interesting.
+AD4- Can you please send lsusb -v for this adapter?

See below:
--------------------------+AD4-8---------------------------
+ACM- lsusb -v

Bus 002 Device 002: ID 0cf3:9271+AKAAoA-
Device Descriptor:
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-18
+AKA- bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-1
+AKA- bcdUSB+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-2.00
+AKA- bDeviceClass+AKAAoACgAKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bDeviceSubClass+AKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bDeviceProtocol+AKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bMaxPacketSize0+AKAAoACgAKAAoACgAKAAoA-64
+AKA- idVendor+AKAAoACgAKAAoACgAKAAoACgAKAAoA-0x0cf3+AKA-
+AKA- idProduct+AKAAoACgAKAAoACgAKAAoACgAKA-0x9271+AKA-
+AKA- bcdDevice+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-1.08
+AKA- iManufacturer+AKAAoACgAKAAoACgAKAAoACgAKA-16 ATHEROS
+AKA- iProduct+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-32 USB2.0 WLAN
+AKA- iSerial+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-48 12345
+AKA- bNumConfigurations+AKAAoACgAKAAoACg-1
+AKA- Configuration Descriptor:
+AKAAoACgAKA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKA-wTotalLength+AKAAoACgAKAAoACgAKAAoACgAKAAoA-60
+AKAAoACgAKA-bNumInterfaces+AKAAoACgAKAAoACgAKAAoACgAKA-1
+AKAAoACgAKA-bConfigurationValue+AKAAoACgAKAAoA-1
+AKAAoACgAKA-iConfiguration+AKAAoACgAKAAoACgAKAAoACgAKA-0+AKA-
+AKAAoACgAKA-bmAttributes+AKAAoACgAKAAoACgAKAAoACg-0x80
+AKAAoACgAKAAoACg-(Bus Powered)
+AKAAoACgAKA-MaxPower+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-500mA
+AKAAoACgAKA-Interface Descriptor:
+AKAAoACgAKAAoACg-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKAAoACg-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-4
+AKAAoACgAKAAoACg-bInterfaceNumber+AKAAoACgAKAAoACgAKAAoA-0
+AKAAoACgAKAAoACg-bAlternateSetting+AKAAoACgAKAAoACgAKA-0
+AKAAoACgAKAAoACg-bNumEndpoints+AKAAoACgAKAAoACgAKAAoACgAKAAoA-6
+AKAAoACgAKAAoACg-bInterfaceClass+AKAAoACgAKAAoACgAKA-255+AKA-
+AKAAoACgAKAAoACg-bInterfaceSubClass+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-bInterfaceProtocol+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-iInterface+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-0+AKA-
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x01+AKAAoA-EP 1 OUT
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Bulk
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-0
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x82+AKAAoA-EP 2 IN
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Bulk
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-0
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x83+AKAAoA-EP 3 IN
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-3
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Interrupt
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-1
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x04+AKAAoA-EP 4 OUT
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Bulk
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-0
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x05+AKAAoA-EP 5 OUT
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Bulk
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-0
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x06+AKAAoA-EP 6 OUT
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Bulk
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0040+AKAAoA-1x 64 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-0
Device Qualifier (for other device speed):
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-10
+AKA- bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-6
+AKA- bcdUSB+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-2.00
+AKA- bDeviceClass+AKAAoACgAKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bDeviceSubClass+AKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bDeviceProtocol+AKAAoACgAKAAoACgAKA-255+AKA-
+AKA- bMaxPacketSize0+AKAAoACgAKAAoACgAKAAoA-64
+AKA- bNumConfigurations+AKAAoACgAKAAoACg-1
can't get debug descriptor: Resource temporarily unavailable
Device Status:+AKAAoACgAKAAoA-0x0000
+AKA- (Bus Powered)

Bus 002 Device 001: ID 1d6b:0001+AKAAoA-
Device Descriptor:
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-18
+AKA- bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-1
+AKA- bcdUSB+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-1.10
+AKA- bDeviceClass+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-9+AKA-
+AKA- bDeviceSubClass+AKAAoACgAKAAoACgAKAAoACg-0+AKA-
+AKA- bDeviceProtocol+AKAAoACgAKAAoACgAKAAoACg-0+AKA-
+AKA- bMaxPacketSize0+AKAAoACgAKAAoACgAKAAoA-64
+AKA- idVendor+AKAAoACgAKAAoACgAKAAoACgAKAAoA-0x1d6b+AKA-
+AKA- idProduct+AKAAoACgAKAAoACgAKAAoACgAKA-0x0001+AKA-
+AKA- bcdDevice+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-4.06
+AKA- iManufacturer+AKAAoACgAKAAoACgAKAAoACgAKAAoA-3 Linux 4.6.3 ohci+AF8-hcd
+AKA- iProduct+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-2 Generic Platform OHCI controller
+AKA- iSerial+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-1 e0060000.ohci
+AKA- bNumConfigurations+AKAAoACgAKAAoACg-1
+AKA- Configuration Descriptor:
+AKAAoACgAKA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKA-wTotalLength+AKAAoACgAKAAoACgAKAAoACgAKAAoA-25
+AKAAoACgAKA-bNumInterfaces+AKAAoACgAKAAoACgAKAAoACgAKA-1
+AKAAoACgAKA-bConfigurationValue+AKAAoACgAKAAoA-1
+AKAAoACgAKA-iConfiguration+AKAAoACgAKAAoACgAKAAoACgAKA-0+AKA-
+AKAAoACgAKA-bmAttributes+AKAAoACgAKAAoACgAKAAoACg-0xe0
+AKAAoACgAKAAoACg-Self Powered
+AKAAoACgAKAAoACg-Remote Wakeup
+AKAAoACgAKA-MaxPower+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-0mA
+AKAAoACgAKA-Interface Descriptor:
+AKAAoACgAKAAoACg-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKAAoACg-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-4
+AKAAoACgAKAAoACg-bInterfaceNumber+AKAAoACgAKAAoACgAKAAoA-0
+AKAAoACgAKAAoACg-bAlternateSetting+AKAAoACgAKAAoACgAKA-0
+AKAAoACgAKAAoACg-bNumEndpoints+AKAAoACgAKAAoACgAKAAoACgAKAAoA-1
+AKAAoACgAKAAoACg-bInterfaceClass+AKAAoACgAKAAoACgAKAAoACg-9+AKA-
+AKAAoACgAKAAoACg-bInterfaceSubClass+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-bInterfaceProtocol+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-iInterface+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-0+AKA-
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x81+AKAAoA-EP 1 IN
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-3
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Interrupt
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0002+AKAAoA-1x 2 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-255
Hub Descriptor:
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-9
+AKA- bDescriptorType+AKAAoACgAKAAoACg-41
+AKA- nNbrPorts+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-1
+AKA- wHubCharacteristic 0x0002
+AKAAoACgAKA-No power switching (usb 1.0)
+AKAAoACgAKA-Ganged overcurrent protection
+AKA- bPwrOn2PwrGood+AKAAoACgAKAAoACgAKAAoA-2 +ACo- 2 milli seconds
+AKA- bHubContrCurrent+AKAAoACgAKAAoACg-0 milli Ampere
+AKA- DeviceRemovable+AKAAoACgAKA-0x00
+AKA- PortPwrCtrlMask+AKAAoACgAKA-0xff
+AKA-Hub Port Status:
+AKAAoACg-Port 1: 0000.0103 power enable connect
can't get debug descriptor: Resource temporarily unavailable
Device Status:+AKAAoACgAKAAoA-0x0001
+AKA- Self Powered

Bus 001 Device 001: ID 1d6b:0002+AKAAoA-
Device Descriptor:
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-18
+AKA- bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-1
+AKA- bcdUSB+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-2.00
+AKA- bDeviceClass+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-9+AKA-
+AKA- bDeviceSubClass+AKAAoACgAKAAoACgAKAAoACg-0+AKA-
+AKA- bDeviceProtocol+AKAAoACgAKAAoACgAKAAoACg-0+AKA-
+AKA- bMaxPacketSize0+AKAAoACgAKAAoACgAKAAoA-64
+AKA- idVendor+AKAAoACgAKAAoACgAKAAoACgAKAAoA-0x1d6b+AKA-
+AKA- idProduct+AKAAoACgAKAAoACgAKAAoACgAKA-0x0002+AKA-
+AKA- bcdDevice+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-4.06
+AKA- iManufacturer+AKAAoACgAKAAoACgAKAAoACgAKAAoA-3 Linux 4.6.3 ehci+AF8-hcd
+AKA- iProduct+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-2 EHCI Host Controller
+AKA- iSerial+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-1 e0040000.ehci
+AKA- bNumConfigurations+AKAAoACgAKAAoACg-1
+AKA- Configuration Descriptor:
+AKAAoACgAKA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-2
+AKAAoACgAKA-wTotalLength+AKAAoACgAKAAoACgAKAAoACgAKAAoA-25
+AKAAoACgAKA-bNumInterfaces+AKAAoACgAKAAoACgAKAAoACgAKA-1
+AKAAoACgAKA-bConfigurationValue+AKAAoACgAKAAoA-1
+AKAAoACgAKA-iConfiguration+AKAAoACgAKAAoACgAKAAoACgAKA-0+AKA-
+AKAAoACgAKA-bmAttributes+AKAAoACgAKAAoACgAKAAoACg-0xe0
+AKAAoACgAKAAoACg-Self Powered
+AKAAoACgAKAAoACg-Remote Wakeup
+AKAAoACgAKA-MaxPower+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-0mA
+AKAAoACgAKA-Interface Descriptor:
+AKAAoACgAKAAoACg-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-9
+AKAAoACgAKAAoACg-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-4
+AKAAoACgAKAAoACg-bInterfaceNumber+AKAAoACgAKAAoACgAKAAoA-0
+AKAAoACgAKAAoACg-bAlternateSetting+AKAAoACgAKAAoACgAKA-0
+AKAAoACgAKAAoACg-bNumEndpoints+AKAAoACgAKAAoACgAKAAoACgAKAAoA-1
+AKAAoACgAKAAoACg-bInterfaceClass+AKAAoACgAKAAoACgAKAAoACg-9+AKA-
+AKAAoACgAKAAoACg-bInterfaceSubClass+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-bInterfaceProtocol+AKAAoACgAKAAoACg-0+AKA-
+AKAAoACgAKAAoACg-iInterface+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-0+AKA-
+AKAAoACgAKAAoACg-Endpoint Descriptor:
+AKAAoACgAKAAoACgAKAAoA-bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-7
+AKAAoACgAKAAoACgAKAAoA-bDescriptorType+AKAAoACgAKAAoACgAKAAoACg-5
+AKAAoACgAKAAoACgAKAAoA-bEndpointAddress+AKAAoACgAKAAoA-0x81+AKAAoA-EP 1 IN
+AKAAoACgAKAAoACgAKAAoA-bmAttributes+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-3
+AKAAoACgAKAAoACgAKAAoACgAKA-Transfer Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACg-Interrupt
+AKAAoACgAKAAoACgAKAAoACgAKA-Synch Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-None
+AKAAoACgAKAAoACgAKAAoACgAKA-Usage Type+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-Data
+AKAAoACgAKAAoACgAKAAoA-wMaxPacketSize+AKAAoACgAKAAoA-0x0004+AKAAoA-1x 4 bytes
+AKAAoACgAKAAoACgAKAAoA-bInterval+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoA-12
Hub Descriptor:
+AKA- bLength+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACg-9
+AKA- bDescriptorType+AKAAoACgAKAAoACg-41
+AKA- nNbrPorts+AKAAoACgAKAAoACgAKAAoACgAKAAoACgAKA-1
+AKA- wHubCharacteristic 0x0009
+AKAAoACgAKA-Per-port power switching
+AKAAoACgAKA-Per-port overcurrent protection
+AKA- bPwrOn2PwrGood+AKAAoACgAKAAoACgAKA-10 +ACo- 2 milli seconds
+AKA- bHubContrCurrent+AKAAoACgAKAAoACg-0 milli Ampere
+AKA- DeviceRemovable+AKAAoACgAKA-0x00
+AKA- PortPwrCtrlMask+AKAAoACgAKA-0xff
+AKA-Hub Port Status:
+AKAAoACg-Port 1: 0000.0100 power
can't get device qualifier: Resource temporarily unavailable
can't get debug descriptor: Resource temporarily unavailable
Device Status:+AKAAoACgAKAAoA-0x0001
+AKA- Self Powered
--------------------------+AD4-8---------------------------

+AD4- and it will be
+AD4- interesting to see, which usb endpoint was actualy used.

Any hints on how may I get this information?

-Alexey