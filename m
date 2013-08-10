Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52229 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab3HJGTx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 02:19:53 -0400
Received: from [192.168.2.102] ([93.218.87.66]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0Lfolq-1Vx3Tp27uU-00pMNl for
 <linux-wireless@vger.kernel.org>; Sat, 10 Aug 2013 08:19:51 +0200
Message-ID: <5205DB86.2050905@rempel-privat.de> (sfid-20130810_081958_180431_B5F20FF1)
Date: Sat, 10 Aug 2013 08:19:50 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: Re: FUSB200 xhci issue
References: <Pine.LNX.4.44L0.1308091529080.1405-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091529080.1405-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.08.2013 21:32, schrieb Alan Stern:
> On Fri, 9 Aug 2013, Oleksij Rempel wrote:
>
>>> Is there any way to prevent the device from losing its firmware during
>>> a USB reset or suspend?
>>
>> For suspend - yes. It is possible to ignore suspend command or put the
>> SoC in low power mode - but is it probably not so easy to bring it back.
>> I would need to read more code and create some doc as side effect untill
>> i understand how it works.
>> I'm not sure how about reset command. I would need more testing and some
>> ones help. If i see it correctly, usb reset should affect only usb core
>> and usb pll.
>>
>> How can i trigger usb reset?
>
> http://marc.info/?l=linux-usb&m=121459435621262&w=2
>
> Give the program the pathname for the USB device node.  For example:
>
> 	usbreset /dev/bus/usb/001/004

Great! thx!

usb reset do not affect behaviour of firmware. At least after i remove 
all attempts to reboot FW from driver.
If adapter will got reset signal, FW will be notified about it. Then FW 
will remove reset flag and will just continue to work. After usb reset, 
lsusb show correct, update information - EP3 and EP4 was updated from 
INT to BULK.

I assume, no i need to add to the driver some kind of firmware check. 
What is the proper way to do it?

-- 
Regards,
Oleksij
