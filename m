Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56256 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753498Ab3HITco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 15:32:44 -0400
Date: Fri, 9 Aug 2013 15:32:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oleksij Rempel <linux@rempel-privat.de>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <52053AC4.3090509@rempel-privat.de>
Message-ID: <Pine.LNX.4.44L0.1308091529080.1405-100000@iolanthe.rowland.org> (sfid-20130809_213248_163913_854F8761)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Aug 2013, Oleksij Rempel wrote:

> > Is there any way to prevent the device from losing its firmware during
> > a USB reset or suspend?
> 
> For suspend - yes. It is possible to ignore suspend command or put the 
> SoC in low power mode - but is it probably not so easy to bring it back. 
> I would need to read more code and create some doc as side effect untill 
> i understand how it works.
> I'm not sure how about reset command. I would need more testing and some 
> ones help. If i see it correctly, usb reset should affect only usb core 
> and usb pll.
> 
> How can i trigger usb reset?

http://marc.info/?l=linux-usb&m=121459435621262&w=2

Give the program the pathname for the USB device node.  For example:

	usbreset /dev/bus/usb/001/004

Alan Stern

