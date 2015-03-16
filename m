Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:36502 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbbCPQlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:41:03 -0400
Date: Mon, 16 Mar 2015 17:41:00 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
Message-ID: <20150316164100.GA6208@linutronix.de> (sfid-20150316_174108_473823_B0FB858C)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150316160652.789B313FBE6@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Kalle Valo | 2015-03-16 16:06:52 [+0000]:

>Thanks, 3 patches applied to wireless-drivers-next.git:

Thanks. Do you guys have any kind of further documentation? Where did 
you get the firmware from? Is it the vendor driver in better shape and
firmware excracted from header files?
The reason I'm asking is that I have a small script that switches
between AP & Managed mode and after a while the show ends with:

|wlan0: authenticate with XX
|wlan0: send auth to XX (try 1/3)
|wlan0: authenticated
|wlan0: associate with XX (try 1/3)
|wlan0: RX AssocResp fromXX (capab=0x1411 status=0 aid=3)
|IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
|wlan0: associated
|wlan0: dropped frame to XX (unauthorized port)
Managed mode complete.

|wlan0: deauthenticating from XX by local choice (Reason: 3=DEAUTH_LEAVING)
|cfg80211: Calling CRDA to update world regulatory domain
|ieee80211 phy0: rt2800usb_write_firmware: Info - Firmware loading not required - NIC in AutoRun mode
|IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
|IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
switch to AP mode done.

And this should be where it switches back to managed mode
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3200 with error -110 val: 0 type 40
|ieee80211 phy0: rt2800usb_write_firmware: Info - Firmware is written.
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x7014 with error -110 val: 0 type 40
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x701c with error -110 val: 0 type 40
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x01 failed for offset 0x0000 with error -110 val: 8 type 40
|ieee80211 phy0: rt2800usb_write_firmware: Error - Failed to write Firmware to device
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -110 val: 0 type c0
… mode of these…
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -110 val: 0 type c0
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0400 with error -110 val: 0 type c0
|ieee80211 phy0: rt2800_load_firmware: Error - PBF system register not ready
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x7010 with error -110 val: 0 type c0
… mode of these…
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x7010 with error -110 val: 0 type 40
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0404 with error -110 val: 0 type 40
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x1000 with error -110 val: 0 type c0
|ieee80211 phy0: rt2800_wait_csr_ready: Error - Unstable hardware 
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x7010 with error -110 val: 0 type c0
|ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x7010 with error -110 val: 0 type 40

at this point the stick is dead. Dead as in I think I get -110 for every
USB reqeust. The only thing that helps is to replug the USB stick since
it does not even accept a new device number after a USB-reset.
Since the error happens by the time the firmware is written could it be
that the firmware was not yet ready to receive a new one? Since it does
not answer at all I think it blue screened :)

>
>Kalle Valo

Sebastian
