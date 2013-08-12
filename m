Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55885 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3HLH7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 03:59:10 -0400
Received: from [192.168.2.100] ([79.218.111.223]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0LuKHz-1WAGxH0NV9-011gcV for
 <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 09:59:08 +0200
Message-ID: <520895BC.1070405@rempel-privat.de> (sfid-20130812_095917_547725_8839CAD4)
Date: Mon, 12 Aug 2013 09:58:52 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	Sujith Manoharan <sujith@msujith.org>
Subject: Re: FUSB200 xhci issue
References: <Pine.LNX.4.44L0.1308100755250.31571-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308100755250.31571-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 10.08.2013 13:57, schrieb Alan Stern:
> On Sat, 10 Aug 2013, Oleksij Rempel wrote:
>
>> usb reset do not affect behaviour of firmware. At least after i remove
>> all attempts to reboot FW from driver.
>> If adapter will got reset signal, FW will be notified about it. Then FW
>> will remove reset flag and will just continue to work. After usb reset,
>> lsusb show correct, update information - EP3 and EP4 was updated from
>> INT to BULK.
>>
>> I assume, no i need to add to the driver some kind of firmware check.
>> What is the proper way to do it?
>
> The simplest way is to put a new value for the device descriptor's
> bcdDevice value in the firmware.  Then all you have to do is check that
> value.

Since adding fw check will need fw version update. I would like to do 
quick fix for current kernel and firmware version.
I will revert EP3 and EP4 from bulk back to interrupt. But, before 
sending patch to the list i would like to know, how to reproduce the bug 
which was fixed by converting this endpoints from interrupt to bulk.

-- 
Regards,
Oleksij

-- 
Regards,
Oleksij
