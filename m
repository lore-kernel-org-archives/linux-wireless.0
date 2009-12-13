Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:52763 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753492AbZLMPpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 10:45:11 -0500
Message-ID: <4B250C01.4050400@free.fr>
Date: Sun, 13 Dec 2009 16:45:05 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, stable@kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 2.6.33] rt2x00: Disable powersaving for
 rt61pci.
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>	<200912131115.33485.IvDoorn@gmail.com> <4B250567.8050809@gmail.com>	<200912131618.49312.IvDoorn@gmail.com> <4B25068E.7000201@gmail.com>
In-Reply-To: <4B25068E.7000201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde a écrit :
> On 12/13/09 16:18, Ivo van Doorn wrote:
>> On Sunday 13 December 2009, Gertjan van Wingerde wrote:
>>> On 12/13/09 11:15, Ivo van Doorn wrote:
>>>> On Sunday 13 December 2009, Gertjan van Wingerde wrote:
>>>>> We've had many reports of rt61pci failures with powersaving enabled.
>>>>> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
>>>>> until we have found a proper solution.
>>>> This disables powersaving completely, can't we set the default powersaving
>>>> to disabled? That way for people for who it does work, it can still be enabled.
>>>>
>>> Well, when I was looking into this I came up with a number of issues in the code
>>> which makes me believe that it simply isn't working at all.
>>> One example is that the rt61pci devices rely on handling the wakeup interrupt
>>> by the driver to wake up the devices. As far as I can tell there is no handling
>>> of the wakeup interrupt in the rt61pci driver.
>>> That's why I decided to disable it all together, as I don't think it works
>>> properly for anyone (although some people may not really notice it).
>> Ok, but then please disable it for _all_ rt2x00 drivers, or at least all PCI rt2x00 drivers
>> since they would have the same wakeup interrupt requirement.
>>
> 
> I'll see if this will be the case for all PCI rt2x00 devices and adapt for the ones that
> need it. I didn't look into the other devices yet, and ISTR that at least rt2500pci doesn't
> have this requirement.
> 
> ---
> Gertjan.

If the same mecanism is used by rt2800usb, that would explain why power save is
not working as well on my rt2870 USB device. Is there a way to start the device
with power save disabled at startup (so it can be reenabled later to debug it).

Regards,
Benoit
