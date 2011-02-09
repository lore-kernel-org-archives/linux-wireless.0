Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54228 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1BIC20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 21:28:26 -0500
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19793.64449.344588.240418@gargle.gargle.HOWL>
Date: Wed, 9 Feb 2011 07:58:17 +0530
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Sujith <m.sujith@gmail.com>,
	Martin Schleier <drahemmaps@gmx.net>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <Pine.LNX.4.44L0.1102081011030.2100-100000@iolanthe.rowland.org>
References: <20110208140329.16761adb54ekbcpw@hayate.sektori.org>
	<Pine.LNX.4.44L0.1102081011030.2100-100000@iolanthe.rowland.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern wrote:
> There are at least three problems that I can see.  First, the device 
> doesn't disconnect from and reconnect to the USB bus when it starts 
> using new firmware.

Yes, ath9k_htc has this problem.

> Second, the device loses its firmware when it is 
> reset.

Agreed again, this is a problem with ath9k_htc.

> The first two problems are the device's fault, and the third is the 
> driver's fault.  None of them are the fault of usbcore.

Indeed, which is why this dirty hack is done in the driver.
And it was done to fix a similar issue - high CPU usage when scanning.

But do you have any suggestion for such broken devices ?
The FW changes the type from Interrupt to Bulk, but can the host
driver continue to use Interrupt URBs and use the URB_NO_INTERRUPT trick
that you have mentioned ?

Sujith
