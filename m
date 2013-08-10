Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:51773 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757879Ab3HJL5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 07:57:14 -0400
Date: Sat, 10 Aug 2013 07:57:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Oleksij Rempel <linux@rempel-privat.de>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
In-Reply-To: <5205DB86.2050905@rempel-privat.de>
Message-ID: <Pine.LNX.4.44L0.1308100755250.31571-100000@netrider.rowland.org> (sfid-20130810_135718_579082_BFED64C7)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Aug 2013, Oleksij Rempel wrote:

> usb reset do not affect behaviour of firmware. At least after i remove 
> all attempts to reboot FW from driver.
> If adapter will got reset signal, FW will be notified about it. Then FW 
> will remove reset flag and will just continue to work. After usb reset, 
> lsusb show correct, update information - EP3 and EP4 was updated from 
> INT to BULK.
> 
> I assume, no i need to add to the driver some kind of firmware check. 
> What is the proper way to do it?

The simplest way is to put a new value for the device descriptor's 
bcdDevice value in the firmware.  Then all you have to do is check that 
value.

Alan Stern

