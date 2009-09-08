Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51091 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZIHSNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:13:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Daiker <daikerjohn@gmail.com>
Subject: Re: b43 dma error
Date: Tue, 8 Sep 2009 20:13:39 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	netrolller.3d@gmail.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <20090908134732.GA1936@darkstar> <4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com>
In-Reply-To: <4AA69961.9010808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909082013.41929.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 September 2009 19:50:25 John Daiker wrote:
> On 09/08/2009 07:54 AM, Larry Finger wrote:
> > Michael Buesch wrote:
> >> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
> >>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
> >>> then the controller keep restarting...
> >>>
> >>> Please tell what I can provide or test, Thanks.
> >>
> >> Is this a regression? If so, please bisect.
> >
> > It is something specific to his system as I don't see anything like
> > this. In addition, there are some users on the openSUSE forums that
> > have implemented the latest compat-wireless and switched away from
> > Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
> > them.
> >
> > Please reboot so that we see the ssb output as well. Use the command
> >
> > dmesg | egrep "ssb|b43"
> >
> > That way we will be able to see exactly what kind of device you have
> > and what revisions are in it. AFAIK, the testing to date has been
> > limited to Rev 1 PHYs and Rev 2 radios.
> >
> > Larry
> >
> 
> I can confirm the same issue.  I have a HP Mini 1116NR with a Broadcom 4312.  Looks to be a PHY 1, Radio 2:
> 
> --snip--
> [  456.165296] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
> [  456.165364] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
> --snip--
> 
> I've attached the output of 'dmesg | egrep "ssb|b43"', my kernel config, and lspci -vv and lspci -nn
> 
> Note: With the dmesg output, I had unloaded the b43 module previous 'modprobe -r b43' and then loaded it again with debug output: 'modprobe b43 verbose=3'
> 
> John Daiker
> 

To ask the question once again: Is this a regression?
This is a critical question to track down the bug.

-- 
Greetings, Michael.
