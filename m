Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:45303 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2GXTCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 15:02:12 -0400
Received: from xhc-rcd-x05.cisco.com (xhc-rcd-x05.cisco.com [173.37.183.79])
	by rcdn-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q6OIqbfE030003
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 18:52:37 GMT
From: "Balaji Ravindran (balravin)" <balravin@cisco.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Help requested troubleshooting compilation of rt3573 driver for
 cisco ae3000
Date: Tue, 24 Jul 2012 18:52:36 +0000
Message-ID: <781BD600E733884C96CCDD5DF04A71C1023B3B@xmb-rcd-x14.cisco.com> (sfid-20120724_210216_181237_BA445F60)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I request help to make my cisco AE3000 wireless usb work with my Ubuntu 12.04 64 bit server OS. I tried the following, and everything was in vain. So please pass me on some pointers.

 1.      Started off with ndiswrapper.

	a.      Looked for Windows XP driver from CD packaging and tried load it with ndiswrapper 1.57, but it is not working because, cisco does not provide a 64 bit windows xp driver, so ndiswrapper complains saying 64 bit kernel detected.

	b.      I did give a shot with using 64bit windows vista and windows 7 drivers included in the CD package even though I knew ndiswrapper will not support vista or win 7 drivers.

2.      RT drivers are opensource (yay!) so identified the hardware Id for the product it was (13b1:003b) comes with rt3573 chipset (I confirm that). So I downloaded the latest RT3573 chipset driver from their RALINK website, and still no use.
I successfully built and installed the rt3573sta.ko under /lib/modules/(shell $(uname -r))..... and was successfully able to modprobe the module. But still I did not see the device's model was recognized as a WiFi device. 
Output of 'lsusb' still showed up 'Linksys'

 3.      Step further, under /common/rtusb_dev_id.c I waslooking for the USB device id, and I could'nt find a match for 13b1:003b., so created a new device id, and rebuilt the driver

	a.      Make clean, make uninstall, make install.
	b.      Driver built successfully, still did not detect the device

4.      In vain tried the default included rt2800usb module., and did
	a.      sudo depmod -a
	b.      sudo modprobe -v rt2800usb
	c.      Module loaded successfully, and still in vain, driver not detected.

Any help here would be much appreciated? Anything I missed out or I could try., please help.

Thanks

 
Balaji R

---
Thanks 'n' Regards

Balaji R

