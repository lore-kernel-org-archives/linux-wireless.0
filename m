Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56304 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3GXKh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 06:37:58 -0400
Received: from [192.168.2.100] ([93.218.114.45]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0M8laO-1UpnNg3G04-00C6hG for
 <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 12:37:57 +0200
Message-ID: <51EFAE83.7010902@rempel-privat.de> (sfid-20130724_123828_965408_9515E990)
Date: Wed, 24 Jul 2013 12:37:55 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: FUSB200 xhci issue
References: <51ED4E12.8030006@rempel-privat.de> <3155156.7uKpoiQrxp@blech> <51EE0DC2.3030200@rempel-privat.de> <2119509.Av8Iiax5KF@blech>
In-Reply-To: <2119509.Av8Iiax5KF@blech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.07.2013 20:26, schrieb Christian Lamparter:
> On Tuesday, July 23, 2013 06:59:46 AM Oleksij Rempel wrote:
>> Am 22.07.2013 23:23, schrieb Christian Lamparter:
>>> On Monday, July 22, 2013 10:47:41 PM Oleksij Rempel wrote:
>>>> Am 22.07.2013 21:54, schrieb Christian Lamparter:
>>>>> Hello!
>>>>>
>>>>> On Monday, July 22, 2013 05:21:54 PM Oleksij Rempel wrote:
>>>>>> i'm one of ath9k_htc devs. Currently i'm working on usb_suspend issue of
>>>>>> this adapters. Looks like ar9271 and ar7010 have FUSB200, and i
>>>>>> accidentally discovered that 9170 have it too. Are there any issue with
>>>>>> usb-suspend + xhci controllers by you? Did you some how specially
>>>>>> handled it?
>>>>>
>>>>> No, I haven't heard any complains about xhci + suspend. In fact,
>>>>> it's working fine with the NEC xhci I have. I also have a AR9271
>>>>> and AR7010, so if you want I could try if they survive a suspend
>>>>> +resume cycle when attached.
>>>>>
>>>>> But, I do have a bug-report from someone else who has/had? problems
>>>>> with carl9170 and xhci. If you want, you can get the details from:
>>>>> "carl9170 A-MPDU transmit problem":
>>>>> <http://comments.gmane.org/gmane.linux.kernel.wireless.general/104597>
>>>>>
>>>>> The likely cause is related to Intel's xhci silicon (Ivy Bridge is
>>>>> affected, but I don't know about Haswell):
>>>>> <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/104602>
>>>>
>>>> Same situation is here - i have problem on Ivy Bridge.
>>> (Note: I don't have any Ivy Bridge system. Just Sandy Bridge
>>> and AMD's new A6-1450 Temash and both xhci work. So I can't
>>> do any proper comparisons like you.)
>>>
>>>> Steps to reproduce:
>>>> - plug adapter. Module and firmware will be loaded
>>>> - make sure usb autosupend is enabled. By default it is not! Use
>>>> powertop or directly sysfs to enable autosuspend for this device
>>>> - rmmod .... and wait some seconds until adapter is suspended and then
>>>> modprobe ath9k_htc
>>
>>>> first packet which is bigger as 64Byte will kill EP4 FIFO. Size register
>>>> will report wrong size.. bigger as FIFO can handle. And only first ~40
>>>> readet bytes will be actually OK.. all the rest of packet will be trashed.
>>>
>>> This is what happens with a WN721 (ar9271):
>>>
>>> [17619.597905] usbcore: deregistering interface driver ath9k_htc
>>> [17619.679549] usb 2-2: ath9k_htc: USB layer deinitialized
>>> [17619.679602] ath9k_htc: Driver unloaded
>>> <suspend>
>>>
>>> <resume>
>>> [17667.543024] usb 2-2: reset high-speed USB device number 3 using xhci_hcd <----
>>> [17667.572168] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77600
>>> [17667.572174] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77640
>>> [17667.572177] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77680
>>> [17667.572180] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa776c0
>>> [17667.572183] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77700
>>> [17667.572185] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88031aa77740
>>> [17667.573826] usb 2-2: ath9k_htc: Firmware htc_9271.fw requested
>>> [17667.573873] usbcore: registered new interface driver ath9k_htc
>>> [17668.038200] usb 2-2: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>>> [17668.273249] ath9k_htc 2-2:1.0: ath9k_htc: HTC initialized with 33 credits
>>>
>>> The driver loads, but there's no "wlanX" interface, no phyX interface
>>> and the driver can't be unloaded due to "Error: Module ath9k_htc is in use".
>>
>> So, it is exactly this bug.
>> After firmware was loaded ath9k trying to set some registers. Since
>> command buffer is trashed it will write some nonsense to registers and
>> some times in wrong to wrong addresses. I have some patches to do crc
>> check of commands, to easy detect corrupted ones.
>>
>> You reproduced it on NEC xhci? Is it possible to reproduce it in
>> carl9170?
>
> Ok: That's dmesg of your scenario:
>
> [  809.995966] usbcore: deregistering interface driver carl9170
> <suspend>
>
> <resume>
> [  826.365596] usb 2-2: reset high-speed USB device number 2 using xhci_hcd
> [  826.431154] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b900
> [  826.431159] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b940
> [  826.431162] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b980
> [  826.431164] xhci_hcd 0000:19:00.0: xHCI xhci_drop_endpoint called with disabled ep ffff88045af2b9c0
> [  826.432257] usbcore: registered new interface driver carl9170
> [  826.433717] usb 2-2: driver   API: 1.9.8 2013-03-23 [1-1]
> ...
> [  826.816110] usb 2-2: Atheros AR9170 is registered as 'phy3'
>
> carl9170 is able to recover and the stick is working after autosuspend cycle.

Thank you for your tests. USB configuration and handlers look similar on 
this two firmwares. May be problem is not in FUSB200 and it is clock 
related issue so carl9170 do not need reset. - I don't know :(

Can you please test this branch:
https://github.com/olerem/open-ath9k-htc-firmware/commits/next
There is a workaround to reset adapter, right after this bug is 
detected. It is really dirty hack, but currently i do not know how to 
fix this bug on xhci or on ath9k-htc side.

-- 
Regards,
Oleksij
