Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:28562 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXKSJIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 04:08:14 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Date: Mon, 19 Nov 2007 10:08:26 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>
References: <20071117023548.79a7a33c@morte>
In-Reply-To: <20071117023548.79a7a33c@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711191008.26174.hs4233@mail.mn-solutions.de> (sfid-20071119_090818_249992_3C4C2554)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Marvell USB8388, running on wireless-2.6. Firmware is:
> 421964206b0699014a11256ac48dd0a8  /lib/firmware/usb8388.bin

lsusb says "Bus 001 Device 003: ID 1286:2001". And when I insert 
the card, I see

usb 1-1: new high speed USB device using ehci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice

When I modprobes usb8xxx.ko (I have it in my module blacklist), I 
get an additional two lines:

libertas: eth1: Marvell WLAN 802.11 adapter
usbcore: registered new interface driver usb8xxx

After this, the USB stick works.



I use this firmware:

$ md5sum /lib/firmware/usb8388.bin
f1dfa0042efd61dc138b01fdf8c0cdab  /lib/firmware/usb8388.bin

As I got this firmware some months ago (and I hardly use this 
device), I cannot say which download link I've used.
