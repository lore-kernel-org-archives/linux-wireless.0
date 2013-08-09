Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49835 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030353Ab3HISyQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 14:54:16 -0400
Received: from [192.168.2.100] ([93.218.76.213]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MDV5t-1VLpve0hll-00GqJD for
 <linux-wireless@vger.kernel.org>; Fri, 09 Aug 2013 20:54:15 +0200
Message-ID: <52053AC4.3090509@rempel-privat.de> (sfid-20130809_205419_575788_15E1BE95)
Date: Fri, 09 Aug 2013 20:53:56 +0200
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
References: <Pine.LNX.4.44L0.1308091310560.1405-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308091310560.1405-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.08.2013 19:16, schrieb Alan Stern:
> On Fri, 9 Aug 2013, Oleksij Rempel wrote:
>
>> Am 09.08.2013 16:52, schrieb Alan Stern:
>>> On Fri, 9 Aug 2013, Oleksij Rempel wrote:
>>>
>>>>> What about a "get firmware version" sort of thing?  There really should
>>>>> be a way for the driver to tell whether the firmware has already been
>>>>> updated.
>>>>
>>>> I was not able to find good direct way to check firmware version. If i
>>>> would add some new command then i will get option like: if responding FW
>>>> is updated; if not, then dead or old.
>>>> How about overwriting iProduct field? Let say, if iProduct == ath9k_htc,
>>>> then firmware is updated? Is it more or less acceptable method? I need
>>>> to ask this because it is really new for me.
>>>
>>> Changing the iProduct string descriptor would work, because the
>>> descriptors_changed() routine doesn't compare the old value of that
>>> string with the new value.  (On the other hand, it does compare the
>>> iSerialNumber strings.)
>>
>> Just to make sure. You mean, i should avoid changing iSerialNumber
>> because host will initiate usb reset and this device will probably not
>> survive it?
>
> Right.  If the device would survive a reset then there would be no
> problem.
>
> BTW, it is common for new firmware to change the bcdDevice value in the
> device descriptor.  That might be easier than changing a string
> descriptor.
>
>>> Is there any way to read the firmware back from the device?  Then you
>>> could check directly.
>>
>> No, this device is a SoC with usb client interface based on FUSB200 core
>> (If i'm correct, same core as on carl9170 devices). We can't read memory
>> unless FW provide this service.
>> At power on, this device will boot from external or internal ROM and
>> load minimal FW. Without it, USB wont work.
>> If i read FW code correctly, it should be responsible for suspend and reset.
>
> How do you tell the device to start running the new firmware after it
> is loaded?  Normally this requires some sort of reset.

There are two vendor commands cUSB_REQ_DOWNLOAD and 
cUSB_REQ_DOWNLOAD_COMP. With cUSB_REQ_DOWNLOAD firmware will be uploaded 
and cUSB_REQ_DOWNLOAD_COMP should just jump to first address of the 
firmware.

This system has micro modular structure. Firmware can register own 
modules. Or relink modules of bootloader, but this is limited only to 
existing api.

> Is there any way to prevent the device from losing its firmware during
> a USB reset or suspend?

For suspend - yes. It is possible to ignore suspend command or put the 
SoC in low power mode - but is it probably not so easy to bring it back. 
I would need to read more code and create some doc as side effect untill 
i understand how it works.
I'm not sure how about reset command. I would need more testing and some 
ones help. If i see it correctly, usb reset should affect only usb core 
and usb pll.

How can i trigger usb reset?

-- 
Regards,
Oleksij
