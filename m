Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53219 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab2DEH1m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 03:27:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SFh6Z-00069X-8V
	for linux-wireless@vger.kernel.org; Thu, 05 Apr 2012 09:27:39 +0200
Received: from linuxconsulting.iasi.rdsnet.ro ([86.124.39.167])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 09:27:39 +0200
Received: from npavel by linuxconsulting.iasi.rdsnet.ro with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 09:27:39 +0200
To: linux-wireless@vger.kernel.org
From: Nicu Pavel <npavel@mini-box.com>
Subject: Re: Problem with the rtl8192cu - kernelmodule after ifdown, ifup
Date: Thu, 5 Apr 2012 07:27:27 +0000 (UTC)
Message-ID: <loom.20120405T091556-756@post.gmane.org> (sfid-20120405_092758_811722_834FE093)
References: <4F0EEA1B.3040501@wut.de> <4F0FA4DD.5020601@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I am using a USB WLAN - Stick with Realtek 8192 kernel driver. After 
plugging it
> > works fine, connecting to a WPA - network works. After ifdown wlan0, ifup 
wlan0
> > the stick no longer works , it stucks on scanning. Only a modprobe -r 
rtl8192cu;
> > modprobe rtl8192cu fixes the problem. The problem only appear if more than 
one
> > wireless - network is in range.The problem appear only in connection with 
the
> > rtl8192cu driver, other USB - sticks (with different Chipset) and other PCIE 
-
> > boards operate properly.
> > In order to reproduce the behavior repeat the sequenceifdown wlan0, ifup 
wlan0 a
> > few times.
[..]

After mode debugging with DBG_LOUD I found out that the difference when the 
driver is loaded/modprobed and ifdown/ifup to be a receive configuration 
register (RCR) value.

On bootup/modprobe:  ### Set RCR(0xf0002a0e) ###
On ifdown/ifup: ### Set RCR(0xf0002ace) ###

If I force RCR value to 0x2a0e in rtl92cu_set_hw_reg()inside HW_VAR_RCR case
everything works ok.

This seems to work with 3 different vendors USB sticks based on 8192cu chipset 
(Edimax, EDUP and some unknown vendor).

I tried looking up the bit values meanings from that register but couldn't find 
a proper spec.

Thanks,
Nicu Pavel

