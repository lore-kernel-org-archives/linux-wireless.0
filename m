Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:42981 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab0E0Jxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 05:53:43 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id o4R9rfIh000759
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 11:53:41 +0200
Received: from mail2.itwm.fhg.de ([131.246.191.79]:54177)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1)
	 (Exim 4.66 #1)
	id 1OHZmX-0000Ld-E5
	for linux-wireless@vger.kernel.org; Thu, 27 May 2010 11:53:41 +0200
Message-ID: <4BFE4124.2090601@itwm.fraunhofer.de>
Date: Thu, 27 May 2010 11:53:40 +0200
From: Martin Vogt <martin.vogt@itwm.fraunhofer.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: new bluetooth id for lenovo T410s?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a new Lenovo T410s with the compat-wireless package for 2.6.34.

My bluetooh chip seems not to work:

linux-4box:~ # lsusb | grep Broadcom
Bus 001 Device 005: ID 0a5c:217f Broadcom Corp.

This device id (from lsub) is missing in ./drivers/bluetooth/btusb.c:

/* IBM/Lenovo ThinkPad with Broadcom chip */
{ USB_DEVICE(0x0a5c, 0x201e), .driver_info = BTUSB_WRONG_SCO_MTU },
{ USB_DEVICE(0x0a5c, 0x2110), .driver_info = BTUSB_WRONG_SCO_MTU },

Most likely the T410s has this chip onboard:

Broadcom Model: BCM2045B (BDC-2).

But I haven't found any resources on the lenovo pages about that.
Only this:

http://www.thinkwiki.org/wiki/ThinkPad_Bluetooth_with_Enhanced_Data_Rate_(BDC-2.1)

Do you think I should add the ids to btusb.c?

+{ USB_DEVICE(0x0a5c, 0x217f), .driver_info = BTUSB_WRONG_SCO_MTU },

and test it?

regards,

Martin

