Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45161 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFGO01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 10:26:27 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MDJKL-0002LS-Qf
	for linux-wireless@vger.kernel.org; Sun, 07 Jun 2009 14:26:26 +0000
Received: from p5086E73E.dip.t-dialin.net ([80.134.231.62])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 14:26:25 +0000
Received: from sparcoular by p5086E73E.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 14:26:25 +0000
To: linux-wireless@vger.kernel.org
From: Markus <sparcoular@t-online.de>
Subject: Re: bcm43xx 5.10.38.35 firmware
Date: Sun, 7 Jun 2009 14:26:00 +0000 (UTC)
Message-ID: <loom.20090607T140512-723@post.gmane.org>
References: <loom.20090607T124008-575@post.gmane.org> <4A2BBD98.4040708@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> Markus wrote:
> > Hello,
> > 
> > 
> > after MacOSX Airport firmware update 5.10.38.35
> > 
> > (bcm43xx/ Macbook Core2Duo SR)
> > 
> > I cannot connect to my Wlan-Router anymore.
> > 
> > 
> > The b43-module gets modprobed without errors
> > 
> > and nm-applet shows my Access-Points SSID.
> > 
> > Alas, it won't establish a connection to it.
> > 
> > 
> > Any clues?
> 
> Please post all items in dmesg that pertain to ssb or b43 using
> 
> dmesg | egrep "ssb|b43"
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------------------

dmesg | egrep "ssb|b43"


[  101.205300] b43-pci-bridge 0000:02:00.0: PCI
INT A -> GSI 16 (level, low) -> IRQ 16

[  101.205322] b43-pci-bridge 0000:02:00.0: setting
latency timer to 64

[  101.272313] ssb: Sonics Silicon Backplane found
on PCI device 0000:02:00.0


----------------

lspci | egrep BCM


02:00.0 Network controller: Broadcom Corporation
 BCM4328 802.11a/b/g/n (rev 03)


---------------------------

BTW I don't know if the b43 official Kernel Module ever worked

with my WIFI Controller. I'm using Ubuntu and as with kernel

2.28 I could enable the proprietary Broadcom Driver via

the "Restricted Drivers Manager". And that Driver doesn't seem

 to work now anymore.



The above command outputs are nevertheless produced using
Kernel 2.6.30 and the official b43 module.

Is my BCM-Chip supported by the official driver anyway? 



iwconfig can't find a wireless-supporting device either.

Only eth0, loopback and the (fw-controller?)

The proprietary driver lists eth1 in addition to that.


