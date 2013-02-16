Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:53474 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3BPTjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 14:39:31 -0500
Date: Sat, 16 Feb 2013 20:39:33 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] rt2800usb_txdone_entry_check: Warning - TX status
 report missed for queue XX entry ZZ
Message-ID: <20130216193933.GA2158@localhost.localdomain> (sfid-20130216_203935_904433_01D23873)
References: <5119664D.9030902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5119664D.9030902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Feb 11, 2013 at 10:44:45PM +0100, Xose Vazquez Perez wrote:
> ( 3.7.6-102.fc17.x86_64 + compat-drivers-3.8-rc7-1 )
> 
> with this device:
> usb 2-1.5: new high-speed USB device number 9 using ehci_hcd
> usb 2-1.5: New USB device found, idVendor=148f, idProduct=5370
> usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-1.5: Product: 802.11 n WLAN
> usb 2-1.5: Manufacturer: Ralink
> usb 2-1.5: SerialNumber: 1.0
> usb 2-1.5: reset high-speed USB device number 9 using ehci_hcd
> phy4 -> rt2x00_set_chip: Info - Chipset detected - rt: 5390, rf: 5370, rev: 0502.
> ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
> Registered led device: rt2800usb-phy4::radio
> Registered led device: rt2800usb-phy4::assoc
> Registered led device: rt2800usb-phy4::quality
> phy4 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
> phy4 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.33.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> 
> and debug enabled, I see a lot of:
> Feb 11 22:34:28 chuchi kernel: [  935.675466] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
> Feb 11 22:34:29 chuchi kernel: [  935.745710] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11
> Feb 11 22:34:29 chuchi kernel: [  935.747333] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 12

We discussed this some time ago. Basically those messages can be
ignored. Thread below give some more light on the problem:
http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/497

Stanislaw
