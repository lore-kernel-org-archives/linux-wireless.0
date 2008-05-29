Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:13464 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbYE2U57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 16:57:59 -0400
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: wimax@linuxwimax.org, linux-wireless@vger.kernel.org
Subject: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050 v1.2
Date: Thu, 29 May 2008 13:57:47 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805291357.47910.inaky@linux.intel.com> (sfid-20080529_225803_515524_FD09554F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi All


Intel would like to announce the 1.2 release of the Linux WiMAX common
stack and drivers for its WiMAX devices (eg: Intel(r) WiMAX/WiFi </WiFi>
Link 5050, with estimated availability around third quarter of 2008).

You can find the code and additional information at http://linuxwimax.org.

The changes from release 1.1 to 1.2 are:

* WiMAX network service:*

   1. Support for semi-manual and auto scan modes.
   2. Support for preferred and wide scan types.
   3. Support for FW based SSL implementation. This does not quite work
      yet (fix expected soon). There exists the ability to switch
      (dynamic) between a host based OpenSSL implementation and a FW
      based SSL.
   4. Statistics and device details
   5. Daemon mode operation for wimax network service
   6. Miscellaneous stability related fixes. 

* WiMAX kernel stack and drivers:

General

   1. Debug levels can be changed in runtime.
   2. General cleanup and removal of dead code 

WiMAX kernel stack

   1. Add RF-Kill subsystem integration and wimax_rfkill() API call.
   2. Documentation update 

Intel 2400m WiMAX driver

   1. Remove old IOCTL legacy control interface and other unused code.
   2. Add new firmware upload mechanism, deprecate the old one.
   3. Integrate into WiMAX stack's rfkill framework
   4. Split the driver into device / transport specific parts. The
      device becomes the i200m.ko module (the driver core) and the USB
      specific driver becomes i2400m-usb.ko, that uses the core as a
      "library".
   5. Export RX and TX statistics on sysfs
   6. RX path uses skb_clone() to minimize memory pressure; buffer size
      is now dynamically grown on-demand instead of always allocating 64k.
   7. New TX engine based on a FIFO (to lower memory pressure). 



-- 
Inaky
