Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0EARTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 13:19:39 -0400
Received: by fxm10 with SMTP id 10so1056805fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 10:19:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: ar9170-fw II
Date: Sat, 1 May 2010 19:19:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net>
In-Reply-To: <4BDC001F.9050202@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005011919.32016.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 May 2010 12:19:11 David H. Lynch Jr. wrote:
> I have ethernet driver experience but not wifi. I have a project to 
> add some features to the ar9170 that will require additions to the 
> firmware. I would appreciate pointers for docs etc. to get me started.

Well, for starters the ar9170 uses a ZyDas MAC (aka ZD1221)
and a AR900x PHY/Radio. Therefore the phy code and registers
are very similar to those #definitions you can find in ath9k.
And for the MAC code & registers you can look into zd1211rw,
or look into drivers/staging/otus (original vendor driver,
shares some code with their windows drivers)

AFAICT, there are no technical documents about the AR9170 
solution available w/o signing a NDA with Atheros
(probably because the devices are still produced and sold in high quantities?).

> What is available for the ar9170 itself ?
> How does the firmware and the linux driver communicate?
>   Is there an overview of the firmware - what is where ?

not really, apart from the headers of the original firmware 
and vendor drivers.

But if you really need to implement some of your 'features'
(what are they, if I may ask?) into the firmware you could
save some time by migrating to carl9170 code base:
( http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/1.0.5 
  + linville's wireless-testing.git )

The advantages over the original firmware code (from a developers POV) are:
 * customizable/configurable fw
	+ driver can auto detect all selected fw features

 * userspace testbench ( carlu ) for the usb subsystem
   (allows you to run usb stress-test, dump the device's eeprom content
    to stdout and of course: you can implement your own routines
    and test & develop without crashing the kernel)

 * all hardware & firmware interface definitions are all located 
   in a single directory /include/shared/*.h

	version.h	- carl9170 API/ABI version
	eeprom.h	- eeprom layout
	phy.h		- AR900x PHY/Radio definitions
	fwcmd.h		- implemented firmware commands
	fwdesc.h	- layout of the firmware descriptor (e.g. available/activated features)
	hw.h		- ZD1221 MAC + (Faraday USB) definitions
		wlan.h	- (part of hw.h & phy.h) contains all the information about
				  tx & rx frame formats.

 * (tiny) printf + hexdump (obviously, you want those ;-) )

 * follows linux' kernel coding style :-D

Regards,
	Chr
