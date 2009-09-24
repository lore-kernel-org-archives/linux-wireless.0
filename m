Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35341 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751594AbZIXVeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 17:34:18 -0400
Message-ID: <4ABBE5DB.5070201@gmx.de>
Date: Thu, 24 Sep 2009 23:34:19 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Malte Gell <malte.gell@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170 makes machine hang when shut down
References: <200909242155.19485.malte.gell@gmx.de>
In-Reply-To: <200909242155.19485.malte.gell@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2009 09:55 PM, Malte Gell wrote:

> I use the compat 2.6.30 and the ar9170 driver for my Netgear WN111 USB stick. 
> I use the packages from
> http://download.opensuse.org/repositories/driver:/wireless/11.1-update/i586/
> for openSUSE 11.1.
> 
> When I shutdown my machine, it hangs after the last messages "system now 
> rebooting" or similar.
> 
> Does it make sense to use "rmmod --force ar9170" to force removing that module 
> before shutting down?

Why are you sure that the hang is caused by the ar9170 driver? 

The vendor driver is called arusb_lnx, the new one ar9170usb

If you only use the packages from the above URL and haven't compile compat-wireless yourself,
chances are that you use the vendor driver. You may check the loaded module list:
	lsmod
and try to remove the module:
	rmmod arusb_lnx
before shutting down.
If this fails, try to close the corresponding netdev first:
	 ifconfig X down
with X = ath0 or wlan0 (see the output of "iwconfig").

Needing "--force" for rmmod is IMHO a bug in the driver.

Regards,
Jörg.

