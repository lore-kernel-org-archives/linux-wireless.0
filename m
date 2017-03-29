Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:36365 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752982AbdC2Qda (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 12:33:30 -0400
Received: by mail-wr0-f181.google.com with SMTP id w11so22007669wrc.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 09:33:29 -0700 (PDT)
From: poma <pomidorabelisima@gmail.com>
Subject: Re: compile driver for rtl8192su
To: walter@strametz.eu, linux-wireless@vger.kernel.org
References: <CAMFBgyj=A4GmOyO3wkOgVLCOjc35RC4n8yJm+z+cxO3U=OH_qQ@mail.gmail.com>
Message-ID: <45d244a7-c1a9-0076-b39a-739204927a3b@gmail.com> (sfid-20170329_183448_864278_0B60C7F0)
Date: Wed, 29 Mar 2017 18:33:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAMFBgyj=A4GmOyO3wkOgVLCOjc35RC4n8yJm+z+cxO3U=OH_qQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29.03.2017 14:51, walter strametz wrote:
> Hi - I try to get my D-Link N300 running and compiled the sources on
> github (chunkeey - rtl8192su).  Other trials also failed, because the
> driver-source is not compatible with the (newer) kernel.
> 
> See more information in the enclosed textfile .
> 
> Can you help me?
> 
> Thx, Walter
> 

>From the aforementioned attachment - compileerror.txt
[...]
walter@thinkpad ~/rtl8192su $ lsusb
Bus 002 Device 004: ID 2001:3319 D-Link Corp. 
Bus 002 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0a5c:217f Broadcom Corp. BCM2045B (BDC-2.1)
Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
[...]

= Bus 002 Device 004: ID 2001:3319 D-Link Corp. =


Support - DWA-131 - Revision E
http://www.dlink.com/uk/en/support/product/dwa-131-wireless-n-nano-usb-adapter?revision=deu_reve#downloads
Drivers
ftp://ftp.dlink.eu/Products/dwa/dwa-131/driver_software/DWA-131_drv_revE_5-03_eu_multi_20161215.zip

$ unzip DWA-131_drv_revE_5-03_eu_multi_20161215.zip
$ unzip 20161124_DWA-131E_V5.04b03.zip

$ dos2unix < 20161124_DWA-131E_V5.04b03/Drivers/WinXPx86_Win2K/Dnetrtwlanu_XP.inf | grep 2001.*3319
%DLink_131E.DeviceDesc% 			= RTL8192eu.ndi, 	USB\VID_2001&PID_3319

........................................

D-Link DWA-131 (N300, USB, WiFi Adapter)
http://www.linux-hardware-guide.com/2013-11-16-d-link-dwa-131-n300-usb-wifi-adapter
...
Version E1: 2001:3319
A new version of the DWA-131 was identified with USB ID 2001:3319
Bus 001 Device 003: ID 2001:3319 D-Link Corp
and seems to be based on the Realtek RTL8192eu chipset.
...

http://support.dlink.com.au/download/download.aspx?product=DWA-131
Drivers
ftp://files.dlink.com.au/products/DWA-131/REV_E/Drivers/DWA-131_Linux_driver_v4.3.1.1.zip

$ unzip DWA-131_Linux_driver_v4.3.1.1.zip
$ tar xf 20140812_rtl8192EU_linux_v4.3.1.1_11320.tar.gz

$ grep 2001.*3319 20140812_rtl8192EU_linux_v4.3.1.1_11320/os_dep/linux/usb_intf.c
	{USB_DEVICE(0x2001, 0x3319),.driver_info = RTL8192E}, /* D-Link - DWA-131 */

...............................................

Drivers for the rtl8192eu chipset for wireless adapters (D-Link DWA-131 rev E1 included!)
https://github.com/Mange/rtl8192eu-linux-driver

$ git clone https://github.com/Mange/rtl8192eu-linux-driver.git
$ cd rtl8192eu-linux-driver/
$ make
$ modinfo 8192eu.ko | grep 2001.3319
alias:          usb:v2001p3319d*dc*dsc*dp*ic*isc*ip*in*
