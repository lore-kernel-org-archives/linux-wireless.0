Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59632 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0E0Ksi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 06:48:38 -0400
Subject: Re: new bluetooth id for lenovo T410s?
From: Marcel Holtmann <marcel@holtmann.org>
To: Martin Vogt <martin.vogt@itwm.fraunhofer.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4BFE4124.2090601@itwm.fraunhofer.de>
References: <4BFE4124.2090601@itwm.fraunhofer.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 12:47:56 +0200
Message-ID: <1274957276.4706.4.camel@aeonflux.t-mobile.de>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Martin,

so first of all, this is the wrong mailing list. You should be using
linux-bluetooth@vger.kernel.org.

> I have a new Lenovo T410s with the compat-wireless package for 2.6.34.
> 
> My bluetooh chip seems not to work:
> 
> linux-4box:~ # lsusb | grep Broadcom
> Bus 001 Device 005: ID 0a5c:217f Broadcom Corp.
> 
> This device id (from lsub) is missing in ./drivers/bluetooth/btusb.c:
> 
> /* IBM/Lenovo ThinkPad with Broadcom chip */
> { USB_DEVICE(0x0a5c, 0x201e), .driver_info = BTUSB_WRONG_SCO_MTU },
> { USB_DEVICE(0x0a5c, 0x2110), .driver_info = BTUSB_WRONG_SCO_MTU },

Please send in the output of /proc/bus/usb/devices for your devices
since I doubt it is not supported. There are general interface
descriptors that make the devices work. Only if Lenovo screwed something
up, then this is needed.

Regards

Marcel


