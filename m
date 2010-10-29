Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:48533 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754404Ab0J2UCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 16:02:35 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Realtek rtl8188 support?
Date: Fri, 29 Oct 2010 22:02:22 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <201010282348.16673.s.L-H@gmx.de> <4CC9F4BE.7070500@lwfinger.net>
In-Reply-To: <4CC9F4BE.7070500@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010292202.25486.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Friday 29 October 2010, Larry Finger wrote:
> On 10/28/2010 04:48 PM, Stefan Lippers-Hollmann wrote:
> > 
> > I assume you refer to rtl8712u.bin in your r8712u_firmware tree:
> > http://git.kernel.org/?p=linux/kernel/git/lwfinger/r8712u_firmware.git;a=blob_plain;f=rtl8712u.bin
> > 200fd952db3cc9259b1fd05e3e51966f  *rtl8712u.bin
> > 
> >> you want to grab the new firmware package, I can send you a copy of the patch.
> > 
> > I'd very much like to test the patch(2) needed for rtl8712, if possible.
> 
> Attached is the patch. You should place rtl8712u.bin in
> /lib/modules/rtl8712u/rtl8712u.bin.
200fd952db3cc9259b1fd05e3e51966f */lib/firmware/rtl8712u/rtl8712u.bin
[...]


Given this module only needs one firmware image, what about dropping that 
subdirectory?

My tests with RTL8188S and RTL8191S are very successful so far, including 
the imaginable cornercases (missing firmware, wrong firmware file, etc.).

RTL8188S:
[  104.239032] usb 1-9: new high speed USB device using ehci_hcd and address 4
[  104.355650] usb 1-9: New USB device found, idVendor=0bda, idProduct=8171
[  104.355658] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  104.355664] usb 1-9: Product: RTL8188S WLAN Adapter 
[  104.355669] usb 1-9: Manufacturer: Manufacturer Realtek 
[  104.355673] usb 1-9: SerialNumber: 00e04c000001
[  104.386766] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
[  104.393694] r8712u: DriverVersion: v7_0.20100831
[  104.393728] r8712u: register rtl8712_netdev_ops to netdev_ops
[  104.393735] r8712u: USB_SPEED_HIGH with 4 endpoints
[  104.394644] r8712u: Boot from EFUSE: Autoload OK
[  104.908448] r8712u: CustomerID = 0x0000
[  104.908454] r8712u: MAC Address from efuse = 00:08:54:99:6f:99
[  104.910922] usbcore: registered new interface driver r8712u
[  120.721878] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[  135.957515] lo: Disabled Privacy Extensions
[  155.603760] r8712u: Loading firmware from "rtl8712u/rtl8712u.bin"
[  156.246429] r8712u: 1 RCR=0x153f00e
[  156.247462] r8712u: 2 RCR=0x553f00e
[  156.352536] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  162.190670] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  166.025559] r8712u: [r8712_got_addbareq_event_callback] mac = 00:27:19:fe:47:84, seq = 16, tid = 0
[  172.226017] wlan1: no IPv6 routers present
[  629.891124] r8712u: [r8712_got_addbareq_event_callback] mac = 00:27:19:fe:47:84, seq = 16, tid = 6

RTL8191S:
[  573.003014] usb 1-3: new high speed USB device using ehci_hcd and address 6
[  573.119503] usb 1-3: New USB device found, idVendor=0bda, idProduct=8172
[  573.119507] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  573.119509] usb 1-3: Product: RTL8191S WLAN Adapter 
[  573.119511] usb 1-3: Manufacturer: Manufacturer Realtek 
[  573.119513] usb 1-3: SerialNumber: 00e04c000001
[  573.128096] r8712u: module is from the staging directory, the quality is unknown, you have been warned.
[  573.130926] r8712u: DriverVersion: v7_0.20100831
[  573.130939] r8712u: register rtl8712_netdev_ops to netdev_ops
[  573.130942] r8712u: USB_SPEED_HIGH with 4 endpoints
[  573.131499] r8712u: Boot from EFUSE: Autoload OK
[  573.584756] r8712u: CustomerID = 0x0000
[  573.584759] r8712u: MAC Address from efuse = 00:02:72:8c:05:16
[  573.585488] usbcore: registered new interface driver r8712u
[  598.630199] r8712u: Loading firmware from "rtl8712u/rtl8712u.bin"
[  599.264458] r8712u: 1 RCR=0x153f00e
[  599.265210] r8712u: 2 RCR=0x553f00e
[  599.370062] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  604.898813] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  607.391186] r8712u: [r8712_got_addbareq_event_callback] mac = 00:27:19:fe:47:84, seq = 16, tid = 0
[  615.266009] wlan1: no IPv6 routers present
[ 2346.336558] r8712u: [r8712_got_addbareq_event_callback] mac = 00:27:19:fe:47:84, seq = 32, tid = 6

With both devices the connection is stable and quite performant (~9 MB/s, 
short distance, little channel overlap) against an Atheros/ athk9 based 
router running OpenWrt (HT20 && HT40-, b/g/n). In comparison to rtl8192su
the authentification handshake succeeds a lot quicker and without needing 
retries, performance is comparable.

I'm following up this mail with a patch covering two minor changes, 
selecting FW_LOADER in Kconfig and declaring MODULE_FIRMWARE, feel free 
to merge them into your patch.

Thank you a lot, regards
	Stefan Lippers-Hollmann
