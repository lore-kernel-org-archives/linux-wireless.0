Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28668 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZCXBwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 21:52:22 -0400
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
  dereference
From: Martin Capitanio <martin@capitanio.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Larry.Finger@lwfinger.net, herton@mandriva.com.br,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
References: <1237849455.16745.41.camel@marvin>
	 <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:52:07 +0100
Message-Id: <1237859527.5714.60.camel@marvin> (sfid-20090324_025226_879469_EA35CC29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, den 23.03.2009, 16:10 -0700 schrieb Luis R. Rodriguez: 
> On Mon, Mar 23, 2009 at 4:04 PM, Martin Capitanio <martin@capitanio.org> wrote:
> > Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=EU)
> > seems to be working, but afterwards inserting the rtl8187 driver causes crash:
> 
> Please try with today's wireless-testing a set of fixes went in to

Sure, I tried "DE" with the same result as well.

Fortunately, wireless-testing doesn't crash during the rtl8187 driver load
anymore, but changing the regulatory domain seems to be no-op (see below).

Furthermore the current wireless-testing breaks the rtl8187 driver completely.
If I try to connect to an AP (with or without changing the domain),
it hard-freezes the kernel without any log entry.

> address a bug with "EU". Mind you, "EU" is an invalid ISO3166-alpha2
> so you may want to consider start using your own valid country alpha2
> code. If you use "EU" now you'll world roam.

I wonder why is there than the EU (confusing) code at all?
Actually I would expect a "smallest common intersection" of the 27 European
Union member states.

Martin

----
2.6.29-rc8-wl at commit 8fe80c672051978895d0c3ef7be1dc7bcaa8621e

[   14.724111] cfg80211: Using static regulatory domain info
[   14.724154] cfg80211: Regulatory domain: US
[   14.724186]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   14.724233]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[   14.724267]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.724300]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.724334]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.724367]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[   14.724402]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[   14.724453] cfg80211: Calling CRDA for country: US
[   14.731855] usbcore: registered new interface driver hiddev
[   14.734528] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input6
[   14.744220] generic-usb 0003:046D:C526.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[   14.749224] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.1/input/input7
[   14.760185] generic-usb 0003:046D:C526.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[   14.761508] usbcore: registered new interface driver usbhid
[   14.762406] usbhid: v2.6:USB HID core driver
[   14.785424] uvcvideo: Found UVC 1.00 device CNF7051 (04f2:b070)
[   14.787514] input: CNF7051 as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input8
[   14.795375] Bluetooth: Generic Bluetooth USB driver ver 0.4
[   14.795520] usbcore: registered new interface driver btusb
[   14.874378] usbcore: registered new interface driver uvcvideo
[   14.874417] USB Video Class driver (v0.1.0)
[   15.384073] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x9280b1, caps: 0xa04711/0xa04000
[   15.406636] rtl8187: 8187B chip detected.
[   15.407152] phy0: Selected rate control algorithm 'minstrel'


modprobe -r rtl8187
modprobe -r cfg80211
modprobe cfg80211 ieee80211_regdom=DE
[  570.676064] usbcore: deregistering interface driver rtl8187
[  570.944071] usb 2-6: reset high speed USB device using ehci_hcd and address 4
[  687.552176] cfg80211: Using static regulatory domain info
[  687.552182] cfg80211: Regulatory domain: US
[  687.552186] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  687.552191] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[  687.552196] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  687.552201] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  687.552206] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  687.552210] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  687.552215] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[  687.552501] cfg80211: Calling CRDA for country: DE

modprobe rtl8187
[  731.873109] rtl8187: 8187B chip detected.
[  731.877283] phy0: Selected rate control algorithm 'minstrel'
[  731.877990] phy0: hwaddr , RTL8187BvE V0 + rtl8225z2
[  731.878047] usbcore: registered new interface driver rtl8187

iw reg get
country US:
	(2402 - 2472 @ 40), (6, 27)
	(5170 - 5190 @ 40), (6, 23)
	(5190 - 5210 @ 40), (6, 23)
	(5210 - 5230 @ 40), (6, 23)
	(5230 - 5330 @ 40), (6, 23)
	(5735 - 5835 @ 40), (6, 30)

iw reg set DE
iw reg get
country US:
	(2402 - 2472 @ 40), (6, 27)
	(5170 - 5190 @ 40), (6, 23)
	(5190 - 5210 @ 40), (6, 23)
	(5210 - 5230 @ 40), (6, 23)
	(5230 - 5330 @ 40), (6, 23)
	(5735 - 5835 @ 40), (6, 30)


iw list
Wiphy phy0
	Band 1:
		Frequencies:
			* 2412 MHz [1] (27.0 dBm)
			* 2417 MHz [2] (27.0 dBm)
			* 2422 MHz [3] (27.0 dBm)
			* 2427 MHz [4] (27.0 dBm)
			* 2432 MHz [5] (27.0 dBm)
			* 2437 MHz [6] (27.0 dBm)
			* 2442 MHz [7] (27.0 dBm)
			* 2447 MHz [8] (27.0 dBm)
			* 2452 MHz [9] (27.0 dBm)
			* 2457 MHz [10] (27.0 dBm)
			* 2462 MHz [11] (27.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates:
			* 1.0 Mbps
			* 2.0 Mbps
			* 5.5 Mbps
			* 11.0 Mbps
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	Supported interface modes:
		 * Station
		 * Monitor


