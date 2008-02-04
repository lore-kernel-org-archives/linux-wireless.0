Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s30.bay0.hotmail.com ([65.54.246.230]:19751 "EHLO
	bay0-omc3-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583AbYBDWX5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 17:23:57 -0500
Message-ID: <BAY101-W217643374DBB20E5EBF086C8330@phx.gbl> (sfid-20080204_222402_103742_EACE381E)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: mac80211 crypto_alloc_blkcipher("ecb(arc4)") call is failing
Date: Mon, 4 Feb 2008 17:23:56 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I just compiled a new 2.6.24 kernel with arc4 compiled into the kernel and still the rt73usb driver gives the following output:
 
rt73usb 1-1:1.0: usb_probe_interface
rt73usb 1-1:1.0: usb_probe_interface - got id
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 18 (level, low) -> IRQ 19
snd-ca0106: Model 1006 Rev 00000000 Serial 10061102
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x0000
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002 573a.
phy0: Selected rate control algorithm 'simple'
phy0: Failed to initialize wep
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt73usb: probe of 1-1:1.0 failed with error -12
usbcore: registered new interface driver rt73usb
 
Despite the statement about registering the new interface driver rt73usb, the interface is not created.  Ivo said the problem appears to be that the crypto_alloc_blkcipher is failing in mac80211.  Can someone please tell me what is wrong and get a fix into 2.6.24.1?
 
Thanks,
Adam
_________________________________________________________________
Connect and share in new ways with Windows Live.
http://www.windowslive.com/share.html?ocid=TXT_TAGHM_Wave2_sharelife_012008