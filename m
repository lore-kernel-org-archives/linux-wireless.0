Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58042 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683AbZJLKKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 06:10:41 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MxHqt-0000Q4-2o
	for linux-wireless@vger.kernel.org; Mon, 12 Oct 2009 12:10:03 +0200
Received: from bzq-79-176-17-15.red.bezeqint.net ([79.176.17.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 12:10:03 +0200
Received: from oshi by bzq-79-176-17-15.red.bezeqint.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 12:10:03 +0200
To: linux-wireless@vger.kernel.org
From: oshi <oshi@trego.co.il>
Subject: ar9170 network interface initialization failure 
Date: Mon, 12 Oct 2009 10:05:53 +0000 (UTC)
Message-ID: <loom.20091012T120512-386@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am trying to enable a Ubiquity SR71 device on x86 - ubuntu 9.04 (kernel
headers 2.6.28-15).

I built and installed compat-wireless-2009-10-09 on my machine.
ar9170 module is loaded and a network interface is created.

However when I try to bring up the interface, an error occurs:

ifconfig wlan3 up
SIOCSIFFLAGS: Operation not permitted

I managed to trace down the error to  a failure in usb_submit_urb() called from
ar9170_init_mac().


[70247.612064] usb 2-1: new high speed USB device using ehci_hcd and address 10
[70247.779863] usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x4 has
invalid maxpacket 64
[70247.792411] usb 2-1: configuration #1 chosen from 1 choice
[70247.910900] usb 2-1: reset high speed USB device using ehci_hcd and address 10
[70249.084059] usb 2-1: firmware: requesting ar9170.fw
[70249.096406] usb 2-1: ar9170.fw firmware file not found, trying old firmware...
[70249.096416] usb 2-1: firmware: requesting ar9170-1.fw
[70249.138585] usb 2-1: firmware: requesting ar9170-2.fw
[70249.568392] ath: EEPROM regdomain: 0x0
[70249.568397] ath: EEPROM indicates default country code should be used
[70249.568402] ath: doing EEPROM country->regdmn map search
[70249.568408] ath: country maps to regdmn code: 0x3a
[70249.568413] ath: Country alpha2 being used: US
[70249.568418] ath: Regpair used: 0x3a
[70249.568792] phy2: Selected rate control algorithm 'minstrel'
[70249.572212] ar9170_usb_exec_cmd line 399
[70249.572488] ar9170_usb_exec_cmd line 399
[70249.572820] Registered led device: ar9170-phy2::tx
[70249.572883] Registered led device: ar9170-phy2::assoc
[70249.572890] usb 2-1: Atheros AR9170 is registered as 'phy2'
[70249.588769] udev: renamed network interface wlan0 to wlan3
[70254.388224] ar9170_op_start 1259
[70254.388231] ar9170_init_mac 147
[70254.388257] ar9170_usb_exec_cmd usb_submit_urb err -1 
[70254.391839] ar9170_usb_exec_cmd usb_submit_urb err -1 
[70254.391846] usb 2-1: USB setup failed (-1).
[70262.056330] ar9170_usb_exec_cmd usb_submit_urb err -1 
[70262.056338] usb 2-1: USB setup failed (-1).


The problem occurs also when using the single firmware file.
All the process was performed as root.

Am I missing any configuration phase?
Are there any usb patches i am missing?

Any suggestion will be appreciated.

Thanks,
Oshi


