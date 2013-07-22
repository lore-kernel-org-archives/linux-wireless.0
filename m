Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52344 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3GVUro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 16:47:44 -0400
Received: from [192.168.2.102] ([93.218.114.45]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MKbZD-1V0Y4P0it5-0022ul for
 <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 22:47:43 +0200
Message-ID: <51ED9A6D.4070900@rempel-privat.de> (sfid-20130722_224750_785667_CB9DAC7B)
Date: Mon, 22 Jul 2013 22:47:41 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: FUSB200 xhci issue
References: <51ED4E12.8030006@rempel-privat.de> <1559414.LIxku4Z5O8@blech>
In-Reply-To: <1559414.LIxku4Z5O8@blech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 22.07.2013 21:54, schrieb Christian Lamparter:
> Hello!
>
> On Monday, July 22, 2013 05:21:54 PM Oleksij Rempel wrote:
>> i'm one of ath9k_htc devs. Currently i'm working on usb_suspend issue of
>> this adapters. Looks like ar9271 and ar7010 have FUSB200, and i
>> accidentally discovered that 9170 have it too. Are there any issue with
>> usb-suspend + xhci controllers by you? Did you some how specially
>> handled it?
>
> No, I haven't heard any complains about xhci + suspend. In fact,
> it's working fine with the NEC xhci I have. I also have a AR9271
> and AR7010, so if you want I could try if they survive a suspend
> +resume cycle when attached.
>
> But, I do have a bug-report from someone else who has/had? problems
> with carl9170 and xhci. If you want, you can get the details from:
> "carl9170 A-MPDU transmit problem":
> <http://comments.gmane.org/gmane.linux.kernel.wireless.general/104597>
>
> The likely cause is related to Intel's xhci silicon (Ivy Bridge is
> affected, but I don't know about Haswell):
> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/104602>

Same situation is here - i have problem on Ivy Bridge.
Steps to reproduce:
- plug adapter. Module and firmware will be loaded
- make sure usb autosupend is enabled. By default it is not! Use 
powertop or directly sysfs to enable autosuspend for this device
- rmmod .... and wait some seconds until adapter is suspended and then 
modprobe ath9k_htc

first packet which is bigger as 64Byte will kill EP4 FIFO. Size register 
will report wrong size.. bigger as FIFO can handle. And only first ~40 
readet bytes will be actually OK.. all the rest of packet will be trashed.

But... i'm not 100% sure, if the FIFO as actually over filled, or host 
controller sending brocken data, or wrong timing...

There are flawing workarounds:
- reload xhci_hcd module.
- do USB_PHY reset, from firmware.
- use other host controller

It will be good if you can test it on you NEX xhci.

>
> However, I haven't heard back from Sarah or Seth about this matter
> (Added them to the CC. so "PLEASE" join if either of you think to
> have something to add about carl9170 transmit problem or ath9k_htc's
> suspend issue... of course, if it was fixed, then it would be really
> great to know which commit "fixed it"...)
>
> Regards
>
> Christian



-- 
Regards,
Oleksij
