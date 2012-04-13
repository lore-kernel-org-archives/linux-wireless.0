Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:39728 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932687Ab2DMNrt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 09:47:49 -0400
Subject: Interest in a driver for MT5921 wifi chip?
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: baseband-devel@lists.osmocom.org, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Date: Fri, 13 Apr 2012 15:47:41 +0200
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Message-Id: <201204131547.42617.heiko@sntech.de> (sfid-20120413_154753_663977_24CF5158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Synopsis
--------

I started on a driver for the MT5921 wlan chip from MediaTek and am now trying 
to find developers wo would be interested in this, as I don't have the 
necessary knowledge of the whole wireless part, or to determine if trying 
this is completely futile.

Available is:
- a (hopefully) nearly complete register-map of the chip
- my initial work of basic communication through its spi interface up to and 
including reading the chips eeprom
- a proprietary driver through which it's possible to log the spi-traffic

Also it seems I would be able to provide hardware to interested parties.


MT5921 and MediaTek
-------------------

The MT5921 [1] can be connected via SPI, SDIO, HPI and compact flash. It seems 
to be used mostly in phones based on MediaTek SoCs, but also gained a 
relatively wide spread through the ebook readers from Qisda (Oyo in germany, 
Fnacbook / Sagem Binder in france, bq Avant in spain, Positivo Alfa in brazil, 
Mr. Book in russia, ...).

MediaTek itself does not provide any information about the chip and also 
does not seem to answer inquiries [via various channels] at all.

>From talks to some of the device makers, I gathered that MediaTek also
completely refuses to release any material to them. The proprietary driver
mentioned above also seems to have been made by MediaTek directly.


The device
----------

I'm working on the Qisda ebook readers mentioned above (S3C2416 with 400MHz or 
S3C2450 with 533MHz depending on the device). The overall support at this 
point is quite good, including the driver for the epd controller, multitouch-
capable capacitive touchscreen, suspending and resuming the device.

Impressions of these devices can be found on [2].


I have a spare "Oyo 1" that was donated to me, that I could redonate for this
and it seems I could gain the support of one of the device makers, who will 
also supply a small number of devices, if I can find interested developers
for this endavour.


State of the driver
-------------------

The kernel release by Alcatel of their OT890 [3] did include headers describing
most of the chips registers and the eeprom structure of the sdio version. It
explicitly did non include sources for the wifi driver itself.

For things like chip signature and mac address, the eeprom struct also matches
the spi version, so I guess it could match also for most of the non-sdio stuff


On the Qisda devices modifying the underlying spi-dev driver makes it possible
to log the traffic the module sends to and receives from the chip.There also
exists a debug-version of the proprietary module that emits more in-depth
information on what it's currently doing [4].

I also build a crude script [5] to convert these dumps to a representation of
registers and constants form the header. There are probably better tools around
to do such things, but it made the reading of the dumps easier, like:

Array
(
    [mode] => write
    [register] => MCR_RFCR
    [reg-desc] => Receive Filter Control Register
    [valstr] => RFCR_RX_SAMEBSSIDPRORESP_CTRL | RFCR_RX_SAMEBSSIDBCN_CTRL
    [unmatched] => 0x0
)


As written above, bringup of and basic communication with the device
works and I'm lacking the necessary knowledge of the whole wireless part.


So, if anybody is interested in this I would be very happy :-) .


Thanks
Heiko




[1] http://www.mediatek.com/en/Products/product_content.php?sn=48
[2] http://www.youtube.com/user/MMind81
[3] http://sourceforge.net/projects/alcatel/files/
[4] examples in
https://gitorious.org/oyo-hack/kernel/blobs/topic/board/sg060/drivers/net/wireless/mt592x/mt5921-modprobe.log
https://gitorious.org/oyo-hack/kernel/blobs/topic/board/sg060/drivers/net/wireless/mt592x/mt5921-scan.log
[5] https://gitorious.org/oyo-hack/kernel/blobs/topic/board/sg060/drivers/net/wireless/mt592x/dump-to-defs.php
